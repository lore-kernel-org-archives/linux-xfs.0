Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n9Q10T2l174764 for <xfs@oss.sgi.com>; Sun, 25 Oct 2009 20:00:29 -0500
Received: from mail-gx0-f220.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E317FC54EEA
	for <xfs@oss.sgi.com>; Sun, 25 Oct 2009 18:02:04 -0700 (PDT)
Received: from mail-gx0-f220.google.com (mail-gx0-f220.google.com
	[209.85.217.220]) by cuda.sgi.com with ESMTP id
	HjfaL6J9h3ojC3jG for <xfs@oss.sgi.com>;
	Sun, 25 Oct 2009 18:02:04 -0700 (PDT)
Received: by gxk20 with SMTP id 20so14532353gxk.12
	for <xfs@oss.sgi.com>; Sun, 25 Oct 2009 18:02:04 -0700 (PDT)
Message-ID: <4AE4F4FC.5090900@gmail.com>
Date: Mon, 26 Oct 2009 12:01:48 +1100
From: Steven Adams <stevezau@gmail.com>
MIME-Version: 1.0
Subject: Slow performance
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
To: xfs@oss.sgi.com

Hi All,

I am using XFS for the first time of one of my servers. I was using 
rsync to copy the files from the old server to the new server and 
noticed that every 5-6 transfer the speeds would slow down to only 
1-2MB/s and sometimes stop all together.

I suspected this was due to the cache/memory getting filled up so XFS 
has to write the changes to the sata drive. I tried to turn off 
write-cache and nobarriers but still have the same problem..

When i try it on the ext3 filesystem it runs at a constant transfer speed.

Is this normal with the XFS filesystem?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
