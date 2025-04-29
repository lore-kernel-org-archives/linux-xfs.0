Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78FE7246787
	for <linux-xfs@vger.kernel.org>; Tue, 29 Apr 2025 23:59:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745971183; cv=none; b=Y9zDFC4l47fJfb4bb4V814nH4JGdGf+S4NHpugej0tSutBGuLyIj9xTWVfxvkZHirXjjE9z86GXRbzhScRkj9Mv69HNwXVP+URscfW35Andq4p2iJUK4JPRqHM816jmhvitVphn9jyxrh8gKkJzYiJA2/ofeWMZ5bY7WPEEULDo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745971183; c=relaxed/simple;
	bh=zYPtI3bHKiFeKZGAqAvYP78ecZbSnxjIXDnbtWFJEDg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eMr58byZlXppGt/svOLiLSZRvxT/mghAwpxZpFuXGtcOU4k0HLAF1Ao3RvcZzAGzdZM5Eo8+JgDsrbdQel+aziZVsCdYdpDxw+Iew7wVJyYZ9RW4NZ9zjqDd+KzCQm+aYobDBUaCR2BC6sNDlBm6rZrDW3RbnYYv0jgt936PVNc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=QK6NHCjD; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="QK6NHCjD"
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-227c7e57da2so56903935ad.0
        for <linux-xfs@vger.kernel.org>; Tue, 29 Apr 2025 16:59:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1745971181; x=1746575981; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=YVw92qdDBpSeLoYhqTmkn3e/ekyDNEnwi+AVc5uI+WE=;
        b=QK6NHCjDhStnGLgzRBbAyQTE8qrCPrUFIQK7pniEq+JR9DwHxRrPrffCGJBUtMt6DZ
         9/sECpe6dQqK5X29j69YcAXT3KI7FaTmsNPzfxDE69FHZq8+YapYtsLHSD0e0CTezjSF
         HYWHexF1BMulVF8YbVbIao9XnR/IxcMZoOVW3nEBjyfJS3zTClj8QjZezY8SbHIZE+Y0
         /Ts5V3KbVLcMrFZ04reW+3WUUwi442J326XnfP7VL8AluQ/oKpKiJorKdk4x/LGNgvQp
         nl1n2j16tpy4FJ43rWI41IH8bH8NC1fCXfg4vk5u4nFmemz9CH+sPZp0/Xq36iCq7JMY
         MvnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745971181; x=1746575981;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YVw92qdDBpSeLoYhqTmkn3e/ekyDNEnwi+AVc5uI+WE=;
        b=XSi8zOqiSFNDBOwVXmodpiZ1uoxH6nu8FiTfUOcZly7ducj6zBQu583/s0x/l5lYMB
         Mg/mplpV/06t9Guyge6EXJ1HCTGRFYLj/CVmtE4Cmv7gTqtzZCsahx5e2/65NTzplc3w
         p/48VnfkXBNL/aml8UdT/qsZ12WF9OmEHGCXnh23e5QH5aCStLtZMehPTSG3D1GcTO+p
         AUycEAGUSXJ/Sok5rXVuHM7LSRNiYV0DrgHvzNYSKZSkF9OR/xzo4e1/z8/a1N21T+8e
         OjxYZ3YBFIdtZlbmMyw765CTmle8mcgbVCZsY5XgNlZxWXgWWZMAbl7q8tozwMk9WK+P
         egXA==
X-Forwarded-Encrypted: i=1; AJvYcCVAhCAOzntfVbSlqsepA8AJ01sWwE1Y4z5yNYBlBV6ZsPgF/QRHyxz77b6Y5NVqtzLSdu4ALjc+sko=@vger.kernel.org
X-Gm-Message-State: AOJu0YzrSyPmPQ10OX7aoT6aojVCMfiljpwGB51TSRV9IeLigBI1Zb+6
	bwENjE/iEPNYeYFRuR7XOQyDtv5lkhE35KLPebEjq1NXf7VvHXSmmDYCr1R/ltk=
