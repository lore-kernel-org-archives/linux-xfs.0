Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73D8B5372D4;
	Tue, 22 Sep 2026 12:32:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790080382; cv=none; b=ndX41j8lLdcWad/4Hz+Kr/Kh/88KhJiOX3qOIYEPsiQXwxVbd+ftCkHYQ9GlCdBoT+WS4W7BTPF4Qkx02mN81d1Vjok5sDSN/tBdtM7KKF44q3aGQp2BewB/3/a8SundYdNWrpLOecPlsnIio4tyY49zD8JjZIEt5ymPTdVM4BY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790080382; c=relaxed/simple;
	bh=pGsSuFpAg/3dTfkTCBEQyOAgnme3ZlTsAB2LBY26MpE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ThxrfM54V9/vo2gVugZlxFoGBeXz05mj3lRQmjnyGdF0OumjgAkMWptBph1lPANlBYcz6YAfUIoyfGsrtqI1z2xJPKKdxP9MBbkI2R/WZreJLM2boeihiN0e0psYx+xgraZvZvQyUQH3jLLgpg6d2sjUvdcf/meCBQtdrcOvqQw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=JlR7Kgn6; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="JlR7Kgn6"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=DoWMKpoGiRtUtawRlMT8UC8Ou0pBxNI+3BTSenoifKk=; b=JlR7Kgn6Of7lIT5bj8t6yeRSIk
	ND1YN8FXctmH9e6xtJ+SWMF5boxLVQ3keTJNTnZdf+RIPtkp7HFem0/m73M18sFPaj4/IqH7ekL4T
	ifmPM09xiVhzHV7SiAjELUSWjC800HTLA7Jrnz5+cXE1jYeOmKIAf7KpiE33eYrZqdjGYkTt3mRyp
	7B5xtRCIlnQvgn4FAeo6MFxSr7BMukZBI6zsj+GvBis/72wfZTCBDtYWCzWx7aKWlNjiI3lNWVyVi
	fz+ZwmfUaMlUktkDRz5rGp90Uy0xr5uvVZjDszvJM1pITtocjKRbh1hbWbRP4v3dDjzjMFTpVLkJn
	sNGXOqzQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x8zg5-00000005Jd2-2Ixo;
	Tue, 22 Sep 2026 12:32:53 +0000
Date: Tue, 22 Sep 2026 05:32:53 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Andrey Albershteyn <aalbersh@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>,
	Andrey Albershteyn <aalbersh@kernel.org>, djwong@kernel.org,
	ebiggers@kernel.org, hch@lst.de, Carlos Maiolino <cem@kernel.org>,
	fsverity@lists.linux.dev, linux-fsdevel@vger.kernel.org,
	linux-xfs@vger.kernel.org, linux-unionfs@vger.kernel.org,
	linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
	linux-btrfs@vger.kernel.org, david@fromorbit.com
Subject: Re: [PATCH v16 15/21] xfs: add fs-verity support
Message-ID: <arJ1dfejt4DyCsvG@infradead.org>
References: <20260918111539.1003439-1-aalbersh@kernel.org>
 <20260918111539.1003439-16-aalbersh@kernel.org>
 <arIszDCcy0VbRVFp@infradead.org>
 <arI-5Ejg0Xw7OVmH@aalbersh-thinkpadx1carbongen13.rmtcz.csb>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <arI-5Ejg0Xw7OVmH@aalbersh-thinkpadx1carbongen13.rmtcz.csb>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Sep 22, 2026 at 10:56:09AM +0200, Andrey Albershteyn wrote:
> On 2026-09-22 00:22:52, Christoph Hellwig wrote:
> > On Fri, Sep 18, 2026 at 01:15:27PM +0200, Andrey Albershteyn wrote:
> > > +	xfs_ilock(ip, XFS_ILOCK_EXCL);
> > > +	xfs_trans_ijoin(tp, ip, 0);
> > > +
> > > +	truncate_inode_pages(VFS_I(ip)->i_mapping, XFS_ISIZE(ip));
> > 
> > We can't call truncate_inode_pages with the ilock held.
> > 
> > I also don't see what this is trying to protect to start with.
> > 
> 
> I added this to remove stale pages created post-EOF, so, writeback
> doesn't try to flush them latter (but now I see that writeback will
> fail to map them to extents anyway). Also, if EOF gets extended
> these pages would be exposed as they are up-to-date which would be
> unexpected garbage.

Yeah, but what is the ilock trying to protect against?  ilock is
the innermost sleeping lock and protects modifications to the
inode fields and the extent mapping.   Higher level synchronization
is done using the iolock and the mmaplock (which is already taken
here).

