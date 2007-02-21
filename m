Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 20 Feb 2007 20:04:19 -0800 (PST)
Received: from postoffice.aconex.com (mail.app.aconex.com [203.89.192.138])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l1L44Bm7032553
	for <xfs@oss.sgi.com>; Tue, 20 Feb 2007 20:04:14 -0800
Subject: Re: [PATCH] make sure xfs_repair doesn't restore corrupted primary
	superblock
From: Nathan Scott <nscott@aconex.com>
Reply-To: nscott@aconex.com
In-Reply-To: <200702210200.NAA15545@larry.melbourne.sgi.com>
References: <200702210200.NAA15545@larry.melbourne.sgi.com>
Content-Type: text/plain
Date: Wed, 21 Feb 2007 15:06:45 +1100
Message-Id: <1172030805.26078.169.camel@edge>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Barry Naujok <bnaujok@melbourne.sgi.com>
Cc: xfs@oss.sgi.com, xfs-dev@sgi.com

On Wed, 2007-02-21 at 13:05 +1100, Barry Naujok wrote:
> Phase 2 in xfs_repair fixes corrupted superblock fields, but in phase 5, the
> originally read primary superblock before the phase 2 fix is written to disk
> with updated counters. The patch in scan.c makes sure the mount point
> superblock copy is updated if the primary superblock is modified.
> 
> Included is some fixes to libxfs when IO_DEBUG is enabled.

Looks good to me.

-- 
Nathan
