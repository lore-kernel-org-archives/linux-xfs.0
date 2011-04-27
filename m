Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p3R7qHNw205474 for <xfs@oss.sgi.com>; Wed, 27 Apr 2011 02:52:18 -0500
Received: from firestarter.dermichi.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2472B41764C
	for <xfs@oss.sgi.com>; Wed, 27 Apr 2011 00:55:49 -0700 (PDT)
Received: from firestarter.dermichi.com (firestarter.dermichi.com
	[78.41.115.230]) by cuda.sgi.com with ESMTP id WHbxYEldkjjdVl6q
	for <xfs@oss.sgi.com>; Wed, 27 Apr 2011 00:55:49 -0700 (PDT)
Received: from dermichi-2-pt.tunnel.tserv23.zrh1.ipv6.he.net
	([2001:470:25:4f4::2])
	by firestarter.dermichi.com with esmtpsa (TLSv1:CAMELLIA256-SHA:256)
	(Exim 4.75) (envelope-from <mw@dermichi.com>) id 1QEzb8-0007dz-Tp
	for xfs@oss.sgi.com; Wed, 27 Apr 2011 09:55:47 +0200
Message-ID: <4DB7CC01.8090804@dermichi.com>
Date: Wed, 27 Apr 2011 09:55:45 +0200
From: Michael Weissenbacher <mw@dermichi.com>
MIME-Version: 1.0
Subject: Re: xfs performance problem
References: <4DB72084.8020205@inf.ethz.ch> <4DB74331.3030804@hardwarefreak.com>
In-Reply-To: <4DB74331.3030804@hardwarefreak.com>
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
To: xfs@oss.sgi.com

schrieb Stan Hoeppner:
> Benjamin Schindler put forth on 4/26/2011 2:44 PM:
>> Hi
> Also, slap yourself in the forehead at least 3 times for running your
> root filesystem on RAID 0.  That's akin to riding a motorcycle, naked,
> in a blizzard, down a steep, winding, ice covered mountain road with no
> guard rails and a 3000 ft drop. ;)
> 
If you are really adventurous and don't care about the data on your root
fs use the following mount options:
logbsize=256k,delaylog,nobarrier

Personally i would only enable "nobarrier" on Server-Class hardware with
Battery Backup and proper UPS. But since you are using RAID-0 i suppose
you really don't care that much about the data on your root fs.

Note that both logbsize and delaylog will only have effect on your root
fs if added to grub.conf (real_rootflags=) since remounting won't
activate them. Use "cat /proc/mounts" to see if these options were
really enabled.

hth,
Michael

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
