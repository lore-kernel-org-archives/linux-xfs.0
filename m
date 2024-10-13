Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 253B212CDBA
	for <linux-xfs@vger.kernel.org>; Sun, 13 Oct 2024 17:49:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728841791; cv=none; b=WzSsXDjaHiKwjCsIt6EpQRHnb5v9ejPxHzg7eZjlI0lZcbql4iAGlk0nT5rjl+BMJg08IhjTuQP+7Q4YCH23+EpkiaPPmpEsm52bgzG0UQsCplo/GfxC7OaToScb5xJENdy6FgG4aAxu+uMMYSi2vLMPy+hcVEgOTiGH60/0CLo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728841791; c=relaxed/simple;
	bh=0k2v4i9Fzqw8t3vciIoeoRBKi6G25p2RrA8aY+9jbtw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LddgM0+Yfp5ssNU4Gbl0OseEwuCg1OOvSy/fiMzvRy1MhFklKoexCozkLBN27FqFg9lYFhSU5Mm/kGMxZvBCROORws/gFEKk3RoxWhKGoesI39fptTe2r8ZwZdn3KZLWjHQ03e/i3WsBIaGOsA7gOo4UsRzgGN9UjXtY6tTvOLE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fuNjJZ6z; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fuNjJZ6z"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1728841788;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=HfKyqFMqYun44E54/2sEJ/FImhAMQQTIQH7+op6GYmo=;
	b=fuNjJZ6zjgirnF/vdJ/LHQfjDgcgkTzhAWkv5/p0gh2/N4+o9qPUeDnxP5wGJyqutqSxo1
	3QFSK8w1MwrcMt4ldtQuuJ8SOPJGhzBY1sHjs3yiT+m3VLBcx7R88qBraj2EPj/peVQvPk
	XAW39UkwCKjx9boZgOszmi+hKvajMsc=
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com
 [209.85.215.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-513-8iy-MADhNN2FljcYd-M19g-1; Sun, 13 Oct 2024 13:49:44 -0400
X-MC-Unique: 8iy-MADhNN2FljcYd-M19g-1
Received: by mail-pg1-f199.google.com with SMTP id 41be03b00d2f7-6507e2f0615so2640992a12.1
        for <linux-xfs@vger.kernel.org>; Sun, 13 Oct 2024 10:49:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728841783; x=1729446583;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HfKyqFMqYun44E54/2sEJ/FImhAMQQTIQH7+op6GYmo=;
        b=ELfC0XPizvBAcR4lyAYmQSUr9/d1s6NbApE5gruYPuOGJwwUdzcyWLZh2Q6Dy9n/v1
         GyNvC+4ngwoiign0Fks+E4ZdpeivVgWldxvuCrHLZ15QjR2r5BjaVsrm+R6xf0AVkc9i
         069ayFl1MYUEBfFGAx+czJLSx20qed6o392EW/FFieakdqLwD5A1/4sE2GqteEqwZw2R
         bBCn1r9AdVlqepDpfpR5iXcCfYG8W8v3CSrg0V9LWtTs0i8sUN1laVYIm0lAxmMwatYt
         wls8Qw/Sx7cenmcXMCyBLgHmAEfJ9EQ//2WyU1kJMuMK+98tb7QNg8+qUb+WhEpAnnud
         Xa8Q==
X-Forwarded-Encrypted: i=1; AJvYcCXdpAgv/B72nxtp/PE9yF2qwCMjX+PxSleBZBYRPugKDeA4zZqgms36rI9F1HqhkDwmNq4UcrLwGyk=@vger.kernel.org
X-Gm-Message-State: AOJu0YyUjjTmY4MZiOLnI9mU2PkVpBiQnSsUy+MLyEvpOouSMssJaByi
	fDbJu9UaXvPOYgyPUDToID4hsSV7YTq2xHKdqH4I9ZGmHeSKJwhIGuNS07As3u8i8tgKTNY45xy
	NOiDiAApBJ7FYFLOTGNr1yct9ia2b0WRFNOZqwWn/kbjf9/+RQb1VXQLD/Q==
X-Received: by 2002:a17:90a:d792:b0:2c9:df1c:4a58 with SMTP id 98e67ed59e1d1-2e2f0ab9849mr11540384a91.23.1728841783072;
        Sun, 13 Oct 2024 10:49:43 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGeU/A+fR7oExFEUnNC4UXZh1KY2dZigTM72fGAId9+emhvSGSiGtdpaFHtAjqL0kQue8H82A==
X-Received: by 2002:a17:90a:d792:b0:2c9:df1c:4a58 with SMTP id 98e67ed59e1d1-2e2f0ab9849mr11540361a91.23.1728841782402;
        Sun, 13 Oct 2024 10:49:42 -0700 (PDT)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2e2d5fc5e29sm6929494a91.53.2024.10.13.10.49.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 13 Oct 2024 10:49:41 -0700 (PDT)
Date: Mon, 14 Oct 2024 01:49:36 +0800
From: Zorro Lang <zlang@redhat.com>
To: Christoph Hellwig <hch@lst.de>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org,
	fstests@vger.kernel.org
Subject: Re: [PATCH] xfs: new EOF fragmentation tests
Message-ID: <20241013174936.og4m2yopfh26ygwm@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
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

Hi Christoph,

Thanks for reworking this patch, it's been merged into fstests, named
xfs/629~632. But now these 4 cases always fail on upstream xfs, e.g
(diff output) [1][2][3][4]. Could you help to take a look at the
failure which Darick metioned above too :)

