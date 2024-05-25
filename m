Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE0BBB651
	for <linux-xfs@vger.kernel.org>; Sat, 25 May 2024 05:42:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716615781; cv=none; b=dQT9ERMFPhwlbXotfuapU4q/rPWCl09fkI1RwJK7lU5kiQeHXtsrWBYYw9ryLOp13l9IL6KPf8kBoblZh8zxJqXvdGyUcqdNwWNjQaTh3liWHHJ+JxUh2Bpc5qWVeQmw5zc2RPrQ3X4JYWeS/eCiL7uzSwncRvlZd5nFxHSin4w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716615781; c=relaxed/simple;
	bh=QH6CiInNA+sLUcWIGlusgioN1a9ALec6l+HzsZTZk8o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hZNH6EavrUlx6bkQ/KYd+T/N3nkue2Th5p0snm/bkKwaE3RwFcns2++uQoudy+qIYn2B3qoBJ57iC+7VyGG4n37/3HkkvKBAI2z31V884ust4gBMPWavlyJXowDZ8gFUqlxOjPnJjAPxCgXb5rW6dOX0uMikyv28zjkBR8uFeDU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=CE0QdE24; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CE0QdE24"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1716615778;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=bjVVpyovcTh1KhIZeNxJ7zyNZ65WzYBVUyV7DNwDnA4=;
	b=CE0QdE24B6FWkIyGo8Scern/MYwp3UGkXar+44xBE7ksTov1fuLoqstuPhvqDJIe5LuF+t
	1FQShWEofE4R1tsdJBNV1MIQgXPZcUk1+YoZogNUS8jxsvtu7n8AySq2vYT73qRdvcIxOs
	qfq7cNCDbu+vlC/ZTXT8/ERKTKd0qjA=
