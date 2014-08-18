Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 4CA057F3F
	for <xfs@oss.sgi.com>; Mon, 18 Aug 2014 08:12:08 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id D0D13AC004
	for <xfs@oss.sgi.com>; Mon, 18 Aug 2014 06:12:07 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	NgK1i6QkaLwG4aqE for <xfs@oss.sgi.com>;
	Mon, 18 Aug 2014 06:12:02 -0700 (PDT)
Date: Mon, 18 Aug 2014 23:11:48 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [RFD]: Help in setting up XFS
Message-ID: <20140818131148.GN20518@dastard>
References: <BLU181-W3698AB216D54D0CCE5A9739CD40@phx.gbl>
	<20140818070312.GM20518@dastard>
	<BLU181-W782ECB29BAB77090E0292A9CD40@phx.gbl>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <BLU181-W782ECB29BAB77090E0292A9CD40@phx.gbl>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Prithvi Rathore <prithvi_rathore@outlook.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Mon, Aug 18, 2014 at 03:00:31PM +0530, Prithvi Rathore wrote:
> Hi Dave,
>    I really appreciate you help in this matter.
> 
> > Date: Mon, 18 Aug 2014 17:03:12 +1000
> > From: david@fromorbit.com
> > To: prithvi_rathore@outlook.com
> > CC: xfs@oss.sgi.com
> > Subject: Re: [RFD]: Help in setting up XFS
> > 
> > On Mon, Aug 18, 2014 at 10:22:37AM +0530, Prithvi Rathore wrote:
> > > Hi,
> > > As the subject states, I would like to setup and use XFS on an external USB drive. I am currently using Ubuntu 14.04 on MacBook Air 2013.
> > > My understanding is:
> > > 
> > > 1) I will have to install the packages
> > > $ sudo apt-get install xfsprogs
> > > $ sudo apt-get install xfsdump
> > > 
> > > 2) I will have to create the filesystem for the USB drive
> > > $ mkfs.xfs -f dev/sdab1
> > > -f option needed to overwrite any existing filesytem
>  
> > And then mount it appropriately and it will be ready to use.
> > Nothing more.
> 
> About the part where you say mount it properly, I just wanted to check if this is correct.
> 
> 1)Create a mount point.
>     $ mkdir /mnt/dat1
> 
> 2)Mount the drive.
>    $ mount -t xfs /dev/sdc1 /mnt/dat1

mount will work out that it contains XFS and do the right thing
automatically. i.e. this should work just fine:

    $ mount /dev/sdc1 /mnt/dat1

Look in dmesg to see what happens at the kernel level when you run
the command, and compare the difference with and without the "-t
xfs"....

> And i will have to do this every time I want to use the pendrive

Only the mount command. the mount point won't go away unless you
remove it.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
