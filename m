Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oBNF0biv189897 for <xfs@oss.sgi.com>; Thu, 23 Dec 2010 09:00:37 -0600
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 35FBD21B9AC
	for <xfs@oss.sgi.com>; Thu, 23 Dec 2010 07:02:35 -0800 (PST)
Received: from mail.sandeen.net (64-131-28-21.usfamily.net [64.131.28.21]) by
	cuda.sgi.com with ESMTP id gzxMSkzffRIRB5QE for
	<xfs@oss.sgi.com>; Thu, 23 Dec 2010 07:02:35 -0800 (PST)
Message-ID: <4D13648B.8000105@sandeen.net>
Date: Thu, 23 Dec 2010 09:02:35 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: no rw xfs file systems in mtab: /proc/mounts
References: <AANLkTi=Xes02L3XfZvUu6Yh2yi2FR8GtpVdOGzngVjJk@mail.gmail.com>
In-Reply-To: <AANLkTi=Xes02L3XfZvUu6Yh2yi2FR8GtpVdOGzngVjJk@mail.gmail.com>
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
To: Honza Fikar <j.fikar@gmail.com>
Cc: xfs@oss.sgi.com

On 12/23/10 6:32 AM, Honza Fikar wrote:
> Hi guys,
> 
> when I try "xfs_fsr -v -d" on my two computers, it says now:
> 
> no rw xfs file systems in mtab: /proc/mounts

hm that's a little confusing, what it means is it looked
in /proc/mounts and did not find anything, or so it thought.


As a result of:

89e4b5bd5615edc584a5111c86f12b4f89f8dd7d xfs_fsr: use /proc/mounts if available

What does your /proc/mounts show?

-Eric

> while actually there is the LUKS encrypted root:
> ...
> /dev/mapper/root / xfs
> rw,noatime,attr2,inode64,logbufs=8,logbsize=256k,noquota 0 0
> ...
> 
> on the third computer it works as expected, there are two xfs file
> systems, one of them LUKS encrypted:
> ...
> /dev/root / xfs
> rw,noatime,attr2,delaylog,inode64,logbufs=8,logbsize=256k,noquota 0 0
> /dev/mapper/encrypted /home xfs
> rw,noatime,attr2,delaylog,inode64,logbufs=8,logbsize=256k,sunit=512,swidth=1536,noquota
> 0 0
> ...
> 
> and it was working some time ago on all the three computers
> 
> distribution gentoo
> xfsprogs 3.1.4, but I just tried git version and it's the same
> kernel 2.6.32, on the third machine 2.6.35
> 
> Best regards,
> Honza
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
