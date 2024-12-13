Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C57A1B21A2
	for <linux-xfs@vger.kernel.org>; Fri, 13 Dec 2024 09:25:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734081952; cv=none; b=lOatYNHm1sOpjXqls2BTU2d8ZXfG388qW6Pg9AwF6hmkksY7treuu1rAfISXjnqeGGiMy3IK3dzbdmq0VLRnDmX5z3M+S8mNriVRPS5C1LONfQMkidyifmujDYcisuifiRg+jEkrvqT1PDwn/wGdBgIriC70Q2tLqbIsjQrSQR4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734081952; c=relaxed/simple;
	bh=yTiFBMddjf62WF/KdYCjM7I3bczFVmSMLqvhOt4uPsg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sDHMB+TkvvzMIjR/dhXZFibJUk3Aht91NnZIfbaUqNwzbCi1SLVQDPgjVO0sZblNAGFDrpBLdvmwyOVf3vqbx20AOCv0koTZqfKej1gCvHJaQeA9VD/aUSdKATHtH9c2Rhm13ITEhOB7qePzoAVm5xzWptylLWM8gs2v0kzdCUA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=KbztIbPg; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="KbztIbPg"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=VYGBMR05b2ih0Y22xsDCj1cZpcuUVaXrODAijrCX5nM=; b=KbztIbPgHwO9Jc23RGPhPjj1cD
	mlZ5OghOHa0SaqZDw9a7rClROA415Xkj7G+mOU6K1Ti4Frih+3G64yiBjtABqNbYCIXbC35J4ASq4
	2mQiUBbkTuA8c/T2LMxQu7Jw85poVQPLX/3NsC2qYv2PjUdoYNFN7mN5MfLsBl8qoifhDeyu8wqAA
	Jp+tO5Rt4c7DOoW95Yy6L0Vrz0B5kC08EDq8MpykSzrfNp6nXyteIT+akovh5h0iMudbZ/m1QJ+RU
	5i/1bZpSEQh1yztTa19lzo/UEDsBaNxfeoFjmauR0K7NzjUnCsCZM1pUmFSWo9zNNGowFfVSGmjb3
	k2w+tPrQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tM1vi-00000003Fmd-2yK2;
	Fri, 13 Dec 2024 09:25:50 +0000
Date: Fri, 13 Dec 2024 01:25:50 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 43/43] xfs: enable realtime reflink
Message-ID: <Z1v9nl9DP4N_1mNQ@infradead.org>
References: <173405124452.1182620.15290140717848202826.stgit@frogsfrogsfrogs>
 <173405125304.1182620.11655711195171869232.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173405125304.1182620.11655711195171869232.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

> -		if (xfs_globals.always_cow) {
> +		/*
> +		 * always-cow mode is not supported on filesystems with rt
> +		 * extent sizes larger than a single block because we'd have
> +		 * to perform write-around for unaligned writes because remap
> +		 * requests must be aligned to an rt extent.
> +		 */
> +		if (xfs_globals.always_cow &&
> +		    (!xfs_has_realtime(mp) || mp->m_sb.sb_rextsize == 1)) {

This looks unrelated to the rest of the patch, or am I missing
something?

