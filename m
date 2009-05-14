Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n4E0fFlX183032 for <xfs@oss.sgi.com>; Wed, 13 May 2009 19:41:15 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3E67628513F
	for <xfs@oss.sgi.com>; Wed, 13 May 2009 17:41:22 -0700 (PDT)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id Dpws71Undeunx6KK for
	<xfs@oss.sgi.com>; Wed, 13 May 2009 17:41:22 -0700 (PDT)
Message-ID: <4A0B68B2.70208@sandeen.net>
Date: Wed, 13 May 2009 19:41:22 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: file preallocation without unwritten flag being set
References: <283244.29270.qm@web65608.mail.ac4.yahoo.com>
	<4A0A0E76.6000701@sandeen.net>
	<618437.93111.qm@web65601.mail.ac4.yahoo.com>
	<4A0A55E0.4010202@sandeen.net>
	<705795.15734.qm@web65604.mail.ac4.yahoo.com>
	<20090513222823.GL16929@discord.disaster>
	<502709.63746.qm@web65615.mail.ac4.yahoo.com>
	<4A0B6325.8000706@sandeen.net>
	<20090514003422.GM16929@discord.disaster>
In-Reply-To: <20090514003422.GM16929@discord.disaster>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

Dave Chinner wrote:

>> Unmounting will flush the filesytem address space, but not the block
>> device address space.
> 
> Not exactly the problem, though. XFS opens it's own device address space
> when mounting - not the address space you get by opening /dev/sdX.
> xfs_db uses the address space associated with /dev/sdX. hence
> if you do:
> 
> # xfs_db /dev/sdc
> ....
> # mount /dev/sdc
> <do some changes>
> # unmount /dev/sdc
> # xfs_db /dev/sdc
> 
> The second invocation of xfs_db will not see any of the changes that
> occured to the filesystem because it will read from the buffers
> cached on /dev/sdc during the first invocation.
> 
> This is the same problem Grub has....

We meant the same thing, even if I said it wrong ;)

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
