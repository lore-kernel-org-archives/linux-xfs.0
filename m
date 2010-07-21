Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o6L7osiM067639 for <xfs@oss.sgi.com>; Wed, 21 Jul 2010 02:50:54 -0500
Received: from mail-bw0-f53.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6861BBF738C
	for <xfs@oss.sgi.com>; Wed, 21 Jul 2010 01:00:40 -0700 (PDT)
Received: from mail-bw0-f53.google.com (mail-bw0-f53.google.com
	[209.85.214.53]) by cuda.sgi.com with ESMTP id jvtcCU5a3AKYypKY
	for <xfs@oss.sgi.com>; Wed, 21 Jul 2010 01:00:40 -0700 (PDT)
Received: by bwz6 with SMTP id 6so4360334bwz.26
	for <xfs@oss.sgi.com>; Wed, 21 Jul 2010 00:53:53 -0700 (PDT)
From: Khelben Blackstaff <eye.of.the.8eholder@gmail.com>
Subject: RE: 4k sector drives
Date: Wed, 21 Jul 2010 10:53:45 +0300
MIME-Version: 1.0
Message-Id: <201007211053.45191.eye.of.the.8eholder@gmail.com>
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

> shows a jumper exists for "advanced format", but doesn't tell what it 
> does. I'll try to set or unset it depending on what it is now, and see 
> if there's a difference.

No, don't set the jumper.

Because DOS required the first head to be empty for some reason
and because allmost every geometry uses 63 sectors per track,
the first partition usually starts at sector 63. The jumper tells the
disk firmware to use a mapping so that the sectors fall in a 4096
boundary. (It uses either +1 or -7 offset). So, the OS thinks it writes
to sector 63 while it truly writes to sector 64 (or 56). Every sector
is transparently mapped using this offset.

This jumper exists to be used only with legacy OSes like Windows XP
and makes sense when there is only one primary partition which covers
the whole disk.

So, don't use the jumper in linux but align properly the partitions.
fdisk from util-linux-ng > 0.17 align on 1MB so everything will be fine.
If you use an older version then align the partitions manually.

WD EARS drives with 00Y model revision doesn't report the sector size
properly and only report 512 bytes. (Use hdparm to see it)
Those with 00Z revision report correctly that they have 4096 physical
sector size and 512 logical sector size.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
