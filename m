Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4BD627C87C
	for <linux-xfs@vger.kernel.org>; Wed, 23 Apr 2025 14:18:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745417903; cv=none; b=DKBMAd8GwOYRu2DZBLMp1bbSrzfSabEIOszrjWZDSPeu20GiAp+JSt6n+VW4jg7VLlvXdXArtklE25Eje4ArkKlWiqjoGE9c2sOhYdQW49A0dl8dCFGHV/Kpsw9DZGtrIknumtjp4nzcNBcru4obX8TiSTOxQRsI0oSaO4A8pjM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745417903; c=relaxed/simple;
	bh=TUvg4ARG4Smble6Dlvk2B5zrYTtTh7sKlkaZQNiowYo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FShnYe6pQ2rOdVeC/YORHXT6rRnyV/KWuhi1luijdz0u/4fSKHFluuDt+tfP8UVifX9SIHqHAEJPkM+KmRICNvEFWf9UWUyhspRtgN/BDRwzs2u5PmSyvmKxxcICllSEDSzbhOp3XMQZfxvapanDxbttXYKndMG8t7cJw43RHqY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=hb1y5z5c; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hb1y5z5c"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1745417900;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=hsn9CH6/nAt1LGWpd4X879LvaqHmIn9XeRJNFLaTOx0=;
	b=hb1y5z5c/0shQUysQCzxOnxGWpIeG6XwJjpScvw/v6l75Jhr/pUhzszxxEL0qaqijHv6/q
	7+qHN7GeLx8RunOtBOQCYAFc1LDY3QL/IQPsOZ3fVFw1oF4EoHETMqj1SpHHEZv7o7PeWP
	jUucMiBGlhsVIx9ZSl/IAqB5opS7RYE=
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-67-NZfZupx1O_yXlFb6ZDVycQ-1; Wed, 23 Apr 2025 10:18:16 -0400
X-MC-Unique: NZfZupx1O_yXlFb6ZDVycQ-1
X-Mimecast-MFC-AGG-ID: NZfZupx1O_yXlFb6ZDVycQ_1745417895
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-2254e500a73so43550395ad.0
        for <linux-xfs@vger.kernel.org>; Wed, 23 Apr 2025 07:18:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745417895; x=1746022695;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hsn9CH6/nAt1LGWpd4X879LvaqHmIn9XeRJNFLaTOx0=;
        b=qxhkJC7JGi6405INjcKj9qd1Ercu0N8iiIUu9deKUpObsN2nWEskdFxuvk1Vpfubud
         EpMEXonOBk1OdSB41Sx2SennaJrsX+8RImRlp6YkUdPdzlu1lpdEYnykGZz1yuVTGx2e
         12sZevEb1/jvcr2F6RmBNERwtVgJ3XQZxykWNhyoXfBSKyQXYwke0ASYYco5KmIMCxZ1
         R7O6WJENE+FrICVTK5VQvGq4/nrLMuMtgd6DYVF4SUn59MpPJJRvG4Q9QCh8T2iH6pWn
         QZU+3xAAa43xOKs7xkQZysF98Ni0RTh4Ivv2k8qs0jpHGZsukqAbD+8BYFrl/Vt465tb
         5h8Q==
X-Forwarded-Encrypted: i=1; AJvYcCUAYCFuQqNyK222lDmPV4judLzz7p+53bkcSx2W4E73Wj78mP5QyjQgFdWw/QjVoCR3OdpXS8A0bcA=@vger.kernel.org
X-Gm-Message-State: AOJu0YycvEsrCrE2PecYC3Td4JqAQBZCW3BHha7fnW24p+SyFWAXhMdB
	t1DSqbYimdpBwmivHI/KpnNih8pkvXG6KM5Cs1jjYTUpiaevzF+yITEbAEXGDcDFXf20tBcpstu
	yk+vtmujrQV5WB+KF6tdAQ3c7SvoEifmJDkMyd0hYf0smAKUWI7zxcqoVYQ==
