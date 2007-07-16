Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 16 Jul 2007 08:50:33 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l6GFoUbm003876
	for <xfs@oss.sgi.com>; Mon, 16 Jul 2007 08:50:31 -0700
Message-ID: <469B93CA.30801@sandeen.net>
Date: Mon, 16 Jul 2007 10:50:34 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: 3ware 9650 tips
References: <alpine.LRH.0.999.0707131356520.25773@chaos.egr.duke.edu> <Pine.LNX.4.64.0707131434470.31742@p34.internal.lan> <4697CA4D.6020304@etelos.com> <Pine.LNX.4.64.0707131535270.2064@p34.internal.lan> <20070716024115.GJ12413810@sgi.com> <20070716122225.GB31489@sgi.com>
In-Reply-To: <20070716122225.GB31489@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: Justin Piszcz <jpiszcz@lucidpixels.com>, Jon Collette <jon@etelos.com>, Joshua Baker-LePain <jlb17@duke.edu>, linux-ide-arrays@lists.math.uh.edu, linux-raid@vger.kernel.org, xfs@oss.sgi.com

David Chinner wrote:
> On Mon, Jul 16, 2007 at 12:41:15PM +1000, David Chinner wrote:
>> On Fri, Jul 13, 2007 at 03:36:46PM -0400, Justin Piszcz wrote:
...
>> If you've got any sort of serious disk array, ext3 is not the filesystem
>> to use....
> 
> To show what the difference is, I used blktrace and Chris Mason's
> seekwatcher script on a simple, single threaded dd command on
> a 12 disk dm RAID0 stripe:
> 
> # dd if=/dev/zero of=/mnt/scratch/fred bs=1024k count=10k; sync
> 
> http://oss.sgi.com/~dgc/writes/ext3_write.png
> http://oss.sgi.com/~dgc/writes/xfs_write.png

Were those all with default mkfs & mount options?  ext3 in writeback
mode might be an interesting comparison too.

-Eric
