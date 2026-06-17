Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BDC53B19D2;
	Wed, 17 Jun 2026 06:25:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781677530; cv=none; b=Ffj48H1yEiyqC55MYEgOEPFyLGMvmWxknTXkopnzPBVXkCvwZDTuPqyU72ZD9rDJtTosX1qS7493a6hPUTfxeVxpg1CNwJgWjxwTaP4kSEfBx0ByOLJPoCExDtaxcJxdw5HPDU2Fk7JmHiRO0ixZb64ZV4vm3x0qVE9cSTkTkL0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781677530; c=relaxed/simple;
	bh=Quz/nKGmXdkzP2kCEXj1l0t4dVl9EoMg1ILY8AM0Qls=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nrOkXsL/k6AVT8Z185XKMdZcsm/Z58lHpG83J49tqlD/UXm06mIj2PK1GpesFlsHUtM1OcTpXvnZYp0N+8/9pKnQR8qvOBjn2B+TZRIY0TiFGxY7FenPI11v1Oo7LE6yW8wMbfEDfxAzDfbU2ixgTCPNLs7Zj5fTpoWL+yj+XF4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 1092068AFE; Wed, 17 Jun 2026 08:25:24 +0200 (CEST)
Date: Wed, 17 Jun 2026 08:25:23 +0200
From: Christoph Hellwig <hch@lst.de>
To: Christian Brauner <brauner@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Jan Kara <jack@suse.cz>,
	Jens Axboe <axboe@kernel.dk>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, Carlos Maiolino <cem@kernel.org>,
	linux-xfs@vger.kernel.org, Chris Mason <clm@fb.com>,
	David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org,
	Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org,
	Gao Xiang <xiang@kernel.org>, linux-erofs@lists.ozlabs.org
Subject: Re: [PATCH RFC 2/8] fs: add a global device to super block hash
 table
Message-ID: <20260617062523.GA20041@lst.de>
References: <20260602-work-super-bdev_holder_global-v1-0-bb0fd82f3861@kernel.org> <20260602-work-super-bdev_holder_global-v1-2-bb0fd82f3861@kernel.org> <20260616123443.GA21024@lst.de> <20260616-fragil-duktus-nachverfolgen-60f54584c206@brauner>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260616-fragil-duktus-nachverfolgen-60f54584c206@brauner>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Jun 16, 2026 at 04:59:53PM +0200, Christian Brauner wrote:
> > Err, no.  block devices need to have a specific owner.  If erofs wants
> > to share a device between superblock it needs to come up with an entity
> > that owns the block devices which is not a superblock.
> 
> It already did.
> 
> > IMHO sharing devices between superblocks is a bad idea, but that ship
> > has sailed, but please keep it contained inside of erofs.
> 
> We need a simple device number to superblock mapping anyway and that can
> simply be centralized in the vfs. And it can work with anon device
> numbers and block device numbers uniformly.

No, we don't need a secondary device number to sb mapping.  On the other
hand we do need the deviceloss, freeze etc upcalls to work for owners
that are not file systems like mdraid or dm, even if they have been
slow to pick this.  The whole idea of the holder ops is to abstract
away from who holds it instead of adding back the broken hard coding
of the superblock.  Otherwise you're just badly reinventing get_super.

If erofs already has an owner entity it just needs custom holder ops for
that.
