Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q0NHWMlg122841 for <xfs@oss.sgi.com>; Mon, 23 Jan 2012 11:32:22 -0600
Received: from e32.co.us.ibm.com (e32.co.us.ibm.com [32.97.110.150]) by
	cuda.sgi.com with ESMTP id 4fa7aJ7To6H5JfWn for
	<xfs@oss.sgi.com>; Mon, 23 Jan 2012 09:32:21 -0800 (PST)
Received: from /spool/local
	by e32.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only!
	Violators will be prosecuted
	for <xfs@oss.sgi.com> from <sekharan@us.ibm.com>;
	Mon, 23 Jan 2012 10:32:20 -0700
Received: from d01relay03.pok.ibm.com (d01relay03.pok.ibm.com [9.56.227.235])
	by d03dlp02.boulder.ibm.com (Postfix) with ESMTP id 93BCF3E40066
	for <xfs@oss.sgi.com>; Mon, 23 Jan 2012 10:31:22 -0700 (MST)
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay03.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	q0NHVLuw185926 for <xfs@oss.sgi.com>; Mon, 23 Jan 2012 12:31:21 -0500
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id
	q0NHVKMd020438 for <xfs@oss.sgi.com>; Mon, 23 Jan 2012 12:31:20 -0500
From: Chandra Seetharaman <sekharan@us.ibm.com>
Date: Mon, 23 Jan 2012 11:31:18 -0600
Message-Id: <20120123173118.31546.3353.sendpatchset@chandra-lucid.austin.ibm.com>
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

These define some new inline functions and macros, rearrange
the code for easier reading, simplification of code paths
and prepare for the changes to support pquota and gquota
simultaneously.

This is just a repost of the patch posted on 10/27/2011:
http://marc.info/?l=linux-xfs&m=131975420304313&w=2

Regards,

chandra

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
