Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nBF6B6ZV210820 for <xfs@oss.sgi.com>; Tue, 15 Dec 2009 00:11:06 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 20C341BBFAEC
	for <xfs@oss.sgi.com>; Mon, 14 Dec 2009 22:11:43 -0800 (PST)
Received: from mail.internode.on.net (bld-mail19.adl2.internode.on.net
	[150.101.137.104]) by cuda.sgi.com with ESMTP id
	5wHcHP4VWptuR9l4 for <xfs@oss.sgi.com>;
	Mon, 14 Dec 2009 22:11:43 -0800 (PST)
Received: from discord (unverified [121.44.201.81])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	10009051-1927428
	for <xfs@oss.sgi.com>; Tue, 15 Dec 2009 16:41:41 +1030 (CDT)
Received: from disturbed ([192.168.1.9]) by discord with esmtp (Exim 4.69)
	(envelope-from <dave@fromorbit.com>) id 1NKQdH-0001l6-97
	for xfs@oss.sgi.com; Tue, 15 Dec 2009 17:11:39 +1100
Received: from dave by disturbed with local (Exim 4.69)
	(envelope-from <dave@disturbed.disaster>) id 1NKQcx-0000cs-QD
	for xfs@oss.sgi.com; Tue, 15 Dec 2009 17:11:19 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 0/6] XFS: Fix growfs deadlocks and per-AG use after free V3
Date: Tue, 15 Dec 2009 17:11:11 +1100
Message-Id: <1260857477-2368-1-git-send-email-david@fromorbit.com>
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

The use of an array for the xfs_perag structures results in growfs having
to realocate the array. This requires exclusion to prevent use-after-free
situations. The current locking is prone to deadlocks when growing under
load, and the xfssyncd currently has no protection against the array being
reallocated that can lead to panics.

This series abstracts the per-ag structure access and then removes the array
to replace it with individual xfs_perag structures indexed by a radix tree.
The only locking required is for the radix tree, hence the deadlocks go away
as the tree lock is always the innermost lock. The use after frees go away
as well as growfs does not need to reallocate structures fo pre-existing
allocation groups - it only needs to allocate the structures for the new
AGs and insert them into the tree.

This series also adds reference counting to the xfs-perag structure to
ensure that we balance get/put accesses to the structures and provide the
infrastructure to determine if the structure is in use or not.

Version 3: Rebase for current upstream tree.
Version 2: Fix review comments from Christoph.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
