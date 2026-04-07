Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47FBE3314D0;
	Tue,  7 Apr 2026 05:22:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775539338; cv=none; b=BxJ6EnbtvJa3dsX8gjGWI2K7L6lWCJ2+ceb/BdKUTYILF591YfC/DgSU4ciceCvK/ZaPS0qNmTYILoYVUAyyrmy7j5BCS1z/52nhvJkIRemGkK8q2rwF1JYfKnTJZD2FuY9SzjMD1WSmkglQWQiBBOTjq4LHq+kuPK2O7QJOst0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775539338; c=relaxed/simple;
	bh=wWelZyIKNqYzhsz42ROzMJtwaT4UqNEfxVRfSUhyelA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qTVI8xg7ZBfuNwXe26CCJaP863Nj3GulMuVFCbltHHPb/JvRJRfiBWjdA88SQ5dWPVdyJ1nIFoEM8omjHAY6abYEkc3q6BdXkNy2DSUAG4jgGHmGHXSwyaQH4gyF1Tfj45Sciz1Bmg6MpDHgdrZs+cq0h0dkntjo5/rC09dtdjI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=jNGZIpn3; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="jNGZIpn3"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=LNwJPq2PzoXENMaFsFevQJSHbENECqvI5gUJFL8NwIw=; b=jNGZIpn3NBs9neRTPgIjC91Kmg
	/67JNs7o9hoteY1YyH5uthK2/KWCjvUr8obZXiWpUKXkOY1/0JmPxXZi3o6Ys6SbFjZI7cPATNPCP
	aErP3w2aa3/3wrSOyoL1zWfYDHAlzbr6rqFK/+6fRT7NAG573S8E+Y9LaGUqTfAfajhKTtSUJjqub
	4DOpGDjcQRKuAelFq2+2HDkmjRqThP4Bvhpvpn74AJca5hcYnO6P0IzkLUXv1pB1JZKSI0TVDpRCu
	vthrnJn7DHULPouq2oUnT59Mw12ygtQOuM2mQPVm12cGLYE+olU90rRlNJGp+Me98uBNINLg3qUZ/
	+3a6kCDQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w9ytE-00000005uM2-2NTQ;
	Tue, 07 Apr 2026 05:22:16 +0000
Date: Mon, 6 Apr 2026 22:22:16 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Anand Jain <anajain.sg@gmail.com>
Cc: Theodore Tso <tytso@mit.edu>, Christoph Hellwig <hch@infradead.org>,
	"Darrick J. Wong" <djwong@kernel.org>, linux-ext4@vger.kernel.org,
	linux-btrfs@vger.kernel.org, linux-xfs@vger.kernel.org,
	Anand Jain <asj@kernel.org>
Subject: Re: [PATCH v2 3/3] ext4: derive f_fsid from block device to avoid
 collisions
Message-ID: <adSUiB9L0sFAd04U@infradead.org>
References: <cover.1774092915.git.asj@kernel.org>
 <33e8eb64c304a4d42b60f608c26497bf9a2e9e19.1774092915.git.asj@kernel.org>
 <20260323041624.GA11453@mac.lan>
 <d4a9970b-e7ed-4e74-be9d-2d08400f9d79@gmail.com>
 <5bda3d00-df35-4ea1-b313-2fef6e5c5682@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5bda3d00-df35-4ea1-b313-2fef6e5c5682@gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Sat, Apr 04, 2026 at 04:59:08PM +0800, Anand Jain wrote:
> Context:
> Currently, ext4's f_fsid is consistent across reboots but fails to be
> unique when dealing with cloned filesystems (sharing the same UUID). Per
> statfs(2) [1], the primary requirement is that the (f_fsid, ino) pair
> uniquely identifies a file. The man page makes no explicit guarantee
> regarding consistency across mount cycles or reboots.
> 
> Proposal:
> With this fix, f_fsid becomes f(uuid, dev_t). This ensures OS-wide
> uniqueness and maintains consistency as long as the underlying dev_t
> remains stable.
> 
> Dilemma:
> While statfs(2) [1] suggests f_fsid is "some random stuff," we know
> userspace (NFS, systemd) often treats it as a persistent handle.
> 
> Do you prefer one of the names above, or is there a more idiomatic ext4
> naming convention I should follow?
> 
> Given the ambiguity in the man page, is gating this behind an -o option
> necessary, or should we consider making uniqueness the default behavior?
> 

My take is that anything that should persist should be an on-disk
feature flag, not a mount option.  But I'm not in charge for ext4.

