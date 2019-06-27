Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:52018 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726382AbfF0Ksp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 Jun 2019 06:48:45 -0400
From: Christoph Hellwig <hch@lst.de>
Subject: lift the xfs writepage code into iomap v2
Date: Thu, 27 Jun 2019 12:48:23 +0200
Message-Id: <20190627104836.25446-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J . Wong" <darrick.wong@oracle.com>
Cc: Damien Le Moal <Damien.LeMoal@wdc.com>, Andreas Gruenbacher <agruenba@redhat.com>, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org

Hi all,

this series cleans up the xfs writepage code and then lifts it to
fs/iomap.c so that it could be use by other file system.  I've been
wanting to this for a while so that I could eventually convert gfs2
over to it, but I never got to it.  Now Damien has a new zonefs
file system for semi-raw access to zoned block devices that would
like to use the iomap code instead of reinventing it, so I finally
had to do the work.

This new version should have addressed all comments from the review,
except that I haven't split iomap.c, which is a little too invasive
with other pending changes to the file.  I do however offer to submit
a split right at the end of the merge window when it is least invasive.

Changes since v1:
 - rebased to the latest xfs for-next tree
 - keep the preallocated transactions for size updates
 - rename list_pop to list_pop_entry and related cleanups
 - better document the nofs context handling
 - document that the iomap tracepoints are not a stable API
