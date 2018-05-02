Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail03.adl2.internode.on.net ([150.101.137.141]:19610 "EHLO
        ipmail03.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750932AbeEBGCH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 2 May 2018 02:02:07 -0400
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 0/3 v3] iomap: Use FUA for O_DSYNC DIO writes
Date: Wed,  2 May 2018 15:38:04 +1000
Message-Id: <20180502053807.13846-1-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org, hch@lst.de, rdorr@microsoft.com

Hi folks,

Version 3 of the FUA for O-DSYNC patchset. This version fixes bugs
found in the previous version. Functionality is otherwise the same
as described in the first version:

https://marc.info/?l=linux-xfs&m=152213446528167&w=2

Version 3:

- fixed O_SYNC behaviour as noticed by Jan Kara
- fixed use after free on IO completion due
  iomap_dio_complete_work() simplification added in version 2. Found
  by KASAN when running xfstests.

Version 2:
- Fixed comment typos in first patch
- simplified iomap_dio_complete_work()
- changed IOMAP_DIO_WRITE_SYNC to IOMAP_DIO_NEED_SYNC
- split blk_queue_fua() into it's own patch
- fixed formatting issue in last patch
- update bio->io_opf directly rather than use bio_set_op_attrs()
- Updated comment to mention we try to use FUA optimistically.


