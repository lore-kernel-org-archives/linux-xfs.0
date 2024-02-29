Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2AD736124
	for <linux-xfs@vger.kernel.org>; Thu, 29 Feb 2024 01:55:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709171731; cv=none; b=bhNkIG0hNWTPYTrr0nrEg3H7UJyPm8Ma0K4NbatMYmY6ICTHdPyEmwfWImaqzTIWtkcRsyAUlNvdHvC4CJ0XTBSlJAegrumQFgqWzyK+oygCNFkDYq4jtt8QoKfbZc+YRQRasJsaiEbvOnuAQxiL2lSy2wt8Mh8KXvGmBdbgK+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709171731; c=relaxed/simple;
	bh=emvYB5CJurEAyFu0hm/qpLWACXac98pyJYfaRTG1gjo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Xuhbj4hVdk/WZ/onkdKpypxHG7djE3SFfdgIfOTRjZi4GugKKqRB9bLn9PoaJ+bqL9peF4zxZZiEQn5N/IheJIxYpuMR8iJPmDBNSpuVzMTPERPttSEqRsUDVq51fkYGiRH35Q2CspCuQtA9iNh2qYDCB2NSmy92INE/Pj8pTuE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=A6vIc1hh; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="A6vIc1hh"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709171728;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=gxnW9HDt+CaNup2eDRfP2FTFCcnw5N8wNRgLXcxv9rY=;
	b=A6vIc1hhgnTpo46hMaUWHnxrwBkFkMZUGChuzYnrugHqLNLmT4ydPlt0eqRuIXT4046hVB
	9n3JapYvRB0K1OydGvTtSQJaPdTa+4lWKQty5hvt+I+sdzVQCiFemHU2ObRt/firn7q30M
	eV0AA5rJ3Cq8ddwNUCcDD1wUCywwvtM=
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com
 [209.85.215.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-543-mzQPWg4oMnqKltUFbngfsA-1; Wed, 28 Feb 2024 20:55:26 -0500
X-MC-Unique: mzQPWg4oMnqKltUFbngfsA-1
Received: by mail-pg1-f199.google.com with SMTP id 41be03b00d2f7-5d8bdadc79cso305166a12.2
        for <linux-xfs@vger.kernel.org>; Wed, 28 Feb 2024 17:55:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709171726; x=1709776526;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gxnW9HDt+CaNup2eDRfP2FTFCcnw5N8wNRgLXcxv9rY=;
        b=SI41vIGhDx9eVVo/CdtBU9+G+1xHKi07gcbAtRjQRVr4Y2Hk21EiUfrUf7tZTppmqO
         Crhp9xU9tUDZQAqo0UltH4T6kCwdwJ3SQdtvshz13qCJjW1HExmInRlNDSqbFzQSOntD
         vPxXnFS9BbPWdiQOHxTlHrPose2uQj9ZNTKgsOMlTlykGv3zsFmkMdq3QSO5wbTWItIL
         1S9P0+d73cZO3aSAZhz0cNjOnfhwnrKMJlXX+wDUpY2e//NGI72LhSZToYrfkFicuJeR
         MXAEL6OJ2KFAmF/jcvMhy5QZtcAdhD0hG08Xy3T5jMJ/S11Qr0IPNgywoW9onF2SMG9N
         lCMQ==
X-Forwarded-Encrypted: i=1; AJvYcCUO5jtlgpIG1wZ3YORRjhpyC+2fGwH/2JTvn1bre4HEZP4ym2gJ2HYEjg8jnuwo1SLWtospOOtwQqJe5A7ihb3rVzc9reo6l9OF
X-Gm-Message-State: AOJu0Yx2PdxOXokCGuwiV/XVg+w+fsWtB01fGSS4GCF03DTw91DBD6TK
	XArT0de4VXb62O0/ujOwH4yQccP90oAI5JhQIPZhB22xy+MYpjlN4lQXKbiz4Yv3GIfd/87YNuu
	caaBWA2EhWXAwW/4ScRviTE+xPUrGSBNU93jRDmHunGbkJHLNpGQG9JFflkLpG2fOrYza
X-Received: by 2002:a05:6a21:3a4a:b0:1a1:278f:8254 with SMTP id zu10-20020a056a213a4a00b001a1278f8254mr907932pzb.14.1709171725710;
        Wed, 28 Feb 2024 17:55:25 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHevT2f1ehUe1p+0WrWrM2elNHpmYowMPKpPLvjkjW1Kb6dbIYN+CkWk6gHj/voY4m3AHRD7Q==
X-Received: by 2002:a05:6a21:3a4a:b0:1a1:278f:8254 with SMTP id zu10-20020a056a213a4a00b001a1278f8254mr907917pzb.14.1709171725330;
        Wed, 28 Feb 2024 17:55:25 -0800 (PST)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id q7-20020a17090311c700b001dcc18e1c10sm120476plh.174.2024.02.28.17.55.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Feb 2024 17:55:25 -0800 (PST)
Date: Thu, 29 Feb 2024 09:55:21 +0800
From: Zorro Lang <zlang@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org,
	Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] generic: check logical-sector sized O_DIRECT
