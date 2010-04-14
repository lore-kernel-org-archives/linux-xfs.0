Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o3EKIaYd096961 for <xfs@oss.sgi.com>; Wed, 14 Apr 2010 15:18:36 -0500
Subject: Re: [PATCHv2 7/10] xfs: tidy up some goto labels
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20100412065232.GI2493@dastard>
References: <1270852163.7840.154.camel@doink> <20100412065232.GI2493@dastard>
Date: Wed, 14 Apr 2010 15:20:27 -0500
Message-ID: <1271276427.3559.34.camel@doink>
Mime-Version: 1.0
Reply-To: aelder@sgi.com
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Mon, 2010-04-12 at 16:52 +1000, Dave Chinner wrote:
> On Fri, Apr 09, 2010 at 05:29:23PM -0500, Alex Elder wrote:
> > Rename a label used in xlog_find_head() that I thought was poorly
> > chosen.  Also combine two adjacent labels xlog_find_tail() into
> > a single label, and give it a more generic name.
> > 
> > Signed-off-by: Alex Elder <aelder@sgi.com>
> > 
> > ---
> > fs/xfs/xfs_log_recover.c |   83 ++++++++++++++++++++++++-----------------------
> >  fs/xfs/xfs_log_recover.c |   20 +++++++++-----------
> >  1 file changed, 9 insertions(+), 11 deletions(-)
> > 
> > Index: b/fs/xfs/xfs_log_recover.c
> > ===================================================================
> > --- a/fs/xfs/xfs_log_recover.c
> > +++ b/fs/xfs/xfs_log_recover.c

. . .

> > @@ -757,7 +757,7 @@ xlog_find_head(
> >  			head_blk = new_blk;
> >  	}
> >  
> > - bad_blk:
> > +fine_tune:
> >  	/*
> >  	 * Now we need to make sure head_blk is not pointing to a block in
> >  	 * the middle of a log record.
> 
> I don't think "fine_tune" really matches what is being done here
> either. "bad_blk" makes sense when you consider that the search is
> being terminated due to a log block being found that didn't match
> the search criteria. i.e. it is bad.
> 
> What we are really doing there at "bad_blk" is validating the head
> block we have found, so if you are going to change the label then
> "validate_head" makes more sense to me...

My label came from the idea that at this point
we're refining the estimate of the head of the
log.  But I like "validate_head" just as well.
(In my brain "bad_blk" suggests a media problem;
I care more about changing it than about what
it is changed to...)

If I switch it to use your proposed label, can
I get a "Reviewed-by"?  (I won't bother re-posting
the patch.)

					-Alex

PS  I'm still working on reorganizing this file
    (including this function) some more, to kill
    off a bunch of duplicated code.



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