Thanks,
Zorro

[1]
--- /dev/fd/63	2024-10-12 03:26:05.854655824 -0400
+++ xfs/629.out.bad	2024-10-12 03:26:05.196658410 -0400
@@ -1,9 +1,17 @@
 QA output created by 629
-file.0 extent count is in range
-file.1 extent count is in range
-file.2 extent count is in range
-file.3 extent count is in range
-file.4 extent count is in range
-file.5 extent count is in range
-file.6 extent count is in range
-file.7 extent count is in range
+file.0 extent count has value of 262
+file.0 extent count is NOT in range 2 .. 40
+file.1 extent count has value of 278
+file.1 extent count is NOT in range 2 .. 40
+file.2 extent count has value of 292
+file.2 extent count is NOT in range 2 .. 40
+file.3 extent count has value of 255
+file.3 extent count is NOT in range 2 .. 40
+file.4 extent count has value of 299
+file.4 extent count is NOT in range 2 .. 40
+file.5 extent count has value of 276
+file.5 extent count is NOT in range 2 .. 40
+file.6 extent count has value of 281
+file.6 extent count is NOT in range 2 .. 40
+file.7 extent count has value of 290
+file.7 extent count is NOT in range 2 .. 40

[2]
--- /dev/fd/63	2024-10-12 03:27:24.685345937 -0400
+++ xfs/630.out.bad	2024-10-12 03:27:24.002348622 -0400
@@ -1,9 +1,17 @@
 QA output created by 630
-file.0 extent count is in range
-file.1 extent count is in range
-file.2 extent count is in range
-file.3 extent count is in range
-file.4 extent count is in range
-file.5 extent count is in range
-file.6 extent count is in range
-file.7 extent count is in range
+file.0 extent count has value of 996
+file.0 extent count is NOT in range 1 .. 10
+file.1 extent count has value of 991
+file.1 extent count is NOT in range 1 .. 10
+file.2 extent count has value of 989
+file.2 extent count is NOT in range 1 .. 10
+file.3 extent count has value of 998
+file.3 extent count is NOT in range 1 .. 10
+file.4 extent count has value of 993
+file.4 extent count is NOT in range 1 .. 10
+file.5 extent count has value of 990
+file.5 extent count is NOT in range 1 .. 10
+file.6 extent count has value of 997
+file.6 extent count is NOT in range 1 .. 10
+file.7 extent count has value of 995
+file.7 extent count is NOT in range 1 .. 10

[3]
--- /dev/fd/63	2024-10-12 03:28:38.598055384 -0400
+++ xfs/631.out.bad	2024-10-12 03:28:37.973057841 -0400
@@ -1,9 +1,17 @@
 QA output created by 631
-file.0 extent count is in range
-file.1 extent count is in range
-file.2 extent count is in range
-file.3 extent count is in range
-file.4 extent count is in range
-file.5 extent count is in range
-file.6 extent count is in range
-file.7 extent count is in range
+file.0 extent count has value of 994
+file.0 extent count is NOT in range 1 .. 10
+file.1 extent count has value of 992
+file.1 extent count is NOT in range 1 .. 10
+file.2 extent count has value of 980
+file.2 extent count is NOT in range 1 .. 10
+file.3 extent count has value of 996
+file.3 extent count is NOT in range 1 .. 10
+file.4 extent count has value of 994
+file.4 extent count is NOT in range 1 .. 10
+file.5 extent count has value of 985
+file.5 extent count is NOT in range 1 .. 10
+file.6 extent count has value of 987
+file.6 extent count is NOT in range 1 .. 10
+file.7 extent count has value of 990
+file.7 extent count is NOT in range 1 .. 10

