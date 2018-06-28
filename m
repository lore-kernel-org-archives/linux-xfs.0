Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail03.adl2.internode.on.net ([150.101.137.141]:43460 "EHLO
        ipmail03.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932883AbeF1XVT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 28 Jun 2018 19:21:19 -0400
Date: Fri, 29 Jun 2018 09:21:15 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 04/21] xfs: repair the AGF and AGFL
Message-ID: <20180628232115.GD2234@dastard>
References: <152986820984.3155.16417868536016544528.stgit@magnolia>
 <152986823481.3155.13034509035761369722.stgit@magnolia>
 <824fc014-2af0-dcad-6bd1-d765f6cb2be9@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <824fc014-2af0-dcad-6bd1-d765f6cb2be9@oracle.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Allison Henderson <allison.henderson@oracle.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org

On Thu, Jun 28, 2018 at 02:14:51PM -0700, Allison Henderson wrote:
> On 06/24/2018 12:23 PM, Darrick J. Wong wrote:
> >+static const struct xfs_repair_find_ag_btree repair_agf[] = {
> >+	[REPAIR_AGF_BNOBT] = {
> >+		.rmap_owner = XFS_RMAP_OWN_AG,
> >+		.buf_ops = &xfs_allocbt_buf_ops,
> >+		.magic = XFS_ABTB_CRC_MAGIC,
> >+	},
> >+	[REPAIR_AGF_CNTBT] = {
> >+		.rmap_owner = XFS_RMAP_OWN_AG,
> >+		.buf_ops = &xfs_allocbt_buf_ops,
> >+		.magic = XFS_ABTC_CRC_MAGIC,
> >+	},
> >+	[REPAIR_AGF_RMAPBT] = {
> >+		.rmap_owner = XFS_RMAP_OWN_AG,
> >+		.buf_ops = &xfs_rmapbt_buf_ops,
> >+		.magic = XFS_RMAP_CRC_MAGIC,
> >+	},
> >+	[REPAIR_AGF_REFCOUNTBT] = {
> >+		.rmap_owner = XFS_RMAP_OWN_REFC,
> >+		.buf_ops = &xfs_refcountbt_buf_ops,
> >+		.magic = XFS_REFC_CRC_MAGIC,
> >+	},
> >+	[REPAIR_AGF_END] = {
> >+		.buf_ops = NULL,
> >+	},
> >+};
> >+
> >+/*
> >+ * Find the btree roots.  This is /also/ a chicken and egg problem because we
> >+ * have to use the rmapbt (rooted in the AGF) to find the btrees rooted in the
> >+ * AGF.  We also have no idea if the btrees make any sense.  If we hit obvious
> >+ * corruptions in those btrees we'll bail out.
> >+ */
> It would help if maybe we could put the /*IN*/ or /*OUT*/ on the
> parameters here?  And maybe a blurb about their usage.  From looking
> at how their used in the memcpy, I'm guessing that agf_bp is IN and
> fab is OUT.  But it's otherwise its not really clear on how they're
> meant to be used with out going the function to see how it handles
> them.

IMO, that's what kerneldoc format comments are for. I'd much prefer
we use kerneldoc format than go back to the bad old terse 3-4 word
post-variable declaration comments that we used to have.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
