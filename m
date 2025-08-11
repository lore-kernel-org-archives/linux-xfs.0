Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 097B1296BDC
	for <linux-xfs@vger.kernel.org>; Mon, 11 Aug 2025 17:55:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754934952; cv=none; b=Geg4nUqIWj1vkztT0YZnZqRpbLfb9duZCbHBuw8jx13CxwajOz+mkBiEVFkhL6mBAnUdM3Tt0r7haPrfSMuvWaUvXZIPrvcMRzER36LzrrDFBhRjzdD95YGSyfVwiISDho+pI59HLgFBZe51K3WLSAXp8GxzXkKcKlAE+CJLdp8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754934952; c=relaxed/simple;
	bh=d76Rw9ArLn/J5YVt1ffSDv17TJKmXjtKa6MujY3MULY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gthoiGB0fd8flnQpWTe2+QWm7g9KMR8fCYmI+EmdkGEgaR8rz0ZatQRgt+UxIxrYDx1HnVs462LlrruH0mXli8omgfAh//McO7KS/iIGMyoWu+cCrtEzMZ6KP9/aZxZoanAPLtTYPL6GE6Nr74LR+O4f+KhAZ5GL5oCuvlFkpAY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=iks4cUEt; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="iks4cUEt"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754934949;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=C3QXOydH3LXGSPQs+asu65g20FwVWtDtiIiic1aVboc=;
	b=iks4cUEtMyQZoA/+8NbDhQAMOWot9Q6KxfP2zcwAFKXWHMW3xShYxCdwaWoyR6wvZKD+CD
	CzBQY4NX48qVN+Wlav69v9l+OD7ySe2vTQSs3gcutmH4xCs3C035gpIwvbufeGkq9hRkTc
	tbj+m+0yZ0ORJT8XozY4KrKXNipV4IM=
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com
 [209.85.210.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-74-dBEqoml-NWOb5lopqy00pg-1; Mon, 11 Aug 2025 13:55:48 -0400
X-MC-Unique: dBEqoml-NWOb5lopqy00pg-1
X-Mimecast-MFC-AGG-ID: dBEqoml-NWOb5lopqy00pg_1754934948
Received: by mail-pf1-f199.google.com with SMTP id d2e1a72fcca58-76b857c5be7so4378356b3a.3
        for <linux-xfs@vger.kernel.org>; Mon, 11 Aug 2025 10:55:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754934948; x=1755539748;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=C3QXOydH3LXGSPQs+asu65g20FwVWtDtiIiic1aVboc=;
        b=KPBsH8T1d54dluBcrzTeWaVZkajtlKXArvsFcuVFV0Q3c/8Dyrxd+4C2PSFszIsSKO
         B1WGAfFPjYhnX9l+MFtW+/W///6epdUlJAWwajxrED7+bIkurjBq+Wy45qf59eE+i4e7
         mK/2QpcViMSNNrjzQMDGndnsM8DW57eDTXgdzmOC1jWtVnH+NZ1+Xj9A0WP1UymUWCsc
         B/DPbwPYyklwYqxn99K7jg9B9MUMDMRmTTQAd/+55KrsHRev8t8tBHGAnaT6Fb0Hk4tP
         XzUGLIT6aFzjINdaDD+Ijo9CFjSn5KKJ/0nPS+SJSf/An5qH/prZ9iqFCIFoSNy/6zey
         0wCg==
X-Forwarded-Encrypted: i=1; AJvYcCX/R6GH+CeWsGUZG9XAzjNBGrVtGTROIAR1DxItmC8bNm5Y/Klr1FB8vEM+5uBhYnmsyvWui5NJns8=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz4WtpY9NiWuiSkgQz16E8MWS0nNo6OZY23RAIB2zy+zgvixt3S
	OpdQDjq6hxyJNO4F3AQw9AgyOw9qn4NP88LqAPvKSzwqeRxhNmMtJ0Rr5nSDdeU0htzB7ewMxKN
	jqIDo1l+B6yAoyYEPdnRTTx8pmVbfLAQx9MGtLO5QeI3r8EWSNIox/06+hMY+CA==
X-Gm-Gg: ASbGncvIKbzZmJ4mbp4Sm4ir4pCMCg/X0PEvM2WQYnYOQJwIStIUi6IZd163MbSY9uz
	+1VEFnxrNoSbVOb7uFNPwX62V6r5UfpUAIpG6lSOtsof7fCd0coECMyq3RwXYkC8h/2LJkX8uR0
	qI276Le+6ZTUqwcAXBdTVdFlfCc6AIeGxnyDpzhgNslJLGPmbrRvk4TYR7MneWmMVkoVdNrESSy
	deysOEyN628QwWEb/2z9v/NFgrTZoSbd1+lVg0N7pnyAGxDnRCvm70+xpU1dvoWYDEUhoAVKNP8
	26yFtMcGrMGHDUA+uzuQqB3ge0i0jDq2ku+gjobHp8gcOLQ1DhFzE0A3hQp/8F+DRmSehMPSNcs
	xBnKI
X-Received: by 2002:a05:6a21:6da1:b0:23d:54bd:92e6 with SMTP id adf61e73a8af0-2409a97be24mr557748637.29.1754934947514;
        Mon, 11 Aug 2025 10:55:47 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFkx3HlXgqAb3dC/KM8+a1wL3fzhbRQifsRsePpuzZS+oPXlv/TTJGnW1EcRAswQskCNnsL6A==
X-Received: by 2002:a05:6a21:6da1:b0:23d:54bd:92e6 with SMTP id adf61e73a8af0-2409a97be24mr557666637.29.1754934946575;
        Mon, 11 Aug 2025 10:55:46 -0700 (PDT)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([209.132.188.88])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b428e6244a5sm9723150a12.23.2025.08.11.10.55.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Aug 2025 10:55:46 -0700 (PDT)
Date: Tue, 12 Aug 2025 01:55:41 +0800
From: Zorro Lang <zlang@redhat.com>
To: Andrey Albershteyn <aalbersh@redhat.com>
Cc: fstests@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-xfs@vger.kernel.org, Andrey Albershteyn <aalbersh@kernel.org>
Subject: Re: [PATCH 2/3] generic: introduce test to test
 file_getattr/file_setattr syscalls
Message-ID: <20250811175541.nbvwyy76zulslgnq@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <20250808-xattrat-syscall-v1-0-6a09c4f37f10@kernel.org>
 <20250808-xattrat-syscall-v1-2-6a09c4f37f10@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250808-xattrat-syscall-v1-2-6a09c4f37f10@kernel.org>

On Fri, Aug 08, 2025 at 09:31:57PM +0200, Andrey Albershteyn wrote:
> Add a test to test basic functionality of file_getattr() and
> file_setattr() syscalls. Most of the work is done in file_attr
> utility.
> 
> Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
> ---
>  tests/generic/2000     | 113 +++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/generic/2000.out |  37 ++++++++++++++++
>  2 files changed, 150 insertions(+)
> 
> diff --git a/tests/generic/2000 b/tests/generic/2000
> new file mode 100755
> index 000000000000..b4410628c241
> --- /dev/null
> +++ b/tests/generic/2000
> @@ -0,0 +1,113 @@
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
> +# Import common functions.
> +# . ./common/filter
> +
> +_wants_kernel_commit xxxxxxxxxxx \
> +	"fs: introduce file_getattr and file_setattr syscalls"

As this's a new feature test, I'm wondering if we should use a _require_
function to check if current kernel and FSTYP supports file_set/getattr
syscalls, and _notrun if it's not supported, rather than fail the test.

Thanks,
Zorro

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
> +file_attr --get $projectdir
> +file_attr --get $projectdir ./fifo
> +file_attr --get $projectdir ./chardev
> +file_attr --get $projectdir ./blockdev
> +file_attr --get $projectdir ./socket
> +file_attr --get $projectdir ./foo
> +file_attr --get $projectdir ./symlink
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
> +file_attr --get $projectdir
> +file_attr --get $projectdir ./fifo
> +file_attr --get $projectdir ./chardev
> +file_attr --get $projectdir ./blockdev
> +file_attr --get $projectdir ./socket
> +file_attr --get $projectdir ./foo
> +file_attr --get $projectdir ./symlink
> +
> +echo "Set attribute on broken link with AT_SYMLINK_NOFOLLOW"
> +file_attr --set --set-nodump $projectdir ./broken-symlink
> +file_attr --get $projectdir ./broken-symlink
> +
> +file_attr --set --no-follow --set-nodump $projectdir ./broken-symlink
> +file_attr --get --no-follow $projectdir ./broken-symlink
> +
> +cd $SCRATCH_MNT
> +touch ./foo2
> +echo "Initial state of foo2"
> +file_attr --get --at-cwd ./foo2
> +echo "Set attribute relative to AT_FDCWD"
> +file_attr --set --at-cwd --set-nodump ./foo2
> +file_attr --get --at-cwd ./foo2
> +
> +echo "Set attribute on AT_FDCWD"
> +mkdir ./bar
> +file_attr --get --at-cwd ./bar
> +cd ./bar
> +file_attr --set --at-cwd --set-nodump ""
> +file_attr --get --at-cwd .
> +
> +# success, all done
> +status=0
> +exit
> diff --git a/tests/generic/2000.out b/tests/generic/2000.out
> new file mode 100644
> index 000000000000..51b4d84e2bae
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
> +----------------- /mnt/scratch/prj 
> +----------------- ./fifo 
> +----------------- ./chardev 
> +----------------- ./blockdev 
> +----------------- ./socket 
> +----------------- ./foo 
> +----------------- ./symlink 
> +Set FS_XFLAG_NODUMP (d)
> +Read attributes
> +------d---------- /mnt/scratch/prj 
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
> 2.49.0
> 

