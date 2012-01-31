Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q0V1Vd04169666 for <xfs@oss.sgi.com>; Mon, 30 Jan 2012 19:31:40 -0600
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	lo7CEouAzJwLdrRx for <xfs@oss.sgi.com>;
	Mon, 30 Jan 2012 17:31:37 -0800 (PST)
Date: Tue, 31 Jan 2012 12:31:24 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: File system remain unresponsive until the system is rebooted.
Message-ID: <20120131013124.GE9090@dastard>
References: <CANs4eSBWLc4HxAbPZ8kOVOdJ7RKiA+-ai3Q2J+FAyuzHtUqfdg@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CANs4eSBWLc4HxAbPZ8kOVOdJ7RKiA+-ai3Q2J+FAyuzHtUqfdg@mail.gmail.com>
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
To: Supratik Goswami <supratiksekhar@gmail.com>
Cc: xfs@oss.sgi.com

On Mon, Jan 30, 2012 at 02:48:58PM +0530, Supratik Goswami wrote:
> Hi
> 
> We are using RAID-0 volumes as PV's in our LVM stack and XFS as the filesystem.
> 
> The kernel logged the below call trace when the filesystem was being
> expanded using "xfs_growfs" command.
> We have used xfs_grofs at least 3 times earlier but did not cam across
> this situation.
> 
> The files system remained unresponsive until we rebooted the system
> and again increased the size of the filesystem.
> This time it worked fine. Can you please tell us why xfs_grofs hanged suddenly ?

What kernel?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
