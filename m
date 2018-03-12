Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45092 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932231AbeCLRf5 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 12 Mar 2018 13:35:57 -0400
Date: Mon, 12 Mar 2018 13:35:53 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH RFC] xfs: convert between packed and unpacked agfls
 on-demand
Message-ID: <20180312173552.GA30332@bfoster.bfoster>
References: <20180307192451.24196-1-bfoster@redhat.com>
 <20180308140354.pk25gd54cqjzbecs@odin.usersys.redhat.com>
 <20180309131628.GA3445@bfoster.bfoster>
 <20180309173318.GD18989@magnolia>
 <20180309183727.GA17046@bfoster.bfoster>
 <20180309190832.GH18989@magnolia>
 <20180309212031.GA19019@bfoster.bfoster>
 <20180309223757.GA4865@magnolia>
 <20180312131157.GA29810@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180312131157.GA29810@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org, Eric Sandeen <sandeen@redhat.com>

On Mon, Mar 12, 2018 at 09:11:58AM -0400, Brian Foster wrote:
> On Fri, Mar 09, 2018 at 02:37:57PM -0800, Darrick J. Wong wrote:
> > On Fri, Mar 09, 2018 at 04:20:31PM -0500, Brian Foster wrote:
> > > On Fri, Mar 09, 2018 at 11:08:32AM -0800, Darrick J. Wong wrote:
> > > > On Fri, Mar 09, 2018 at 01:37:28PM -0500, Brian Foster wrote:
> > > > > On Fri, Mar 09, 2018 at 09:33:18AM -0800, Darrick J. Wong wrote:
...
> > <nod> I've been mulling over rewriting your previous rfc patch that put
> > all the scanning/lifting in {get,put}_freelist but having it reset the
> > agfl instead of doing the swizzling stuff.
> > 
> 
> Something to be careful of... emptying the agfl obviously means the
> subsequent fixup is a btree block allocation. That may limit the context
> of where the fixup can be performed. IOW, deferring it to
> _get_freelist() might no longer be safe. Instead, I think we'd have to
> implement it such that the on-disk flcount is completely untrusted when
> the mismatch is detected.
> 
...

Here's a variant of that patch that does a reset. It's definitely much
simpler. Thoughts?

Brian

--- 8< ---

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index c02781a4c091..7d313bb4677d 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -2053,6 +2053,59 @@ xfs_alloc_space_available(
 	return true;
 }
 
+static bool
+xfs_agf_verify_flcount(
+	struct xfs_mount	*mp,
+	struct xfs_agf		*agf)
+{
+	int			f = be32_to_cpu(agf->agf_flfirst);
+	int			l = be32_to_cpu(agf->agf_fllast);
+	int			c = be32_to_cpu(agf->agf_flcount);
+	int			active = c;
+	int			agfl_size = XFS_AGFL_SIZE(mp);
+
+	if (!xfs_sb_version_hascrc(&mp->m_sb))
+		return true;
+
+	if (c && l >= f)
+		active = l - f + 1;
+	else if (c)
+		active = agfl_size - f + l + 1;
+
+	if (active != c)
+		return false;
+	if (f >= agfl_size || l >= agfl_size)
+		return false;
+
+	return true;
+}
+
+static void
+xfs_agfl_reset(
+	struct xfs_trans	*tp,
+	struct xfs_buf		*agbp,
+	struct xfs_perag	*pag)
+{
+	struct xfs_mount	*mp = tp->t_mountp;
+	struct xfs_agf		*agf = XFS_BUF_TO_AGF(agbp);
+
+	if (!pag->pagf_needreset)
+		return;
+
+	trace_xfs_agfl_reset(pag);
+	xfs_warn(mp, "agfl reset agno %u flcount %d", pag->pag_agno,
+		 pag->pagf_flcount);
+
+	agf->agf_flfirst = 0;
+	agf->agf_fllast = cpu_to_be32(XFS_AGFL_SIZE(mp) - 1);
+	agf->agf_flcount = 0;
+	xfs_alloc_log_agf(tp, agbp, XFS_AGF_FLFIRST | XFS_AGF_FLLAST |
+				    XFS_AGF_FLCOUNT);
+
+	pag->pagf_flcount = 0;
+	pag->pagf_needreset = false;
+}
+
 /*
  * Decide whether to use this allocation group for this allocation.
  * If so, fix up the btree freelist's size.
@@ -2119,6 +2172,9 @@ xfs_alloc_fix_freelist(
 	if (!xfs_alloc_space_available(args, need, flags))
 		goto out_agbp_relse;
 
+	if (pag->pagf_needreset)
+		xfs_agfl_reset(tp, agbp, pag);
+
 	/*
 	 * Make the freelist shorter if it's too long.
 	 *
@@ -2588,6 +2644,7 @@ xfs_alloc_read_agf(
 		pag->pagb_count = 0;
 		pag->pagb_tree = RB_ROOT;
 		pag->pagf_init = 1;
+		pag->pagf_needreset = !xfs_agf_verify_flcount(mp, agf);
 	}
 #ifdef DEBUG
 	else if (!XFS_FORCED_SHUTDOWN(mp)) {
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index e0792d036be2..5dd36920b7d6 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -353,6 +353,7 @@ typedef struct xfs_perag {
 	char		pagi_inodeok;	/* The agi is ok for inodes */
 	uint8_t		pagf_levels[XFS_BTNUM_AGF];
 					/* # of levels in bno & cnt btree */
+	bool		pagf_needreset;
 	uint32_t	pagf_flcount;	/* count of blocks in freelist */
 	xfs_extlen_t	pagf_freeblks;	/* total free blocks */
 	xfs_extlen_t	pagf_longest;	/* longest free space */
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 945de08af7ba..678d602dc400 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -3339,6 +3339,24 @@ TRACE_EVENT(xfs_trans_resv_calc,
 		  __entry->logflags)
 );
 
+TRACE_EVENT(xfs_agfl_reset,
+	TP_PROTO(struct xfs_perag *pag),
+	TP_ARGS(pag),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_agnumber_t, agno)
+		__field(int, flcount)
+	),
+	TP_fast_assign(
+		__entry->dev = pag->pag_mount->m_super->s_dev;
+		__entry->agno = pag->pag_agno;
+		__entry->flcount = pag->pagf_flcount;
+	),
+	TP_printk("dev %d:%d agno %u flcount %d",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->agno, __entry->flcount)
+);
+
 #endif /* _TRACE_XFS_H */
 
 #undef TRACE_INCLUDE_PATH
