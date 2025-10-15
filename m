Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52BD8303CA4
	for <linux-xfs@vger.kernel.org>; Wed, 15 Oct 2025 06:52:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760511159; cv=none; b=EVpj8rL6TJUzx/4adFqzUPmsiRq95TsaZe4npwDf6ufTbLzHHDe3fCN3kSnk+VQDFZe6VY/34itT3XK9qwkYgrgVIzrlDgBue8K4wHPSKcZ1XByqMd0Isp2piswTnguhrnGqfDaW7PBvUXkL1/lBlfjaurmi/bKQQ2D+6JV8+8c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760511159; c=relaxed/simple;
	bh=XMpcesZ+XTitm1UG8rVvdQXz+sdpegio3GxZecVh1Rg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lQtGdd0+kGOMLnlU1WBmsUK4dXNxAaMDv7ZWLm5/eD9SzM6Stm2z0rN8FqrDB+c3SWSdl/dbY9v1gQzbsYAWvwB6C1ZsZwkAB3yUfiHg5NQVhvO9G7X0koX1GpVZF2tseVIVzwornn4TCXIceRBuzLNhngXai8KLLqkMpIULzoo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=aeLdok7q; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="aeLdok7q"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1760511156;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=A9reHZ473caRc+edawZ+46z/1YuvAJTFIbh7qXByHsI=;
	b=aeLdok7qnTjSWwN3TGiGo5Z/eySOB+86ewnlnnsW0TT74neaZgEq1kduLYVEzzgTMq4dnO
	kTYSAWgvzV+rGxNQ0qlQYkzOvCRY1ntdvEW5gElwHsFgm4sertuDsVYVkjTNlMI1fcITVx
	LrY6WfhhJg+4+Lnm6ogFIYrqh2YhovY=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-640-nQgaEJESMMumu6HQyFHvWw-1; Wed, 15 Oct 2025 02:52:34 -0400
X-MC-Unique: nQgaEJESMMumu6HQyFHvWw-1
X-Mimecast-MFC-AGG-ID: nQgaEJESMMumu6HQyFHvWw_1760511154
Received: by mail-qv1-f71.google.com with SMTP id 6a1803df08f44-78ea15d3583so269466736d6.1
        for <linux-xfs@vger.kernel.org>; Tue, 14 Oct 2025 23:52:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760511154; x=1761115954;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=A9reHZ473caRc+edawZ+46z/1YuvAJTFIbh7qXByHsI=;
        b=X9hOFEqHgmKMizNjRqG3B4oZ7QqEETaQZhsFRH5LNcBk5j4w8c4cKJGA6CmIosrnjp
         AOqN901ES4xAyCOcPx5+mDpi07m0VEu4leOdEEOyruLNYAdrmhUgCnwTnSmEuC+htlGF
         0Mi39b5B/Td6iTtXxiKQyspYTbY8kzXV2A/OOfvEcjR2zYCmqLXfDMCtirMG8n/HZJVv
         m9HZNWSSLRgm/Ne8wkiIEDW9v5Ieia45NCMwxwJ9Qqanuu0bkBMKeFK9CLnFAz1fDaOJ
         aj6+iXohAH9A7anOCAZylRiZBqetnvouN4drQ3A5O38GW17oPfsdRAmOKFJ8kQgFr+c1
         xakg==
X-Gm-Message-State: AOJu0YzIlfqhwZVtTZ3B7mmA1smOQVvlSHqjnr5mJHzloLWC/KskZmvB
	m7GvJSPTOZyUoaLTOZ1C+iJ+B70Z4QtKP7TEGeHG0dfr/jx1XU7hg+shvEf4Iz2wP5TJ5wqPkM+
	Xnw/022d0Pl1VnWimyNULxhBMnLygwJSxt2Cq7YxHAGhFfWJNWn8kX68a5uZxBWz3ZQm9MA==
X-Gm-Gg: ASbGncv1WC0eN/0xgC0djV6AZdEKJKllOx4lpKBaGLGWmp9PCdQWHLrMKfNE3OPDSNp
	cbJtZofMaslTGSXXVy9pK4iUTFql/z4hFzpiEuPb3eTqy9JcTuGWRs00LCRIB2tprYc6O4LsE+e
	+psnNhfYVPN7jw3HTjGHQVTy7D8ucA5CIqmegqnNL0PMXnkYPhJmgwfgK8cs6LTT6s0vRDctUhK
	o19SUoz+aycV0zqyIYY7pIuiuCCtDmTOkOrCBGW+IkiYxOVsRV8Zyco/28jBtUTMq+88PscsN8M
	TcwbfMn3v7sAWWEEPYyXqa917CpIRA5jwOr49pJv1WZq5txg1b9g+3riOpAPkCKMKI+Klq2JFKB
	z4Pygm8jPHrA=
X-Received: by 2002:ad4:5e8b:0:b0:7ef:f440:2b40 with SMTP id 6a1803df08f44-87b2ef94018mr418402746d6.53.1760511153734;
        Tue, 14 Oct 2025 23:52:33 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGr/anVWc9Amu1ipnyGbz7zFQc3IYS+TsMGDusLUj6Lk5hoMsJFLlLS69JjIQUHALqa79K/uA==
X-Received: by 2002:ad4:5e8b:0:b0:7ef:f440:2b40 with SMTP id 6a1803df08f44-87b2ef94018mr418402576d6.53.1760511153276;
        Tue, 14 Oct 2025 23:52:33 -0700 (PDT)
