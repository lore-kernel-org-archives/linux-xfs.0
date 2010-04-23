Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o3NB5QG9043840 for <xfs@oss.sgi.com>; Fri, 23 Apr 2010 06:05:26 -0500
Received: from b.mx.filmlight.ltd.uk (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with SMTP id A2291154877F
	for <xfs@oss.sgi.com>; Fri, 23 Apr 2010 04:07:26 -0700 (PDT)
Received: from b.mx.filmlight.ltd.uk (bongo.filmlight.ltd.uk [77.107.81.251])
	by cuda.sgi.com with SMTP id X8Pxwa974xkMtcpG for
	<xfs@oss.sgi.com>; Fri, 23 Apr 2010 04:07:26 -0700 (PDT)
Message-Id: <8A91C8CC-6DC4-4334-A2B9-ED814DAF0352@filmlight.ltd.uk>
From: Roger Willcocks <roger@filmlight.ltd.uk>
Mime-Version: 1.0 (Apple Message framework v936)
Subject: inode parent pointer attributes
Date: Fri, 23 Apr 2010 12:07:08 +0100
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

Hi folks,

Commit 6d73cf133c5477f7038577bfeda603ce9946f8cb reintroduced the
XFS_SB_VERSION2_PARENTBIT in the kernel headers, which is described
in the xfs filesystem structure document as 'All inodes must have an
extended attribute that points back to its parent inode'.

There's currently (afaict) no Linux kernel implementation of this. But
it's something I would find very useful for a filesystem extension I'm
working on.

I'm quite happy to add the necessary code to maintain parent attributes
myself, borrowing from the posix acl code, but it would make sense to
make it compatible with the original - seemingly undocumented -
attribute names and encoding scheme.

So my questions are: is this something that's being worked on already,
and/or is there any information about the corresponding extended
attributes?

--
Roger

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
