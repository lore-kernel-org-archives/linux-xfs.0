Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:33731 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751250AbdHEJuP (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sat, 5 Aug 2017 05:50:15 -0400
Date: Sat, 5 Aug 2017 11:50:13 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v2 0/5] fs, xfs: block map immutable files for dax,
        dma-to-storage, and swap
Message-ID: <20170805095013.GC14930@lst.de>
References: <150181368442.32119.13336247800141074356.stgit@dwillia2-desk3.amr.corp.intel.com> <CAPcyv4ii41F-Rj9pPGc0FHwrQ=hkSF_f0niQDn5_NjU-wcL+gg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPcyv4ii41F-Rj9pPGc0FHwrQ=hkSF_f0niQDn5_NjU-wcL+gg@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dan Williams <dan.j.williams@intel.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, Jan Kara <jack@suse.cz>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Dave Chinner <david@fromorbit.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, linux-xfs@vger.kernel.org, Jeff Moyer <jmoyer@redhat.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Andy Lutomirski <luto@kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Ross Zwisler <ross.zwisler@linux.intel.com>, Christoph Hellwig <hch@lst.de>, Linux API <linux-api@vger.kernel.org>

On Thu, Aug 03, 2017 at 07:38:11PM -0700, Dan Williams wrote:
> [ adding linux-api to the cover letter for notification, will send the
> full set to linux-api for v3 ]

Just don't send this crap ever again.  All the so called use cases in the
earlier thread were incorrect and highly dangerous.

Promising that the block map is stable is not a useful userspace API,
as it the block map is a complete internal implementation detail.

We've been through this a few times but let me repeat it:  The only
sensible API gurantee is one that is observable and usable.

so Jan's synchronous page fault flag in one form or another makes
perfect sense as it is a clear receipe for the user:  you don't
have to call msync to persist your mmap writes.  This API is not,
it guarantees that the block map does not change, but the application
has absolutely no point of even knowing about the block map.

