Return-Path: <SRS0=IJtx=XO=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33790C49ED7
	for <linux-xfs@archiver.kernel.org>; Thu, 19 Sep 2019 05:13:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E4D8721927
	for <linux-xfs@archiver.kernel.org>; Thu, 19 Sep 2019 05:13:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387809AbfISFNJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 19 Sep 2019 01:13:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45753 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387579AbfISFNJ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 19 Sep 2019 01:13:09 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id DF8941005337;
        Thu, 19 Sep 2019 05:13:08 +0000 (UTC)
Received: from localhost (dhcp-12-102.nay.redhat.com [10.66.12.102])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5912019C5B;
        Thu, 19 Sep 2019 05:13:08 +0000 (UTC)
Date:   Thu, 19 Sep 2019 13:20:33 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Yang Xu <xuyang2018.jy@cn.fujitsu.com>,
        "fstests@vger.kernel.org" <fstests@vger.kernel.org>,
        xfs <linux-xfs@vger.kernel.org>
Subject: Re: question of xfs/148 and xfs/149
Message-ID: <20190919052033.GL7239@dhcp-12-102.nay.redhat.com>
References: <4BF2FD5A942B1C4B828DDAF5635768C1041AB0E2@G08CNEXMBPEKD02.g08.fujitsu.local>
 <20190917163933.GC736475@magnolia>
 <20190918025915.GK7239@dhcp-12-102.nay.redhat.com>
 <7b5d5797-afff-90bc-0131-38fd13eced34@cn.fujitsu.com>
 <20190918163711.GX2229799@magnolia>
 <20190918231050.GH2229799@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190918231050.GH2229799@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.64]); Thu, 19 Sep 2019 05:13:08 +0000 (UTC)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Sep 18, 2019 at 04:10:50PM -0700, Darrick J. Wong wrote:
