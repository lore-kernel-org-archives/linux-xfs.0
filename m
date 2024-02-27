Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 120BB1DA21
	for <linux-xfs@vger.kernel.org>; Tue, 27 Feb 2024 05:31:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709011905; cv=none; b=XqYK/a5ALjHscGoQ851mrbXqt/1RN/PskaNcqPQF86p++4qSh4l8ixPYHr1kgoeJ3s+EBge3to2ubmAw28mc4o7mkCoiMrnStmZk6WjCAHwumc8cCF1yQ9PGeZYCMBbTB3S2DVPnWv5DlXeE/E5CPPQUe1hacuQNxrfb7JL+J0A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709011905; c=relaxed/simple;
	bh=ocw5XcIWZQgQ1y1hNyqTVBXOjBjFZuD+T6I3/da+R5s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=E/J2w2EztmTnEXAzWtyVEePNmIlhwe2PYU64RkQ3EQMYV7fvz/wfbTtobvvDCRMkN4U2c8Mq9hKgdHNNAuTe3il/aULI/WZzOXmzy7k1Rlt4XQD09RvTigu4NBgutA83BokgBmW2O+n6glKagAs3xNGHkugWKNcUc4NC/9epwxw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=h3XK5jFk; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="h3XK5jFk"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709011902;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=tQUtK6n1GJcIihAKCH5DiOFWaCsLOMH/Ad/lhD9WCAE=;
	b=h3XK5jFkookzNHEa0/Z8UGoqVDQ2Vt4eGXIjUew5L/BzSxFQvACaWerpdxHOKmjBncYnE/
	NjnXPMzGk8yro+jc14y2gkn82cwhTXe7+5TCAprn/zoNW5sWjHLGAn2k3DpB9qpK7ehcoC
	smR0mL6Xeq7IqsCNye6Mx2Sq6qBAqGA=
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com
 [209.85.214.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-569-zXW9qRl1NmObXr0gbrNZnQ-1; Tue, 27 Feb 2024 00:31:41 -0500
X-MC-Unique: zXW9qRl1NmObXr0gbrNZnQ-1
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-1dc6b99b045so22067395ad.0
        for <linux-xfs@vger.kernel.org>; Mon, 26 Feb 2024 21:31:41 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709011900; x=1709616700;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tQUtK6n1GJcIihAKCH5DiOFWaCsLOMH/Ad/lhD9WCAE=;
        b=nLaBxxoZA6F51FzzkSbhlBlD+Y0mbqE2G6v531wPRquzEk4MGe0YNAkMoyPwGRQA25
         hWM+ZNg/ci9Buvppjo8rcD+3B6oLiwZVvDZVoUIVXeXGVAbyUaOdk5NKPdAAEbJ7dnj2
         kLXTXm8M5MlTe2fqgRQmpyRoYwKaCYOlXYqdyf+SdFpvkedmfUUcEiHN7GuscLkKp1rm
         eWdLx4FC0VzfJuqhULK7JkAVQ2ly3Ie2JX/J/gAtwa0wWDkdGCog2pyVcRCi4o85wXOu
         6cFFhiw9iTN8HKmLuwt8Qt+ndObLG7mi+SPqeZ5TnBJi++ZAQcNa9Ts4HTXvIZEdiE+I
         4SdA==
X-Gm-Message-State: AOJu0YyrYh7ewGCgeR+AkBtab/18myvJnGPyZdRUXN9i2TCI+Ns7kf4W
	OwiCQsUZnHV6FwCLSNxwfzF3oUU3jbTRlR+EubY6ORmU+7JW4gGMT4C2zvzahsYfaOiKLz9znJz
	IiqOu3aSDkCGtblA8HerlyDy9wcdQ1tc87F/RXdcbIS884x2/ol1AdfEnnoVlQ9UXMQCa
X-Received: by 2002:a17:903:2306:b0:1d9:e1aa:f217 with SMTP id d6-20020a170903230600b001d9e1aaf217mr12386055plh.22.1709011899944;
        Mon, 26 Feb 2024 21:31:39 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHo/vef3aoVXNFHEOfKG7LNo7c6Zcpyv1MQWxBKBr/6toWUwDL6pc0pjjmcmSHuxYBdO+/Xkw==
X-Received: by 2002:a17:903:2306:b0:1d9:e1aa:f217 with SMTP id d6-20020a170903230600b001d9e1aaf217mr12386038plh.22.1709011899551;
        Mon, 26 Feb 2024 21:31:39 -0800 (PST)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id v11-20020a170902d68b00b001dca9b21267sm590386ply.186.2024.02.26.21.31.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Feb 2024 21:31:39 -0800 (PST)
Date: Tue, 27 Feb 2024 13:31:36 +0800
From: Zorro Lang <zlang@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 7/8] xfs/43[4-6]: make module reloading optional
Message-ID: <20240227053136.47rc2ftu3eysmu4u@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <170899915207.896550.7285890351450610430.stgit@frogsfrogsfrogs>
 <170899915319.896550.14222768162023866668.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170899915319.896550.14222768162023866668.stgit@frogsfrogsfrogs>

