Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n9Q4QJgt184523 for <xfs@oss.sgi.com>; Sun, 25 Oct 2009 23:26:19 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8E9A017C6FE9
	for <xfs@oss.sgi.com>; Sun, 25 Oct 2009 21:27:56 -0700 (PDT)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id BefVOv65lUqnQyP9 for
	<xfs@oss.sgi.com>; Sun, 25 Oct 2009 21:27:56 -0700 (PDT)
Message-ID: <4AE5254F.3060105@sandeen.net>
Date: Sun, 25 Oct 2009 23:27:59 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Slow performance
References: <4AE4F4FC.5090900@gmail.com>
In-Reply-To: <4AE4F4FC.5090900@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Steven Adams <stevezau@gmail.com>
Cc: xfs@oss.sgi.com

Steven Adams wrote:
> Hi All,
> 
> I am using XFS for the first time of one of my servers. I was using 
> rsync to copy the files from the old server to the new server and 
> noticed that every 5-6 transfer the speeds would slow down to only 
> 1-2MB/s and sometimes stop all together.
> 
> I suspected this was due to the cache/memory getting filled up so XFS 
> has to write the changes to the sata drive. I tried to turn off 
> write-cache and nobarriers but still have the same problem..
> 
> When i try it on the ext3 filesystem it runs at a constant transfer speed.
> 
> Is this normal with the XFS filesystem?
> 

We looked at this a bit on irc tonight and even streaming direct IO to a 
contiguous xfs file was going very very slow.  I think he also tested 
direct IO reads from the device, and found them slow as well, so the 
problem may well be beneath xfs.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
