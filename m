Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 962AB7F54
	for <xfs@oss.sgi.com>; Wed,  5 Feb 2014 15:54:49 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 48DE5AC003
	for <xfs@oss.sgi.com>; Wed,  5 Feb 2014 13:54:46 -0800 (PST)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	HXO0HYTp64t1GOaB for <xfs@oss.sgi.com>;
	Wed, 05 Feb 2014 13:54:41 -0800 (PST)
Date: Thu, 6 Feb 2014 08:54:36 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] restore: don't trash file capabilities
Message-ID: <20140205215436.GF13997@dastard>
References: <1391564918-25524-1-git-send-email-david@fromorbit.com>
	<52F246BF.60302@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <52F246BF.60302@redhat.com>
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

On Wed, Feb 05, 2014 at 09:12:15AM -0500, Brian Foster wrote:
> On 02/04/2014 08:48 PM, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > xfsrestore fails to restore file capabilities correctly because it
> > sets the owner on the file after it has restored the capability
> > attributes. This results in the kernel stripping the capabilities
> > when changing the owner of the file and hence the restored file is
> > not complete.
> > 
> > Fix this by changing the owner of the file when it is created rather
> > than after it has been fully restored. This ensures we don't kill
> > the caps as they are restored after the owner it appropriately set.
> > This fixes the xfs/296 failure.
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > ---
> >  restore/content.c | 116 ++++++++++++++++++++++++++++++++++++------------------
> >  1 file changed, 77 insertions(+), 39 deletions(-)
> > 
> > diff --git a/restore/content.c b/restore/content.c
> > index 54d933c..b655ed1 100644
> > --- a/restore/content.c
> > +++ b/restore/content.c
> ...
> > @@ -7442,6 +7509,12 @@ restore_reg( drive_t *drivep,
> >  		}
> >  	}
> >  
> > +	if (strctxp->sc_ownerset == BOOL_FALSE && persp->a.ownerpr) {
> > +		rval = set_file_owner(path, fdp, strctxp);
> > +		if (rval)
> > +			return BOOL_TRUE;
> > +	}
> > +
> 
> If this fails (rval == -1), we have unlinked the file and closed the fd
> in set_file_owner(). Why return BOOL_TRUE? I've not gone through and
> learned what dump/restore is doing, but this path looks like it's going
> to continue on with the restore in that scenario. Even if that is what
> we want to happen, it seems inconsistent with failure handling in
> set_file_owner() and the fact that we skip the rest of this function.

If any of the rest of the operations in this function fail, then it
keeps trying to do more operations and then finally it returns
BOOL_TRUE even after errors have occurred. Because the file has been
unlinked and the fd has been closed, we know all further operations
are going to fail, so we may as well just return immediately.

And if we follow the caller path back, we get back to


applynondirdump
  for (;;) {
    restore_file
      treecb_link
        restore_file_cb
          restore_reg
   if (not ok)
     break;
  }

So, returning BOOL_FALSE in the context above results in
tree_cb_link() returning RV_NOT_OK, which results in the stream
processing loop in applynondirdump() being aborted. i.e. returning
an error restoring a file causes the entire dump stream to be
aborted at that point.

IOWs, the dump image cannot be restored past that point, hence
returning an error of any kind is a bad idea.  Mostly complete
restores missing just a file (that were reported on during the
restore) is much, much better than having restore stop half way
through and refusing to go any further.

The code is convoluted, obtuse and difficult to read. But we're not
going to rewrite it from scratch any time soon so we just have to
live with it's craziness.

> > -			if ( mode != (mode_t)bstatp->bs_mode ) {
> > -				rval = fchmod( fd, mode );
> > -				if ( rval ) {
> > -					mlog( MLOG_VERBOSE | MLOG_ERROR,
> > -					      _("unable to strip setuid/setgid "
> > -					      "on %s, unlinking file.\n"),
> > -					      path );
> > -					unlink( path );
> > -				}
> > -			}
> > -		}
> > +	if (strcxtp->sc_ownerset == BOOL_FALSE && persp->a.ownerpr) {
> > +		rval = set_file_owner(path, &fd, strcxtp);
> > +		if (rval)
> > +			return BOOL_TRUE;
> >  	}
> 
> Ok, so we handle both set_file_owner() situations because the ordering
> here is really only important for regular files. IIUC, this particular
> block is still required for that non-ifreg case. Though, in the failure
> case, it looks like we're leaking the fd by returning now.

set_file_owner() closes the fd on error, immediately after unlinking
the file. Hence there is no fd leak in the error path.

And, again, we return BOOL_TRUE because that's what all the other
paths return even on error. And, in fact, none of the callers even
look at the error returned, so it's pretty much irrelevant in this
function.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
