Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:40002 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753911AbdF0Vsd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 27 Jun 2017 17:48:33 -0400
From: Christoph Hellwig <hch@lst.de>
Subject: lseek SEEK_HOLE / SEEK_DATA fixes and switch to iomap V3-hch
Date: Tue, 27 Jun 2017 14:48:22 -0700
Message-Id: <20170627214828.1029-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Andreas Gruenbacher <agruenba@redhat.com>
Cc: Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org, linux-ext4@vger.kernel.org

Here is my take on all the current seek work.  It has my XFS quota changes
(unmodified from last post), Andrea's page cache seek helper (unmodified
except that the export is dropped), and Andreas iomap SEEK_HOLE / DATA,
for which I've added a couple of cleanups and converted ext4 as well.

I've made sure both xfs and ext4 pass all the xfstests.