[4]
--- /dev/fd/63	2024-10-12 03:31:07.166471365 -0400
+++ xfs/632.out.bad	2024-10-12 03:31:06.487474034 -0400
@@ -1,33 +1,65 @@
 QA output created by 632
-file.0 extent count is in range
-file.1 extent count is in range
-file.2 extent count is in range
-file.3 extent count is in range
-file.4 extent count is in range
-file.5 extent count is in range
-file.6 extent count is in range
-file.7 extent count is in range
-file.8 extent count is in range
-file.9 extent count is in range
-file.10 extent count is in range
-file.11 extent count is in range
-file.12 extent count is in range
-file.13 extent count is in range
-file.14 extent count is in range
-file.15 extent count is in range
-file.16 extent count is in range
-file.17 extent count is in range
-file.18 extent count is in range
-file.19 extent count is in range
-file.20 extent count is in range
-file.21 extent count is in range
-file.22 extent count is in range
-file.23 extent count is in range
-file.24 extent count is in range
-file.25 extent count is in range
-file.26 extent count is in range
-file.27 extent count is in range
-file.28 extent count is in range
-file.29 extent count is in range
-file.30 extent count is in range
-file.31 extent count is in range
+file.0 extent count has value of 530
+file.0 extent count is NOT in range 1 .. 16
+file.1 extent count has value of 516
+file.1 extent count is NOT in range 1 .. 16
+file.2 extent count has value of 524
+file.2 extent count is NOT in range 1 .. 16
+file.3 extent count has value of 526
+file.3 extent count is NOT in range 1 .. 16
+file.4 extent count has value of 531
+file.4 extent count is NOT in range 1 .. 16
+file.5 extent count has value of 529
+file.5 extent count is NOT in range 1 .. 16
+file.6 extent count has value of 533
+file.6 extent count is NOT in range 1 .. 16
+file.7 extent count has value of 519
+file.7 extent count is NOT in range 1 .. 16
+file.8 extent count has value of 385
+file.8 extent count is NOT in range 1 .. 16
+file.9 extent count has value of 465
+file.9 extent count is NOT in range 1 .. 16
+file.10 extent count has value of 525
+file.10 extent count is NOT in range 1 .. 16
+file.11 extent count has value of 527
+file.11 extent count is NOT in range 1 .. 16
+file.12 extent count has value of 345
+file.12 extent count is NOT in range 1 .. 16
+file.13 extent count has value of 523
+file.13 extent count is NOT in range 1 .. 16
+file.14 extent count has value of 504
+file.14 extent count is NOT in range 1 .. 16
+file.15 extent count has value of 518
+file.15 extent count is NOT in range 1 .. 16
+file.16 extent count has value of 501
+file.16 extent count is NOT in range 1 .. 16
+file.17 extent count has value of 518
+file.17 extent count is NOT in range 1 .. 16
+file.18 extent count has value of 524
+file.18 extent count is NOT in range 1 .. 16
+file.19 extent count has value of 530
+file.19 extent count is NOT in range 1 .. 16
+file.20 extent count has value of 509
+file.20 extent count is NOT in range 1 .. 16
+file.21 extent count has value of 519
+file.21 extent count is NOT in range 1 .. 16
+file.22 extent count has value of 522
+file.22 extent count is NOT in range 1 .. 16
+file.23 extent count has value of 522
+file.23 extent count is NOT in range 1 .. 16
+file.24 extent count has value of 501
+file.24 extent count is NOT in range 1 .. 16
+file.25 extent count has value of 218
+file.25 extent count is NOT in range 1 .. 16
+file.26 extent count has value of 529
+file.26 extent count is NOT in range 1 .. 16
+file.27 extent count has value of 527
+file.27 extent count is NOT in range 1 .. 16
+file.28 extent count has value of 525
+file.28 extent count is NOT in range 1 .. 16
+file.29 extent count has value of 545
+file.29 extent count is NOT in range 1 .. 16
+file.30 extent count has value of 527
+file.30 extent count is NOT in range 1 .. 16
+file.31 extent count has value of 519
+file.31 extent count is NOT in range 1 .. 16

> 
> I'm not sure why this happens, but it probably needs to be looked at
> along with all the FALLOC_FL_UNSHARE_RANGE brokenness that's also been
> exposed by fstests that /does/ need to be fixed.
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

