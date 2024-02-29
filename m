Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FDA17B3C5
	for <linux-xfs@vger.kernel.org>; Thu, 29 Feb 2024 11:40:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709206808; cv=none; b=B/k6xz4MUA16eEwMLc5U+J9aQymLuDwGPnev8/pJxDSEjXhTxEs22Qk8Spve1xgea15dA6nymilOxYvbtWX+ph7cuW5zkc7iiSnZpoGplH7eHolThRO2et9RrxnXnJQl3N25szmrtCLRZGLhnkixwMZVIl7rl6SqpYoIwA4y0Ks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709206808; c=relaxed/simple;
	bh=Vr4XqUeTB3QMdPUr91fnbjV2uoHjfAzfzJlB0dlzj2o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Z/wrMWmqPoa3H8EuBOjYI8XCmbTu/m/TsgvidRvFMEEy1Dh2shPMhoIwaavK7I+BL5BzS94xVW4lTRzj6Sljvx3ytRcwYU1MHbwM641BMgcQ/EMTbvs05rVnR+RCLbQ+MRsp4B2QgWA4drpq/D5IguBzrrYQ63QTcl5SVKUbFWo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Pa4IcbfE; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Pa4IcbfE"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709206804;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=13GnZXU0qbANNRDEiYRIXhFGscFc23PREgerHpFd+fM=;
	b=Pa4IcbfEpuPWw4HgM1P4tAQ5Ybpqv0ZjQdEugDuCprxyv1CJUlQ9G9ZNxO9acLObXu4C3t
	he38EsKq9PYJnOXdT4Mi5TBXVmEbnbG2gWMxHuHGIBsizbrYsrFCeyi305pZhVP4hqynyR
	69mEl/oLu5X9JlXAp4XHLKujFC/IJew=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-372-AvoZV3OBM5KLAWvOe2P98w-1; Thu, 29 Feb 2024 06:40:02 -0500
X-MC-Unique: AvoZV3OBM5KLAWvOe2P98w-1
Received: by mail-ed1-f69.google.com with SMTP id 4fb4d7f45d1cf-566aa1c194bso270632a12.2
        for <linux-xfs@vger.kernel.org>; Thu, 29 Feb 2024 03:40:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709206801; x=1709811601;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=13GnZXU0qbANNRDEiYRIXhFGscFc23PREgerHpFd+fM=;
        b=HCb+inzLZA46Uf2BPEgSyzYg1bOG+3JHBwHRBzosFVb40QKKXIu4GO+KD9weW/lF+p
         UEUQ1ZhQthyg3YYwxxueXbMs0nsBlEPIH/rrIIgp7SG2Tzr4cUPCMy8lhK9bzJp9uzaM
         gAdKAeitf0I7Z0hjMnqv55TFzvRcHpQ61PIyGVjQD1D91TZCDi2W53VJPDiBTmRK/otl
         Xdw0n8IT4djy1GTODhb7X7Rsgoyh6Wj1E1QAS4jAWgWHy6qQ4bxhqXwCZoMcnzrszbVG
         VlvQO8rbDdDDmqVLTRYdWmVelR8WCyZBpbCiYDjjlrTjMq2rPlSZ6VsBnLxYjpfx4yRA
         f4XQ==
X-Forwarded-Encrypted: i=1; AJvYcCUdNxJ/mQwmiG1OIg9FZo8ITo5LvvqSbk53NXTLz1eLT9Lzr/FSAbsG77C5OHbm6jj5AO+Wf46P0xShGjYYLMN71hib51htXhkv
X-Gm-Message-State: AOJu0Ywzr6gsJ5nbyt3d9z64qTA3UaBaHsDlVMQNDcJSOgsGFSkyc7SL
	j+rFEsEBH+0mxSg//P/he0Wn+ViUrYde9AXBD3abxy4cKqev2Xz2l4lkUUQR0EMyhVBJZvRujH2
	3TzZ7L80rw9ij3SgiiMPOPPEZhcUVnrCslTrr4APeSnCIy257hP2sp46u
X-Received: by 2002:a05:6402:5247:b0:566:a44d:c642 with SMTP id t7-20020a056402524700b00566a44dc642mr1084465edd.15.1709206801460;
        Thu, 29 Feb 2024 03:40:01 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFJkYHFAWvLdcumzwYhhjCC6QYC9n2jJDV5utuSTJf29rD4f2IvH8bD+Zt6Z5Lq6d8IuHp0Bg==
X-Received: by 2002:a05:6402:5247:b0:566:a44d:c642 with SMTP id t7-20020a056402524700b00566a44dc642mr1084404edd.15.1709206799452;
        Thu, 29 Feb 2024 03:39:59 -0800 (PST)
