Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0331546B8
	for <linux-xfs@vger.kernel.org>; Tue, 15 Oct 2024 05:09:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728968984; cv=none; b=S+rTELtlrENPeTgXoQQKf+6Uzd3VQDJSnuD5P6LaHW4KIm4pkzPY75mozKfMeZsIdw4Q8JI2l1w+qVljwc9smoY2pAkGmUH/YVKMhrge3HEiIdPao4N23+p8Z69ABB8SrLtlcGABo51Ln/P1/ViTu+ghLiLh250fWeOIhXUtcbs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728968984; c=relaxed/simple;
	bh=wdQRSzt3oV+UK8vRpoct9SzNfGv13RMwxRduSaKFvVk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AHn4dPQXXkvG3Nl1e/Nz80eCRYYPfE/yuNW+n1lfDkIn0tDkQvzb3yE0V5XwyTfaBHSJdDOFY8npRvYmRBm6WIs7p9xAHfQF1hqo8I4018EMjxQr4Hi17abwybgAqcmqAkzsoaIES0kJ7K7EZ0XMo3vbFI5digIMMd5kHSo3jb0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=OucOQ+cv; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="OucOQ+cv"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=sVcRMWXpBFAuzYssB0SMce4UD5+ORBGUTai350zOJeE=; b=OucOQ+cv307x7yWMhPBkDDq71T
	AXEdMgitHhY78z/n5xYyQhfFp2IRaIuWsFLHHv/+vmGrehFQhakiyRZYmNXRAm8HXhYzsNOVI6UD2
	PkLTcPETjDs/8LewbyG/XMHz6PaiOf+m51bN1AvNQyCQZ1E5Psh8DDYeLB+taQc3sxWmuu6uuRLj5
	3m94l5Zar52thR6Waq9p9AP3Qy9qpbry9bJNIMwg/rXIUl8/8RlEdbRYKgBz9YQ7itxrguBn72gE+
	YI8u2XJhHnR3apvitJguLPcwO1d0nUTNGEqfxrS8hty9bG75hihy028VOr74syTAtYweMzbJ7F7Uy
	OxfhuJ4Q==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1t0ZoU-000000075NI-0qjY;
	Tue, 15 Oct 2024 05:09:42 +0000
Date: Mon, 14 Oct 2024 22:09:42 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, Carlos Maiolino <cem@kernel.org>,
	xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: port xfs/122 to the kernel
Message-ID: <Zw35FgISfIdk1gSl@infradead.org>
References: <20241011182407.GC21853@frogsfrogsfrogs>
 <Zwy0S3hyj2bCYTwg@infradead.org>
 <20241014152533.GF21853@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241014152533.GF21853@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, Oct 14, 2024 at 08:25:33AM -0700, Darrick J. Wong wrote:
> On Sun, Oct 13, 2024 at 11:03:55PM -0700, Christoph Hellwig wrote:
> > On Fri, Oct 11, 2024 at 11:24:07AM -0700, Darrick J. Wong wrote:
> > > From: Darrick J. Wong <djwong@kernel.org>
> > > 
> > > Check this with every kernel and userspace build, so we can drop the
> > > nonsense in xfs/122.  Roughly drafted with:
> > 
> > Is ondisk.h the right file for checks on ioctl structures?  Otherwise
> > looks good.
> 
> Dunno -- maybe those should go in xfs_fs.h, but I'm hesitant to ship
> that kind of noise to every customer. :)

Yeah.  Maybe just rename xfs_ondisk.h to xfs_size_check.h?

