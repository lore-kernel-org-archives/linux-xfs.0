Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 449A955C307;
	Tue, 22 Sep 2026 13:28:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790083681; cv=none; b=Twip6me8gqEGvOFQLjAZUr5NzKDIXASSGNF8DKPXKFMz58GAVwNT179AOswGngVv2LKos3XhFzeTd02ZM+B3vibSP89WaffH6GIXuyTPjSaKpjw+1fa5LMrZt7XR3Edh4yl7865Ux6CTh53fe7fESJAuPWa6hzQf/mpLj8XNVlc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790083681; c=relaxed/simple;
	bh=hGeVzV1YxHXH/YgZr5KqyzMj/gRCc3ycdX41tV/4H4s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Q2fbLtu2HZwwe/IbohrlPAmfexPWqHHkEIuOBKCl3I5LxS/kFyhYQZSpOLopZk5N47kdFZffaRH9dK2VykhPNfhOcRphfb2aNYj7wzupZRjF2JQLPSw8FJ+87tNdr1BK6uUdXe9cqkHfiiY73GuWzxBF+aRm9W1Lm1peWdyvDe4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ioqsi3Zx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ioqsi3Zx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A33081F00893;
	Tue, 22 Sep 2026 13:27:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790083679;
	bh=6PGj+hd//EF8JcQmcnCRDBkLakUJwfZRFfDprUZGMAk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ioqsi3ZxN9+a/YXEvieSjbpT8UHcfOoBGM9mV7YUu4Yngh5XSlFRbochz4k9LuSU6
	 KuuM0jcH0zX5qOM08Ci6BMAyBsh/nffUzf0u+mjzpfJ177dsB40GH4QPFgQeifeRAw
	 0wo/c9tnRIY/PLap26paJls5/ZA5dXLhtAniZtX5+BPgCqtoTFm/DnOYcaZ3QSD7/X
	 7AiqT7Oti/bB7AV1hhm5tT8dBdSGvgTP5ohj0lxjHRFMVlBLywo62ETGv/04MalR4G
	 ptZiGbBlHK3sXSfknpaUlXNMGkTLAHwz88EF/N10v6pnWguVSXRjh5q/DOf+DbSkGl
	 EN2JJKrO04y1g==
Date: Tue, 22 Sep 2026 15:27:54 +0200
From: Andrey Albershteyn <aalbersh@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Andrey Albershteyn <aalbersh@redhat.com>, djwong@kernel.org, 
	ebiggers@kernel.org, hch@lst.de, Carlos Maiolino <cem@kernel.org>, 
	fsverity@lists.linux.dev, linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org, 
	linux-unionfs@vger.kernel.org, linux-ext4@vger.kernel.org, 
	linux-f2fs-devel@lists.sourceforge.net, linux-btrfs@vger.kernel.org, david@fromorbit.com
Subject: Re: [PATCH v16 15/21] xfs: add fs-verity support
Message-ID: <arKAqsuSoxvM1yKt@aalbersh-thinkpadx1carbongen13.rmtcz.csb>
References: <20260918111539.1003439-1-aalbersh@kernel.org>
 <20260918111539.1003439-16-aalbersh@kernel.org>
 <arIszDCcy0VbRVFp@infradead.org>
 <arI-5Ejg0Xw7OVmH@aalbersh-thinkpadx1carbongen13.rmtcz.csb>
 <arJ1dfejt4DyCsvG@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <arJ1dfejt4DyCsvG@infradead.org>

On 2026-09-22 05:32:53, Christoph Hellwig wrote:
> On Tue, Sep 22, 2026 at 10:56:09AM +0200, Andrey Albershteyn wrote:
> > On 2026-09-22 00:22:52, Christoph Hellwig wrote:
> > > On Fri, Sep 18, 2026 at 01:15:27PM +0200, Andrey Albershteyn wrote:
> > > > +	xfs_ilock(ip, XFS_ILOCK_EXCL);
> > > > +	xfs_trans_ijoin(tp, ip, 0);
> > > > +
> > > > +	truncate_inode_pages(VFS_I(ip)->i_mapping, XFS_ISIZE(ip));
> > > 
> > > We can't call truncate_inode_pages with the ilock held.
> > > 
> > > I also don't see what this is trying to protect to start with.
> > > 
> > 
> > I added this to remove stale pages created post-EOF, so, writeback
> > doesn't try to flush them latter (but now I see that writeback will
> > fail to map them to extents anyway). Also, if EOF gets extended
> > these pages would be exposed as they are up-to-date which would be
> > unexpected garbage.
> 
> Yeah, but what is the ilock trying to protect against?  ilock is
> the innermost sleeping lock and protects modifications to the
> inode fields and the extent mapping.   Higher level synchronization
> is done using the iolock and the mmaplock (which is already taken
> here).
> 

hmm maybe I don't understand what you addressing here but don't I
need ilock for xfs_itruncate_extents() used with this transaction.
So, doing extent removal.

With this function I want to remove post EOF pages from pagecache
and then remove post EOF extents on that inode.

iolock is already hold, mmaplock is for pagecache truncation and
ilock for extents removal.

-- 
- Andrey
