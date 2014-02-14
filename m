Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 70BEB7F51
	for <xfs@oss.sgi.com>; Fri, 14 Feb 2014 14:01:53 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 4DF0A304062
	for <xfs@oss.sgi.com>; Fri, 14 Feb 2014 12:01:53 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id UqnhsVVslWVQ7htl for
	<xfs@oss.sgi.com>; Fri, 14 Feb 2014 12:01:49 -0800 (PST)
Message-ID: <52FE7629.9090208@redhat.com>
Date: Fri, 14 Feb 2014 15:01:45 -0500
From: Brian Foster <bfoster@redhat.com>
MIME-Version: 1.0
Subject: Re: [PATCH v3 06/11] xfs: use and update the finobt on inode
	allocation
References: <1391536182-9048-1-git-send-email-bfoster@redhat.com>
	<1391536182-9048-7-git-send-email-bfoster@redhat.com>
	<20140211071703.GG13647@dastard>
In-Reply-To: <20140211071703.GG13647@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On 02/11/2014 02:17 AM, Dave Chinner wrote:
> On Tue, Feb 04, 2014 at 12:49:37PM -0500, Brian Foster wrote:
...
>> +	/*
>> +	 * Lookup and modify the equivalent record in the inobt.
>> +	 */
>> +	tcur = xfs_inobt_init_cursor(mp, tp, agbp, agno, XFS_BTNUM_INO);
> 
> In case ou hadn't guessed, I don't like the "tcur/trec" variables
> because they make me thing "temporary" which they aren't. In this
> case it is the inobt cursor and record....
> 
> In fact, this whole segment could be factored into a function like
> xfs_dialloc_ag_inobt_update(), hence removing the second cursor from
> xfs_dialloc_ag() function altogether and that would clean a lot of
> the logic up....
> 
...
>> +	/*
>> +	 * Update the perag and superblock.
>> +	 */
>> +	be32_add_cpu(&agi->agi_freecount, -1);
>> +	xfs_ialloc_log_agi(tp, agbp, XFS_AGI_FREECOUNT);
>> +	pag->pagi_freecount--;
>> +
>> +	xfs_trans_mod_sb(tp, XFS_TRANS_SB_IFREE, -1);
> 
> This will need to be done before you update the inobt, though, so
> you can run the xfs_check_agi_freecount() count in it and it will
> come out correct....
> 

After cleaning up some of this code and taking a closer look, I end up
with something just short of complete removal of the inobt cursor in
this function. Reason being... the point above with regard to checking
the btrees against the agi freecount pre and post modification.

The only way I see to push the inobt cursor into a separate function is
to also push the agi/sb update to the middle of that function, which
just seems ugly to me. The helper function is now non-intuitively
sensitive to the context in which it is called (and conversely buries
context that makes xfs_dialloc_ag() harder to follow). E.g., misplaced
functionality for an "update the inobt" helper.

That said, xfs_dialloc_ag() is much smaller from all of the other
refactoring, trec is gone and tcur is renamed to icur. So I think
clarity is still improved. Let me know if there's any major objections
to that pattern or alternate suggestions. Otherwise, I'll run with this
for the next version...

Brian

> Cheers,
> 
> Dave.
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
