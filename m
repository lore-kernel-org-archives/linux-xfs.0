Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:36418 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751101AbdFTJCt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 20 Jun 2017 05:02:49 -0400
From: Christoph Hellwig <hch@lst.de>
Subject: simplify the Q_GETNEXTQUOTA implementation
Date: Tue, 20 Jun 2017 11:02:42 +0200
Message-Id: <20170620090244.30876-1-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: agruenba@redhat.com

Hi all,

the first patch simplifieѕ xfs_dq_get_next_id to use raw extent
list lookups instead of using the SEEK_DATA code.  This should make
it a bit more efficient and doesn't require the new iomap based
SEEK_HOLE/DATA code to support this special use case.  Note that
I've not removed various now unused bits of the lseek code to reduce
the conflicts with Andreas' work.

The second one just removes a whitespace only line I noticed while
looking at the history of the code.

