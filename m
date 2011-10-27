Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p9RM7suA122581 for <xfs@oss.sgi.com>; Thu, 27 Oct 2011 17:07:54 -0500
Received: from e5.ny.us.ibm.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 45AE01FE5D4
	for <xfs@oss.sgi.com>; Thu, 27 Oct 2011 15:07:53 -0700 (PDT)
Received: from e5.ny.us.ibm.com (e5.ny.us.ibm.com [32.97.182.145]) by
	cuda.sgi.com with ESMTP id CbF1w2SLQ8GcAg5X for
	<xfs@oss.sgi.com>; Thu, 27 Oct 2011 15:07:53 -0700 (PDT)
Received: from /spool/local
	by e5.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only!
	Violators will be prosecuted
	for <xfs@oss.sgi.com> from <sekharan@us.ibm.com>;
	Thu, 27 Oct 2011 18:05:37 -0400
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay05.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	p9RM5Ui6198834 for <xfs@oss.sgi.com>; Thu, 27 Oct 2011 18:05:31 -0400
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id
	p9RM5P6H032102 for <xfs@oss.sgi.com>; Thu, 27 Oct 2011 18:05:25 -0400
From: Chandra Seetharaman <sekharan@us.ibm.com>
Date: Thu, 27 Oct 2011 17:05:23 -0500
Message-Id: <20111027220523.2638.12351.sendpatchset@chandra-lucid.austin.ibm.com>
Subject: [RFC PATCH 0/4] Rearrange code to make the code more readable
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

These are the split up patches from patch 1/5 that I posted today, as
suggested by Christoph.

These define some new inline functions and macros, rearrange
the code for easier reading, simplification of code paths
and prepare for the changes to support pquota and gquota
simultaneously.

Regards,

chandra

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
