Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 797B81386C9
	for <linux-xfs@vger.kernel.org>; Sat,  1 Nov 2025 09:00:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761987657; cv=none; b=mA7GfwCEnosVz3pfyeI6t54EypvnFaeiej7EC07W72GylvpCWNJyjvFHpHdTsYcCkNgOodKpD0IEMLCmJ8YvhJ/HQtUIZzEthSetOsaBwLd84HOGfLok5I1ufhm+zHAz9gjh+p01bb80dDE7HlMrQ/ok9TVzh57yMjVsKEUBgDE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761987657; c=relaxed/simple;
	bh=erZlZwmG67hxS99lC1J1OI9uGWwNY/GeBgK/oj0OKmY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MYpa/FNn/vqXmfwY9Ah9Welsf2nGIxDo0e0GmMrtA5TM2bF6NZ8ePZgep6Oc5/E1Ngf5yHclnVdfX1PVDkCTh5WtQs1THgOkcD9bNnMk/DKxyZkeMD7WEer04bN/HUDLRUXGmC3BiHD/NlTo0rHFwLuj9drvLTDTZNNojy7GgGk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=QOxlWDC+; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=NRbJCSqQ; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QOxlWDC+";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="NRbJCSqQ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761987654;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Zn+afpMdtbihpSuxES9QlBr4zxqcZucnzgZEXoXLmqk=;
	b=QOxlWDC++ObgYSZE2dTbnz5Mz0ZbAeAdEvaJe9KulIU1P4YB5EwzJVsOPGf0GlvA8Y9T0o
	2P7Oq8Vu/5DMbI33iQhIvH+Q1lQOOmxy+Xb69GPptKrsiTurvS1xvmzWoEzshB4r3YMfiI
	RQgegRBT8le00IDf8BBL18R5I0UFBAo=
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com
 [209.85.214.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-628-Au4-Q1Z7OkGbaZhwBQWMcw-1; Sat, 01 Nov 2025 05:00:53 -0400
X-MC-Unique: Au4-Q1Z7OkGbaZhwBQWMcw-1
X-Mimecast-MFC-AGG-ID: Au4-Q1Z7OkGbaZhwBQWMcw_1761987652
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-29523ed27e0so16998885ad.1
        for <linux-xfs@vger.kernel.org>; Sat, 01 Nov 2025 02:00:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1761987652; x=1762592452; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Zn+afpMdtbihpSuxES9QlBr4zxqcZucnzgZEXoXLmqk=;
        b=NRbJCSqQQXUPBQ0iXpNW1IZFzPSBYqEWgTwNy13GYi4JhUroSU5WJfavmTkLdX+P3v
         iCDTzzfGSEx4vHRQZEQoFD7P5WsHJ+TE7iWddX61c0eWZV3iU2pTL5eKMqj4hDGqUMhJ
         yF3iQFVWdQSal6IXUBKogqSSOL7mAgq7PC4sf9n01XU+/Jwi8uNms1L0qykgFHE2fsNy
         O1xUiWLrm8mbsD11ioq5cvYeSq6GYfM/D4gLDJPssFuFwL7mkrdYpchlTJv0ONlRFw02
         GywJbdYvTJ2IAPZCwp22xAGYgcKD7JzTSIc/YMD1XJlgkslwMWDUbv1eYywMQiG7Wsux
         XHnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761987652; x=1762592452;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Zn+afpMdtbihpSuxES9QlBr4zxqcZucnzgZEXoXLmqk=;
        b=BD+oBGsAJa/VGdBGSYg4wet5tBNgRCtEM4pC8K0kIOnuLKDitq/j4SRxP59q//RaKe
         Geojlhy22wUpVuRcsU9gEwI6Z02iYEtvudtNUZhljcsjBNEfQpWaXYVGDBEkQcIZeUqq
         WfeTL2O4DjvQNdj6WdLJAJbloOFb9mTa72dS4S/MrHaqhhh5lxYSyo/74eUsScNwfHl9
         nHONQk7D5gWQH9TenWYOzAuKbsDB5tb+33Vu124VIeag28YG+DQrGkGPiMOzQcMVSDYs
         Q9cWbwWMmcNlWV/hx0+NqrPGC7W0bg3Dev/hxUH4cqQ188MBTbwMHMcCZU52dyDtd1M2
         ekPw==
X-Forwarded-Encrypted: i=1; AJvYcCX3ooC0NJ+STIIUIh47mZ4owe7HmYz3+oycmEMsd07buumyGmPC97/Rf9NfUtFlh4+l2l5d92nr7ws=@vger.kernel.org
X-Gm-Message-State: AOJu0YwUsbQm5/xcq+6FGFEFCjcfMIrqTHn5LBAZuMcoQcLiVFdXWshx
	MywV84DXcOqgWUTQUxJoSSJD8WzgfYYFVG3Tew/EY0Ud2IgbeO2kugz2Qs8EMAf6rfmcKGL8Vgp
	UPRIiekmzM3eYqiIiBnd4QA1HBtgL+LyVrLFZlKBbvIdmB6xnRikqUBUFF2Z3Hg==
X-Gm-Gg: ASbGncsiOxVGBiZfXO0OXKCPfp/tag0FuDoPHEewmvUZ+gZxm9r2tCpfJl9TgaqVDXT
	P/qF0Jo7ockLoYilsqKfrByMlEfa4J3VG0LCFHoAbeV3cSaHrM33xO4UlYbGsWuuyKcUqGud6JW
	0JvR3EaPUnx1XGV/1FLwsE3LPRkZ0P/fxcbPwU1VX38XdN7+gjEJpYB5cBgwTUHI7P4c0jhEN2k
	54WzumITsMLPb6GpSmR92UBlMS51H59QwjZltt/8YEhH0uajG6fIF+dmJKi8N5QFgbr/++Z79rz
	DKOoXehA8c/VrFrAFvWB5b1lL6oqFCJ+jOLvAMHmscc+CwpVAzeHDUPDKgNWeL84HiTpMfy/th2
	+3jSFd7QXDfqc6BzL80Gz5lLhJWvD5u48DHdL4ZA=
X-Received: by 2002:a17:902:c401:b0:295:595c:d002 with SMTP id d9443c01a7336-295595cd1bamr11607085ad.15.1761987647772;
        Sat, 01 Nov 2025 02:00:47 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFWfYSpqPPKZTWZUIuCP9sZI3ZFUiApsjI7S0Dmb+QGZeLsda0a9cQgrC17lhu6wzKpF6jaeg==
X-Received: by 2002:a17:902:c401:b0:295:595c:d002 with SMTP id d9443c01a7336-295595cd1bamr11606135ad.15.1761987646798;
        Sat, 01 Nov 2025 02:00:46 -0700 (PDT)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([209.132.188.88])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29556d61c4dsm16365525ad.56.2025.11.01.02.00.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 01 Nov 2025 02:00:46 -0700 (PDT)
Date: Sat, 1 Nov 2025 17:00:40 +0800
From: Zorro Lang <zlang@redhat.com>
To: Ojaswin Mujoo <ojaswin@linux.ibm.com>
Cc: fstests@vger.kernel.org, Ritesh Harjani <ritesh.list@gmail.com>,
	djwong@kernel.org, john.g.garry@oracle.com, tytso@mit.edu,
	linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org
Subject: Re: [PATCH v7 05/12] generic: Add atomic write test using fio crc
 check verifier
Message-ID: <20251101090040.6ukcaal2c55ka7wy@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <cover.1758264169.git.ojaswin@linux.ibm.com>
 <3c034b2fb5b81b3a043f1851f3905ce6a41c827a.1758264169.git.ojaswin@linux.ibm.com>
 <aQCQFOtjhyzohgnA@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aQCQFOtjhyzohgnA@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>

On Tue, Oct 28, 2025 at 03:12:44PM +0530, Ojaswin Mujoo wrote:
> On Fri, Sep 19, 2025 at 12:17:58PM +0530, Ojaswin Mujoo wrote:
> > This adds atomic write test using fio based on it's crc check verifier.
> > fio adds a crc header for each data block, which is verified later to
> > ensure there is no data corruption or torn write.
> > 
> > This test essentially does a lot of parallel RWF_ATOMIC IO on a
> > preallocated file to stress the write and end-io unwritten conversion
> > code paths. The idea is to increase code coverage to ensure RWF_ATOMIC
> > hasn't introduced any issues.
> > 
> > Avoid doing overlapping parallel atomic writes because it might give
> > unexpected results. Use offset_increment=, size= fio options to achieve
> > this behavior.
> > 
> > Co-developed-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
> > Signed-off-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
> > Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> > Reviewed-by: John Garry <john.g.garry@oracle.com>
> > Signed-off-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>
> > ---
> >  tests/generic/1226     | 108 +++++++++++++++++++++++++++++++++++++++++
> >  tests/generic/1226.out |   2 +
> >  2 files changed, 110 insertions(+)
> >  create mode 100755 tests/generic/1226
> >  create mode 100644 tests/generic/1226.out
> > 
> > diff --git a/tests/generic/1226 b/tests/generic/1226
> > new file mode 100755
> > index 00000000..7ad74554
> > --- /dev/null
> > +++ b/tests/generic/1226
> > @@ -0,0 +1,108 @@
> > +#! /bin/bash
> > +# SPDX-License-Identifier: GPL-2.0
> > +# Copyright (c) 2025 IBM Corporation. All Rights Reserved.
> > +#
> > +# FS QA Test 1226
> 
> Hey Zorro,
> 
> Thanks for picking these in for-next. I just noticed that the test
> number for this test has become 773, but we missed changing:
> 
>  # FS QA Test 1226
> 
>  to
> 
>  # FS QA Test 773

Hmm...weird, I change the case number by running `./tools/mvtest generic/1226 generic/773`.
The "FS QA Test 1226" should be changed to "FS QA Test No. 773" by:

  sed -e "s/^# FS[[:space:]]*QA.*Test.*[0-9]\+$/# FS QA Test No. ${did}/g" -i "tests/${dest}"

I'm not sure what happened at that time, I'll check if there're more "wrong number" issues,
will correct them in one patch. Thanks for reporting:)

