Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEB9835BDCC
	for <linux-xfs@vger.kernel.org>; Fri,  5 Dec 2025 07:31:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764919908; cv=none; b=tRLtOqb0YZtLU8ni7ElvJcZECeB17HmBJuHw5LtiXf3eI/uFfmsBj+p99A2vGaHt/7FGf/MCoZaQnOcXRE7RgBBHg6EDgat9hHKr33kebWstlNYcwISOMnKxKTPSYv0Ao3lH9+aNV+MrPbDsidFFbgSaNsHwA7mfCvzXAEC5gl4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764919908; c=relaxed/simple;
	bh=cPVh4uGXO3JKn4X7MqDs89jrIQ8PgZgeS5FBaBbBu/o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kJibj2ArdlI5x0R8KQA1rPEniGY9+Co1pB8mIjB3g3Ps0HsuzhsKx7I5fLwlWLlvQlUVi97afpLOms24S2zZE53IbR/sMc+RxgxTTy3ooBlxxUKmPl/xcoSGsDZHB2gFYM97UXixmm6xxHwg3O7hwVTukyyx4x5vdrdvQTnOJUQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=StsFTZVL; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=Op/VgbYr; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="StsFTZVL";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="Op/VgbYr"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764919893;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=WKF7QrOFWuELzP/P2olrzfa/3sHRV/+J1OT7rcGZ/xw=;
	b=StsFTZVLqQ0/blyacUr5hFAc7hF1ATkH32V0JRBD7Rgt9E8LCzpcehXvGtZeVwMQfiaInR
	oqPgmHn9TDUdQQJPbwymjzQc1gQbd7ZH0wvb+d/TBszM31PxcA1rK3W9oauAVTWRFDVU4F
	qoleIpZ5r8yyNxbKnFR4oYyGA26OG3c=
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com
 [209.85.216.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-371-SG3xYlukPPmYj4zWRY7o2g-1; Fri, 05 Dec 2025 02:31:32 -0500
X-MC-Unique: SG3xYlukPPmYj4zWRY7o2g-1
X-Mimecast-MFC-AGG-ID: SG3xYlukPPmYj4zWRY7o2g_1764919891
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-343806688cbso3967642a91.3
        for <linux-xfs@vger.kernel.org>; Thu, 04 Dec 2025 23:31:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1764919891; x=1765524691; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=WKF7QrOFWuELzP/P2olrzfa/3sHRV/+J1OT7rcGZ/xw=;
        b=Op/VgbYrpRRQn7ELVYlbSO8txzgV3YCH0LgfkCCYgB1H7ZvcCxIesV23VTx/eOQ1IV
         CLDRZOScYTrLc2Tfi34xxEuIDQdxjx9JSbIEZ+pPzsJaQVSuynMG+xAbB+AH+mS5iXoN
         8I7UgKvzl+QCPhCvSp1H5yrihVB6lBLfecP5N9n0/QzRSyVKE22D5/guI4tp/AAIxhbI
         BZwRw1DZi6edP/VeThs37z2y/EyYZzBTjEzgZpuRuUcrGXGbWmkmZad2kAPh8HI4iMJi
         KoDh0AORNxSBJMNR0pDbBl/t1h+f31r5+rLMxg7oPfL1tMUfLp8ShF0GlXXTwronUAT3
         CfTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764919891; x=1765524691;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WKF7QrOFWuELzP/P2olrzfa/3sHRV/+J1OT7rcGZ/xw=;
        b=l3kUT9lHLV72QRzOgUv+IpTppViyIbQo0CdiPTWRGyNdH/XZNJu9UVtfAt1kDNa2nP
         6s4jxYTKCO9+8tFv3uIDZqODSMfbbgkhug7iSMUSsOZ3hZla5xuU7bgJ4lmjs4ZiC2K0
         BNtuhWVZ9mvrNg8R5nq6IiWn/ua8R2wZDc3RpA8TbcHvs9OtEJYof6nEQ/Y48qTA3R4N
         /x6W/WCdxRGqaisVAItVxIZdWq+4g/e/Y8cx+p5TfnXs9P71+Y91P8juBBYi1IzoUfZf
         YS/78d8+DAHEYv8dq6TsVP0gnmq1L4bzW+zaNPRl5jNWYyKWW7m51WRo6RXAyWeu3xG6
         nf3Q==
X-Forwarded-Encrypted: i=1; AJvYcCUkg3eY/RFRoD0Ksf6S2r+8CU7ap+9dnEPn+EFMK+ut0rtSCZzp1myXmA0Cv2/RlpIaFHPjoAaStQc=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz2jfJCKNAvFoDuGUFAzijlDstXs8Sq85qGUeV6AFzCdkbOl8Dy
	R2kWaO6sngeu7Af1FwRJtbFZVHWZ2WyYX85PPVmgG78N9k1pjQV4JEIgrWmfVqvs0S+8yjlHJXa
	hQP5cxOboH/aYOBxZhToJ/c7aYXPCB4ll41QJTgDTKPtzHsIeld8SQWsdoUbkN4RP4uw17g==
X-Gm-Gg: ASbGncsMOQQ8ragd6W1QoxaKRjT9L36Ew7pH89P4iq+Z8hngtdaVQ/35+rK7gxJ+YSP
	wix+sl2SKjg9sUQWRDwr+CDcxAtsqBZhloSgiC8pKEv5pKD52mrXkRf8iLeQkimGyDfmz3xxOPE
	zzkW41ND2KkbuFc89Fvu5Jck4SrxF7u2trZICufiUlw2CDwx7coYWL7SsOk1ksq/wbN+0B7u/bM
	MrFROU+6XSKX5R0tzDjRsAHuBRQOTXZ/lhA7Dzqlyzou5KvSC3EG5bJDJBQEc8M+5iLLCvAP1qT
	y4EbUbWCwlxtGk/EY3IF0IOKJvL4HKvPzwU9o7ZiAGu8UrbQoFEvAxiHBQ3XMmXWrziBybRlFQG
	7alDIIrdlyn6lXNWgK4qQXbhudC1IvXunQ8zvRKsCKrriploDxQ==
X-Received: by 2002:a17:90b:5644:b0:32e:9f1e:4ee4 with SMTP id 98e67ed59e1d1-349126d0d0emr10240427a91.17.1764919890776;
        Thu, 04 Dec 2025 23:31:30 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFHvKcw1J3JRbPRFVPumWJICvQTcnO2qIe0MHIwuvOTQvNgfh/ooO8rBUVWOHJdajlNoZP3ww==
X-Received: by 2002:a17:90b:5644:b0:32e:9f1e:4ee4 with SMTP id 98e67ed59e1d1-349126d0d0emr10240408a91.17.1764919890287;
        Thu, 04 Dec 2025 23:31:30 -0800 (PST)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([209.132.188.88])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3494e84f577sm3876845a91.6.2025.12.04.23.31.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Dec 2025 23:31:29 -0800 (PST)
Date: Fri, 5 Dec 2025 15:31:25 +0800
From: Zorro Lang <zlang@redhat.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Zorro Lang <zlang@kernel.org>, "Darrick J. Wong" <djwong@kernel.org>,
	fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/3] xfs/158: _notrun when the file system can't be
 created
