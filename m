Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50C021D07AD
	for <linux-xfs@vger.kernel.org>; Wed,  2 Oct 2024 13:38:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727876292; cv=none; b=U8/GXeB9bbCUU5UDeahAwUjvj+DHwiei5V5G639+Fb1NwV+SjLxoDUcr264re1rrS4qq2WadnwdT0adtv4IshkXaPPWeNFvcw1bsc2Ia6KatgGwLHGBoDHaQPLS8mH66p/PfEBM7kUGOjez54UtZtBNc5VCo0BAeuQl5UPUNMZc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727876292; c=relaxed/simple;
	bh=4B4o4MunQ60c7QX8isbEEPPv1ilfRH3c9KmCzcf7tEo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=K5E9l0aXvOe7ePjpzSDpiSLPthpE2a/zGeh4rgcCR70wgGB9SkgyHh3ezKHezBZkRlwf6KD4vpZ4F/rVeeGkZzZyI0+1j+RJnOSZkrbOsJaHNDkI7tYvZT1mvmgzgcub0MBtNb6uXhfcRLjTnu0dspstKTaYYP27HmLXcR7xUWc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Ni3AiffY; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Ni3AiffY"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1727876288;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=qzX5jq71qX2Xyvp0wNt4hZOZU3FceZiufZfnSmf6GwA=;
	b=Ni3AiffYSOFLXVPNhOkU5JZJRQ6Pef4P9ti3eK6dnLYSGbjHrRGl8xxSnWRyjIOtA7nKk8
	WZiDjNHHGzTQTzeCzKMNqM2scd5dtN0b+TWQByx1jHg3jqx92NYhSlXBVknNAZg05Q740K
	92Hy1/wjsped79PHluqaE0F7iGWX1d4=
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com
 [209.85.215.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-454-Y_Yh9qO_OaKhnOC7f78d6w-1; Wed, 02 Oct 2024 09:38:07 -0400
X-MC-Unique: Y_Yh9qO_OaKhnOC7f78d6w-1
Received: by mail-pg1-f197.google.com with SMTP id 41be03b00d2f7-7db9418552fso5860192a12.0
        for <linux-xfs@vger.kernel.org>; Wed, 02 Oct 2024 06:38:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727876286; x=1728481086;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qzX5jq71qX2Xyvp0wNt4hZOZU3FceZiufZfnSmf6GwA=;
        b=hWQ5D0t/wSFMfy9uVeDMNPbCXuQ5Yrrnl2IXWB528bDY2v7agX1LfedKDZWKpKbKT0
         mef36Hi5qVZ7Uskq6xbtk4Bwu4F+QSNRhvos9cdF4U4xUG+U6X71aTDps5jTmDzL7vjv
         R6hI52e0PtceOK8VEevNJkGLfpyG24k/6ZPU0nP6V7ovIPK+1UJYfKGmCbpVULS1+3hV
         7c2FX0Ck/yuChBp2vkIG1wCh9u3bg7AnI6R7VUiefx3cEFx2pcPoQBSEvRQtnuuYx+hk
         Lju6fdC/vL5204E0HjtEt53nl2HWjxT3Ggx5eNBsN6l++/f0oUVmtNNbOMSQh1QDLMIK
         xyaQ==
X-Forwarded-Encrypted: i=1; AJvYcCWyY63Ut1OCgMF60dKVZJp3HWOlvZGq0mi1q55bg6K9Fhbg98//hNN08zLwfg4Cf1l/YiXbtaf3Cc8=@vger.kernel.org
X-Gm-Message-State: AOJu0YyPgOcvyDI1tF39D/hSgPWMPXibBpZ5f5/uvqnmHPbIbu6b5eJp
	3FTCAVvNS6RMP2uPJtX6ACuubbYFYR5iUvrxU6CyZM8BN6MsEt54PpepFMNBUhprSP/8W5WtDa/
	YwiulwvwT54QHsRi25qJTCuyxprXDcYlQyQ+FD5TceWbL4H1aSCe68L5HPTgBOWwwGfo7
X-Received: by 2002:a17:90b:4f43:b0:2e0:7560:9338 with SMTP id 98e67ed59e1d1-2e184901f61mr3984071a91.25.1727876285920;
        Wed, 02 Oct 2024 06:38:05 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEgIDIHXeQa3/vlWtaSL8dXbMdxyjeHTc3x6E9eii/+OoRndJCqpknfGxnPEMQW9g+6khib1Q==
X-Received: by 2002:a17:90b:4f43:b0:2e0:7560:9338 with SMTP id 98e67ed59e1d1-2e184901f61mr3984048a91.25.1727876285517;
        Wed, 02 Oct 2024 06:38:05 -0700 (PDT)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2e18f8cda33sm1534518a91.44.2024.10.02.06.38.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Oct 2024 06:38:05 -0700 (PDT)
Date: Wed, 2 Oct 2024 21:38:00 +0800
From: Zorro Lang <zlang@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>, bfoster@redhat.com
Cc: Christoph Hellwig <hch@lst.de>, Zorro Lang <zlang@kernel.org>,
	Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org,
	fstests@vger.kernel.org
Subject: Re: [PATCH] xfs: new EOF fragmentation tests
Message-ID: <20241002133800.pk3kb5powlqjbm3m@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <20240924084551.1802795-1-hch@lst.de>
 <20240924084551.1802795-2-hch@lst.de>
 <20241001145944.GE21840@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241001145944.GE21840@frogsfrogsfrogs>

On Tue, Oct 01, 2024 at 07:59:44AM -0700, Darrick J. Wong wrote:
> On Tue, Sep 24, 2024 at 10:45:48AM +0200, Christoph Hellwig wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > These tests create substantial file fragmentation as a result of
> > application actions that defeat post-EOF preallocation
> > optimisations. They are intended to replicate known vectors for
> > these problems, and provide a check that the fragmentation levels
> > have been controlled. The mitigations we make may not completely
> > remove fragmentation (e.g. they may demonstrate speculative delalloc
> > related extent size growth) so the checks don't assume we'll end up
> > with perfect layouts and hence check for an exceptable level of
> > fragmentation rather than none.
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > [move to different test number, update to current xfstest APIs]
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > ---
> >  tests/xfs/1500     | 66 +++++++++++++++++++++++++++++++++++++++
> >  tests/xfs/1500.out |  9 ++++++
> >  tests/xfs/1501     | 68 ++++++++++++++++++++++++++++++++++++++++
> >  tests/xfs/1501.out |  9 ++++++
> >  tests/xfs/1502     | 68 ++++++++++++++++++++++++++++++++++++++++
> >  tests/xfs/1502.out |  9 ++++++
> >  tests/xfs/1503     | 77 ++++++++++++++++++++++++++++++++++++++++++++++
> >  tests/xfs/1503.out | 33 ++++++++++++++++++++
> >  8 files changed, 339 insertions(+)
> >  create mode 100755 tests/xfs/1500
> >  create mode 100644 tests/xfs/1500.out
> >  create mode 100755 tests/xfs/1501
> >  create mode 100644 tests/xfs/1501.out
> >  create mode 100755 tests/xfs/1502
> >  create mode 100644 tests/xfs/1502.out
> >  create mode 100755 tests/xfs/1503
> >  create mode 100644 tests/xfs/1503.out
> > 
> > diff --git a/tests/xfs/1500 b/tests/xfs/1500
> > new file mode 100755
> > index 000000000..de0e1df62
> > --- /dev/null
> > +++ b/tests/xfs/1500
> > @@ -0,0 +1,66 @@
> > +#! /bin/bash
> > +# SPDX-License-Identifier: GPL-2.0
> > +# Copyright (c) 2019 Red Hat, Inc.  All Rights Reserved.
> > +#
> > +# FS QA Test xfs/500
> > +#
> > +# Post-EOF preallocation defeat test for O_SYNC buffered I/O.
> > +#
> > +
> > +. ./common/preamble
> > +_begin_fstest auto quick prealloc rw
> > +
> > +. ./common/rc
> > +. ./common/filter
> > +
> > +_require_scratch
> > +
> > +_cleanup()
> > +{
> > +	# try to kill all background processes
> > +	wait
> > +	cd /
> > +	rm -r -f $tmp.*
> > +}
> > +
> > +_scratch_mkfs > "$seqres.full" 2>&1
> > +_scratch_mount
> > +
> > +# Write multiple files in parallel using synchronous buffered writes. Aim is to
> > +# interleave allocations to fragment the files. Synchronous writes defeat the
> > +# open/write/close heuristics in xfs_file_release() that prevent EOF block
> > +# removal, so this should fragment badly. Typical problematic behaviour shows
> > +# per-file extent counts of >900 (almost worse case) whilst fixed behaviour
> > +# typically shows extent counts in the low 20s.
> 
> Now that these are in for-next, I've noticed that these new tests
> consistently fail in the above-documented manner on various configs --
> fsdax, always_cow, rtextsize > 1fsb, and sometimes 1k fsblock size.
> 
> I'm not sure why this happens, but it probably needs to be looked at
> along with all the FALLOC_FL_UNSHARE_RANGE brokenness that's also been
> exposed by fstests that /does/ need to be fixed.

Yes, some fsx tests fail on xfs, after the FALLOC_FL_UNSHARE_RANGE supporting.
e.g. g/091, g/127, g/263, g/363 and g/616. I thought they're known issues as
you known. If they're not, better to check. Hi Brian, are these failures as you
known?

Thanks,
Zorro

> 
> --D
> 
> > +# Failure is determined by golden output mismatch from _within_tolerance().
> > +
> > +workfile=$SCRATCH_MNT/file
> > +nfiles=8
> > +wsize=4096
> > +wcnt=1000
> > +
> > +write_sync_file()
> > +{
> > +	idx=$1
> > +
> > +	for ((cnt=0; cnt<$wcnt; cnt++)); do
> > +		$XFS_IO_PROG -f -s -c "pwrite $((cnt * wsize)) $wsize" $workfile.$idx
> > +	done
> > +}
> > +
> > +rm -f $workfile*
> > +for ((n=0; n<$nfiles; n++)); do
> > +	write_sync_file $n > /dev/null 2>&1 &
> > +done
> > +wait
> > +sync
> > +
> > +for ((n=0; n<$nfiles; n++)); do
> > +	count=$(_count_extents $workfile.$n)
> > +	# Acceptible extent count range is 1-40
> > +	_within_tolerance "file.$n extent count" $count 21 19 -v
> > +done
> > +
> > +status=0
> > +exit
> > diff --git a/tests/xfs/1500.out b/tests/xfs/1500.out
> > new file mode 100644
> > index 000000000..414df87ed
> > --- /dev/null
> > +++ b/tests/xfs/1500.out
> > @@ -0,0 +1,9 @@
> > +QA output created by 1500
> > +file.0 extent count is in range
> > +file.1 extent count is in range
> > +file.2 extent count is in range
> > +file.3 extent count is in range
> > +file.4 extent count is in range
> > +file.5 extent count is in range
> > +file.6 extent count is in range
> > +file.7 extent count is in range
> > diff --git a/tests/xfs/1501 b/tests/xfs/1501
> > new file mode 100755
> > index 000000000..cf3cbf8b5
> > --- /dev/null
> > +++ b/tests/xfs/1501
> > @@ -0,0 +1,68 @@
> > +#! /bin/bash
> > +# SPDX-License-Identifier: GPL-2.0
> > +# Copyright (c) 2019 Red Hat, Inc.  All Rights Reserved.
> > +#
> > +# FS QA Test xfs/501
> > +#
> > +# Post-EOF preallocation defeat test for buffered I/O with extent size hints.
> > +#
> > +
> > +. ./common/preamble
> > +_begin_fstest auto quick prealloc rw
> > +
> > +. ./common/rc
> > +. ./common/filter
> > +
> > +_require_scratch
> > +
> > +_cleanup()
> > +{
> > +	# try to kill all background processes
> > +	wait
> > +	cd /
> > +	rm -r -f $tmp.*
> > +}
> > +
> > +_scratch_mkfs > "$seqres.full" 2>&1
> > +_scratch_mount
> > +
> > +# Write multiple files in parallel using buffered writes with extent size hints.
> > +# Aim is to interleave allocations to fragment the files. Writes w/ extent size
> > +# hints set defeat the open/write/close heuristics in xfs_file_release() that
> > +# prevent EOF block removal, so this should fragment badly. Typical problematic
> > +# behaviour shows per-file extent counts of 1000 (worst case!) whilst
> > +# fixed behaviour should show very few extents (almost best case).
> > +#
> > +# Failure is determined by golden output mismatch from _within_tolerance().
> > +
> > +workfile=$SCRATCH_MNT/file
> > +nfiles=8
> > +wsize=4096
> > +wcnt=1000
> > +extent_size=16m
> > +
> > +write_extsz_file()
> > +{
> > +	idx=$1
> > +
> > +	$XFS_IO_PROG -f -c "extsize $extent_size" $workfile.$idx
> > +	for ((cnt=0; cnt<$wcnt; cnt++)); do
> > +		$XFS_IO_PROG -f -c "pwrite $((cnt * wsize)) $wsize" $workfile.$idx
> > +	done
> > +}
> > +
> > +rm -f $workfile*
> > +for ((n=0; n<$nfiles; n++)); do
> > +	write_extsz_file $n > /dev/null 2>&1 &
> > +done
> > +wait
> > +sync
> > +
> > +for ((n=0; n<$nfiles; n++)); do
> > +	count=$(_count_extents $workfile.$n)
> > +	# Acceptible extent count range is 1-10
> > +	_within_tolerance "file.$n extent count" $count 2 1 8 -v
> > +done
> > +
> > +status=0
> > +exit
> > diff --git a/tests/xfs/1501.out b/tests/xfs/1501.out
> > new file mode 100644
> > index 000000000..a266ef74b
> > --- /dev/null
> > +++ b/tests/xfs/1501.out
> > @@ -0,0 +1,9 @@
> > +QA output created by 1501
> > +file.0 extent count is in range
> > +file.1 extent count is in range
> > +file.2 extent count is in range
> > +file.3 extent count is in range
> > +file.4 extent count is in range
> > +file.5 extent count is in range
> > +file.6 extent count is in range
> > +file.7 extent count is in range
> > diff --git a/tests/xfs/1502 b/tests/xfs/1502
> > new file mode 100755
> > index 000000000..f4228667a
> > --- /dev/null
> > +++ b/tests/xfs/1502
> > @@ -0,0 +1,68 @@
> > +#! /bin/bash
> > +# SPDX-License-Identifier: GPL-2.0
> > +# Copyright (c) 2019 Red Hat, Inc.  All Rights Reserved.
> > +#
> > +# FS QA Test xfs/502
> > +#
> > +# Post-EOF preallocation defeat test for direct I/O with extent size hints.
> > +#
> > +
> > +. ./common/preamble
> > +_begin_fstest auto quick prealloc rw
> > +
> > +. ./common/rc
> > +. ./common/filter
> > +
> > +_require_scratch
> > +
> > +_cleanup()
> > +{
> > +	# try to kill all background processes
> > +	wait
> > +	cd /
> > +	rm -r -f $tmp.*
> > +}
> > +
> > +_scratch_mkfs > "$seqres.full" 2>&1
> > +_scratch_mount
> > +
> > +# Write multiple files in parallel using O_DIRECT writes w/ extent size hints.
> > +# Aim is to interleave allocations to fragment the files. O_DIRECT writes defeat
> > +# the open/write/close heuristics in xfs_file_release() that prevent EOF block
> > +# removal, so this should fragment badly. Typical problematic behaviour shows
> > +# per-file extent counts of ~1000 (worst case) whilst fixed behaviour typically
> > +# shows extent counts in the low single digits (almost best case)
> > +#
> > +# Failure is determined by golden output mismatch from _within_tolerance().
> > +
> > +workfile=$SCRATCH_MNT/file
> > +nfiles=8
> > +wsize=4096
> > +wcnt=1000
> > +extent_size=16m
> > +
> > +write_direct_file()
> > +{
> > +	idx=$1
> > +
> > +	$XFS_IO_PROG -f -c "extsize $extent_size" $workfile.$idx
> > +	for ((cnt=0; cnt<$wcnt; cnt++)); do
> > +		$XFS_IO_PROG -f -d -c "pwrite $((cnt * wsize)) $wsize" $workfile.$idx
> > +	done
> > +}
> > +
> > +rm -f $workfile*
> > +for ((n=0; n<$nfiles; n++)); do
> > +	write_direct_file $n > /dev/null 2>&1 &
> > +done
> > +wait
> > +sync
> > +
> > +for ((n=0; n<$nfiles; n++)); do
> > +	count=$(_count_extents $workfile.$n)
> > +	# Acceptible extent count range is 1-10
> > +	_within_tolerance "file.$n extent count" $count 2 1 8 -v
> > +done
> > +
> > +status=0
> > +exit
> > diff --git a/tests/xfs/1502.out b/tests/xfs/1502.out
> > new file mode 100644
> > index 000000000..82c8760a3
> > --- /dev/null
> > +++ b/tests/xfs/1502.out
> > @@ -0,0 +1,9 @@
> > +QA output created by 1502
> > +file.0 extent count is in range
> > +file.1 extent count is in range
> > +file.2 extent count is in range
> > +file.3 extent count is in range
> > +file.4 extent count is in range
> > +file.5 extent count is in range
> > +file.6 extent count is in range
> > +file.7 extent count is in range
> > diff --git a/tests/xfs/1503 b/tests/xfs/1503
> > new file mode 100755
> > index 000000000..9002f87e6
> > --- /dev/null
> > +++ b/tests/xfs/1503
> > @@ -0,0 +1,77 @@
> > +#! /bin/bash
> > +# SPDX-License-Identifier: GPL-2.0
> > +# Copyright (c) 2019 Red Hat, Inc.  All Rights Reserved.
> > +#
> > +# FS QA Test xfs/503
> > +#
> > +# Post-EOF preallocation defeat test with O_SYNC buffered I/O that repeatedly
> > +# closes and reopens the files.
> > +#
> > +
> > +. ./common/preamble
> > +_begin_fstest auto prealloc rw
> > +
> > +. ./common/rc
> > +. ./common/filter
> > +
> > +_require_scratch
> > +
> > +_cleanup()
> > +{
> > +	# try to kill all background processes
> > +	wait
> > +	cd /
> > +	rm -r -f $tmp.*
> > +}
> > +
> > +_scratch_mkfs > "$seqres.full" 2>&1
> > +_scratch_mount
> > +
> > +# Write multiple files in parallel using synchronous buffered writes that
> > +# repeatedly close and reopen the fails. Aim is to interleave allocations to
> > +# fragment the files. Assuming we've fixed the synchronous write defeat, we can
> > +# still trigger the same issue with a open/read/close on O_RDONLY files. We
> > +# should not be triggering EOF preallocation removal on files we don't have
> > +# permission to write, so until this is fixed it should fragment badly.  Typical
> > +# problematic behaviour shows per-file extent counts of 50-350 whilst fixed
> > +# behaviour typically demonstrates post-eof speculative delalloc growth in
> > +# extent size (~6 extents for 50MB file).
> > +#
> > +# Failure is determined by golden output mismatch from _within_tolerance().
> > +
> > +workfile=$SCRATCH_MNT/file
> > +nfiles=32
> > +wsize=4096
> > +wcnt=1000
> > +
> > +write_file()
> > +{
> > +	idx=$1
> > +
> > +	$XFS_IO_PROG -f -s -c "pwrite -b 64k 0 50m" $workfile.$idx
> > +}
> > +
> > +read_file()
> > +{
> > +	idx=$1
> > +
> > +	for ((cnt=0; cnt<$wcnt; cnt++)); do
> > +		$XFS_IO_PROG -f -r -c "pread 0 28" $workfile.$idx
> > +	done
> > +}
> > +
> > +rm -f $workdir/file*
> > +for ((n=0; n<$((nfiles)); n++)); do
> > +	write_file $n > /dev/null 2>&1 &
> > +	read_file $n > /dev/null 2>&1 &
> > +done
> > +wait
> > +
> > +for ((n=0; n<$nfiles; n++)); do
> > +	count=$(_count_extents $workfile.$n)
> > +	# Acceptible extent count range is 1-40
> > +	_within_tolerance "file.$n extent count" $count 6 5 10 -v
> > +done
> > +
> > +status=0
> > +exit
> > diff --git a/tests/xfs/1503.out b/tests/xfs/1503.out
> > new file mode 100644
> > index 000000000..1780b16df
> > --- /dev/null
> > +++ b/tests/xfs/1503.out
> > @@ -0,0 +1,33 @@
> > +QA output created by 1503
> > +file.0 extent count is in range
> > +file.1 extent count is in range
> > +file.2 extent count is in range
> > +file.3 extent count is in range
> > +file.4 extent count is in range
> > +file.5 extent count is in range
> > +file.6 extent count is in range
> > +file.7 extent count is in range
> > +file.8 extent count is in range
> > +file.9 extent count is in range
> > +file.10 extent count is in range
> > +file.11 extent count is in range
> > +file.12 extent count is in range
> > +file.13 extent count is in range
> > +file.14 extent count is in range
> > +file.15 extent count is in range
> > +file.16 extent count is in range
> > +file.17 extent count is in range
> > +file.18 extent count is in range
> > +file.19 extent count is in range
> > +file.20 extent count is in range
> > +file.21 extent count is in range
> > +file.22 extent count is in range
> > +file.23 extent count is in range
> > +file.24 extent count is in range
> > +file.25 extent count is in range
> > +file.26 extent count is in range
> > +file.27 extent count is in range
> > +file.28 extent count is in range
> > +file.29 extent count is in range
> > +file.30 extent count is in range
> > +file.31 extent count is in range
> > -- 
> > 2.45.2
> > 
> > 
> 

