Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q6N6Tf6e080505 for <xfs@oss.sgi.com>; Mon, 23 Jul 2012 01:29:41 -0500
Received: from mail.amfes.com (wsip-24-120-114-53.lv.lv.cox.net
	[24.120.114.53]) by cuda.sgi.com with ESMTP id AVAihBt9bVJ9ACMG
	for <xfs@oss.sgi.com>; Sun, 22 Jul 2012 23:29:40 -0700 (PDT)
Received: from mail.amfes.com (localhost [127.0.0.1])
	(using TLSv1.1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by Postfix-ASSP.amfeslan.local (Postfix) with ESMTPSA id BED814040920
	for <xfs@oss.sgi.com>; Sun, 22 Jul 2012 23:29:34 -0700 (PDT)
Message-ID: <assp.1551ac5709.500CEF4B.8020400@amfes.com>
Date: Sun, 22 Jul 2012 23:29:31 -0700
From: "Daniel L. Miller" <dmiller@amfes.com>
MIME-Version: 1.0
Subject: Delay in folder access
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

I have an XFS partition on simple 4-disk RAID-10 array.  The array is 
mounted at /raid.  I have a variety of subfolders - one of which is 
/raid/data - which in turn has a number of subfolders.

Doing a simple "ls /raid" has no problems.  Similarly, no issues with 
"ls /raid/data/stuff".  But ... executing "ls /raid/data" results in a 
delay, sometimes in minutes, before it returns.

I don't see any errors in dmesg or syslog.  Does this indicate a pending 
crash?

Also, I do have a ".fsr" folder under /raid.  All the folders listed, 
which appear empty, are dated 11/1/2010.  Is it safe to delete ".fsr"?

-- 
Daniel

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