Received: from ?IPV6:2001:8003:4a36:e700:8cd:5151:364a:2095? ([2001:8003:4a36:e700:8cd:5151:364a:2095])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-87c012a2c6dsm13082096d6.46.2025.10.14.23.52.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Oct 2025 23:52:32 -0700 (PDT)
Message-ID: <c7ceb034-9d65-445c-8d3c-8e63a99115db@redhat.com>
Date: Wed, 15 Oct 2025 17:52:27 +1100
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mkfs.xfs fix sunit size on 512e and 4kN disks.
To: Lukas Herbolt <lukas@herbolt.com>, aalbersh@redhat.com, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
References: <20250926123829.2101207-2-lukas@herbolt.com>
Content-Language: en-US
From: Donald Douwsma <ddouwsma@redhat.com>
In-Reply-To: <20250926123829.2101207-2-lukas@herbolt.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 26/9/25 22:38, Lukas Herbolt wrote:
> Creating of XFS on 4kN or 512e disk result in suboptimal LSU/LSUNIT.
> As of now we check if the sectorsize is bigger than XLOG_HEADER_SIZE
> and so we set lsu to blocksize. But we do not check the the size if
> lsunit can be bigger to fit the disk geometry.
> 
> Before:
> modprobe scsi_debug inq_vendor=XFS_TEST physblk_exp=3 sector_size=512 \
> opt_xferlen_exp=9 opt_blks=512 dev_size_mb=100 virtual_gb=1000; \
> lsblk -tQ 'VENDOR == "XFS_TEST"'; \
> mkfs.xfs -f $(lsblk -Q 'VENDOR == "XFS_TEST"' -no path) 2>/dev/null; sleep 1; \
> modprobe -r scsi_debug
> NAME ALIGNMENT MIN-IO OPT-IO PHY-SEC LOG-SEC ROTA SCHED RQ-SIZE  RA WSAME
> sda          0 262144 262144    4096     512    0 bfq       256 512    0B
> meta-data=/dev/sda               isize=512    agcount=32, agsize=8192000 blks
>           =                       sectsz=4096  attr=2, projid32bit=1
>           =                       crc=1        finobt=1, sparse=1, rmapbt=1
>           =                       reflink=1    bigtime=1 inobtcount=1 nrext64=1
>           =                       exchange=0
> data     =                       bsize=4096   blocks=262144000, imaxpct=25
>           =                       sunit=64     swidth=64 blks
> naming   =version 2              bsize=4096   ascii-ci=0, ftype=1, parent=0
> log      =internal log           bsize=4096   blocks=128000, version=2
>           =                       sectsz=4096  sunit=1 blks, lazy-count=1
> realtime =none                   extsz=4096   blocks=0, rtextents=0
> 
> After:
> modprobe scsi_debug inq_vendor=XFS_TEST physblk_exp=3 sector_size=512 \
> opt_xferlen_exp=9 opt_blks=512 dev_size_mb=100 virtual_gb=1000; \
> lsblk -tQ 'VENDOR == "XFS_TEST"'; \
> mkfs.xfs -f $(lsblk -Q 'VENDOR == "XFS_TEST"' -no path) 2>/dev/null; sleep 1; \
> modprobe -r scsi_debug
> NAME ALIGNMENT MIN-IO OPT-IO PHY-SEC LOG-SEC ROTA SCHED RQ-SIZE  RA WSAME
> sda          0 262144 262144    4096     512    0 bfq       256 512    0B
> meta-data=/dev/sda               isize=512    agcount=32, agsize=8192000 blks
>           =                       sectsz=4096  attr=2, projid32bit=1
>           =                       crc=1        finobt=1, sparse=1, rmapbt=1
>           =                       reflink=1    bigtime=1 inobtcount=1 nrext64=1
>           =                       exchange=0   metadir=0
> data     =                       bsize=4096   blocks=262144000, imaxpct=25
>           =                       sunit=64     swidth=64 blks
> naming   =version 2              bsize=4096   ascii-ci=0, ftype=1, parent=0
> log      =internal log           bsize=4096   blocks=128000, version=2
>           =                       sectsz=4096  sunit=64 blks, lazy-count=1
> realtime =none                   extsz=4096   blocks=0, rtextents=0
>           =                       rgcount=0    rgsize=0 extents
>           =                       zoned=0      start=0 reserved=0
> 

Has it always been like this?

"2f44b1b0 mkfs: rework stripe calculations" changed a lot in this area,
but its harder to follow the code before the change.

> Signed-off-by: Lukas Herbolt <lukas@herbolt.com>
> ---
>   mkfs/xfs_mkfs.c | 4 ++++
>   1 file changed, 4 insertions(+)
> 
> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> index 8cd4ccd7..05268cd9 100644
> --- a/mkfs/xfs_mkfs.c
> +++ b/mkfs/xfs_mkfs.c
> @@ -3643,6 +3643,10 @@ check_lsunit:
>   		lsu = getnum(cli->lsu, &lopts, L_SU);
>   	else if (cfg->lsectorsize > XLOG_HEADER_SIZE)

Missing { ?                                           ^

>   		lsu = cfg->blocksize; /* lsunit matches filesystem block size */
> +		if (cfg->dsunit){
> +			cfg->lsunit = cfg->dsunit;
> +			lsu = 0;
> +		}

	}

>   
>   	if (lsu) {
>   		/* verify if lsu is a multiple block size */

