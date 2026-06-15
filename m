Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBB9B3FFABE;
	Mon, 15 Jun 2026 15:05:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781535902; cv=none; b=eJmD9TyRj2CkOzpTaiWDF/2dbyg+RKCYI2W7vdsIjXQHF0/5CrcmrbftZwQyngl04Ly80rEmDhTp0QnaNMjXb+tpxIznES0DaBTU7NF7Arfi9u5Otr994YiB8CoIFlQYepYyz/DzoHcKDHVDP/RhMPExjyNRRZXCyc+mvjeNmgk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781535902; c=relaxed/simple;
	bh=yCNwdtLZCVr7PoiAlGoYbDjdB9Jb4X+7shi9s8oAAvg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Pq4gGkvMmMVg9+wz1y5vHHTh6CbKhhs56iHhh048US40o3+YKFiqC4xnRx6XpZyCj3IvUesXB0V+Vjm8mGk5QXlnaY+pmDzAGCSptC+RiuUlIYgRClC2Rby+1ZSAGt1dxtMRU67WeEffnJKXTz4anPbh2ctohCKcnLOWGEwOUuc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=IsDOwpXo; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="IsDOwpXo"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=3OCpgEkaMVY33epjoCoLMYv8TflczDWi7Ic0PcSElsg=; b=IsDOwpXoIMzdDpoZYQN3PuIfIL
	zdJMxZbin5c5M1br8N7i22NgLR6pkJhU/w48BhyKrQmpAK8kDYTgID1onbmt/b0dRvIsFWzsN32Wz
	wfmZpFv5btDHGOnrw6BAxc77LVqTJS5/kIeW85iDasbCy0+AZFQ1htZiEPA+Pv+cODJHjsnptybJh
	IIMEFKRaaZvcuj8b81LxoFBgco5yI9nRhHknfaWw+rGnmX/LC+PAWi2gCXprIfiaxyaW585x9mtNP
	u8oWVaJcSabygGFl1W/O5iaAdwvMugOBDXbLitNqCMoHq4yFDhU1AcFFl/rcXxUYLgxigqJRDrRpJ
	fu7jodNg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wZ8s0-0000000ETbZ-2jZS;
	Mon, 15 Jun 2026 15:05:00 +0000
Date: Mon, 15 Jun 2026 08:05:00 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org, linux-block@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v3 2/4] block: respect iov_iter::nofault flag in
 bio_iov_iter_bounce_write()
Message-ID: <ajAUnIft39_yly9N@infradead.org>
References: <cover.1781253428.git.wqu@suse.com>
 <35a61301ea76c71d101533bf7d4aeffb7752fb85.1781253428.git.wqu@suse.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <35a61301ea76c71d101533bf7d4aeffb7752fb85.1781253428.git.wqu@suse.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Fri, Jun 12, 2026 at 07:21:13PM +0930, Qu Wenruo wrote:
> diff --git a/block/bio.c b/block/bio.c
> index b33ff69bb722..01bb76d9717c 100644
> --- a/block/bio.c
> +++ b/block/bio.c
> @@ -1335,7 +1335,10 @@ static int bio_iov_iter_bounce_write(struct bio *bio, struct iov_iter *iter,
>  			break;
>  		bio_add_folio_nofail(bio, folio, this_len, 0);
>  
> -		copied = copy_from_iter(folio_address(folio), this_len, iter);
> +		if (iter->nofault)
> +			copied = copy_folio_from_iter_atomic(folio, 0, this_len, iter);

Same here, please keep a sane line length.

