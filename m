Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n4O7Qpnj036132 for <xfs@oss.sgi.com>; Sun, 24 May 2009 02:26:52 -0500
Received: from rv-out-0708.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 55EE11A144F8
	for <xfs@oss.sgi.com>; Sun, 24 May 2009 00:27:04 -0700 (PDT)
Received: from rv-out-0708.google.com (rv-out-0708.google.com
	[209.85.198.241]) by cuda.sgi.com with ESMTP id
	AXQnzRSnjQ9G5B6q for <xfs@oss.sgi.com>;
	Sun, 24 May 2009 00:27:04 -0700 (PDT)
Received: by rv-out-0708.google.com with SMTP id k29so736957rvb.32
	for <xfs@oss.sgi.com>; Sun, 24 May 2009 00:27:03 -0700 (PDT)
MIME-Version: 1.0
Date: Sun, 24 May 2009 15:27:02 +0800
Message-ID: <7fe205990905240027t15a0bb4ew68d7c328d8ebeee0@mail.gmail.com>
Subject: Any fast way to make an ever pre-allocated extent become unwritten
	again?
From: Joe Hsu <nagual.hsu@gmail.com>
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

    I do really need this. When pre-allocated, files are not
fragmented. After writing data to these files, I just want to make the
extent un-written again, using the same allocated blocks. I can only
initialize these files as un-fragmented in the beginning and I don't
want to over-write them simply after they are fully written because
over-writings can cause input traffic(partial updating of some
blocks), thus lowering output performance.

    Thanks if any one can give me some idea. (Except dirty hacks into
xfs filesystem kernel codes).
-- 
The sun is shinny but the ice is slippery.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
