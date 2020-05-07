Return-Path: <SRS0=M5eb=6V=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA4FBC38A24
	for <linux-xfs@archiver.kernel.org>; Thu,  7 May 2020 15:12:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AFB222073A
	for <linux-xfs@archiver.kernel.org>; Thu,  7 May 2020 15:12:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="tEU+auZW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727092AbgEGPMt (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 7 May 2020 11:12:49 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:54656 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726074AbgEGPMs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 May 2020 11:12:48 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 047F9JlP086396;
        Thu, 7 May 2020 15:12:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=rrHgmTVUMDajeUiBVJDroSodlsz3NX3IRi9PwFhaZK4=;
 b=tEU+auZWs+ki+71WLVAlMQD8Q5VgX4/MvII7DitkfjhAC5N4w15wiFI+Zl5f/wUoKnTn
 zqsD4w0V0VCHB/uCF7y733t6CF1pyiLaRHVJktxDcnfs8J7482nxn5NdaEKHk/kDzQlE
 YJQPGRtnaWSk3Cz8701E+HWTTfcFL1hBXKiYs8uanJK+GGFFiNVDUNXrHSN6WuTkahp5
 YqAohOgunjEtHYDRcIMB8EaBWFMEjGb1Y5F+n86nc6mD0UGPmZkBIscVLeMkZWTHZq2W
 cExg8igM2fsDHPQCBxix1b9iCgJklHm+rEpIkjyt9W8a0JsFQxDA+F9Ar8Khewe22ZGA 4A== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 30usgq7tr6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 07 May 2020 15:12:44 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 047FCQkO183851;
        Thu, 7 May 2020 15:12:44 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 30sjnpk775-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 07 May 2020 15:12:37 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 047F9v0m000616;
        Thu, 7 May 2020 15:09:58 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 07 May 2020 08:09:57 -0700
