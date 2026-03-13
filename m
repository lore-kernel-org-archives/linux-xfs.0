Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29DDE3D5678
	for <linux-xfs@vger.kernel.org>; Fri, 13 Mar 2026 17:55:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773424539; cv=none; b=uLBp3zC/hEcNZaAz8Xvsx+AretMwH/e+szCH41N6+d7mU5emVbOGPzdXE+2XRFCbvMiL1rX9Fyb7IR9dgxWwbjb5WmSHSXczhg0dfG1LaAMvKyqVJ1MBCCBfGKgb4SgPyg+no+XHLbCNsysLByjp/DKro7LPalrShjEtme8oJGk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773424539; c=relaxed/simple;
	bh=zFTpUqNxfwHZYoFVLLsWS3yA02zzXxNAGAap+93fzLc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=L7BJSGvjW3BG8tLYb94hcCAFlrRV3/veVE1ncdRKZPP/mR+OE9eDU7DbPrDJpG+CMEvJhkeKWprB/W69NOi6hHwTkFvJc9FU3TXacyWI4ue6C2rssp8bsjVRfuhIr7ZU3r7mMeTvL9Z2yoAyp/Njh4GRMS2ws/NaWgLl6NTZy+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=JmzHD0zh; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=iVLHV5K4; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JmzHD0zh";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="iVLHV5K4"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1773424537;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lLH+zzk82XmVGuSsd5GeuCRRscX7AappD0ztCcZg5hQ=;
	b=JmzHD0zhb1VPk15LAV26Nol5HTuSBdrMyrhbCF7sdFxkLZZhNSNfWtAP/oYM/ricP59Wu1
	rJJ8QUv7/2lnAAw+4bgbGUrkis8fesqTTEvhfIHriOfn629cDf2axe+GtLlLx6H5/vd2mh
	92nia8jN3ADspkpbrqZJ4++Y9Fy5N+A=
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com
 [209.85.216.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-54-Q4ZOeVfZOK-qcSEDM2imXQ-1; Fri, 13 Mar 2026 13:55:35 -0400
X-MC-Unique: Q4ZOeVfZOK-qcSEDM2imXQ-1
X-Mimecast-MFC-AGG-ID: Q4ZOeVfZOK-qcSEDM2imXQ_1773424535
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-35a21d5246fso1275204a91.2
        for <linux-xfs@vger.kernel.org>; Fri, 13 Mar 2026 10:55:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1773424534; x=1774029334; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=lLH+zzk82XmVGuSsd5GeuCRRscX7AappD0ztCcZg5hQ=;
        b=iVLHV5K4N7lIwjyHGaaYHvc9yhWJV33CPazXGtajm+aJnF4i31OpbOP8xZVcf2weKt
         kiXWnmwMNUB/ly1K9ZizX6BqNhYB71xZ/eufbV+GJPHvFD5gPIZqw9guoNXns5MFwoJk
         BwxE+3B+Tq9JIFUHMlR+U6k9phhQpiff/USKyFMV0Xbw+lxaIJrUuOg+r1O/lHlmH6Kj
         vn3nr5ynyEzl+ukwKFVa11Zqr5XRlg8h7U5sTRAlX/jOOYucymvM/dZI7H1mH1r3+zmz
         /uoLog4qtRKsrlEGyEnXUoSXktBkg/RTXuo2XTh7lQtP4ixjctEsanWetfK6rxdB0j3M
         3D6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773424534; x=1774029334;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lLH+zzk82XmVGuSsd5GeuCRRscX7AappD0ztCcZg5hQ=;
        b=AmakV99DuU8EE9sHY4XYCxp/FZfpr96e0VwGuQVGB3SX1YwHUdzmRmdprioBRoROCZ
         5idi+0v8XcHzGQqhi9JyvtMsgb1V4nV4sYQlM2Yy6lGkSPDd52XVePIFhiSCXxJ8J5dq
         qt34I+U1td2pybMjQetslQr5wcIVm3wKhu68w7Oe+rJcg/5o3n5ZzJJUeoQdx7aNHVPR
         ftA0VbwmEo6Dlyl8w1AmftBUZ9FN2hyF/v37uckV6E62y9gFHscQ/lLrZRHas1xi5AUE
         bL/OMQd3fPsgMSQm0JFMHsE8Ku1TlFQkYu0WQ/lGO2T7HVrRtOtxsOirmQnrxqBqt0ll
         l5dA==
X-Forwarded-Encrypted: i=1; AJvYcCVcuU5NC2OEAwflyBmKjxyvUnXI1d5XmhdlrnhyzyMMHnYpvEJjHNJcFUFgyYhRl3tl+8ApIbgKYe0=@vger.kernel.org
X-Gm-Message-State: AOJu0YxrxZUcSH4yz4en2lavx/+CwjLB5FQXhQqOsqchHXdqQ1feROGh
	EQSCVzJfSQrqzmtB8DBOvIu8Hj/tzhpY8P9MfO34eKByqZus5/IZ22rNZgzVQEW4YkOb1YEo/lC
	BZLp4R8CwFRLeJUvOFg8T6rHLv4qGSp+HqnPudoqKr76dB6owk8sz0c69RJ7lHJB11B/9PQ==
X-Gm-Gg: ATEYQzynbxyCFGwB0Yd85oNHN/46g4bEodyZ2wFGZncys+bqo4cfpB2jr4DDxtOrxwb
	swcZtdfmsvkArlL4BQTcfirJOuUbcr9SOCk4u9AvJTGstf1OsTa41uXfvHeiGdK8j1RL/l+r0/b
	uovyF3j/3xKxu96xukac6Ovjw509enb7Ekaa+jVU+gNqCVywjwWNzdNClxO679diuOC98hDw3GN
	rkmSjMhXeinu4DAwJPIFA76ogG20DbUZCEnwe/6ES00xk5BOzQcmcZPVt1IgEgDOgxj7vgcu09k
	xVDGt2k+Jn8oIXtf4A5yG7lEWqTJRn2olV2szpq4+IsYFjyjG93FA8pd/tX3/2++tXU1NvycIig
	fYR30pvROGloNHzOz2KKvDQEEXnd5eW5Y3mxen11F0zqpva8uquBQHYi2cELUDA==
X-Received: by 2002:a17:90b:3d4b:b0:359:fdc0:4621 with SMTP id 98e67ed59e1d1-35a21f666cbmr3506535a91.11.1773424534293;
        Fri, 13 Mar 2026 10:55:34 -0700 (PDT)
X-Received: by 2002:a17:90b:3d4b:b0:359:fdc0:4621 with SMTP id 98e67ed59e1d1-35a21f666cbmr3506522a91.11.1773424533785;
        Fri, 13 Mar 2026 10:55:33 -0700 (PDT)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([209.132.188.88])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c73ebb6335fsm2485840a12.19.2026.03.13.10.55.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Mar 2026 10:55:33 -0700 (PDT)
Date: Sat, 14 Mar 2026 01:55:29 +0800
From: Zorro Lang <zlang@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs/62[3-8]: require XFS_SCRUB_PROG
Message-ID: <20260313175529.kdwqkjtpn2fwigrz@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <20260311041443.GC6023@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260311041443.GC6023@frogsfrogsfrogs>

On Tue, Mar 10, 2026 at 09:14:43PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> QA reports that xfs/62[3-8] fail because they didn't install
> xfsprogs-xfs_scrub package and this test requires xfs_scrub(8).
> Add the missing _require call, and update the README so that anyone
> running fstests on RHEL/Fedora actually get all the necessary
> components to do a full test of XFS.
> 
> Cc: <fstests@vger.kernel.org> # v2024.06.27
> Fixes: 4de8fd7860a2bb ("scrub: test correction of directory tree corruptions")
> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
> ---
>  README        |    2 +-
>  tests/xfs/623 |    3 +--
>  tests/xfs/624 |    3 +--
>  tests/xfs/625 |    3 +--
>  tests/xfs/626 |    3 +--
>  tests/xfs/627 |    3 +--
>  tests/xfs/628 |    1 +
>  7 files changed, 7 insertions(+), 11 deletions(-)
> 
> diff --git a/README b/README
> index 211e273115f08f..36684cc6572d4b 100644
> --- a/README
> +++ b/README
> @@ -126,7 +126,7 @@ Fedora
>     $ sudo yum install acl attr automake bc dbench dump e2fsprogs fio gawk gcc \
>          gdbm-devel git indent kernel-devel libacl-devel libaio-devel \
>          libcap-devel libtool liburing-devel libuuid-devel lvm2 make psmisc \
> -        python3 quota sed sqlite udftools  xfsprogs
> +        python3 quota sed sqlite udftools xfsprogs xfsprogs-xfs_scrub

Sure,

Reviewed-by: Zorro Lang <zlang@redhat.com>

I’m thinking we could split this package list into "necessary" dependencies and "optional"
ones. The "necessary" dependencies would include all packages required for building and
basic execution of xfstests, while missing "optional" dependencies would simply result in
certain cases being notrun. Any thoughts on this :)

