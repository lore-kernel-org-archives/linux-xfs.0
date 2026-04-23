Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FE7321E098;
	Thu, 23 Apr 2026 05:08:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776920914; cv=none; b=gmlxPFjvQqQw5wHsmyxNS7lUerD+625mK4r0h76L59AaNZsf5idc0OOpmRzZTRgDoGrQR+Qq5DKXyQ41+q+sg/m4xlA1gK88mBpw2bMhJxkS3/oaXmf9hHOtl0DCpyY+Su6PdXHaKBtDG6GfLxwZswovTYNtiwUrwjxV5AwD710=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776920914; c=relaxed/simple;
	bh=HrfNR7fnumiB56vEYMy3p40je4xEW7wwiAn4IjvsHko=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KmEL7FLT5Klz5hi1C8qcoFKIfiDvGQSqq37yUfPyCpiHw3QQUMQPSbfhGAdEriUCjvQUpP2OZ+n/bLJ4IALWtCEegqh0qdajd30cBBlM8Gi6poLwuKLOE0ou2X/DyjNVUPSdDrhk+j89kGqiFMbsEhfoTXJwQjPByLN24sIH+e4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=FYv33qok; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="FYv33qok"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=1OxXqEnjl+54GOy6xnGRl8Qec/72RctUzHC5EckBAQk=; b=FYv33qokR6WpAV/RxGOQbhG8YO
	wmLSRqHLiTV3pezvTYS6WBzXykW/GPGgHRYwb4aPcgRqyc+6UlaQpy7TMpy1ZowpTR91JlBPZuh2+
	iUDEMyQC+jdsob+ZwUweKrrniV2nVCt1NILstuFWH2RVgSfT5f/UqdIjSbAIRy6sMaqrae5fUPtiZ
	ZzgU/U2ppSgJ87aIbWc2dvTRlDwbSeVN2wG0wJgFfDYON4fm10aZrWJX9h9H/uWRp63ap5iMgdMLG
	XOKWNt07GQaAzAGH458GgeePKU7+dCR41p4Umn1ufD+S6ceHUXcTbj2ApQPcD71YvHKuhmWxk2z04
	8lqyZJxg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1wFmIf-0000000B3C9-0TS1;
	Thu, 23 Apr 2026 05:08:29 +0000
Date: Wed, 22 Apr 2026 22:08:29 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Anand Jain <anajain.sg@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>, Theodore Tso <tytso@mit.edu>,
	"Darrick J. Wong" <djwong@kernel.org>, linux-ext4@vger.kernel.org,
	linux-btrfs@vger.kernel.org, linux-xfs@vger.kernel.org,
	Anand Jain <asj@kernel.org>, dsterba@suse.com
Subject: Re: [PATCH v2 3/3] ext4: derive f_fsid from block device to avoid
 collisions
Message-ID: <aempTb5TyKG0vPL0@infradead.org>
References: <5bda3d00-df35-4ea1-b313-2fef6e5c5682@gmail.com>
 <adSUiB9L0sFAd04U@infradead.org>
 <20260407144709.GA81690@macsyma-wired.lan>
 <3c9e478a-42ef-446f-a8cc-1b4ac970d2ef@gmail.com>
 <20260409041035.GC99725@macsyma-wired.lan>
 <22cfbf8d-af9b-462e-b240-67a1de24764f@gmail.com>
 <20260409131238.GC18443@macsyma-wired.lan>
 <b593ab17-afaf-4128-97eb-0ab9c23dec5c@gmail.com>
 <aeHikJwRmFdDg5FW@infradead.org>
 <cd9c0147-18cf-464d-86e2-12342a992ebc@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cd9c0147-18cf-464d-86e2-12342a992ebc@gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Wed, Apr 22, 2026 at 07:39:57PM +0800, Anand Jain wrote:
> > No, T10 does not actually mandate unique identifiers, NVMe does, but the
> > implementations are often totally broken.
> 
> Right. Newer SPC-3 (and above) compliant devices must support
> the Inquiry CDB EVPD flag and provide page 0x83 for identification,
> which is what we typically use for multipathing.

But there is no requirement for it to contain something useful.

> These are globally unique. And, we can overlook legacy
> drives, as they've probably been past their EOSL for a while now.

We have absolutely no useful identifiers for most USB devices.
NVMe devices have broken identifiers all the time as well.

So no, you can't.

