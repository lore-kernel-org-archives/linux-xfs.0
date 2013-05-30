Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 62E4E7F37
	for <xfs@oss.sgi.com>; Thu, 30 May 2013 15:27:22 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id D5F49AC010
	for <xfs@oss.sgi.com>; Thu, 30 May 2013 13:27:21 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	BvxdexYDawirHG7V for <xfs@oss.sgi.com>;
	Thu, 30 May 2013 13:27:19 -0700 (PDT)
Date: Fri, 31 May 2013 06:27:15 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/2] xfs: inode unlinked list needs to recalculate the
	inode CRC
Message-ID: <20130530202715.GO29466@dastard>
References: <1369636707-15150-10-git-send-email-david@fromorbit.com>
	<1369773373-26697-1-git-send-email-david@fromorbit.com>
	<1369773373-26697-3-git-send-email-david@fromorbit.com>
	<51A75F8B.8000507@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <51A75F8B.8000507@redhat.com>
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
Cc: bpm@sgi.com, xfs@oss.sgi.com

On Thu, May 30, 2013 at 10:17:47AM -0400, Brian Foster wrote:
> On 05/28/2013 04:36 PM, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > The inode unlinked list manipulations operate directly on the inode
> > buffer, and so bypass the inode CRC calculation mechanisms. Hence an
> > inode on the unlinked list has an invalid CRC. Fix this by
> > recalculating the CRC whenever we modify an unlinked list pointer in
> > an inode, ncluding during log recovery. This is trivial to do and
> > results in  unlinked list operations always leaving a consistent
> > inode in the buffer.
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > ---
> >  fs/xfs/xfs_inode.c       |   42 ++++++++++++++++++++++++++++++++++++++----
> >  fs/xfs/xfs_log_recover.c |    9 +++++++++
> >  2 files changed, 47 insertions(+), 4 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> > index efbe1ac..2d993e7 100644
> > --- a/fs/xfs/xfs_inode.c
> > +++ b/fs/xfs/xfs_inode.c
> > @@ -1579,6 +1579,23 @@ out_bmap_cancel:
> >  }
> >  
> >  /*
> > + * Helper function to calculate range of the inode to log and recalculate the
> > + * on-disk inode crc if necessary.
> > + */
> > +static int
> > +xfs_iunlink_dinode_calc_crc(
> > +	struct xfs_mount	*mp,
> > +	struct xfs_dinode	*dip)
> > +{
> > +	if (dip->di_version < 3)
> > +		return sizeof(xfs_agino_t);
> > +
> > +	xfs_dinode_calc_crc(mp, dip);
> > +	return offsetof(struct xfs_dinode, di_changecount) -
> > +		offsetof(struct xfs_dinode, di_next_unlinked);
> > +}
> > +
> 
> So we've added a new helper, the return value for which is either the
> size of an inode number or an inode number + crc, depending on format. I
> also notice that the return value doesn't appear to be used anywhere
> this helper is called.

Because I forgot to remove it. ;)

> 
> > +/*
> >   * This is called when the inode's link count goes to 0.
> >   * We place the on-disk inode on a list in the AGI.  It
> >   * will be pulled from this list when the inode is freed.
> > @@ -1638,10 +1655,15 @@ xfs_iunlink(
> >  		dip->di_next_unlinked = agi->agi_unlinked[bucket_index];
> >  		offset = ip->i_imap.im_boffset +
> >  			offsetof(xfs_dinode_t, di_next_unlinked);
> > +
> > +		/* need to recalc the inode CRC if appropriate */
> > +		xfs_iunlink_dinode_calc_crc(mp, dip);
> > +
> >  		xfs_trans_inode_buf(tp, ibp);
> >  		xfs_trans_log_buf(tp, ibp, offset,
> > -				  (offset + sizeof(xfs_agino_t) - 1));
> > +				  offset + sizeof(xfs_agino_t) - 1);
> >  		xfs_inobp_check(mp, ibp);
> > +
> >  	}
> 
> So IIUC, offset is set to the offset of the di_next_unlinked value of
> this inode in the backing buffer of the inode (which we've just updated
> directly via dip).
> 
> We call the helper to update the CRC then call xfs_trans_log_buf() to
> log a range of the buffer. From the original code, I surmise that we're
> logging the range that represents the di_next_unlinked value and from
> the addition of the helper, I surmise we intend to now include the crc
> in that logged region.
> 
> But we haven't utilized the return value and I'm speculating on the
> intent here. So I see that we're updating the CRC, but is it actually
> logged? Perhaps I'm missing something, but if so, then why even have the
> xfs_iunlink_dinode_calc_crc() helper?
> 
> /me goes back to read the original 9/9 and followup:
> 
> http://oss.sgi.com/archives/xfs/2013-05/msg00867.html
> 
> OK, so in that case, perhaps the helper is now unnecessary and we could
> just call xfs_dinode_calc_crc()?

Yup, exactly.

> BTW, I was also going to ask here whether the fact that we update the
> CRC on recovery rather than logging it exposed items in the log to risk
> if they happened to become corrupted before that update occurs, but
> IIUC, we're still protected in that recovery itself should validate the
> existing on-disk CRC prior to the update. Correct?

No, recovery doesn't check it yet. Recovery is a complex dance, so
there's further work there needed allow recovery to do CRC checking
on read (as the buffer initialisation migh be what is being
replayed).

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
