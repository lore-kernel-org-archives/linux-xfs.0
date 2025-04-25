Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07485101DE
	for <linux-xfs@vger.kernel.org>; Fri, 25 Apr 2025 13:36:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745588221; cv=none; b=euCMZkCh8/3DV1pFtHKeTZm3dc/ySxYwDWAOcCvb6rz47XvsEsOUXU+xE8niyJxsSHYJTSA7Dw+lPfbolkldiqcKdfCXioLCKsnNxqBU9XwzoS/+bdDeATLv66Us0PZQBKk9t372Iz/RlTQr6hd1vLQ487ufV8Etv4N9wrkNsGo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745588221; c=relaxed/simple;
	bh=V5ggDDxC0m+mjJaKFOC1WXP2nwIMmLEgInb16OKMH7c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FQevidTdJcOeWWlDNm8qFawTNNoxDKl+tLg8S2itqdMu3g9rkSYFI+LjXX2++wpmORtVS2kJ0Mje78x7RAcE0r/o86Upa8wFmpGR0vrmXUxVj97keGK7bldBXPTsX7ClVeoJgwt045DGnFuRyCkrtx2ZNzzia2z+zTDfKxa3K6E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ZZpytW2S; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZZpytW2S"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1745588216;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=bsa3XznCsXi0l1Az/tg7zffswx+H0UzUP3bSBrZZzNU=;
	b=ZZpytW2SI86zSqQi0rI9yp3uVuSNcICxUxmQAYXojDSNhLpRMkjWyTq5d+jx76Uy1Yg0BB
	v659Q8JCZu9Uj6WYo5DGWjgDV4mNM1lyoH33/84kX9O72Dp84MN9766IQMGPG84JGHlQl/
	EGnrIRFc0vjb6u0bFywMmRpzXq3y5VA=
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com
 [209.85.216.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-125-0oa3YAiXNFeCclNtps75Aw-1; Fri, 25 Apr 2025 09:36:55 -0400
X-MC-Unique: 0oa3YAiXNFeCclNtps75Aw-1
X-Mimecast-MFC-AGG-ID: 0oa3YAiXNFeCclNtps75Aw_1745588214
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-306b590faaeso1861449a91.3
        for <linux-xfs@vger.kernel.org>; Fri, 25 Apr 2025 06:36:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745588214; x=1746193014;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bsa3XznCsXi0l1Az/tg7zffswx+H0UzUP3bSBrZZzNU=;
        b=F+D2Xqkp7ry/2+3mFky1VFtV8vPEnHu3ckhdTzKEHHVHuPqx3qt0H/+fMFGC9AE4uz
         7g7YOnfcGBIBDwO5E1oRg9kS4RkCxbJzVyuy8rD86JLVzxTqqamcBYhIHdf6gePY4ZyV
         wshgL3rtGt1A1qj3nx/ladq8+MwyzweY5jAkgqpjMtkB4b15xs3YlMho0Qo3y00SsZ85
         SiRxTW6dRFKVwvuwqYvoOcb4I2emauuLtodKD1kYMIjY2QIbm7oQrP/N095x5HfKiK7S
         mTkD4IZW8sfAcX/EpiP/FEhgU9gV6Q1CjRgvNyiItubU60hCjGd2eXYGYO03h7s/jgud
         2gTg==
X-Forwarded-Encrypted: i=1; AJvYcCXJvABtKQXytaFvh4WPn1CLVCD+1hkGs+zPwMBrEWBxBbmP9O10oiPT2JwIMC3iT5b+gJYi5+d+/Zk=@vger.kernel.org
X-Gm-Message-State: AOJu0YyxbJPlKg7CdAysOTfS7F1L5eINCd5NrJDyGiKuZq5Q7nufD5Mx
	f1/d1y801Gi0OVFn9T2b4EsMH/V++EguxV4/QEVdBklPg4k6poHd+8ZkSR8XfwG2o0Qk47yNGD8
	1LMra32xu0ZA0w+gE4sp6CimYAK8r1mQ2gCTU+BLI1XVdxruS60e8cQyoig==
X-Gm-Gg: ASbGnctc31mj1EAfMwIFlt2RrS6sN24oELN060oGJz7tQOeQA4QOh6JIFzgwzuYswRm
	iRjT40fmH1JrMyBKi1Y7+L9u0HolxHIS0ZYzAhf/FzHb4q60akbP0wySElq6G92lbFJksSen/f9
	f4OVyWSlpifz1aPNkbKjiCQCYsWvnZ5nrzaSJFg41GH9AlNrH/dsOBH0xmaMkJk6px31vRh8nG2
	kEwmc8CRaak3pjJ1+0VlqlQY09lf07Nkv+ZlACGSqQJ9YcQQGVa9y4nYsl9wG/uTyG2uH+cOSD3
	rzsWdL1ndfRWhP6/dKSd3+J1AnHCVl131TvByBkXdy1xTJ8OcWH0
X-Received: by 2002:a17:90b:4e8e:b0:309:e195:59d4 with SMTP id 98e67ed59e1d1-309f7dd8957mr4694323a91.12.1745588214350;
        Fri, 25 Apr 2025 06:36:54 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEUV8wyJbS7P7I2r72x0zMp1bHmBaCZvnqHfQmzazI6jgQZIXrSd/FrJladtzhzfcorOjzBOA==
X-Received: by 2002:a17:90b:4e8e:b0:309:e195:59d4 with SMTP id 98e67ed59e1d1-309f7dd8957mr4694271a91.12.1745588213879;
        Fri, 25 Apr 2025 06:36:53 -0700 (PDT)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([209.132.188.88])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22db5104dd2sm31784155ad.203.2025.04.25.06.36.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Apr 2025 06:36:53 -0700 (PDT)
Date: Fri, 25 Apr 2025 21:36:48 +0800
From: Zorro Lang <zlang@redhat.com>
To: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>
Cc: fstests@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org, ritesh.list@gmail.com,
	ojaswin@linux.ibm.com, djwong@kernel.org, zlang@kernel.org,
	david@fromorbit.com
Subject: Re: [PATCH v1 1/2] common: Move exit related functions to a
 common/exit
Message-ID: <20250425133648.5uygihyqo7vqofi3@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <cover.1745390030.git.nirjhar.roy.lists@gmail.com>
 <d0b7939a277e8a16566f04e449e9a1f97da28b9d.1745390030.git.nirjhar.roy.lists@gmail.com>
 <20250423141808.2qdmacsyxu3rtrwh@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
 <054fa772-360e-4f90-bc4d-ea7ef954d5a2@gmail.com>
 <20250425112745.aaamjdvhqtlx7vpd@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
 <175d064b-76a5-4ff8-a34f-358f0e0d6baa@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <175d064b-76a5-4ff8-a34f-358f0e0d6baa@gmail.com>

On Fri, Apr 25, 2025 at 05:33:24PM +0530, Nirjhar Roy (IBM) wrote:
> 
> On 4/25/25 16:57, Zorro Lang wrote:
> > On Thu, Apr 24, 2025 at 02:39:39PM +0530, Nirjhar Roy (IBM) wrote:
> > > On 4/23/25 19:48, Zorro Lang wrote:
> > > > On Wed, Apr 23, 2025 at 06:41:34AM +0000, Nirjhar Roy (IBM) wrote:
> > > > > Introduce a new file common/exit that will contain all the exit
> > > > > related functions. This will remove the dependencies these functions
> > > > > have on other non-related helper files and they can be indepedently
> > > > > sourced. This was suggested by Dave Chinner[1].
> > > > > 
> > > > > [1] https://lore.kernel.org/linux-xfs/Z_UJ7XcpmtkPRhTr@dread.disaster.area/
> > > > > Suggested-by: Dave Chinner <david@fromorbit.com>
> > > > > Signed-off-by: Nirjhar Roy (IBM) <nirjhar.roy.lists@gmail.com>
> > > > > ---
> > > > >    check           |  1 +
> > > > >    common/btrfs    |  2 +-
> > > > >    common/ceph     |  2 ++
> > > > >    common/config   | 17 +----------------
> > > > >    common/dump     |  1 +
> > > > >    common/exit     | 50 +++++++++++++++++++++++++++++++++++++++++++++++++
> > > > >    common/ext4     |  2 +-
> > > > >    common/populate |  2 +-
> > > > >    common/preamble |  1 +
> > > > >    common/punch    |  6 +-----
> > > > >    common/rc       | 29 +---------------------------
> > > > >    common/repair   |  1 +
> > > > >    common/xfs      |  1 +
> > > > I think if you define exit helpers in common/exit, and import common/exit
> > > > in common/config, then you don't need to source it(common/exit) in other
> > > > common files (.e.g common/xfs, common/rc, etc). Due to when we call the
> > > > helpers in these common files, the process should already imported
> > > > common/rc -> common/config -> common/exit. right?
> > > Oh, right. I can remove the redundant imports from
> > > common/{btrfs,ceph,dump,ext4,populate,preamble,punch,rc,repair,xfs} in v2. I
> > > will keep ". common/exit" only in common/config and check. The reason for me
> > > to keep it in check is that before common/rc is sourced in check, we might
> > > need _exit() (which is present is common/exit). Do you agree?
> > I thought "check" might not need that either. I didn't give it a test, but I found
> > before importing common/rc, there're only command arguments initialization, and
> > "check" calls "exit" directly if the initialization fails (except you want to call
> > _exit, but I didn't see you change that).
> 
> Yes, I have changed the exit() to _exit() in "check" in the next patch [1]
> of this series. Can you please take a look at that patch[1] and suggest
> whether I should have ". common/exit" in "check" or not?
> 
> 
> [1] https://lore.kernel.org/all/7d8587b8342ee2cbe226fb691b372ac7df5fdb71.1745390030.git.nirjhar.roy.lists@gmail.com/

Oh, as "check" has:

  if $OPTIONS_HAVE_SECTIONS; then
          trap "_summary; exit \$status" 0 1 2 3 15
  else
          trap "_wrapup; exit \$status" 0 1 2 3 15
  fi

So I think it makes sense to use _exit() to deal with status variable :)

> 
> --NR
> 
> > 
> > Thanks,
> > Zorro
> > 
> > > --NR
> > > 
> > > > Thanks,
> > > > Zorro
> > > > 
> > > > >    13 files changed, 63 insertions(+), 52 deletions(-)
> > > > >    create mode 100644 common/exit
> > > > > 
> > > > > diff --git a/check b/check
> > > > > index 9451c350..67355c52 100755
> > > > > --- a/check
> > > > > +++ b/check
> > > > > @@ -51,6 +51,7 @@ rm -f $tmp.list $tmp.tmp $tmp.grep $here/$iam.out $tmp.report.* $tmp.arglist
> > > > >    SRC_GROUPS="generic"
> > > > >    export SRC_DIR="tests"
> > > > > +. common/exit
> > > > >    usage()
> > > > >    {
> > > > > diff --git a/common/btrfs b/common/btrfs
> > > > > index 3725632c..9e91ee71 100644
> > > > > --- a/common/btrfs
> > > > > +++ b/common/btrfs
> > > > > @@ -1,7 +1,7 @@
> > > > >    #
> > > > >    # Common btrfs specific functions
> > > > >    #
> > > > > -
> > > > > +. common/exit
> > > > >    . common/module
> > > > >    # The recommended way to execute simple "btrfs" command.
> > > > > diff --git a/common/ceph b/common/ceph
> > > > > index df7a6814..89e36403 100644
> > > > > --- a/common/ceph
> > > > > +++ b/common/ceph
> > > > > @@ -2,6 +2,8 @@
> > > > >    # CephFS specific common functions.
> > > > >    #
> > > > > +. common/exit
> > > > > +
> > > > >    # _ceph_create_file_layout <filename> <stripe unit> <stripe count> <object size>
> > > > >    # This function creates a new empty file and sets the file layout according to
> > > > >    # parameters.  It will exit if the file already exists.
> > > > > diff --git a/common/config b/common/config
> > > > > index eada3971..6a60d144 100644
> > > > > --- a/common/config
> > > > > +++ b/common/config
> > > > > @@ -38,7 +38,7 @@
> > > > >    # - this script shouldn't make any assertions about filesystem
> > > > >    #   validity or mountedness.
> > > > >    #
> > > > > -
> > > > > +. common/exit
> > > > >    . common/test_names
> > > > >    # all tests should use a common language setting to prevent golden
> > > > > @@ -96,15 +96,6 @@ export LOCAL_CONFIGURE_OPTIONS=${LOCAL_CONFIGURE_OPTIONS:=--enable-readline=yes}
> > > > >    export RECREATE_TEST_DEV=${RECREATE_TEST_DEV:=false}
> > > > > -# This functions sets the exit code to status and then exits. Don't use
> > > > > -# exit directly, as it might not set the value of "$status" correctly, which is
> > > > > -# used as an exit code in the trap handler routine set up by the check script.
> > > > > -_exit()
> > > > > -{
> > > > > -	test -n "$1" && status="$1"
> > > > > -	exit "$status"
> > > > > -}
> > > > > -
> > > > >    # Handle mkfs.$fstyp which does (or does not) require -f to overwrite
> > > > >    set_mkfs_prog_path_with_opts()
> > > > >    {
> > > > > @@ -121,12 +112,6 @@ set_mkfs_prog_path_with_opts()
> > > > >    	fi
> > > > >    }
> > > > > -_fatal()
> > > > > -{
> > > > > -    echo "$*"
> > > > > -    _exit 1
> > > > > -}
> > > > > -
> > > > >    export MKFS_PROG="$(type -P mkfs)"
> > > > >    [ "$MKFS_PROG" = "" ] && _fatal "mkfs not found"
> > > > > diff --git a/common/dump b/common/dump
> > > > > index 09859006..4701a956 100644
> > > > > --- a/common/dump
> > > > > +++ b/common/dump
> > > > > @@ -3,6 +3,7 @@
> > > > >    # Copyright (c) 2000-2002,2005 Silicon Graphics, Inc.  All Rights Reserved.
> > > > >    #
> > > > >    # Functions useful for xfsdump/xfsrestore tests
> > > > > +. common/exit
> > > > >    # --- initializations ---
> > > > >    rm -f $seqres.full
> > > > > diff --git a/common/exit b/common/exit
> > > > > new file mode 100644
> > > > > index 00000000..ad7e7498
> > > > > --- /dev/null
> > > > > +++ b/common/exit
> > > > > @@ -0,0 +1,50 @@
> > > > > +##/bin/bash
> > > > > +
> > > > > +# This functions sets the exit code to status and then exits. Don't use
> > > > > +# exit directly, as it might not set the value of "$status" correctly, which is
> > > > > +# used as an exit code in the trap handler routine set up by the check script.
> > > > > +_exit()
> > > > > +{
> > > > > +	test -n "$1" && status="$1"
> > > > > +	exit "$status"
> > > > > +}
> > > > > +
> > > > > +_fatal()
> > > > > +{
> > > > > +    echo "$*"
> > > > > +    _exit 1
> > > > > +}
> > > > > +
> > > > > +_die()
> > > > > +{
> > > > > +        echo $@
> > > > > +        _exit 1
> > > > > +}
> > > > > +
> > > > > +die_now()
> > > > > +{
> > > > > +	_exit 1
> > > > > +}
> > > > > +
> > > > > +# just plain bail out
> > > > > +#
> > > > > +_fail()
> > > > > +{
> > > > > +    echo "$*" | tee -a $seqres.full
> > > > > +    echo "(see $seqres.full for details)"
> > > > > +    _exit 1
> > > > > +}
> > > > > +
> > > > > +# bail out, setting up .notrun file. Need to kill the filesystem check files
> > > > > +# here, otherwise they are set incorrectly for the next test.
> > > > > +#
> > > > > +_notrun()
> > > > > +{
> > > > > +    echo "$*" > $seqres.notrun
> > > > > +    echo "$seq not run: $*"
> > > > > +    rm -f ${RESULT_DIR}/require_test*
> > > > > +    rm -f ${RESULT_DIR}/require_scratch*
> > > > > +
> > > > > +    _exit 0
> > > > > +}
> > > > > +
> > > > > diff --git a/common/ext4 b/common/ext4
> > > > > index f88fa532..ab566c41 100644
> > > > > --- a/common/ext4
> > > > > +++ b/common/ext4
> > > > > @@ -1,7 +1,7 @@
> > > > >    #
> > > > >    # ext4 specific common functions
> > > > >    #
> > > > > -
> > > > > +. common/exit
> > > > >    __generate_ext4_report_vars() {
> > > > >    	__generate_blockdev_report_vars TEST_LOGDEV
> > > > >    	__generate_blockdev_report_vars SCRATCH_LOGDEV
> > > > > diff --git a/common/populate b/common/populate
> > > > > index 50dc75d3..a17acc9e 100644
> > > > > --- a/common/populate
> > > > > +++ b/common/populate
> > > > > @@ -4,7 +4,7 @@
> > > > >    #
> > > > >    # Routines for populating a scratch fs, and helpers to exercise an FS
> > > > >    # once it's been fuzzed.
> > > > > -
> > > > > +. common/exit
> > > > >    . ./common/quota
> > > > >    _require_populate_commands() {
> > > > > diff --git a/common/preamble b/common/preamble
> > > > > index ba029a34..0f306412 100644
> > > > > --- a/common/preamble
> > > > > +++ b/common/preamble
> > > > > @@ -3,6 +3,7 @@
> > > > >    # Copyright (c) 2021 Oracle.  All Rights Reserved.
> > > > >    # Boilerplate fstests functionality
> > > > > +. common/exit
> > > > >    # Standard cleanup function.  Individual tests can override this.
> > > > >    _cleanup()
> > > > > diff --git a/common/punch b/common/punch
> > > > > index 64d665d8..637f463f 100644
> > > > > --- a/common/punch
> > > > > +++ b/common/punch
> > > > > @@ -3,6 +3,7 @@
> > > > >    # Copyright (c) 2007 Silicon Graphics, Inc.  All Rights Reserved.
> > > > >    #
> > > > >    # common functions for excersizing hole punches with extent size hints etc.
> > > > > +. common/exit
> > > > >    _spawn_test_file() {
> > > > >    	echo "# spawning test file with $*"
> > > > > @@ -222,11 +223,6 @@ _filter_bmap()
> > > > >    	_coalesce_extents
> > > > >    }
> > > > > -die_now()
> > > > > -{
> > > > > -	_exit 1
> > > > > -}
> > > > > -
> > > > >    # test the different corner cases for zeroing a range:
> > > > >    #
> > > > >    #	1. into a hole
> > > > > diff --git a/common/rc b/common/rc
> > > > > index 9bed6dad..945f5134 100644
> > > > > --- a/common/rc
> > > > > +++ b/common/rc
> > > > > @@ -2,6 +2,7 @@
> > > > >    # SPDX-License-Identifier: GPL-2.0+
> > > > >    # Copyright (c) 2000-2006 Silicon Graphics, Inc.  All Rights Reserved.
> > > > > +. common/exit
> > > > >    . common/config
> > > > >    BC="$(type -P bc)" || BC=
> > > > > @@ -1798,28 +1799,6 @@ _do()
> > > > >        return $ret
> > > > >    }
> > > > > -# bail out, setting up .notrun file. Need to kill the filesystem check files
> > > > > -# here, otherwise they are set incorrectly for the next test.
> > > > > -#
> > > > > -_notrun()
> > > > > -{
> > > > > -    echo "$*" > $seqres.notrun
> > > > > -    echo "$seq not run: $*"
> > > > > -    rm -f ${RESULT_DIR}/require_test*
> > > > > -    rm -f ${RESULT_DIR}/require_scratch*
> > > > > -
> > > > > -    _exit 0
> > > > > -}
> > > > > -
> > > > > -# just plain bail out
> > > > > -#
> > > > > -_fail()
> > > > > -{
> > > > > -    echo "$*" | tee -a $seqres.full
> > > > > -    echo "(see $seqres.full for details)"
> > > > > -    _exit 1
> > > > > -}
> > > > > -
> > > > >    #
> > > > >    # Tests whether $FSTYP should be exclude from this test.
> > > > >    #
> > > > > @@ -3835,12 +3814,6 @@ _link_out_file()
> > > > >    	_link_out_file_named $seqfull.out "$features"
> > > > >    }
> > > > > -_die()
> > > > > -{
> > > > > -        echo $@
> > > > > -        _exit 1
> > > > > -}
> > > > > -
> > > > >    # convert urandom incompressible data to compressible text data
> > > > >    _ddt()
> > > > >    {
> > > > > diff --git a/common/repair b/common/repair
> > > > > index fd206f8e..db6a1b5c 100644
> > > > > --- a/common/repair
> > > > > +++ b/common/repair
> > > > > @@ -3,6 +3,7 @@
> > > > >    # Copyright (c) 2000-2002 Silicon Graphics, Inc.  All Rights Reserved.
> > > > >    #
> > > > >    # Functions useful for xfs_repair tests
> > > > > +. common/exit
> > > > >    _zero_position()
> > > > >    {
> > > > > diff --git a/common/xfs b/common/xfs
> > > > > index 96c15f3c..c236146c 100644
> > > > > --- a/common/xfs
> > > > > +++ b/common/xfs
> > > > > @@ -1,6 +1,7 @@
> > > > >    #
> > > > >    # XFS specific common functions.
> > > > >    #
> > > > > +. common/exit
> > > > >    __generate_xfs_report_vars() {
> > > > >    	__generate_blockdev_report_vars TEST_RTDEV
> > > > > -- 
> > > > > 2.34.1
> > > > > 
> > > -- 
> > > Nirjhar Roy
> > > Linux Kernel Developer
> > > IBM, Bangalore
> > > 
> -- 
> Nirjhar Roy
> Linux Kernel Developer
> IBM, Bangalore
> 

