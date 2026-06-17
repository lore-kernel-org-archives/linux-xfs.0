Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 688E83947AE;
	Wed, 17 Jun 2026 09:26:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781688406; cv=none; b=hYUITEMUBmyWgpdbKVi6J7t2wbhQGUp+IF1AOn/flelYKsP/YrZhTK8Rw6cuSARKXk11G0ZRS7arygZpwUqZ32XZ9VU5ufCYOl2aCiI9hJyGDjjMo0NQSHG0PpgT2q3o5mr8aZMj7SWrkTPmuUEmrgxxLUSONyKrOgBgBjy0mFw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781688406; c=relaxed/simple;
	bh=fyk25gi1eDVCMWHnsx04c+rIIl6ODSKkju5Brthoxjc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Fhwg0LO3rgtMp0hF2J7spLtRZ1hK8p6+ydTfDcJ3FHBysj6vUyl+HTu4xhCwajEmWg5ebDDiF040XnOM21h/EvVRQMWhXwHfLa2IqY6oBeGXYCA9ImpPWDa238os/ZLJmiyoZ9IzZfB104nvvZCs0zQSNoOK/Cug/ozj+Fdx37Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cZT3Af0T; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cZT3Af0T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F2F11F000E9;
	Wed, 17 Jun 2026 09:26:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781688405;
	bh=hOhaP1OaoR+UZZSCRy5KHBEq3gQvQZdhNLr67J2uV+0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=cZT3Af0T0IWUuc1r9zI/xA0uAIXw2Y2OWW3rXg0r1QNqlwNYVnaxcq5CFm933d6vy
	 Kw2wr4iY9P+w7mar3VjaC73o/zB/yktfehj3+sX+2+pH7MwZ+1HYP1msnBdafBWbgz
	 WFgAnKA8mih+A7/RYse4sBWDk/ae34tXmA5k03hDRITxIMtzG2AvieF33hAKzYqBTd
	 ReNE7qTkwhpvwxdL6+ncAFA2XM5tPj/UP/tBGDGLIx1T3tXD1ByzQQedQnZSRXpGfv
	 k6mDTiSBPJJmVTBRl9ttrTgvVk2AWyJnzFwp4Armi3Ga3IeOR9IWZeKMmaodqvjCyU
	 lhJLdjD0o1CgA==
Date: Wed, 17 Jun 2026 11:26:39 +0200
From: Christian Brauner <brauner@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Jan Kara <jack@suse.cz>, Jens Axboe <axboe@kernel.dk>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org, 
	Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org, 
	Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org, Gao Xiang <xiang@kernel.org>, 
	linux-erofs@lists.ozlabs.org
Subject: Re: [PATCH RFC 2/8] fs: add a global device to super block hash table
Message-ID: <20260617-hoffen-eschenholz-abmarsch-fc69ce9e1640@brauner>
References: <20260602-work-super-bdev_holder_global-v1-0-bb0fd82f3861@kernel.org>
 <20260602-work-super-bdev_holder_global-v1-2-bb0fd82f3861@kernel.org>
 <20260616123443.GA21024@lst.de>
 <20260616-fragil-duktus-nachverfolgen-60f54584c206@brauner>
 <20260617062523.GA20041@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260617062523.GA20041@lst.de>

> No, we don't need a secondary device number to sb mapping.  On the other
> hand we do need the deviceloss, freeze etc upcalls to work for owners
> that are not file systems like mdraid or dm, even if they have been
> slow to pick this.  The whole idea of the holder ops is to abstract
> away from who holds it instead of adding back the broken hard coding
> of the superblock.  Otherwise you're just badly reinventing get_super.

No, the expanded version works for all device numbers. There's also
no-hardcoding. And non-fs users may do whatever they want with their
holder ops ofc. erofs always had the non 1:1 relationship between
devices and filesystems and for that case it seems sane. I'm happy to
let the series sit for a bit to gather input and do the security
mediation patches first. The series are complementary.
