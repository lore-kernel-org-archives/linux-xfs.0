Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 101FA29E09
	for <xfs@oss.sgi.com>; Fri,  6 Dec 2013 23:52:03 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id D41098F8050
	for <xfs@oss.sgi.com>; Fri,  6 Dec 2013 21:52:02 -0800 (PST)
Message-ID: <52A2B75C.3040803@oracle.com>
Date: Sat, 07 Dec 2013 13:51:24 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: Re: [PATCH v2 2/3] xfs: fix infinite loop by detaching the
	group/project hints from user dquot
References: <5294A469.1060000@oracle.com>	<20131128104336.GE26927@infradead.org>	<52986001.9040101@oracle.com>
	<20131206210137.GT1935@sgi.com>
In-Reply-To: <20131206210137.GT1935@sgi.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Ben Myers <bpm@sgi.com>, Christoph Hellwig <hch@infradead.org>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

Hi Ben,

On 12/07 2013 05:01 AM, Ben Myers wrote:
> Hey Jeff,
> 
> On Fri, Nov 29, 2013 at 05:36:01PM +0800, Jeff Liu wrote:
>> On 11/28 2013 18:43 PM, Christoph Hellwig wrote:
>>> On Tue, Nov 26, 2013 at 09:38:49PM +0800, Jeff Liu wrote:
>>>> +	if (flags & XFS_QMOPT_UQUOTA)
>>>> +		return xfs_qm_dqpurge(dqp, NULL);
>>>
>>> To me it doesn't make any sense to overload this function for the user
>>> quotas that don't have hints.
>> To me it would like a silly compromise.
>>>
>>> I'd suggest dropping this hunk and keeping a separate walk for
>>> releasing the uquots.
>> I thought this over and yup, that is an overload if neither group nor project
>> are enabled, or we don't want to turn user quota off.
>>
>> But even so, we currently also have overloads by checking group/project hints
>> before releasing any type of quota in xfs_qm_purge().  In this point, this fix
>> can reduce a bit overloads by moving those checkups to xfs_qm_purge_hints() if
>> we want to turn group/project quotas off.
>>
>> If we considering to drop above hunk to release user quota separately, we finally
>> would have to walk through user quota to remove those hints again, i.e,
>>
>> /* Remove group/project hints from user dquot */
>> STATIC int
>> xfs_qm_dqpurge_hints(
>> 	struct xfs_dquot        *dqp,
>> 	void                    *data)
>> {
>> 	uint                    flags = *((uint *)data);
>> 	struct xfs_dquot        *gdqp;
>> 	struct xfs_dquot        *pdqp;
>>
>> 	xfs_dqlock(dqp);
>> 	if (dqp->dq_flags & XFS_DQ_FREEING) {
>> 		xfs_dqunlock(dqp);
>> 		return EAGAIN;
>> 	}
>>
>> 	/* If this quota has a hint attached, prepare for releasing it now */
>>         gdqp = dqp->q_gdquot;
>> 	if (gdqp)
>> 		dqp->q_gdquot = NULL;
>>
>> 	pdqp = dqp->q_pdquot;
>> 	if (pdqp)
>> 		dqp->q_pdquot = NULL;
>>
>> 	xfs_dqunlock(dqp);
>>
>> 	if (gdqp)
>> 		xfs_qm_dqrele(gdqp);
>> 	if (pdqp)
>> 		xfs_qm_dqrele(pdqp);
>>
>> 	return 0;
>> }
>>
>> void
>> xfs_qm_dqpurge_all()
>> {
>> 	xfs_qm_dquot_walk(mp, XFS_DQ_USER, xfs_qm_dqpurge_hints, NULL);
>>
>> 	if (flags & XFS_QMOPT_UQUOTA)
>> 		xfs_qm_dquot_walk(mp, XFS_DQ_USER, xfs_qm_dqpurge, NULL);
>> 	if (flags & XFS_QMOPT_GQUOTA)
>> 		xfs_qm_dquot_walk(mp, XFS_DQ_GROUP, xfs_qm_dqpurge, NULL);
>> 	if (flags & XFS_QMOPT_PQUOTA)
>> 		xfs_qm_dquot_walk(mp, XFS_DQ_PROJ, xfs_qm_dqpurge, NULL);
>> }
>>
>> Above code is what I can figured out as per your suggestions for now, but it
>> would introduce overheads for walking through user dquots to release hints
>> separately if we want to turn user quota off.
>>
>> Any thoughts?
> 
> I was gonna pull in the single walk version, but now I realize that it is still
> under discussion.  I'm happy with either implementation, with maybe a slight
> preference for a single user quota walk.  Can you and Christoph come to an
> agreement?
For now, I can not figure out a more optimized solution.  Well, I just realized
I don't need to initialize both gdqp and pdqp to NULL at xfs_qm_dqpurge_hints()
since they will be evaluated by dqp pointers dereference anyway.  As a minor fix,
the revised version was shown as follows.

