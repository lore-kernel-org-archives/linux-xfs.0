Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C7B12FF67A
	for <linux-xfs@vger.kernel.org>; Fri, 17 Oct 2025 17:46:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760723204; cv=none; b=m3K7krGHuHFqMQmIb0Aq+qspXntzX/gD7hG6dnv2jWgA9Lz8MeAP1YYMCGdlhL/kNPtd9p2Y+eurDXhkM8/p8xf+3dRYGR3IB2ZyyIrO06Zrda/gF4Nr8CuFPEwtgy8vh1G5ApGRajcbd7AHitN6+BEqwS+T14O+bLonfxBqAwQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760723204; c=relaxed/simple;
	bh=+rlXMsdBVCiAGKNrtStCluWm7gAecJ+SisXX1H6GGYQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=c5uagjSKogvA+ymOe++DFNeHD0tRdbNeq6ZudtSul2gffb8lbWPoCNPmQfKZxN5Xp8V5RoLGazhlhQ3Djp/tU5GU0sTD5P9HG/InTdBNKZ8tmM8tdJ3SnIdZHLLzFNgVIjQoyz10YJzzFVH0za6tUY6V0q2mwXEcufC9atrk+jI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=T/FXNU5G; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="T/FXNU5G"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1760723202;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=nqAd0fHzJv/ONbqAnOwgeKtyz/JhNvYGbRvyQBkC5F8=;
	b=T/FXNU5GoFf4o2nkJ2CMi8sa6jZHx9XaM6Q2CiExQ3qxKqZIjQvFA3473BtLoaCdWSneBE
	FSgKGwDNyTZMIR9EgWYDh/lfUQRXUAT0tgYVCdd8E4aT2IYOs3GLGBP1e1DnjUTTKYjNq6
	2/UwlzNv+2cXOaUpr6dsNl72yqDiTA0=
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com
 [209.85.210.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-641-PPSk6_rSMp-wln1j4Pd65g-1; Fri, 17 Oct 2025 13:46:40 -0400
X-MC-Unique: PPSk6_rSMp-wln1j4Pd65g-1
X-Mimecast-MFC-AGG-ID: PPSk6_rSMp-wln1j4Pd65g_1760723200
Received: by mail-pf1-f200.google.com with SMTP id d2e1a72fcca58-780fb254938so1987113b3a.0
        for <linux-xfs@vger.kernel.org>; Fri, 17 Oct 2025 10:46:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760723199; x=1761327999;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nqAd0fHzJv/ONbqAnOwgeKtyz/JhNvYGbRvyQBkC5F8=;
        b=MmVqXfmYnhHtw2xFmDPjE2TpZpYFJgChSoaNb2hGvkkTDywoReu84g5FMzcdoKNqHZ
         tIffAm8Ptrar8niP6FmrYIl4Q/pr5dvm0wqM4IbTVjKUf2gFB7MaIVrUsBZHxpiZFSW/
         2h09pCz8nvAk4ha4qRVKccJqC0XjyCy/51n2+rlc/cNF2rEArK3J1yoDm5teOWTYuR6P
         lYs3lvFuZrKejkvtv+y5mDhtj+wYUtmV2vFs+9BM6gRGbgcc1RDBPZApjmoWCgytUVmn
         oZh6aJYwLTDrPVFJ1UmuYzvsD/3Tr2CEoiYCFaYoCzOc1yofv3w2KXURQ8Vh/dDKm74s
         YqnA==
X-Forwarded-Encrypted: i=1; AJvYcCWIJPMairJbL4+iEwdFflYHDxvFbeCQGcx5YRy4DTS6+pmbmzR3YOZFv4pknMBQ/bQb2fuGEqJ3xo8=@vger.kernel.org
X-Gm-Message-State: AOJu0YxRwihz91Pe0En2HCRbBlENdBrrB68jGMYRqiiDMMz+s0hxopgW
	vwDuzQGcX06/0TMHMMq+Y28iIuBLMvgjD/68r0hs9AOTfGYVP7/iktuznjbWEOSA8wbc2Ng7jwJ
	IspJe1Vj+JlsIIbhtCBTMDq11bILduCTaeV7cZlYNQ7VBdrByc+RnP1tZh/w7ig==
X-Gm-Gg: ASbGncsS/Hy6m5fRC66BiQXEZFwXYyZ16uKpwWDvA/l0W+E6HxH0rQipeR15GXhJPTn
	s67FR+JEdVNGvaxN1jehi5CwRm9VR/U9CQUZZMrmXnmCpfrsqb9GLWV/eKXfD4ArKoPXUzh7SkK
	8plZbI4dAJIPgBkhPzFA1VHPE41wqqqtZU+5IFSvxsUNK8TAYwVKP0e+2WjkxmkLns57zAiSVcL
	KtO/wRdV7i26wrRognYI4XxwZ98fdGjxP3c/02YBQ7eCdE/8QenMMz5vAE3CgOdAVImjURJuK4p
	fE6NoOqA9VzceOVfOa6njgCTaJ0mtJ0XlG/d6/IZhRY8yXuO3+sH/+B48p1HBLHHJusPy8hUu0u
	WFq8FaBywvj4teljvf9xWb7heGC3GUOyWLLdzi1s=
X-Received: by 2002:a05:6a00:1793:b0:776:12ea:c737 with SMTP id d2e1a72fcca58-7a220b06549mr4843944b3a.23.1760723199042;
        Fri, 17 Oct 2025 10:46:39 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGe/timuZwjbKtFT1+8rRGPQgkec8Ndr9avLVggU9VbXoopwWlOx0AlvXqT8Q8E7rvXqNzdaw==
X-Received: by 2002:a05:6a00:1793:b0:776:12ea:c737 with SMTP id d2e1a72fcca58-7a220b06549mr4843913b3a.23.1760723198504;
        Fri, 17 Oct 2025 10:46:38 -0700 (PDT)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([209.132.188.88])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7a22ff1581dsm170103b3a.12.2025.10.17.10.46.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Oct 2025 10:46:37 -0700 (PDT)
Date: Sat, 18 Oct 2025 01:46:33 +0800
From: Zorro Lang <zlang@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/8] generic/772: actually check for file_getattr special
 file support
