Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F057215198
	for <linux-xfs@vger.kernel.org>; Mon,  6 Oct 2025 09:56:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759744571; cv=none; b=YWWNONnnsheVq2pXSxVlojjsFVxkMZiU+BT9qPF8G7g1d0e3LfB08J4QDaGltn5nxTsOHvfaOtCUrxYVZ3urSQrJjb2FbYhoF3SNwxaJm5g25htRB837IOANciq9RWT0Aqa6snCm/H/r1i0WkBPMUmKQQ7U6iDJN3kbLfxk4Orw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759744571; c=relaxed/simple;
	bh=NahU/+V4n1+IDk7/jTnSOYcbHuz1ozZre0J4OPBcXvA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DggkwGl2WtadYZfGQCItyMJfflDYBRwuUqUenRNoNnUVMdDWUarsP1KZka/6dbbPGNby/+O7bRfuYKMorYQvzoms2tIWXVinMh1isU841dMwJv1z1fLAiD1fXGQAdFVOxGhEOg9edYX0OK9/m8pNFCt5qzzY0RA/lHyfM1GQbY4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=co9k+qrD; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="co9k+qrD"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759744568;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=/TtWqsB+vL29f+WqHIVh0uOt8o6InBJTuTjqBkW5psw=;
	b=co9k+qrDFkMYhMi1R6ODQ0nSkRuE2aPbFJAwqRzqzSPvgkOcCoh8O93hyNiyw5Od+ZxD4G
	Weh4jwPOTrPUy5gbNDxBpFcgB23zzLYZZwgFUJkSJ7bLQFRy0di/O54KxvxBbv2RWvyg2A
	hGghMcyftqU/qFAOTERqeivwOvahZLo=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-569-TFFQ2WmLML2D5kYhzeZMeA-1; Mon, 06 Oct 2025 05:56:06 -0400
X-MC-Unique: TFFQ2WmLML2D5kYhzeZMeA-1
X-Mimecast-MFC-AGG-ID: TFFQ2WmLML2D5kYhzeZMeA_1759744566
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-3f42b54d159so3769986f8f.2
        for <linux-xfs@vger.kernel.org>; Mon, 06 Oct 2025 02:56:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759744565; x=1760349365;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/TtWqsB+vL29f+WqHIVh0uOt8o6InBJTuTjqBkW5psw=;
        b=gd0x8yQKTb+ND+kknGXJseotq8v8mWmm8zQmVdOP3Q/JgaIcA6TE/brwV9vzYfGH59
         HO0WOVZ7Bj+9UWpJ3HQ+YJAIMsXcY2ylanIyW4+TmLvO2rovdFTfpmB5GzkMsl6ur8IQ
         kaD8ACbZtSNscRSDVi/bsEf5Nuw6/Um8eg1iQbiDkQ6WrpDPkGOWQJ+R+AV2ptPwbuLd
         eBbm2fmjMWOLmMo6rOekPxtsFtQO4k+NhVKLNh8weNvdmhNZqtEQWbXF3l0OU6/jRlZ4
         6Sm8QYVPTTyDKl+gYbkHjTBTzwq3LI8HuQb03jjBsdWMtaIpGsXLq3Lxk0tBOkcbGQ4x
         dniw==
X-Forwarded-Encrypted: i=1; AJvYcCVWIZHwPqXUJatTALv+OdsWhCTN1Zqy/1LpR5V2+20iE/7jZZp0DJxyE2rQx54emVjIrPGb1r6Uyis=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw/JtABd8aH+U5pwj9q2Yp6HptxtLK/BPGebTvc6zFt2M7ZpAvh
	SiD0zc3v89c7pF9QLUm3h6I9um5yBO1u162/Rt3GdSqf8Y1LrJfgMrYLCTQlBP3KDD8bbTYcGwu
	oPmNk8q78KFVQROyKs7vazTkTroW6d2YaFxiC83j2iVJUY5PUeB+xZCral2Z4
X-Gm-Gg: ASbGncsZ+b57CW5hUnFMlhAXQogDCu3dx9S/tsNParZq3kThiTqckGPuR7JlkSQDj+J
	qPcox8XtTWEawzUTIds0Nz8/B5B/or6e70PX2OOUlR+mZfeMITEYKQp/a0KyPBFAUCBO8kcU7RT
	ExYOH4JstiBj1FlLGe+qNRZgYs034WRigw8zFSxuDE6kWrBpyb5o548rUOgmRZV8V5hGCkFGx6T
	6nLUos2MMng4wF0bAJHiKrK3xlOkbTf/xzaQyD05/Sm4rsBfY9hfZz0z1p88WhnYvmkOsnTJa42
	GXkgK1FHECPJxsx1XRs63GHs3LYUi6MnFw5ptcV1g95D/DTd/yJxnBh7PmFMdaNPMA==
