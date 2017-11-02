Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:56639 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934221AbdKBUN6 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 2 Nov 2017 16:13:58 -0400
Date: Thu, 2 Nov 2017 21:13:56 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 10/15] IB/core: disable memory registration of
        fileystem-dax vmas
Message-ID: <20171102201356.GD5732@lst.de>
References: <150949209290.24061.6283157778959640151.stgit@dwillia2-desk3.amr.corp.intel.com> <150949214929.24061.10464887309708944817.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <150949214929.24061.10464887309708944817.stgit@dwillia2-desk3.amr.corp.intel.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-nvdimm@lists.01.org, Sean Hefty <sean.hefty@intel.com>, linux-xfs@vger.kernel.org, akpm@linux-foundation.org, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, Jeff Moyer <jmoyer@redhat.com>, stable@vger.kernel.org, hch@lst.de, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, linux-mm@kvack.org, Doug Ledford <dledford@redhat.com>, linux-fsdevel@vger.kernel.org, Ross Zwisler <ross.zwisler@linux.intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>

Any chance we could add a new get_user_pages_longerm or similar
helper instead of opencoding this in the various callers?