> On Wed, Sep 18, 2019 at 09:37:11AM -0700, Darrick J. Wong wrote:
> > On Wed, Sep 18, 2019 at 11:24:47AM +0800, Yang Xu wrote:
> > > 
> > > 
> > > on 2019/09/18 10:59, Zorro Lang wrote:
> > > > xfs/030 is weird, I've found it long time ago.
> > > > 
> > > > If I do a 'whole disk mkfs' (_scratch_mkfs_xfs), before this sized mkfs:
> > > > 
> > > >    _scratch_mkfs_xfs $DSIZE >/dev/null 2>&1
> > > > 
> > > > Everything looks clear, and test pass. I can't send a patch to do this,
> > > > because I don't know the reason.
> > > Yes. I also found running _scratch_mkfs_xfs in xfs/030 can slove this
> > > problem yesterday. Or, we can adjust _try_wipe_scratch_devs order in
> > > check(But I dont't have enough reason to explain why adjust it). as below:
> > 
> > (Yeah, I don't see any obvious reason why that would change outcomes...)
> > 
> > > --- a/check
> > > +++ b/check
> > > @@ -753,7 +753,6 @@ for section in $HOST_OPTIONS_SECTIONS; do
> > >                         # _check_dmesg depends on this log in dmesg
> > >                         touch ${RESULT_DIR}/check_dmesg
> > >                 fi
> > > -               _try_wipe_scratch_devs > /dev/null 2>&1
> > >                 if [ "$DUMP_OUTPUT" = true ]; then
> > >                         _run_seq 2>&1 | tee $tmp.out
> > >                         # Because $? would get tee's return code
> > > @@ -799,7 +798,7 @@ for section in $HOST_OPTIONS_SECTIONS; do
> > >                 # Scan for memory leaks after every test so that associating
> > >                 # a leak to a particular test will be as accurate as
> > > possible.
> > >                 _check_kmemleak || err=true
> > > -
> > > +               _try_wipe_scratch_devs > /dev/null 2>&1
> > >                 # test ends after all checks are done.
> > >                 $timestamp && _timestamp
> > >                 stop=`_wallclock`
> > > 
> > > > 
> > > > I'm not familiar with xfs_repair so much, so I don't know what happens
> > > > underlying. I suppose the the part after the $DSIZE affect the xfs_repair,
> > > > but I don't know why the wipefs can cause that, wipefs only erase 4 bytes
> > > > at the beginning.
> > > > 
> > >  I am finding the reasion. It seems wipefs wipes important information and
> > > $DSIZE option(using single agcount or dsize, it also fails ) can not format
> > > disk completely. If we use other options, it can pass.
> > 
> > How does mkfs fail, specifically?
> > 
> > Also, what's your storage configuration?  And lsblk -D output?
> 
> I'm still interested in the answer to these questions, but I've done a
> little more research and noticed that yes, xfs/030 fails if the device
> doesn't support zeroing discard.
> 
> First, if mkfs.xfs detects an old primary superblock, it will write
> zeroes to all superblocks before formatting the new filesystem.
> Obviously this won't be done if the device doesn't have a primary
> superblock.
> 
> (1) So let's say that a previous test formatted a 4GB scratch disk with
> all defaults, and let's say that we have 4 AGs.  The disk will look like
> this:
> 
>   SB0 [1G space] SB1 [1G space] SB2 [1G space] SB3 [1G space]
> 
> (2) Now we _try_wipe_scratch_devs, which wipes out the primary label:
> 
>   000 [1G space] SB1 [1G space] SB2 [1G space] SB3 [1G space]
> 
> (3) Now xfs/030 runs its special mkfs command (6AGs, 100MB disk).  If the
> disk supports zeroing discard, it will discard the whole device:
> 
>   <4GB of zeroes>
> 
> (4) Then it will lay down its own filesystem:
> 
>   SB0 [16M zeroes] SB1 [16M zeroes] <4 more AGs> <zeroes from 100M to 4G>
> 
> (5) Next, xfs/030 zaps the primary superblock:
> 
>   000 [16M zeroes] SB1 [16M zeroes] <4 more AGs> <zeroes from 100M to 4G>
> 
> (6) Next, xfs/030 runs xfs_repair.  It fails to find the primary sb, so it
> tries to find secondary superblocks.  Its first strategy is to compute
> the fs geometry assuming all default options.  In this case, that means
> 4 AGs, spaced 1G apart.  They're all zero, so it falls back to a linear
> scan of the disk.  It finds SB1, uses that to rewrite the primary super,
> and continues with the repair (which is mostly uneventful).  The test
> passes; this is why it works on my computer.
> 
> ---------
> 
> Now let's see what happened before _try_wipe_scratch_devs.  In step (3)
> mkfs would find the old superblocks and wipe the superblocks, before
> laying down the new superblocks:
> 
>   SB0 [16M zeroes] SB1 [16M zeroes] <4 more AGs> <zeroes from 100M to 1G> \
>       000 [1G space] 000 [1G space] 000 [1G space]
> 
> Step (5) zaps the primary, yielding:
> 
>   000 [16M zeroes] SB1 [16M zeroes] <4 more AGs> <zeroes from 100M to 1G> \
>       000 [1G space] 000 [1G space] 000 [1G space]
> 
> Step (6) fails to find a primary superblock so it tries to read backup
> superblocks at 1G, 2G, and 3G, but they're all zero so it falls back to
> the linear scan and picks up SB1 and proceeds with a mostly uneventful
> repair.  The test passes.
> 
> ---------
> 
> However, with _try_wipe_scratch_devs and a device that doesn't support
> discard (or MKFS_OPTIONS includes -K), we have a problem.  mkfs.xfs
> doesn't discard the device nor does it find a primary superblock, so it
> simply formats the new filesystem.  We end up with:
> 
>   SB0 [16M zeroes] SB1 [16M zeroes] <4 more AGs> <zeroes from 100M to 1G> \
>       SB'1 [1G space] SB'2 [1G space] SB'3 [1G space]
> 
> Where SB[0-5] are from the filesystem that xfs/030 formatted but
> SB'[1-3] are from the filesystem that was on the scratch disk before
> xfs/030 even started.  Uhoh.
> 
> Step (5) zaps the primary, yielding:
> 
>   000 [16M zeroes] SB1 [16M zeroes] <4 more AGs> <zeroes from 100M to 1G> \
>       SB'1 [1G space] SB'2 [1G space] SB'3 [1G space]
> 
> Step (6) fails to find a primary superblock so it tries to read backup
> superblocks at 1G.  It finds SB'1 and uses that to reconstruct the /old/
> filesystem, with what looks like massive filesystem damage.  This
> results in test failure.  Oops.
> 
> ----------
> 
> The reason for adding _try_wipe_scratch_devs was to detect broken tests
> that started using the filesystem on the scratch device (if any) before
> (or without!) formatting the scratch device.  That broken behavior could
> result in spurious test failures when xfstests was run in random order
> mode either due to mounting an unformatted device or mounting a corrupt
> fs that some other test left behind.
> 
> I guess a fix for XFS would be have _try_wipe_scratch_devs try to read
> the primary superblock to compute the AG geometry and then erase all
> superblocks that could be on the disk; and then compute the default
> geometry and wipe out all those superblocks too.
> 
> Does any of that square with what you've been seeing?

Thanks Darrick, so what I supposed might be true?
"
  > > > > I'm not familiar with xfs_repair so much, so I don't know what happens
  > > > > underlying. I suppose the the part after the $DSIZE affect the xfs_repair,
"

The sized mkfs.xfs (without discard) leave old on-disk structure behind $DSIZE
space, it cause xfs_repair try to use odd things to do the checking.

When I tried to erase the 1st block of each AGs[1], the test passed[2].
Is that what you talked as above?

Thanks,
Zorro

[1]
diff --git a/common/rc b/common/rc
index e0b087c1..19b7ab02 100644
--- a/common/rc
+++ b/common/rc
@@ -4048,6 +4048,10 @@ _try_wipe_scratch_devs()
        for dev in $SCRATCH_DEV_POOL $SCRATCH_DEV $SCRATCH_LOGDEV $SCRATCH_RTDEV; do
                test -b $dev && $WIPEFS_PROG -a $dev
        done
+
+       if [ "$FSTYP" = "xfs" ];then
+               _try_wipe_scratch_xfs
+       fi
 }
 
 # Only run this on xfs if xfs_scrub is available and has the unicode checker
diff --git a/common/xfs b/common/xfs
index 1bce3c18..53f33d12 100644
--- a/common/xfs
+++ b/common/xfs
@@ -884,3 +884,24 @@ _xfs_mount_agcount()
 {
        $XFS_INFO_PROG "$1" | grep agcount= | sed -e 's/^.*agcount=\([0-9]*\),.*$/\1/g'
 }
+
+_try_wipe_scratch_xfs()
+{
+       local tmp=`mktemp -u`
+
+       _scratch_mkfs_xfs -N 2>/dev/null | perl -ne '
+               if (/^meta-data=.*\s+agcount=(\d+), agsize=(\d+) blks/) {
+                       print STDOUT "agcount=$1\nagsize=$2\n";
+               }
+               if (/^data\s+=\s+bsize=(\d+)\s/) {
+                       print STDOUT "dbsize=$1\n";
+               }' > $tmp.mkfs
+       . $tmp.mkfs
+       if [ -n "$agcount" -a -n "$agsize" -a -n "$dbsize" ];then
+               for((i=0; i<agcount; i++)); do
+                       $XFS_IO_PROG -c "pwrite $((i * dbsize * agsize)) $dbsize" \
+                               $SCRATCH_DEV >/dev/null;
+               done
+       fi
+       rm -f $tmp.mkfs
+}

[2]
# ./check xfs/030
FSTYP         -- xfs (non-debug)
PLATFORM      -- Linux/x86_64 xxx-xxxx-xx xxx-xxxx-xx-xxx
MKFS_OPTIONS  -- -f -bsize=4096 /dev/mapper/scratchdev
MOUNT_OPTIONS -- -o context=system_u:object_r:root_t:s0 /dev/mapper/scratchdev /mnt/scratch

xfs/030 24s ...  25s
Ran: xfs/030
Passed all 1 tests

> 
> --D
> 
> > --D
> > 
> > > > Darrick, do you know more about that?
> > > > 
> > > > Thanks,
> > > > Zorro
> > > > 
> > > > > > xfs/148 is a clone of test 030 using xfs_prepair64 instead of xfs_repair.
> > > > > > xfs/149 is a clone of test 031 using xfs_prepair instead of xfs_repair
> > > > I'm not worried about it too much, due to it always 'not run' and never
> > > > failsYes. But I perfer to remove them because IMO they are useless.
> > > > 
> > > 
> > > > xfs/148 [not run] parallel repair binary xfs_prepair64 is not installed
> > > > xfs/149 [not run] parallel repair binary xfs_prepair is not installed
> > > > Ran: xfs/148 xfs/149
> > > > Not run: xfs/148 xfs/149
> > > > Passed all 2 tests
> > > > 
> > > 
> > > 
