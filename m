Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8CCAA947
	for <linux-xfs@vger.kernel.org>; Sat,  2 Mar 2024 12:04:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709381096; cv=none; b=VZBMpW9duAg+QuTkAkO1O4yYR74D380XMjvgCPRwbBqd+T3I/M2MmyodcuU+og8nCD34FVy/2aibEA7hdYPh1+67kddA2cVa7o+lmlsLBIR5mTx1V/zRWxLaii74nCAQtBGs2YdGBO60pt1seTnndwvk3CtO4OaEQ5I3iEX62vI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709381096; c=relaxed/simple;
	bh=gPUKPRjyr5YXTXbr77SysTatb9hnunEvFtTgC+c+TOM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Xb6PEhZOIu/twCgmDxfaNnebWqClAG+pVDhrEJt8fP5kizilHD7UHK9h8WOERAaZZ+FJNLw6GJVjvjN3jDPnhVbp98AW+LhuVNzCn9NlHpeyNQxyWwE5NrVvSlGNOqzW/Mn81hM1JgJutvB51H5xKaKInnTO7mfyE4xsmxMosz8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=FQIP/heO; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FQIP/heO"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709381093;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=OeCuK7shauYTVK7z/EIc+QlIF7Xp4Ex/ANVnzxXVIVs=;
	b=FQIP/heOIemrC46nuHJmgDQXPQdAzjEJF1mSzSzRlCtQM92kdBP7KGZwAFgd/8ZEAgisY5
	wjgwVBoH/2HR9UqsU9UH2lYcEgyahO/6FuR/hG0oMl4WhEWX6+Zk7wK8xQ91qYN1TZrADS
	ogF51hxdcmrCXZwMkfbvowO6jznuHR8=
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com
 [209.85.214.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-283-qSEjVfjQPo-42ySQ-F_5sg-1; Sat, 02 Mar 2024 07:04:52 -0500
X-MC-Unique: qSEjVfjQPo-42ySQ-F_5sg-1
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-1dcaff13db5so28786515ad.3
        for <linux-xfs@vger.kernel.org>; Sat, 02 Mar 2024 04:04:52 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709381091; x=1709985891;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OeCuK7shauYTVK7z/EIc+QlIF7Xp4Ex/ANVnzxXVIVs=;
        b=t9Rlwk/GxBOhOeRO/sRSWaKGG/zLWYvBqzCrLWdYUjY0bmyuKK7u56ChwwnixPftmv
         /eKKZhVYWbY/nRhaLCh3T3FkPCDuCMNOwVHCncWaB98+VeaEW23ddTmPQWxIGtJp/04k
         hvZ6bYZy/td2ZR2Jyzk3aLbNJ/WMEa6EiDsWfTRf+9PdNmBHkbeo9v3d1GsmBwZG5KmW
         N8Q0/hRJBzJNOvBZSBUHmN1fu9vFnchjLqtEdSMshhVoUialub46aPHvcnyHzUs1darj
         W7t0hHsqruMIEtMHCjLtn3qWQ/aTSNXjKcetKOnrudBbU/43ClxutcNic6yZx224YOZ1
         ewJw==
X-Gm-Message-State: AOJu0Ywz6g//uwX+Kp2h1hplUy0QlulzIN+wDqQZ/DEvZF2f1muu47IC
	2Kz+lN8jBTsf3y6WkJmJQCiAu/fgOSn/XJh1/BBLUGwX/ZIrGh3XS3woe/ZSI/eOyrKm6m0rZXu
	VcdNtS0CrnWxJpirKfF3UG2svXpY4foZww/4RhwHGsC+p8DqR72gpomDdgvSNU93tTw==
X-Received: by 2002:a17:903:2286:b0:1dc:3ab7:cc80 with SMTP id b6-20020a170903228600b001dc3ab7cc80mr4971549plh.48.1709381090971;
        Sat, 02 Mar 2024 04:04:50 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGAa8iIzAx3bCotIJDvsnfiExtckKCzlDrPCrg1je3s/KpLsrWP37EwY64YH/PMj4xxIJ7xPQ==
X-Received: by 2002:a17:903:2286:b0:1dc:3ab7:cc80 with SMTP id b6-20020a170903228600b001dc3ab7cc80mr4971531plh.48.1709381090567;
        Sat, 02 Mar 2024 04:04:50 -0800 (PST)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id w16-20020a1709026f1000b001dc90b62393sm5175328plk.216.2024.03.02.04.04.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 02 Mar 2024 04:04:50 -0800 (PST)
Date: Sat, 2 Mar 2024 20:04:47 +0800
From: Zorro Lang <zlang@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH v1.1 7/8] xfs/43[4-6]: make module reloading optional
Message-ID: <20240302120447.5tbxra7d5gvvvyzk@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <170899915207.896550.7285890351450610430.stgit@frogsfrogsfrogs>
 <170899915319.896550.14222768162023866668.stgit@frogsfrogsfrogs>
 <20240301175124.GJ1927156@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240301175124.GJ1927156@frogsfrogsfrogs>

On Fri, Mar 01, 2024 at 09:51:24AM -0800, Darrick J. Wong wrote:
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
> v1.1: address some review comments from maintainer

This version looks good to me,
Reviewed-by: Zorro Lang <zlang@redhat.com>

> ---
>  common/module |   33 ++++++++++++++++++++++++++++-----
>  tests/xfs/434 |    3 +--
>  tests/xfs/435 |    3 +--
>  tests/xfs/436 |    3 +--
>  4 files changed, 31 insertions(+), 11 deletions(-)
> 
> diff --git a/common/module b/common/module
> index 6efab71d34..a8d5f492d3 100644
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
> @@ -68,8 +71,28 @@ _require_loadable_fs_module()
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

