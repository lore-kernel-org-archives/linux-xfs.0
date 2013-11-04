Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id A90DC7F87
	for <xfs@oss.sgi.com>; Mon,  4 Nov 2013 17:10:19 -0600 (CST)
Date: Mon, 4 Nov 2013 17:10:16 -0600
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH v2] xfs: fix the extent count when allocating an new
	indirection array entry
Message-ID: <20131104231016.GR1935@sgi.com>
References: <526A153C.2090408@oracle.com>
 <20131031213624.GQ1935@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131031213624.GQ1935@sgi.com>
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
To: Jeff Liu <jeff.liu@oracle.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Thu, Oct 31, 2013 at 04:36:24PM -0500, Ben Myers wrote:
> On Fri, Oct 25, 2013 at 02:52:44PM +0800, Jeff Liu wrote:
> > From: Jie Liu <jeff.liu@oracle.com>
> > 
> > At xfs_iext_add(), if extent(s) are being appended to the last page in
> > the indirection array and the new extent(s) don't fit in the page, the
> > number of extents(erp->er_extcount) in a new allocated entry should be
> > the minimum value between count and XFS_LINEAR_EXTS, instead of count.
> > 
> > For now, there is no existing test case can demonstrates a problem with
> > the er_extcount being set incorrectly here, but it obviously like a bug.
> > 
> > Signed-off-by: Jie Liu <jeff.liu@oracle.com>
> > ---
> > v2: * Declare count to uint as it will be decreased to 0 and XFS_LINEAR_EXTS
> >       can be uint because of a case in the macro.
> >     * Convert MIN() to min().
> >     * Revise the commits log to indicate there is no existing test case can
> >       reflect this issue for future tracking up.
> > 
> >  fs/xfs/xfs_inode_fork.c |    9 ++++-----
> >  1 file changed, 4 insertions(+), 5 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_inode_fork.c b/fs/xfs/xfs_inode_fork.c
> > index 22c9837..cfee14a 100644
> > --- a/fs/xfs/xfs_inode_fork.c
> > +++ b/fs/xfs/xfs_inode_fork.c
> > @@ -1021,15 +1021,14 @@ xfs_iext_add(
> >  		 * the next index needed in the indirection array.
> >  		 */
> >  		else {
> > -			int	count = ext_diff;
> > +			uint	count = ext_diff;
> >  
> >  			while (count) {
> >  				erp = xfs_iext_irec_new(ifp, erp_idx);
> > -				erp->er_extcount = count;
> > -				count -= MIN(count, (int)XFS_LINEAR_EXTS);
> > -				if (count) {
> > +				erp->er_extcount = min(count, XFS_LINEAR_EXTS);
> > +				count -= erp->er_extcount;
> > +				if (count)
> >  					erp_idx++;
> > -				}
> >  			}
> >  		}
> >  	}
> 
> Really nice find.  So there is potential for incorrect er_extcount and
> er_extoff when adding > 256 extents to the end of the indirection array.  You'd
> think we'd be seeing some side effects since xfs_iext_idx_to_irec uses them in
> it's binary search.
> 
> Reviewed-by: Ben Myers <bpm@sgi.com>

Applied this.  Thanks Jeff.

-Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
