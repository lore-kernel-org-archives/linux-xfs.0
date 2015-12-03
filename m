Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 018AD7F37
	for <xfs@oss.sgi.com>; Thu,  3 Dec 2015 17:24:42 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id D5D13304053
	for <xfs@oss.sgi.com>; Thu,  3 Dec 2015 15:24:38 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id A9QklyEkYDafMYyT for <xfs@oss.sgi.com>;
	Thu, 03 Dec 2015 15:24:35 -0800 (PST)
Received: from Liberator.example.com
	(74-95-67-117-Minnesota.hfc.comcastbusiness.net [74.95.67.117])
	(using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id E5A3D63C5A9F
	for <xfs@oss.sgi.com>; Thu,  3 Dec 2015 17:24:34 -0600 (CST)
Subject: Re: [PATCH v16 00/22] Richacls (Core and Ext4)
References: <1449090088-9281-1-git-send-email-agruenba@redhat.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <5660CF31.1000101@sandeen.net>
Date: Thu, 3 Dec 2015 17:24:33 -0600
MIME-Version: 1.0
In-Reply-To: <1449090088-9281-1-git-send-email-agruenba@redhat.com>
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
To: xfs@oss.sgi.com

(try again, replying to list this time, doh!)

On 12/3/15 12:48 PM, Reinoud Koornstra wrote:
> Hi Everyone,
>
> Periodically I seem to have some issues with xfs on my SSD.
> smartd reports this:
>
> Device: /dev/sdb [SAT], Crucial_CT256M550SSD3, S/N:15020ED48DF8,
> WWN:5-00a075-10ed48df8, FW:MU02, 256 GB
>
> reinoud@Mipam:~$ uname -a
> Linux Mipam 4.1.10-custom #1 SMP Tue Oct 20 11:20:40 MDT 2015 x86_64
> x86_64 x86_64 GNU/Linux
>
> The distro is ubuntu 14.04
> reinoud@Mipam:~$ xfs_repair -V
> xfs_repair version 3.2.3
>
> I am not sure if I have any errors, but I did get problems building
> some stuff after a simple hg clone or git clone that others aren't
> seeing.

Missing build dependencies maybe?   What problems?

> Earlier I did disable the write cache back.
> I just did run an xfs_repair:
>
> reinoud@Mipam:~$ sudo xfs_repair -v /dev/sdb1
> Phase 1 - find and verify superblock...
>         - block cache size set to 1515280 entries
> Phase 2 - using internal log
>         - zero log...
> zero_log: head block 26744 tail block 26744
>         - scan filesystem freespace and inode maps...
>         - found root inode chunk
> Phase 3 - for each AG...
>         - scan and clear agi unlinked lists...
>         - process known inodes and perform inode discovery...
>         - agno = 0
>         - agno = 1
>         - agno = 2
>         - agno = 3
>         - process newly discovered inodes...
> Phase 4 - check for duplicate blocks...
>         - setting up duplicate extent list...
>         - check for inodes claiming duplicate blocks...
>         - agno = 0
>         - agno = 1
>         - agno = 2
>         - agno = 3
> Phase 5 - rebuild AG headers and trees...
>         - agno = 0
>         - agno = 1
>         - agno = 2
>         - agno = 3
>         - reset superblock...
> Phase 6 - check inode connectivity...
>         - resetting contents of realtime bitmap and summary inodes
>         - traversing filesystem ...
>         - agno = 0
>         - agno = 1
>         - agno = 2
>         - agno = 3
>         - traversal finished ...
>         - moving disconnected inodes to lost+found ...
> Phase 7 - verify and correct link counts...
>
>         XFS_REPAIR Summary    Thu Dec  3 11:37:01 2015
>
> Phase           Start           End             Duration
> Phase 1:        12/03 11:36:21  12/03 11:36:21
> Phase 2:        12/03 11:36:21  12/03 11:36:27  6 seconds
> Phase 3:        12/03 11:36:27  12/03 11:36:55  28 seconds
> Phase 4:        12/03 11:36:55  12/03 11:36:58  3 seconds
> Phase 5:        12/03 11:36:58  12/03 11:36:58
> Phase 6:        12/03 11:36:58  12/03 11:37:01  3 seconds
> Phase 7:        12/03 11:37:01  12/03 11:37:01
>
> Total run time: 40 seconds
> done
> Did I have errors? I saw disconnected inodes, but other than that.....

No, that was a clean repair run.

-Eric


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