X-Received: by 2002:a05:6000:2890:b0:3ee:1279:6e68 with SMTP id ffacd0b85a97d-425671ab32fmr8219361f8f.47.1759744565087;
        Mon, 06 Oct 2025 02:56:05 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IESIFH0nsmLTuTfpAn77LYDu6eTjChPZl8GGpx/iU11/r7ZbfgkcR1RO/Syy2wrlHG4ldNS8Q==
X-Received: by 2002:a05:6000:2890:b0:3ee:1279:6e68 with SMTP id ffacd0b85a97d-425671ab32fmr8219344f8f.47.1759744564452;
        Mon, 06 Oct 2025 02:56:04 -0700 (PDT)
Received: from thinky (ip-217-030-074-039.aim-net.cz. [217.30.74.39])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4255d8a6c49sm20213119f8f.3.2025.10.06.02.56.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Oct 2025 02:56:04 -0700 (PDT)
Date: Mon, 6 Oct 2025 11:55:33 +0200
From: Andrey Albershteyn <aalbersh@redhat.com>
To: fstests@vger.kernel.org
Cc: zlang@redhat.com, linux-fsdevel@vger.kernel.org, 
	linux-xfs@vger.kernel.org, Andrey Albershteyn <aalbersh@kernel.org>, 
	"Darrick J. Wong" <djwong@kernel.org>
Subject: Re: [PATCH v4 2/3] generic: introduce test to test
 file_getattr/file_setattr syscalls
Message-ID: <zg4q7gnriwp64i7elakbvfxcukva7neq5qqcg7lyzglmmdduxm@6texsbefmit6>
References: <20251003-xattrat-syscall-v4-0-1cfe6411c05f@kernel.org>
 <20251003-xattrat-syscall-v4-2-1cfe6411c05f@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251003-xattrat-syscall-v4-2-1cfe6411c05f@kernel.org>

On 2025-10-03 11:32:45, Andrey Albershteyn wrote:
> Add a test to test basic functionality of file_getattr() and
> file_setattr() syscalls. Most of the work is done in file_attr
> utility.
> 
> Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
> Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

ops, Darrick, I forgot to drop your rvb tag as I changed this a bit,
let me know if you have any comments or if I need to resend without
it

> ---
>  common/filter          |  15 +++++++
>  tests/generic/2000     | 109 +++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/generic/2000.out |  37 +++++++++++++++++
>  3 files changed, 161 insertions(+)
> 
> diff --git a/common/filter b/common/filter
> index bbe13f4c8a8d..b330b27827d0 100644
> --- a/common/filter
> +++ b/common/filter
> @@ -683,5 +683,20 @@ _filter_sysfs_error()
>  	sed 's/.*: \(.*\)$/\1/'
>  }
>  
> +# Filter file attributes (aka lsattr/chattr)
> +# To filter X:
> +# 	... | _filter_file_attributes X
> +# Or to filter all except X
> +# 	... | _filter_file_attributes ~X
> +_filter_file_attributes()
> +{
> +	if [[ $1 == ~* ]]; then
> +		regex=$(echo "[aAcCdDeEFijmNPsStTuxVX]" | tr -d "$1")
> +	else
> +		regex="$1"
> +	fi
> +	awk "{ printf \"%s \", gensub(\"$regex\", \"-\", \"g\", \$1) } {print \$2}"
> +}
> +

this is new

>  # make sure this script returns success
>  /bin/true
> diff --git a/tests/generic/2000 b/tests/generic/2000
> new file mode 100755
> index 000000000000..16045829031a
> --- /dev/null
> +++ b/tests/generic/2000
> @@ -0,0 +1,109 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2025 Red Hat Inc.  All Rights Reserved.
> +#
> +# FS QA Test No. 2000
> +#
> +# Test file_getattr/file_setattr syscalls
> +#
> +. ./common/preamble
> +_begin_fstest auto
> +
> +. ./common/filter
> +
> +# Modify as appropriate.
> +_require_scratch
> +_require_test_program "af_unix"
> +_require_test_program "file_attr"
> +_require_symlinks
> +_require_mknod
> +
> +_scratch_mkfs >>$seqres.full 2>&1
> +_scratch_mount
> +
> +file_attr () {
> +	$here/src/file_attr $*
> +}
> +
> +create_af_unix () {
> +	$here/src/af_unix $* || echo af_unix failed
> +}
> +
> +projectdir=$SCRATCH_MNT/prj
> +
> +# Create normal files and special files
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
> +echo "Error codes"
> +# wrong AT_ flags
> +file_attr --get --invalid-at $projectdir ./foo
> +file_attr --set --invalid-at $projectdir ./foo
> +# wrong fsxattr size (too big, too small)
> +file_attr --get --too-big-arg $projectdir ./foo
> +file_attr --get --too-small-arg $projectdir ./foo
> +file_attr --set --too-big-arg $projectdir ./foo
> +file_attr --set --too-small-arg $projectdir ./foo
> +# out of fsx_xflags mask
> +file_attr --set --new-fsx-flag $projectdir ./foo
> +
> +echo "Initial attributes state"
> +file_attr --get $projectdir | _filter_scratch | _filter_file_attributes ~d

						 ^^^^^^^^^^^^^^^^^^^^^^^^^^^^
						 this filter is new
						 in the test

