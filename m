Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:48871 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S941853AbcJYPIW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Oct 2016 11:08:22 -0400
From: Christoph Hellwig <hch@lst.de>
Subject: 
Date: Tue, 25 Oct 2016 17:08:12 +0200
Message-Id: <1477408098-10153-1-git-send-email-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: axboe@fb.com, kent.overstreet@gmail.com, linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org

Subject: an iomap-based direct I/O implementation

Hi all,

this series adds a new direct I/O implementation based on the iomap
interface, and switches XFS to use it.

The first two patches are a resend of my earlier series to remove the
XFS iolock.  They are needed for the lockdep assert in the new iomap
code.

The third patch adds a new helper to the block layer that builds bio
from locked down user pages without needing an additional page array.
This helper was originally written by Kent and then heavily rewritten
by me to use the iov_iter helper that also allow non-user page backed
iov_iters.  (Kent - I kept your credits for it, if you feel this doesn't
look like your code anymore I'll happily claim it for me).  This patch
should probably go into a shared branch in the block layer tree as I
have some other users for it as well.

The rest implements a new iomap_dio_rw direct I/O implementation and
switches XFS to use it.
