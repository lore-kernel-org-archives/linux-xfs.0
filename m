Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nB125IxM085449
	for <linux-xfs@oss.sgi.com>; Mon, 30 Nov 2009 20:05:19 -0600
Received: from mail-pw0-f53.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id EE46A1904705
	for <linux-xfs@oss.sgi.com>; Mon, 30 Nov 2009 18:05:48 -0800 (PST)
Received: from mail-pw0-f53.google.com (mail-pw0-f53.google.com
	[209.85.160.53]) by cuda.sgi.com with ESMTP id YK0rfXivcQGmvV9Z
	for <linux-xfs@oss.sgi.com>; Mon, 30 Nov 2009 18:05:48 -0800 (PST)
Received: by pwj11 with SMTP id 11so2241630pwj.12
	for <linux-xfs@oss.sgi.com>; Mon, 30 Nov 2009 18:05:48 -0800 (PST)
MIME-Version: 1.0
Date: Tue, 1 Dec 2009 10:05:47 +0800
Message-ID: <389deec70911301805j37df7397l1c3ddbbad7e91768@mail.gmail.com>
Subject: can xfs_repair guarantee a complete clean filesystem?
From: hank peng <pengxihan@gmail.com>
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
To: linux-xfs@oss.sgi.com

When using xfs_repair, I want my XFS filesystem complete clean and
continue to work even if some files lost. Becase we use XFS in low-end
NAS box, customers want a tool to repair the filesystem when it has
problem and they allow some files be lost and don't want the whole
system to stop.
So, I wonder if xfs_repair or some other tools can satisfy this funciton?

-- 
The simplest is not all best but the best is surely the simplest!

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
