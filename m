Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99F111A9FAA
	for <linux-xfs@vger.kernel.org>; Mon, 11 Aug 2025 17:46:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754934384; cv=none; b=CDaz/hNYdvJLElhP0X0NnzGxo1iQ6VGW+upENBxRY9aHZTkQaWkmhti7DEBThPOLrLul2K2cQLljfXw8H7LmUnelID58QeHpHhvdv3bNnZ5uoSdWYPQkmQlqXRqYBDC5mGDZlBe52JMT/njdaZIrHaACvDExK/WBMcNXzH6AASo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754934384; c=relaxed/simple;
	bh=jblgerfx+aJVX6LVOYqXPt0kykFkW9DjcEJst3CKdxM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ak0Bl+Z1+PM+U9Plr2dKAn62deWzRezc2nrlcmCtZ0ZDZ8Lb3cTXan5LO1PlFb/6F7KuPLcGLNUcKoFJI8mxnsJIdUkN8WuVZOcYfIwm4Io6gJcVsyLuOAt9dQgOO+XcyqxnIAOVl8Bb4Dd3oMtjH+fk+TfNdGF6qfb4PrWiKrY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=XquZFkkf; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XquZFkkf"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754934381;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=qMneaytKQ0AD4shgUGd68vlulgEjA6lPuzfiwSM1OQI=;
	b=XquZFkkfGaPgDUgfju67hCTZbWWCX10tdbZQoNs34S8elVrd85oYfgH6C1NTF9w5B0VCAM
	lTK6JQho82fOtUhCJdpaLDm0BMkqBI0vSJB5zPWZKEURCQIP8nAGIn796AcT+qRfBCRnEo
	G13IxYDxTFIFS8vzrke+FEf86jjDN1E=
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com
 [209.85.210.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-625-sm6X6S2aMW-p7kYwV0yu1A-1; Mon, 11 Aug 2025 13:46:19 -0400
X-MC-Unique: sm6X6S2aMW-p7kYwV0yu1A-1
X-Mimecast-MFC-AGG-ID: sm6X6S2aMW-p7kYwV0yu1A_1754934378
Received: by mail-pf1-f198.google.com with SMTP id d2e1a72fcca58-76bf8e79828so8935585b3a.3
        for <linux-xfs@vger.kernel.org>; Mon, 11 Aug 2025 10:46:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754934378; x=1755539178;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qMneaytKQ0AD4shgUGd68vlulgEjA6lPuzfiwSM1OQI=;
        b=hAM3nvAJ24v8UYGxp+wX4L3rVYOn/orWu+8RjCWLA/jYneSzXi3Da2ONQ8mIXjH0eM
         E0m4B0rtkNslX+1YwqgXvIsXjN/b827V01Se+hGnEqz+tyG2rOq6HEkMGhj9UWMhp1Nr
         BOOF10R3HUSdfh8FLWdyKrP1yI7sJEgIfasO6jyPXgKuPcSokpV1uYLTwWrbfEVpT9bK
         rtvXEBEZ0ZeWuqWia1Ea0ucLHry+M6gEdJLDuqe9WVbUqDBBQitLDHYqn93oO+xSbFni
         7S2VCEh8VpMV36pzENbuG07U3f17FLP2yu4w/scG+Z2s68O/c5Yw78QWIhjk2fRT6+r7
         NE6A==
X-Forwarded-Encrypted: i=1; AJvYcCV1qkiLnmUxjlFZSoDJtbI5JBkuAEKF9ItRH/ru6ommHsT2fqT4q3Gy3FUMdfqgv+LSDgeHhZ2L9uY=@vger.kernel.org
X-Gm-Message-State: AOJu0YzWoHNsQTba/jZ20T0STPPGJcuXy+fWy2C5GKqFFxzz3q+2jxVT
	DcHuVEyEjpD3OCA9eWUWQsJiBaVOO0HCLSvvKTwcRYWLoTSvDTFWThrQx3YGUPlyBxONlUzCpkb
	6O0lCBJ45pc2ol7GyVrjYF+Zbudq2G9HOXK+e87pSZnO5d81W095zoT4p6AYL6Q==
X-Gm-Gg: ASbGncvZ/mT8gaGz7Hy3PXvChqnh0+tGPInyI/jDVN4ocQhukm4jPDcrw/LSd5OKJ/X
	rCQfZRYCzDm43f5ni/5hNFrlNAu3afZ/FytDyHVyhgOT1Rhq2/ddKSf4Axgzaegkq3OIzulQANQ
	q0yCaMFuKK8GLvA7Qp1SiOcLEoc7D8wE69hKRzvlf4kzhYCG6LJNkcTKKNDmDAkzt86I6HqHm+b
	mah/RPbRUh2OqSGNqRTHozEiK7epQlQ9xH/F3aLxuIhyaC/ZgTXMG1NRu4FP+uMtMOxqBSX6wLR
	DuGvc7yKz88SnMyqOUNKiPCgHpiLKMnzn32UmHgKTHmJyhru9ljlsAC1UeemwRWdRsYnT2WcCxd
	lWSIL
X-Received: by 2002:a05:6a00:2d1b:b0:748:2ac2:f8c3 with SMTP id d2e1a72fcca58-76c461afafbmr20914886b3a.24.1754934378070;
        Mon, 11 Aug 2025 10:46:18 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHICW+eZv8C5Z5RSskTv0jMxvDRZLNGUY53XhWHmVwEA9SnpT+Jnb7MR3JJ8/dMmD/l01jQSw==
X-Received: by 2002:a05:6a00:2d1b:b0:748:2ac2:f8c3 with SMTP id d2e1a72fcca58-76c461afafbmr20914839b3a.24.1754934377649;
        Mon, 11 Aug 2025 10:46:17 -0700 (PDT)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([209.132.188.88])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-76c2078afd8sm15396442b3a.117.2025.08.11.10.46.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Aug 2025 10:46:17 -0700 (PDT)
Date: Tue, 12 Aug 2025 01:46:13 +0800
From: Zorro Lang <zlang@redhat.com>
To: Andrey Albershteyn <aalbersh@redhat.com>
Cc: fstests@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-xfs@vger.kernel.org, Andrey Albershteyn <aalbersh@kernel.org>
Subject: Re: [PATCH 3/3] xfs: test quota's project ID on special files
Message-ID: <20250811174613.tskc4xzbhteyiq5z@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <20250808-xattrat-syscall-v1-0-6a09c4f37f10@kernel.org>
 <20250808-xattrat-syscall-v1-3-6a09c4f37f10@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250808-xattrat-syscall-v1-3-6a09c4f37f10@kernel.org>

On Fri, Aug 08, 2025 at 09:31:58PM +0200, Andrey Albershteyn wrote:
> From: Andrey Albershteyn <aalbersh@redhat.com>
> 
> With addition of file_getattr() and file_setattr(), xfs_quota now can
> set project ID on filesystem inodes behind special files. Previously,
> quota reporting didn't count inodes of special files created before
> project initialization. Only new inodes had project ID set.
> 
> Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
> ---
>  tests/xfs/2000     | 77 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/2000.out | 17 ++++++++++++
>  2 files changed, 94 insertions(+)
> 
> diff --git a/tests/xfs/2000 b/tests/xfs/2000
> new file mode 100755
> index 000000000000..26a0093c1da1
> --- /dev/null
> +++ b/tests/xfs/2000
> @@ -0,0 +1,77 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2024 Red Hat.  All Rights Reserved.
> +#
> +# FS QA Test No. 2000
> +#
> +# Test that XFS can set quota project ID on special files
> +#
> +. ./common/preamble
> +_begin_fstest auto quota
> +
> +# Import common functions.
> +. ./common/quota
> +. ./common/filter
> +
> +_wants_kernel_commit xxxxxxxxxxx \
> +	"xfs: allow setting file attributes on special files"
> +_wants_git_commit xfsprogs xxxxxxxxxxx \
> +	"xfs_quota: utilize file_setattr to set prjid on special files"
> +
> +# Modify as appropriate.
> +_require_scratch
> +_require_xfs_quota
> +_require_test_program "af_unix"
> +_require_symlinks
> +_require_mknod
> +
> +_scratch_mkfs >>$seqres.full 2>&1
> +_qmount_option "pquota"
> +_scratch_mount
> +
> +create_af_unix () {
> +	$here/src/af_unix $* || echo af_unix failed
> +}
> +
> +filter_quota() {
> +	_filter_quota | sed "s~$tmp.projects~PROJECTS_FILE~"
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
> +$XFS_QUOTA_PROG -D $tmp.projects -P $tmp.projid -x \
> +	-c "project -sp $projectdir $id" $SCRATCH_DEV | filter_quota
> +$XFS_QUOTA_PROG -D $tmp.projects -P $tmp.projid -x \
> +	-c "limit -p isoft=20 ihard=20 $id " $SCRATCH_DEV | filter_quota
> +$XFS_QUOTA_PROG -D $tmp.projects -P $tmp.projid -x \
> +	-c "project -cp $projectdir $id" $SCRATCH_DEV | filter_quota
> +$XFS_QUOTA_PROG -D $tmp.projects -P $tmp.projid -x \
> +	-c "report -inN -p" $SCRATCH_DEV
> +$XFS_QUOTA_PROG -D $tmp.projects -P $tmp.projid -x \
> +	-c "project -Cp $projectdir $id" $SCRATCH_DEV | filter_quota
> +
> +# Let's check that we can recreate the project (flags were cleared out)
> +$XFS_QUOTA_PROG -D $tmp.projects -P $tmp.projid -x \
> +	-c "project -sp $projectdir $id" $SCRATCH_DEV | filter_quota
> +$XFS_QUOTA_PROG -D $tmp.projects -P $tmp.projid -x \
> +	-c "limit -p isoft=20 ihard=20 $id " $SCRATCH_DEV | filter_quota
> +$XFS_QUOTA_PROG -D $tmp.projects -P $tmp.projid -x \
> +	-c "report -inN -p" $SCRATCH_DEV
> +$XFS_QUOTA_PROG -D $tmp.projects -P $tmp.projid -x \
> +	-c "project -Cp $projectdir $id" $SCRATCH_DEV | filter_quota
> +
> +# success, all done
> +status=0
> +exit
> diff --git a/tests/xfs/2000.out b/tests/xfs/2000.out
> new file mode 100644
> index 000000000000..dd3918f1376d
> --- /dev/null
> +++ b/tests/xfs/2000.out
> @@ -0,0 +1,17 @@
> +QA output created by 2000
> +Setting up project 42 (path SCRATCH_MNT/prj)...
> +Processed 1 (PROJECTS_FILE and cmdline) paths for project 42 with recursion depth infinite (-1).
> +Checking project 42 (path SCRATCH_MNT/prj)...
> +Processed 1 (PROJECTS_FILE and cmdline) paths for project 42 with recursion depth infinite (-1).
> +#0                   3          0          0     00 [--------]

Better to filter out the root quota report, it might fail on some test environments.

Thanks,
Zorro

> +#42                  8         20         20     00 [--------]
> +
> +Clearing project 42 (path SCRATCH_MNT/prj)...
> +Processed 1 (PROJECTS_FILE and cmdline) paths for project 42 with recursion depth infinite (-1).
> +Setting up project 42 (path SCRATCH_MNT/prj)...
> +Processed 1 (PROJECTS_FILE and cmdline) paths for project 42 with recursion depth infinite (-1).
> +#0                   3          0          0     00 [--------]
> +#42                  8         20         20     00 [--------]
> +
> +Clearing project 42 (path SCRATCH_MNT/prj)...
> +Processed 1 (PROJECTS_FILE and cmdline) paths for project 42 with recursion depth infinite (-1).
> 
> -- 
> 2.49.0
> 

