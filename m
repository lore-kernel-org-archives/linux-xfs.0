Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D163C363C73;
	Tue, 16 Jun 2026 14:59:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781621999; cv=none; b=GDAxHn/4HsBO351YJbsgxeNWiZESuZxRM6X57d0jkxcukmIyDysHVnkBB+KvGoX3NdBYXhpIyFR0jGs2M+Xr6SuWxfSbj1SKvTHabfRr2XOh3QhMboCzSZXfOtPc6NrLn0wr9SsChKPnBntxfjRtVXuvY+1Tu6IFiSXBj8GwAC8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781621999; c=relaxed/simple;
	bh=cVOQmGZhaywNgUpe1waAeohcJcxkKV6VYrn8lHFxGHs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=s+MftEAROCRCafggdA/BaEiK9s90IPe9FUGsZD1x61r6XxuQ8tTQCJ33eOOg1vBgGenhQ3yafjPpPBFxtsJN26x+D5TWdHd3n3DxCl0w1O4X4c4V29Hm7ZYD8A/Vtky3GUL/ehWpMcE9NlJqN2SdwPGwC2nD2lLVOfeRx821e8Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jA2q0c4E; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jA2q0c4E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D5AC1F000E9;
	Tue, 16 Jun 2026 14:59:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781621998;
	bh=54nrZd56QlDOLjrnGUMxikC0RJz3adz3i0y4la/F30Q=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=jA2q0c4Ee6LVq3wsrXzEp9N7Su9CbMmoI6RP4rBSzy7r8wEReuDOvyko1gR0PEBZq
	 bg9x1Q83U6bfJVi8MI1KRXQHZSlLKfTldHay7P4JnrGnDygtoE8Uyr1SZXXq6iopy+
	 1uiksflRJgCiH46ewjX97OHYoJUczZNbraNTb5w472Yzug6sY9EulbLUSfhDKPqy2P
	 fXQQ0U37sAQtSAUQVyf1H6jtse9vqf7bUdWGz5uvC+yB+YxD4JAWUp9yh5ga+TP8bC
	 P3YC8LvGv2tE0gC7aIeruXedVTLx5LPurEO7KW1M1oaYJSRkYmGAKiLdMI2ZflI/gv
	 Ek4hr9EandhYQ==
Date: Tue, 16 Jun 2026 16:59:53 +0200
From: Christian Brauner <brauner@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Jan Kara <jack@suse.cz>, Jens Axboe <axboe@kernel.dk>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org, 
	Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org, 
	Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org, Gao Xiang <xiang@kernel.org>, 
	linux-erofs@lists.ozlabs.org
Subject: Re: [PATCH RFC 2/8] fs: add a global device to super block hash table
Message-ID: <20260616-fragil-duktus-nachverfolgen-60f54584c206@brauner>
References: <20260602-work-super-bdev_holder_global-v1-0-bb0fd82f3861@kernel.org>
 <20260602-work-super-bdev_holder_global-v1-2-bb0fd82f3861@kernel.org>
 <20260616123443.GA21024@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260616123443.GA21024@lst.de>

On Tue, Jun 16, 2026 at 02:34:43PM +0200, Christoph Hellwig wrote:
> On Tue, Jun 02, 2026 at 12:10:08PM +0200, Christian Brauner wrote:
> > fs_holder_ops recovers the owning superblock from bdev->bd_holder, which
> > forces the holder to be exactly one superblock and prevents several
> > superblocks from sharing one block device. That's what erofs is doing.
> > 
> > Introduce a global dev_t-keyed rhltable mapping each block device to the
> > superblock(s) using it. The holder argument becomes purely the block
> > layer's exclusivity token (a superblock, or a file_system_type for
> > shared devices) and is no longer needed by the fs specific callbacks.
> 
> Err, no.  block devices need to have a specific owner.  If erofs wants
> to share a device between superblock it needs to come up with an entity
> that owns the block devices which is not a superblock.

It already did.

> IMHO sharing devices between superblocks is a bad idea, but that ship
> has sailed, but please keep it contained inside of erofs.

We need a simple device number to superblock mapping anyway and that can
simply be centralized in the vfs. And it can work with anon device
numbers and block device numbers uniformly.
