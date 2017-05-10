Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:57097 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751432AbdEJSCT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 10 May 2017 14:02:19 -0400
From: Christoph Hellwig <hch@lst.de>
Subject: cleanup UUID types
Date: Wed, 10 May 2017 20:01:58 +0200
Message-Id: <20170510180214.16852-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Amir Goldstein <amir73il@gmail.com>, linux-fsdevel@vger.kernel.org
Cc: Shaohua Li <shli@kernel.org>, Dan Williams <dan.j.williams@intel.com>, David Howells <dhowells@redhat.com>, Steven Whitehouse <swhiteho@redhat.com>, Mimi Zohar <zohar@linux.vnet.ibm.com>, linux-xfs@vger.kernel.org, linux-raid@vger.kernel.org, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org

Hi all,

this series, which is a combined effort from Amir, Andy and me introduces
new uuid_t and guid_t type names that are less confusing than the existing
types, adds new helpers for them and starts switching the fs code over to
it.  Andy has additional patches on top to convert many of the users
that use char arrays for UUIDs and GUIDs to these (or rather a predecessor
for now until updated).


