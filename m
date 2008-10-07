Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 07 Oct 2008 15:12:41 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m97MCK8f011221
	for <xfs@oss.sgi.com>; Tue, 7 Oct 2008 15:12:20 -0700
Received: from ipmail05.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 71EFD4C8371
	for <xfs@oss.sgi.com>; Tue,  7 Oct 2008 15:13:59 -0700 (PDT)
Received: from ipmail05.adl2.internode.on.net (ipmail05.adl2.internode.on.net [203.16.214.145]) by cuda.sgi.com with ESMTP id WFErObI40wwKcI5y for <xfs@oss.sgi.com>; Tue, 07 Oct 2008 15:13:59 -0700 (PDT)
Received: from dave by disturbed with local (Exim 4.69)
	(envelope-from <david@fromorbit.com>)
	id 1KnKoY-0002dK-Ca
	for xfs@oss.sgi.com; Wed, 08 Oct 2008 09:13:58 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 0/8] XFS: AIL cleanup and bug fixes
Date: Wed,  8 Oct 2008 09:13:50 +1100
Message-Id: <1223417638-10050-1-git-send-email-david@fromorbit.com>
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

Version 2:
o cleanup based on review comments
