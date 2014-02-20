Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 467F98005
	for <xfs@oss.sgi.com>; Wed, 19 Feb 2014 18:39:28 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 2C3C430406A
	for <xfs@oss.sgi.com>; Wed, 19 Feb 2014 16:39:27 -0800 (PST)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	A9Dk21C8rjiLNP7L for <xfs@oss.sgi.com>;
	Wed, 19 Feb 2014 16:39:25 -0800 (PST)
Date: Thu, 20 Feb 2014 11:38:50 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v3 06/11] xfs: use and update the finobt on inode
	allocation
Message-ID: <20140220003850.GJ4916@dastard>
References: <1391536182-9048-1-git-send-email-bfoster@redhat.com>
	<1391536182-9048-7-git-send-email-bfoster@redhat.com>
	<20140211071703.GG13647@dastard> <52FE7629.9090208@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <52FE7629.9090208@redhat.com>
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
To: Brian Foster <bfoster@redhat.com>
Cc: xfs@oss.sgi.com

On Fri, Feb 14, 2014 at 03:01:45PM -0500, Brian Foster wrote:
> On 02/11/2014 02:17 AM, Dave Chinner wrote:
> > On Tue, Feb 04, 2014 at 12:49:37PM -0500, Brian Foster wrote:
> ...
> >> +	/*
> >> +	 * Lookup and modify the equivalent record in the inobt.
> >> +	 */
> >> +	tcur = xfs_inobt_init_cursor(mp, tp, agbp, agno, XFS_BTNUM_INO);
> > 
> > In case ou hadn't guessed, I don't like the "tcur/trec" variables
> > because they make me thing "temporary" which they aren't. In this
> > case it is the inobt cursor and record....
> > 
> > In fact, this whole segment could be factored into a function like
> > xfs_dialloc_ag_inobt_update(), hence removing the second cursor from
> > xfs_dialloc_ag() function altogether and that would clean a lot of
> > the logic up....
> > 
> ...
> >> +	/*
> >> +	 * Update the perag and superblock.
> >> +	 */
> >> +	be32_add_cpu(&agi->agi_freecount, -1);
> >> +	xfs_ialloc_log_agi(tp, agbp, XFS_AGI_FREECOUNT);
> >> +	pag->pagi_freecount--;
> >> +
> >> +	xfs_trans_mod_sb(tp, XFS_TRANS_SB_IFREE, -1);
> > 
> > This will need to be done before you update the inobt, though, so
> > you can run the xfs_check_agi_freecount() count in it and it will
> > come out correct....
> > 
> 
> After cleaning up some of this code and taking a closer look, I end up
> with something just short of complete removal of the inobt cursor in
> this function. Reason being... the point above with regard to checking
> the btrees against the agi freecount pre and post modification.

I can't really comment all that well without having seen the
factored code you've written....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
