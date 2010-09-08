Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o88Ep88U041103 for <xfs@oss.sgi.com>; Wed, 8 Sep 2010 09:51:09 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3AD3557C27
	for <xfs@oss.sgi.com>; Wed,  8 Sep 2010 07:51:52 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail18.adl2.internode.on.net
	[150.101.137.103]) by cuda.sgi.com with ESMTP id
	x6NOXvVNJE1SqFUq for <xfs@oss.sgi.com>;
	Wed, 08 Sep 2010 07:51:52 -0700 (PDT)
Date: Thu, 9 Sep 2010 00:51:48 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfs mount/create options (was: XFS status update for August 2010)
Message-ID: <20100908145148.GB705@dastard>
References: <20100902145959.GA27887@infradead.org> <201009080738.58483@zmi.at>
	<20100908105858.GZ705@dastard> <201009081538.54488@zmi.at>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <201009081538.54488@zmi.at>
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
To: Michael Monnerie <michael.monnerie@is.it-management.at>
Cc: xfs@oss.sgi.com

On Wed, Sep 08, 2010 at 03:38:53PM +0200, Michael Monnerie wrote:
> On Mittwoch, 8. September 2010 Dave Chinner wrote:
> > >  On machines with 32MiB or more 32k is the default, but most
> > >  machines these days have multi-gigabytes of RAM, so at least for
> > >  RAM>1GiB that could be made default.
> > 
> > That is definitely not true. XFS is widely used in the embedded NAS
> > space, where memory is very limited and might be configured with
> > many filesystems.  32k is the default because those sorts of machines
> > can't afford to burn 2MB RAM per filesystem just in log buffers.
> >
> > Also, you can go and search the archives or git history as to why we
> > don't tune the logbsize based on physical memory size anymore, too.
> 
> OK, then the man page should be updated to reflect this "newer logic". 
> I've got the information directly from there.
>  
> > You're getting the wrong information there. largeio affects the
> > output of the optimal IO size reported by stat(2). 'stat -f" does
> > a statfs(2) call. Try 'stat /disk/db/<file> --format %o'....
> 
> Ah, that's better, thank you :-)
>  
> > >  And while I am at it: Why does "mount" not provide the su=/sw=
> > >   options that we can use to create a filesystem? Would make life
> > >   easier, as it's much easier to read su=64k,sw=7 than
> > >   sunit=128,swidth=896.
> > 
> > You should never, ever need to use the mount options.
> 
> ..except when a disk is added to the RAID, or it's RAID level gets 
> changed. Then sw=7 becomes sw=8 or so - or better said: would become, as 
> then you must use the (I call it strange, error prone) semantics of 
> sunit/swidth.

Dynamically changing the RAID array geometry is a Bad Idea.  Yes,
you can do it, but if you've got a filesystem full of data and
metadata aligned to the old geometry then after the modification
it won't be aligned anymore.

If you want to do this, then either don't bother about geomtry hints
in the first place, or dump, rebuild the array, mkfs and restore so
everything is properly aligned with the new world order. Hell,
dump/mkfs/restore might even be faster than reshaping a large
array...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