X-Gm-Gg: ASbGnctQUzKlamcIasD0NOIwi7EtjmKR1QvkwXtgkhvv3bXrOqVKCFnvUAw8U9+96zo
	0vz8YL70xC89mhG5bpXHgQO1fzR2DpNAq3k8Kzl/5Qus780AV6So7TQMSYWl5DmE4YFA8VXnRbG
	WvEuR0J6c9SeFu4GzjpNshAjTikfF/9u01dQEU51OD+xXOPMckXUe8y2NGbnTTChkpeUVdAOzTn
	+yr51A0WfpaXqWsxNH09DNwVzMGkZ3bA/Zd7i5319Zp/mCEVX3mqcXN0SkAACViaVK5l9C5CDN8
	92kZzr9ZIaa2cs/kyrq0+gPJkBqyvD7ol0cmx7iFGRTz22ri9HZ3
X-Received: by 2002:a17:903:240a:b0:220:fce7:d3a6 with SMTP id d9443c01a7336-22c535aeb6fmr295249355ad.23.1745417894969;
        Wed, 23 Apr 2025 07:18:14 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGw6u37V2Z+2+2l2vO45PELpooTb5LqcTRommPQW7L9w0GU7xJdUSOARAAAm2RWryDIBd3qiw==
X-Received: by 2002:a17:903:240a:b0:220:fce7:d3a6 with SMTP id d9443c01a7336-22c535aeb6fmr295248825ad.23.1745417894570;
        Wed, 23 Apr 2025 07:18:14 -0700 (PDT)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([209.132.188.88])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22c50eb4b58sm104596435ad.109.2025.04.23.07.18.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Apr 2025 07:18:14 -0700 (PDT)
Date: Wed, 23 Apr 2025 22:18:08 +0800
From: Zorro Lang <zlang@redhat.com>
To: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>
Cc: fstests@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org, ritesh.list@gmail.com,
	ojaswin@linux.ibm.com, djwong@kernel.org, zlang@kernel.org,
	david@fromorbit.com
Subject: Re: [PATCH v1 1/2] common: Move exit related functions to a
 common/exit
Message-ID: <20250423141808.2qdmacsyxu3rtrwh@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <cover.1745390030.git.nirjhar.roy.lists@gmail.com>
 <d0b7939a277e8a16566f04e449e9a1f97da28b9d.1745390030.git.nirjhar.roy.lists@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d0b7939a277e8a16566f04e449e9a1f97da28b9d.1745390030.git.nirjhar.roy.lists@gmail.com>

On Wed, Apr 23, 2025 at 06:41:34AM +0000, Nirjhar Roy (IBM) wrote:
> Introduce a new file common/exit that will contain all the exit
> related functions. This will remove the dependencies these functions
> have on other non-related helper files and they can be indepedently
> sourced. This was suggested by Dave Chinner[1].
> 
> [1] https://lore.kernel.org/linux-xfs/Z_UJ7XcpmtkPRhTr@dread.disaster.area/
> Suggested-by: Dave Chinner <david@fromorbit.com>
> Signed-off-by: Nirjhar Roy (IBM) <nirjhar.roy.lists@gmail.com>
> ---
>  check           |  1 +
>  common/btrfs    |  2 +-
>  common/ceph     |  2 ++
>  common/config   | 17 +----------------
>  common/dump     |  1 +
>  common/exit     | 50 +++++++++++++++++++++++++++++++++++++++++++++++++
>  common/ext4     |  2 +-
>  common/populate |  2 +-
>  common/preamble |  1 +
>  common/punch    |  6 +-----
>  common/rc       | 29 +---------------------------
>  common/repair   |  1 +
>  common/xfs      |  1 +

I think if you define exit helpers in common/exit, and import common/exit
in common/config, then you don't need to source it(common/exit) in other
common files (.e.g common/xfs, common/rc, etc). Due to when we call the
helpers in these common files, the process should already imported
common/rc -> common/config -> common/exit. right?

Thanks,
Zorro

