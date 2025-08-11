Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FC362E03FD
	for <linux-xfs@vger.kernel.org>; Mon, 11 Aug 2025 18:13:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754936025; cv=none; b=gKSFgNmwQIULnJDmNm4ajoGY+WJzkZGoFCCtOcZlRE29OzHAIVh8ODd++n75c+HJjvBHFC9wXLyPXdvNGzr7vhKkm3QM7rH8LUZXUxpqFYtm1HvltPsIvHgzjWZ3JprDGBDNGynUvgV93gZHeyaRs4LwLzO0PZHmYMCq8mAQ2CE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754936025; c=relaxed/simple;
	bh=SaDYoexQ4i5tsfF3WUqgJORGkWiPSN9Fx4XhDfEx2tA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nZzHKHZpEKknT6qY0b7eAOQlctgCjyzoNkK4q/7j4WnzNUIAm3GXH4G7LZmPQt7HDw3i9EA6AWg2LBhAOYp5bgFLyNcYKB95PP8o3AhEcv9A+dgbLUwKq3W3d9SXJEOKO2ZnPniOKqp1IvjVotJy0h0RQLA3JLySSiM0C06+Bes=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=HIomUPfw; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HIomUPfw"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754936022;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=9TMPOQosyR3kzECChmd17ITJUt3EfWra1AAklKdXopQ=;
	b=HIomUPfwNuqsw1XY2bZouyhNtpqmrsqZ7q57FOzT4PVK4iUMNL1FYHIBAUV16m8g0gBcpi
	RizPl84Uuy8XvNw5ToagHrCd/SJlu0YBOev7iRH3Za+TggwFktnElxSdkQjcCJnBgQQOA6
	bR6g9ppbNF4ab8fBQPG7vgZIwEFTDBk=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-213-bOhTOB4UN1KvzdJ1KoiCSg-1; Mon, 11 Aug 2025 14:13:41 -0400
X-MC-Unique: bOhTOB4UN1KvzdJ1KoiCSg-1
X-Mimecast-MFC-AGG-ID: bOhTOB4UN1KvzdJ1KoiCSg_1754936020
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-459edc72b65so39879995e9.3
        for <linux-xfs@vger.kernel.org>; Mon, 11 Aug 2025 11:13:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754936020; x=1755540820;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9TMPOQosyR3kzECChmd17ITJUt3EfWra1AAklKdXopQ=;
        b=f6E8JCWGA4VmY2xcilzEGOBY4HXXASIf3a/WgSLlW+CuXxilCqpwRd4VaAQZ9Cwjw1
         xzN7uv4vZCM3vIZonzZTxISVDiSnrRHjk96nixAbiGCCwHvtjRpImWELs6MevqkhB/Oy
         CcZab9yU0ZL5zox2mBecQl0xgjQ+1X447snOPeKbmUhpe21950oKYVCvYppEy1UFgEd1
         MIEJFM5817suC8W0f3UfqaOD/A4jfX1XiPuhs5lIaW7zklYhwFR3mEEPdpFRQK2hSugd
         EpPNho/PmAJTQptNNpRPasMhK6RXubCX7RzD4f+Ua2D3o7njYwvxwDXDlH5hIBmOiwRs
         Zs9A==
X-Forwarded-Encrypted: i=1; AJvYcCUk1K61ORaydY/Lwlsml5KkBAhBYKO3tgNpODKEsynIyY9Qt/hu3TZ/QloiXp0goY0We8id3kVdBG0=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw0HeXG5eMuVqNbhwBaMRuN/DISKLhZB7+zSQwV2JW/qnuW+KuX
	xyurKdyp0Ae1P8Dyd6vjePKU+BKVnjpHq8dXg3HwzHlLMERR8UZAAB5MfvdwFr7xqvLcxDFSYgr
	8fF18BVCcnoZtlifcckaGktyf5GTvrkoG1tkZyvLBKbg6Sp7UiYUZuJNXJQmu
X-Gm-Gg: ASbGncvnp34HxppIbyx0yUVyzmSYBtQpEuqZRESpLspAg0OwrVVWhpK+E7AEpYdm41Y
	anFgbEhmf8X0h1RRBYOHUbyXb5WOwEwKhhnkPA9IujoQiGfYOtRXB287FdT6goKYCZ2kkSlR6wO
	Ge05G7JYYvwyDVFVVT2cag89I1Jm8v+AY8VhE+TC1Yw7VjeIHZxUF8segOAQXfnBNMVJG1ka0VO
	WWU114tbBsamrhKpOgMTexSA4q1/zFZjSmwvo26BBdOdTohYx4oBzooBNlTMOhDbcAfh58GArN8
	msxieueokdikZTiLnNb/KlGrtSePM9L4kuQYJLagfjiQBH9ekYF8kbxM2l0=
