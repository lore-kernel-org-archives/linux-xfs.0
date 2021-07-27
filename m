Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8C1DC4320A
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Jul 2021 18:37:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A2A6960F9F
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Jul 2021 18:37:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229727AbhG0Shf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 27 Jul 2021 14:37:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:36530 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229581AbhG0She (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 27 Jul 2021 14:37:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7846360F9F;
        Tue, 27 Jul 2021 18:37:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627411054;
        bh=5KgL07cUeD9zdSgHT/80N+z7O5y38qmDJWOfnnPbOzM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=LSacCqgZ8rZhSooG8iVk2j5WC+rYmta0SL8VkNOe+bV4to6jEbIp4M39GWGs0Ia8K
         vbx6fnfAwHFH2/MDxhZvNvucHPIoLunYGJgCP1P3lRykasU5f+PxfpxbPaKXaoyidR
         yR30QGqXcQTG9SkkCl/hTAWP4olDr+Hko3ZPaKcxJXstr5uGrlG1ACBCe1oiPZf4NJ
         QD6WEPLfgVnoa/TiayaDyUWPjlRjdTjJzBsv2HUwkvX83eSclpKgqPn8TR753k3Njj
         h2TFPoerJGVEkPzSrYGNvQcqMmNk9bAEHMlcedoXc5Jp8bntAcEucfa95IBE5KXFf0
         1RkFCZEFG33pg==
Date:   Tue, 27 Jul 2021 11:37:34 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Chandan Babu R <chandanrlinux@gmail.com>
Cc:     fstests@vger.kernel.org, guaneryu@gmail.com,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/3] xfs/530: Bail out if either of reflink or rmapbt is
 enabled
Message-ID: <20210727183734.GD559142@magnolia>
References: <20210726064313.19153-1-chandanrlinux@gmail.com>
 <20210726064313.19153-3-chandanrlinux@gmail.com>
 <20210726171916.GV559212@magnolia>
 <87fsw0fjq0.fsf@garuda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87fsw0fjq0.fsf@garuda>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jul 27, 2021 at 10:15:27AM +0530, Chandan Babu R wrote:
> On 26 Jul 2021 at 22:49, Darrick J. Wong wrote:
> > On Mon, Jul 26, 2021 at 12:13:13PM +0530, Chandan Babu R wrote:
> >> _scratch_do_mkfs constructs a mkfs command line by concatenating the values of
> >> 1. $mkfs_cmd
> >> 2. $MKFS_OPTIONS
> >> 3. $extra_mkfs_options
> >>
> >> The corresponding mkfs command line fails if $MKFS_OPTIONS enables either
> >> reflink or rmapbt feature. The failure occurs because the test tries to create
> >> a filesystem with realtime device enabled. In such a case, _scratch_do_mkfs()
> >> will construct and invoke an mkfs command line without including the value of
> >> $MKFS_OPTIONS.
> >>
> >> To prevent such silent failures, this commit causes the test to exit if it
> >> detects either reflink or rmapbt feature being enabled.
> >
> > Er, what combinations of mkfs.xfs and MKFS_OPTIONS cause this result?
> > What kind of fs configuration comes out of that?
> 
> With MKFS_OPTIONS set as shown below,
> 
> export MKFS_OPTIONS="-m reflink=1 -b size=1k"
> 
> _scratch_do_mkfs() invokes mkfs.xfs with both realtime and reflink options
> enabled. Such an invocation of mkfs.xfs fails causing _scratch_do_mkfs() to
> ignore the contents of $MKFS_OPTIONS while constructing and invoking mkfs.xfs
> once again.
> 
> This time, the fs block size will however be set to 4k (the default block
> size). At the beginning of the test we would have obtained the block size of
> the filesystem as 1k and used it to compute the size of the realtime device
> required to overflow realtime bitmap inode's max pseudo extent count.
> 
> Invocation of xfs_growfs (made later in the test) ends up succeeding since a
> 4k fs block can accommodate more bits than a 1k fs block.

OK, now I think I've finally put all the pieces together.  Both of these
patches are fixing weirdness when MKFS_OPTIONS="-m reflink=1 -b size=1k".

With current HEAD, we try to mkfs.xfs with double "-b size" arguments.
That fails with 'option respecified', so fstests tries again without
MKFS_OPTIONS, which means you don't get the filesystem that you want.
If, say, MKFS_OPTIONS also contained bigtime=1, you won't get a bigtime
filesystem.

So the first patch removes the double -bsize arguments.  But you still
have the problem that the reflink=1 in MKFS_OPTIONS still causes
mkfs.xfs to fail (because we don't do rt and reflink yet), so fstests
again drops MKFS_OPTIONS, and now you're testing the fs without a block
size option at all.  The test still regresses because the special rt
geometry depends on the blocksize, and we didn't get all the geometry
elements that we need to trip the growfs failure.

Does the following patch fix all that for you?

--D

diff --git a/tests/xfs/530 b/tests/xfs/530
index 4d168ac5..9c6f44d7 100755
--- a/tests/xfs/530
+++ b/tests/xfs/530
@@ -60,10 +60,22 @@ echo "Format and mount rt volume"
 
 export USE_EXTERNAL=yes
 export SCRATCH_RTDEV=$rtdev
-_scratch_mkfs -d size=$((1024 * 1024 * 1024)) -b size=${dbsize} \
+_scratch_mkfs -d size=$((1024 * 1024 * 1024)) \
 	      -r size=${rtextsz},extsize=${rtextsz} >> $seqres.full
 _try_scratch_mount || _notrun "Couldn't mount fs with synthetic rt volume"
 
+# If we didn't get the desired realtime volume and the same blocksize as the
+# first format (which we used to compute a specific rt geometry), skip the
+# test.  This can happen if the MKFS_OPTIONS conflict with the ones we passed
+# to _scratch_mkfs or do not result in a valid rt fs geometry.  In this case,
+# _scratch_mkfs will try to "succeed" at formatting by dropping MKFS_OPTIONS,
+# giving us the wrong geometry.
+formatted_blksz="$(_get_block_size $SCRATCH_MNT)"
+test "$formatted_blksz" -ne "$dbsize" && \
+	_notrun "Tried to format with $dbsize blocksize, got $formatted_blksz."
+$XFS_INFO_PROG $SCRATCH_MNT | egrep -q 'realtime.*blocks=0' && \
+	_notrun "Filesystem should have a realtime volume"
+
 echo "Consume free space"
 fillerdir=$SCRATCH_MNT/fillerdir
 nr_free_blks=$(stat -f -c '%f' $SCRATCH_MNT)

> >
> > Eventually, the plan is to support rmap[1] and reflink[2] on the
> > realtime device, at which point this will have to be torn out and a
> > better solution found.
> >
> > --D
> >
> > [1] https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git/log/?h=realtime-rmap
> > [2] https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git/log/?h=realtime-reflink
> >
> 
> --
> chandan