Received: from thinky ([109.183.6.197])
        by smtp.gmail.com with ESMTPSA id j1-20020a50ed01000000b005667629f6e1sm537935eds.39.2024.02.29.03.39.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Feb 2024 03:39:58 -0800 (PST)
Date: Thu, 29 Feb 2024 12:39:58 +0100
From: Andrey Albershteyn <aalbersh@redhat.com>
To: Zorro Lang <zlang@redhat.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>, fstests@vger.kernel.org, 
	linux-xfs@vger.kernel.org, Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] generic: check logical-sector sized O_DIRECT
Message-ID: <kxhp3he7t53sr2g3khet3lw3nq47uqku7ttr3rwn2ai7nlw2hk@lo5f677t7svz>
References: <20221107045618.2772009-1-zlang@kernel.org>
 <20240228155929.GD1927156@frogsfrogsfrogs>
 <20240229005218.pwgakn5x3fwwcjnj@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
 <20240229014140.GU6226@frogsfrogsfrogs>
 <20240229015521.yuof45wulkneq5ij@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240229015521.yuof45wulkneq5ij@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>

On 2024-02-29 09:55:21, Zorro Lang wrote:
> On Wed, Feb 28, 2024 at 05:41:40PM -0800, Darrick J. Wong wrote:
> > On Thu, Feb 29, 2024 at 08:52:18AM +0800, Zorro Lang wrote:
> > > On Wed, Feb 28, 2024 at 07:59:29AM -0800, Darrick J. Wong wrote:
> > > > On Mon, Nov 07, 2022 at 12:56:18PM +0800, Zorro Lang wrote:
> > > > > If the physical sector size is 4096, but the logical sector size
> > > > > is 512, the 512b dio write/read should be allowed.
> > > > 
> > > > Huh, did we all completely forget to review this patch?
> > > 
> > > Hmm?? This patch has been reviewed and merged in 2022, refer to g/704.
> > > Why did it appear (be refreshed) at here suddenly ?
> > 
> > Doh!
> > 
> > Sorry, I saw this patch sitting by itself with no replies or "Hey I
> > merged this" messages and thought we'd forgotten it.
> 
> Thanks for taking care this test :)
> 
> There was a RVB for this patch:
> https://lore.kernel.org/fstests/20221107105309.khksga5m7p766sed@aalbersh.remote.csb/

Sorry, it's probably because I somehow dropped CC to linux-xfs

