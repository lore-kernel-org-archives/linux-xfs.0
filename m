Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCBF622D4FE
	for <linux-xfs@vger.kernel.org>; Sun, 11 May 2025 14:13:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746972831; cv=none; b=tebVFwRWQDqawVo8CiVyNMgjbf54qZnPxVZDnur5oLz/pX/oG3n1Esltal6voJEKs2psB+dg5+BvlAR8dK6PD5+9J1mX1Nx0ii7QIpMewBLYXufqF5FiTiyuwTPW0RnKSPBCegnx6vyZE/CUK4Yma2AzyBH0mQITx3cSQrDT/OQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746972831; c=relaxed/simple;
	bh=fZ95Hs8cwmnoy4OSnmpVbzgSXqhB1fwRqRKAAuMQRwE=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=P+5s52d1Ub/+ysyGIunQiuzjjTU5XGTY6LhKBTRmw1SMy/0x3Eq2+k9Jdt7UA7qYeRWYWpuVlmGSeRzIsTtt+ArtVqaFxm07UNb74cs8olY6BN37XY5KtbNM8bmXsGR3aqv9HaHFYBFpe2ZQn+d+zYNigXDOPQe6CKqQJ7iLi6E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=I7zzNgXG; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="I7zzNgXG"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1746972826;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=i2sTCoD+3rcoULC7IhrnIDXG1lOhL/404Hw5RcdK11w=;
	b=I7zzNgXGLuDyfQ1qOAtIWYbjNH7CSVM+dbyGRHJbqw2utQtUO6+1JLHx8Uu71q7ht8JiQa
	QJLTC4U3Euh3TS4qToZ5fBLvxdLa+53GBVF2ABbHLS5shGx814wYcZP+miqT9fAKtSp8WH
	YlpN9YFAcjHlCTY9BTnRHilw1WhRr1Y=
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com
 [209.85.210.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-44-TObZX90KPRuaejo0NZtW9Q-1; Sun, 11 May 2025 10:13:43 -0400
X-MC-Unique: TObZX90KPRuaejo0NZtW9Q-1
X-Mimecast-MFC-AGG-ID: TObZX90KPRuaejo0NZtW9Q_1746972822
Received: by mail-pf1-f200.google.com with SMTP id d2e1a72fcca58-74244ba183cso1276836b3a.1
        for <linux-xfs@vger.kernel.org>; Sun, 11 May 2025 07:13:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746972822; x=1747577622;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=i2sTCoD+3rcoULC7IhrnIDXG1lOhL/404Hw5RcdK11w=;
        b=meWzNS5oa/wUP8hoEvho6oGixdkKPcCEywBH9BS87zM04w3qzi/CzYUum5D0TOQAZI
         o6klKwwY/BcZ3TMqPyhfqYJohStqhpvKg0aFdkTCvL46Vi0lyqqM1bVtpbuhBexyJZf1
         QvoksiyQLgzO/nNQ6I3YacuvkDVXFIe9HP0AR8QWVqiEfxeLDUwB2EQafNSTQMqM214e
         2yn7mDboYIxpvlPSyQoXNKzKzRBsRJsb7zFA/Q3EqkiC0VqnbT+QEZissEnTlM6OLOHG
         atYfpFz+ajzOXR/blPkY0oXbNJtBocQcszpw7SpRDndV4o94Xn42GgueICHh8v3lcui1
         YSoQ==
X-Gm-Message-State: AOJu0YyQhJz2j8NQyGbM5C+paE0mCfSxO5JcUtYHSCkvAdhIkzurnTAb
	WdlehLSb/YD2mApyMDP6T5McnxUfsSRjPnB0oGkSL9+9rpNkhNGaFaQ+dwhwX4Ca7IlA9BFLH00
	JlLocNjuneox0zMSftTL0+dwKyUpXkNLiK7WwroMC5839XwWMwX/+F870spsw/beABCaOzlgjiN
	+UgSWCAczXFRE7mi33pUpxFwx4aqFftlycZk5HJw==
X-Gm-Gg: ASbGncsvVz/Q8yduO7wHcXFDwQz7HPtq2fnuqE4HpN5i7JxT2Qg942XjLkjY/iWtlgI
	wI28Cwnv0HjiMLN2XOPQMrLZE7wrk+G2xInBbfvEsfZqZCE82xCAGG7QKKCdfypsHbzxSXSji5N
	hcI2XA1+VHk3KFnP1N2xTHOcpxjIg6Lwu6Vksg602syYuYOlrPZKK6c0D9oV+Zm0UQq2Bo1FVFT
	wBPV0+x0sIJKL/3sd4tSCW3kXu3DPoVjiFnKOvTsHymgmlAEpPEJSw/R0lD0Nf3GFRETQI3qBXJ
	tM9Vqfres48vpvWFbb90D6omLGrRqIi+SQUDuuRuxL3diYQkNTR6
X-Received: by 2002:a05:6a20:6f0e:b0:1f5:77ed:40b9 with SMTP id adf61e73a8af0-215abd23316mr15822232637.40.1746972821678;
        Sun, 11 May 2025 07:13:41 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEFVaNY86lSE3ZVjU3EjlMeJZixDpNzwT8wzM/NIJ+VG6xkGEobZhi2jBE7w/Jd+J5hR9sPHw==
X-Received: by 2002:a05:6a20:6f0e:b0:1f5:77ed:40b9 with SMTP id adf61e73a8af0-215abd23316mr15822182637.40.1746972820920;
        Sun, 11 May 2025 07:13:40 -0700 (PDT)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([209.132.188.88])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b234951024csm4197385a12.5.2025.05.11.07.13.39
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 May 2025 07:13:40 -0700 (PDT)
Date: Sun, 11 May 2025 22:13:37 +0800
From: Zorro Lang <zlang@redhat.com>
To: linux-xfs@vger.kernel.org
Subject: Re: [Bug report][xfstests g/735] xfs corruption
Message-ID: <20250511141337.eo6au3pa5yp7mauq@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <20250511135709.335cjvctemixkccn@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250511135709.335cjvctemixkccn@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>

On Sun, May 11, 2025 at 09:57:09PM +0800, Zorro Lang wrote:
> Hi,
> 
> Last xfstests regression test failed on xfs, generic/753 always hit a
> corruption [1], the whole .full output as [2]. I don't remember I hit
> this issue before.
> 
> I tested on mainline linux which HEAD=acaa3e726f4a29f32bca5146828565db56bc396f

Please ignore this report, Darrick has reminded that:
https://lore.kernel.org/fstests/20250508144737.GA2701446@frogsfrogsfrogs/

> 
> Thanks,
> Zorro
> 
> 
> [1]
> FSTYP         -- xfs (debug)
> PLATFORM      -- Linux/x86_64 sweetpig-16 6.15.0-rc5+ #1 SMP PREEMPT_DYNAMIC Thu May  8 21:32:46 EDT 2025
> MKFS_OPTIONS  -- -f /dev/vda3
> MOUNT_OPTIONS -- -o context=system_u:object_r:root_t:s0 /dev/vda3 /mnt/xfstests/scratch
> 
> generic/753       _check_xfs_filesystem: filesystem on /dev/vda3 is inconsistent (r)
> (see /var/lib/xfstests/results//generic/753.full for details)
> 
> Ran: generic/753
> Failures: generic/753
> Failed 1 of 1 tests
> 
> [2]
> meta-data=/dev/vda3              isize=512    agcount=4, agsize=983040 blks
>          =                       sectsz=512   attr=2, projid32bit=1
>          =                       crc=1        finobt=1, sparse=1, rmapbt=1
>          =                       reflink=1    bigtime=1 inobtcount=1 nrext64=1
>          =                       exchange=0   metadir=0
> data     =                       bsize=4096   blocks=3932160, imaxpct=25
>          =                       sunit=0      swidth=0 blks
> naming   =version 2              bsize=4096   ascii-ci=0, ftype=1, parent=0
> log      =internal log           bsize=4096   blocks=16384, version=2
>          =                       sectsz=512   sunit=0 blks, lazy-count=1
> realtime =none                   extsz=4096   blocks=0, rtextents=0
>          =                       rgcount=0    rgsize=0 extents
>          =                       zoned=0      start=0 reserved=0
> Discarding blocks...Done.
> device-mapper: remove ioctl on error-test.753  failed: No such device or address
> Command failed.
> echo '1' 2>&1 > /sys/fs/xfs/dm-0/error/fail_at_unmount
> echo '0' 2>&1 > /sys/fs/xfs/dm-0/error/metadata/EIO/max_retries
> echo '0' 2>&1 > /sys/fs/xfs/dm-0/error/metadata/EIO/retry_timeout_seconds
> fsstress: check_cwd stat64() returned -1 with errno: 5 (Input/output error)
> fsstress: check_cwd failure
> fsstress: check_cwd stat64() returned -1 with errno: 5 (Input/output error)
> fsstress: check_cwd failure
> fsstress: check_cwd stat64() returned -1 with errno: 5 (Input/output error)
> fsstress: check_cwd failure
> fsstress: check_cwd stat64() returned -1 with errno: 5 (Input/output error)
> fsstress: check_cwd failure
> fsstress killed (pid 1264750)
> fsstress killed (pid 1264752)
> fsstress killed (pid 1264753)
> fsstress killed (pid 1264754)
> fsstress killed (pid 1264755)
> -z -s 0 -m 31 -n 1 -p 1 \
> 
> seed = 1746688748
> echo '1' 2>&1 > /sys/fs/xfs/dm-0/error/fail_at_unmount
> echo '0' 2>&1 > /sys/fs/xfs/dm-0/error/metadata/EIO/max_retries
> echo '0' 2>&1 > /sys/fs/xfs/dm-0/error/metadata/EIO/retry_timeout_seconds
> fsstress: check_cwd stat64() returned -1 with errno: 5 (Input/output error)
> fsstress: check_cwd failure
> fsstress: check_cwd stat64() returned -1 with errno: 5 (Input/output error)
> fsstress: check_cwd failure
> fsstress: check_cwd stat64() returned -1 with errno: 5 (Input/output error)
> fsstress: check_cwd failure
> fsstress: check_cwd stat64() returned -1 with errno: 5 (Input/output error)
> fsstress: check_cwd failure
> fsstress killed (pid 1264831)
> fsstress killed (pid 1264833)
> fsstress killed (pid 1264834)
> fsstress killed (pid 1264835)
> fsstress killed (pid 1264836)
> -z -s 0 -m 31 -n 1 -p 1 \
> 
> seed = 1746555680
> echo '1' 2>&1 > /sys/fs/xfs/dm-0/error/fail_at_unmount
> echo '0' 2>&1 > /sys/fs/xfs/dm-0/error/metadata/EIO/max_retries
> echo '0' 2>&1 > /sys/fs/xfs/dm-0/error/metadata/EIO/retry_timeout_seconds
> fsstress: check_cwd stat64() returned -1 with errno: 5 (Input/output error)
> fsstress: check_cwd failure
> fsstress: check_cwd stat64() returned -1 with errno: 5 (Input/output error)
> fsstress: check_cwd failure
> fsstress: check_cwd stat64() returned -1 with errno: 5 (Input/output error)
> fsstress: check_cwd stat64() returned -1 with errno: 5 (Input/output error)
> fsstress: check_cwd failure
> fsstress: check_cwd failure
> fsstress killed (pid 1264917)
> fsstress killed (pid 1264919)
> fsstress killed (pid 1264920)
> fsstress killed (pid 1264921)
> fsstress killed (pid 1264922)
> -z -s 0 -m 31 -n 1 -p 1 \
> 
> seed = 1745956522
> echo '1' 2>&1 > /sys/fs/xfs/dm-0/error/fail_at_unmount
> echo '0' 2>&1 > /sys/fs/xfs/dm-0/error/metadata/EIO/max_retries
> echo '0' 2>&1 > /sys/fs/xfs/dm-0/error/metadata/EIO/retry_timeout_seconds
> fsstress: check_cwd stat64() returned -1 with errno: 5 (Input/output error)
> fsstress: check_cwd failure
> fsstress: check_cwd stat64() returned -1 with errno: 5 (Input/output error)
> fsstress: check_cwd failure
> fsstress: check_cwd stat64() returned -1 with errno: 5 (Input/output error)
> fsstress: check_cwd failure
> fsstress: check_cwd stat64() returned -1 with errno: 5 (Input/output error)
> fsstress: check_cwd failure
> fsstress killed (pid 1265000)
> fsstress killed (pid 1265002)
> fsstress killed (pid 1265003)
> fsstress killed (pid 1265004)
> fsstress killed (pid 1265005)
> -z -s 0 -m 31 -n 1 -p 1 \
> 
> seed = 1746792823
> echo '1' 2>&1 > /sys/fs/xfs/dm-0/error/fail_at_unmount
> echo '0' 2>&1 > /sys/fs/xfs/dm-0/error/metadata/EIO/max_retries
> echo '0' 2>&1 > /sys/fs/xfs/dm-0/error/metadata/EIO/retry_timeout_seconds
> fsstress: check_cwd stat64() returned -1 with errno: 5 (Input/output error)
> fsstress: check_cwd failure
> fsstress: check_cwd stat64() returned -1 with errno: 5 (Input/output error)
> fsstress: check_cwd failure
> fsstress: check_cwd stat64() returned -1 with errno: 5 (Input/output error)
> fsstress: check_cwd failure
> fsstress: check_cwd stat64() returned -1 with errno: 5 (Input/output error)
> fsstress: check_cwd failure
> fsstress killed (pid 1265082)
> fsstress killed (pid 1265084)
> fsstress killed (pid 1265085)
> fsstress killed (pid 1265086)
> fsstress killed (pid 1265087)
> -z -s 0 -m 31 -n 1 -p 1 \
> 
> seed = 1746309745
> echo '1' 2>&1 > /sys/fs/xfs/dm-0/error/fail_at_unmount
> echo '0' 2>&1 > /sys/fs/xfs/dm-0/error/metadata/EIO/max_retries
> echo '0' 2>&1 > /sys/fs/xfs/dm-0/error/metadata/EIO/retry_timeout_seconds
> fsstress: check_cwd stat64() returned -1 with errno: 5 (Input/output error)
> fsstress: check_cwd failure
> fsstress: check_cwd stat64() returned -1 with errno: 5 (Input/output error)
> fsstress: check_cwd failure
> fsstress: check_cwd stat64() returned -1 with errno: 5 (Input/output error)
> fsstress: check_cwd failure
> fsstress: check_cwd stat64() returned -1 with errno: 5 (Input/output error)
> fsstress: check_cwd failure
> fsstress killed (pid 1265164)
> fsstress killed (pid 1265166)
> fsstress killed (pid 1265167)
> fsstress killed (pid 1265168)
> fsstress killed (pid 1265169)
> -z -s 0 -m 31 -n 1 -p 1 \
> 
> seed = 1746209217
> echo '1' 2>&1 > /sys/fs/xfs/dm-0/error/fail_at_unmount
> echo '0' 2>&1 > /sys/fs/xfs/dm-0/error/metadata/EIO/max_retries
> echo '0' 2>&1 > /sys/fs/xfs/dm-0/error/metadata/EIO/retry_timeout_seconds
> fsstress: check_cwd stat64() returned -1 with errno: 5 (Input/output error)
> fsstress: check_cwd failure
> fsstress: check_cwd stat64() returned -1 with errno: 5 (Input/output error)
> fsstress: check_cwd failure
> fsstress: check_cwd stat64() returned -1 with errno: 5 (Input/output error)
> fsstress: check_cwd failure
> fsstress: check_cwd stat64() returned -1 with errno: 5 (Input/output error)
> fsstress: check_cwd failure
> fsstress killed (pid 1265251)
> fsstress killed (pid 1265253)
> fsstress killed (pid 1265254)
> fsstress killed (pid 1265255)
> fsstress killed (pid 1265256)
> -z -s 0 -m 31 -n 1 -p 1 \
> 
> seed = 1746364404
> echo '1' 2>&1 > /sys/fs/xfs/dm-0/error/fail_at_unmount
> echo '0' 2>&1 > /sys/fs/xfs/dm-0/error/metadata/EIO/max_retries
> echo '0' 2>&1 > /sys/fs/xfs/dm-0/error/metadata/EIO/retry_timeout_seconds
> fsstress: check_cwd stat64() returned -1 with errno: 5 (Input/output error)
> fsstress: check_cwd failure
> fsstress: check_cwd stat64() returned -1 with errno: 5 (Input/output error)
> fsstress: check_cwd failure
> fsstress: check_cwd stat64() returned -1 with errno: 5 (Input/output error)
> fsstress: check_cwd failure
> fsstress: check_cwd stat64() returned -1 with errno: 5 (Input/output error)
> fsstress: check_cwd failure
> fsstress killed (pid 1265333)
> fsstress killed (pid 1265336)
> fsstress killed (pid 1265337)
> fsstress killed (pid 1265338)
> fsstress killed (pid 1265339)
> -z -s 0 -m 31 -n 1 -p 1 \
> 
> seed = 1746436311
> echo '1' 2>&1 > /sys/fs/xfs/dm-0/error/fail_at_unmount
> echo '0' 2>&1 > /sys/fs/xfs/dm-0/error/metadata/EIO/max_retries
> echo '0' 2>&1 > /sys/fs/xfs/dm-0/error/metadata/EIO/retry_timeout_seconds
> fsstress: check_cwd stat64() returned -1 with errno: 5 (Input/output error)
> fsstress: check_cwd failure
> fsstress: check_cwd stat64() returned -1 with errno: 5 (Input/output error)
> fsstress: check_cwd failure
> fsstress: check_cwd stat64() returned -1 with errno: 5 (Input/output error)
> fsstress: check_cwd failure
> fsstress: check_cwd stat64() returned -1 with errno: 5 (Input/output error)
> fsstress: check_cwd failure
> fsstress killed (pid 1265415)
> fsstress killed (pid 1265417)
> fsstress killed (pid 1265419)
> fsstress killed (pid 1265420)
> fsstress killed (pid 1265421)
> -z -s 0 -m 31 -n 1 -p 1 \
> 
> seed = 1746759320
> echo '1' 2>&1 > /sys/fs/xfs/dm-0/error/fail_at_unmount
> echo '0' 2>&1 > /sys/fs/xfs/dm-0/error/metadata/EIO/max_retries
> echo '0' 2>&1 > /sys/fs/xfs/dm-0/error/metadata/EIO/retry_timeout_seconds
> fsstress: check_cwd stat64() returned -1 with errno: 5 (Input/output error)
> fsstress: check_cwd failure
> fsstress: check_cwd stat64() returned -1 with errno: 5 (Input/output error)
> fsstress: check_cwd failure
> fsstress: check_cwd stat64() returned -1 with errno: 5 (Input/output error)
> fsstress: check_cwd failure
> fsstress: check_cwd stat64() returned -1 with errno: 5 (Input/output error)
> fsstress: check_cwd failure
> fsstress killed (pid 1265497)
> fsstress killed (pid 1265500)
> fsstress killed (pid 1265501)
> fsstress killed (pid 1265502)
> fsstress killed (pid 1265503)
> -z -s 0 -m 31 -n 1 -p 1 \
> 
> seed = 1745946997
> echo '1' 2>&1 > /sys/fs/xfs/dm-0/error/fail_at_unmount
> echo '0' 2>&1 > /sys/fs/xfs/dm-0/error/metadata/EIO/max_retries
> echo '0' 2>&1 > /sys/fs/xfs/dm-0/error/metadata/EIO/retry_timeout_seconds
> fsstress: check_cwd stat64() returned -1 with errno: 5 (Input/output error)
> fsstress: check_cwd failure
> fsstress: check_cwd stat64() returned -1 with errno: 5 (Input/output error)
> fsstress: check_cwd stat64() returned -1 with errno: 5 (Input/output error)
> fsstress: check_cwd failure
> fsstress: check_cwd failure
> fsstress: check_cwd stat64() returned -1 with errno: 5 (Input/output error)
> fsstress: check_cwd failure
> fsstress killed (pid 1265579)
> fsstress killed (pid 1265581)
> fsstress killed (pid 1265583)
> fsstress killed (pid 1265584)
> fsstress killed (pid 1265585)
> -z -s 0 -m 31 -n 1 -p 1 \
> 
> seed = 1746180413
> echo '1' 2>&1 > /sys/fs/xfs/dm-0/error/fail_at_unmount
> echo '0' 2>&1 > /sys/fs/xfs/dm-0/error/metadata/EIO/max_retries
> echo '0' 2>&1 > /sys/fs/xfs/dm-0/error/metadata/EIO/retry_timeout_seconds
> fsstress: check_cwd stat64() returned -1 with errno: 5 (Input/output error)
> fsstress: check_cwd failure
> fsstress: check_cwd stat64() returned -1 with errno: 5 (Input/output error)
> fsstress: check_cwd failure
> fsstress: check_cwd stat64() returned -1 with errno: 5 (Input/output error)
> fsstress: check_cwd failure
> fsstress: check_cwd stat64() returned -1 with errno: 5 (Input/output error)
> fsstress: check_cwd failure
> fsstress killed (pid 1265661)
> fsstress killed (pid 1265663)
> fsstress killed (pid 1265664)
> fsstress killed (pid 1265665)
> fsstress killed (pid 1265666)
> -z -s 0 -m 31 -n 1 -p 1 \
> 
> seed = 1746750486
> echo '1' 2>&1 > /sys/fs/xfs/dm-0/error/fail_at_unmount
> echo '0' 2>&1 > /sys/fs/xfs/dm-0/error/metadata/EIO/max_retries
> echo '0' 2>&1 > /sys/fs/xfs/dm-0/error/metadata/EIO/retry_timeout_seconds
> fsstress: check_cwd stat64() returned -1 with errno: 5 (Input/output error)
> fsstress: check_cwd failure
> fsstress: check_cwd stat64() returned -1 with errno: 5 (Input/output error)
> fsstress: check_cwd failure
> fsstress: check_cwd stat64() returned -1 with errno: 5 (Input/output error)
> fsstress: check_cwd failure
> fsstress: check_cwd stat64() returned -1 with errno: 5 (Input/output error)
> fsstress: check_cwd failure
> fsstress killed (pid 1265747)
> fsstress killed (pid 1265749)
> fsstress killed (pid 1265750)
> fsstress killed (pid 1265752)
> fsstress killed (pid 1265753)
> -z -s 0 -m 31 -n 1 -p 1 \
> 
> seed = 1746034728
> echo '1' 2>&1 > /sys/fs/xfs/dm-0/error/fail_at_unmount
> echo '0' 2>&1 > /sys/fs/xfs/dm-0/error/metadata/EIO/max_retries
> echo '0' 2>&1 > /sys/fs/xfs/dm-0/error/metadata/EIO/retry_timeout_seconds
> fsstress: check_cwd stat64() returned -1 with errno: 5 (Input/output error)
> fsstress: check_cwd failure
> fsstress: check_cwd stat64() returned -1 with errno: 5 (Input/output error)
> fsstress: check_cwd failure
> fsstress: check_cwd stat64() returned -1 with errno: 5 (Input/output error)
> fsstress: check_cwd stat64() returned -1 with errno: 5 (Input/output error)
> fsstress: check_cwd failure
> fsstress: check_cwd failure
> fsstress killed (pid 1265829)
> fsstress killed (pid 1265831)
> fsstress killed (pid 1265832)
> fsstress killed (pid 1265833)
> fsstress killed (pid 1265835)
> -z -s 0 -m 31 -n 1 -p 1 \
> 
> seed = 1746227618
> echo '1' 2>&1 > /sys/fs/xfs/dm-0/error/fail_at_unmount
> echo '0' 2>&1 > /sys/fs/xfs/dm-0/error/metadata/EIO/max_retries
> echo '0' 2>&1 > /sys/fs/xfs/dm-0/error/metadata/EIO/retry_timeout_seconds
> fsstress: check_cwd stat64() returned -1 with errno: 5 (Input/output error)
> fsstress: check_cwd failure
> fsstress: check_cwd stat64() returned -1 with errno: 5 (Input/output error)
> fsstress: check_cwd failure
> fsstress: check_cwd stat64() returned -1 with errno: 5 (Input/output error)
> fsstress: check_cwd failure
> fsstress: check_cwd stat64() returned -1 with errno: 5 (Input/output error)
> fsstress: check_cwd failure
> fsstress killed (pid 1265911)
> fsstress killed (pid 1265913)
> fsstress killed (pid 1265914)
> fsstress killed (pid 1265915)
> fsstress killed (pid 1265916)
> -z -s 0 -m 31 -n 1 -p 1 \
> 
> seed = 1746443212
> echo '1' 2>&1 > /sys/fs/xfs/dm-0/error/fail_at_unmount
> echo '0' 2>&1 > /sys/fs/xfs/dm-0/error/metadata/EIO/max_retries
> echo '0' 2>&1 > /sys/fs/xfs/dm-0/error/metadata/EIO/retry_timeout_seconds
> fsstress: check_cwd stat64() returned -1 with errno: 5 (Input/output error)
> fsstress: check_cwd failure
> fsstress: check_cwd stat64() returned -1 with errno: 5 (Input/output error)
> fsstress: check_cwd failure
> fsstress: check_cwd stat64() returned -1 with errno: 5 (Input/output error)
> fsstress: check_cwd failure
> fsstress: check_cwd stat64() returned -1 with errno: 5 (Input/output error)
> fsstress: check_cwd failure
> fsstress killed (pid 1265993)
> fsstress killed (pid 1265995)
> fsstress killed (pid 1265996)
> fsstress killed (pid 1265997)
> fsstress killed (pid 1265998)
> -z -s 0 -m 31 -n 1 -p 1 \
> 
> seed = 1746823710
> echo '1' 2>&1 > /sys/fs/xfs/dm-0/error/fail_at_unmount
> echo '0' 2>&1 > /sys/fs/xfs/dm-0/error/metadata/EIO/max_retries
> echo '0' 2>&1 > /sys/fs/xfs/dm-0/error/metadata/EIO/retry_timeout_seconds
> fsstress: check_cwd stat64() returned -1 with errno: 5 (Input/output error)
> fsstress: check_cwd failure
> fsstress: check_cwd stat64() returned -1 with errno: 5 (Input/output error)
> fsstress: check_cwd failure
> fsstress: check_cwd stat64() returned -1 with errno: 5 (Input/output error)
> fsstress: check_cwd failure
> fsstress: check_cwd stat64() returned -1 with errno: 5 (Input/output error)
> fsstress: check_cwd failure
> fsstress killed (pid 1266079)
> fsstress killed (pid 1266082)
> fsstress killed (pid 1266083)
> fsstress killed (pid 1266084)
> fsstress killed (pid 1266085)
> -z -s 0 -m 31 -n 1 -p 1 \
> 
> seed = 1746130939
> echo '1' 2>&1 > /sys/fs/xfs/dm-0/error/fail_at_unmount
> echo '0' 2>&1 > /sys/fs/xfs/dm-0/error/metadata/EIO/max_retries
> echo '0' 2>&1 > /sys/fs/xfs/dm-0/error/metadata/EIO/retry_timeout_seconds
> fsstress: check_cwd stat64() returned -1 with errno: 5 (Input/output error)
> fsstress: check_cwd failure
> fsstress: check_cwd stat64() returned -1 with errno: 5 (Input/output error)
> fsstress: check_cwd failure
> fsstress: check_cwd stat64() returned -1 with errno: 5 (Input/output error)
> fsstress: check_cwd failure
> fsstress: check_cwd stat64() returned -1 with errno: 5 (Input/output error)
> fsstress: check_cwd failure
> fsstress killed (pid 1266161)
> fsstress killed (pid 1266164)
> fsstress killed (pid 1266165)
> fsstress killed (pid 1266166)
> fsstress killed (pid 1266167)
> -z -s 0 -m 31 -n 1 -p 1 \
> 
> seed = 1746370420
> echo '1' 2>&1 > /sys/fs/xfs/dm-0/error/fail_at_unmount
> echo '0' 2>&1 > /sys/fs/xfs/dm-0/error/metadata/EIO/max_retries
> echo '0' 2>&1 > /sys/fs/xfs/dm-0/error/metadata/EIO/retry_timeout_seconds
> fsstress: check_cwd stat64() returned -1 with errno: 5 (Input/output error)
> fsstress: check_cwd failure
> fsstress: check_cwd stat64() returned -1 with errno: 5 (Input/output error)
> fsstress: check_cwd failure
> fsstress: check_cwd stat64() returned -1 with errno: 5 (Input/output error)
> fsstress: check_cwd failure
> fsstress: check_cwd stat64() returned -1 with errno: 5 (Input/output error)
> fsstress: check_cwd failure
> fsstress killed (pid 1266244)
> fsstress killed (pid 1266246)
> fsstress killed (pid 1266248)
> fsstress killed (pid 1266249)
> fsstress killed (pid 1266250)
> -z -s 0 -m 31 -n 1 -p 1 \
> 
> seed = 1746456120
> echo '1' 2>&1 > /sys/fs/xfs/dm-0/error/fail_at_unmount
> echo '0' 2>&1 > /sys/fs/xfs/dm-0/error/metadata/EIO/max_retries
> echo '0' 2>&1 > /sys/fs/xfs/dm-0/error/metadata/EIO/retry_timeout_seconds
> fsstress: check_cwd stat64() returned -1 with errno: 5 (Input/output error)
> fsstress: check_cwd stat64() returned -1 with errno: 5 (Input/output error)
> fsstress: check_cwd failure
> fsstress: check_cwd failure
> fsstress: check_cwd stat64() returned -1 with errno: 5 (Input/output error)
> fsstress: check_cwd failure
> fsstress: check_cwd stat64() returned -1 with errno: 5 (Input/output error)
> fsstress: check_cwd failure
> fsstress killed (pid 1266326)
> fsstress killed (pid 1266328)
> fsstress killed (pid 1266329)
> fsstress killed (pid 1266330)
> fsstress killed (pid 1266331)
> -z -s 0 -m 31 -n 1 -p 1 \
> 
> seed = 1745918452
> echo '1' 2>&1 > /sys/fs/xfs/dm-0/error/fail_at_unmount
> echo '0' 2>&1 > /sys/fs/xfs/dm-0/error/metadata/EIO/max_retries
> echo '0' 2>&1 > /sys/fs/xfs/dm-0/error/metadata/EIO/retry_timeout_seconds
> fsstress: check_cwd stat64() returned -1 with errno: 5 (Input/output error)
> fsstress: check_cwd failure
> fsstress: check_cwd stat64() returned -1 with errno: 5 (Input/output error)
> fsstress: check_cwd failure
> fsstress: check_cwd stat64() returned -1 with errno: 5 (Input/output error)
> fsstress: check_cwd failure
> fsstress: check_cwd stat64() returned -1 with errno: 5 (Input/output error)
> fsstress: check_cwd failure
> fsstress killed (pid 1266408)
> fsstress killed (pid 1266410)
> fsstress killed (pid 1266411)
> fsstress killed (pid 1266413)
> fsstress killed (pid 1266414)
> -z -s 0 -m 31 -n 1 -p 1 \
> 
> seed = 1746520497
> echo '1' 2>&1 > /sys/fs/xfs/dm-0/error/fail_at_unmount
> echo '0' 2>&1 > /sys/fs/xfs/dm-0/error/metadata/EIO/max_retries
> echo '0' 2>&1 > /sys/fs/xfs/dm-0/error/metadata/EIO/retry_timeout_seconds
> fsstress: check_cwd stat64() returned -1 with errno: 5 (Input/output error)
> fsstress: check_cwd failure
> fsstress: check_cwd stat64() returned -1 with errno: 5 (Input/output error)
> fsstress: check_cwd failure
> fsstress: check_cwd stat64() returned -1 with errno: 5 (Input/output error)
> fsstress: check_cwd failure
> fsstress: check_cwd stat64() returned -1 with errno: 5 (Input/output error)
> fsstress: check_cwd failure
> fsstress killed (pid 1266490)
> fsstress killed (pid 1266492)
> fsstress killed (pid 1266493)
> fsstress killed (pid 1266495)
> fsstress killed (pid 1266496)
> -z -s 0 -m 31 -n 1 -p 1 \
> 
> seed = 1746589677
> echo '1' 2>&1 > /sys/fs/xfs/dm-0/error/fail_at_unmount
> echo '0' 2>&1 > /sys/fs/xfs/dm-0/error/metadata/EIO/max_retries
> echo '0' 2>&1 > /sys/fs/xfs/dm-0/error/metadata/EIO/retry_timeout_seconds
> fsstress: check_cwd stat64() returned -1 with errno: 5 (Input/output error)
> fsstress: check_cwd failure
> fsstress: check_cwd stat64() returned -1 with errno: 5 (Input/output error)
> fsstress: check_cwd failure
> fsstress: check_cwd stat64() returned -1 with errno: 5 (Input/output error)
> fsstress: check_cwd failure
> fsstress: check_cwd stat64() returned -1 with errno: 5 (Input/output error)
> fsstress: check_cwd failure
> fsstress killed (pid 1266572)
> fsstress killed (pid 1266574)
> fsstress killed (pid 1266575)
> fsstress killed (pid 1266576)
> fsstress killed (pid 1266577)
> -z -s 0 -m 31 -n 1 -p 1 \
> 
> seed = 1745897117
> echo '1' 2>&1 > /sys/fs/xfs/dm-0/error/fail_at_unmount
> echo '0' 2>&1 > /sys/fs/xfs/dm-0/error/metadata/EIO/max_retries
> echo '0' 2>&1 > /sys/fs/xfs/dm-0/error/metadata/EIO/retry_timeout_seconds
> fsstress: check_cwd stat64() returned -1 with errno: 5 (Input/output error)
> fsstress: check_cwd failure
> fsstress: check_cwd stat64() returned -1 with errno: 5 (Input/output error)
> fsstress: check_cwd failure
> fsstress: check_cwd stat64() returned -1 with errno: 5 (Input/output error)
> fsstress: check_cwd failure
> fsstress: check_cwd stat64() returned -1 with errno: 5 (Input/output error)
> fsstress: check_cwd failure
> fsstress killed (pid 1266658)
> fsstress killed (pid 1266660)
> fsstress killed (pid 1266661)
> fsstress killed (pid 1266662)
> fsstress killed (pid 1266663)
> -z -s 0 -m 31 -n 1 -p 1 \
> 
> seed = 1746210086
> echo '1' 2>&1 > /sys/fs/xfs/dm-0/error/fail_at_unmount
> echo '0' 2>&1 > /sys/fs/xfs/dm-0/error/metadata/EIO/max_retries
> echo '0' 2>&1 > /sys/fs/xfs/dm-0/error/metadata/EIO/retry_timeout_seconds
> fsstress: check_cwd stat64() returned -1 with errno: 5 (Input/output error)
> fsstress: check_cwd failure
> fsstress: check_cwd stat64() returned -1 with errno: 5 (Input/output error)
> fsstress: check_cwd failure
> fsstress: check_cwd stat64() returned -1 with errno: 5 (Input/output error)
> fsstress: check_cwd stat64() returned -1 with errno: 5 (Input/output error)
> fsstress: check_cwd failure
> fsstress: check_cwd failure
> fsstress killed (pid 1266741)
> fsstress killed (pid 1266743)
> fsstress killed (pid 1266744)
> fsstress killed (pid 1266746)
> fsstress killed (pid 1266747)
> -z -s 0 -m 31 -n 1 -p 1 \
> 
> seed = 1746573078
> echo '1' 2>&1 > /sys/fs/xfs/dm-0/error/fail_at_unmount
> echo '0' 2>&1 > /sys/fs/xfs/dm-0/error/metadata/EIO/max_retries
> echo '0' 2>&1 > /sys/fs/xfs/dm-0/error/metadata/EIO/retry_timeout_seconds
> fsstress: check_cwd stat64() returned -1 with errno: 5 (Input/output error)
> fsstress: check_cwd failure
> fsstress: check_cwd stat64() returned -1 with errno: 5 (Input/output error)
> fsstress: check_cwd failure
> fsstress: check_cwd stat64() returned -1 with errno: 5 (Input/output error)
> fsstress: check_cwd failure
> fsstress: check_cwd stat64() returned -1 with errno: 5 (Input/output error)
> fsstress: check_cwd failure
> fsstress killed (pid 1266823)
> fsstress killed (pid 1266826)
> fsstress killed (pid 1266827)
> fsstress killed (pid 1266828)
> fsstress killed (pid 1266829)
> -z -s 0 -m 31 -n 1 -p 1 \
> 
> seed = 1746171555
> echo '1' 2>&1 > /sys/fs/xfs/dm-0/error/fail_at_unmount
> echo '0' 2>&1 > /sys/fs/xfs/dm-0/error/metadata/EIO/max_retries
> echo '0' 2>&1 > /sys/fs/xfs/dm-0/error/metadata/EIO/retry_timeout_seconds
> fsstress: check_cwd stat64() returned -1 with errno: 5 (Input/output error)
> fsstress: check_cwd failure
> fsstress: check_cwd stat64() returned -1 with errno: 5 (Input/output error)
> fsstress: check_cwd failure
> fsstress: check_cwd stat64() returned -1 with errno: 5 (Input/output error)
> fsstress: check_cwd failure
> fsstress: check_cwd stat64() returned -1 with errno: 5 (Input/output error)
> fsstress: check_cwd failure
> fsstress killed (pid 1266905)
> fsstress killed (pid 1266907)
> fsstress killed (pid 1266908)
> fsstress killed (pid 1266909)
> fsstress killed (pid 1266910)
> -z -s 0 -m 31 -n 1 -p 1 \
> 
> seed = 1745904163
> echo '1' 2>&1 > /sys/fs/xfs/dm-0/error/fail_at_unmount
> echo '0' 2>&1 > /sys/fs/xfs/dm-0/error/metadata/EIO/max_retries
> echo '0' 2>&1 > /sys/fs/xfs/dm-0/error/metadata/EIO/retry_timeout_seconds
> fsstress: check_cwd stat64() returned -1 with errno: 5 (Input/output error)
> fsstress: check_cwd failure
> fsstress: check_cwd stat64() returned -1 with errno: 5 (Input/output error)
> fsstress: check_cwd failure
> fsstress: check_cwd stat64() returned -1 with errno: 5 (Input/output error)
> fsstress: check_cwd failure
> fsstress: check_cwd stat64() returned -1 with errno: 5 (Input/output error)
> fsstress: check_cwd failure
> fsstress killed (pid 1266987)
> fsstress killed (pid 1266989)
> fsstress killed (pid 1266990)
> fsstress killed (pid 1266991)
> fsstress killed (pid 1266992)
> -z -s 0 -m 31 -n 1 -p 1 \
> 
> seed = 1746616681
> echo '1' 2>&1 > /sys/fs/xfs/dm-0/error/fail_at_unmount
> echo '0' 2>&1 > /sys/fs/xfs/dm-0/error/metadata/EIO/max_retries
> echo '0' 2>&1 > /sys/fs/xfs/dm-0/error/metadata/EIO/retry_timeout_seconds
> fsstress: check_cwd stat64() returned -1 with errno: 5 (Input/output error)
> fsstress: check_cwd failure
> fsstress: check_cwd stat64() returned -1 with errno: 5 (Input/output error)
> fsstress: check_cwd failure
> fsstress: check_cwd stat64() returned -1 with errno: 5 (Input/output error)
> fsstress: check_cwd failure
> fsstress: check_cwd stat64() returned -1 with errno: 5 (Input/output error)
> fsstress: check_cwd failure
> fsstress killed (pid 1267069)
> fsstress killed (pid 1267071)
> fsstress killed (pid 1267072)
> fsstress killed (pid 1267073)
> fsstress killed (pid 1267074)
> -z -s 0 -m 31 -n 1 -p 1 \
> 
> seed = 1746033108
> echo '1' 2>&1 > /sys/fs/xfs/dm-0/error/fail_at_unmount
> echo '0' 2>&1 > /sys/fs/xfs/dm-0/error/metadata/EIO/max_retries
> echo '0' 2>&1 > /sys/fs/xfs/dm-0/error/metadata/EIO/retry_timeout_seconds
> fsstress: check_cwd stat64() returned -1 with errno: 5 (Input/output error)
> fsstress: check_cwd failure
> fsstress: check_cwd stat64() returned -1 with errno: 5 (Input/output error)
> fsstress: check_cwd failure
> fsstress: check_cwd stat64() returned -1 with errno: 5 (Input/output error)
> fsstress: check_cwd failure
> fsstress: check_cwd stat64() returned -1 with errno: 5 (Input/output error)
> fsstress: check_cwd failure
> fsstress killed (pid 1267155)
> fsstress killed (pid 1267157)
> fsstress killed (pid 1267158)
> fsstress killed (pid 1267159)
> fsstress killed (pid 1267160)
> -z -s 0 -m 31 -n 1 -p 1 \
> 
> seed = 1746550925
> echo '1' 2>&1 > /sys/fs/xfs/dm-0/error/fail_at_unmount
> echo '0' 2>&1 > /sys/fs/xfs/dm-0/error/metadata/EIO/max_retries
> echo '0' 2>&1 > /sys/fs/xfs/dm-0/error/metadata/EIO/retry_timeout_seconds
> fsstress: check_cwd stat64() returned -1 with errno: 5 (Input/output error)
> fsstress: check_cwd failure
> fsstress: check_cwd stat64() returned -1 with errno: 5 (Input/output error)
> fsstress: check_cwd failure
> fsstress: check_cwd stat64() returned -1 with errno: 5 (Input/output error)
> fsstress: check_cwd failure
> fsstress: check_cwd stat64() returned -1 with errno: 5 (Input/output error)
> fsstress: check_cwd failure
> fsstress killed (pid 1267240)
> fsstress killed (pid 1267243)
> fsstress killed (pid 1267244)
> fsstress killed (pid 1267245)
> fsstress killed (pid 1267246)
> -z -s 0 -m 31 -n 1 -p 1 \
> 
> seed = 1746914402
> echo '1' 2>&1 > /sys/fs/xfs/dm-0/error/fail_at_unmount
> echo '0' 2>&1 > /sys/fs/xfs/dm-0/error/metadata/EIO/max_retries
> echo '0' 2>&1 > /sys/fs/xfs/dm-0/error/metadata/EIO/retry_timeout_seconds
> fsstress: check_cwd stat64() returned -1 with errno: 5 (Input/output error)
> fsstress: check_cwd failure
> fsstress: check_cwd stat64() returned -1 with errno: 5 (Input/output error)
> fsstress: check_cwd failure
> fsstress: check_cwd stat64() returned -1 with errno: 5 (Input/output error)
> fsstress: check_cwd failure
> fsstress: check_cwd stat64() returned -1 with errno: 5 (Input/output error)
> fsstress: check_cwd failure
> fsstress killed (pid 1267322)
> fsstress killed (pid 1267324)
> fsstress killed (pid 1267326)
> fsstress killed (pid 1267327)
> fsstress killed (pid 1267328)
> -z -s 0 -m 31 -n 1 -p 1 \
> 
> seed = 1746135592
> echo '1' 2>&1 > /sys/fs/xfs/dm-0/error/fail_at_unmount
> echo '0' 2>&1 > /sys/fs/xfs/dm-0/error/metadata/EIO/max_retries
> echo '0' 2>&1 > /sys/fs/xfs/dm-0/error/metadata/EIO/retry_timeout_seconds
> fsstress: check_cwd stat64() returned -1 with errno: 5 (Input/output error)
> fsstress: check_cwd failure
> fsstress: check_cwd stat64() returned -1 with errno: 5 (Input/output error)
> fsstress: check_cwd failure
> fsstress: check_cwd stat64() returned -1 with errno: 5 (Input/output error)
> fsstress: check_cwd failure
> fsstress: check_cwd stat64() returned -1 with errno: 5 (Input/output error)
> fsstress: check_cwd failure
> fsstress killed (pid 1267406)
> fsstress killed (pid 1267409)
> fsstress killed (pid 1267410)
> fsstress killed (pid 1267411)
> fsstress killed (pid 1267412)
> -z -s 0 -m 31 -n 1 -p 1 \
> 
> seed = 1746161041
> echo '1' 2>&1 > /sys/fs/xfs/dm-0/error/fail_at_unmount
> echo '0' 2>&1 > /sys/fs/xfs/dm-0/error/metadata/EIO/max_retries
> echo '0' 2>&1 > /sys/fs/xfs/dm-0/error/metadata/EIO/retry_timeout_seconds
> fsstress: check_cwd stat64() returned -1 with errno: 5 (Input/output error)
> fsstress: check_cwd failure
> fsstress: check_cwd stat64() returned -1 with errno: 5 (Input/output error)
> fsstress: check_cwd failure
> fsstress: check_cwd stat64() returned -1 with errno: 5 (Input/output error)
> fsstress: check_cwd failure
> fsstress: check_cwd stat64() returned -1 with errno: 5 (Input/output error)
> fsstress: check_cwd failure
> fsstress killed (pid 1267488)
> fsstress killed (pid 1267491)
> fsstress killed (pid 1267492)
> fsstress killed (pid 1267493)
> fsstress killed (pid 1267494)
> -z -s 0 -m 31 -n 1 -p 1 \
> 
> seed = 1746452657
> echo '1' 2>&1 > /sys/fs/xfs/dm-0/error/fail_at_unmount
> echo '0' 2>&1 > /sys/fs/xfs/dm-0/error/metadata/EIO/max_retries
> echo '0' 2>&1 > /sys/fs/xfs/dm-0/error/metadata/EIO/retry_timeout_seconds
> fsstress: check_cwd stat64() returned -1 with errno: 5 (Input/output error)
> fsstress: check_cwd stat64() returned -1 with errno: 5 (Input/output error)
> fsstress: check_cwd failure
> fsstress: check_cwd failure
> fsstress: check_cwd stat64() returned -1 with errno: 5 (Input/output error)
> fsstress: check_cwd failure
> fsstress: check_cwd stat64() returned -1 with errno: 5 (Input/output error)
> fsstress: check_cwd failure
> fsstress killed (pid 1267570)
> fsstress killed (pid 1267573)
> fsstress killed (pid 1267574)
> fsstress killed (pid 1267575)
> fsstress killed (pid 1267576)
> -z -s 0 -m 31 -n 1 -p 1 \
> 
> seed = 1746627778
> echo '1' 2>&1 > /sys/fs/xfs/dm-0/error/fail_at_unmount
> echo '0' 2>&1 > /sys/fs/xfs/dm-0/error/metadata/EIO/max_retries
> echo '0' 2>&1 > /sys/fs/xfs/dm-0/error/metadata/EIO/retry_timeout_seconds
> fsstress: check_cwd stat64() returned -1 with errno: 5 (Input/output error)
> fsstress: check_cwd failure
> fsstress: check_cwd stat64() returned -1 with errno: 5 (Input/output error)
> fsstress: check_cwd failure
> fsstress: check_cwd stat64() returned -1 with errno: 5 (Input/output error)
> fsstress: check_cwd failure
> fsstress: check_cwd stat64() returned -1 with errno: 5 (Input/output error)
> fsstress: check_cwd failure
> fsstress killed (pid 1267652)
> fsstress killed (pid 1267654)
> fsstress killed (pid 1267655)
> fsstress killed (pid 1267656)
> fsstress killed (pid 1267657)
> -z -s 0 -m 31 -n 1 -p 1 \
> 
> seed = 1746736379
> echo '1' 2>&1 > /sys/fs/xfs/dm-0/error/fail_at_unmount
> echo '0' 2>&1 > /sys/fs/xfs/dm-0/error/metadata/EIO/max_retries
> echo '0' 2>&1 > /sys/fs/xfs/dm-0/error/metadata/EIO/retry_timeout_seconds
> fsstress: check_cwd stat64() returned -1 with errno: 5 (Input/output error)
> fsstress: check_cwd failure
> fsstress: check_cwd stat64() returned -1 with errno: 5 (Input/output error)
> fsstress: check_cwd failure
> fsstress: check_cwd stat64() returned -1 with errno: 5 (Input/output error)
> fsstress: check_cwd failure
> fsstress: check_cwd stat64() returned -1 with errno: 5 (Input/output error)
> fsstress: check_cwd failure
> fsstress killed (pid 1267738)
> fsstress killed (pid 1267740)
> fsstress killed (pid 1267741)
> fsstress killed (pid 1267742)
> fsstress killed (pid 1267743)
> -z -s 0 -m 31 -n 1 -p 1 \
> 
> seed = 1746685789
> echo '1' 2>&1 > /sys/fs/xfs/dm-0/error/fail_at_unmount
> echo '0' 2>&1 > /sys/fs/xfs/dm-0/error/metadata/EIO/max_retries
> echo '0' 2>&1 > /sys/fs/xfs/dm-0/error/metadata/EIO/retry_timeout_seconds
> fsstress: check_cwd stat64() returned -1 with errno: 5 (Input/output error)
> fsstress: check_cwd failure
> fsstress: check_cwd stat64() returned -1 with errno: 5 (Input/output error)
> fsstress: check_cwd failure
> fsstress: check_cwd stat64() returned -1 with errno: 5 (Input/output error)
> fsstress: check_cwd failure
> fsstress: check_cwd stat64() returned -1 with errno: 5 (Input/output error)
> fsstress: check_cwd failure
> fsstress killed (pid 1267821)
> fsstress killed (pid 1267824)
> fsstress killed (pid 1267825)
> fsstress killed (pid 1267826)
> fsstress killed (pid 1267827)
> -z -s 0 -m 31 -n 1 -p 1 \
> 
> seed = 1746814468
> echo '1' 2>&1 > /sys/fs/xfs/dm-0/error/fail_at_unmount
> echo '0' 2>&1 > /sys/fs/xfs/dm-0/error/metadata/EIO/max_retries
> echo '0' 2>&1 > /sys/fs/xfs/dm-0/error/metadata/EIO/retry_timeout_seconds
> fsstress: check_cwd stat64() returned -1 with errno: 5 (Input/output error)
> fsstress: check_cwd failure
> fsstress: check_cwd stat64() returned -1 with errno: 5 (Input/output error)
> fsstress: check_cwd failure
> fsstress: check_cwd stat64() returned -1 with errno: 5 (Input/output error)
> fsstress: check_cwd failure
> fsstress: check_cwd stat64() returned -1 with errno: 5 (Input/output error)
> fsstress: check_cwd failure
> fsstress killed (pid 1267903)
> fsstress killed (pid 1267905)
> fsstress killed (pid 1267907)
> fsstress killed (pid 1267908)
> fsstress killed (pid 1267909)
> -z -s 0 -m 31 -n 1 -p 1 \
> 
> seed = 1746023245
> echo '1' 2>&1 > /sys/fs/xfs/dm-0/error/fail_at_unmount
> echo '0' 2>&1 > /sys/fs/xfs/dm-0/error/metadata/EIO/max_retries
> echo '0' 2>&1 > /sys/fs/xfs/dm-0/error/metadata/EIO/retry_timeout_seconds
> fsstress: check_cwd stat64() returned -1 with errno: 5 (Input/output error)
> fsstress: check_cwd failure
> fsstress: check_cwd stat64() returned -1 with errno: 5 (Input/output error)
> fsstress: check_cwd failure
> fsstress: check_cwd stat64() returned -1 with errno: 5 (Input/output error)
> fsstress: check_cwd failure
> fsstress: check_cwd stat64() returned -1 with errno: 5 (Input/output error)
> fsstress: check_cwd failure
> fsstress killed (pid 1267985)
> fsstress killed (pid 1267987)
> fsstress killed (pid 1267988)
> fsstress killed (pid 1267989)
> fsstress killed (pid 1267990)
> -z -s 0 -m 31 -n 1 -p 1 \
> 
> seed = 1746322018
> echo '1' 2>&1 > /sys/fs/xfs/dm-0/error/fail_at_unmount
> echo '0' 2>&1 > /sys/fs/xfs/dm-0/error/metadata/EIO/max_retries
> echo '0' 2>&1 > /sys/fs/xfs/dm-0/error/metadata/EIO/retry_timeout_seconds
> fsstress: check_cwd stat64() returned -1 with errno: 5 (Input/output error)
> fsstress: check_cwd failure
> fsstress: check_cwd stat64() returned -1 with errno: 5 (Input/output error)
> fsstress: check_cwd failure
> fsstress: check_cwd stat64() returned -1 with errno: 5 (Input/output error)
> fsstress: check_cwd failure
> fsstress: check_cwd stat64() returned -1 with errno: 5 (Input/output error)
> fsstress: check_cwd failure
> fsstress killed (pid 1268072)
> fsstress killed (pid 1268075)
> fsstress killed (pid 1268076)
> fsstress killed (pid 1268077)
> fsstress killed (pid 1268078)
> -z -s 0 -m 31 -n 1 -p 1 \
> 
> seed = 1746355717
> echo '1' 2>&1 > /sys/fs/xfs/dm-0/error/fail_at_unmount
> echo '0' 2>&1 > /sys/fs/xfs/dm-0/error/metadata/EIO/max_retries
> echo '0' 2>&1 > /sys/fs/xfs/dm-0/error/metadata/EIO/retry_timeout_seconds
> fsstress: check_cwd stat64() returned -1 with errno: 5 (Input/output error)
> fsstress: check_cwd failure
> fsstress: check_cwd stat64() returned -1 with errno: 5 (Input/output error)
> fsstress: check_cwd failure
> fsstress: check_cwd stat64() returned -1 with errno: 5 (Input/output error)
> fsstress: check_cwd failure
> fsstress: check_cwd stat64() returned -1 with errno: 5 (Input/output error)
> fsstress: check_cwd failure
> fsstress killed (pid 1268154)
> fsstress killed (pid 1268156)
> fsstress killed (pid 1268157)
> fsstress killed (pid 1268158)
> fsstress killed (pid 1268159)
> -z -s 0 -m 31 -n 1 -p 1 \
> 
> seed = 1746553455
> echo '1' 2>&1 > /sys/fs/xfs/dm-0/error/fail_at_unmount
> echo '0' 2>&1 > /sys/fs/xfs/dm-0/error/metadata/EIO/max_retries
> echo '0' 2>&1 > /sys/fs/xfs/dm-0/error/metadata/EIO/retry_timeout_seconds
> fsstress: check_cwd stat64() returned -1 with errno: 5 (Input/output error)
> fsstress: check_cwd failure
> fsstress: check_cwd stat64() returned -1 with errno: 5 (Input/output error)
> fsstress: check_cwd failure
> fsstress: check_cwd stat64() returned -1 with errno: 5 (Input/output error)
> fsstress: check_cwd failure
> fsstress: check_cwd stat64() returned -1 with errno: 5 (Input/output error)
> fsstress: check_cwd failure
> fsstress killed (pid 1268239)
> fsstress killed (pid 1268241)
> fsstress killed (pid 1268242)
> fsstress killed (pid 1268243)
> fsstress killed (pid 1268244)
> -z -s 0 -m 31 -n 1 -p 1 \
> 
> seed = 1746689401
> echo '1' 2>&1 > /sys/fs/xfs/dm-0/error/fail_at_unmount
> echo '0' 2>&1 > /sys/fs/xfs/dm-0/error/metadata/EIO/max_retries
> echo '0' 2>&1 > /sys/fs/xfs/dm-0/error/metadata/EIO/retry_timeout_seconds
> fsstress: check_cwd stat64() returned -1 with errno: 5 (Input/output error)
> fsstress: check_cwd failure
> fsstress: check_cwd stat64() returned -1 with errno: 5 (Input/output error)
> fsstress: check_cwd failure
> fsstress: check_cwd stat64() returned -1 with errno: 5 (Input/output error)
> fsstress: check_cwd failure
> fsstress: check_cwd stat64() returned -1 with errno: 5 (Input/output error)
> fsstress: check_cwd failure
> fsstress killed (pid 1268321)
> fsstress killed (pid 1268323)
> fsstress killed (pid 1268324)
> fsstress killed (pid 1268325)
> fsstress killed (pid 1268326)
> -z -s 0 -m 31 -n 1 -p 1 \
> 
> seed = 1746048220
> echo '1' 2>&1 > /sys/fs/xfs/dm-0/error/fail_at_unmount
> echo '0' 2>&1 > /sys/fs/xfs/dm-0/error/metadata/EIO/max_retries
> echo '0' 2>&1 > /sys/fs/xfs/dm-0/error/metadata/EIO/retry_timeout_seconds
> fsstress: check_cwd stat64() returned -1 with errno: 5 (Input/output error)
> fsstress: check_cwd failure
> fsstress: check_cwd stat64() returned -1 with errno: 5 (Input/output error)
> fsstress: check_cwd failure
> fsstress: check_cwd stat64() returned -1 with errno: 5 (Input/output error)
> fsstress: check_cwd failure
> fsstress: check_cwd stat64() returned -1 with errno: 5 (Input/output error)
> fsstress: check_cwd failure
> fsstress killed (pid 1268407)
> fsstress killed (pid 1268409)
> fsstress killed (pid 1268410)
> fsstress killed (pid 1268411)
> fsstress killed (pid 1268412)
> -z -s 0 -m 31 -n 1 -p 1 \
> 
> seed = 1746351882
> echo '1' 2>&1 > /sys/fs/xfs/dm-0/error/fail_at_unmount
> echo '0' 2>&1 > /sys/fs/xfs/dm-0/error/metadata/EIO/max_retries
> echo '0' 2>&1 > /sys/fs/xfs/dm-0/error/metadata/EIO/retry_timeout_seconds
> fsstress: check_cwd stat64() returned -1 with errno: 5 (Input/output error)
> fsstress: check_cwd failure
> fsstress: check_cwd stat64() returned -1 with errno: 5 (Input/output error)
> fsstress: check_cwd failure
> fsstress: check_cwd stat64() returned -1 with errno: 5 (Input/output error)
> fsstress: check_cwd failure
> fsstress: check_cwd stat64() returned -1 with errno: 5 (Input/output error)
> fsstress: check_cwd failure
> fsstress killed (pid 1268493)
> fsstress killed (pid 1268495)
> fsstress killed (pid 1268496)
> fsstress killed (pid 1268497)
> fsstress killed (pid 1268498)
> -z -s 0 -m 31 -n 1 -p 1 \
> 
> seed = 1746461623
> echo '1' 2>&1 > /sys/fs/xfs/dm-0/error/fail_at_unmount
> echo '0' 2>&1 > /sys/fs/xfs/dm-0/error/metadata/EIO/max_retries
> echo '0' 2>&1 > /sys/fs/xfs/dm-0/error/metadata/EIO/retry_timeout_seconds
> fsstress: check_cwd stat64() returned -1 with errno: 5 (Input/output error)
> fsstress: check_cwd failure
> fsstress: check_cwd stat64() returned -1 with errno: 5 (Input/output error)
> fsstress: check_cwd failure
> fsstress: check_cwd stat64() returned -1 with errno: 5 (Input/output error)
> fsstress: check_cwd failure
> fsstress: check_cwd stat64() returned -1 with errno: 5 (Input/output error)
> fsstress: check_cwd failure
> fsstress killed (pid 1268579)
> fsstress killed (pid 1268581)
> fsstress killed (pid 1268582)
> fsstress killed (pid 1268583)
> fsstress killed (pid 1268584)
> -z -s 0 -m 31 -n 1 -p 1 \
> 
> seed = 1746592533
> echo '1' 2>&1 > /sys/fs/xfs/dm-0/error/fail_at_unmount
> echo '0' 2>&1 > /sys/fs/xfs/dm-0/error/metadata/EIO/max_retries
> echo '0' 2>&1 > /sys/fs/xfs/dm-0/error/metadata/EIO/retry_timeout_seconds
> fsstress: check_cwd stat64() returned -1 with errno: 5 (Input/output error)
> fsstress: check_cwd failure
> fsstress: check_cwd stat64() returned -1 with errno: 5 (Input/output error)
> fsstress: check_cwd failure
> fsstress: check_cwd stat64() returned -1 with errno: 5 (Input/output error)
> fsstress: check_cwd failure
> fsstress: check_cwd stat64() returned -1 with errno: 5 (Input/output error)
> fsstress: check_cwd failure
> fsstress killed (pid 1268666)
> fsstress killed (pid 1268669)
> fsstress killed (pid 1268670)
> fsstress killed (pid 1268671)
> fsstress killed (pid 1268672)
> -z -s 0 -m 31 -n 1 -p 1 \
> 
> seed = 1746758569
> echo '1' 2>&1 > /sys/fs/xfs/dm-0/error/fail_at_unmount
> echo '0' 2>&1 > /sys/fs/xfs/dm-0/error/metadata/EIO/max_retries
> echo '0' 2>&1 > /sys/fs/xfs/dm-0/error/metadata/EIO/retry_timeout_seconds
> fsstress: check_cwd stat64() returned -1 with errno: 5 (Input/output error)
> fsstress: check_cwd failure
> fsstress: check_cwd stat64() returned -1 with errno: 5 (Input/output error)
> fsstress: check_cwd failure
> fsstress: check_cwd stat64() returned -1 with errno: 5 (Input/output error)
> fsstress: check_cwd failure
> fsstress: check_cwd stat64() returned -1 with errno: 5 (Input/output error)
> fsstress: check_cwd failure
> fsstress killed (pid 1268748)
> fsstress killed (pid 1268750)
> fsstress killed (pid 1268751)
> fsstress killed (pid 1268752)
> fsstress killed (pid 1268753)
> -z -s 0 -m 31 -n 1 -p 1 \
> 
> seed = 1746823066
> echo '1' 2>&1 > /sys/fs/xfs/dm-0/error/fail_at_unmount
> echo '0' 2>&1 > /sys/fs/xfs/dm-0/error/metadata/EIO/max_retries
> echo '0' 2>&1 > /sys/fs/xfs/dm-0/error/metadata/EIO/retry_timeout_seconds
> fsstress: check_cwd stat64() returned -1 with errno: 5 (Input/output error)
> fsstress: check_cwd failure
> fsstress: check_cwd stat64() returned -1 with errno: 5 (Input/output error)
> fsstress: check_cwd failure
> fsstress: check_cwd stat64() returned -1 with errno: 5 (Input/output error)
> fsstress: check_cwd failure
> fsstress: check_cwd stat64() returned -1 with errno: 5 (Input/output error)
> fsstress: check_cwd failure
> fsstress killed (pid 1268830)
> fsstress killed (pid 1268832)
> fsstress killed (pid 1268833)
> fsstress killed (pid 1268834)
> fsstress killed (pid 1268835)
> -z -s 0 -m 31 -n 1 -p 1 \
> 
> seed = 1746240425
> umount: /mnt/xfstests/scratch: not mounted.
> _check_xfs_filesystem: filesystem on /dev/vda3 is inconsistent (r)
> *** xfs_repair -n output ***
> Phase 1 - find and verify superblock...
> Phase 2 - using internal log
>         - zero log...
>         - scan filesystem freespace and inode maps...
>         - found root inode chunk
> Phase 3 - for each AG...
>         - scan (but don't clear) agi unlinked lists...
>         - process known inodes and perform inode discovery...
>         - agno = 0
> attribute entry #3 in attr block 146, inode 132 is INCOMPLETE
> problem with attribute contents in inode 132
> would clear attr fork
> bad nblocks 452 for inode 132, would reset to 0
> bad anextents 211 for inode 132, would reset to 0
> attribute entry #19 in attr block 228, inode 133 is INCOMPLETE
> problem with attribute contents in inode 133
> would clear attr fork
> bad nblocks 493 for inode 133, would reset to 0
> bad anextents 250 for inode 133, would reset to 0
>         - agno = 1
> attribute entry #12 in attr block 79, inode 8388736 is INCOMPLETE
> problem with attribute contents in inode 8388736
> would clear attr fork
> bad nblocks 440 for inode 8388736, would reset to 0
> bad anextents 221 for inode 8388736, would reset to 0
>         - agno = 2
> attribute entry #11 in attr block 79, inode 16908416 is INCOMPLETE
> problem with attribute contents in inode 16908416
> would clear attr fork
> bad nblocks 471 for inode 16908416, would reset to 0
> bad anextents 243 for inode 16908416, would reset to 0
>         - agno = 3
> attribute entry #2 in attr block 0, inode 25171328 is INCOMPLETE
> problem with attribute contents in inode 25171328
> would clear attr fork
> bad nblocks 1 for inode 25171328, would reset to 0
> bad anextents 1 for inode 25171328, would reset to 0
>         - process newly discovered inodes...
> Phase 4 - check for duplicate blocks...
>         - setting up duplicate extent list...
>         - check for inodes claiming duplicate blocks...
>         - agno = 0
>         - agno = 1
>         - agno = 2
>         - agno = 3
> No modify flag set, skipping phase 5
> Phase 6 - check inode connectivity...
>         - traversing filesystem ...
>         - traversal finished ...
>         - moving disconnected inodes to lost+found ...
> Phase 7 - verify link counts...
> No modify flag set, skipping filesystem flush and exiting.
> *** end xfs_repair output
> *** mount output ***
> /dev/vda7 on / type xfs (rw,relatime,seclabel,attr2,inode64,logbufs=8,logbsize=32k,noquota)
> devtmpfs on /dev type devtmpfs (rw,nosuid,seclabel,size=2636876k,nr_inodes=659219,mode=755,inode64)
> tmpfs on /dev/shm type tmpfs (rw,nosuid,nodev,seclabel,size=2679952k,nr_inodes=669988,inode64)
> devpts on /dev/pts type devpts (rw,nosuid,noexec,relatime,seclabel,gid=5,mode=620,ptmxmode=000)
> sysfs on /sys type sysfs (rw,nosuid,nodev,noexec,relatime,seclabel)
> securityfs on /sys/kernel/security type securityfs (rw,nosuid,nodev,noexec,relatime)
> cgroup2 on /sys/fs/cgroup type cgroup2 (rw,nosuid,nodev,noexec,relatime,seclabel,nsdelegate,memory_recursiveprot)
> none on /sys/fs/pstore type pstore (rw,nosuid,nodev,noexec,relatime,seclabel)
> bpf on /sys/fs/bpf type bpf (rw,nosuid,nodev,noexec,relatime,mode=700)
> configfs on /sys/kernel/config type configfs (rw,nosuid,nodev,noexec,relatime)
> proc on /proc type proc (rw,nosuid,nodev,noexec,relatime)
> tmpfs on /run type tmpfs (rw,nosuid,nodev,seclabel,size=1071984k,nr_inodes=819200,mode=755,inode64)
> selinuxfs on /sys/fs/selinux type selinuxfs (rw,nosuid,noexec,relatime)
> systemd-1 on /proc/sys/fs/binfmt_misc type autofs (rw,relatime,fd=31,pgrp=1,timeout=0,minproto=5,maxproto=5,direct,pipe_ino=5125)
> hugetlbfs on /dev/hugepages type hugetlbfs (rw,nosuid,nodev,relatime,seclabel,pagesize=2M)
> mqueue on /dev/mqueue type mqueue (rw,nosuid,nodev,noexec,relatime,seclabel)
> debugfs on /sys/kernel/debug type debugfs (rw,nosuid,nodev,noexec,relatime,seclabel)
> tracefs on /sys/kernel/tracing type tracefs (rw,nosuid,nodev,noexec,relatime,seclabel)
> tmpfs on /run/credentials/systemd-journald.service type tmpfs (ro,nosuid,nodev,noexec,relatime,nosymfollow,seclabel,size=1024k,nr_inodes=1024,mode=700,inode64,noswap)
> fusectl on /sys/fs/fuse/connections type fusectl (rw,nosuid,nodev,noexec,relatime)
> /dev/vda2 on /boot type xfs (rw,relatime,seclabel,attr2,inode64,logbufs=8,logbsize=32k,noquota)
> sunrpc on /var/lib/nfs/rpc_pipefs type rpc_pipefs (rw,relatime)
> tmpfs on /run/user/0 type tmpfs (rw,nosuid,nodev,relatime,seclabel,size=535960k,nr_inodes=133990,mode=700,inode64)
> tmpfs on /run/credentials/getty@tty1.service type tmpfs (ro,nosuid,nodev,noexec,relatime,nosymfollow,seclabel,size=1024k,nr_inodes=1024,mode=700,inode64,noswap)
> tmpfs on /run/credentials/serial-getty@ttyS0.service type tmpfs (ro,nosuid,nodev,noexec,relatime,nosymfollow,seclabel,size=1024k,nr_inodes=1024,mode=700,inode64,noswap)
> *** end mount output

