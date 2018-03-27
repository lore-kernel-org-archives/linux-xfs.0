Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:27030 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752125AbeC0HHb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 27 Mar 2018 03:07:31 -0400
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 0/3 V2] iomap: Use FUA for O_DSYNC DIO writes
Date: Tue, 27 Mar 2018 18:07:14 +1100
Message-Id: <20180327070717.7107-1-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org, hch@lst.de, rdorr@microsoft.com

Hi folks,

This is a followup on my original patch to enable use of FUA writes
for pure data O_DSYNC writes through the XFS and iomap based direct
IO paths. This version has all of the changes christoph asked for,
and splits it up into simpler patches. The performance improvements
are detailed in the commit description of the third patch.

Changes from the original patch:
- put XFS generic_write_sync call de-factoring into it's own patch
- the change for iomap_dio_rw() to handle all aspects of O_DSYNC
  writes was pushed into it's own patch
- changed the flag and logic for tracking if FUA is in use though
  the iomap DIO paths
- only enable use of FUA is the underlying device supports FUA
  operations.

Thoughts and comments welcome.

Cheers,

Dave.
