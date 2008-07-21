Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 21 Jul 2008 04:45:55 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m6LBjqHG021620
	for <xfs@oss.sgi.com>; Mon, 21 Jul 2008 04:45:52 -0700
Received: from ipmail01.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2008C30D986
	for <xfs@oss.sgi.com>; Mon, 21 Jul 2008 04:47:01 -0700 (PDT)
Received: from ipmail01.adl6.internode.on.net (ipmail01.adl6.internode.on.net [203.16.214.146]) by cuda.sgi.com with ESMTP id wEuGa0OHuxKqohpZ for <xfs@oss.sgi.com>; Mon, 21 Jul 2008 04:47:01 -0700 (PDT)
Received: from dave by disturbed with local (Exim 4.69)
	(envelope-from <david@fromorbit.com>)
	id 1KKtr1-0005G7-2G
	for xfs@oss.sgi.com; Mon, 21 Jul 2008 21:46:59 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 0/3] XFS: sanitise VFS inode extraction V2
Date: Mon, 21 Jul 2008 21:46:56 +1000
Message-Id: <1216640819-19924-1-git-send-email-david@fromorbit.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Getting the VFS inode from the XFS inode is done in a variety of
ways right now - direct deference or one of two XFS_ITOV macros.
This should be consistent throughout the code - this patch
series does that in a way that is consistent with the opposite
XFS_I() conversion. We now use VFS_I() to extract the VFS inode
from the XFS inode.

Version 2:
o don't use vn_to_inode() and inode_to_vn() functions as they
  are not needed
o rediff patches 2 and 3 against the change patch.
