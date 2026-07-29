Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7D8143CED5;
	Wed, 29 Jul 2026 11:24:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785324249; cv=none; b=F2QfUGC3tOZFvjmfFTNlOKYanBJu4Ulz+xVBQHiuGbvTavnHFzvrsMO+EAB3gLoGabb6KmDjCZYB6lMDxW6Yli09A2LTcm0r29qQepKUCkcKuOTLQHUTE2quNBH+p3XUaVVw79FtfqiAFCpeMbJRPqAFQ+zEtvwgQQwvd4tkECs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785324249; c=relaxed/simple;
	bh=uvke3dxlhqftGiZC0k18rL13TCUf5wrGuBLRrf1WDkY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JgzhPHNMXMSh0e02IpgwKCMb3ajjiJ4vu0B9yOPJpS5i5y6XSDBWqZq1lMmkzI8y7JHLd5aDM75ztD2W+8eMo8e7bBnDTJRiPAtbkmukARHPd0Up3j0teLf0I4eGh+W/2lS0ISL0L7odOMkm3fm6hONUeWXGDgfDevEIdR9V+to=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id A8E3668BEB; Wed, 29 Jul 2026 13:24:02 +0200 (CEST)
Date: Wed, 29 Jul 2026 13:24:02 +0200
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
	Christian Brauner <brauner@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>, Tal Zussman <tz2294@columbia.edu>,
	Anuj Gupta <anuj20.g@samsung.com>, linux-block@vger.kernel.org,
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 06/22] block,iomap: fix protection information
 verification with initial bvec offset
Message-ID: <20260729112402.GB30003@lst.de>
References: <20260723145000.116419-1-hch@lst.de> <20260723145000.116419-7-hch@lst.de> <amnJ0rFnXTcfmcVJ@aalbersh-thinkpadx1carbongen13.rmtcz.csb>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <amnJ0rFnXTcfmcVJ@aalbersh-thinkpadx1carbongen13.rmtcz.csb>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Jul 29, 2026 at 11:52:46AM +0200, Andrey Albershteyn wrote:
> > -int fs_bio_integrity_verify(struct bio *bio, sector_t sector,
> > -		unsigned int size);
> > +int fs_bio_integrity_verify(struct bio *bio, struct bvec_iter *data_iter);
> 
> shouldn't this have a static inline stub if BLK_DEV_INTEGRITY=no?
> linker fails to resolve this in ioend.c
> 
> not sure why _generate and rest are apparently fine

It should be fine if all the callers are dead code eliminated.  I think
the version I posted messed that up, but the current version in my
git tree fixed that.

