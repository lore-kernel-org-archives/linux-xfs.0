Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmailnode02.adl6.internode.on.net ([150.101.137.148]:27234
        "EHLO ipmailnode02.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752210AbeF0Xhs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 27 Jun 2018 19:37:48 -0400
Date: Thu, 28 Jun 2018 09:37:20 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 04/21] xfs: repair the AGF and AGFL
Message-ID: <20180627233720.GA2234@dastard>
References: <152986820984.3155.16417868536016544528.stgit@magnolia>
 <152986823481.3155.13034509035761369722.stgit@magnolia>
 <20180627021908.GD19934@dastard>
 <e2261ffd-1d03-b205-1375-25bef625c3f6@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e2261ffd-1d03-b205-1375-25bef625c3f6@oracle.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Allison Henderson <allison.henderson@oracle.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org

On Wed, Jun 27, 2018 at 09:44:53AM -0700, Allison Henderson wrote:
> On 06/26/2018 07:19 PM, Dave Chinner wrote:
> >On Sun, Jun 24, 2018 at 12:23:54PM -0700, Darrick J. Wong wrote:
> >>From: Darrick J. Wong <darrick.wong@oracle.com>
> >>
> >>Regenerate the AGF and AGFL from the rmap data.
> >>
> >>Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> >
> >[...]

> >>+	/* Record all the OWN_AG blocks. */
> >>+	if (rec->rm_owner == XFS_RMAP_OWN_AG) {
> >>+		fsb = XFS_AGB_TO_FSB(cur->bc_mp, cur->bc_private.a.agno,
> >>+				rec->rm_startblock);
> >>+		error = xfs_repair_collect_btree_extent(ra->sc,
> >>+				ra->freesp_list, fsb, rec->rm_blockcount);
> >>+		if (error)
> >>+			return error;
> >>+	}
> >>+
> >>+	return xfs_repair_collect_btree_cur_blocks(ra->sc, cur,
> >>+			xfs_repair_collect_btree_cur_blocks_in_extent_list,
> >
> >Urk. The function name lengths is getting out of hand. I'm very
> >tempted to suggest we should shorten the namespace of all this
> >like s/xfs_repair_/xr_/ and s/xfs_scrub_/xs_/, etc just to make them
> >shorter and easier to read.
> >
> >Oh, wait, did I say that out loud? :P
> >
> >Something to think about, anyway.
> >
> Well they are sort of long, but TBH I think i still kind of
> appreciate the extra verbiage.  I have seen other projects do things
> like adopt a sort of 3 or 4 letter abbreviation (like maybe xfs_scrb
> or xfs_repr). Helps to cut down on the verbosity while still not
> loosing too much of what it is supposed to mean.  Just another idea
> to consider. :-)

We've got that in places, too, like "xlog_" prefixes for all the log
code, so that's not an unreasonable thing to suggest. After all, in
many cases we're talking about a tradeoff between readabilty and the
amount of typing necessary.

However, IMO, function names so long they need a line of their own
indicates we have a structural problem in our code, not a
readability problem. We should not need names that long to document
what the function does - it should be obvious from the context, the
abstraction that is being used and a short name....

e.g. how many of these different "collect extent" operations could
be abstracted into a common extent list structure and generic
callbacks? It seems there's a lot of similarity in them, and we're
really only differentiating them by adding more namespace and
context specific information into the structure and function names.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
