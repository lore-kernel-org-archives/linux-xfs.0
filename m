Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 724A6C433EF
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Sep 2021 23:11:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5082060EE9
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Sep 2021 23:11:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229538AbhIOXNR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 15 Sep 2021 19:13:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:39376 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232465AbhIOXNQ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 15 Sep 2021 19:13:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2320E60E05;
        Wed, 15 Sep 2021 23:11:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631747517;
        bh=LoD4ufPwNbUcOksuUKAbSHpi43DPqU+JkV0aBX/Hwlw=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=BhjqhwnZWGk7vztezG8xwbT9yvvNDPd/+5FXyrZj4edEdwPKD14JhlXnu/Ot2lbcU
         7Y+/Qc+g1wv2PuuxqB6daNpGjxQMS99RLw1KK+BI+9Sei/ZNhGpUdu3MLJ1bNJbffg
         QoXUQamldq7na74RjUiyDCWQ467McRWil1/GBh3R7lk0rxFMXN9QFFsMjpPi7e5y+X
         ZgC21K4r8hJVyg5Q8Q3hn1JQ7f/bCfNddaCdYjpJqCBLVemtjKWNkTKswBV6hVApFL
         cunEA+M2bjlrPDIdUZQ72MHvaUXapInGgfKr3Da20kNyz89zVZi994BzsXmkKQFAzB
         Z1DrPYjZguJow==
Subject: [PATCH 59/61] xfs: logging the on disk inode LSN can make it go
 backwards
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org
Date:   Wed, 15 Sep 2021 16:11:56 -0700
Message-ID: <163174751688.350433.9364841513650368999.stgit@magnolia>
In-Reply-To: <163174719429.350433.8562606396437219220.stgit@magnolia>
References: <163174719429.350433.8562606396437219220.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Source kernel commit: 32baa63d82ee3f5ab3bd51bae6bf7d1c15aed8c7

When we log an inode, we format the "log inode" core and set an LSN
in that inode core. We do that via xfs_inode_item_format_core(),
which calls:

xfs_inode_to_log_dinode(ip, dic, ip->i_itemp->ili_item.li_lsn);

to format the log inode. It writes the LSN from the inode item into
the log inode, and if recovery decides the inode item needs to be
replayed, it recovers the log inode LSN field and writes it into the
on disk inode LSN field.

Now this might seem like a reasonable thing to do, but it is wrong
on multiple levels. Firstly, if the item is not yet in the AIL,
item->li_lsn is zero. i.e. the first time the inode it is logged and
formatted, the LSN we write into the log inode will be zero. If we
only log it once, recovery will run and can write this zero LSN into
the inode.

This means that the next time the inode is logged and log recovery
runs, it will *always* replay changes to the inode regardless of
whether the inode is newer on disk than the version in the log and
that violates the entire purpose of recording the LSN in the inode
at writeback time (i.e. to stop it going backwards in time on disk
during recovery).

Secondly, if we commit the CIL to the journal so the inode item
moves to the AIL, and then relog the inode, the LSN that gets
stamped into the log inode will be the LSN of the inode's current
location in the AIL, not it's age on disk. And it's not the LSN that
will be associated with the current change. That means when log
recovery replays this inode item, the LSN that ends up on disk is
the LSN for the previous changes in the log, not the current
changes being replayed. IOWs, after recovery the LSN on disk is not
in sync with the LSN of the modifications that were replayed into
the inode. This, again, violates the recovery ordering semantics
that on-disk writeback LSNs provide.

Hence the inode LSN in the log dinode is -always- invalid.

Thirdly, recovery actually has the LSN of the log transaction it is
replaying right at hand - it uses it to determine if it should
replay the inode by comparing it to the on-disk inode's LSN. But it
doesn't use that LSN to stamp the LSN into the inode which will be
written back when the transaction is fully replayed. It uses the one
in the log dinode, which we know is always going to be incorrect.

