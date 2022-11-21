Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C1A7C433FE
	for <linux-xfs@archiver.kernel.org>; Mon, 21 Nov 2022 19:37:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229527AbiKUThV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 21 Nov 2022 14:37:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229572AbiKUThV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 21 Nov 2022 14:37:21 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 408B1CFE9D;
        Mon, 21 Nov 2022 11:37:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CB26161452;
        Mon, 21 Nov 2022 19:37:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DD44C433D6;
        Mon, 21 Nov 2022 19:37:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669059437;
        bh=FagImw2FKFYLpALNSyCcWEpnKQ8e0584CSz9n46tr+k=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=BP6eNlj70kvnigYm+XcGR1BMvfGeVT+5kbXfWSUId7QBG5IBw4xrAD66fXR4YUlsS
         qhK4AbLByqIXkhgD9/mLc9OxPDpWYJg63oVob/61xP9T7N5iz2aHwJ4b9+1TlSpVlp
         Y9vdp7Q6uIeetMyF3sqxHeGa8m2piuPRmhP7a7IyMoIvef4Sb7HDcGgM5vLYcSws50
         pOQnjRReKhaYRQiMvLkn1OR9hsK/9zH44v6hOis5jBL6jiMBflJoZk/kTStFY1DfMy
         Q4ExvStiA16gleQCknLBjE3LcVY8yzUu97eMMoJqzfhnZ+1Nn1hjRUvxYToGsadgQN
         4MCe7p+h2z/SA==
Date:   Mon, 21 Nov 2022 11:37:16 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Zorro Lang <zlang@redhat.com>
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH] nfs: test files written size as expected
Message-ID: <Y3vTbHqT64gsQ573@magnolia>
References: <20221105032329.2067299-1-zlang@kernel.org>
 <20221121184745.p3duc7thj53s5fgv@zlang-mailbox>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221121184745.p3duc7thj53s5fgv@zlang-mailbox>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Nov 22, 2022 at 02:47:45AM +0800, Zorro Lang wrote:
> On Sat, Nov 05, 2022 at 11:23:29AM +0800, Zorro Lang wrote:
> > Test nfs and its underlying fs, make sure file size as expected
> > after writting a file, and the speculative allocation space can
> > be shrunken.
> > 
> > Signed-off-by: Zorro Lang <zlang@kernel.org>
> > ---
> > 
> > Hi,
> > 
> > The original bug reproducer is:
> > 1. mount nfs3 backed by xfs
> > 2. dd if=/dev/zero of=/nfs/10M bs=1M count=10
> > 3. du -sh /nfs/10M                           
> > 16M	/nfs/10M 
> > 
> > As this was a xfs issue, so cc linux-xfs@ to get review.
> > 
> > Thanks,
> > Zorro
> > 
> >  tests/nfs/002     | 43 +++++++++++++++++++++++++++++++++++++++++++
> >  tests/nfs/002.out |  2 ++
> >  2 files changed, 45 insertions(+)
> >  create mode 100755 tests/nfs/002
> >  create mode 100644 tests/nfs/002.out
> > 
> > diff --git a/tests/nfs/002 b/tests/nfs/002
> > new file mode 100755
> > index 00000000..3d29958d
> > --- /dev/null
> > +++ b/tests/nfs/002
> > @@ -0,0 +1,43 @@
> > +#! /bin/bash
> > +# SPDX-License-Identifier: GPL-2.0
> > +# Copyright (c) 2022 Red Hat, Inc.  All Rights Reserved.
> > +#
> > +# FS QA Test 002
> > +#
> > +# Make sure nfs gets expected file size after writting a big sized file. It's
> > +# not only testing nfs, test its underlying fs too. For example a known old bug
> > +# on xfs (underlying fs) caused nfs get larger file size (e.g. 16M) after
> > +# writting 10M data to a file. It's fixed by a series of patches around
> > +# 579b62faa5fb16 ("xfs: add background scanning to clear eofblocks inodes")
> > +#
> > +. ./common/preamble
> > +_begin_fstest auto rw
> > +
> > +# real QA test starts here
> > +_supported_fs nfs
> > +_require_test
> > +
> > +localfile=$TEST_DIR/testfile.$seq
> > +rm -rf $localfile
> > +
> > +$XFS_IO_PROG -f -t -c "pwrite 0 10m" -c "fsync" $localfile >>$seqres.full 2>&1
> > +block_size=`stat -c '%B' $localfile`
> > +iblocks_expected=$((10 * 1024 * 1024 / $block_size))
> > +# Try several times for the speculative allocated file size can be shrunken
> > +res=1
> > +for ((i=0; i<10; i++));do
> > +	iblocks_real=`stat -c '%b' $localfile`
> > +	if [ "$iblocks_expected" = "$iblocks_real" ];then
> > +		res=0
> > +		break
> > +	fi
> > +	sleep 10
> > +done
> 
> Hmm... this case sometimes fails on kernel 6.1.0-rc6 [1] (nfs4.2 base on xfs),
> even I changed the sleep time to 20s * 10, it still fails. But I can't reproduce
> this failure if the underlying fs is ext4... cc linux-xfs, to check if I miss
> something for xfs? Or this's a xfs issue?

Could be anything, really -- speculative preallocation on the server, or
xattrs blowing up the attr fork.  You'd have to go query the file
mappings and whatnot of the xfs file on the server to find out.

--D

> Thanks,
> Zorro
> 
> [1]
> # ./check nfs/002
> FSTYP         -- nfs
> PLATFORM      -- Linux/x86_64 dell-per640-04 6.1.0-rc6 #1 SMP PREEMPT_DYNAMIC Mon Nov 21 00:51:20 EST 2022
> MKFS_OPTIONS  -- dell-per640-04.dell2.lab.eng.bos.redhat.com:/mnt/xfstests/scratch/nfs-server
> MOUNT_OPTIONS -- -o vers=4.2 -o context=system_u:object_r:root_t:s0 dell-per640-04.dell2.lab.eng.bos.redhat.com:/mnt/xfstests/scratch/nfs-server /mnt/xfstests/scratch/nfs-client
> 
> nfs/002 3s ... - output mismatch (see /var/lib/xfstests/results//nfs/002.out.bad)
>     --- tests/nfs/002.out       2022-11-21 01:29:33.861770474 -0500
>     +++ /var/lib/xfstests/results//nfs/002.out.bad      2022-11-21 13:27:37.424199056 -0500
>     @@ -1,2 +1,3 @@
>      QA output created by 002
>     +Write 20480 blocks, but get 32640 blocks
>      Silence is golden
>     ...
>     (Run 'diff -u /var/lib/xfstests/tests/nfs/002.out /var/lib/xfstests/results//nfs/002.out.bad'  to see the entire diff)
> Ran: nfs/002
> Failures: nfs/002
> Failed 1 of 1 tests
> 
> 
> > +if [ $res -ne 0 ];then
> > +	echo "Write $iblocks_expected blocks, but get $iblocks_real blocks"
> > +fi
> > +
> > +echo "Silence is golden"
> > +# success, all done
> > +status=0
> > +exit
> > diff --git a/tests/nfs/002.out b/tests/nfs/002.out
> > new file mode 100644
> > index 00000000..61705c7c
> > --- /dev/null
> > +++ b/tests/nfs/002.out
> > @@ -0,0 +1,2 @@
> > +QA output created by 002
> > +Silence is golden
> > -- 
> > 2.31.1
> > 
> 