Message-ID: <20251205073125.tddypzbg7lyrzwna@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <20251121071013.93927-1-hch@lst.de>
 <20251121071013.93927-4-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251121071013.93927-4-hch@lst.de>

On Fri, Nov 21, 2025 at 08:10:07AM +0100, Christoph Hellwig wrote:
> I get an "inode btree counters not supported without finobt support"
> with some zoned setups with the latests xfsprogs.  Just _notrun the
> test if we can't create the original file system feature combination
> that we're trying to upgrade from.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  tests/xfs/158 | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/tests/xfs/158 b/tests/xfs/158
> index 89bf8c851659..02ab39ffda0b 100755
> --- a/tests/xfs/158
> +++ b/tests/xfs/158
> @@ -22,12 +22,14 @@ _scratch_mkfs -m crc=1,inobtcount=1,finobt=0 &> $seqres.full && \
>  	echo "Should not be able to format with inobtcount but not finobt."
>  
>  # Make sure we can't upgrade a filesystem to inobtcount without finobt.
> -_scratch_mkfs -m crc=1,inobtcount=0,finobt=0 >> $seqres.full
> +try_scratch_mkfs -m crc=1,inobtcount=0,finobt=0 || \
> +	_notrun "invalid feature combination" >> $seqres.full
>  _scratch_xfs_admin -O inobtcount=1 2>> $seqres.full
>  _check_scratch_xfs_features INOBTCNT
>  
>  # Format V5 filesystem without inode btree counter support and populate it.
> -_scratch_mkfs -m crc=1,inobtcount=0 >> $seqres.full
> +_scratch_mkfs -m crc=1,inobtcount=0 || \
> +	_notrun "invalid feature combination" >> $seqres.full

Hi Christoph,

BTW, shouldn't we do ">> $seqres.full" behind the _scratch_mkfs, why does that
for _notrun?

Two patches of this patchset have been acked. As this patchset is a random fix,
so I'd like to merge those 2 "acked" patches at first, then you can re-send
the 3rd patch with other patches later. Is that good to you?

Thanks,
Zorro

>  _scratch_mount
>  
>  mkdir $SCRATCH_MNT/stress
> -- 
> 2.47.3
> 