Christoph, as I mentioned previously, keeping a separate walk to release the user
dquots would also have overloads in some cases, would you happy to have this fix
although it is not most optimized?

Also, Ben, would you please pull in another fix below? It is independent to the
current fix and it has already been reviewed by Christoph. :)
[PATCH v2 1/3] xfs: fix assertion failure at xfs_setattr_nonsize

Thanks,
-Jeff

From: Jie Liu <jeff.liu@oracle.com>

xfs_quota(8) will hang up if trying to turn group/project quota off
before the user quota is off, this could be 100% reproduced by:
  # mount -ouquota,gquota /dev/sda7 /xfs
  # mkdir /xfs/test
  # xfs_quota -xc 'off -g' /xfs <-- hangs up
  # echo w > /proc/sysrq-trigger
  # dmesg

  SysRq : Show Blocked State
  task                        PC stack   pid father
  xfs_quota       D 0000000000000000     0 27574   2551 0x00000000
  [snip]
  Call Trace:
  [<ffffffff81aaa21d>] schedule+0xad/0xc0
  [<ffffffff81aa327e>] schedule_timeout+0x35e/0x3c0
  [<ffffffff8114b506>] ? mark_held_locks+0x176/0x1c0
  [<ffffffff810ad6c0>] ? call_timer_fn+0x2c0/0x2c0
  [<ffffffffa0c25380>] ? xfs_qm_shrink_count+0x30/0x30 [xfs]
  [<ffffffff81aa3306>] schedule_timeout_uninterruptible+0x26/0x30
  [<ffffffffa0c26155>] xfs_qm_dquot_walk+0x235/0x260 [xfs]
  [<ffffffffa0c059d8>] ? xfs_perag_get+0x1d8/0x2d0 [xfs]
  [<ffffffffa0c05805>] ? xfs_perag_get+0x5/0x2d0 [xfs]
  [<ffffffffa0b7707e>] ? xfs_inode_ag_iterator+0xae/0xf0 [xfs]
  [<ffffffffa0c22280>] ? xfs_trans_free_dqinfo+0x50/0x50 [xfs]
  [<ffffffffa0b7709f>] ? xfs_inode_ag_iterator+0xcf/0xf0 [xfs]
  [<ffffffffa0c261e6>] xfs_qm_dqpurge_all+0x66/0xb0 [xfs]
  [<ffffffffa0c2497a>] xfs_qm_scall_quotaoff+0x20a/0x5f0 [xfs]
  [<ffffffffa0c2b8f6>] xfs_fs_set_xstate+0x136/0x180 [xfs]
  [<ffffffff8136cf7a>] do_quotactl+0x53a/0x6b0
  [<ffffffff812fba4b>] ? iput+0x5b/0x90
  [<ffffffff8136d257>] SyS_quotactl+0x167/0x1d0
  [<ffffffff814cf2ee>] ? trace_hardirqs_on_thunk+0x3a/0x3f
  [<ffffffff81abcd19>] system_call_fastpath+0x16/0x1b

It's fine if we turn user quota off at first, then turn off other
kind of quotas if they are enabled since the group/project dquot
refcount is decreased to zero once the user quota if off. Otherwise,
those dquots refcount is non-zero due to the user dquot might refer
to them as hint(s).  Hence, above operation cause an infinite loop
at xfs_qm_dquot_walk() while trying to purge dquot cache.

This problem has been around since Linux 3.4, it was introduced by:
  [ b84a3a9675 xfs: remove the per-filesystem list of dquots ]

Originally we will release the group dquot pointers because the user
dquots maybe carrying around as a hint via xfs_qm_detach_gdquots().
However, with above change, there is no such work to be done before
purging group/project dquot cache.

In order to solve this problem, this patch introduces a special routine
xfs_qm_dqpurge_hints(), and it would release the group/project dquot
pointers the user dquots maybe carrying around as a hint, and then it
will proceed to purge the user dquot cache if requested.