>  13 files changed, 63 insertions(+), 52 deletions(-)
>  create mode 100644 common/exit
> 
> diff --git a/check b/check
> index 9451c350..67355c52 100755
> --- a/check
> +++ b/check
> @@ -51,6 +51,7 @@ rm -f $tmp.list $tmp.tmp $tmp.grep $here/$iam.out $tmp.report.* $tmp.arglist
>  
>  SRC_GROUPS="generic"
>  export SRC_DIR="tests"
> +. common/exit
>  
>  usage()
>  {
> diff --git a/common/btrfs b/common/btrfs
> index 3725632c..9e91ee71 100644
> --- a/common/btrfs
> +++ b/common/btrfs
> @@ -1,7 +1,7 @@
>  #
>  # Common btrfs specific functions
>  #
> -
> +. common/exit
>  . common/module
>  
>  # The recommended way to execute simple "btrfs" command.
> diff --git a/common/ceph b/common/ceph
> index df7a6814..89e36403 100644
> --- a/common/ceph
> +++ b/common/ceph
> @@ -2,6 +2,8 @@
>  # CephFS specific common functions.
>  #
>  
> +. common/exit
> +
>  # _ceph_create_file_layout <filename> <stripe unit> <stripe count> <object size>
>  # This function creates a new empty file and sets the file layout according to
>  # parameters.  It will exit if the file already exists.
> diff --git a/common/config b/common/config
> index eada3971..6a60d144 100644
> --- a/common/config
> +++ b/common/config
> @@ -38,7 +38,7 @@
>  # - this script shouldn't make any assertions about filesystem
>  #   validity or mountedness.
>  #
> -
> +. common/exit
>  . common/test_names
>  
>  # all tests should use a common language setting to prevent golden
> @@ -96,15 +96,6 @@ export LOCAL_CONFIGURE_OPTIONS=${LOCAL_CONFIGURE_OPTIONS:=--enable-readline=yes}
>  
>  export RECREATE_TEST_DEV=${RECREATE_TEST_DEV:=false}
>  
> -# This functions sets the exit code to status and then exits. Don't use
> -# exit directly, as it might not set the value of "$status" correctly, which is
> -# used as an exit code in the trap handler routine set up by the check script.
> -_exit()
> -{
> -	test -n "$1" && status="$1"
> -	exit "$status"
> -}
> -
>  # Handle mkfs.$fstyp which does (or does not) require -f to overwrite
>  set_mkfs_prog_path_with_opts()
>  {
> @@ -121,12 +112,6 @@ set_mkfs_prog_path_with_opts()
>  	fi
>  }
>  
> -_fatal()
> -{
> -    echo "$*"
> -    _exit 1
> -}
> -
>  export MKFS_PROG="$(type -P mkfs)"
>  [ "$MKFS_PROG" = "" ] && _fatal "mkfs not found"
>  
> diff --git a/common/dump b/common/dump
> index 09859006..4701a956 100644
> --- a/common/dump
> +++ b/common/dump
> @@ -3,6 +3,7 @@
>  # Copyright (c) 2000-2002,2005 Silicon Graphics, Inc.  All Rights Reserved.
>  #
>  # Functions useful for xfsdump/xfsrestore tests
> +. common/exit
>  
>  # --- initializations ---
>  rm -f $seqres.full
> diff --git a/common/exit b/common/exit
> new file mode 100644
> index 00000000..ad7e7498
> --- /dev/null
> +++ b/common/exit
> @@ -0,0 +1,50 @@
> +##/bin/bash
> +
> +# This functions sets the exit code to status and then exits. Don't use
> +# exit directly, as it might not set the value of "$status" correctly, which is
> +# used as an exit code in the trap handler routine set up by the check script.
> +_exit()
> +{
> +	test -n "$1" && status="$1"
> +	exit "$status"
> +}
> +
> +_fatal()
> +{
> +    echo "$*"
> +    _exit 1
> +}
> +
> +_die()
> +{
> +        echo $@
> +        _exit 1
> +}
> +
> +die_now()
> +{
> +	_exit 1
> +}
> +
> +# just plain bail out
> +#
> +_fail()
> +{
> +    echo "$*" | tee -a $seqres.full
> +    echo "(see $seqres.full for details)"
> +    _exit 1
> +}
> +
> +# bail out, setting up .notrun file. Need to kill the filesystem check files
> +# here, otherwise they are set incorrectly for the next test.
> +#
> +_notrun()
> +{
> +    echo "$*" > $seqres.notrun
> +    echo "$seq not run: $*"
> +    rm -f ${RESULT_DIR}/require_test*
> +    rm -f ${RESULT_DIR}/require_scratch*
> +
> +    _exit 0
> +}
> +
> diff --git a/common/ext4 b/common/ext4
> index f88fa532..ab566c41 100644
> --- a/common/ext4
> +++ b/common/ext4
> @@ -1,7 +1,7 @@
>  #
>  # ext4 specific common functions
>  #
> -
> +. common/exit
>  __generate_ext4_report_vars() {
>  	__generate_blockdev_report_vars TEST_LOGDEV
>  	__generate_blockdev_report_vars SCRATCH_LOGDEV
> diff --git a/common/populate b/common/populate
> index 50dc75d3..a17acc9e 100644
> --- a/common/populate
> +++ b/common/populate
> @@ -4,7 +4,7 @@
>  #
>  # Routines for populating a scratch fs, and helpers to exercise an FS
>  # once it's been fuzzed.
> -
> +. common/exit
>  . ./common/quota
>  
>  _require_populate_commands() {
> diff --git a/common/preamble b/common/preamble
> index ba029a34..0f306412 100644
> --- a/common/preamble
> +++ b/common/preamble
> @@ -3,6 +3,7 @@
>  # Copyright (c) 2021 Oracle.  All Rights Reserved.
>  
>  # Boilerplate fstests functionality
> +. common/exit
>  
>  # Standard cleanup function.  Individual tests can override this.
>  _cleanup()
> diff --git a/common/punch b/common/punch
> index 64d665d8..637f463f 100644
> --- a/common/punch
> +++ b/common/punch
> @@ -3,6 +3,7 @@
>  # Copyright (c) 2007 Silicon Graphics, Inc.  All Rights Reserved.
>  #
>  # common functions for excersizing hole punches with extent size hints etc.
> +. common/exit
>  
>  _spawn_test_file() {
>  	echo "# spawning test file with $*"
> @@ -222,11 +223,6 @@ _filter_bmap()
>  	_coalesce_extents
>  }
>  
> -die_now()
> -{
> -	_exit 1
> -}
> -
>  # test the different corner cases for zeroing a range:
>  #
>  #	1. into a hole
> diff --git a/common/rc b/common/rc
> index 9bed6dad..945f5134 100644
> --- a/common/rc
> +++ b/common/rc
> @@ -2,6 +2,7 @@
>  # SPDX-License-Identifier: GPL-2.0+
>  # Copyright (c) 2000-2006 Silicon Graphics, Inc.  All Rights Reserved.
>  
> +. common/exit
>  . common/config
>  
>  BC="$(type -P bc)" || BC=
> @@ -1798,28 +1799,6 @@ _do()
>      return $ret
>  }
>  
> -# bail out, setting up .notrun file. Need to kill the filesystem check files
> -# here, otherwise they are set incorrectly for the next test.
> -#
> -_notrun()
> -{
> -    echo "$*" > $seqres.notrun
> -    echo "$seq not run: $*"
> -    rm -f ${RESULT_DIR}/require_test*
> -    rm -f ${RESULT_DIR}/require_scratch*
> -
> -    _exit 0
> -}
> -
> -# just plain bail out
> -#
> -_fail()
> -{
> -    echo "$*" | tee -a $seqres.full
> -    echo "(see $seqres.full for details)"
> -    _exit 1
> -}
> -
>  #
>  # Tests whether $FSTYP should be exclude from this test.
>  #
> @@ -3835,12 +3814,6 @@ _link_out_file()
>  	_link_out_file_named $seqfull.out "$features"
>  }
>  
> -_die()
> -{
> -        echo $@
> -        _exit 1
> -}
> -
>  # convert urandom incompressible data to compressible text data
>  _ddt()
>  {
> diff --git a/common/repair b/common/repair
> index fd206f8e..db6a1b5c 100644
> --- a/common/repair
> +++ b/common/repair
> @@ -3,6 +3,7 @@
>  # Copyright (c) 2000-2002 Silicon Graphics, Inc.  All Rights Reserved.
>  #
>  # Functions useful for xfs_repair tests
> +. common/exit
>  
>  _zero_position()
>  {
> diff --git a/common/xfs b/common/xfs
> index 96c15f3c..c236146c 100644
> --- a/common/xfs
> +++ b/common/xfs
> @@ -1,6 +1,7 @@
>  #
>  # XFS specific common functions.
>  #
> +. common/exit
>  
>  __generate_xfs_report_vars() {
>  	__generate_blockdev_report_vars TEST_RTDEV
> -- 
> 2.34.1
> 

