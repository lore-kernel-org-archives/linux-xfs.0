Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nB26BAvj217321 for <xfs@oss.sgi.com>; Wed, 2 Dec 2009 00:11:10 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9A1E61DA2F83
	for <xfs@oss.sgi.com>; Tue,  1 Dec 2009 22:11:39 -0800 (PST)
Received: from mail.internode.on.net (bld-mail19.adl2.internode.on.net
	[150.101.137.104]) by cuda.sgi.com with ESMTP id
	jHk68dOeNOq937E2 for <xfs@oss.sgi.com>;
	Tue, 01 Dec 2009 22:11:39 -0800 (PST)
Received: from discord (unverified [121.44.201.81])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	9273423-1927428
	for <xfs@oss.sgi.com>; Wed, 02 Dec 2009 16:41:38 +1030 (CDT)
Received: from disturbed ([192.168.1.9]) by discord with esmtp (Exim 4.69)
	(envelope-from <dave@fromorbit.com>) id 1NFiR5-0000gC-4A
	for xfs@oss.sgi.com; Wed, 02 Dec 2009 17:11:35 +1100
Received: from dave by disturbed with local (Exim 4.69)
	(envelope-from <dave@disturbed.disaster>) id 1NFiRD-0005Kn-3o
	for xfs@oss.sgi.com; Wed, 02 Dec 2009 17:11:43 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 0/6] [XFS] Fix growfs deadlocks and per-AG use after free
Date: Wed,  2 Dec 2009 17:11:33 +1100
Message-Id: <1259734299-20306-1-git-send-email-david@fromorbit.com>
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

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
