Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC310322B
	for <linux-xfs@vger.kernel.org>; Thu, 26 Sep 2024 12:31:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727353883; cv=none; b=ZMsLuKleGJ+LP5js6ZnbwcBjBviePziXt9EeawtIQ6ZCIOq9a4q7oJ0AbL5U41QX20Thtg/PUGjVROmGvZ+JaOTdM1t5svlOuT28D0RmBzhJPYQvRsXXy/4CC26+oB+J70l1MHz0n+W52dG3lAkHLQ02DM4pYxko3X1SQoGIXY8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727353883; c=relaxed/simple;
	bh=L9MKsTm1lwDbzxn/KI265r3z+uMSi6FqDmHksz3+Fiw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gVTdZtqVDeHVVGbY+7U47psw0hqs1Qc29jF2aMrKHuk9+oUKw0Tw8J1nToJ5BLPsEgNdITX1eYz/HpTCmhtzgy/neEHeqngoBbUObMt/xcp5Uji84AmD9suCt7vAm7ijoFFEABymsvB3AQek9IXgmNPaSeMhOGpG8MR4ExlSs+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=AYqdE6/R; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="AYqdE6/R"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1727353880;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=3A7QxA4FlFf9/86Y9wF2lJ+L+lYXFrcfRRsDryos7sY=;
	b=AYqdE6/RyWUUC4d6YTTHF+GLsaL2sovfVtQrnMRs5QiIB6c5XctCcH75R8HhuzDcgSpKkF
	UShZALrc6XxGu10OTjXp7chxiN2yPvE2TeaC9Nh6Pk0cPppNq0O5/MYVwnrxunrEOIZj96
	glDp0TverAo9PPZK8qWt9IF0BfpckTo=
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-556-9IL_1J-mM_i02gkllUCTjA-1; Thu, 26 Sep 2024 08:31:18 -0400
X-MC-Unique: 9IL_1J-mM_i02gkllUCTjA-1
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-20afe0063e0so8834575ad.3
        for <linux-xfs@vger.kernel.org>; Thu, 26 Sep 2024 05:31:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727353877; x=1727958677;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3A7QxA4FlFf9/86Y9wF2lJ+L+lYXFrcfRRsDryos7sY=;
        b=UOKNtd2xJz2cqpweVJGrdNA7chBkxxn3hxZ5KdvJ5blxahivPps+wcr5oMNtvPUf4i
         nUJZW91hklEt80BNK1zP1wSLel3adqlGv7PRAvG+ZlSDUDFhjfte1mWr7T9xyeEwOczv
         9FtzFLsal/OZR1FvAvMHz/3zmyQmk4+Dw0F87AvmwLGvtbux+wMv7GS4S5KNdJLNgm0L
         Wz5p+xc/WOf8smaEV40lc39m0ffKXAmglR80wmVwrdJAcxN4oA9t3pB+CxKfnIXZe1ha
         CgXW3BKAPA4qKNE1W237w1omaE0K2V7MjZMHRrkfBA8AQr24KA8PnVWFZpuruR9Ox5xk
         PohQ==
X-Forwarded-Encrypted: i=1; AJvYcCXH7+7zsSH3zh9m8/1sTG8CqsLscMVd4c5jvZ9l6v0JfTryTbJTKtZxp1D9249HBh2N7EjU3O5RoYc=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy+KH7MpyHmFvaGjdLklNMzrj7qfPBL+1LFTflMtW8GlHGRzVFU
	2YNrbng4TTm5F1O7G/Muro+DEQ7VaclHQs8hAZlxUNP2JUkijlAi11nkY6a57G3E3jUyVpKGE3M
	5xIQuz4MPyEjk/vW9tuYcomjXACpJxJ966QFPwBZ/oGWunu69XsTjiTT+YKZz4FpdLNff
X-Received: by 2002:a17:902:f543:b0:205:866d:174f with SMTP id d9443c01a7336-20afc4db6e7mr79757635ad.44.1727353875695;
        Thu, 26 Sep 2024 05:31:15 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IERgA0VnzJvHRfyM60gUBuD/ADOhXl3fJPpLGcilydEiRb1/ZudTmgIhzhoXIuMQDkPvG1Q1A==
X-Received: by 2002:a17:902:f543:b0:205:866d:174f with SMTP id d9443c01a7336-20afc4db6e7mr79757235ad.44.1727353875201;
        Thu, 26 Sep 2024 05:31:15 -0700 (PDT)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-20b23673e95sm9008225ad.112.2024.09.26.05.31.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Sep 2024 05:31:14 -0700 (PDT)
Date: Thu, 26 Sep 2024 20:31:11 +0800
From: Zorro Lang <zlang@redhat.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Zorro Lang <zlang@kernel.org>, "Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org,
	fstests@vger.kernel.org
Subject: Re: [PATCH] xfs: new EOF fragmentation tests
Message-ID: <20240926123111.cpun67hpeqp32ivy@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <20240924084551.1802795-1-hch@lst.de>
 <20240924084551.1802795-2-hch@lst.de>
 <20240925111532.me7szmoqedt7ta63@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240925111532.me7szmoqedt7ta63@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>

On Wed, Sep 25, 2024 at 07:15:32PM +0800, Zorro Lang wrote:
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
> 
> This patch looks good to me, just a few nit-picking below...
> 
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

Above two lines are not necessary.
(same for other cases)

> > +
> > +_require_scratch
> > +
> > +_cleanup()
> > +{
> > +	# try to kill all background processes
> 
> I didn't see "kill" below, maybe "wait all background processes done"? Or you'd
> like to use "kill" but forgot? If you don't want to use "kill", please tell me,
> then I'll help to change the comment when I merge it.
> 
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
> > +#
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
> 
> Hmm, "rm -f $XXX*", but looks like the $workdfile doesn't have chance to be
> null :) Maybe rm -f $workfile.* is safer, as all test files are $workfile.$idx
> or $workfile.$n. I can do this change when I merge it.
> 
> Thanks,
> Zorro
> 
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

_require_xfs_io_command "extsize"

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

_count_extents uses fiemap command, so maybe:

_require_xfs_io_command "fiemap"

> > +	# Acceptible extent count range is 1-10
> > +	_within_tolerance "file.$n extent count" $count 2 1 8 -v
> > +done
> > +
> > +status=0
> > +exit

[snap]

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

What's the $(( )) for?

Thanks,
Zorro

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

