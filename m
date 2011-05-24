Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p4OGrkxj084832 for <xfs@oss.sgi.com>; Tue, 24 May 2011 11:53:47 -0500
Received: from mail-pz0-f53.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1EC471BE7AF3
	for <xfs@oss.sgi.com>; Tue, 24 May 2011 09:53:45 -0700 (PDT)
Received: from mail-pz0-f53.google.com (mail-pz0-f53.google.com
	[209.85.210.53]) by cuda.sgi.com with ESMTP id ZHEKS5hJPOkYAsPq
	for <xfs@oss.sgi.com>; Tue, 24 May 2011 09:53:45 -0700 (PDT)
Received: by pzk6 with SMTP id 6so3566055pzk.26
	for <xfs@oss.sgi.com>; Tue, 24 May 2011 09:53:45 -0700 (PDT)
Message-ID: <4DDBE293.8030203@philkarn.net>
Date: Tue, 24 May 2011 09:53:39 -0700
From: Phil Karn <karn@philkarn.net>
MIME-Version: 1.0
Subject: automatically running fstrim
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

Now that the Linux 2.6.39 kernel is out, is there any reason I shouldn't
run fstrim out of my crontab? It doesn't seem to slow down my system
significantly while it runs.

As I understand fstrim, it walks through the file system free list
issuing TRIMs for each entry, and except for whatever load the TRIM
commands themselves generate (which is drive dependent) it shouldn't
interfere that much with system operation. Correct? Is there any
mechanism to issue these commands at a lower priority than regular disk I/O?

Thanks for all the work you guys do on XFS. It is much appreciated.

Phil

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