X-Gm-Gg: ASbGnctNJ6vdxv+2nbl8QNH4VF+/4VpNCbNmzyHoIGAQMEwKwUIAivf78X3ogP+Hqri
	+oD+QJHDGjVC2lPiv3SbrufjBOiLT2QQIri26UVsavfRaNrSkFfsIP5yqgEpoT3lGlglt9eSjZU
	IrBnHxTzi+zhxRpapg61tFpcANLTAaFoJ0jip1l/60qRrFNGgKG6H1nWsuLkF5GqpCP6WTElWCs
	wPrny9U3XMWfyvv3sq4obYxk/4QQvM8ogGgV98J9SeK9tWWhBI70b6n47GfzfK1xWm62xt7LKaB
	mdKaTrzrN68FeTnAg/0XMqHZ3++15ZRXfRXFoDHYZefnMwdfQz3OPLx5iPgKOWXzoeuQbg4TFRA
	dZNfeYe4rmEvDDw==
X-Google-Smtp-Source: AGHT+IHsH/8X6UP9tikizlY4psmrzOQStlrdrC7h0vwhF7x6aWzUfoYr97UdhdbC1d7CvYyLD0W2VQ==
X-Received: by 2002:a17:902:ccc3:b0:215:9bc2:42ec with SMTP id d9443c01a7336-22df5838ce0mr5785565ad.47.1745971180608;
        Tue, 29 Apr 2025 16:59:40 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-60-96.pa.nsw.optusnet.com.au. [49.181.60.96])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22db4dbbf8dsm109681655ad.65.2025.04.29.16.59.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Apr 2025 16:59:40 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.98.2)
	(envelope-from <david@fromorbit.com>)
	id 1u9urR-0000000F0ny-2iHa;
	Wed, 30 Apr 2025 09:59:37 +1000
Date: Wed, 30 Apr 2025 09:59:37 +1000
From: Dave Chinner <david@fromorbit.com>
To: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>
Cc: fstests@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org, ritesh.list@gmail.com,
	ojaswin@linux.ibm.com, djwong@kernel.org, zlang@kernel.org
Subject: Re: [PATCH v2 2/2] check: Replace exit with _exit in check
Message-ID: <aBFn6YL3vHpb09yB@dread.disaster.area>
References: <cover.1745908976.git.nirjhar.roy.lists@gmail.com>
 <de352e171003ab91fab2328652f8b1990a2d8cce.1745908976.git.nirjhar.roy.lists@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <de352e171003ab91fab2328652f8b1990a2d8cce.1745908976.git.nirjhar.roy.lists@gmail.com>

On Tue, Apr 29, 2025 at 06:52:54AM +0000, Nirjhar Roy (IBM) wrote:
> Some of the "status=<val>;exit" and "exit <val>" were not
> replace with _exit <val>. Doing it now.
> 
> Signed-off-by: Nirjhar Roy (IBM) <nirjhar.roy.lists@gmail.com>
> ---
>  check | 44 ++++++++++++++++++--------------------------
>  1 file changed, 18 insertions(+), 26 deletions(-)
> 
> diff --git a/check b/check
> index 9451c350..99d38492 100755
> --- a/check
> +++ b/check
> @@ -47,6 +47,7 @@ export DIFF_LENGTH=${DIFF_LENGTH:=10}
>  # by default don't output timestamps
>  timestamp=${TIMESTAMP:=false}
>  
> +. common/exit
>  rm -f $tmp.list $tmp.tmp $tmp.grep $here/$iam.out $tmp.report.* $tmp.arglist
>  
>  SRC_GROUPS="generic"
> @@ -121,7 +122,7 @@ examples:
>   check -X .exclude -g auto
>   check -E ~/.xfstests.exclude
>  '
> -	    exit 1
> +	    _exit 1
>  }
>  
>  get_sub_group_list()
> @@ -231,7 +232,7 @@ _prepare_test_list()
>  			list=$(get_group_list $group)
>  			if [ -z "$list" ]; then
>  				echo "Group \"$group\" is empty or not defined?"
> -				exit 1
> +				_exit 1
>  			fi
>  
>  			for t in $list; do

This is now:

	_fatal "Group \"$group\" is empty or not defined?"

> @@ -316,14 +317,14 @@ while [ $# -gt 0 ]; do
>  	-r)
>  		if $exact_order; then
>  			echo "Cannot specify -r and --exact-order."
> -			exit 1
> +			_exit 1
>  		fi
>  		randomize=true
>  		;;
>  	--exact-order)
>  		if $randomize; then
>  			echo "Cannnot specify --exact-order and -r."
> -			exit 1
> +			_exit 1
>  		fi
>  		exact_order=true
>  		;;

