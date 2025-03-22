Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B43FE221550
	for <linux-xfs@vger.kernel.org>; Sat, 22 Mar 2025 15:01:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742655664; cv=none; b=hOo4dPuQXfiZ72DUoYrpfdHCXdJzcVCIypIM6eayYdkAut3C3i/yqgVCOqu7lD10UiJjmFLRHAUUwfoGd5uYvS39XA2xI81Yi7334zz/Y1v6NeqLUetrm55ckUx2eqrY6OURJcydkrC2OSx4BsVPlOQ/+hNGV0twZS8YfV961vI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742655664; c=relaxed/simple;
	bh=vM909MV1xRIxsji7GkE0M2VaUres9qPw8Yj5ppl7xpY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TBIeVp1/7sAuMRLK74f8icc6KBB9spr9zj8wz+/Og4BS6d8E0eFTOfsq+IP16yO3533qgOoTS1SdWr4h4yVPNxxhjpnnE9KniOg7AOUEhdpDPvV8TY+x69EJ+Hn70Nsx9q+pHUI9ohzEct/MCWqgxwGhoDVcf+ICHjykjtJ2tbA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Sn3vuzMX; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Sn3vuzMX"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1742655661;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=QbEnZcYniNzHNoFgfqOJwSZI+W0C/5rQjUnSrB+X1hA=;
	b=Sn3vuzMX6gaYmaig9/37kpnaCMvagL/QEusPVNVNSY8F2OpUfQQRqz54R0jiBCcDwkH5+0
	j88npJEnx8+q95/kriHT2Q/uYnPRB+cyGDJS9efVHIDR79TEd/OhNiUKDh58ZsHkLseMgP
	roKxaSxJF45im/g0fu05XziiS+I0/XQ=
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com
 [209.85.216.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-518-8NsUPI1uOzmyXfECh-rszw-1; Sat, 22 Mar 2025 11:00:59 -0400
X-MC-Unique: 8NsUPI1uOzmyXfECh-rszw-1
X-Mimecast-MFC-AGG-ID: 8NsUPI1uOzmyXfECh-rszw_1742655658
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-2ff8a2c7912so4802519a91.1
        for <linux-xfs@vger.kernel.org>; Sat, 22 Mar 2025 08:00:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742655658; x=1743260458;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QbEnZcYniNzHNoFgfqOJwSZI+W0C/5rQjUnSrB+X1hA=;
        b=cFS8Pe2G2vK0Bk2YKK5wjC3sCUnAo0c2VIS2BBrKGU3yPl+6ke4zZmyAYQTaIvWWyB
         n/NNGCW8q4prt3gmFGxsBtE0vJMxKCT6wOH0cg0p2TBBIVBN8R4nyjLHr1i70XaH2tpu
         PiTWdckpkrEEX/PVD7V0cPVmYq5FpokpmayJ7TK8gLD10wmWMXsYQ+v5NMHeiiPcKLpV
         lTm33Fw1ULOYZ+MOUDGv3Vqk0zpcYOCfhmny7QpJSsYWuoIQ7GimW5SqgYMwzHim5zx7
         LzlapZBtggFXAlACNOOOTzqp6+p6cchLqgE9elAlxIbpVzKmPqwQExzZ1u2ikuRZjlU2
         i4xg==
X-Forwarded-Encrypted: i=1; AJvYcCVpcRBrFjtYEPp8tu15jRIsxgQ4FLXakjN7yKw9Ti+qedcpV6WvmdUQ1gTA9EMqrBNfo20ES+nCxlw=@vger.kernel.org
X-Gm-Message-State: AOJu0YwvLbcIBDLHQtWbQxdBSKM4N341eimXOiYYhTVgDApy5d5X6O+n
	jE6imzaYTZ+v2v27ZG5PrRmOwZabpCrU7gF3vWQztdMftjKYab6yRGOqjyqDHzeHqU/78hBXDG/
	nUFdHq7qVNpmKIKPwUKOoeZw0vkYuu7drjZW6jer5920Xr4BaDG5IukF5vw==
X-Gm-Gg: ASbGncu4Cx7uY+JpCKVaomyZBiUQSJ0ewi9ZmPIRQEfxx71AP36ujtd8iWtdsjcbD7n
	mbUGG4B+q2NRzY9cicQBWUBZ2kGKmoS7qnwuOrmSduvN3ToptKL/NPrRClCLSGMhDhOXaZLMbim
	ixZs4kFZ/fOQ2dh2aNmyKOdyUSrQVBla4i7ILJKMreMzvTHtGhFt4RLN+N8lPehyPZu6QYUoz1S
	AZFaVcY9Vh/gTlKVftIg9fdIDaq3Z1UVF8k/ql8WvODFzl9+2lLKV6AhGnZPMS+Kq5i3koyNwpe
	T9Jqz7OYQOkeX5pzBHBoCpCaTI7bO2CS5hik76BbbyPKrFMEa97Zjbsp
X-Received: by 2002:a17:90b:1c82:b0:2fb:fe21:4841 with SMTP id 98e67ed59e1d1-301d42c585dmr18854449a91.8.1742655657894;
        Sat, 22 Mar 2025 08:00:57 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IElL7bt3velPPnZFKVKH6XHvWvRuh8sAjZc620qhVFQ8x+hlGKxuMM7M4undR2VflifW9erPA==
X-Received: by 2002:a17:90b:1c82:b0:2fb:fe21:4841 with SMTP id 98e67ed59e1d1-301d42c585dmr18854397a91.8.1742655657401;
        Sat, 22 Mar 2025 08:00:57 -0700 (PDT)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3030f3efbabsm4265051a91.0.2025.03.22.08.00.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 22 Mar 2025 08:00:57 -0700 (PDT)
Date: Sat, 22 Mar 2025 23:00:53 +0800
From: Zorro Lang <zlang@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: fstests@vger.kernel.org, hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/4] xfs/818: fix some design issues
Message-ID: <20250322150053.l7tlptpqeiv6pg5m@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <174259233946.743619.993544237516250761.stgit@frogsfrogsfrogs>
 <174259234036.743619.7066882477727740142.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <174259234036.743619.7066882477727740142.stgit@frogsfrogsfrogs>

