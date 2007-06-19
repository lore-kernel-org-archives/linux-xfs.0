Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 19 Jun 2007 06:27:34 -0700 (PDT)
Received: from mail.suse.cz (styx.suse.cz [82.119.242.94])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l5JDRSdo015125
	for <xfs@oss.sgi.com>; Tue, 19 Jun 2007 06:27:30 -0700
Message-Id: <20070619132549.266927601@suse.cz>
Date: Tue, 19 Jun 2007 15:25:49 +0200
From: mmarek@suse.cz
Subject: [patch 0/3] Fix for XFS compat ioctls (try2)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com
Cc: linux-kernel@vger.kernel.org

Hi,

here is my second attempt at fixing (some of) the XFS ioctls in compat mode.
The main difference from the first version is the bulkstat patch, which I
modified to do less copies (no unnecessary copy_in_user() anymore).

--
have a nice day,
Michal Marek
