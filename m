Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q3C4Ov0V005218 for <xfs@oss.sgi.com>; Wed, 11 Apr 2012 23:24:58 -0500
Received: from mail.sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com
	with ESMTP id OZO63aWBP5rPMjFG for <xfs@oss.sgi.com>;
	Wed, 11 Apr 2012 21:24:56 -0700 (PDT)
Message-ID: <4F865915.80104@sandeen.net>
Date: Wed, 11 Apr 2012 23:24:53 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Fragmentation Issue We Are Having
References: <CADrkzimg891ZBGK7-UzhGeey16KwH-ZXpEqFr=O3KwD3qA9LwQ@mail.gmail.com>
	<20120412021626.GX18323@dastard>
	<CADrkzim1B9fU5sK73uGicPpr7D+ANPwKWGdMS7TroyoX5ncdOw@mail.gmail.com>
In-Reply-To: <CADrkzim1B9fU5sK73uGicPpr7D+ANPwKWGdMS7TroyoX5ncdOw@mail.gmail.com>
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
To: David Fuller <dfuller@epoch.com>
Cc: xfs@oss.sgi.com

On 4/11/12 9:55 PM, David Fuller wrote:
> Dave,
> 
> Thanks so much for that informative read.  This helps me fight my case that systematic
> defrags are not needed and are bad for the system in general.
> 
> After reading this I did do some checks against some of our larger tables and found that
> on average we are storing about 2.5GB per extent. For me that seems pretty reasonable
> to me and does not require defrag'ing at this time.

I've also added a visual aid to that faq entry to show how quickly the frag factor
approaches 100% :)

-Eric

> --David Fuller
> 
> 
> <http://www.topshelfads.com/email/sig/epochbestbilling.jpg>
> 
> 
> On Wed, Apr 11, 2012 at 7:16 PM, Dave Chinner <david@fromorbit.com <mailto:david@fromorbit.com>> wrote:
> 
>     On Wed, Apr 11, 2012 at 06:04:25PM -0700, David Fuller wrote:
>     > We seen to be having an issue whereby our database server
>     > gets to 90% or higher fragmentation.  When it gets to this point
>     > we would need to remove form production and defrag using the
>     > xfs_fsr tool.
> 
>     Bad assumption.
> 
>     > The server does get a lot of writes and reads.  Is
>     > there something we can do to reduce the fragmentation or could
>     > this be a result of hard disk tweaks we use or mount options?
>     >
>     > here is some fo the tweaks we do:
>     >
>     > /bin/echo "512" > /sys/block/sda/queue/read_ahead_kb
>     > /bin/echo "10000" > /sys/block/sda/queue/nr_requests
>     > /bin/echo "512" > /sys/block/sdb/queue/read_ahead_kb
>     > /bin/echo "10000" > /sys/block/sdb/queue/nr_requests
>     > /bin/echo "noop" > /sys/block/sda/queue/scheduler
>     > /bin/echo "noop" > /sys/block/sdb/queue/scheduler
> 
>     They have no effect on filesystem fragmentation.
> 
>     > Adn here are the mount options on one of our servers:
>     >
>     >  xfs     rw,noikeep,allocsize=256M,logbufs=8,sunit=128,swidth=2304
>     >
>     > the sunit and swidth vary on each server based on disk drives.
>     >
>     > We do use LVM on the volume where the mysql data is stored
>     > as we need this for snapshotting.  Here is an example of a current state:
>     >
>     > xfs_db -c frag -r /dev/mapper/vgmysql-lvmysql
>     > actual 42586, ideal 3134, fragmentation factor 92.64%
> 
>     Read this first:
> 
>     http://xfs.org/index.php/XFS_FAQ#Q:_The_xfs_db_.22frag.22_command_says_I.27m_over_50.25.__Is_that_bad.3F
> 
>     Then decide whether 10 extents per file is really a problem or not.
> 
>     Cheers,
> 
>     Dave.
>     --
>     Dave Chinner
>     david@fromorbit.com <mailto:david@fromorbit.com>
> 
> 
> 
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
