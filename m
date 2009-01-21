Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	n0LK95Kv008529
	for <linux-xfs@oss.sgi.com>; Wed, 21 Jan 2009 14:09:05 -0600
Received: from pu01.news-service.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 059F5A87DF
	for <linux-xfs@oss.sgi.com>; Wed, 21 Jan 2009 12:09:04 -0800 (PST)
Received: from pu01.news-service.com (ns1.news-service.com [195.114.240.3]) by
	cuda.sgi.com with ESMTP id DJyEyKQthaZMW9Gb for
	<linux-xfs@oss.sgi.com>; Wed, 21 Jan 2009 12:09:04 -0800 (PST)
Received: from [172.25.4.18] (unknown [172.25.8.1])
	by pu01.news-service.com (Postfix) with ESMTP id 1EFD91FD89
	for <linux-xfs@oss.sgi.com>; Wed, 21 Jan 2009 21:09:03 +0100 (CET)
Message-ID: <497780D4.8090004@news-service.com>
Date: Wed, 21 Jan 2009 21:08:52 +0100
From: Patrick Schreurs <patrick@news-service.com>
MIME-Version: 1.0
Subject: Re: No space left on device on xfs filesystem with 1.6TB free
References: <alpine.LSU.2.00.0901211007200.19898@hermes-2.csi.cam.ac.uk>
	<gl7n76$6et$1@ger.gmane.org>
In-Reply-To: <gl7n76$6et$1@ger.gmane.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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
To: linux-xfs@oss.sgi.com

Bryon Roche wrote:
> On Wed, 21 Jan 2009 10:33:10 +0000, Owen Dunn wrote:
> 
>> I'm running SuSE Linux Enterprise Server 10 SP2, on a 32-bit i386 Linux
>> machine with kernel version 2.6.16.60-0.33-smp.  I appear to have
>> version 2.9.4 of xfsprogs.
>>
>> I have a 6TB xfs filesystem which has been grown twice from 2TB, and
>> which appears to have 1.6TB and plenty of inodes free.  However,
>> attempts to create a new file fail with ENOSPC:
> You probably need to mount with inode64 then, to allow xfs to make inodes 
> in the later space in the FS.

We've seen this on 64-bit 2.6.23.x and 2.6.27.x kernels with inode64 
mounted partitions. xfsprogs 2.8.11 (Debian Etch).

Unfortunately we've never been able to track this down.

Patrick Schreurs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
