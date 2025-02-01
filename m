Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3D7B762F7
	for <linux-xfs@vger.kernel.org>; Sat,  1 Feb 2025 07:05:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738393550; cv=none; b=QH0fD7Ryr/RZOqQF5Wb63KsUiDGKj91nIeIsJoCJVDShjTazyhp0k9eQvsP7WGUOZYjB0OBp2MkuICJ8VMH1T+rIrCH4FNIjKjSxnyDPAT2Lx41t9BzCan+Qex3kQrmrHaqUxWIs7s/kT/tHeYluzLnxJzUC8dBR+hknU30tt+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738393550; c=relaxed/simple;
	bh=V8oRhT2/qocvP7c7/6x9lh4o/5vuxcRma/3A7IjW3QQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jsj0yY+lpMKQyw/OCafDn5HGvau6QJBL1yv3j/y7VQyLIJQUpNElChwx4szANFqtidZVd+duvZF1uP06V2//ZgW8dxm5xv4LqepBlRO0mtq3mdD+n/WTULa33JYKYrFMp5+QaP3l8eKPoOo7peweD30z+g8RKe1v1SwypBmoNzc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DSzCLpID; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DSzCLpID"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1738393547;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=LOil50X7To4Izr3XMF3C3ToTpCATFupGxfJXHGENw+4=;
	b=DSzCLpID/YB/YoZFvIX7x6Qqo7rW2oLREGLqa0mnDtZCswu23wPNXlIyw/6rlB/zGQ6rVL
	/qBiudkAQqKfopjeqDua3QadwbnOOw2AMzuDlAuphaNMj7mKr8F2CpSMMTuFoDu9qpHUbZ
	/0v5/er3XkF3WFf4/g6lGqPYXDbY+24=
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com
 [209.85.216.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-433-TIOhKUaCP7isNoipA9rBNg-1; Sat, 01 Feb 2025 02:05:44 -0500
X-MC-Unique: TIOhKUaCP7isNoipA9rBNg-1
X-Mimecast-MFC-AGG-ID: TIOhKUaCP7isNoipA9rBNg
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-2ef9e4c5343so7741796a91.0
        for <linux-xfs@vger.kernel.org>; Fri, 31 Jan 2025 23:05:43 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738393543; x=1738998343;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LOil50X7To4Izr3XMF3C3ToTpCATFupGxfJXHGENw+4=;
        b=sByyiKCBECcKy+lpjsx6WXfq7LgOm+e/7Qg3St0she+lQ+BmVj2y4CFUiRZlQZZ0kh
         2dWqL1DSHH6FUJNmxMGgW/j0hRxWwBITI7ArpL9XufGxzRDrYKzUy1rllkzguNQTdScV
         N+8nu4jikH/s3E5m/5v1CBGZTEW9AU7OkRk7VHcMeVrB7UOcM48Zna3HP/evZLnm6968
         MeN+CkpWjmQm1lcKJko7z6EBihY2DkEiZmBwjBwxcxSTZY0m/yu4+wWJkC+2m3BYO5Ol
         U/A6j4ce12yQYaaZXTPwHvdQmJ9nLFgWlAi1u9WLV3+QiXFfqPY0xhC26ztSW6DFxQx7
         AnWQ==
X-Forwarded-Encrypted: i=1; AJvYcCU0kj7pdriYX/MS94prp8IrRAsFlfMqnOpwXoqrO3liEjs3MPRIho24aQj4PGnxXDa8Q86c8M7AjJY=@vger.kernel.org
X-Gm-Message-State: AOJu0YyzyJ2hh21FzIbvmVQsOb0Iq7GCLRSSJsgfuFUW+SYwQCO2Y1D5
	+kwpWYpdmvDROo64wSwUauH8OHyH6fDuF38N1c7EHlOSbmgV9EDWyUoBHsVIT8xcsn/NTQz/xh3
	67qgspAJymuavgTzF/ih0lnJPZItpLbEJatpYLlwt7pz3Pv5KFuQg+6gHoA==
X-Gm-Gg: ASbGncsMorNsA9rH918GHaYBAE1YW8tOF70HoyYDYFpKhOQkjJLaGDeLsCCXnuPf6SA
	abj9I7YgGRRN3XTfcTDTpq5sRNF/U1RB17PzreW1zVGNd93Y1mv+v0zmKjZrziurbw4338UXCkk
	r/ScCMzjusuBOHyS80nD6apdxorDzQRA8s0Qxof+RJFyCok9ajTiFQ1x3Q16N50Se0CiEuzCW+B
	HpAD/wj95rnTh3HkciqEqd/QLlsjuyG0dZ4h/DXsOhlCYRaeCwUAvW0vfpGJ5zBy4k3QoaOHGOa
	lBtcMCU/Ohnxx1+IRI1Zo0XxVwNizGK6kR6cdPHLP/6kig==
X-Received: by 2002:a05:6a00:278e:b0:71e:6b8:2f4a with SMTP id d2e1a72fcca58-72fd0c1487fmr19169746b3a.12.1738393542911;
        Fri, 31 Jan 2025 23:05:42 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEovbZRZDUPyRjBsMSwhtkSDtYrYfFiTSCzeACcsV4AytoO+dqNEf4OG9wges0H9ELPqkxUqQ==
X-Received: by 2002:a05:6a00:278e:b0:71e:6b8:2f4a with SMTP id d2e1a72fcca58-72fd0c1487fmr19169723b3a.12.1738393542581;
        Fri, 31 Jan 2025 23:05:42 -0800 (PST)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-72fe631be61sm4528747b3a.19.2025.01.31.23.05.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Jan 2025 23:05:42 -0800 (PST)
Date: Sat, 1 Feb 2025 15:05:38 +0800
From: Zorro Lang <zlang@redhat.com>
To: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>
Cc: fstests@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org, ritesh.list@gmail.com,
	ojaswin@linux.ibm.com, djwong@kernel.org, zlang@kernel.org
Subject: Re: [PATCH v2] check: Fix fs specfic imports when
 $FSTYPE!=$OLD_FSTYPE
Message-ID: <20250201070538.u2o2n6znswbvhsdf@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <3b980d028a8ae1496c13ebe3a6685fbc472c5bc0.1738040386.git.nirjhar.roy.lists@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3b980d028a8ae1496c13ebe3a6685fbc472c5bc0.1738040386.git.nirjhar.roy.lists@gmail.com>

On Tue, Jan 28, 2025 at 05:00:22AM +0000, Nirjhar Roy (IBM) wrote:
> Bug Description:
> 
> _test_mount function is failing with the following error:
> ./common/rc: line 4716: _xfs_prepare_for_eio_shutdown: command not found
> check: failed to mount /dev/loop0 on /mnt1/test
> 
> when the second section in local.config file is xfs and the first section
> is non-xfs.
> 
> It can be easily reproduced with the following local.config file
> 
> [s2]
> export FSTYP=ext4
> export TEST_DEV=/dev/loop0
> export TEST_DIR=/mnt1/test
> export SCRATCH_DEV=/dev/loop1
> export SCRATCH_MNT=/mnt1/scratch
> 
> [s1]
> export FSTYP=xfs
> export TEST_DEV=/dev/loop0
> export TEST_DIR=/mnt1/test
> export SCRATCH_DEV=/dev/loop1
> export SCRATCH_MNT=/mnt1/scratch
> 
> ./check selftest/001
> 
> Root cause:
> When _test_mount() is executed for the second section, the FSTYPE has
> already changed but the new fs specific common/$FSTYP has not yet
> been done. Hence _xfs_prepare_for_eio_shutdown() is not found and
> the test run fails.
> 
> Fix:
> Remove the additional _test_mount in check file just before ". commom/rc"
                                                                 common


> since ". commom/rc" is already sourcing fs specific imports and doing a
           common

> _test_mount.

This version looks good to me, I'll merge it with above changes.

Reviewed-by: Zorro Lang <zlang@redhat.com>

I'll push this patch (if it's passed the regression test) to fix current
problem at first.

