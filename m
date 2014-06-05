Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id BD4FB7F3F
	for <xfs@oss.sgi.com>; Thu,  5 Jun 2014 17:41:50 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 5410CAC006
	for <xfs@oss.sgi.com>; Thu,  5 Jun 2014 15:41:50 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	abOzTJpHeav29LrT for <xfs@oss.sgi.com>;
	Thu, 05 Jun 2014 15:41:44 -0700 (PDT)
Date: Fri, 6 Jun 2014 08:41:40 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS filesystem claims to be mounted after a disconnect
Message-ID: <20140605224140.GB4453@dastard>
References: <20140503030221.GJ26353@dastard> <538C5E67.6090005@gmail.com>
	<20140602234135.GO6677@dastard> <538D9412.3040009@gmail.com>
	<CAAxjCEzz5n85zAH5HuUQkfxKvzZt5_+cPCj3uzZR7U69H+2tDw@mail.gmail.com>
	<538DA7FF.4080002@gmail.com> <20140603212834.GG14410@dastard>
	<538E4E1B.1020003@gmail.com> <20140605005538.GB4523@dastard>
	<5390C77E.4020003@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5390C77E.4020003@gmail.com>
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
To: Martin Papik <mp6058@gmail.com>
Cc: Linux fs XFS <xfs@oss.sgi.com>

On Thu, Jun 05, 2014 at 10:39:42PM +0300, Martin Papik wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA512
> 
> Dear Dave,
> 
> Thanks for your patience, and I'd like to ask a few more questions if
> I may.
> 
> You mentioned that XFS is primarily for server type environment and
> specifically mentioned multipath access to storage devices. I had a
> setup in the past, blade center with a shared SCSI array where
> everything was duplicated. The blades had two connections one to each
> of a pair of switches, the switches had duplicated connections to two
> controllers (4 connections) and the controllers had access to the SCSI
> drives (a dozen). So in this scenario each blade had two SCSI drives
> showing for each volume on the array. So.....
> 
> Does XFS bind to both devices?

No. Use dm-multipath to make them appear as a single block device
made up as a pair of redundant paths in primary/secondary failover
or active/active load balancing configurations. dm-multipath handles
failover between the two block devices on path failure
transparently.

	  XFS
	   |
	dm-mp-0
	/    \
      sdc    sdd

The mounted filesystem doesn't even know there are multiple paths in
this configuration, however the XFS UUID trapping behaviour avoids
this problem by preventing you from doing XFS operations directly on
/dev/sdc or /dev/sdd while the filesystem is mount on
/dev/dm-mp-0....

Cheers.

Dave.

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