On Mon, Feb 26, 2024 at 06:02:21PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> These three tests examine two things -- first, can xfs CoW staging
> extent recovery handle corruptions in the refcount btree gracefully; and
> second, can we avoid leaking incore inodes and dquots.
> 
> The only cheap way to check the second condition is to rmmod and
> modprobe the XFS module, which triggers leak detection when rmmod tears
> down the caches.  Currently, the entire test is _notrun if module
> reloading doesn't work.
> 
> Unfortunately, these tests never run for the majority of XFS developers
> because their testbeds either compile the xfs kernel driver into vmlinux
> statically or the rootfs is xfs so the module cannot be reloaded.  The
> author's testbed boots from NFS and does not have this limitation.
> 
> Because we've had repeated instances of CoW recovery regressions not
> being caught by testing until for-next hits my machine, let's make the
> module reloading optional in all three tests to improve coverage.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  common/module |   34 +++++++++++++++++++++++++++++-----
>  tests/xfs/434 |    3 +--
>  tests/xfs/435 |    3 +--
>  tests/xfs/436 |    3 +--
>  4 files changed, 32 insertions(+), 11 deletions(-)
> 
> 
> diff --git a/common/module b/common/module
> index 6efab71d34..f6814be34e 100644
> --- a/common/module
> +++ b/common/module
> @@ -48,12 +48,15 @@ _require_loadable_module()
>  	modprobe "${module}" || _notrun "${module} load failed"
>  }
>  
> -# Check that the module for FSTYP can be loaded.
> -_require_loadable_fs_module()
> +# Test if the module for FSTYP can be unloaded and reloaded.
> +#
> +# If not, returns 1 if $FSTYP is not a loadable module; 2 if the module could
> +# not be unloaded; or 3 if loading the module fails.
> +_test_loadable_fs_module()
>  {
>  	local module="$1"
>  
> -	modinfo "${module}" > /dev/null 2>&1 || _notrun "${module}: must be a module."
> +	modinfo "${module}" > /dev/null 2>&1 || return 1
>  
>  	# Unload test fs, try to reload module, remount
>  	local had_testfs=""
> @@ -68,8 +71,29 @@ _require_loadable_fs_module()
>  	modprobe "${module}" || load_ok=0
>  	test -n "${had_scratchfs}" && _scratch_mount 2> /dev/null
>  	test -n "${had_testfs}" && _test_mount 2> /dev/null
> -	test -z "${unload_ok}" || _notrun "Require module ${module} to be unloadable"
> -	test -z "${load_ok}" || _notrun "${module} load failed"
> +	test -z "${unload_ok}" || return 2
> +	test -z "${load_ok}" || return 3
> +	return 0
> +}
> +
> +_require_loadable_fs_module()
> +{
> +	local module="$1"
> +
> +	_test_loadable_fs_module "${module}"
> +	ret=$?
> +	case "$ret" in
> +	1)
> +		_notrun "${module}: must be a module."
> +		;;
> +	2)
> +		_notrun "${module}: module could not be unloaded"
> +		;;
> +	3)
> +		_notrun "${module}: module reload failed"
> +		;;
> +	esac
> +	return "${ret}"

I think nobody checks the return value of a _require_xxx helper. The
_require helper generally notrun or keep running. So if ret=0, then
return directly, other return values trigger different _notrun.

>  }
>  
>  # Print the value of a filesystem module parameter
> diff --git a/tests/xfs/434 b/tests/xfs/434
> index 12d1a0c9da..ca80e12753 100755
> --- a/tests/xfs/434
> +++ b/tests/xfs/434
> @@ -30,7 +30,6 @@ _begin_fstest auto quick clone fsr
>  
>  # real QA test starts here
>  _supported_fs xfs
> -_require_loadable_fs_module "xfs"
>  _require_quota
>  _require_scratch_reflink
>  _require_cp_reflink
> @@ -77,7 +76,7 @@ _scratch_unmount 2> /dev/null
>  rm -f ${RESULT_DIR}/require_scratch
>  
>  echo "See if we leak"
> -_reload_fs_module "xfs"
> +_test_loadable_fs_module "xfs"
>  
>  # success, all done
>  status=0
> diff --git a/tests/xfs/435 b/tests/xfs/435
> index 44135c7653..b52e9287df 100755
> --- a/tests/xfs/435
> +++ b/tests/xfs/435
> @@ -24,7 +24,6 @@ _begin_fstest auto quick clone
>  
>  # real QA test starts here
>  _supported_fs xfs
> -_require_loadable_fs_module "xfs"
>  _require_quota
>  _require_scratch_reflink
>  _require_cp_reflink
> @@ -55,7 +54,7 @@ _scratch_unmount 2> /dev/null
>  rm -f ${RESULT_DIR}/require_scratch
>  
>  echo "See if we leak"
> -_reload_fs_module "xfs"
> +_test_loadable_fs_module "xfs"

So we don't care about if the fs module reload success or not, just
try it then keep running?

Thanks,
Zorro

>  
>  # success, all done
>  status=0
> diff --git a/tests/xfs/436 b/tests/xfs/436
> index d010362785..02bcd66900 100755
> --- a/tests/xfs/436
> +++ b/tests/xfs/436
> @@ -27,7 +27,6 @@ _begin_fstest auto quick clone fsr
>  
>  # real QA test starts here
>  _supported_fs xfs
> -_require_loadable_fs_module "xfs"
>  _require_scratch_reflink
>  _require_cp_reflink
>  _require_xfs_io_command falloc # fsr requires support for preallocation
> @@ -72,7 +71,7 @@ _scratch_unmount 2> /dev/null
>  rm -f ${RESULT_DIR}/require_scratch
>  
>  echo "See if we leak"
> -_reload_fs_module "xfs"
> +_test_loadable_fs_module "xfs"
>  
>  # success, all done
>  status=0
> 
> 