-- 
- Andrey

> +file_attr --get $projectdir ./fifo | _filter_file_attributes ~d
> +file_attr --get $projectdir ./chardev | _filter_file_attributes ~d
> +file_attr --get $projectdir ./blockdev | _filter_file_attributes ~d
> +file_attr --get $projectdir ./socket | _filter_file_attributes ~d
> +file_attr --get $projectdir ./foo | _filter_file_attributes ~d
> +file_attr --get $projectdir ./symlink | _filter_file_attributes ~d
> +
> +echo "Set FS_XFLAG_NODUMP (d)"
> +file_attr --set --set-nodump $projectdir
> +file_attr --set --set-nodump $projectdir ./fifo
> +file_attr --set --set-nodump $projectdir ./chardev
> +file_attr --set --set-nodump $projectdir ./blockdev
> +file_attr --set --set-nodump $projectdir ./socket
> +file_attr --set --set-nodump $projectdir ./foo
> +file_attr --set --set-nodump $projectdir ./symlink
> +
> +echo "Read attributes"
> +file_attr --get $projectdir | _filter_scratch | _filter_file_attributes ~d
> +file_attr --get $projectdir ./fifo | _filter_file_attributes ~d
> +file_attr --get $projectdir ./chardev | _filter_file_attributes ~d
> +file_attr --get $projectdir ./blockdev | _filter_file_attributes ~d
> +file_attr --get $projectdir ./socket | _filter_file_attributes ~d
> +file_attr --get $projectdir ./foo | _filter_file_attributes ~d
> +file_attr --get $projectdir ./symlink | _filter_file_attributes ~d
> +
> +echo "Set attribute on broken link with AT_SYMLINK_NOFOLLOW"
> +file_attr --set --set-nodump $projectdir ./broken-symlink
> +file_attr --get $projectdir ./broken-symlink
> +
> +file_attr --set --no-follow --set-nodump $projectdir ./broken-symlink
> +file_attr --get --no-follow $projectdir ./broken-symlink | _filter_file_attributes ~d
> +
> +cd $SCRATCH_MNT
> +touch ./foo2
> +echo "Initial state of foo2"
> +file_attr --get --at-cwd ./foo2 | _filter_file_attributes ~d
> +echo "Set attribute relative to AT_FDCWD"
> +file_attr --set --at-cwd --set-nodump ./foo2
> +file_attr --get --at-cwd ./foo2 | _filter_file_attributes ~d
> +
> +echo "Set attribute on AT_FDCWD"
> +mkdir ./bar
> +file_attr --get --at-cwd ./bar | _filter_file_attributes ~d
> +cd ./bar
> +file_attr --set --at-cwd --set-nodump ""
> +file_attr --get --at-cwd . | _filter_file_attributes ~d
> +
> +# success, all done
> +status=0
> +exit
> diff --git a/tests/generic/2000.out b/tests/generic/2000.out
> new file mode 100644
> index 000000000000..e6fc7381709b
> --- /dev/null
> +++ b/tests/generic/2000.out
> @@ -0,0 +1,37 @@
> +QA output created by 2000
> +Error codes
> +Can not get fsxattr on ./foo: Invalid argument
> +Can not get fsxattr on ./foo: Invalid argument
> +Can not get fsxattr on ./foo: Argument list too long
> +Can not get fsxattr on ./foo: Invalid argument
> +Can not get fsxattr on ./foo: Argument list too long
> +Can not get fsxattr on ./foo: Invalid argument
> +Can not set fsxattr on ./foo: Invalid argument
> +Initial attributes state
> +----------------- SCRATCH_MNT/prj
> +----------------- ./fifo
> +----------------- ./chardev
> +----------------- ./blockdev
> +----------------- ./socket
> +----------------- ./foo
> +----------------- ./symlink
> +Set FS_XFLAG_NODUMP (d)
> +Read attributes
> +------d---------- SCRATCH_MNT/prj
> +------d---------- ./fifo
> +------d---------- ./chardev
> +------d---------- ./blockdev
> +------d---------- ./socket
> +------d---------- ./foo
> +------d---------- ./symlink
> +Set attribute on broken link with AT_SYMLINK_NOFOLLOW
> +Can not get fsxattr on ./broken-symlink: No such file or directory
> +Can not get fsxattr on ./broken-symlink: No such file or directory
> +------d---------- ./broken-symlink
> +Initial state of foo2
> +----------------- ./foo2
> +Set attribute relative to AT_FDCWD
> +------d---------- ./foo2
> +Set attribute on AT_FDCWD
> +----------------- ./bar
> +------d---------- .
> 
> -- 
> 2.50.1
> 

