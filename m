Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p2B7qVLS147994 for <xfs@oss.sgi.com>; Fri, 11 Mar 2011 01:52:37 -0600
Received: from iport-c2-out.ucsd.edu (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C5E221215811
	for <xfs@oss.sgi.com>; Thu, 10 Mar 2011 23:55:22 -0800 (PST)
Received: from iport-c2-out.ucsd.edu (iport-c2-out.ucsd.edu [132.239.0.119])
	by cuda.sgi.com with ESMTP id RjZQEx26fvB59QVI for
	<xfs@oss.sgi.com>; Thu, 10 Mar 2011 23:55:22 -0800 (PST)
Received: from [128.54.20.156] (unknown [128.54.20.156])
	(using TLSv1 with cipher AES128-SHA (128/128 bits))
	(No client certificate requested)
	by cse-smtp.ucsd.edu (Postfix) with ESMTP id ECE5250047
	for <xfs@oss.sgi.com>; Thu, 10 Mar 2011 23:55:21 -0800 (PST)
From: Steven Swanson <swanson@cs.ucsd.edu>
Subject: Does XFS ever relocate extents after they are on disk?
Date: Thu, 10 Mar 2011 23:55:21 -0800
Message-Id: <903E14DC-D9EA-4BDC-8D43-FBB9AB4127BC@cs.ucsd.edu>
Mime-Version: 1.0 (Apple Message framework v1082)
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

I have simple question that I'm having trouble finding a concrete answer for:

Does XFS ever relocate a file or one of its extents once it's been written to disk?  For instance, does the file system ever decide to reorganize extents to reduce fragmentation.

I've read through all the documentation I can find, and everything points to using an external de-fragmentation tool, which suggests that XFS won't do it autonomously, but for the project we are working on it would be useful to know for certain when and under what conditions XFS might decide to move an extent that's already been written.

Thanks!

-steve

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