Message-ID: <20251017174633.lvfvpv2zoauwo7s7@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <176054617853.2391029.10911105763476647916.stgit@frogsfrogsfrogs>
 <176054617988.2391029.18130416327249525205.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <176054617988.2391029.18130416327249525205.stgit@frogsfrogsfrogs>

On Wed, Oct 15, 2025 at 09:38:01AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> On XFS in 6.17, this test fails with:
> 
>  --- /run/fstests/bin/tests/generic/772.out	2025-10-06 08:27:10.834318149 -0700
>  +++ /var/tmp/fstests/generic/772.out.bad	2025-10-08 18:00:34.713388178 -0700
>  @@ -9,29 +9,34 @@ Can not get fsxattr on ./foo: Invalid ar
>   Can not set fsxattr on ./foo: Invalid argument
>   Initial attributes state
>   ----------------- SCRATCH_MNT/prj
>  ------------------ ./fifo
>  ------------------ ./chardev
>  ------------------ ./blockdev
>  ------------------ ./socket
>  ------------------ ./foo
>  ------------------ ./symlink
>  +Can not get fsxattr on ./fifo: Inappropriate ioctl for device
>  +Can not get fsxattr on ./chardev: Inappropriate ioctl for device
>  +Can not get fsxattr on ./blockdev: Inappropriate ioctl for device
>  +Can not get fsxattr on ./socket: Inappropriate ioctl for device
> 
> This is a result of XFS' file_getattr implementation rejecting special
> files prior to 6.18.  Therefore, skip this new test on old kernels.
> 
> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
> ---
>  tests/generic/772 |    3 +++
>  tests/xfs/648     |    3 +++
>  2 files changed, 6 insertions(+)
> 
> 
> diff --git a/tests/generic/772 b/tests/generic/772
> index cc1a1bb5bf655c..e68a6724654450 100755
> --- a/tests/generic/772
> +++ b/tests/generic/772
> @@ -43,6 +43,9 @@ touch $projectdir/bar
>  ln -s $projectdir/bar $projectdir/broken-symlink
>  rm -f $projectdir/bar
>  
> +file_attr --get $projectdir ./fifo &>/dev/null || \
> +	_notrun "file_getattr not supported on $FSTYP"

I'm wondering if a _require_file_attr() is better?

Thanks,
Zorro

> +
>  echo "Error codes"
>  # wrong AT_ flags
>  file_attr --get --invalid-at $projectdir ./foo
> diff --git a/tests/xfs/648 b/tests/xfs/648
> index 215c809887b609..e3c2fbe00b666a 100755
> --- a/tests/xfs/648
> +++ b/tests/xfs/648
> @@ -47,6 +47,9 @@ touch $projectdir/bar
>  ln -s $projectdir/bar $projectdir/broken-symlink
>  rm -f $projectdir/bar
>  
> +$here/src/file_attr --get $projectdir ./fifo &>/dev/null || \
> +	_notrun "file_getattr not supported on $FSTYP"
> +
>  $XFS_QUOTA_PROG -D $tmp.projects -P $tmp.projid -x \
>  	-c "project -sp $projectdir $id" $SCRATCH_DEV | filter_quota
>  $XFS_QUOTA_PROG -D $tmp.projects -P $tmp.projid -x \
> 

