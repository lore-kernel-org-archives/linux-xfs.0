Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:53511 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751348AbdHXPWO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 24 Aug 2017 11:22:14 -0400
From: Christoph Hellwig <hch@lst.de>
Subject: synchronous page faults for XFS
Date: Thu, 24 Aug 2017 17:22:04 +0200
Message-Id: <20170824152207.30729-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jan Kara <jack@suse.cz>
Cc: linux-fsdevel@vger.kernel.org, linux-nvdimm@lists.01.org, linux-xfs@vger.kernel.org, Ross Zwisler <ross.zwisler@linux.intel.com>, Dan Williams <dan.j.williams@intel.com>

Hi Jan,

the three patches below wire up the synchronous page fault code for XFS.
I've only verified it by making sure we always use the synchronous fault
path and then running xfstests, so don't use it for critical applications
just yet :)

This is against the current tree at:

    git://git.kernel.org//pub/scm/linux/kernel/git/jack/linux-fs.git dax_sync_fault