Received: from mail-oa1-f69.google.com (mail-oa1-f69.google.com
 [209.85.160.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-641-thsEbX_LOrqh70boatC74g-1; Sat, 25 May 2024 01:42:57 -0400
X-MC-Unique: thsEbX_LOrqh70boatC74g-1
Received: by mail-oa1-f69.google.com with SMTP id 586e51a60fabf-24c6f7c27e4so3341064fac.2
        for <linux-xfs@vger.kernel.org>; Fri, 24 May 2024 22:42:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716615776; x=1717220576;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bjVVpyovcTh1KhIZeNxJ7zyNZ65WzYBVUyV7DNwDnA4=;
        b=nlmEXp7mCKgIMR8YXCFaUM6a2kGffD2kPJdi88tyowNfXtvBNcSEufFxWJqgD9PzbY
         GN3IDXg4WOMH/7swZ3ZF8rtnRXu2iVnEoR4V9H8BreaGqMLYrY0PSxytp4ugmWujlHiq
         FL3lFP0RLCvwWWZAD4IsRdCl8UuqJF5SWXMdFsO8JC79qE30V7o9SRnt+FyVGm969Kp9
         EUtYHTJlz9LhkLioBEdTogkUVfGLZFTu8AWT+2asEAjHgR8e6GHg320uvmVjt/t+xrDV
         1fAChoWV1LBI4RLV3HoLeFxSFamCsZ03R0TKfW5jzc3L+zqYhPDjl4imL/JIRt/QqXT2
         1w8Q==
X-Forwarded-Encrypted: i=1; AJvYcCURXN5fHu9E8xXGuBmjgRRa45xAFcPqwKzRzLGDQGAjK9HqAvtOXWl1tyriH+chrrC2zASbArhBC9n6rKl+dVlqpb/FSdKblwY2
X-Gm-Message-State: AOJu0Yzbrppyl58aOePQdf/O9+4tavdNqDp99aTIKaX280Zduu+dXFdO
	h/7Wv5ZaGjznvVGwITJ/R7rTCVccCHQcX6rsYJL2MKM7hsc4G62FC+808pMT5iaJvVUHGCc4oSn
	Qn5ZvjFH4dMKfzwTBxgIfMIRWN+dG54QIpcW4Y+2d6dyUb6rS7eGqZfHVLnyZD2pCS9ao
X-Received: by 2002:a05:6870:35d4:b0:23e:7764:7795 with SMTP id 586e51a60fabf-24ca12e174bmr4328495fac.28.1716615776133;
        Fri, 24 May 2024 22:42:56 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGk9UhLE5f2euh3S/6RGiQf+H/9ZsQZ/LN/AwdFjGW/6xBaFtTpItRSIrQ0p4cepqh+YgZiEg==
X-Received: by 2002:a05:6870:35d4:b0:23e:7764:7795 with SMTP id 586e51a60fabf-24ca12e174bmr4328484fac.28.1716615775532;
        Fri, 24 May 2024 22:42:55 -0700 (PDT)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-6f8fcfe64b1sm1951721b3a.146.2024.05.24.22.42.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 May 2024 22:42:55 -0700 (PDT)
Date: Sat, 25 May 2024 13:42:52 +0800
From: Zorro Lang <zlang@redhat.com>
To: Andrey Albershteyn <aalbersh@redhat.com>
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: test quota's project ID on special files
Message-ID: <20240525054252.2h55e2oer65mpy6s@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <20240520170004.669254-2-aalbersh@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240520170004.669254-2-aalbersh@redhat.com>

On Mon, May 20, 2024 at 07:00:05PM +0200, Andrey Albershteyn wrote:
> With addition of FS_IOC_FSSETXATTRAT xfs_quota now can set project
> ID on filesystem inodes behind special files. Previously, quota
> reporting didn't count inodes of special files created before
> project initialization. Only new inodes had project ID set.
> 
> Signed-off-by: Andrey Albershteyn <aalbersh@redhat.com>
> ---
> 
> Notes:
>     This is part of the patchset which introduces
>     FS_IOC_FS[GET|SET]XATTRAT:
>     https://lore.kernel.org/linux-xfs/20240520164624.665269-2-aalbersh@redhat.com/T/#t
>     https://lore.kernel.org/linux-xfs/20240520165200.667150-2-aalbersh@redhat.com/T/#u

So this test fails on old xfsprogs and kernel which doesn't support
above feature? Do we need a _require_xxxx helper to skip this test?
Or you hope to fail on old kernel to clarify this feature missing?

As this test requires some new patches, better to point out:
  _wants_kernel_commit xxxxxxxxxxxxx xxxxxxxxxxxxxxxxxxxxxxxx
  _wants_git_commit xfsprogs xxxxxxxxxxxxx xxxxxxxxxxxxxxxxxxxxxxxxx

> 
>  tests/xfs/608     | 73 +++++++++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/608.out | 10 +++++++
>  2 files changed, 83 insertions(+)
>  create mode 100755 tests/xfs/608
>  create mode 100644 tests/xfs/608.out
> 
> diff --git a/tests/xfs/608 b/tests/xfs/608
> new file mode 100755
> index 000000000000..3573c764c5f4
> --- /dev/null
> +++ b/tests/xfs/608
> @@ -0,0 +1,73 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2024 Red Hat.  All Rights Reserved.
> +#
> +# FS QA Test 608
> +#
> +# Test that XFS can set quota project ID on special files
> +#
> +. ./common/preamble
> +_begin_fstest auto quota
> +
> +# Override the default cleanup function.
> +_cleanup()
> +{
> +	cd /
> +	rm -r -f $tmp.*
> +	rm -f $tmp.proects $tmp.projid
                      ^^^^
                   projects? (same below)

And won't "rm -f $tmp.*" help to remove $tmp.proects and $tmp.projid ?
If it does, we can remove this _cleanup, just use the default one.

> +}
> +
> +
> +# Import common functions.
> +. ./common/quota
> +. ./common/filter
> +
> +# Modify as appropriate.
> +_supported_fs xfs
> +_require_scratch
> +_require_xfs_quota
> +_require_user

Does this patch use "fsgqa" user/group?

> +
> +_scratch_mkfs >/dev/null 2>&1
> +_qmount_option "pquota"
> +_scratch_mount

If there's not special reason, we generally do all _require_xxx checking
at first, then mkfs & mount.

> +_require_test_program "af_unix"
> +_require_symlinks
> +_require_mknod

So you might can move above 3 lines over the _scratch_mkfs, looks like
they don't need a SCRATCH_DEV with $FSTYP.

> +
> +function create_af_unix () {

We generally don't use "function", but that's fine if you intend that :)

Thanks,
Zorro

> +	$here/src/af_unix $* || echo af_unix failed
> +}
> +
> +function filter_quota() {
> +	_filter_quota | sed "s~$tmp.proects~PROJECTS_FILE~"
> +}
> +
> +projectdir=$SCRATCH_MNT/prj
> +id=42
> +
> +mkdir $projectdir
> +mkfifo $projectdir/fifo
> +mknod $projectdir/chardev c 1 1
> +mknod $projectdir/blockdev b 1 1
> +create_af_unix $projectdir/socket
> +touch $projectdir/foo
> +ln -s $projectdir/foo $projectdir/symlink
> +touch $projectdir/bar
> +ln -s $projectdir/bar $projectdir/broken-symlink
> +rm -f $projectdir/bar
> +
> +$XFS_QUOTA_PROG -D $tmp.proects -P $tmp.projid -x \
> +	-c "project -sp $projectdir $id" $SCRATCH_DEV | filter_quota
> +$XFS_QUOTA_PROG -D $tmp.proects -P $tmp.projid -x \
> +	-c "limit -p isoft=20 ihard=20 $id " $SCRATCH_DEV | filter_quota
> +$XFS_QUOTA_PROG -D $tmp.proects -P $tmp.projid -x \
> +	-c "project -cp $projectdir $id" $SCRATCH_DEV | filter_quota
> +$XFS_QUOTA_PROG -D $tmp.proects -P $tmp.projid -x \
> +	-c "report -inN -p" $SCRATCH_DEV
> +$XFS_QUOTA_PROG -D $tmp.proects -P $tmp.projid -x \
> +	-c "project -Cp $projectdir $id" $SCRATCH_DEV | filter_quota
> +
> +# success, all done
> +status=0
> +exit
> diff --git a/tests/xfs/608.out b/tests/xfs/608.out
> new file mode 100644
> index 000000000000..c3d56c3c7682
> --- /dev/null
> +++ b/tests/xfs/608.out
> @@ -0,0 +1,10 @@
> +QA output created by 608
> +Setting up project 42 (path SCRATCH_MNT/prj)...
> +Processed 1 (PROJECTS_FILE and cmdline) paths for project 42 with recursion depth infinite (-1).
> +Checking project 42 (path SCRATCH_MNT/prj)...
> +Processed 1 (PROJECTS_FILE and cmdline) paths for project 42 with recursion depth infinite (-1).
> +#0                   3          0          0     00 [--------]
> +#42                  8         20         20     00 [--------]
> +
> +Clearing project 42 (path SCRATCH_MNT/prj)...
> +Processed 1 (PROJECTS_FILE and cmdline) paths for project 42 with recursion depth infinite (-1).
> -- 
> 2.42.0
> 
> 