X-Received: by 2002:a05:600c:1c97:b0:43c:f44c:72a6 with SMTP id 5b1f17b1804b1-459f4f3dda6mr118690395e9.2.1754936019733;
        Mon, 11 Aug 2025 11:13:39 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGpEEe1Ffykdz8Jornajz4J1RLFvc/FUoBKAZ7COCrJvtMvhYda/gZ9RZ/4GOWvQPFQrYHNYA==
X-Received: by 2002:a05:600c:1c97:b0:43c:f44c:72a6 with SMTP id 5b1f17b1804b1-459f4f3dda6mr118690175e9.2.1754936019256;
        Mon, 11 Aug 2025 11:13:39 -0700 (PDT)
Received: from thinky (ip-217-030-074-039.aim-net.cz. [217.30.74.39])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-459e5873c43sm286317885e9.22.2025.08.11.11.13.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Aug 2025 11:13:39 -0700 (PDT)
Date: Mon, 11 Aug 2025 20:13:38 +0200
From: Andrey Albershteyn <aalbersh@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: fstests@vger.kernel.org, zlang@redhat.com, 
	linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org, 
	Andrey Albershteyn <aalbersh@kernel.org>
Subject: Re: [PATCH 2/3] generic: introduce test to test
 file_getattr/file_setattr syscalls
Message-ID: <n226bxztejpoulfh5ok4qp2acccnr3d2smbqev2jsbd46omnom@4xqc67yx234p>
References: <20250808-xattrat-syscall-v1-0-6a09c4f37f10@kernel.org>
 <20250808-xattrat-syscall-v1-2-6a09c4f37f10@kernel.org>
 <20250811151740.GE7965@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250811151740.GE7965@frogsfrogsfrogs>

