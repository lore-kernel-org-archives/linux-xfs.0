Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p52GHKoe210139 for <xfs@oss.sgi.com>; Thu, 2 Jun 2011 11:17:22 -0500
Received: from greer.hardwarefreak.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 44E0F14E26B5
	for <xfs@oss.sgi.com>; Thu,  2 Jun 2011 09:17:19 -0700 (PDT)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id Fx1R9bcrdeU0lxkb
	for <xfs@oss.sgi.com>; Thu, 02 Jun 2011 09:17:19 -0700 (PDT)
Message-ID: <4DE7B78C.4040608@hardwarefreak.com>
Date: Thu, 02 Jun 2011 11:17:16 -0500
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: I/O hang, possibly XFS, possibly general
References: <BANLkTim_BCiKeqi5gY_gXAcmg7JgrgJCxQ@mail.gmail.com>
In-Reply-To: <BANLkTim_BCiKeqi5gY_gXAcmg7JgrgJCxQ@mail.gmail.com>
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
To: Paul Anderson <pha@umich.edu>
Cc: xfs-oss <xfs@oss.sgi.com>

On 6/2/2011 9:42 AM, Paul Anderson wrote:

> had mounted the filesystem with inode64,largeio,logbufs=8,noatime.

I don't see 'delaylog' in your mount options nor an external log device
specified.  Delayed logging will dramatically decrease IOPs to the log
device via cleverly discarding duplicate metadata write operations and
other tricks.  Enabling it may solve your problem given your high
metadata workload.  Delayed logging design document:

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=blob;f=Documentation/filesystems/xfs-delayed-logging-design.txt

Delaylog was an optional mount option from 2.6.35 to 2.6.38.  In 2.6.39
and up it is the default.  Give it a go.

-- 
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