Message-ID: <20240229015521.yuof45wulkneq5ij@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <20221107045618.2772009-1-zlang@kernel.org>
 <20240228155929.GD1927156@frogsfrogsfrogs>
 <20240229005218.pwgakn5x3fwwcjnj@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
 <20240229014140.GU6226@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240229014140.GU6226@frogsfrogsfrogs>

On Wed, Feb 28, 2024 at 05:41:40PM -0800, Darrick J. Wong wrote:
> On Thu, Feb 29, 2024 at 08:52:18AM +0800, Zorro Lang wrote:
> > On Wed, Feb 28, 2024 at 07:59:29AM -0800, Darrick J. Wong wrote:
> > > On Mon, Nov 07, 2022 at 12:56:18PM +0800, Zorro Lang wrote:
> > > > If the physical sector size is 4096, but the logical sector size
> > > > is 512, the 512b dio write/read should be allowed.
> > > 
> > > Huh, did we all completely forget to review this patch?
> > 
> > Hmm?? This patch has been reviewed and merged in 2022, refer to g/704.
> > Why did it appear (be refreshed) at here suddenly ?
> 
> Doh!
> 
> Sorry, I saw this patch sitting by itself with no replies or "Hey I
> merged this" messages and thought we'd forgotten it.

Thanks for taking care this test :)

There was a RVB for this patch:
https://lore.kernel.org/fstests/20221107105309.khksga5m7p766sed@aalbersh.remote.csb/

This remind me that I still have some patches in my local branch, they were
not merged by some reasons. I'll check if some of them are suitable for now :)

Thanks,
Zorro

