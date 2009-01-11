Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	n0BAZZIL013109 for <xfs@oss.sgi.com>; Sun, 11 Jan 2009 04:35:40 -0600
Received: from ipmail05.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 39EECF6B280
	for <xfs@oss.sgi.com>; Sun, 11 Jan 2009 02:35:34 -0800 (PST)
Received: from ipmail05.adl2.internode.on.net (ipmail05.adl2.internode.on.net
	[203.16.214.145]) by cuda.sgi.com with ESMTP id
	Y5INCP6lFljDgehd for <xfs@oss.sgi.com>;
	Sun, 11 Jan 2009 02:35:34 -0800 (PST)
Date: Sun, 11 Jan 2009 21:35:28 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: mkfs.xfs with a 9TB realtime volume hangs
Message-ID: <20090111103528.GA8071@disturbed>
References: <alpine.DEB.2.00.0811141231390.23165@kurp.hut.fi>
	<49690F73.1070908@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <49690F73.1070908@sandeen.net>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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
Cc: xfs@oss.sgi.com, Jan Wagner <jwagner@kurp.hut.fi>

On Sat, Jan 10, 2009 at 03:13:23PM -0600, Eric Sandeen wrote:
> Jan Wagner wrote:
> > Hi,
> > 
> > I have a RAID0 with 11x750GB+1x1TB components in the following 
> > partitionable-md test setup
> > 
> > root@abidal:~# cat /proc/partitions | grep md
> >   254     0 9035047936 md_d0
> >   254     1     124983 md_d0p1
> >   254     2    1828125 md_d0p2
> >   254     3    1953125 md_d0p3
> >   254     4 9031141669 md_d0p4
> > 
> > Essentially, four partitions: 128MB, ~1.9GB, 2GB, 9TB. I'd like to use the 
> > 1.9GB partition for xfs and put a realtime subvolume onto the same raid0 
> > onto the 9TB partition. The partition tables are GDT instead of MBR to be 
> > able to have >=2TB partitions.
> 
> Sorry for the slow/no reply.  It seems to be doing many calculations in
> rtinit, haven't sorted out what yet, but it's not likely hung, it's
> workin hard.  :)
> 
> If you give it a larger extsize it should go faster (if the larger
> extsize is acceptable for your use...)
> 
> I tried a 4t realtime volume:
> 
> mkfs.xfs -dfile,name=fsfile,size=1g -rfile,name=rtfile,size=4t,extsize=$SIZE
> 
> for a few different extent sizes, and got
> 
> extsize	  time
> -------	  ----
> 512k	  0.3s
> 256k	  0.7s
> 128k	  1.9s
>  64k	  8.4s
>  32k	 25.4s
>  16k	129.4s
> 
> With the default 4k extent size this takes forever (the man page claims
> default is 64k, maybe this got broken at some point).

It got changed a few years back by Nathan, IIRC. I bet the time
being taken a result of the blow-out in bitmap size caused by reducing
the extent size. Given it is non-linear, it may have something to do
with cache sizes as well.  e.g buftarg hashes not large enough.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