On Fri, Mar 21, 2025 at 02:28:26PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> While QA'ing zoned filesystem support, I discovered some design errors
> in this test:
> 
> 1) Since we're test formatting a sparse file on an xfs filesystem,
> there's no need to play games with optimal device size; we can create
> a totally sparse file that's the same size as SCRATCH_DEV.
> 
> 2) mkfs.xfs cannot create realtime files, so if it fails with that,
> there's no need to continue the test.
> 
> 3) If mkfs -p fails for none of the proscribed reasons, it should exit
> the test.  The final cat $tmp.mkfs will take care of tweaking the golden
> output to register the test failure for further investigation.
> 
> Cc: <fstests@vger.kernel.org> # v2025.03.09
> Fixes: 6d39dc34e61e11 ("xfs: test filesystem creation with xfs_protofile")
> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
> ---

Make sense to me,

Reviewed-by: Zorro Lang <zlang@redhat.com>

>  tests/xfs/818 |   19 ++++++++++++++++---
>  1 file changed, 16 insertions(+), 3 deletions(-)
> 
> 
> diff --git a/tests/xfs/818 b/tests/xfs/818
> index aeb462353df7e9..bc809390b9e340 100755
> --- a/tests/xfs/818
> +++ b/tests/xfs/818
> @@ -75,9 +75,8 @@ _run_fsstress -n 1000 -d $SCRATCH_MNT/newfiles
>  make_stat $SCRATCH_MNT before
>  make_md5 $SCRATCH_MNT before
>  
> -kb_needed=$(du -k -s $SCRATCH_MNT | awk '{print $1}')
> -img_size=$((kb_needed * 2))
> -test "$img_size" -lt $((300 * 1024)) && img_size=$((300 * 1024))
> +scratch_sectors="$(blockdev --getsz $SCRATCH_DEV)"
> +img_size=$((scratch_sectors * 512 / 1024))
>  
>  echo "Clone image with protofile"
>  $XFS_PROTOFILE_PROG $SCRATCH_MNT > $testfiles/protofile
> @@ -99,7 +98,21 @@ if ! _try_mkfs_dev -p $testfiles/protofile $testfiles/image &> $tmp.mkfs; then
>  	if grep -q 'No space left on device' $tmp.mkfs; then
>  		_notrun "not enough space in filesystem"
>  	fi
> +
> +	# mkfs cannot create realtime files.
> +	#
> +	# If zoned=1 is in MKFS_OPTIONS, mkfs will create an internal realtime
> +	# volume with rtinherit=1 and fail, so we need to _notrun that case.
> +	#
> +	# If zoned=1 is /not/ in MKFS_OPTIONS, we didn't pass a realtime device
> +	# to mkfs so it will not create realtime files.  The format should work
> +	# just fine.
> +	if grep -q 'creating realtime files from proto file not supported' $tmp.mkfs; then
> +		_notrun "mkfs cannot create realtime files"
> +	fi
> +
>  	cat $tmp.mkfs
> +	exit
>  fi
>  
>  _mount $testfiles/image $testfiles/mount
> 

