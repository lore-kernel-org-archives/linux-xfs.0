Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n9K5eGCR127931 for <xfs@oss.sgi.com>; Tue, 20 Oct 2009 00:40:17 -0500
Received: from Ishtar.sc.tlinx.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7A41811B2A82
	for <xfs@oss.sgi.com>; Mon, 19 Oct 2009 22:41:49 -0700 (PDT)
Received: from Ishtar.sc.tlinx.org (ishtar.tlinx.org [64.81.245.74]) by
	cuda.sgi.com with ESMTP id uiPa7NKwoBBywyxS for
	<xfs@oss.sgi.com>; Mon, 19 Oct 2009 22:41:49 -0700 (PDT)
Received: from [192.168.3.11] (Athena [192.168.3.11])
	by Ishtar.sc.tlinx.org (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n9K5fltx027585 for <xfs@oss.sgi.com>; Mon, 19 Oct 2009 22:41:49 -0700
Message-ID: <4ADD4D9B.9090808@tlinx.org>
Date: Mon, 19 Oct 2009 22:41:47 -0700
From: "Linda A. Walsh" <xfs@tlinx.org>
MIME-Version: 1.0
Subject: xfs_fsr: XFS_IOC_SWAPEXT failed : busy?m
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
To: xfs-oss <xfs@oss.sgi.com>

I noticed a weird message from my daily fsr run -- looks like it is on the
root partition.  

Does this mean the file was busy? (hopefully? :-))

(all 10 passes...but they were only about 2 seconds apart...disks are
apparently not very frag'ed... :-))...

tnx,
-linda



Oct 19 02:05:33 Ishtar fsr[20913]: / start inode=0
Oct 19 02:05:33 Ishtar fsr[20906]: XFS_IOC_SWAPEXT failed: ino=16781994: Invalid argument
Oct 19 02:05:33 Ishtar fsr[20907]: /var start inode=0
...
Oct 19 02:05:35 Ishtar fsr[20913]: / start inode=0
Oct 19 02:05:35 Ishtar fsr[20913]: XFS_IOC_SWAPEXT failed: ino=16781994: Invalid argument


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