About the common/rc:init_rc we're talking about, I think we can keep
talking, and change that in another patch if need. Thanks for fixing this.

Thanks,
Zorro

> 
> Fixes: 1a49022fab9b4 ("fstests: always use fail-at-unmount semantics for XFS")
> Signed-off-by: Nirjhar Roy (IBM) <nirjhar.roy.lists@gmail.com>
> ---
>  check | 12 +++---------
>  1 file changed, 3 insertions(+), 9 deletions(-)
> 
> diff --git a/check b/check
> index 607d2456..5cb4e7eb 100755
> --- a/check
> +++ b/check
> @@ -784,15 +784,9 @@ function run_section()
>  			status=1
>  			exit
>  		fi
> -		if ! _test_mount
> -		then
> -			echo "check: failed to mount $TEST_DEV on $TEST_DIR"
> -			status=1
> -			exit
> -		fi
> -		# TEST_DEV has been recreated, previous FSTYP derived from
> -		# TEST_DEV could be changed, source common/rc again with
> -		# correct FSTYP to get FSTYP specific configs, e.g. common/xfs
> +		# Previous FSTYP derived from TEST_DEV could be changed, source
> +		# common/rc again with correct FSTYP to get FSTYP specific configs,
> +		# e.g. common/xfs
>  		. common/rc
>  		_prepare_test_list
>  	elif [ "$OLD_TEST_FS_MOUNT_OPTS" != "$TEST_FS_MOUNT_OPTS" ]; then
> -- 
> 2.34.1
> 