Thanks,
Zorro

> 
> 
> Commit: https://git.kernel.org/pub/scm/fs/xfs/xfstests-dev.git/commit/?h=for-next&id=1499d4ff2365803e97af3279ba3312bba2cc9a80
> 
> Regards,
> Ojaswin
> 
> > +#
> > +# Validate FS atomic write using fio crc check verifier.
> > +#
> > +. ./common/preamble
> > +. ./common/atomicwrites
> > +
> > +_begin_fstest auto aio rw atomicwrites
> > +
> > +_require_scratch_write_atomic
> > +_require_odirect
> > +_require_aio
> > +_require_fio_atomic_writes
> > +
> > +_scratch_mkfs >> $seqres.full 2>&1
> > +_scratch_mount
> > +_require_xfs_io_command "falloc"
> > +
> > +touch "$SCRATCH_MNT/f1"
> > +awu_min_write=$(_get_atomic_write_unit_min "$SCRATCH_MNT/f1")
> > +awu_max_write=$(_get_atomic_write_unit_max "$SCRATCH_MNT/f1")
> > +
> > +blocksize=$(_max "$awu_min_write" "$((awu_max_write/2))")
> > +threads=$(_min "$(($(nproc) * 2 * LOAD_FACTOR))" "100")
> > +filesize=$((blocksize * threads * 100))
> > +depth=$threads
> > +io_size=$((filesize / threads))
> > +io_inc=$io_size
> > +testfile=$SCRATCH_MNT/test-file
> > +
> > +fio_config=$tmp.fio
> > +fio_out=$tmp.fio.out
> > +
> > +fio_aw_config=$tmp.aw.fio
> > +fio_verify_config=$tmp.verify.fio
> > +
> > +function create_fio_configs()
> > +{
> > +	create_fio_aw_config
> > +	create_fio_verify_config
> > +}
> > +
> > +function create_fio_verify_config()
> > +{
> > +cat >$fio_verify_config <<EOF
> > +	[verify-job]
> > +	direct=1
> > +	ioengine=libaio
> > +	rw=read
> > +	bs=$blocksize
> > +	filename=$testfile
> > +	size=$filesize
> > +	iodepth=$depth
> > +	group_reporting=1
> > +
> > +	verify_only=1
> > +	verify=crc32c
> > +	verify_fatal=1
> > +	verify_state_save=0
> > +	verify_write_sequence=0
> > +EOF
> > +}
> > +
> > +function create_fio_aw_config()
> > +{
> > +cat >$fio_aw_config <<EOF
> > +	[atomicwrite-job]
> > +	direct=1
> > +	ioengine=libaio
> > +	rw=randwrite
> > +	bs=$blocksize
> > +	filename=$testfile
> > +	size=$io_inc
> > +	offset_increment=$io_inc
> > +	iodepth=$depth
> > +	numjobs=$threads
> > +	group_reporting=1
> > +	atomic=1
> > +
> > +	verify_state_save=0
> > +	verify=crc32c
> > +	do_verify=0
> > +EOF
> > +}
> > +
> > +create_fio_configs
> > +_require_fio $fio_aw_config
> > +
> > +cat $fio_aw_config >> $seqres.full
> > +cat $fio_verify_config >> $seqres.full
> > +
> > +$XFS_IO_PROG -fc "falloc 0 $filesize" $testfile >> $seqres.full
> > +
> > +$FIO_PROG $fio_aw_config >> $seqres.full
> > +ret1=$?
> > +$FIO_PROG $fio_verify_config >> $seqres.full
> > +ret2=$?
> > +
> > +[[ $ret1 -eq 0 && $ret2 -eq 0 ]] || _fail "fio with atomic write failed"
> > +
> > +# success, all done
> > +echo Silence is golden
> > +status=0
> > +exit
> > diff --git a/tests/generic/1226.out b/tests/generic/1226.out
> > new file mode 100644
> > index 00000000..6dce0ea5
> > --- /dev/null
> > +++ b/tests/generic/1226.out
> > @@ -0,0 +1,2 @@
> > +QA output created by 1226
> > +Silence is golden
> > -- 
> > 2.49.0
> > 
> 