> 
> This remind me that I still have some patches in my local branch, they were
> not merged by some reasons. I'll check if some of them are suitable for now :)
> 
> Thanks,
> Zorro
> 
> > 
> > And if it's running without problems (I haven't seen any in generic/704)
> > then I'll leave well enough alone.
> > 
> > --D
> > 
> > > > 
> > > > > Signed-off-by: Zorro Lang <zlang@kernel.org>
> > > > > ---
> > > > > 
> > > > > Hi,
> > > > > 
> > > > > This reproducer was written for xfs, I try to make it to be a generic
> > > > > test case for localfs. Current it test passed on xfs, extN and btrfs,
> > > > > the bug can be reproduced on old rhel-6.6 [1]. If it's not right for
> > > > > someone fs, please feel free to tell me.
> > > > > 
> > > > > Thanks,
> > > > > Zorro
> > > > > 
> > > > > [1]
> > > > > # ./check generic/888
> > > > > FSTYP         -- xfs (non-debug)
> > > > > PLATFORM      -- Linux/x86_64 xxx-xxxxx-xxxxxx 2.6.32-504.el6.x86_64
> > > > > MKFS_OPTIONS  -- -f -bsize=4096 /dev/loop1
> > > > > MOUNT_OPTIONS -- -o context=system_u:object_r:nfs_t:s0 /dev/loop1 /mnt/scratch
> > > > > 
> > > > > generic/888      - output mismatch (see /root/xfstests-dev/results//generic/888.out.bad)
> > > > >     --- tests/generic/888.out   2022-11-06 23:42:44.683040977 -0500
> > > > >     +++ /root/xfstests-dev/results//generic/888.out.bad 2022-11-06 23:48:33.986481844 -0500
> > > > >     @@ -4,3 +4,4 @@
> > > > >      512
> > > > >      mkfs and mount
> > > > >      DIO read/write 512 bytes
> > > > >     +pwrite64: Invalid argument
> > > > >     ...
> > > > >     (Run 'diff -u tests/generic/888.out /root/xfstests-dev/results//generic/888.out.bad'  to see the entire diff)
> > > > > Ran: generic/888
> > > > > Failures: generic/888
> > > > > Failed 1 of 1 tests
> > > > > 
> > > > >  tests/generic/888     | 52 +++++++++++++++++++++++++++++++++++++++++++
> > > > >  tests/generic/888.out |  6 +++++
> > > > >  2 files changed, 58 insertions(+)
> > > > >  create mode 100755 tests/generic/888
> > > > >  create mode 100644 tests/generic/888.out
> > > > > 
> > > > > diff --git a/tests/generic/888 b/tests/generic/888
> > > > > new file mode 100755
> > > > > index 00000000..b5075d1e
> > > > > --- /dev/null
> > > > > +++ b/tests/generic/888
> > > > > @@ -0,0 +1,52 @@
> > > > > +#! /bin/bash
> > > > > +# SPDX-License-Identifier: GPL-2.0
> > > > > +# Copyright (c) 2022 Red Hat, Inc.  All Rights Reserved.
> > > > > +#
> > > > > +# FS QA Test No. 888
> > > > > +#
> > > > > +# Make sure logical-sector sized O_DIRECT write is allowed
> > > > > +#
> > > > > +. ./common/preamble
> > > > > +_begin_fstest auto quick
> > > > > +
> > > > > +# Override the default cleanup function.
> > > > > +_cleanup()
> > > > > +{
> > > > > +	cd /
> > > > > +	rm -r -f $tmp.*
> > > > > +	[ -d "$SCSI_DEBUG_MNT" ] && $UMOUNT_PROG $SCSI_DEBUG_MNT 2>/dev/null
> > > > > +	_put_scsi_debug_dev
> > > > > +}
> > > > > +
> > > > > +# Import common functions.
> > > > > +. ./common/scsi_debug
> > > > > +
> > > > > +# real QA test starts here
> > > > > +_supported_fs generic
> > > > > +_fixed_by_kernel_commit 7c71ee78031c "xfs: allow logical-sector sized O_DIRECT"
> > > > > +_require_scsi_debug
> > > > > +# If TEST_DEV is block device, make sure current fs is a localfs which can be
> > > > > +# written on scsi_debug device
> > > > > +_require_test
> > > > > +_require_block_device $TEST_DEV
> > > > 
> > > > _require_odirect?
> > > > 
> > > > > +
> > > > > +echo "Get a device with 4096 physical sector size and 512 logical sector size"
> > > > > +SCSI_DEBUG_DEV=`_get_scsi_debug_dev 4096 512 0 256`
> > > > > +blockdev --getpbsz --getss $SCSI_DEBUG_DEV
> > > > > +
> > > > > +echo "mkfs and mount"
> > > > > +_mkfs_dev $SCSI_DEBUG_DEV || _fail "Can't make $FSTYP on scsi_debug device"
> > > > > +SCSI_DEBUG_MNT="$TEST_DIR/scsi_debug_$seq"
> > > > > +rm -rf $SCSI_DEBUG_MNT
> > > > > +mkdir $SCSI_DEBUG_MNT
> > > > > +run_check _mount $SCSI_DEBUG_DEV $SCSI_DEBUG_MNT
> > > > 
> > > > /me wonders, should we try to use $MKFS_OPTIONS and $MOUNT_OPTIONS
> > > > on the scsidebug device?  To catch cases where the config actually
> > > > matters for that kind of thing?
> > > 
> > > It's been merged, if we need to change something, better to send a new
> > > patch to change that :)
> > > 
> > > Thanks,
> > > Zorro
> > > 
> > > > 
> > > > --D
> > > > 
> > > > > +
> > > > > +echo "DIO read/write 512 bytes"
> > > > > +# This dio write should succeed, even the physical sector size is 4096, but
> > > > > +# the logical sector size is 512
> > > > > +$XFS_IO_PROG -d -f -c "pwrite 0 512" $SCSI_DEBUG_MNT/testfile >> $seqres.full
> > > > > +$XFS_IO_PROG -d -c "pread 0 512" $SCSI_DEBUG_MNT/testfile >> $seqres.full
> > > > > +
> > > > > +# success, all done
> > > > > +status=0
> > > > > +exit
> > > > > diff --git a/tests/generic/888.out b/tests/generic/888.out
> > > > > new file mode 100644
> > > > > index 00000000..0f142ce9
> > > > > --- /dev/null
> > > > > +++ b/tests/generic/888.out
> > > > > @@ -0,0 +1,6 @@
> > > > > +QA output created by 888
> > > > > +Get a device with 4096 physical sector size and 512 logical sector size
> > > > > +4096
> > > > > +512
> > > > > +mkfs and mount
> > > > > +DIO read/write 512 bytes
> > > > > -- 
> > > > > 2.31.1
> > > > > 
> > > > 
> > > 
> > 
> 
> 

-- 
- Andrey

