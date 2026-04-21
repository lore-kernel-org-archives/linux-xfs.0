Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8129C1C84A2
	for <linux-xfs@vger.kernel.org>; Tue, 21 Apr 2026 08:19:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776759550; cv=none; b=F56hsJCG0Tgx0a6GOtkBV3O1hLeEjGL+cFmlzYiMIbBTTEFl8ucAC63TSq1FFy3ItE9khv7UKfF+feLMULdil8cO9xpbaJ8OWCbjLP8bZUqLhu66wfJdaond31K7rjRyjYtLdbMi1Jugdsmps9nhUDDBi0pkwkwPaC7q6RkYRE4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776759550; c=relaxed/simple;
	bh=kuWSIqBmy4o8XsBpkPW/tUnDENqNU9b76u7BTIjBrWI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=I/K7ypVZAG+BZO3Kq9uv0VEtnyVJyOOI++dBhJDz8r5hbcb0XaryVoFgGHJp1O/2cm6wURM8A37JLwr5nYRZPF9c1WweTI1/uXrYDRygdDwwira/YIc/Xsm9vHcmmYaHtmgupkHfLE/sVTY6ovMrqIdOwZ3ns8yQzMNRwbj0jjY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=eITtW2JY; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=Q7g9SNyf; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="eITtW2JY";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="Q7g9SNyf"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1776759547;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XHDhOKbFOsYFAUsphudSL+OUiYOBUkJQRToZVGnuYLc=;
	b=eITtW2JYGBd9VteytgBir6DxUelSFAFL0/SCAqGQx6Xor95XNkQzXE9xDmrs6WIUkugsuP
	m0TBPPyG61TTeFImhBBLy5k1VHkWSrupTrkCA/Lmc9afAL0rREolfvICF5JeWYwzbnzH1r
	HacIUbbhve1qtaKYWWk9B5oS+Q5RyZY=
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com
 [209.85.214.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-532-NiczhdBfOTOP7AZT3joA_Q-1; Tue, 21 Apr 2026 04:19:06 -0400
X-MC-Unique: NiczhdBfOTOP7AZT3joA_Q-1
X-Mimecast-MFC-AGG-ID: NiczhdBfOTOP7AZT3joA_Q_1776759545
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-2b24611696eso27655795ad.3
        for <linux-xfs@vger.kernel.org>; Tue, 21 Apr 2026 01:19:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1776759545; x=1777364345; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=XHDhOKbFOsYFAUsphudSL+OUiYOBUkJQRToZVGnuYLc=;
        b=Q7g9SNyfiJ3hGpiDnJds8oUgjsdjCvI5PHOEIG+EYiQbwiRGTm7ArbMwhGDhBNn1Nr
         t4GVvBYCBnwsyMc0yaONucanvYUSi6twhM3C0pOwb0TEoHBUZ1dAYqUKqHkRwgBv8y/c
         2r1bRy99WCgsXWh9H7uf1DGMBoXmsM2qCN9kh4tmVlxuH9Mu/cvCCV0bPsQ52S+nNOaH
         z/m3y+0tETJtYlqJK0qoTFdKbc5uHvsu+qNpmf/CngSr7wY40NWL5i13X6i+3IZys0dS
         EpRoNoatqGJlemOSv/gb2BehrAxTeL1MON4KLXcHA5ZkA/sFTW3Fton84HNFB9T6M2ei
         L8KQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776759545; x=1777364345;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XHDhOKbFOsYFAUsphudSL+OUiYOBUkJQRToZVGnuYLc=;
        b=FgIRGw0v5OvBLZmP1qqf8LD/z6eiSVPa7TTvvYBdYS1oDi90hBKG1xz07TOOpUu5gX
         PtlFSI54oKd01LLeln6fjv0tfHi8tQukKV86yv6XmUev4QxhN/RBmEoEFN5sSAd2BoVR
         DUPZJm/JalI5xpncwNZ0pSYrrOp7SV0eOIowl7NBrU56gKrMa0mx0duIMO8oofTik1oj
         Z5Zgg6teRlNfQPt95h2JxoUhSLP5byJYDb1IfjLwKbCymuh3HZYWzIYX70IlIYUEPnQ9
         FSsyb4gdjqSYTo8ce9UajuxESYvgsxlsbnO7tz32DwITaG7Z5thwbEQVxSLEW6G9swFv
         Nibg==
X-Gm-Message-State: AOJu0YyRd6FYc28e1lfxbGXHYVpGvjcVjRCFWSnYTyymA5xkmpBRJlnC
	XiXZmroRTqpFC/keH/qUCgykvVxKOfqOa/oPlhBWXMbeKm0G3YC5X4vjdOP/iOJoz/F2e7voV9T
	tFBP419ALpEs11yu0tsHU3AWvJGNYU/EhVFRyj+boa3tGWEbz3/VPANNZ0QVROQ==
X-Gm-Gg: AeBDieuyZQmOBPKaLqttHagQFGqv8PgmzbnL5rXCeX8GJMbDZnlgaIAh6NPSTRRttAL
	GLOLPCChQoWn3rvBAEWQT05qlhQKtxTqWKYkRwXGN4mbRAX69iumnvrE0cCL4cFb5fsqEHB90ag
	EKZAQewxlxJ/fJQQHYHK3vXdg5nXtW3BaWOApunbXArdyA0CdURPIrtv+JCXeVdBOx7ixNS/wOq
	V/IYxIeHLKjOLrbiTHy1dHvo+lbzIcrgsuQsGrG4/vrUExDIi4sSiDyYuipBLoVyDCbCKL9tBuQ
	K3mwUlSW+qWe5vsOd4vEHMA64M263CypwNpHL2XyUw0zuFN5PdaWIlE4J5AVdIyKgYMVdMYSZ/h
	/cVd5wem78O8pY3HQmyxfMqTVWAE7TiKjWKZ5bAdsAS/ULGez0CLnvYY4ySv7R4ATmbwsuPIV2L
	dLT3lFAA==
X-Received: by 2002:a17:903:98b:b0:2b0:7026:24bf with SMTP id d9443c01a7336-2b5f9eff280mr178632835ad.14.1776759545245;
        Tue, 21 Apr 2026 01:19:05 -0700 (PDT)
X-Received: by 2002:a17:903:98b:b0:2b0:7026:24bf with SMTP id d9443c01a7336-2b5f9eff280mr178630255ad.14.1776759539927;
        Tue, 21 Apr 2026 01:18:59 -0700 (PDT)
Received: from ?IPV6:2001:8003:4a36:e700:56b6:ee78:9da2:b58f? ([2001:8003:4a36:e700:56b6:ee78:9da2:b58f])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b5fab0cb92sm122243095ad.50.2026.04.21.01.18.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Apr 2026 01:18:59 -0700 (PDT)
Message-ID: <3ac237a7-29b0-4021-be81-413b4d858be8@redhat.com>
Date: Tue, 21 Apr 2026 18:18:54 +1000
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/3] xfs: handle ERR_PTR return from bio_split in
 xfs_buf_submit_bio
