Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 359142868AF
	for <linux-xfs@vger.kernel.org>; Wed, 17 Sep 2025 21:29:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758144548; cv=none; b=XlSSvxAc1XOwUt8X5vXoM6p1HAzONp78IonJbOCkM7mwCPMhkTzY451xuVTs2pXJwJKhPr81o36YjCdoEuuLIAY8QnYEdXt3LUxY+ABBudNWqo41xehfyXM13xltkH4rIETepAHvNsPf0ZvA8nT0cYcG9kndRRr55X15Qx3VddE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758144548; c=relaxed/simple;
	bh=o67cGI6r6B6eh0iK4X+PxLmmZkWDGGbDOCVh8P+AoqI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KWDS7FUrH33tZ8kyx3Bx1itnlVnN1xrglcvTVnbJFSwRK6M449AxeQua/vr+Mx7V7vUmgxYGJrsYYrZ734XY6XFF9VXcQ9lHkMVq8W+rzVhpEnScrr6NJQhoha/Qr9cMWxwv7MgD5L7C+j+4ZvIdcXM/1VfhmsMM9y6nzY63IGc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=JqW1vHQc; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="JqW1vHQc"
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-26685d63201so2747915ad.0
        for <linux-xfs@vger.kernel.org>; Wed, 17 Sep 2025 14:29:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1758144546; x=1758749346; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=FlYVJ/ZJe1JKkH4hVWOSoJmFiVemWEE+nL2UCBa9VI0=;
        b=JqW1vHQctfSVDKOG50aMPf5pIc0EAUilA2Y3vjCLS2YKFLzfgJk3VY8EwiS7fMxtQ/
         eQyAvA/eLorPv7mGp5iJy2SxvJTh4xCeSTc+m902TAgwHYjlxS8JDqXzGsnwnfy1jiDg
         Oc61FtOYNPmbuLE6/lzfx3N4PIusjx5PjiuNay0z7QG6yh2wFYYIe7Nk8ib+mzcD44uV
         ch1FDRDGotNb8jzZwX2aC9IVHtbZ/UleB962D1SCaceX0iDM45K4AaxT3b12fKZ3Fjr+
         SpZvcaKNcCzRHWk4iUr++WWTi2jwWHPACVEyVle9Y6rta34zQGlhU5maanLoOxRTUQDH
         Ln+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758144546; x=1758749346;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FlYVJ/ZJe1JKkH4hVWOSoJmFiVemWEE+nL2UCBa9VI0=;
        b=dGAh83jkF08VNb5AuXlQH3UMJK0V5bhww23VxMl6Pv3XuoxSbGQfzLTAc46+/R5oR0
         dD77T72Fox6f1hxYlNEiUaza5dO9AYgC3LiORYNG/xj7jZCFDYTFV6fk4mbMl7WWd96u
         a/h634fRXoGBMHNz/cci+sheU+EZN17fhiJeQGJ/QkSo5Cfb0oE3uvsyS0aKANQKOhUE
         mhzFFxcHfbADkNYnjX0i9xPgofptxff8M1YRlus4kXxzT7AE2YyYEQKLS29GEr0DiPf+
         Pi2HoilB1es9paGWCmYOYqYzvNIMq+7bzWLopiBfeMhFxoxsVpS+SI6QvVMGis6JbBRP
         HAbQ==
X-Forwarded-Encrypted: i=1; AJvYcCXsfp4sae4q8lo99muhNARecrI0IDNj8odJ9vbB1swUPpX2M9aI0n8NxXS2H5mKqNvGwKgEkrD79Gw=@vger.kernel.org
X-Gm-Message-State: AOJu0YyXpU+vPpKxMbaycTQW6iPNtNZjIE5gJmI2vKRbjwHihz6pWE2M
	W3G67O9fK1Iep7ZQeYNa6xVk4796zXzojbZECCFUlKf+EyeCWV/HaFBVWdFiNUuEqCw=
X-Gm-Gg: ASbGncsoxQRaKOyE2VaCbQnYB95A1hSNAhTLB1czVkd/LuvDLm4pE3DzulSeMsyWHBR
	QH4hIOnANxBKaREp3/TfewqMtlYjwPXTNR9S04OMrWRnNtBIzEGRt+Vv1hFrJj991QfAlX/wmU9
	m0E9PlGt8bVTLCEhUP6SOPu9Areg1IuitFFIaaexUX1+HY8QzM2y0kZSuKfHbR07h3y83V5dsbX
	NM/a4gsd2Z7or86TGWg8YXuKGJGuCRpMg8XAnh2KznwpPA3Tty3EuA1ivV5PLASdk79UOwds4VR
	EqLV/ejWDohLosNBfut8ahIw+FH7TxEwObrUVu9ja9123trvVXljIRb7XLM7izcGP2s887DRfr7
	DSBsxSg+7cLRjBRgPhR4ynonrRDoB4ClsXoPKh5CMhnNUdgQSXvytbBHPb67rSEqho1HXt4ticv
	c7vZ6N4A==
X-Google-Smtp-Source: AGHT+IHcr21YWLD91dusQW8SNi1I3dAtEWNObYpAHuETIgLObfxFZroJFpb7Ws8YBQPFcnrDJmsPJA==
X-Received: by 2002:a17:902:e741:b0:24d:a3a0:5230 with SMTP id d9443c01a7336-26813cfeb50mr47018265ad.58.1758144546311;
        Wed, 17 Sep 2025 14:29:06 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-91-142.pa.nsw.optusnet.com.au. [49.180.91.142])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2698016c13asm5197425ad.46.2025.09.17.14.29.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Sep 2025 14:29:06 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.98.2)
	(envelope-from <david@fromorbit.com>)
	id 1uyzi3-00000003HCt-0tJN;
	Thu, 18 Sep 2025 07:29:03 +1000
Date: Thu, 18 Sep 2025 07:29:03 +1000
From: Dave Chinner <david@fromorbit.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org,
	"Darrick J. Wong" <djwong@kernel.org>
Subject: Re: [PATCH 2/2] xfs: use bt_nr_blocks in xfs_dax_translate_range
Message-ID: <aMsoH2ez9ZXHjs7X@dread.disaster.area>
References: <20250916135235.218084-1-hch@lst.de>
 <20250916135235.218084-3-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250916135235.218084-3-hch@lst.de>

On Tue, Sep 16, 2025 at 06:52:32AM -0700, Christoph Hellwig wrote:
> Only ranges inside the file system can be translated, and the file system
> can be smaller than the containing device.
> 
> Fixes: f4ed93037966 ("xfs: don't shut down the filesystem for media failures beyond end of log")
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
> ---
>  fs/xfs/xfs_notify_failure.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_notify_failure.c b/fs/xfs/xfs_notify_failure.c
> index fbeddcac4792..3726caa38375 100644
> --- a/fs/xfs/xfs_notify_failure.c
> +++ b/fs/xfs/xfs_notify_failure.c
> @@ -165,7 +165,7 @@ xfs_dax_translate_range(
>  	uint64_t		*bblen)
>  {
>  	u64			dev_start = btp->bt_dax_part_off;
> -	u64			dev_len = bdev_nr_bytes(btp->bt_bdev);
> +	u64			dev_len = BBTOB(btp->bt_nr_blocks);

I'm pretty sure that's wrong based on the first patch -
btp->bt_nr_blocks is in FSB units, not BBs. If bt_nr_blocks is
converted to store the device size in BBs in the first patch like I
suggest, then it's right...

-Dave.
-- 
Dave Chinner
david@fromorbit.com