Looking back at the change history, the inode logging was broken by
back in 2016 by a stupid idiot who thought he knew how this code
worked. i.e. me. That commit replaced an in memory di_lsn field that
was updated only at inode writeback time from the inode item.li_lsn
value - and hence always contained the same LSN that appeared in the
on-disk inode - with a read of the inode item LSN at inode format
time. CLearly these are not the same thing.

Before 93f958f9c41f, the log recovery behaviour was irrelevant,
because the LSN in the log inode always matched the on-disk LSN at
the time the inode was logged, hence recovery of the transaction
would never make the on-disk LSN in the inode go backwards or get
out of sync.

A symptom of the problem is this, caught from a failure of
generic/482. Before log recovery, the inode has been allocated but
never used:

xfs_db> inode 393388
xfs_db> p
core.magic = 0x494e
core.mode = 0
....
v3.crc = 0x99126961 (correct)
v3.change_count = 0
v3.lsn = 0
v3.flags2 = 0
v3.cowextsize = 0
v3.crtime.sec = Thu Jan  1 10:00:00 1970
v3.crtime.nsec = 0

After log recovery:

xfs_db> p
core.magic = 0x494e
core.mode = 020444
....
v3.crc = 0x23e68f23 (correct)
v3.change_count = 2
v3.lsn = 0
v3.flags2 = 0
v3.cowextsize = 0
v3.crtime.sec = Thu Jul 22 17:03:03 2021
v3.crtime.nsec = 751000000
...

You can see that the LSN of the on-disk inode is 0, even though it
clearly has been written to disk. I point out this inode, because
the generic/482 failure occurred because several adjacent inodes in
this specific inode cluster were not replayed correctly and still
appeared to be zero on disk when all the other metadata (inobt,
finobt, directories, etc) indicated they should be allocated and
written back.

The fix for this is two-fold. The first is that we need to either
revert the LSN changes in 93f958f9c41f or stop logging the inode LSN
altogether. If we do the former, log recovery does not need to
change but we add 8 bytes of memory per inode to store what is
largely a write-only inode field. If we do the latter, log recovery
needs to stamp the on-disk inode in the same manner that inode
writeback does.

I prefer the latter, because we shouldn't really be trying to log
and replay changes to the on disk LSN as the on-disk value is the
canonical source of the on-disk version of the inode. It also
matches the way we recover buffer items - we create a buf_log_item
that carries the current recovery transaction LSN that gets stamped
into the buffer by the write verifier when it gets written back
when the transaction is fully recovered.

However, this might break log recovery on older kernels even more,
so I'm going to simply ignore the logged value in recovery and stamp
the on-disk inode with the LSN of the transaction being recovered
that will trigger writeback on transaction recovery completion. This
will ensure that the on-disk inode LSN always reflects the LSN of
the last change that was written to disk, regardless of whether it
comes from log recovery or runtime writeback.

Fixes: 93f958f9c41f ("xfs: cull unnecessary icdinode fields")
Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_log_format.h |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)


diff --git a/libxfs/xfs_log_format.h b/libxfs/xfs_log_format.h
index d548ea4b..2c5bcbc1 100644
--- a/libxfs/xfs_log_format.h
+++ b/libxfs/xfs_log_format.h
@@ -411,7 +411,16 @@ struct xfs_log_dinode {
 	/* start of the extended dinode, writable fields */
 	uint32_t	di_crc;		/* CRC of the inode */
 	uint64_t	di_changecount;	/* number of attribute changes */
-	xfs_lsn_t	di_lsn;		/* flush sequence */
+
+	/*
+	 * The LSN we write to this field during formatting is not a reflection
+	 * of the current on-disk LSN. It should never be used for recovery
+	 * sequencing, nor should it be recovered into the on-disk inode at all.
+	 * See xlog_recover_inode_commit_pass2() and xfs_log_dinode_to_disk()
+	 * for details.
+	 */
+	xfs_lsn_t	di_lsn;
+
 	uint64_t	di_flags2;	/* more random flags */
 	uint32_t	di_cowextsize;	/* basic cow extent size for file */
 	uint8_t		di_pad2[12];	/* more padding for future expansion */

