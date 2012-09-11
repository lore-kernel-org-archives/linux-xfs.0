Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q8B3iB3V005630 for <xfs@oss.sgi.com>; Mon, 10 Sep 2012 22:44:11 -0500
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	AORYEHo54uLActOL for <xfs@oss.sgi.com>;
	Mon, 10 Sep 2012 20:45:14 -0700 (PDT)
Date: Tue, 11 Sep 2012 13:45:10 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v3] Add test case to test xfs projid32bit functionality a
	bit more extensively.
Message-ID: <20120911034510.GA11511@dastard>
References: <CAFZPdfjKfZP85f8zCLxCOf__ZyBd=tKsvqRGS-_bcaR0P_JuWA@mail.gmail.com>
	<504EA627.2050906@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <504EA627.2050906@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Boris Ranto <ranto.boris@gmail.com>, xfs-oss <xfs@oss.sgi.com>

On Mon, Sep 10, 2012 at 09:47:03PM -0500, Eric Sandeen wrote:
> On 9/6/12 10:23 AM, Boris Ranto wrote:
> >    The test covers several areas including enabling projid32bit
> > functionality dynamically by xfs_admin, dumping, restoring, quota
> > reporting and xfs_db projid values reporting.
> >   This test case hits a bug with xfsdump/xfsrestore process on a
> > projid32bit enabled filesystem.
> > 
> > Signed-off-by: Boris Ranto <ranto.boris@gmail.com>
> 
> there are just a couple things below, but I think we can get it
> checked in unless Dave has further concerns - please see below.
....
> > +dir=$SCRATCH_MNT/pquota
> > +
> > +status=1
> > +
> > +mkdir -p $dir
> > +touch $dir/{16,32}less
> 
> Although I understand it ok, I might add a comment here saying:
> 
> # create files to hold 16 and 32-bit project IDs
> 
> In retrospect I might use 16bit and 32bit to make more sense.
> Sorry, should have suggested that earlier.
> 
> I could just change the names on checkin with a note if that's ok with you.

With that change to 16bit/32bit, it's fine by me.

> > @@ -403,3 +403,4 @@ deprecated
> >  282 dump ioctl auto quick
> >  283 dump ioctl auto quick
> >  284 auto
> > +285 auto dump quota

Like I mentione dfirst time around, it needs to be added to the
quick group as well.

If you make those changes, Eric, then consider it:

Reviewed-by: Dave Chinner <dchinner@redhat.com>

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
