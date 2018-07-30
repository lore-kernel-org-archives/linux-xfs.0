Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:52960 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728798AbeG3OL2 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 30 Jul 2018 10:11:28 -0400
Date: Mon, 30 Jul 2018 08:36:37 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 2/2] xfs: verify icount in superblock write
Message-ID: <20180730123636.GA34351@bfoster>
References: <153262651940.8934.17525988748289196893.stgit@magnolia>
 <153262652554.8934.816888163232208002.stgit@magnolia>
 <20180726232028.GC2234@dastard>
 <20180727000715.GJ30972@magnolia>
 <20180727104439.GA21835@bfoster>
 <20180729043900.GE2234@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180729043900.GE2234@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org, billodo@redhat.com

On Sun, Jul 29, 2018 at 02:39:00PM +1000, Dave Chinner wrote:
> On Fri, Jul 27, 2018 at 06:44:40AM -0400, Brian Foster wrote:
> > That aside.. since these values shouldn't change often I'm wondering if
> > it's worth calculating the global min/max once at mount time (we'd have
> 
> The values are needed during the initial read of the superblock
> before any "for the life of the mount" calculations can be made,
> and they can change across log recovery, too, if recovery replays a
> growfs transaction. Hence they really need to be point in time
> calculations based on the current superblock values during
> superblock reads....
> 

I'm not so worried about storing the calculated total as much as
simplifying the implementation. All but the last iteration in the
current loop calculate a fixed value, so this can trivially be
simplified to something like:

	xfs_agino_range(mp, --agcount, first, last);
	max = last - first + 1;
	if (agcount) {
		xfs_agino_range(mp, agcount - 1, first, last);
		max += (last - first + 1) * agcount;
	}

... which (if it mattered) could probably simplify even further if we
factored out the additional portion of the calculation that is fixed:

	xfs_agino_range(mp, --agcount, first, last);
	max = last - first + 1;
	if (agcount)
		max += agcount * mp->m_aginodes;

I.e., with an ->m_aginodes field in xfs_mount that is analogous to
sb_agblocks.

Brian

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
