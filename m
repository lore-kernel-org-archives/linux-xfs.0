Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p1E5Sl5g102015 for <xfs@oss.sgi.com>; Sun, 13 Feb 2011 23:28:47 -0600
Received: from ipmail05.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0573899A4E1
	for <xfs@oss.sgi.com>; Sun, 13 Feb 2011 21:31:24 -0800 (PST)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	CEsCGineJg8sXXOD for <xfs@oss.sgi.com>;
	Sun, 13 Feb 2011 21:31:24 -0800 (PST)
Date: Mon, 14 Feb 2011 16:31:22 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/3] libxlog: sync up with 2.6.38 kernel code
Message-ID: <20110214053122.GJ2559@dastard>
References: <1294649091-27174-1-git-send-email-david@fromorbit.com>
	<1294649091-27174-3-git-send-email-david@fromorbit.com>
	<1297288144.2513.228.camel@doink> <20110214051005.GI2559@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110214051005.GI2559@dastard>
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
To: Alex Elder <aelder@sgi.com>
Cc: xfs@oss.sgi.com

On Mon, Feb 14, 2011 at 04:10:05PM +1100, Dave Chinner wrote:
> On Wed, Feb 09, 2011 at 03:49:03PM -0600, Alex Elder wrote:
> > On Mon, 2011-01-10 at 19:44 +1100, Dave Chinner wrote:
> > > From: Dave Chinner <dchinner@redhat.com>
> > > 
> > > Update libxlog with the current 2.6.38 kernel code and well as
> > > updating the necessary parts of libxfs and variaous header files to
> > > ensure that it compiles correctly.

.....

> xfsprogs. As the code has changed, I'm sure there's bits that are
> now unused by userspace and should be cleaned up. We also need to
> make another pass over the kernel headers to refine what is in
> #idef__KERNEL__ regions as there is some problems in that area as
> well.  That doesn't have to be done right now, though...

....

> > > diff --git a/libxfs/trans.c b/libxfs/trans.c
> > > index 1c60f38..c5dd2ca 100644
> > > --- a/libxfs/trans.c
> > > +++ b/libxfs/trans.c
> > > @@ -36,8 +36,7 @@ libxfs_trans_alloc(
> > >  	}
> > >  	ptr->t_mountp = mp;
> > >  	ptr->t_type = type;
> > > -	ptr->t_items_free = XFS_LIC_NUM_SLOTS;
> > 
> > t_items_free is removed from the xfs_trans structure
> > in "include/xfs_trans.h" but it remains in the version
> > of that structure defined in "include/libxfs.h".
> > 
> > I believe the latter is the one we want to keep,
> > but if that's the case you'd better delete the
> > field definition there.  (The compiler isn't
> > warning you that you neglected to initialize a
> > field.)
> 
> Nor is it warning about a duplicate definition by the sound of it.
> I'll fix it up.

There are two declarations of struct xfs_trans in userspace but only
the one in libxfs.h is used because the one in include/xfs_trans.h
is surrounded bu #ifdef __KERNEL__. Just an example of the sort of
cleanup I mentioned above that is needed...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