Thanks,
Zorro

>  
>  2. Install packages for the filesystem(s) being tested:
>  
> diff --git a/tests/xfs/623 b/tests/xfs/623
> index aff3f903660fa7..7f79ccbcbf7f14 100755
> --- a/tests/xfs/623
> +++ b/tests/xfs/623
> @@ -16,8 +16,7 @@ _begin_fstest auto online_repair
>  . ./common/fuzzy
>  . ./common/populate
>  
> -
> -# Modify as appropriate.
> +_require_scrub
>  _require_xfs_db_command "link"
>  _require_xfs_db_command "unlink"
>  _require_scratch
> diff --git a/tests/xfs/624 b/tests/xfs/624
> index e63cfcc6e7ba82..09a922c8d18c8a 100755
> --- a/tests/xfs/624
> +++ b/tests/xfs/624
> @@ -16,8 +16,7 @@ _begin_fstest auto online_repair
>  . ./common/fuzzy
>  . ./common/populate
>  
> -
> -# Modify as appropriate.
> +_require_scrub
>  _require_xfs_db_command "link"
>  _require_xfs_db_command "unlink"
>  _require_scratch
> diff --git a/tests/xfs/625 b/tests/xfs/625
> index 23013f195c9e7f..2654216b67aa11 100755
> --- a/tests/xfs/625
> +++ b/tests/xfs/625
> @@ -16,8 +16,7 @@ _begin_fstest auto online_repair
>  . ./common/fuzzy
>  . ./common/populate
>  
> -
> -# Modify as appropriate.
> +_require_scrub
>  _require_xfs_db_command "link"
>  _require_xfs_db_command "unlink"
>  _require_scratch
> diff --git a/tests/xfs/626 b/tests/xfs/626
> index c424819cede6e1..3b4cdca4fe4e24 100755
> --- a/tests/xfs/626
> +++ b/tests/xfs/626
> @@ -16,8 +16,7 @@ _begin_fstest auto online_repair
>  . ./common/fuzzy
>  . ./common/populate
>  
> -
> -# Modify as appropriate.
> +_require_scrub
>  _require_xfs_db_command "link"
>  _require_xfs_db_command "unlink"
>  _require_scratch
> diff --git a/tests/xfs/627 b/tests/xfs/627
> index 411a7603317058..fc54199b4a95de 100755
> --- a/tests/xfs/627
> +++ b/tests/xfs/627
> @@ -16,8 +16,7 @@ _begin_fstest auto online_repair
>  . ./common/fuzzy
>  . ./common/populate
>  
> -
> -# Modify as appropriate.
> +_require_scrub
>  _require_xfs_db_command "link"
>  _require_xfs_db_command "unlink"
>  _require_scratch
> diff --git a/tests/xfs/628 b/tests/xfs/628
> index c77d67db358983..e003f41999f401 100755
> --- a/tests/xfs/628
> +++ b/tests/xfs/628
> @@ -17,6 +17,7 @@ _begin_fstest scrub fsstress_scrub
>  . ./common/inject
>  . ./common/xfs
>  
> +_require_scrub
>  _require_scratch
>  _require_xfs_stress_scrub
>  
> 

