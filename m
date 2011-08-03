Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p732Js6c128066 for <xfs@oss.sgi.com>; Tue, 2 Aug 2011 21:19:54 -0500
Received: from e6.ny.us.ibm.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id CE70F1863158
	for <xfs@oss.sgi.com>; Tue,  2 Aug 2011 19:19:41 -0700 (PDT)
Received: from e6.ny.us.ibm.com (e6.ny.us.ibm.com [32.97.182.146]) by
	cuda.sgi.com with ESMTP id v5X5rnxJQd3RrDR1 for
	<xfs@oss.sgi.com>; Tue, 02 Aug 2011 19:19:41 -0700 (PDT)
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e6.ny.us.ibm.com (8.14.4/8.13.1) with ESMTP id p731tXGh003904
	for <xfs@oss.sgi.com>; Tue, 2 Aug 2011 21:55:33 -0400
Received: from d03av04.boulder.ibm.com (d03av04.boulder.ibm.com [9.17.195.170])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	p732IOcs172810 for <xfs@oss.sgi.com>; Tue, 2 Aug 2011 22:18:24 -0400
Received: from d03av04.boulder.ibm.com (loopback [127.0.0.1])
	by d03av04.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP
	id p72KINKP026754
	for <xfs@oss.sgi.com>; Tue, 2 Aug 2011 14:18:23 -0600
From: Chandra Seetharaman <sekharan@us.ibm.com>
Date: Tue, 02 Aug 2011 19:18:23 -0700
Message-Id: <20110803021823.29700.71553.sendpatchset@chandra-lucid.beaverton.ibm.com>
Subject: [PATCH 0/2] Check return value of xfs_buf_read()
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: Chandra Seetharaman <sekharan@us.ibm.com>

Hello All,

While doing the previous clean up Alex noted that some of the places
where xfs_buf_read() returns, the return value is not checked for NULL.

This set check for the return value and returns failure if NULL and also
avoids using xfs_buf_geterror() when not needed.

Thanks & Regards,

chandra

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