To: Long Li <leo.lilong@huawei.com>, djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org, david@fromorbit.com, yi.zhang@huawei.com,
 houtao1@huawei.com, yangerkun@huawei.com, lonuxli.64@gmail.com
References: <20260418092715.375850-1-leo.lilong@huawei.com>
 <20260418092715.375850-2-leo.lilong@huawei.com>
Content-Language: en-US, en-AU
From: Donald Douwsma <ddouwsma@redhat.com>
In-Reply-To: <20260418092715.375850-2-leo.lilong@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 18/4/26 19:27, Long Li wrote:
> bio_split() now returns ERR_PTR() on failure rather than NULL.
> xfs_buf_submit_bio() currently ignores the return value and
> dereferences it unconditionally, which will crash on error.
> 
> Add an IS_ERR() check after bio_split(). On failure, flush the plug
> to dispatch any already-chained split bios, then call bio_endio()
> with BLK_STS_IOERR on the parent bio. Because bio_chain() increments
> the parent's bi_remaining for each chained child, the end_io callback
> fires only after all children complete, propagating the error back to
> xfs_buf through the normal path.
> 
> Fixes: e546fe1da9bd ("block: Rework bio_split() return value")

This looks like it could cause problems further back?
Perhaps 
    fac69ec8cd74 xfs: simplify buffer I/O submission


Don


> Signed-off-by: Long Li <leo.lilong@huawei.com>
> ---
>  fs/xfs/xfs_buf.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index 580d40a5ee57..fda215dd00df 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -1268,6 +1268,12 @@ xfs_buf_submit_bio(
>  
>  		split = bio_split(bio, bp->b_maps[map].bm_len, GFP_NOFS,
>  				&fs_bio_set);
> +		if (IS_ERR(split)) {
> +			blk_finish_plug(&plug);
> +			bio->bi_status = BLK_STS_IOERR;
> +			bio_endio(bio);
> +			return;
> +		}
>  		split->bi_iter.bi_sector = bp->b_maps[map].bm_bn;
>  		bio_chain(split, bio);
>  		submit_bio(split);

