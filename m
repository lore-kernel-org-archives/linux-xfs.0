Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:54687 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750973AbdE1KUQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 28 May 2017 06:20:16 -0400
From: Christoph Hellwig <hch@lst.de>
Subject: cleanup UUID types V5
Date: Sun, 28 May 2017 13:19:46 +0300
Message-Id: <20170528102008.30276-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Amir Goldstein <amir73il@gmail.com>, linux-fsdevel@vger.kernel.org
Cc: Shaohua Li <shli@kernel.org>, Dan Williams <dan.j.williams@intel.com>, David Howells <dhowells@redhat.com>, Steven Whitehouse <swhiteho@redhat.com>, Mimi Zohar <zohar@linux.vnet.ibm.com>, linux-xfs@vger.kernel.org, linux-raid@vger.kernel.org, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, linux-block@vger.kernel.org

Hi all,

this series, which is a combined effort from Amir, Andy and me introduces
new uuid_t and guid_t type names that are less confusing than the existing
types, adds new helpers for them and starts switching the fs code over to
it.  Andy has additional patches on top to convert many of the users
that use char arrays for UUIDs and GUIDs to these (or rather a predecessor
for now until updated).

Changes since V4:
 - removed the patch to remove uuid_be for now
 - move the md patch to the front of the queue
 - remove the union for V1 uuids and provide accessors instead
 - new patch to set s_uuid for tmpfs
 - revert the patch that moved struct uuid_v1 from afs to the core
 - implement the fsid generation differently in XFS due to the
   change above
 - add a MAINTAINERS entry

Changes since V3:
 - stop exposing uuid_be/uuid_t to userspace
 - remove uuid_be entirely

Changes since V2:
 - various cleanups
