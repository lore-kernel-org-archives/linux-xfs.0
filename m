Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 10 Jul 2008 18:12:51 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m6B1CmM3017315
	for <xfs@oss.sgi.com>; Thu, 10 Jul 2008 18:12:48 -0700
Received: from ipmail01.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6A28018B0C60
	for <xfs@oss.sgi.com>; Thu, 10 Jul 2008 18:13:53 -0700 (PDT)
Received: from ipmail01.adl6.internode.on.net (ipmail01.adl6.internode.on.net [203.16.214.146]) by cuda.sgi.com with ESMTP id MCycY5cWG4QEg4jL for <xfs@oss.sgi.com>; Thu, 10 Jul 2008 18:13:53 -0700 (PDT)
From: Dave Chinner <david@fromorbit.com>
Subject: [RESEND, PATCH 0/6] Remove most users of semaphores from XFS
Date: Fri, 11 Jul 2008 11:13:44 +1000
Message-Id: <1215738830-31048-1-git-send-email-david@fromorbit.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com
Cc: linux-kernel@vger.kernel.org, matthew@wil.cx

This series aims to convert all but one of the remaining users of
semaphores in the XFS code to use completions. Two of these
semaphores don't quite match to completion semantics, but a small
amount of additional code on top of the completions fixes this
problem. I'm open to suggestions on different/better ways to implement
this.

The patch series does not touch the b_lock semaphore in the
xfs_buf_t. At this point I'm not sure what we want to do with that
semaphore so I've ignored that for now. Also, this lock uses
linux primitives, not the xfs sema_t primitives so  it doesn't
need changing to allow me to remove the sema_t.

Version 2:
o remove "flush" based API and just add the minimum necessary
  extensions to allow counting completions to do what is needed
    by XFS.
    o change XFS patches to make use of new API
    o clean up the XFS APIs using the new completion API a little.