> 
> And if it's running without problems (I haven't seen any in generic/704)
> then I'll leave well enough alone.
> 
> --D
> 
> > > 
> > > > Signed-off-by: Zorro Lang <zlang@kernel.org>
> > > > ---
> > > > 
> > > > Hi,
> > > > 
> > > > This reproducer was written for xfs, I try to make it to be a generic
> > > > test case for localfs. Current it test passed on xfs, extN and btrfs,
> > > > the bug can be reproduced on old rhel-6.6 [1]. If it's not right for
> > > > someone fs, please feel free to tell me.
> > > > 
> > > > Thanks,
> > > > Zorro
> > > > 
> > > > [1]
> > > > # ./check generic/888
> > > > FSTYP         -- xfs (non-debug)
> > > > PLATFORM      -- Linux/x86_64 xxx-xxxxx-xxxxxx 2.6.32-504.el6.x86_64
> > > > MKFS_OPTIONS  -- -f -bsize=4096 /dev/loop1
> > > > MOUNT_OPTIONS -- -o context=system_u:object_r:nfs_t:s0 /dev/loop1 /mnt/scratch
> > > > 
> > > > generic/888      - output mismatch (see /root/xfstests-dev/results//generic/888.out.bad)
> > > >     --- tests/generic/888.out   2022-11-06 23:42:44.683040977 -0500
> > > >     +++ /root/xfstests-dev/results//generic/888.out.bad 2022-11-06 23:48:33.986481844 -0500
> > > >     @@ -4,3 +4,4 @@
> > > >      512
> > > >      mkfs and mount
> > > >      DIO read/write 512 bytes
> > > >     +pwrite64: Invalid argument
> > > >     ...
> > > >     (Run 'diff -u tests/generic/888.out /root/xfstests-dev/results//generic/888.out.bad'  to see the entire diff)
> > > > Ran: generic/888
> > > > Failures: generic/888
> > > > Failed 1 of 1 tests
> > > > 
> > > >  tests/generic/888     | 52 +++++++++++++++++++++++++++++++++++++++++++
> > > >  tests/generic/888.out |  6 +++++
> > > >  2 files changed, 58 insertions(+)
> > > >  create mode 100755 tests/generic/888
> > > >  create mode 100644 tests/generic/888.out
> > > > 
> > > > diff --git a/tests/generic/888 b/tests/generic/888
> > > > new file mode 100755
> > > > index 00000000..b5075d1e
> > > > --- /dev/null
> > > > +++ b/tests/generic/888
> > > > @@ -0,0 +1,52 @@
> > > > +#! /bin/bash
> > > > +# SPDX-License-Identifier: GPL-2.0
> > > > +# Copyright (c) 2022 Red Hat, Inc.  All Rights Reserved.
> > > > +#
> > > > +# FS QA Test No. 888
> > > > +#
> > > > +# Make sure logical-sector sized O_DIRECT write is allowed
> > > > +#
> > > > +. ./common/preamble
> > > > +_begin_fstest auto quick
> > > > +
> > > > +# Override the default cleanup function.
> > > > +_cleanup()
> > > > +{
> > > > +	cd /
> > > > +	rm -r -f $tmp.*
> > > > +	[ -d "$SCSI_DEBUG_MNT" ] && $UMOUNT_PROG $SCSI_DEBUG_MNT 2>/dev/null
> > > > +	_put_scsi_debug_dev
> > > > +}
> > > > +
> > > > +# Import common functions.
> > > > +. ./common/scsi_debug
> > > > +
> > > > +# real QA test starts here
> > > > +_supported_fs generic
> > > > +_fixed_by_kernel_commit 7c71ee78031c "xfs: allow logical-sector sized O_DIRECT"
> > > > +_require_scsi_debug
> > > > +# If TEST_DEV is block device, make sure current fs is a localfs which can be
> > > > +# written on scsi_debug device
> > > > +_require_test
> > > > +_require_block_device $TEST_DEV
> > > 
> > > _require_odirect?
> > > 
> > > > +
> > > > +echo "Get a device with 4096 physical sector size and 512 logical sector size"
> > > > +SCSI_DEBUG_DEV=`_get_scsi_debug_dev 4096 512 0 256`
> > > > +blockdev --getpbsz --getss $SCSI_DEBUG_DEV
> > > > +
> > > > +echo "mkfs and mount"
> > > > +_mkfs_dev $SCSI_DEBUG_DEV || _fail "Can't make $FSTYP on scsi_debug device"
> > > > +SCSI_DEBUG_MNT="$TEST_DIR/scsi_debug_$seq"
> > > > +rm -rf $SCSI_DEBUG_MNT
> > > > +mkdir $SCSI_DEBUG_MNT
> > > > +run_check _mount $SCSI_DEBUG_DEV $SCSI_DEBUG_MNT
> > > 
> > > /me wonders, should we try to use $MKFS_OPTIONS and $MOUNT_OPTIONS
> > > on the scsidebug device?  To catch cases where the config actually
> > > matters for that kind of thing?
> > 
> > It's been merged, if we need to change something, better to send a new
> > patch to change that :)
> > 
> > Thanks,
> > Zorro
> > 
> > > 
> > > --D
> > > 
> > > > +
> > > > +echo "DIO read/write 512 bytes"
> > > > +# This dio write should succeed, even the physical sector size is 4096, but
> > > > +# the logical sector size is 512
> > > > +$XFS_IO_PROG -d -f -c "pwrite 0 512" $SCSI_DEBUG_MNT/testfile >> $seqres.full
> > > > +$XFS_IO_PROG -d -c "pread 0 512" $SCSI_DEBUG_MNT/testfile >> $seqres.full
> > > > +
> > > > +# success, all done
> > > > +status=0
> > > > +exit
> > > > diff --git a/tests/generic/888.out b/tests/generic/888.out
> > > > new file mode 100644
> > > > index 00000000..0f142ce9
> > > > --- /dev/null
> > > > +++ b/tests/generic/888.out
> > > > @@ -0,0 +1,6 @@
> > > > +QA output created by 888
> > > > +Get a device with 4096 physical sector size and 512 logical sector size
> > > > +4096
> > > > +512
> > > > +mkfs and mount
> > > > +DIO read/write 512 bytes
> > > > -- 
> > > > 2.31.1
> > > > 
> > > 
> > 
> 

