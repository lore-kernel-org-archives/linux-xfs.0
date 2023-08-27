Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82EB6C83F11
	for <linux-xfs@archiver.kernel.org>; Sun, 27 Aug 2023 16:05:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229786AbjH0QFO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 27 Aug 2023 12:05:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229768AbjH0QEe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 27 Aug 2023 12:04:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D077BEB
        for <linux-xfs@vger.kernel.org>; Sun, 27 Aug 2023 09:04:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5DDCB6117C
        for <linux-xfs@vger.kernel.org>; Sun, 27 Aug 2023 16:04:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5D5DC433C8;
        Sun, 27 Aug 2023 16:04:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1693152270;
        bh=ldzFi9QWcEgljn5LrdGa/tSzJvAOuNIwQZfQ9XjrNv0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=CCnNoJ4TN3GnPu6WkeSljMubJBHa2X6zCOgc8Y50tVduXBAjmezg5sAKZbq9CIhLJ
         TmmxzyzveS6oyKLiVe+eiZAsX0FM8vKshd+6Y3NXVRKLglPZmXC1mOH1k8gFk+K1mO
         dkHCAM4sTSREcCy50xlG68Be5q9qYXtESHMlk3/p9UblzVRvZLRKYUN1KFgMpeEnVZ
         M50SJ1ms9NG+S0M/vqPfgFMixxvgSfnXCK+E9+HtXUrOBMYh7Gt+FOOvH4JALtbssJ
         l8nagGlt6rKyl3wEa9yzMtV9HEOMx+cnPjxQEZycvkyM4qtoQZSYuBCGF7NT6E8ng3
         HQopO4s2YjSyA==
Date:   Sun, 27 Aug 2023 09:04:30 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Wengang Wang <wen.gang.wang@oracle.com>,
        "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
        Srikanth C S <srikanth.c.s@oracle.com>
Subject: Re: Question: reserve log space at IO time for recover
Message-ID: <20230827160430.GA28186@frogsfrogsfrogs>
References: <2A3BFAC0-1482-412E-A126-7EAFE65282E8@oracle.com>
 <ZL3MlgtPWx5NHnOa@dread.disaster.area>
 <2D5E234E-3EE3-4040-81DA-576B92FF7401@oracle.com>
 <ZMCcJSLiWIi3KBOl@dread.disaster.area>
 <BED64CCE-93D1-4110-B2C8-903A00D0013C@oracle.com>
 <3B6E1DAE-5191-4050-BE97-75B4D22BDE24@oracle.com>
 <20230824045234.GK11263@frogsfrogsfrogs>
 <ZOcGl/tujTv2MjEr@dread.disaster.area>
 <20230824220154.GA17912@frogsfrogsfrogs>
 <ZOlzdNT/DWb+fmPq@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZOlzdNT/DWb+fmPq@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Aug 26, 2023 at 01:37:24PM +1000, Dave Chinner wrote:
> On Thu, Aug 24, 2023 at 03:01:54PM -0700, Darrick J. Wong wrote:
> > On Thu, Aug 24, 2023 at 05:28:23PM +1000, Dave Chinner wrote:
> > > On Wed, Aug 23, 2023 at 09:52:34PM -0700, Darrick J. Wong wrote:
> > > > On Fri, Aug 18, 2023 at 03:25:46AM +0000, Wengang Wang wrote:
> > > > 
> > > > Since xfs_efi_item_recover is only performing one step of what could be
> > > > a chain of deferred updates, it never rolls the transaction that it
> > > > creates.  It therefore only requires the amount of grant space that
> > > > you'd get with tr_logcount == 1.  It is therefore a bit silly that we
> > > > ask for more than that, and in bad cases like this, hang log recovery
> > > > needlessly.
> > > 
> > > But this doesn't fix the whatever problem lead to the recovery not
> > > having the same full tr_itruncate reservation available as was held
> > > by the transaction that logged the EFI and was running the extent
> > > free at the time the system crashed. There should -always- be enough
> > > transaction reservation space in the journal to reserve space for an
> > > intent replay if the intent recovery reservation uses the same
> > > reservation type as runtime.
> > > 
> > > Hence I think this is still just a band-aid over whatever went wrong
> > > at runtime that lead to the log not having enough space for a
> > > reservation that was clearly held at runtime and hadn't yet used.
> > 
> > Maybe I'm not remembering accurately how permanent log reservations
> > work.  Let's continue picking on tr_itruncate from Wengang's example.
> > IIRC, he said that tr_itruncate on the running system was defined
> > roughly like so:
> > 
> > tr_itruncate = {
> > 	.tr_logres	= 180K
> > 	.tr_logcount	= 2,
> > 	.tr_logflags	= XFS_TRANS_PERM_LOG_RES,
> > }
> > 
> > At runtime, when we want to start a truncation update, we do this:
> > 
> > 	xfs_trans_alloc(mp, &M_RES(mp)->tr_itruncate, ...);
> > 
> > Call sequence: xfs_trans_alloc -> xfs_trans_reserve -> xfs_log_reserve
> > -> xlog_ticket_alloc.  Ticket allocation assigns tic->t_unit_res =
> > (tr_logres + overhead) and tic->t_cnt = tr_logcount.
> > 
> > (Let's pretend for the sake of argument that the overhead is 5K.)
> > 
> > Now xfs_log_reserve calls xlog_grant_head_check.  That does:
> > 
> > 	*need_bytes = xlog_ticket_reservation(log, head, tic);
> > 
> > For the reserve head, the ticket reservation computation is
> > (tic->t_unit_res * tic->t_cnt), which in this case is (185K * 2) ==
> > 370K, right?  So we make sure there's at least 370K free in the reserve
> > head, then add that to the reserve and write heads.
> > 
> > Now that we've allocated the transaction, delete the bmap mapping,
> > log an EFI to free the space, and roll the transaction as part of
> > finishing the deferops chain.  Rolling creates a new xfs_trans which
> > shares its ticket with the old transaction.  Next, xfs_trans_roll calls
> > __xfs_trans_commit with regrant == true, which calls xlog_cil_commit
> > with the same regrant parameter.
> > 
> > xlog_cil_commit calls xfs_log_ticket_regrant, which decrements t_cnt and
> > subtracts t_curr_res from the reservation and write heads.
> > 
> > If the filesystem is fresh and the first transaction only used (say)
> > 20K, then t_curr_res will be 165K, and we give that much reservation
> > back to the reservation head.  Or if the file is really fragmented and
> > the first transaction actually uses 170K, then t_curr_res will be 15K,
> > and that's what we give back to the reservation.
> > 
> > Having done that, we're now headed into the second transaction with an
> > EFI and 185K of reservation, correct?
> 
> Ah, right, I overlooked that the long running truncates only regrant a
> single reservation unit at a time when they roll, and the runtime
> instances I seen of this are with long running truncate operations
> (i.e. inactivation after unlink for multi-thousand extent inodes).
> 
> So, yes, all types of intent recovery must only use a single unit
> reservation, not just EFIs, because there is no guarantee that there
> is a full unit * count reservation available in the journal whenever
> that intent was first logged. Indeed, at best it will be 'count - 1'
> that is avaialble, becuase the transaction that logged the intent
> will have used a full unit of the original reservation....

<nod> I think something like this will fix the problem, right?

diff --git a/fs/xfs/libxfs/xfs_log_recover.h b/fs/xfs/libxfs/xfs_log_recover.h
index 2420865f3007..a5100a11faf9 100644
--- a/fs/xfs/libxfs/xfs_log_recover.h
+++ b/fs/xfs/libxfs/xfs_log_recover.h
@@ -131,4 +131,26 @@ void xlog_check_buf_cancel_table(struct xlog *log);
 #define xlog_check_buf_cancel_table(log) do { } while (0)
 #endif
 
+/*
+ * Transform a regular reservation into one suitable for recovery of a log
+ * intent item.
+ *
+ * Intent recovery only runs a single step of the transaction chain and defers
+ * the rest to a separate transaction.  Therefore, we reduce logcount to 1 here
+ * to avoid livelocks if the log grant space is nearly exhausted due to the
+ * recovered intent pinning the tail.  Keep the same logflags to avoid tripping
+ * asserts elsewhere.  Struct copies abound below.
+ */
+static inline struct xfs_trans_res
+xlog_recover_resv(const struct xfs_trans_res *r)
+{
+	struct xfs_trans_res ret = {
+		.tr_logres	= r->tr_logres,
+		.tr_logcount	= 1,
+		.tr_logflags	= r->tr_logflags,
+	};
+
+	return ret;
+}
+
 #endif	/* __XFS_LOG_RECOVER_H__ */
diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
index 2788a6f2edcd..36fe2abb16e6 100644
--- a/fs/xfs/xfs_attr_item.c
+++ b/fs/xfs/xfs_attr_item.c
@@ -547,7 +547,7 @@ xfs_attri_item_recover(
 	struct xfs_inode		*ip;
 	struct xfs_da_args		*args;
 	struct xfs_trans		*tp;
-	struct xfs_trans_res		tres;
+	struct xfs_trans_res		resv;
 	struct xfs_attri_log_format	*attrp;
 	struct xfs_attri_log_nameval	*nv = attrip->attri_nameval;
 	int				error;
@@ -618,8 +618,9 @@ xfs_attri_item_recover(
 		goto out;
 	}
 
-	xfs_init_attr_trans(args, &tres, &total);
-	error = xfs_trans_alloc(mp, &tres, total, 0, XFS_TRANS_RESERVE, &tp);
+	xfs_init_attr_trans(args, &resv, &total);
+	resv = xlog_recover_resv(&resv);
+	error = xfs_trans_alloc(mp, &resv, total, 0, XFS_TRANS_RESERVE, &tp);
 	if (error)
 		goto out;
 
diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
index 7551c3ec4ea5..e736a0844c89 100644
--- a/fs/xfs/xfs_bmap_item.c
+++ b/fs/xfs/xfs_bmap_item.c
@@ -490,6 +490,7 @@ xfs_bui_item_recover(
 	struct list_head		*capture_list)
 {
 	struct xfs_bmap_intent		fake = { };
+	struct xfs_trans_res		resv;
 	struct xfs_bui_log_item		*buip = BUI_ITEM(lip);
 	struct xfs_trans		*tp;
 	struct xfs_inode		*ip = NULL;
@@ -515,7 +516,8 @@ xfs_bui_item_recover(
 		return error;
 
 	/* Allocate transaction and do the work. */
-	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_itruncate,
+	resv = xlog_recover_resv(&M_RES(mp)->tr_itruncate);
+	error = xfs_trans_alloc(mp, &resv,
 			XFS_EXTENTADD_SPACE_RES(mp, XFS_DATA_FORK), 0, 0, &tp);
 	if (error)
 		goto err_rele;
diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
index f1a5ecf099aa..3fa8789820ad 100644
--- a/fs/xfs/xfs_extfree_item.c
+++ b/fs/xfs/xfs_extfree_item.c
@@ -660,6 +660,7 @@ xfs_efi_item_recover(
 	struct xfs_log_item		*lip,
 	struct list_head		*capture_list)
 {
+	struct xfs_trans_res		resv;
 	struct xfs_efi_log_item		*efip = EFI_ITEM(lip);
 	struct xfs_mount		*mp = lip->li_log->l_mp;
 	struct xfs_efd_log_item		*efdp;
@@ -683,7 +684,8 @@ xfs_efi_item_recover(
 		}
 	}
 
-	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_itruncate, 0, 0, 0, &tp);
+	resv = xlog_recover_resv(&M_RES(mp)->tr_itruncate);
+	error = xfs_trans_alloc(mp, &resv, 0, 0, 0, &tp);
 	if (error)
 		return error;
 	efdp = xfs_trans_get_efd(tp, efip, efip->efi_format.efi_nextents);
diff --git a/fs/xfs/xfs_refcount_item.c b/fs/xfs/xfs_refcount_item.c
index edd8587658d5..2d4444d61e98 100644
--- a/fs/xfs/xfs_refcount_item.c
+++ b/fs/xfs/xfs_refcount_item.c
@@ -477,6 +477,7 @@ xfs_cui_item_recover(
 	struct xfs_log_item		*lip,
 	struct list_head		*capture_list)
 {
+	struct xfs_trans_res		resv;
 	struct xfs_cui_log_item		*cuip = CUI_ITEM(lip);
 	struct xfs_cud_log_item		*cudp;
 	struct xfs_trans		*tp;
@@ -514,8 +515,9 @@ xfs_cui_item_recover(
 	 * doesn't fit.  We need to reserve enough blocks to handle a
 	 * full btree split on either end of the refcount range.
 	 */
-	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_itruncate,
-			mp->m_refc_maxlevels * 2, 0, XFS_TRANS_RESERVE, &tp);
+	resv = xlog_recover_resv(&M_RES(mp)->tr_itruncate);
+	error = xfs_trans_alloc(mp, &resv, mp->m_refc_maxlevels * 2, 0,
+			XFS_TRANS_RESERVE, &tp);
 	if (error)
 		return error;
 
diff --git a/fs/xfs/xfs_rmap_item.c b/fs/xfs/xfs_rmap_item.c
index 520c7ebdfed8..0e0e747028da 100644
--- a/fs/xfs/xfs_rmap_item.c
+++ b/fs/xfs/xfs_rmap_item.c
@@ -507,6 +507,7 @@ xfs_rui_item_recover(
 	struct xfs_log_item		*lip,
 	struct list_head		*capture_list)
 {
+	struct xfs_trans_res		resv;
 	struct xfs_rui_log_item		*ruip = RUI_ITEM(lip);
 	struct xfs_rud_log_item		*rudp;
 	struct xfs_trans		*tp;
@@ -530,8 +531,9 @@ xfs_rui_item_recover(
 		}
 	}
 
-	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_itruncate,
-			mp->m_rmap_maxlevels, 0, XFS_TRANS_RESERVE, &tp);
+	resv = xlog_recover_resv(&M_RES(mp)->tr_itruncate);
+	error = xfs_trans_alloc(mp, &resv, mp->m_rmap_maxlevels, 0,
+			XFS_TRANS_RESERVE, &tp);
 	if (error)
 		return error;
 	rudp = xfs_trans_get_rud(tp, ruip);

> > IOWs, I'm operating on an assumption that we have two problems to solve:
> > the runtime acconting bug that you've been chasing, and Wengang's where
> > log recovery asks for more log space than what had been in the log
> > ticket at the time of the crash.
> 
> OK, yes, it does seem there are two problems here...
> 
> > > I suspect that the cause of this recovery issue is the we require an
> > > overcommit of the log space accounting before we throttle incoming
> > > transaction reservations (i.e. the new reservation has to overrun
> > > before we throttle). I think that the reservation accounting overrun
> > > detection can race to the first item being placed on the wait list,
> > 
> > Yeah, I was wondering that myself when I was looking at the logic
> > between list_empty_careful and the second xlog_grant_head_wait and
> > wondering if that "careful" construction actually worked.
> 
> Well, it's not the careful check that is the problem; the race is
> much simpler than that. We just have to have two concurrent
> reservations that will both fit in the remaining log space
> individually but not together. i.e. this is the overcommit race
> window:
> 
> P1				P2
> ---------------------------	--------------------------
> xfs_log_reserve(10000 bytes)
>   xlog_grant_head_check()
>     xlog_space_left()
>       <sees 12000 bytes>
>     OK, doesn't wait
>   				xfs_log_reserve(10000 bytes)
> 				  xlog_grant_head_check()
> 				    xlog_space_left()
> 				      <sees 12000 bytes>
> 				    OK, doesn't wait
>     xlog_grant_add_space(10k)
>     				  xlog_grant_add_space(10k)
> 
> And now we've overcommitted the log by 8000 bytes....
> 
> The current byte based grant head patch set does not address this;
> the attempt I made to fix it didn't work properly, so I split the
> rework of the throttling out of the byte based accounting patchset
> (which seems to work correctly without reworking
> xlog_grant_head_check()) and now I'm trying to address this race
> condition as a separate patchset...

Oh.  Heh.  Yeah.

--D

> -Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
