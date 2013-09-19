Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 10C1B29DFB
	for <xfs@oss.sgi.com>; Thu, 19 Sep 2013 18:29:22 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id F07F48F8059
	for <xfs@oss.sgi.com>; Thu, 19 Sep 2013 16:29:21 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	vaxvwgVI7gsXGdPT for <xfs@oss.sgi.com>;
	Thu, 19 Sep 2013 16:29:20 -0700 (PDT)
Date: Fri, 20 Sep 2013 09:29:17 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 3/3] xfs: push down inactive transaction mgmt for ifree
Message-ID: <20130919232917.GO9901@dastard>
References: <1379520960-22972-1-git-send-email-bfoster@redhat.com>
	<1379520960-22972-4-git-send-email-bfoster@redhat.com>
	<20130918230620.GE9901@dastard> <523AF196.80205@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <523AF196.80205@redhat.com>
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

On Thu, Sep 19, 2013 at 08:44:06AM -0400, Brian Foster wrote:
> On 09/18/2013 07:06 PM, Dave Chinner wrote:
> > On Wed, Sep 18, 2013 at 12:16:00PM -0400, Brian Foster wrote:
> >> Push the inode free work performed during xfs_inactive() down into
> >> a new xfs_inactive_ifree() helper. This clears xfs_inactive() from
> >> all inode locking and transaction management more directly
> >> associated with freeing the inode xattrs, extents and the inode
> >> itself.
.....
> >> +	/*
> >> +	 * Credit the quota account(s). The inode is gone.
> >> +	 */
> >> +	xfs_trans_mod_dquot_byino(tp, ip, XFS_TRANS_DQ_ICOUNT, -1);
> >> +
> >> +	/*
> >> +	 * Just ignore errors at this point.  There is nothing we can
> >> +	 * do except to try to keep going. Make sure it's not a silent
> >> +	 * error.
> >> +	 */
> >> +	error = xfs_bmap_finish(&tp,  &free_list, &committed);
> >> +	if (error)
> >> +		xfs_notice(mp, "%s: xfs_bmap_finish returned error %d",
> >> +			__func__, error);
> >> +	error = xfs_trans_commit(tp, XFS_TRANS_RELEASE_LOG_RES);
> >> +	if (error)
> >> +		xfs_notice(mp, "%s: xfs_trans_commit returned error %d",
> >> +			__func__, error);
> >> +
> >> +	xfs_iunlock(ip, XFS_ILOCK_EXCL);
> >> +	return 0;
> >> +}
> > 
> > I suspect we can clean up the error handling here now, and make it
> > look like the symlink remove inactive handle where we cancel bmaps
> > and abort transactions and trigger shutdowns appropriately. I'd
> > leave that to a separate patchset, though ;)
> > 
> 
> Hmm, well I follow what you mean as far as changing the code I think.
> But what changed that makes this safe? Or are you suggesting to shutdown
> on a bmap_finish/trans_commit failure instead of just "being noisy?"

I was thinking aloud. The error handling there comes from a static
checker that pointed out that we weren't handling the errors at all
in this code (along with another 50 or so other error handling
problems). So rather than change the code logic at the time (because
I didn't understand why the code ignored the errors) I simply made
failures noisy so we'd find out if there were real errors being
ignored there.

Now we know that errors in this code path are extremely rare
(nobody has ever reported a failure with these errors in them) so
it's probably time to convert them to do the correct thing when
xfs_bmap_finish() operations fail: abort transactions and
potentially shut the filesystem down....

> (Regardless, a separate patchset sounds good..)

*nod*

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
