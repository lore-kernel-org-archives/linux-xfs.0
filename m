Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q3C2GWe7178956 for <xfs@oss.sgi.com>; Wed, 11 Apr 2012 21:16:32 -0500
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	xSjDKVbItGuuiw9S for <xfs@oss.sgi.com>;
	Wed, 11 Apr 2012 19:16:29 -0700 (PDT)
Date: Thu, 12 Apr 2012 12:16:26 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Fragmentation Issue We Are Having
Message-ID: <20120412021626.GX18323@dastard>
References: <CADrkzimg891ZBGK7-UzhGeey16KwH-ZXpEqFr=O3KwD3qA9LwQ@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CADrkzimg891ZBGK7-UzhGeey16KwH-ZXpEqFr=O3KwD3qA9LwQ@mail.gmail.com>
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

On Wed, Apr 11, 2012 at 06:04:25PM -0700, David Fuller wrote:
> We seen to be having an issue whereby our database server
> gets to 90% or higher fragmentation.  When it gets to this point
> we would need to remove form production and defrag using the
> xfs_fsr tool.

Bad assumption.

> The server does get a lot of writes and reads.  Is
> there something we can do to reduce the fragmentation or could
> this be a result of hard disk tweaks we use or mount options?
> 
> here is some fo the tweaks we do:
> 
> /bin/echo "512" > /sys/block/sda/queue/read_ahead_kb
> /bin/echo "10000" > /sys/block/sda/queue/nr_requests
> /bin/echo "512" > /sys/block/sdb/queue/read_ahead_kb
> /bin/echo "10000" > /sys/block/sdb/queue/nr_requests
> /bin/echo "noop" > /sys/block/sda/queue/scheduler
> /bin/echo "noop" > /sys/block/sdb/queue/scheduler

They have no effect on filesystem fragmentation.

> Adn here are the mount options on one of our servers:
> 
>  xfs     rw,noikeep,allocsize=256M,logbufs=8,sunit=128,swidth=2304
> 
> the sunit and swidth vary on each server based on disk drives.
> 
> We do use LVM on the volume where the mysql data is stored
> as we need this for snapshotting.  Here is an example of a current state:
>
> xfs_db -c frag -r /dev/mapper/vgmysql-lvmysql
> actual 42586, ideal 3134, fragmentation factor 92.64%

Read this first:

http://xfs.org/index.php/XFS_FAQ#Q:_The_xfs_db_.22frag.22_command_says_I.27m_over_50.25.__Is_that_bad.3F

Then decide whether 10 extents per file is really a problem or not.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