Cc: stable@vger.kernel.org
Signed-off-by: Jie Liu <jeff.liu@oracle.com>
---
 fs/xfs/xfs_qm.c | 71 ++++++++++++++++++++++++++++++++++++++++-----------------
 1 file changed, 50 insertions(+), 21 deletions(-)

diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index 14a4996..424ef73 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -134,8 +134,6 @@ xfs_qm_dqpurge(
 {
 	struct xfs_mount	*mp = dqp->q_mount;
 	struct xfs_quotainfo	*qi = mp->m_quotainfo;
-	struct xfs_dquot	*gdqp = NULL;
-	struct xfs_dquot	*pdqp = NULL;
 
 	xfs_dqlock(dqp);
 	if ((dqp->dq_flags & XFS_DQ_FREEING) || dqp->q_nrefs != 0) {
@@ -143,21 +141,6 @@ xfs_qm_dqpurge(
 		return EAGAIN;
 	}
 
-	/*
-	 * If this quota has a hint attached, prepare for releasing it now.
-	 */
-	gdqp = dqp->q_gdquot;
-	if (gdqp) {
-		xfs_dqlock(gdqp);
-		dqp->q_gdquot = NULL;
-	}
-
-	pdqp = dqp->q_pdquot;
-	if (pdqp) {
-		xfs_dqlock(pdqp);
-		dqp->q_pdquot = NULL;
-	}
-
 	dqp->dq_flags |= XFS_DQ_FREEING;
 
 	xfs_dqflock(dqp);
@@ -206,11 +189,47 @@ xfs_qm_dqpurge(
 	XFS_STATS_DEC(xs_qm_dquot_unused);
 
 	xfs_qm_dqdestroy(dqp);
+	return 0;
+}
+
+/*
+ * Release the group or project dquot pointers the user dquots maybe carrying
+ * around as a hint, and proceed to purge the user dquot cache if requested.
+*/
+STATIC int
+xfs_qm_dqpurge_hints(
+	struct xfs_dquot	*dqp,
+	void			*data)
+{
+	uint			flags = *((uint *)data);
+	struct xfs_dquot	*gdqp;
+	struct xfs_dquot	*pdqp;
 
+	xfs_dqlock(dqp);
+	if (dqp->dq_flags & XFS_DQ_FREEING) {
+		xfs_dqunlock(dqp);
+		return EAGAIN;
+	}
+
+	/* If this quota has a hint attached, prepare for releasing it now */
+	gdqp = dqp->q_gdquot;
 	if (gdqp)
-		xfs_qm_dqput(gdqp);
+		dqp->q_gdquot = NULL;
+
+	pdqp = dqp->q_pdquot;
 	if (pdqp)
-		xfs_qm_dqput(pdqp);
+		dqp->q_pdquot = NULL;
+
+	xfs_dqunlock(dqp);
+
+	if (gdqp)
+		xfs_qm_dqrele(gdqp);
+	if (pdqp)
+		xfs_qm_dqrele(pdqp);
+
+	if (flags & XFS_QMOPT_UQUOTA)
+		return xfs_qm_dqpurge(dqp, NULL);
+
 	return 0;
 }
 
@@ -222,8 +241,18 @@ xfs_qm_dqpurge_all(
 	struct xfs_mount	*mp,
 	uint			flags)
 {
-	if (flags & XFS_QMOPT_UQUOTA)
-		xfs_qm_dquot_walk(mp, XFS_DQ_USER, xfs_qm_dqpurge, NULL);
+	/*
+	 * We have to release group/project dquot hint(s) from the user dquot
+	 * at first if they are there, otherwise we would run into an infinite
+	 * loop while walking through radix tree to purge other type of dquots
+	 * since their refcount is not zero if the user dquot refers to them
+	 * as hint.
+	 *
+	 * Call the special xfs_qm_dqpurge_hints() will end up go through the
+	 * general xfs_qm_dqpurge() against user dquot cache if requested.
+	 */
+	xfs_qm_dquot_walk(mp, XFS_DQ_USER, xfs_qm_dqpurge_hints, &flags);
+
 	if (flags & XFS_QMOPT_GQUOTA)
 		xfs_qm_dquot_walk(mp, XFS_DQ_GROUP, xfs_qm_dqpurge, NULL);
 	if (flags & XFS_QMOPT_PQUOTA)
-- 1.8.3.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
