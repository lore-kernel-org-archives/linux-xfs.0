Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 27 Jun 2008 01:44:06 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m5R8hmUK025173
	for <xfs@oss.sgi.com>; Fri, 27 Jun 2008 01:43:48 -0700
Received: from ipmail04.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0FB54D64442
	for <xfs@oss.sgi.com>; Fri, 27 Jun 2008 01:44:49 -0700 (PDT)
Received: from ipmail04.adl2.internode.on.net (ipmail04.adl2.internode.on.net [203.16.214.57]) by cuda.sgi.com with ESMTP id EoUjvsfhuDVgsN5Y for <xfs@oss.sgi.com>; Fri, 27 Jun 2008 01:44:49 -0700 (PDT)
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 0/6] Remove most users of semaphores from XFS V2.
Date: Fri, 27 Jun 2008 18:44:38 +1000
Message-Id: <1214556284-4160-1-git-send-email-david@fromorbit.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com
Cc: linux-kernel@vger.kernel.org, matthew@wil.cx, dwalker@mvista.com

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
