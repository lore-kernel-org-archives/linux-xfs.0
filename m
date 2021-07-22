Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94091C4338F
	for <linux-xfs@archiver.kernel.org>; Thu, 22 Jul 2021 21:34:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7406760EB4
	for <linux-xfs@archiver.kernel.org>; Thu, 22 Jul 2021 21:34:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231403AbhGVUyJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 22 Jul 2021 16:54:09 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:59948 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231512AbhGVUyI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 22 Jul 2021 16:54:08 -0400
Received: from dread.disaster.area (pa49-181-34-10.pa.nsw.optusnet.com.au [49.181.34.10])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id E348586380F;
        Fri, 23 Jul 2021 07:34:40 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1m6gL1-009crp-T0; Fri, 23 Jul 2021 07:34:39 +1000
Date:   Fri, 23 Jul 2021 07:34:39 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] [RFC] xfs: logging the on disk inode LSN can make it go
 backwards
Message-ID: <20210722213439.GO664593@dread.disaster.area>
References: <20210722110247.3086929-1-david@fromorbit.com>
 <20210722185903.GF559212@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210722185903.GF559212@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=YKPhNiOx c=1 sm=1 tr=0
        a=hdaoRb6WoHYrV466vVKEyw==:117 a=hdaoRb6WoHYrV466vVKEyw==:17
        a=kj9zAlcOel0A:10 a=e_q4qTt1xDgA:10 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8
        a=I5LN7AJ3qBmvtOGIjc0A:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jul 22, 2021 at 11:59:03AM -0700, Darrick J. Wong wrote:
> On Thu, Jul 22, 2021 at 09:02:47PM +1000, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > When we log an inode, we format the "log inode" core and set an LSN
> > in that inode core. We do that via xfs_inode_item_format_core(),
> > which calls:
> > 
> > 	xfs_inode_to_log_dinode(ip, dic, ip->i_itemp->ili_item.li_lsn);
> > 
> > to format the log inode. It writes the LSN from the inode item into
> > the log inode, and if recovery decides the inode item needs to be
> > replayed, it recovers the log inode LSN field and writes it into the
> > on disk inode LSN field.
> > 
> > Now this might seem like a reasonable thing to do, but it is wrong
> > on multiple levels. Firstly, if the item is not yet in the AIL,
> > item->li_lsn is zero. i.e. the first time the inode it is logged and
> > formatted, the LSN we write into the log inode will be zero. If we
> > only log it once, recovery will run and can write this zero LSN into
> > the inode.
> 
> In the case where we don't crash, the AIL calls xfs_inode_item_push ->
> xfs_iflush_cluster -> xfs_iflush, which will set the ondisk di_lsn to
> iip->ili_item.li_lsn.  Presumably, the LSN won't be zero at this point,
> right?  And it will accurately reflect the age of the ondisk inode?

Correct. Writeback puts the correct value into the on-disk inode.

> IOWs, does the low-inode-LSN problem only happen if we log an inode,
> force the log, and crash before the AIL gets to flushing the inode?

Yes.

> > This means that the next time the inode is logged and log recovery
> > runs, it will *always* replay changes to the inode regardless of
> > whether the inode is newer on disk than the version in the log and
> > that violates the entire purpose of recording the LSN in the inode
> > at writeback time (i.e. to stop it going backwards in time on disk
> > during recovery).
> > 
> > Secondly, if we commit the CIL to the journal so the inode item
> > moves to the AIL, and then relog the inode, the LSN that gets
> > stamped into the log inode will be the LSN of the inode's current
> > location in the AIL, not it's age on disk. And it's not the LSN that
> > will be associated with the current change. That means when log
> > recovery replays this inode item, the LSN that ends up on disk is
> > the LSN for the previous changes in the log, not the current
> > changes being replayed. IOWs, after recovery the LSN on disk is not
> > in sync with the LSN of the modifications that were replayed into
> > the inode. This, again, violates the recovery ordering semantics
> > that on-disk writeback LSNs provide.
> 
> Yikes.
> 
> > Hence the inode LSN in the log dinode is -always- invalid.
> 
> In that case, I think the final version of this patch should amend the
> structure definition of xfs_log_dinode should note that di_lsn is never
> correct.

*nod*

