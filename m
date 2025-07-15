Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D1D315B0EC
	for <linux-xfs@vger.kernel.org>; Tue, 15 Jul 2025 16:09:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752595773; cv=none; b=nkV2dgd42erWD5oNQ90YHIXMPwhKYLTt8Ej4gSCngDVi/D39vIjgdip3m5HrWXSxzXfm2YmZhnfUi5dVs2o8/dxpraStzyMyufI+jOf2GFC/IkcU/pl505WCOapdg7U41Jv85okm1gnCaOdchcbJe8dfXVQk+5uBvagq1f8DV1w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752595773; c=relaxed/simple;
	bh=LjnIE3P01OcY3g8uQrURywbMJP+Y0XPrO3Wb5eeaT5E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uk2Z/MfWA6m6IPzh+73hWQ0uOE8b0H5twYHslTTzLkwo0hYH4CuYlOm6XLVeY7Duov2maUSYaUugOvAF7VxZ3GF0lgRn7J3N7DeTR45doBw6VtuF3JEn3vczpq4VKiQn0WzXAoFu5uZwb/ZIl8L/XyuPOzkhWZX7tizzoxPcIv0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=2lIiN6UO; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="2lIiN6UO"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=JXH8TlqD0edT5I48mJ+qCQauDNKRwYKA/gE20wnxgpg=; b=2lIiN6UO30Lj/0JCvDnnX8iaNo
	apojdzexKgKVB/Tq2y0E+bUspiniaqjQ3tqcd1bHgr5FbMZ7ZbKwMSaupqPtJhndIXJPMlBMG5w70
	Q/vCVyzw24qGQfUftd/CxO0DPk84oFQEk8eRjjsDziGVCHhGzhJ56Hl6E5N9GYM8S7+rZmVN3GF5X
	aaCcbYDss4nyIK7ErpYzN+UyIhSNDTWumsXm6V2alCyHoGEYJjjij3vEyFAXVTVeAx+O7XCs1BSuC
	c9KiOHQ6Te1jlgn+xAv4BenPLwLY19ksSNX8SFw9GTKpB/puJHgsO5Cu4z7jFctdtO2GLBgpdP7gh
	46sAD9mQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1ubiDh-00000005hag-1t7s;
	Tue, 15 Jul 2025 16:09:29 +0000
Date: Tue, 15 Jul 2025 09:09:29 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Priya PM <pmpriya@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org
Subject: Re: Query: XFS reflink unique block measurement / snapshot accounting
Message-ID: <aHZ9Oaf7EVcsVT1z@infradead.org>
References: <CAP=9937nv-k1dTbHHRZF3=jizvRKcQNAa9_nM_Z1RA8VMYhKSg@mail.gmail.com>
 <aHScbEVwQad_ryX5@infradead.org>
 <CAP=9937tVVUkFCOudoJWx7O8aBhrAkRmkGQY7YpOU_4aHgyrJA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAP=9937tVVUkFCOudoJWx7O8aBhrAkRmkGQY7YpOU_4aHgyrJA@mail.gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Jul 15, 2025 at 07:21:22PM +0530, Priya PM wrote:
> For example,
> /mnt/fs1 has file1 of size 40KB
> Do a reflink cp of /mnt/fs1 to /mnt/.snap/1
> Now, when I check the size of /mnt/.snap/1/, it should show only snap
> usage. In this case, it should be 0, as no blocks are unique to this
> snap.
> Modify file1 in /mnt/fs1, modify 2 blocks of block size 4 KB.
> Take snapshot /mnt/snap/2 --.> This should show only the unique snap
> usage as 8KB.
> 
> I understand there is no snap accounting in XFS. However, to achieve
> the above things, is there any XFS command that can help?

reflinked blocks are not owned by either file, so the usage is shared
by them.

There's a few things you could theoretically do:

 - check how many non-shared blocks a file has.  The easiest way to
   do that would be to call fiemap on the inode, and count the extents
   that don't have the shared flag set on them.  You'd probably need to
   write that at the C level, as the filefrag and xfs_io fiemap commands
   aren't all that great
 
 - look how many shared vs unshared block a file system has in total.
   For thay you'd want a rmap-enabled file system and look at the fsmap
   output.