On 2025-08-11 08:17:40, Darrick J. Wong wrote:
> On Fri, Aug 08, 2025 at 09:31:57PM +0200, Andrey Albershteyn wrote:
> > Add a test to test basic functionality of file_getattr() and
> > file_setattr() syscalls. Most of the work is done in file_attr
> > utility.
> > 
> > Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
> > ---
> >  tests/generic/2000     | 113 +++++++++++++++++++++++++++++++++++++++++++++++++
> >  tests/generic/2000.out |  37 ++++++++++++++++
> >  2 files changed, 150 insertions(+)
> > 
> > diff --git a/tests/generic/2000 b/tests/generic/2000
> > new file mode 100755
> > index 000000000000..b4410628c241
> > --- /dev/null
> > +++ b/tests/generic/2000
> > @@ -0,0 +1,113 @@
> > +#! /bin/bash
> > +# SPDX-License-Identifier: GPL-2.0
> > +# Copyright (c) 2025 Red Hat Inc.  All Rights Reserved.
> > +#
> > +# FS QA Test No. 2000
> > +#
> > +# Test file_getattr/file_setattr syscalls
> > +#
> > +. ./common/preamble
> > +_begin_fstest auto
> > +
> > +# Import common functions.
> > +# . ./common/filter
> > +
> > +_wants_kernel_commit xxxxxxxxxxx \
> > +	"fs: introduce file_getattr and file_setattr syscalls"
> > +
> > +# Modify as appropriate.
> > +_require_scratch
> > +_require_test_program "af_unix"
> > +_require_test_program "file_attr"
> > +_require_symlinks
> > +_require_mknod
> > +
> > +_scratch_mkfs >>$seqres.full 2>&1
> > +_scratch_mount
> > +
> > +file_attr () {
> > +	$here/src/file_attr $*
> > +}
> > +
> > +create_af_unix () {
> > +	$here/src/af_unix $* || echo af_unix failed
> > +}
> > +
> > +projectdir=$SCRATCH_MNT/prj
> > +
> > +# Create normal files and special files
> > +mkdir $projectdir
> > +mkfifo $projectdir/fifo
> > +mknod $projectdir/chardev c 1 1
> > +mknod $projectdir/blockdev b 1 1
> > +create_af_unix $projectdir/socket
> > +touch $projectdir/foo
> > +ln -s $projectdir/foo $projectdir/symlink
> > +touch $projectdir/bar
> > +ln -s $projectdir/bar $projectdir/broken-symlink
> > +rm -f $projectdir/bar
> > +
> > +echo "Error codes"
> > +# wrong AT_ flags
> > +file_attr --get --invalid-at $projectdir ./foo
> > +file_attr --set --invalid-at $projectdir ./foo
> > +# wrong fsxattr size (too big, too small)
> > +file_attr --get --too-big-arg $projectdir ./foo
> > +file_attr --get --too-small-arg $projectdir ./foo
> > +file_attr --set --too-big-arg $projectdir ./foo
> > +file_attr --set --too-small-arg $projectdir ./foo
> > +# out of fsx_xflags mask
> > +file_attr --set --new-fsx-flag $projectdir ./foo
> > +
> > +echo "Initial attributes state"
> > +file_attr --get $projectdir
> > +file_attr --get $projectdir ./fifo
> > +file_attr --get $projectdir ./chardev
> > +file_attr --get $projectdir ./blockdev
> > +file_attr --get $projectdir ./socket
> > +file_attr --get $projectdir ./foo
> > +file_attr --get $projectdir ./symlink
> > +
> > +echo "Set FS_XFLAG_NODUMP (d)"
> > +file_attr --set --set-nodump $projectdir
> > +file_attr --set --set-nodump $projectdir ./fifo
> > +file_attr --set --set-nodump $projectdir ./chardev
> > +file_attr --set --set-nodump $projectdir ./blockdev
> > +file_attr --set --set-nodump $projectdir ./socket
> > +file_attr --set --set-nodump $projectdir ./foo
> > +file_attr --set --set-nodump $projectdir ./symlink
> > +
> > +echo "Read attributes"
> > +file_attr --get $projectdir
> > +file_attr --get $projectdir ./fifo
> > +file_attr --get $projectdir ./chardev
> > +file_attr --get $projectdir ./blockdev
> > +file_attr --get $projectdir ./socket
> > +file_attr --get $projectdir ./foo
> > +file_attr --get $projectdir ./symlink
> > +
> > +echo "Set attribute on broken link with AT_SYMLINK_NOFOLLOW"
> > +file_attr --set --set-nodump $projectdir ./broken-symlink
> > +file_attr --get $projectdir ./broken-symlink
> > +
> > +file_attr --set --no-follow --set-nodump $projectdir ./broken-symlink
> > +file_attr --get --no-follow $projectdir ./broken-symlink
> > +
> > +cd $SCRATCH_MNT
> > +touch ./foo2
> > +echo "Initial state of foo2"
> > +file_attr --get --at-cwd ./foo2
> > +echo "Set attribute relative to AT_FDCWD"
> > +file_attr --set --at-cwd --set-nodump ./foo2
> > +file_attr --get --at-cwd ./foo2
> > +
> > +echo "Set attribute on AT_FDCWD"
> > +mkdir ./bar
> > +file_attr --get --at-cwd ./bar
> > +cd ./bar
> > +file_attr --set --at-cwd --set-nodump ""
> > +file_attr --get --at-cwd .
> > +
> > +# success, all done
> > +status=0
> > +exit
> > diff --git a/tests/generic/2000.out b/tests/generic/2000.out
> > new file mode 100644
> > index 000000000000..51b4d84e2bae
> > --- /dev/null
> > +++ b/tests/generic/2000.out
> > @@ -0,0 +1,37 @@
> > +QA output created by 2000
> > +Error codes
> > +Can not get fsxattr on ./foo: Invalid argument
> > +Can not get fsxattr on ./foo: Invalid argument
> > +Can not get fsxattr on ./foo: Argument list too long
> > +Can not get fsxattr on ./foo: Invalid argument
> > +Can not get fsxattr on ./foo: Argument list too long
> > +Can not get fsxattr on ./foo: Invalid argument
> > +Can not set fsxattr on ./foo: Invalid argument
> > +Initial attributes state
> > +----------------- /mnt/scratch/prj 
> 
> Assuming SCRATCH_DIR=/mnt/scratch on your system, please _filter_scratch
> the output.
> 
> (The rest looks reasonable to me.)
> 
> --D
> 

ops, will fix, thanks

-- 
- Andrey