Date:   Thu, 7 May 2020 08:09:56 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/3] xfs: fix an incore inode UAF in xfs_bui_recover
Message-ID: <20200507150956.GE6714@magnolia>
References: <158864121286.184729.5959003885146573075.stgit@magnolia>
 <158864123329.184729.14504239314355330619.stgit@magnolia>
 <20200505141138.GB61176@bfoster>
 <20200506003423.GS5703@magnolia>
 <20200506135656.GA5054@bfoster>
 <20200506170150.GY5703@magnolia>
 <20200507095306.GA9003@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200507095306.GA9003@bfoster>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9613 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 adultscore=0 phishscore=0
 mlxlogscore=999 bulkscore=0 malwarescore=0 spamscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005070124
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9613 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 mlxscore=0
 priorityscore=1501 lowpriorityscore=0 malwarescore=0 clxscore=1015
 mlxlogscore=999 spamscore=0 adultscore=0 bulkscore=0 phishscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005070123
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, May 07, 2020 at 05:53:06AM -0400, Brian Foster wrote:
> On Wed, May 06, 2020 at 10:01:50AM -0700, Darrick J. Wong wrote:
> > On Wed, May 06, 2020 at 09:56:56AM -0400, Brian Foster wrote:
> > > On Tue, May 05, 2020 at 05:34:23PM -0700, Darrick J. Wong wrote:
> > > > On Tue, May 05, 2020 at 10:11:38AM -0400, Brian Foster wrote:
> > > > > On Mon, May 04, 2020 at 06:13:53PM -0700, Darrick J. Wong wrote:
> > > > > > From: Darrick J. Wong <darrick.wong@oracle.com>
> > > > > > 
> > > > > > In xfs_bui_item_recover, there exists a use-after-free bug with regards
> > > > > > to the inode that is involved in the bmap replay operation.  If the
> > > > > > mapping operation does not complete, we call xfs_bmap_unmap_extent to
> > > > > > create a deferred op to finish the unmapping work, and we retain a
> > > > > > pointer to the incore inode.
> > > > > > 
> > > > > > Unfortunately, the very next thing we do is commit the transaction and
> > > > > > drop the inode.  If reclaim tears down the inode before we try to finish
> > > > > > the defer ops, we dereference garbage and blow up.  Therefore, create a
> > > > > > way to join inodes to the defer ops freezer so that we can maintain the
> > > > > > xfs_inode reference until we're done with the inode.
> > > > > > 
> > > > > > Note: This imposes the requirement that there be enough memory to keep
> > > > > > every incore inode in memory throughout recovery.
> > > > > > 
> > > > > > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > > > > > ---
> > > > > 
> > > > > Maybe I'm missing something, but I thought the discussion on the
> > > > > previous version[1] landed on an approach where the intent would hold a
> > > > > reference to the inode. Wouldn't that break the dependency on the dfops
> > > > > freeze/thaw mechanism?
> > > > 
> > > > We did, but as I started pondering how to make this work in practice,
> > > > I soon realized that it's not as simple as "don't irele the inode":
> > > > 
> > > > (Part 1)
> > > > 
> > > > It would be easy enough to add a flag to struct xfs_bmap_intent that
> > > > means "when you're done, unlock and irele the inode".  You'd have to add
> > > > this capability to any log item that deals with inodes, but only
> > > > deferred bmap items need this.
> > > > 
> > > > Log recovery looks like this:
> > > > 
> > > > ----------------
> > > > Transaction 0
> > > > BUI1 unmap file1, offset1, startblock1, length == 200000
> > > > ----------------
> > > > <end>
> > > > 
> > > > What happens if the first bunmapi call doesn't actually unmap
> > > > everything?  We'll queue yet another bmap intent item (call it BUI2) to
> > > > finish the work.  This means that we can't just drop the inode when
> > > > we're done processing BUI1; we have to propagate the "unlock and irele"
> > > > flag to BUI2.  Ok, so now there's this chaining behavior that wasn't
> > > > there before.
> > > > 
> > > > Then I thought about it some more, and wondered what would happen if the
> > > > log contained two unfinished bmap items for the same inode?  If this
> > > > happened, you'd deadlock because you've not released the ILOCK for the
> > > > first unfinished bmap item when you want to acquire the ILOCK for the
> > > > second unfinished bmap item.
> > > > 
> > > 
> > > Hm, Ok.. so IIUC the lock is implicitly held across these map/unmap
> > > dfops at runtime, but that's not necessarily the case during recovery
> > > due to the dfops chaining behavior. To me, this raises the question of
> > > why we need to reorder/split these particular intents during recovery if
> > > the original operation would have completed under a single inode lock
> > > cycle.
> > 
> > Log recovery /did/ function that way (no reordering) until
> > 509955823cc9c, when it was discovered that we don't have a good way to
> > reconstruct the dfops chain from the list of recovered log intent items.
> > 
> > > The comments in xfs_log_recover.c don't really explain it. From going
> > > back to commit 509955823cc9c ("xfs: log recovery should replay deferred
> > > ops in order"), it looks like the issue is that ordering gets screwed up
> > > for operations that commit multiple intents per-transaction and
> > > completion of those intents creates new child intents. At runtime, we'd
> > > process the intents in the current transaction first and then get to the
> > > child intents in the order they were created. If we didn't have the
> > > recovery time dfops shuffling implemented in this patch, recovery would
> > > process the first intent in the log, then all of the child intents of
> > > that one before getting to the next intent in the log that presumably
> > > would have been second at runtime. Am I following that correctly?
> > 
> > Correct.  If we could figure out how to rebuild the dfops chain (and
> > thus the ordering requirements), we would be able to eliminate this
> > freezer stuff entirely.
> > 
> 
> Ok, thanks. I was wondering the same, but it's not clear how to do that
> with just the intent information in the log and big checkpoint
> transactions. Perhaps we could if we had a transactional id that was
> common across intents in a single transaction, or otherwise unique
> intent ids that would allow an intent to refer to the next in a chain at
> the time the intent was logged (such that recovery could learn to
> construct and process chains instead of just individual intents). I'm
> curious if we're going to want/need to solve that issue somehow or
> another more directly eventually as we grow more intents and perhaps
> come up with new and more complex intent-based operations (with more
> complex recovery scenarios).

<nod>  Too bad that's a log format change. :(

> > > I think the rest makes sense from the perspective of not wanting to
> > > plumb the conditional locking complexity through the dfops/intent
> > > processing for every intent type that eventually needs it, as opposed to
> > > containing in the log recovery code (via dfops magic). I need to think
> > > about all that some more, but I'd like to make sure I understand why we
> > > have this recovery requirement in the first place.
> > 
> > <nod>  It took me a few hours to figure out why that patch was correct
> > the first time I saw it.  It took me a few hours again(!) when I was
> > trying to write this series. :/
> > 
> 
> If I follow correctly, the rmap swapext sequence makes for a good
> example because the bmap completions generate the rmap intents. A
> simplified (i.e. single extent remap) runtime transactional flow for
> that looks something like the following:
> 
> t1: unmap intent, map intent
> t2: unmap done, map intent, runmap intent
> t3: map done, runmap intent, rmap intent
> t4: runmap done, rmap intent

Work items that aren't touched in a particular transaction do not get
relogged, so this sequence is:

t1: unmap(0) intent, map(1) intent
t2: unmap(0) done, runmap(2) intent
t3: map(1) done, rmap(3) intent
t4: runmap(2) done
t5: rmap(3) done

(Maybe I need to take another look at the autorelogging patchset.)

> ...
> 
> So at runtime these operations complete in the obvious linear order.
> Intents drop off the front as done items are logged and new intents are
> tacked on the end. If we crash between t2 and t3, however, we see t2 in
> the log and would end up completing the map intent and the subsequently
> generated rmap intent (that pops up in t3 at runtime) before we process
> the runmap intent that's still in the log (and was originally in the
> dfops queue for t2). I _think_ that's essentially the scenario described
> in 509955823cc9c,