> > Thirdly, recovery actually has the LSN of the log transaction it is
> > replaying right at hand - it uses it to determine if it should
> > replay the inode by comparing it to the on-disk inode's LSN. But it
> > doesn't use that LSN to stamp the LSN into the inode which will be
> > written back when the transaction is fully replayed. It uses the one
> > in the log dinode, which we know is always going to be incorrect.
> > 
> > Looking back at the change history, the inode logging was broken by
> > commit 93f958f9c41f ("xfs: cull unnecessary icdinode fields") way
> > back in 2016 by a stupid idiot who thought he knew how this code
> > worked. i.e. me. That commit replaced an in memory di_lsn field that
> > was updated only at inode writeback time from the inode item.li_lsn
> > value - and hence always contained the same LSN that appeared in the
> > on-disk inode - with a read of the inode item LSN at inode format
> > time. CLearly these are not the same thing.
> > 
> > Before 93f958f9c41f, the log recovery behaviour was irrelevant,
> > because the LSN in the log inode always matched the on-disk LSN at
> > the time the inode was logged, hence recovery of the transaction
> > would never make the on-disk LSN in the inode go backwards or get
> > out of sync.
> > 
> > A symptom of the problem is this, caught from a failure of
> > generic/482. Before log recovery, the inode has been allocated but
> > never used:
> > 
> > xfs_db> inode 393388
> > xfs_db> p
> > core.magic = 0x494e
> > core.mode = 0
> > ....
> > v3.crc = 0x99126961 (correct)
> > v3.change_count = 0
> > v3.lsn = 0
> > v3.flags2 = 0
> > v3.cowextsize = 0
> > v3.crtime.sec = Thu Jan  1 10:00:00 1970
> > v3.crtime.nsec = 0
> > 
> > After log recovery:
> > 
> > xfs_db> p
> > core.magic = 0x494e
> > core.mode = 020444
> > ....
> > v3.crc = 0x23e68f23 (correct)
> > v3.change_count = 2
> > v3.lsn = 0
> > v3.flags2 = 0
> > v3.cowextsize = 0
> > v3.crtime.sec = Thu Jul 22 17:03:03 2021
> > v3.crtime.nsec = 751000000
> > ...
> > 
> > You can see that the LSN of the on-disk inode is 0, even though it
> > clearly has been written to disk. I point out this inode, because
> 
> (I'd noticed this in a few crash metadumps...)

This is the first time I recall seeing it - it jumped out at me
immediately as a big red flag that something was wrong as I worked
my way through each inode in the cluster that repair found errors
in.

> > the generic/482 failure occurred because several adjacent inodes in
> > this specific inode cluster were not replayed correctly and still
> > appeared to be zero on disk when all the other metadata (inobt,
> > finobt, directories, etc) indicated they should be allocated and
> > written back.
> > 
> > The Fix for this is two-fold. The first is that we need to either
> > revert the LSN changes in 93f958f9c41f or stop logging the inode LSN
> > altogether. If we do the former, log recovery does not need to
> > change but we add 8 bytes of memory per inode to store what is
> > largely a write-only inode field. If we do the latter, log recovery
> > needs to stamp the on-disk inode in the same manner that inode
> > writeback does.
> > 
> > I prefer the latter, because we shouldn't really be trying to log
> > and replay changes to the on disk LSN as the on-disk value is the
> > canonical source of the on-disk version of the inode. It also
> > matches the way we recover buffer items - we create a buf_log_item
> > that carries the current recovery transaction LSN that gets stamped
> > into the buffer by the write verifier when it gets written back
> > when the transaction is fully recovered.
> 
> That sounds like something to do the next time someone adds a new
> *incompat feature...

Maybe we need an occasional "remove incompat cruft" feature bit to
batch little stuff like this together...

> > However, this might break log recovery on older kernels even more,
> > so I'm going to simply ignore the logged value in recovery and stamp
> > the on-disk inode with the LSN of the transaction being recovered
> > that will trigger writeback on transaction recovery completion. This
> 
> Well, that's easily backportable. ;)

*nod*

Once backported, we don't have to really care whether the LSN is
valid or not, just whether the kernel performs recovery correctly or
not. I suspect we also need a verifier check on this - if the inode
is allocated, the LSN should not be zero. And if it is zero, we
immediately log the inode so it will get written back with a good
LSN. I suspect xfs_repair and scrub need to flag this, too.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