Same.

> @@ -361,7 +362,7 @@ done
>  # after processing args, overlay needs FSTYP set before sourcing common/config
>  if ! . ./common/rc; then
>  	echo "check: failed to source common/rc"
> -	exit 1
> +	_exit 1
>  fi
>  
>  init_rc

Same.

> @@ -373,8 +374,7 @@ if [ -n "$SOAK_DURATION" ]; then
>  		sed -e 's/^\([.0-9]*\)\([a-z]\)*/\1 \2/g' | \
>  		$AWK_PROG -f $here/src/soak_duration.awk)"
>  	if [ $? -ne 0 ]; then
> -		status=1
> -		exit 1
> +		_exit 1
>  	fi
>  fi
>  
> @@ -385,8 +385,7 @@ if [ -n "$FUZZ_REWRITE_DURATION" ]; then
>  		sed -e 's/^\([.0-9]*\)\([a-z]\)*/\1 \2/g' | \
>  		$AWK_PROG -f $here/src/soak_duration.awk)"
>  	if [ $? -ne 0 ]; then
> -		status=1
> -		exit 1
> +		_exit 1
>  	fi
>  fi
>  
> @@ -404,8 +403,7 @@ if $have_test_arg; then
>  	while [ $# -gt 0 ]; do
>  		case "$1" in
>  		-*)	echo "Arguments before tests, please!"
> -			status=1
> -			exit $status
> +			_exit 1

_fatal

>  			;;
>  		*)	# Expand test pattern (e.g. xfs/???, *fs/001)
>  			list=$(cd $SRC_DIR; echo $1)
> @@ -438,7 +436,7 @@ fi
>  if [ `id -u` -ne 0 ]
>  then
>      echo "check: QA must be run as root"
> -    exit 1
> +    _exit 1
>  fi

Same

>  
>  _wipe_counters()
> @@ -721,9 +719,9 @@ _prepare_test_list
>  fstests_start_time="$(date +"%F %T")"
>  
>  if $OPTIONS_HAVE_SECTIONS; then
> -	trap "_summary; exit \$status" 0 1 2 3 15
> +	trap "_summary; _exit" 0 1 2 3 15
>  else
> -	trap "_wrapup; exit \$status" 0 1 2 3 15
> +	trap "_wrapup; _exit" 0 1 2 3 15
>  fi

Please add a comment explaining that _exit will capture $status
that has been previously set as the exit value.

Realistically, though, I think 'exit $status' is much better here
because it clearly documents that we are capturing $status as the
exit value from the trap rather than having to add a comment to make
it clear that $status is the exit value of the trap...

>  function run_section()
> @@ -767,8 +765,7 @@ function run_section()
>  	mkdir -p $RESULT_BASE
>  	if [ ! -d $RESULT_BASE ]; then
>  		echo "failed to create results directory $RESULT_BASE"
> -		status=1
> -		exit
> +		_exit 1
>  	fi

_fatal

>  	if $OPTIONS_HAVE_SECTIONS; then
> @@ -784,8 +781,7 @@ function run_section()
>  			echo "our local _test_mkfs routine ..."
>  			cat $tmp.err
>  			echo "check: failed to mkfs \$TEST_DEV using specified options"
> -			status=1
> -			exit
> +			_exit 1
>  		fi
>  		# Previous FSTYP derived from TEST_DEV could be changed, source
>  		# common/rc again with correct FSTYP to get FSTYP specific configs,
> @@ -829,8 +825,7 @@ function run_section()
>  	      echo "our local _scratch_mkfs routine ..."
>  	      cat $tmp.err
>  	      echo "check: failed to mkfs \$SCRATCH_DEV using specified options"
> -	      status=1
> -	      exit
> +	      _exit 1
>  	  fi
>  
>  	  # call the overridden mount - make sure the FS mounts with
> @@ -840,8 +835,7 @@ function run_section()
>  	      echo "our local mount routine ..."
>  	      cat $tmp.err
>  	      echo "check: failed to mount \$SCRATCH_DEV using specified options"
> -	      status=1
> -	      exit
> +	      _exit 1
>  	  else
>  	      _scratch_unmount
>  	  fi

Same for all these.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
