Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 25 Jun 2008 21:41:06 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m5Q4eLlw008305
	for <xfs@oss.sgi.com>; Wed, 25 Jun 2008 21:40:22 -0700
Received: from ipmail01.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8073DD5613B
	for <xfs@oss.sgi.com>; Wed, 25 Jun 2008 21:41:21 -0700 (PDT)
Received: from ipmail01.adl6.internode.on.net (ipmail01.adl6.internode.on.net [203.16.214.146]) by cuda.sgi.com with ESMTP id kzZngU078ANtcCPg for <xfs@oss.sgi.com>; Wed, 25 Jun 2008 21:41:21 -0700 (PDT)
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 0/6] Remove most users of semaphores from XFS.
Date: Thu, 26 Jun 2008 14:41:11 +1000
Message-Id: <1214455277-6387-1-git-send-email-david@fromorbit.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com
Cc: matthew@wil.cx, linux-kernel@vger.kernel.org

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
