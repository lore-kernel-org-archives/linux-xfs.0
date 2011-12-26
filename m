Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pBQKJ26B259642 for <xfs@oss.sgi.com>; Mon, 26 Dec 2011 14:19:03 -0600
Received: from out2.smtp.messagingengine.com (out2.smtp.messagingengine.com
	[66.111.4.26]) by cuda.sgi.com with ESMTP id daElgIPw2m9GSwaP
	for <xfs@oss.sgi.com>; Mon, 26 Dec 2011 12:19:00 -0800 (PST)
Received: from compute4.internal (compute4.nyi.mail.srv.osa [10.202.2.44])
	by gateway1.nyi.mail.srv.osa (Postfix) with ESMTP id 580752092E
	for <xfs@oss.sgi.com>; Mon, 26 Dec 2011 15:18:59 -0500 (EST)
Received: from davidb.org (dweb.davidb.org [173.255.246.16])
	by mail.messagingengine.com (Postfix) with ESMTPSA id F18EA4827CB
	for <xfs@oss.sgi.com>; Mon, 26 Dec 2011 15:18:58 -0500 (EST)
Date: Mon, 26 Dec 2011 12:18:56 -0800
From: David Brown <davidb@davidb.org>
Subject: xfsrestore: incorrect restore if file becomes a dir
Message-ID: <20111226201856.GA3909@davidb.org>
MIME-Version: 1.0
Content-Disposition: inline
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

http://oss.sgi.com/bugzilla/show_bug.cgi?id=915

I've had this happen again.  It appears to be the case if between
incremental dumps, a file is deleted and a directory is created that
gets the same inode number.  The restore leaves a file in place of the
directory.  If the new directory has any contents, xfsrestore prints a
warning, and doesn't restore the subdirectory contents.

Given the sparseness of inodes, this doesn't seem to occur all that
frequently, but I do have a couple of backups that exhibit the
behavior.  If no one has any ideas, I'll start digging through
xfsrestore to see if I can figure out what is happening.

Thanks,
David Brown

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
