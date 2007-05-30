Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 30 May 2007 07:55:37 -0700 (PDT)
Received: from mail.suse.cz (styx.suse.cz [82.119.242.94])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l4UEtTWt018599
	for <xfs@oss.sgi.com>; Wed, 30 May 2007 07:55:30 -0700
Message-Id: <20070530125954.706423971@suse.cz>
Date: Wed, 30 May 2007 14:59:54 +0200
From: Michal Marek <mmarek@suse.cz>
Subject: [patch 0/3] Fix for XFS compat ioctls
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com
Cc: linux-kernel@vger.kernel.org

Hi,

it looks like the XFS compat ioctl interface
(fs/xfs/linux-2.6/xfs_ioctl32.c) is quite incomplete. Attached patches
fix some ioctls to make at least xfsdump work. Tested on x86_64 with an
i386 xfsdump binary, I'll test on ppc64 later.

-- 
have a nice day,
Michal Marek
