Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 13 Sep 2008 07:56:41 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8DEuWZl022213
	for <xfs@oss.sgi.com>; Sat, 13 Sep 2008 07:56:33 -0700
Received: from ipmail05.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 04DFA126C1A4
	for <xfs@oss.sgi.com>; Sat, 13 Sep 2008 07:58:03 -0700 (PDT)
Received: from ipmail05.adl2.internode.on.net (ipmail05.adl2.internode.on.net [203.16.214.145]) by cuda.sgi.com with ESMTP id ldsW8936UECYAOWV for <xfs@oss.sgi.com>; Sat, 13 Sep 2008 07:58:03 -0700 (PDT)
Received: from dave by disturbed with local (Exim 4.69)
	(envelope-from <david@fromorbit.com>)
	id 1KeWZR-0002Nl-Re
	for xfs@oss.sgi.com; Sun, 14 Sep 2008 00:57:57 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 0/8] XFS: AIL cleanup and bug fixes
Date: Sun, 14 Sep 2008 00:57:49 +1000
Message-Id: <1221317877-8333-1-git-send-email-david@fromorbit.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Clean up the AIL interfaces and the way it is referenced by
external code by making the struct xfs_ail the primary method
of accessing the AIL.

The main bug fix in this patch series is the second patch - it fixes
the restart bug in traversals of the AIL. The method used is
to track the next item in the list in a stack based cursor so
we don't need to trust the current log item after we've dropped
the AIL lock.

Because this changes the interface to the traversal code, it makes
sense to clean up the entire AIL subsystem interface while I am
there. The overall goal here is to make the struct xfs_ail the sole
structure used to access the AIL - for inserts, deletes, traversals,
locking, etc so that we don't need to reference the xfs_mount just
to get to the AIL.

This also enables us to move the struct xfs_ail definition out of
xfs_mount.h and reduce the visible scope of it to just the files
that need to access members of the structure.
