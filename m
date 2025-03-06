Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DD9D207A03
	for <linux-xfs@vger.kernel.org>; Thu,  6 Mar 2025 21:14:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741295648; cv=none; b=onh0v37PUfsZzlrFdtk4C+oEF2GwWeyrsuGRN07eNF0N/zJ0znIDSNoYCldVN+1TofNV+WEp1ImItXkzOHnZK1X6bwK1WKqSdpYMvPbbxmfqajPVqNOMHx5EOh33qgrhsmQ21zKNjXqCV+zaUF0zDmIuwjTEABmhHXGoSMrntXc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741295648; c=relaxed/simple;
	bh=7M/TI2OSjR5YHIJN0VEW3G7sZxrEleNeYTf8aGUuXHI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gOYQVz1eEt3DlyDG6iu0gOkIKTyTM3o2M8J9uuHzoOniaxEOeD0GpESItL1l++BE9vngsb0rKhwwq5q1yGTlLZuJ8TAE6136ur33p906DkIP0/5piHE2KXG8EEZMcoyG+zgV8aGLxTHnbFy1aDHYa7MyGb/q1B2IXFiDt5llu74=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=FHLkqpJs; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FHLkqpJs"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1741295645;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=b/+jMnMag8/dlG/SpTCd1rW6bdR/hxWoP7cHVfdj/Rk=;
	b=FHLkqpJslZDLg8TeEEtPIQQMcUgruMralOWviDkZjriJo7GF2gb3HtqWlV/j8VEqLPVLju
	jf3b6uRXUSPJEloJ2Z+l4zaNJERYkOO7+BKuXHZIuyz8khOULA9sFSzdYPBSoDu+RND9Ue
	1EYlc0hfOdcyc/zP5yrzrwFWrTPseyo=
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com
 [209.85.214.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-350-wcfKNDinNSeQIHTl0iaMaw-1; Thu, 06 Mar 2025 16:14:04 -0500
X-MC-Unique: wcfKNDinNSeQIHTl0iaMaw-1
X-Mimecast-MFC-AGG-ID: wcfKNDinNSeQIHTl0iaMaw_1741295643
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-22368a8979cso19394855ad.2
        for <linux-xfs@vger.kernel.org>; Thu, 06 Mar 2025 13:14:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741295643; x=1741900443;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=b/+jMnMag8/dlG/SpTCd1rW6bdR/hxWoP7cHVfdj/Rk=;
        b=IF/qp1Dd4lfkwj+pm/d4Q2hAcqGm3j/zszat6jsAYctnLMAClMzOY13cleGu4BZegC
         6+QPW0B8qfkg9mIq0625Hu/fZToLb40Cl/awko9pztPYs4zddV3ARsbz0nTgIRfOfMCG
         A3n/+5rm1+xtHc8uDgcPhz4dMlgtzfhH8gzD1lcwh/e/NsYbCWwmkyF9GUgYcajtp9ez
         KlaJoqTtImtqitjF5ciqNTWBGy5UhHXYUamvUq74ChpHG42P/BmBFBHmBW1LBcQQ6YeK
         Qkp6LnIRSqHGzuQRCyT+eJqETsVaaYaCKdUFhf96GWSKt8AVcrPFbRntxRUBtOTrrJ08
         nfVA==
X-Forwarded-Encrypted: i=1; AJvYcCXtx17285AwffQDAv8GNCvRCRBmqVHnqXgEdJI3qGnVYsAn+G6RS+tPtLzr0I246r9Q81a/E7MEd6Y=@vger.kernel.org
X-Gm-Message-State: AOJu0YyOmyXBYoatBmyqPWeMSq6KrBoDwlZSrvm0gSizcARs8PuTPOgy
	Nv327RJgiBbjYbPlD+YQgebnlC068JgI6sEsjTLvHwUOAMsTrou/dwTIngtGnT1EEoSXaMUzauZ
	io1jfpi7xYR/Hkor2t/LwpJ/X1qu1UZOJD6DbmF3LPbV2HZTE+BbUAp/hrg==
X-Gm-Gg: ASbGnctQCO8+949tQO3ORQB2LUe9VooypiWKLdtWKJxKETtdH1h11v7hJWYFFmNJmtF
	t9Pv268PpQqmd633hqMt9MyANezP+GaPI/pRLVi8TpB9RNcSeraz3WoKKP/L2wr+CV39por2AJe
	ThEktYkOK0sfU8lXvUpOOGLry7pkdBfgtNWQhopE3nRDHNwyHW4mGJdOD36yNFecfrzfO8P+w5A
	6vhBebo1gI6lG+9At+44N0g07Esey+dnrOH0Si6Spi45daj5GBLr/NjP7F586iEVZ7oUsHLPjT3
	NVSG8JBRTV30lmPCJDhBCfUYtzMjExH1e5+L/LVDaHQuXmeTaaKnkQW7
X-Received: by 2002:a17:903:22c8:b0:224:a74:28d2 with SMTP id d9443c01a7336-22428a890a3mr13014495ad.26.1741295643003;
        Thu, 06 Mar 2025 13:14:03 -0800 (PST)
X-Google-Smtp-Source: AGHT+IE23EgO7EHnOotbD3brWjYmfJC8xgM4/UCHnXOoF54NF4nSSXUIDJ7IZei75So4jsQeKLecCQ==
X-Received: by 2002:a17:903:22c8:b0:224:a74:28d2 with SMTP id d9443c01a7336-22428a890a3mr13014125ad.26.1741295642533;
        Thu, 06 Mar 2025 13:14:02 -0800 (PST)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22410a7f7efsm17034525ad.132.2025.03.06.13.14.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Mar 2025 13:14:02 -0800 (PST)
Date: Fri, 7 Mar 2025 05:13:57 +0800
From: Zorro Lang <zlang@redhat.com>
To: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>
Cc: fstests@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org, ritesh.list@gmail.com,
	ojaswin@linux.ibm.com, djwong@kernel.org, zlang@kernel.org,
	david@fromorbit.com
Subject: Re: [PATCH v1 2/2] check,common/{preamble,rc},soak: Decoupling
 init_rc() call from sourcing common/rc
Message-ID: <20250306211357.fnruffn2nkbiyx5b@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <cover.1741248214.git.nirjhar.roy.lists@gmail.com>
 <1d07e5657c2817c74e939894bb554424199fd290.1741248214.git.nirjhar.roy.lists@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1d07e5657c2817c74e939894bb554424199fd290.1741248214.git.nirjhar.roy.lists@gmail.com>

On Thu, Mar 06, 2025 at 08:17:41AM +0000, Nirjhar Roy (IBM) wrote:
> Silently executing scripts during sourcing common/rc doesn't look good
> and also causes unnecessary script execution. Decouple init_rc() call
> and call init_rc() explicitly where required.
> 
> Signed-off-by: Nirjhar Roy (IBM) <nirjhar.roy.lists@gmail.com>
> ---
>  check           | 10 ++--------
>  common/preamble |  1 +
>  common/rc       |  2 --
>  soak            |  1 +
>  4 files changed, 4 insertions(+), 10 deletions(-)
> 
> diff --git a/check b/check
> index ea92b0d6..d30af1ba 100755
> --- a/check
> +++ b/check
> @@ -840,16 +840,8 @@ function run_section()
>  		_prepare_test_list
>  	elif [ "$OLD_TEST_FS_MOUNT_OPTS" != "$TEST_FS_MOUNT_OPTS" ]; then
>  		_test_unmount 2> /dev/null
> -		if ! _test_mount
> -		then
> -			echo "check: failed to mount $TEST_DEV on $TEST_DIR"
> -			status=1
> -			exit
> -		fi

Why remove these lines?

>  	fi
>  
> -	init_rc

Doesn't the "check" need init_rc at here?

> -
>  	seq="check.$$"
>  	check="$RESULT_BASE/check"
>  
> @@ -870,6 +862,8 @@ function run_section()
>  	needwrap=true
>  
>  	if [ ! -z "$SCRATCH_DEV" ]; then
> +		_check_mounted_on SCRATCH_DEV $SCRATCH_DEV SCRATCH_MNT $SCRATCH_MNT
> +		[ $? -le 1 ] || exit 1
         ^^^^^^^
         Different indent with below code.

This looks like part of init_rc. If you don't remove above init_rc, can this
change be saved? 

>  	  _scratch_unmount 2> /dev/null
>  	  # call the overridden mkfs - make sure the FS is built
>  	  # the same as we'll create it later.
> diff --git a/common/preamble b/common/preamble
> index 0c9ee2e0..c92e55bb 100644
> --- a/common/preamble
> +++ b/common/preamble
> @@ -50,6 +50,7 @@ _begin_fstest()
>  	_register_cleanup _cleanup
>  
>  	. ./common/rc
> +	init_rc
>  
>  	# remove previous $seqres.full before test
>  	rm -f $seqres.full $seqres.hints
> diff --git a/common/rc b/common/rc
> index d2de8588..f153ad81 100644
> --- a/common/rc
> +++ b/common/rc
> @@ -5754,8 +5754,6 @@ _require_program() {
>  	_have_program "$1" || _notrun "$tag required"
>  }
>  
> -init_rc
> -
>  ################################################################################
>  # make sure this script returns success
>  /bin/true
> diff --git a/soak b/soak
> index d5c4229a..5734d854 100755
> --- a/soak
> +++ b/soak
> @@ -5,6 +5,7 @@
>  
>  # get standard environment, filters and checks
>  . ./common/rc
> +# ToDo: Do we need an init_rc() here? How is soak used?

I never noticed we have this file... this file was create by:

  commit 27fba05e66981c239c3be7a7e5a3aa0d8dc59247
  Author: Nathan Scott <nathans@sgi.com>
  Date:   Mon Jan 15 05:01:19 2001 +0000

      cmd/xfs/stress/001 1.6 Renamed to cmd/xfstests/001

I can't understand the relationship of this commit with this file. Does
anyone learn about the history of it.

I tried to "grep" the whole fstests, looks like nothing uses this file.
Maybe we should remove it?

Thanks,
Zorro

>  . ./common/filter
>  
>  tmp=/tmp/$$
> -- 
> 2.34.1
> 
> 

