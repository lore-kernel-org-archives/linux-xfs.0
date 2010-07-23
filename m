Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o6NExIi1207048 for <xfs@oss.sgi.com>; Fri, 23 Jul 2010 09:59:18 -0500
Received: from mail-fx0-f53.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 36E9146C883
	for <xfs@oss.sgi.com>; Fri, 23 Jul 2010 08:02:20 -0700 (PDT)
Received: from mail-fx0-f53.google.com (mail-fx0-f53.google.com
	[209.85.161.53]) by cuda.sgi.com with ESMTP id Fhz4O6fnKWvSORdo
	for <xfs@oss.sgi.com>; Fri, 23 Jul 2010 08:02:20 -0700 (PDT)
Received: by fxm19 with SMTP id 19so6022427fxm.26
	for <xfs@oss.sgi.com>; Fri, 23 Jul 2010 08:02:19 -0700 (PDT)
From: Khelben Blackstaff <eye.of.the.8eholder@gmail.com>
Subject: Re: 4k sector drives
Date: Fri, 23 Jul 2010 18:02:11 +0300
MIME-Version: 1.0
Message-Id: <201007231802.11491.eye.of.the.8eholder@gmail.com>
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

> What MAY hurt, also for large writes, are the meta-data operations while 
> writing the file. (e.g. the file-size changes, journaling ...)

> But i haven't tested that and can't say for sure how much that hurts.

It hurts a lot. On my 1TB EARS when i was benchmarking unaligned
partitions, untarring a linux kernel for example took ages. (tar output
finished quickly but then you had to wait a long time till the shell
prompt returns)

With aligned partition, performance is normal.



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
