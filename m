Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail03.adl2.internode.on.net ([150.101.137.141]:52320 "EHLO
        ipmail03.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751271AbeDRELK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 18 Apr 2018 00:11:10 -0400
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 0/4 V2] iomap: Use FUA for O_DSYNC DIO writes
Date: Wed, 18 Apr 2018 14:08:24 +1000
Message-Id: <20180418040828.18165-1-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org, hch@lst.de, rdorr@microsoft.com

Hi folks,

This is the latest version of the "use FUA for DIO writes" patchset
that was last posted here:

https://marc.info/?l=linux-xfs&m=152213446528167&w=2

Functionality and performance is the same as the previous version.
Changes in this version address Christoph's review comments.

Version 2:
- Fixed comment typos in first patch
- simplified iomap_dio_complete_work()
- changed IOMAP_DIO_WRITE_SYNC to IOMAP_DIO_NEED_SYNC
- split blk_queue_fua() into it's own patch
- fixed formatting issue in last patch
- update bio->io_opf directly rather than use bio_set_op_attrs()
- Updated comment to mention we try to use FUA optimistically.

Cheers,

Dave.
