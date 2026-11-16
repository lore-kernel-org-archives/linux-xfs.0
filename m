Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.137.202.133
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794808908;
	b=MdjJFKyAr2uARHGM5nVDcgse6oO2J4UP2HhdS9YYOZ2wf2KN7Y8tW+l6u5lvCniOmAU4
	 lRnNWtwVsp1EFCZDBk+8aS5tXJEjtTZ59J9PNoBCLs+Xh8ip0ZmHs35qnOBBG7TK9NHyi
	 o/AJFzbwB3ZVevZoaaT0FaDZeq9wn4m9okkls9Bq9axFgXQ8BxI3C7mUGV4UWD0XFRg5i
	 7zBN32+WN/a9/hpbe3G4Fi0ry4SUzyTciYZRNTe71p4ZXsi1JFbakWeJIlIs65N5xxNPY
	 78QuUAwr65ejnu8cNZGmp3j8QppsQXZyyXrwnFltEe98qV7dbj1G0Lc0/q/rMA2Krpg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794808908;
	h=DMARC-Filter:DKIM-Signature:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-SRS-Rewrite;
	bh=f1ONLJ0Ih5Ss8RqWcX7BFA1NKCceyjCJxFaWFPNB+nc=;
	b=fPm9/RhI3bCPEAIKfYRkPj0y4ygl922l+tAY9vkEXxPXS1Hk6UeR5gD4VZF4K+QUi0PE
	 uuoUUCf4xDtT/+a0jrzLYxayjUEj8cgG4fIHjFoVCdP9m/yU3TPiJRzkPLjSPiLu1Oe34
	 H4nf59X1U310zfU4tSWg2sqH9Jq+4W368Wi9UmX9E/XhEg9aoJLxIvbYNiS0K4oMlFeOE
	 +VNQP54j9BtXclK3L075mlbxZi3mA6M0KrKexnl55t9+OcMrp9rFNb8mNIGxBDzHPWqG+
	 QKIC9Con5itmkJBN4Zf+XcHhHRf3B7npsz5ClHq6ZCEX4nSYwF4fRKNQj6zbdRGbeqw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=infradead.org;
	spf=none smtp.mailfrom=bombadil.srs.infradead.org;
	dkim=pass header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=FhGCTeAB;
	arc=none smtp.remote-ip=198.137.202.133
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97928606A323;
	Mon, 16 Nov 2026 06:01:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 97928606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=FhGCTeAB
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=f1ONLJ0Ih5Ss8RqWcX7BFA1NKCceyjCJxFaWFPNB+nc=; b=FhGCTeAB7H92RKxMbcl4qDCqdC
	eZuEJNYOjeRRFPmQiVrEqFWrrG0Ga51/jo1NpkvUEvopbDGvN3r/CLS/zAO85IynW/e6cqAJUF9a1
	GWs2fvJ102UZQU/owYTdNWlI6VaGHsOEw3u9mU9MZU0G/cvm8W2YsJ8DrRgDRdNmiznbEvSc8eDjQ
	bXSXRvKu15ilmmENs8hCRAe+gsqbxEGQ2bJP/x83fpzv0RbEf0GLYIT7NOeHL/7+NzB3elk3OMQ6k
	b470a48IamAVipT7j8hlPzcrkI8A7lS2MTtURohzqOADbFMrGYlKZpii24b6C1MqL0TRDfLYjAFeY
	ndP1WQmg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xSpmk-00000001Ca6-1hnv;
	Mon, 16 Nov 2026 06:01:46 +0000
Date: Sun, 15 Nov 2026 22:01:46 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Breno Leitao <leitao@debian.org>
Cc: Christian Brauner <brauner@kernel.org>, Jens Axboe <axboe@kernel.dk>,
	Hannes Reinecke <hare@suse.de>,
	Pankaj Raghav <p.raghav@samsung.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Luis Chamberlain <mcgrof@kernel.org>, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: Re: [PATCH] iomap: don't update i_size of block devices on buffered
 write
Message-ID: <avqcSintiX4fhNUB@infradead.org>
References: <20261113-iomap-bdev-isize-v1-1-699603b589da@debian.org>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261113-iomap-bdev-isize-v1-1-699603b589da@debian.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Fri, Nov 13, 2026 at 07:02:17AM -0800, Breno Leitao wrote:
> -		if (pos + written > old_size &&
> +		if (pos + written > old_size && !S_ISBLK(iter->inode->i_mode) &&
>  		    !(iter->iomap.flags & IOMAP_F_FSVERITY)) {
>  			i_size_write(iter->inode, pos + written);
>  			iter->iomap.flags |= IOMAP_F_SIZE_CHANGED;
>  		}
>  		__iomap_put_folio(iter, write_ops, written, folio);
>  
> -		if (old_size < pos && !(iter->iomap.flags & IOMAP_F_FSVERITY))
> +		if (old_size < pos && !S_ISBLK(iter->inode->i_mode) &&
> +		    !(iter->iomap.flags & IOMAP_F_FSVERITY))

Please add a function scope "update_isize" variable instead of
duplicating these checks.  Otherwise looks good.

