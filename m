Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FEC22DE1F0
	for <linux-xfs@vger.kernel.org>; Tue,  2 Dec 2025 04:49:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764650952; cv=none; b=q9WoQDbeSRLxnyCp2PO1MNqjhZWY+YxY0DZeMBSClCsem9iBreO7/Kka7iobeSve+ea7n+Yh1env6G4knDJlgVPsqMNVnJPctQ+Oqw295eei5pxXSiYRTIErzZjNWgToXr8DW0tp117aK7Df6Ox6sbwSuNLGjC6Av1GPWAQelY8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764650952; c=relaxed/simple;
	bh=ZYETizQ+hiimQowD31L6fDaehmOdpTtJ7kR9C53Z3rM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uGkXSKhkX+2kKKxd9Du7nMiGDwfCz0PYLKQ0aXu+venFeI9cJEUQZLOq32wHvstk6vez5tsjOg1dOKxmXyGcnN+UTbQ5mfkSuSXrlJKmbr8mG3ikwor5NFm8ZXilkm6GGq3kSxGznuvW0G54UqKScTEWIUER78rWJCyAR/ePmZk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ITX0IMaI; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=TL6izFlc; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ITX0IMaI";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="TL6izFlc"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764650948;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=nfXCG7qtvqsPd97VFpV5B8S0Vrh42iGdxD4tn64fZI8=;
	b=ITX0IMaIsNoKAUpgZ/4JmKlyFHMUzZtT0hpdqSvStDrn0/SWF2VFxYFCQyuAtUc6CDRWdx
	nUZZul+EycoX3CYjd/7oO2QLkhi6nF2GY+dhBOBamdwRmFiOBjK5Tac1IQr9iMhi6BjjMS
	JvaXb+aRI/oVhud4VttiCOZVy4scfXk=
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com
 [209.85.214.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-595-8g168MorPj64ANAPoThr2A-1; Mon, 01 Dec 2025 23:49:07 -0500
X-MC-Unique: 8g168MorPj64ANAPoThr2A-1
X-Mimecast-MFC-AGG-ID: 8g168MorPj64ANAPoThr2A_1764650946
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-297df52c960so93242255ad.1
        for <linux-xfs@vger.kernel.org>; Mon, 01 Dec 2025 20:49:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1764650946; x=1765255746; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=nfXCG7qtvqsPd97VFpV5B8S0Vrh42iGdxD4tn64fZI8=;
        b=TL6izFlc6ls/gP0rrD21DBAB3hkUOFidxH5kbh92uQzpDd97bfsT7ycb4lOJddjLnw
         GMZOFrHWW5cmKs66OdGVsPG3K/yYMA6F+Kv/WSQb8ctqBX3CNFGw0t3ZyrOpOz9QiWyy
         YLkPTSxelOE0mBD+m7YUEMYZAvV12BZKGfG+rkX559Qp8u2H5mycUHUW0JjYIqyjhM6S
         F+F76ElHnpITGE+wfYr1s+JPEk1mfOB6s2stqLkgO7tvHNaNRQkJHTGugE9xSmiE2zaR
         f71UNKmNarnZpYEPU0L8t7L6Bsw5SucyiR0BesC8KAymXuDLl9ilGCHfBcIAvYVITeGq
         UX7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764650946; x=1765255746;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nfXCG7qtvqsPd97VFpV5B8S0Vrh42iGdxD4tn64fZI8=;
        b=ZD+LfncZgZQTRIMfJ1TEQfCtBhMOT46kWoR9NnjfAeVEUF6b0X1Fix5igGm6+wPpCx
         T/tsLZcjkh3isnbBS8ti6htEkZqeY6gOD3KDgx83Ec6GXZ+MTnlYqKpUw7TKbn1EoxjI
         1U336hmBMJQPuWUVBT0d9XXeDyn/e5P2TLqoz06B1CxIvpI1QNeVpR65DR/RNMhAbGVW
         wGUnjQpl1h6kvIj6PvDtn2VVBNta9sYFW9/CCzkbNMBxqKASLwwZdlW62BeN73eKg44o
         TZHjTYJ88xwi5YdoF/uvb8fN788A0GP38h+lIVRjXzry6P4f56nNl85twx7vfxUY5+x9
         GsKw==
X-Forwarded-Encrypted: i=1; AJvYcCUUNx9ruRarT/ws6Ypaqk+PZUIwqXKQOdpPxL6/cVEIzgpzZzm1J0UGiPDp0NX0sFuIh8ajNa3CQLM=@vger.kernel.org
X-Gm-Message-State: AOJu0YxgmbPKLrBCjmsaFltQhVN9cQKp0YtnpETHQ01QK64+txaAu5Av
	0lsjGsCqO8Kf+UDPYuPcqOy9iru4EcdNo8NfAIsbFFzafpkNgAjGUDsM8WGwLfPzTe+LGc+RhNU
	UiMFMJLnP+dcpNWVwg191J/75ck4uAbZrJvGDpMSwwhdqyb8BOGJOxcz1cmMgfw==
X-Gm-Gg: ASbGnctKnEARb+RBnWSFXngfyKEvKXIjtu+mebS7RqoHSBPsdX+sRQsokLBdQMKNqlW
	/UqPKipo8RvKcIST9+Xl8WfWBDqgK8ECBucr1dnM7kRXobTipRPahuL8uz/oz8bUUyUubWAGT8F
	8CFPy02rQ0k7H10i9l8JDyEFcUWe12zMWsLjkQS80Z2bR7LbsID02jYCP4Md5spanFnUYtfLjgs
	DvHgjhXr6cKPTZHE7izAqHKUuDvBU/mCPOQcsJ8gDP5wLB+u8+q+iZ/dGUVVd7m1wPtwJR7RXNd
	Fh6yhz4etyDvDi2MG2WH3P3co/0jQN8G7Z8CvF8etWkdjHuM3KrrptaaamZvKizJbCRcdkzpIxg
	f20skKEa6q4rFNM+OIJgwJ2ist4LeydD4t1rXTNmeoK+wtF9WOg==
X-Received: by 2002:a17:902:d48f:b0:295:24c3:8b49 with SMTP id d9443c01a7336-29b6bf5d77dmr449738545ad.46.1764650945942;
        Mon, 01 Dec 2025 20:49:05 -0800 (PST)
X-Google-Smtp-Source: AGHT+IG2u/cUF1izPuZbuy40mPYYnvxZy9wgLY4a0HYIl7i2nOzeKHEjO3khDLjZqam2/yI2UnxzEw==
X-Received: by 2002:a17:902:d48f:b0:295:24c3:8b49 with SMTP id d9443c01a7336-29b6bf5d77dmr449738415ad.46.1764650945449;
        Mon, 01 Dec 2025 20:49:05 -0800 (PST)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([209.132.188.88])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29bceb54563sm136176945ad.89.2025.12.01.20.49.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Dec 2025 20:49:04 -0800 (PST)
Date: Tue, 2 Dec 2025 12:49:00 +0800
From: Zorro Lang <zlang@redhat.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Zorro Lang <zlang@kernel.org>, "Darrick J. Wong" <djwong@kernel.org>,
	fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/3] xfs/158: _notrun when the file system can't be
 created
Message-ID: <20251202044900.rdahcmhpf2t3gulx@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
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

Hmm... is "try_scratch_mkfs" a function in your personal repo ?

> +	_notrun "invalid feature combination" >> $seqres.full
>  _scratch_xfs_admin -O inobtcount=1 2>> $seqres.full
>  _check_scratch_xfs_features INOBTCNT
>  
>  # Format V5 filesystem without inode btree counter support and populate it.
> -_scratch_mkfs -m crc=1,inobtcount=0 >> $seqres.full
> +_scratch_mkfs -m crc=1,inobtcount=0 || \
> +	_notrun "invalid feature combination" >> $seqres.full
>  _scratch_mount
>  
>  mkdir $SCRATCH_MNT/stress
> -- 
> 2.47.3
> 