Yes...

> but it's not clear to me if it's the same runtime example..

...and you arrived at it with a different scenario. :)

--D

> Brian
> 
> > --D
> > 
> > > Brian
> > > 
> > > > You'd have to drop the ILOCK (but retain the inode reference) between
> > > > the two bmap items.  I think this is currently impossible because there
> > > > aren't any transactions that queue multiple bmap intents per
> > > > transaction, nobody else holds the ilock, and the existing rmap
> > > > implementation of the swapext ioctl doesn't allow swapping a file with
> > > > itself.  However...
> > > > 
> > > > (Part 2)
> > > > 
> > > > The second thing I thought about is, what if there's a lot of work after
> > > > transaction 0?  Say the recovery stream looks like:
> > > > 
> > > > ----------------
> > > > Transaction 0
> > > > BUI1 unmap file1, offset1, startblock1, length == 200000
> > > > ----------------
> > > > <10000 more intents applied to other things>
> > > > ----------------
> > > > <end>
> > > > 
> > > > This is a problem, because we must drop the ILOCK after completing the
> > > > BUI1 work so that we can process the 10000 more intents before we can
> > > > get to BUI2.  We cannot let the tail of the log get pinned on the locked
> > > > inode, so we must release the ILOCK after we're done with BUI1 and
> > > > re-acquire it when we're ready to deal with BUI2.
> > > > 
> > > > This means I need /two/ flags in struct xfs_bmap_intent -- one to say
> > > > that we need to irele the inode at the end of processing, and another to
> > > > say that the bmap item needs to grab the ILOCK.  If there's going to be
> > > > a BUI2 as a result of recovering BUI1, the first flag must be propagated
> > > > to BUI2, but the second flag must /not/ be propagated.
> > > > 
> > > > A potential counterargument is that we crammed all 10000 intents into
> > > > the log without pinning the log, so maybe we can hold the ILOCK.
> > > > However....
> > > > 
> > > > (Part 3)
> > > > 
> > > > Next, I considered how the swapext log item in the atomic file update
> > > > patchset would interact with log recovery.  A couple of notes about the
> > > > swapext log items:
> > > > 
> > > > 1. They are careful not to create the kinds of bunmap operations that
> > > > would cause the creation of /more/ BUIs.
> > > > 
> > > > 2. Every time we log one extent's worth of unmap/remap operations (using
> > > > deferred bmap log items, naturally) we log an done item for the original
> > > > swapext intent item and immediately log another swapext intent for the
> > > > work remaining.
> > > > 
> > > > I came up with the following sequence of transactions to recover:
> > > > 
> > > > ----------------
> > > > Transaction 0
> > > > SXI0 file1, offset1, file2, offset2, length == 10
> > > > ----------------
> > > > Transaction 1
> > > > BUI1 unmap file1, offset1, startblock1, length == 2
> > > > BUI2 unmap file2, offset2, startblock2, length == 2
> > > > BUI3 map file1, offset1, startblock2, length == 2
> > > > BUI4 map file2, offset2, startblock1, length == 2
> > > > SXD done (SXI0)
> > > > SXI5 file1, offset1 + 2, file2, offset2 + 2, length == 8
> > > > ---------------
> > > > <end of log>
> > > > 
> > > > Recovery in this case will end up with BUI[1-4] and SXI5 that still need
> > > > processing.  Each of the 5 intent items gets its own recovery
> > > > transaction and dfops freezer chain.  BUI1, BUI3, and SXI5 will each
> > > > require ilock'd access to file1, which means that each of them will have
> > > > to have the ability to drop the ILOCK but retain the reference.  The
> > > > same argument applies to file2 and BUI2, BUI4, and SXI5.  Note also that
> > > > in our brave new world, file1 and file2 can be the same.
> > > > 
> > > > For the swapext log item type this inode management is particularly
> > > > acute because we're certain to have new SXIs created as a result of
> > > > recovering an SXI.
> > > > 
> > > > (End)
> > > > 
> > > > In conclusion, we need a mechanism to drop both the inode lock and the
> > > > inode reference.  Each log item type that works with inodes will have to
> > > > set aside 2 flags somewhere in the incore extent structure, and provide
> > > > more or less the same code to manage that state.  Right now that's just
> > > > the bmap items, but then the swapext items and the deferred xattr items
> > > > will have that same requirement when they get added.
> > > > 
> > > > If we do that, the inode reference and ilock management diverges even
> > > > further from regular operations.  Regular callers are expected to iget
> > > > and ilock the inode and maintain that all the way to the end of
> > > > xfs_trans_commit.  Log recovery, on the other hand, will add a bunch of
> > > > state handling to some of the log items so that we can drop the ILOCK
> > > > after the first item, and then drop the inode reference after finishing
> > > > the last possible user of that inode in the revived dfops chain.
> > > > 
> > > > On the other hand, keeping the inode management in the defer freezer
> > > > code means that I keep all that complexity and state management out of
> > > > the ->finish_item code.  When we go to finish the new incore intents
> > > > that get created during recovery, the inode reference and ILOCK rules
> > > > are the same as anywhere else -- the caller is required to grab the
> > > > inode, the transaction, and the ilock (in that order).
> > > > 
> > > > To the extent that recovering log intent items is /not/ the same as
> > > > running a normal transaction, all that weirdness is concentrated in
> > > > xfs_log_recover.c and a single function in xfs_defer.c.  The desired
> > > > behavior is the same across all the log intent item types, so I
> > > > decided in favor of keeping the centralised behavior and (trying to)
> > > > contain the wacky.  We don't need all that right away, but we will.
> > > > 
> > > > Note that I did make it so that we retain the reference always, so
> > > > there's no longer a need for irele/igrab cycles, which makes capturing
> > > > the dfops chain less error prone.
> > > > 
> > > > --D
> > > > 
> > > > > Brian
> > > > > 
> > > > > [1] https://lore.kernel.org/linux-xfs/20200429235818.GX6742@magnolia/
> > > > > 
> > > > > >  fs/xfs/libxfs/xfs_defer.c |   50 +++++++++++++++++++++++++++++++++++++++++++++
> > > > > >  fs/xfs/libxfs/xfs_defer.h |   10 +++++++++
> > > > > >  fs/xfs/xfs_bmap_item.c    |    7 ++++--
> > > > > >  fs/xfs/xfs_icache.c       |   19 +++++++++++++++++
> > > > > >  4 files changed, 83 insertions(+), 3 deletions(-)
> > > > > > 
> > > > > > 
> > > > > > diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
> > > > > > index ea4d28851bbd..72933fdafcb2 100644
> > > > > > --- a/fs/xfs/libxfs/xfs_defer.c
> > > > > > +++ b/fs/xfs/libxfs/xfs_defer.c
> > > > > > @@ -16,6 +16,7 @@
> > > > > >  #include "xfs_inode.h"
> > > > > >  #include "xfs_inode_item.h"
> > > > > >  #include "xfs_trace.h"
> > > > > > +#include "xfs_icache.h"
> > > > > >  
> > > > > >  /*
> > > > > >   * Deferred Operations in XFS
> > > > > > @@ -583,8 +584,19 @@ xfs_defer_thaw(
> > > > > >  	struct xfs_defer_freezer	*dff,
> > > > > >  	struct xfs_trans		*tp)
> > > > > >  {
> > > > > > +	int				i;
> > > > > > +
> > > > > >  	ASSERT(tp->t_flags & XFS_TRANS_PERM_LOG_RES);
> > > > > >  
> > > > > > +	/* Re-acquire the inode locks. */
> > > > > > +	for (i = 0; i < XFS_DEFER_FREEZER_INODES; i++) {
> > > > > > +		if (!dff->dff_inodes[i])
> > > > > > +			break;
> > > > > > +
> > > > > > +		dff->dff_ilocks[i] = XFS_ILOCK_EXCL;
> > > > > > +		xfs_ilock(dff->dff_inodes[i], dff->dff_ilocks[i]);
> > > > > > +	}
> > > > > > +
> > > > > >  	/* Add the dfops items to the transaction. */
> > > > > >  	list_splice_init(&dff->dff_dfops, &tp->t_dfops);
> > > > > >  	tp->t_flags |= dff->dff_tpflags;
> > > > > > @@ -597,5 +609,43 @@ xfs_defer_freeezer_finish(
> > > > > >  	struct xfs_defer_freezer	*dff)
> > > > > >  {
> > > > > >  	xfs_defer_cancel_list(mp, &dff->dff_dfops);
> > > > > > +	xfs_defer_freezer_irele(dff);
> > > > > >  	kmem_free(dff);
> > > > > >  }
> > > > > > +
> > > > > > +/*
> > > > > > + * Attach an inode to this deferred ops freezer.  Callers must hold ILOCK_EXCL,
> > > > > > + * which will be dropped and reacquired when we're ready to thaw the frozen
> > > > > > + * deferred ops.
> > > > > > + */
> > > > > > +int
> > > > > > +xfs_defer_freezer_ijoin(
> > > > > > +	struct xfs_defer_freezer	*dff,
> > > > > > +	struct xfs_inode		*ip)
> > > > > > +{
> > > > > > +	unsigned int			i;
> > > > > > +
> > > > > > +	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
> > > > > > +
> > > > > > +	for (i = 0; i < XFS_DEFER_FREEZER_INODES; i++) {
> > > > > > +		if (dff->dff_inodes[i] == ip)
> > > > > > +			goto out;
> > > > > > +		if (dff->dff_inodes[i] == NULL)
> > > > > > +			break;
> > > > > > +	}
> > > > > > +
> > > > > > +	if (i == XFS_DEFER_FREEZER_INODES) {
> > > > > > +		ASSERT(0);
> > > > > > +		return -EFSCORRUPTED;
> > > > > > +	}
> > > > > > +
> > > > > > +	/*
> > > > > > +	 * Attach this inode to the freezer and drop its ILOCK because we
> > > > > > +	 * assume the caller will need to allocate a transaction.
> > > > > > +	 */
> > > > > > +	dff->dff_inodes[i] = ip;
> > > > > > +	dff->dff_ilocks[i] = 0;
> > > > > > +out:
> > > > > > +	xfs_iunlock(ip, XFS_ILOCK_EXCL);
> > > > > > +	return 0;
> > > > > > +}
> > > > > > diff --git a/fs/xfs/libxfs/xfs_defer.h b/fs/xfs/libxfs/xfs_defer.h
> > > > > > index 7ae05e10d750..0052a0313283 100644
> > > > > > --- a/fs/xfs/libxfs/xfs_defer.h
> > > > > > +++ b/fs/xfs/libxfs/xfs_defer.h
> > > > > > @@ -76,6 +76,11 @@ struct xfs_defer_freezer {
> > > > > >  	/* Deferred ops state saved from the transaction. */
> > > > > >  	struct list_head	dff_dfops;
> > > > > >  	unsigned int		dff_tpflags;
> > > > > > +
> > > > > > +	/* Inodes to hold when we want to finish the deferred work items. */
> > > > > > +#define XFS_DEFER_FREEZER_INODES	2
> > > > > > +	unsigned int		dff_ilocks[XFS_DEFER_FREEZER_INODES];
> > > > > > +	struct xfs_inode	*dff_inodes[XFS_DEFER_FREEZER_INODES];
> > > > > >  };
> > > > > >  
> > > > > >  /* Functions to freeze a chain of deferred operations for later. */
> > > > > > @@ -83,5 +88,10 @@ int xfs_defer_freeze(struct xfs_trans *tp, struct xfs_defer_freezer **dffp);
> > > > > >  void xfs_defer_thaw(struct xfs_defer_freezer *dff, struct xfs_trans *tp);
> > > > > >  void xfs_defer_freeezer_finish(struct xfs_mount *mp,
> > > > > >  		struct xfs_defer_freezer *dff);
> > > > > > +int xfs_defer_freezer_ijoin(struct xfs_defer_freezer *dff,
> > > > > > +		struct xfs_inode *ip);
> > > > > > +
> > > > > > +/* These functions must be provided by the xfs implementation. */
> > > > > > +void xfs_defer_freezer_irele(struct xfs_defer_freezer *dff);
> > > > > >  
> > > > > >  #endif /* __XFS_DEFER_H__ */
> > > > > > diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
> > > > > > index c733bdeeeb9b..bbce191d8fcd 100644
> > > > > > --- a/fs/xfs/xfs_bmap_item.c
> > > > > > +++ b/fs/xfs/xfs_bmap_item.c
> > > > > > @@ -530,12 +530,13 @@ xfs_bui_item_recover(
> > > > > >  	}
> > > > > >  
> > > > > >  	error = xlog_recover_trans_commit(tp, dffp);
> > > > > > -	xfs_iunlock(ip, XFS_ILOCK_EXCL);
> > > > > > -	xfs_irele(ip);
> > > > > > -	return error;
> > > > > > +	if (error)
> > > > > > +		goto err_rele;
> > > > > > +	return xfs_defer_freezer_ijoin(*dffp, ip);
> > > > > >  
> > > > > >  err_inode:
> > > > > >  	xfs_trans_cancel(tp);
> > > > > > +err_rele:
> > > > > >  	if (ip) {
> > > > > >  		xfs_iunlock(ip, XFS_ILOCK_EXCL);
> > > > > >  		xfs_irele(ip);
> > > > > > diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> > > > > > index 17a0b86fe701..b96ddf5ff334 100644
> > > > > > --- a/fs/xfs/xfs_icache.c
> > > > > > +++ b/fs/xfs/xfs_icache.c
> > > > > > @@ -12,6 +12,7 @@
> > > > > >  #include "xfs_sb.h"
> > > > > >  #include "xfs_mount.h"
> > > > > >  #include "xfs_inode.h"
> > > > > > +#include "xfs_defer.h"
> > > > > >  #include "xfs_trans.h"
> > > > > >  #include "xfs_trans_priv.h"
> > > > > >  #include "xfs_inode_item.h"
> > > > > > @@ -1847,3 +1848,21 @@ xfs_start_block_reaping(
> > > > > >  	xfs_queue_eofblocks(mp);
> > > > > >  	xfs_queue_cowblocks(mp);
> > > > > >  }
> > > > > > +
> > > > > > +/* Release all the inode resources attached to this freezer. */
> > > > > > +void
> > > > > > +xfs_defer_freezer_irele(
> > > > > > +	struct xfs_defer_freezer	*dff)
> > > > > > +{
> > > > > > +	unsigned int			i;
> > > > > > +
> > > > > > +	for (i = 0; i < XFS_DEFER_FREEZER_INODES; i++) {
> > > > > > +		if (!dff->dff_inodes[i])
> > > > > > +			break;
> > > > > > +
> > > > > > +		if (dff->dff_ilocks[i])
> > > > > > +			xfs_iunlock(dff->dff_inodes[i], dff->dff_ilocks[i]);
> > > > > > +		xfs_irele(dff->dff_inodes[i]);
> > > > > > +		dff->dff_inodes[i] = NULL;
> > > > > > +	}
> > > > > > +}
> > > > > > 
> > > > > 
> > > > 
> > > 
> > 
> 
