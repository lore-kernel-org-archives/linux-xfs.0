Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q7UMYKWb034056 for <xfs@oss.sgi.com>; Thu, 30 Aug 2012 17:34:21 -0500
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	BleULakxjTduOxMD for <xfs@oss.sgi.com>;
	Thu, 30 Aug 2012 15:35:13 -0700 (PDT)
Date: Fri, 31 Aug 2012 08:35:04 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: flush workers before stopping log
Message-ID: <20120830223504.GE15292@dastard>
References: <20120829134624.316257238@sgi.com>
	<20120829134628.835024558@sgi.com> <20120830002335.GB15292@dastard>
	<20120830172549.GG3274@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120830172549.GG3274@sgi.com>
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
To: Ben Myers <bpm@sgi.com>
Cc: tinguely@sgi.com, xfs@oss.sgi.com

On Thu, Aug 30, 2012 at 12:25:49PM -0500, Ben Myers wrote:
> On Thu, Aug 30, 2012 at 10:23:35AM +1000, Dave Chinner wrote:
> > On Wed, Aug 29, 2012 at 08:46:25AM -0500, tinguely@sgi.com wrote:
> > > Index: b/fs/xfs/xfs_mount.c
> > > ===================================================================
> > > --- a/fs/xfs/xfs_mount.c
> > > +++ b/fs/xfs/xfs_mount.c
> > > @@ -1490,6 +1490,11 @@ xfs_unmountfs(
> > >  
> > >  	xfs_qm_unmount(mp);
> > >  
> > > +	/* flush the worker queues while the log still exists and
> > > +	 * before the final sync and unmount record.
> > > +	 */
> > > +	xfs_syncd_stop(mp);
> > 
> > xfs_syncd_stop() needs to die rather than being moved from place to
> > place every time some problem is seemd.  I outlined what we need to
> > do to solve the problems once and for all a couple of months ago:
> > 
> > http://oss.sgi.com/archives/xfs/2012-06/msg00064.html
> 
> Yikes, that patchset you've posted is very nice.  Probably it is appropriate
> for the 3.7 merge window.  We also need a fix for 3.5-stable and 3.6.  Do you
> have a suggestion for that?

3.7 - it's too late for 3.6.

> It looks like you've also moved the final log
> force to after cancellation of the work queue in patch 6, similar to what Mark
> has done... so it would seem that Mark has the right idea.  I think Mark's
> patch is appropriate for 3.6 and 3.5-stable inclusion to fix the regression
> introduced by me in 8866fc6.
> 
> What is your opinion?

Don't do unnecessary work. :)

Realistically, the question that I always ask myself in this
situation is: do we really need to fix it right now?

Backports to stable kernels are typically done in response to user
reported issues. If users are not hitting the problem, then there's
no compelling reason for backporting it. i.e. the answer is "no".
If someone is hitting the problem, then the answer is "yes" and we
need a temporary fix until the proper fix is done.

To that extent, I've seen one user report of an unmount problem in 3.5
(reported on #xfs), but it's not clear if the problem they hit was
this problem or the fact that the superblock IO is not being waited
for during unmount in 3.5. This was fixed in 3.6 by commit 9a57fa8e
("xfs: wait for the write the superblock on unmount"):

http://oss.sgi.com/cgi-bin/gitweb.cgi?p=xfs/xfs.git;a=commit;h=9a57fa8ee7c29e11c2a29ce058573ba99157eda7

So, if we take this reported as a "yes, we need to fix it" trigger,
then we've got a couple of fixes that will need to be backported to
3.5.x..

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
