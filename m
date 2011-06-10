Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p5AHv2CQ261869 for <xfs@oss.sgi.com>; Fri, 10 Jun 2011 12:57:03 -0500
Received: from ipmail06.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1B129DA2CC6
	for <xfs@oss.sgi.com>; Fri, 10 Jun 2011 10:56:59 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	wiAE8Fwah1ZlEbXH for <xfs@oss.sgi.com>;
	Fri, 10 Jun 2011 10:56:59 -0700 (PDT)
Date: Sat, 11 Jun 2011 03:56:56 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Defragging XFS File Systems
Message-ID: <20110610175656.GW32466@dastard>
References: <BANLkTi=40mmE+DCbLcSWBwNQtWpP=N=tXw@mail.gmail.com>
	<201106090749.37745@zmi.at> <4DF080AC.2090507@hardwarefreak.com>
	<201106091212.36227@zmi.at> <4DF10FDF.1090508@hardwarefreak.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4DF10FDF.1090508@hardwarefreak.com>
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
To: Stan Hoeppner <stan@hardwarefreak.com>
Cc: Michael Monnerie <michael.monnerie@is.it-management.at>, Kenneth Emerson <kenneth.emerson@gmail.com>, xfs@oss.sgi.com

On Thu, Jun 09, 2011 at 01:24:31PM -0500, Stan Hoeppner wrote:
> On 6/9/2011 5:12 AM, Michael Monnerie wrote:
> > On Donnerstag, 9. Juni 2011 Stan Hoeppner wrote:
> >> When is running xfs_fsr recommended?
> > 
> > Good question. One case that comes to my mind is a filesystem that was 
> > used a long time when filled >85%, which has now either been expanded or 
> > files removed so you have a lot of space again, and you want to defrag 
> > all those files that have been badly fragmented.
> >  
> >> I scheduled it twice a week some time ago due to a filesystem
> >> containing active mbox files.  I did so because they became so
> >> heavily fragmented in short order, especially those swallowing
> >> copious amounts of list mail.  Before cron'ing xfs_fsr I was seeing
> >> mbox files with over 1000 fragmented extents, and increasing MUA
> >> latency as the files became more fragmented.  The filesystem is
> >> currently 90% free.
> > 
> > This is also an example where defrag may help. You have 10% usage, so 
> > there's enough space. Maybe your usage fits the mount option 
> > "allocsize", 
> 
> I tried allocsize=1m but it didn't seem to help already existing files.
>  I simply don't think there's much that can be done in filesystem logic
> to keep long lived constantly appended files from fragmenting, short of

YOu can stop XFS from truncating speculative preallocation beyond
EOF by either telling the inode it has preallocated space or
or turning it into a an append-only file. e.g.

$ xfs_io -f -c "resvsp 0 4k" <file>

or

$ sudo chattr +a <file>

Either way, XFS won't truncate extents beyond EOF on file close for
such a file and that should prevent most future fragmentation of the
file.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
