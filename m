Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBBC92C21E6
	for <linux-xfs@vger.kernel.org>; Fri, 23 Jan 2026 12:25:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769171113; cv=none; b=NIx0Tgdh1uf9VONsRqxDhuLffWErYqKMpiKzxqaJ/E7B81F9oCblqnIjqQOKRNw0hEHNBGoEFZ/PyaRjaLD5yGdR1noSMkmKp4RhWaJFuBbBPC/t7BN4zvBDSKvTgwx6VzSAdVxCLlwkGUTz+BGNHPA/cucIhwX+NFlqhzV1h6E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769171113; c=relaxed/simple;
	bh=MaHOma0efUDlj0h9t53FX6P5BmsxWu98DpeJ6qmkNLA=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:In-Reply-To:
	 Content-Type:References; b=cDeucp+lq/z1lPJB9vE3J26fU7iQYewDGCPplLN5/N83SnZz1xjNwOrkNbVUmow8YXW3ssKzPDCPhGnuuEjPBvq/Gy3L7FGLAdFn5riUIO9dKSsu+wNCiOKya764VGrhRiDLLBUn9ZDa3B+NPFOn4+P4RJlHj1C5GxECj8+moPI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=EaCiZh5A; arc=none smtp.client-ip=203.254.224.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="EaCiZh5A"
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id 20260123122510epoutp027ccf6249740dd52def9e314d603b88ed~NW8BThJXa1048810488epoutp02f
	for <linux-xfs@vger.kernel.org>; Fri, 23 Jan 2026 12:25:10 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20260123122510epoutp027ccf6249740dd52def9e314d603b88ed~NW8BThJXa1048810488epoutp02f
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1769171110;
	bh=SeX3v0qWWpxp41MS12UgsBRF91mTWn1NcAmLb+gsNgw=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=EaCiZh5A+hxpONWmD4ls9BDrI92FWylHWbyuvtfJueTwfJIigoBFaiy5CqByjhkcl
	 q6xaT90OlmFKZN+jPAfxtNBKuD0/1gfBueE+51PNQANMRfJEth2qxZidduimPa5NGV
	 Mn7krHPOouUTNsDrMfaJPO+nB5U4nba9oHd/lzr0=
Received: from epsnrtp04.localdomain (unknown [182.195.42.156]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPS id
	20260123122509epcas5p4eccec6ebc055a3bbdfdc949ba346d3f9~NW8AktzEx3114531145epcas5p4_;
	Fri, 23 Jan 2026 12:25:09 +0000 (GMT)
Received: from epcas5p1.samsung.com (unknown [182.195.38.93]) by
	epsnrtp04.localdomain (Postfix) with ESMTP id 4dyHFJ3RCgz6B9m7; Fri, 23 Jan
	2026 12:25:08 +0000 (GMT)
Received: from epsmtip2.samsung.com (unknown [182.195.34.31]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
	20260123122508epcas5p391c1fb8720a8f1323860431b93da9a53~NW7-TYNTI3097430974epcas5p3t;
	Fri, 23 Jan 2026 12:25:08 +0000 (GMT)
Received: from green245.gost (unknown [107.99.41.245]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20260123122506epsmtip2c18e842c141830db4d4e99801abb9607~NW798qyeb2585125851epsmtip2K;
	Fri, 23 Jan 2026 12:25:06 +0000 (GMT)
Date: Fri, 23 Jan 2026 17:50:47 +0530
From: Anuj Gupta <anuj20.g@samsung.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Christian Brauner <brauner@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>, Carlos Maiolino <cem@kernel.org>, Qu
	Wenruo <wqu@suse.com>, Al Viro <viro@zeniv.linux.org.uk>,
	linux-block@vger.kernel.org, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 05/14] block: add helpers to bounce buffer an iov_iter
 into bios
Message-ID: <20260123122047.by424afpy5swmhqw@green245.gost>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20260119074425.4005867-6-hch@lst.de>
X-CMS-MailID: 20260123122508epcas5p391c1fb8720a8f1323860431b93da9a53
X-Msg-Generator: CA
Content-Type: multipart/mixed;
	boundary="----uUAw3F.Lk_UAUO08rJsbYBgyLSlm5c8z3L48n3TH2NgWyj3Z=_11efce_"
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20260123122508epcas5p391c1fb8720a8f1323860431b93da9a53
References: <20260119074425.4005867-1-hch@lst.de>
	<20260119074425.4005867-6-hch@lst.de>
	<CGME20260123122508epcas5p391c1fb8720a8f1323860431b93da9a53@epcas5p3.samsung.com>

------uUAw3F.Lk_UAUO08rJsbYBgyLSlm5c8z3L48n3TH2NgWyj3Z=_11efce_
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Disposition: inline

On 19/01/26 08:44AM, Christoph Hellwig wrote:
>Add helpers to implement bounce buffering of data into a bio to implement
>direct I/O for cases where direct user access is not possible because
>stable in-flight data is required.  These are intended to be used as
>easily as bio_iov_iter_get_pages for the zero-copy path.
>
>The write side is trivial and just copies data into the bounce buffer.
>The read side is a lot more complex because it needs to perform the copy
>from the completion context, and without preserving the iov_iter through
>the call chain.  It steals a trick from the integrity data user interface
>and uses the first vector in the bio for the bounce buffer data that is
>fed to the block I/O stack, and uses the others to record the user
>buffer fragments.
>
>Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Anuj Gupta <anuj20.g@samsung.com

------uUAw3F.Lk_UAUO08rJsbYBgyLSlm5c8z3L48n3TH2NgWyj3Z=_11efce_
Content-Type: text/plain; charset="utf-8"


------uUAw3F.Lk_UAUO08rJsbYBgyLSlm5c8z3L48n3TH2NgWyj3Z=_11efce_--
