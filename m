Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:33697 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751250AbdHEJrK (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sat, 5 Aug 2017 05:47:10 -0400
Date: Sat, 5 Aug 2017 11:47:08 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v2 1/5] fs, xfs: introduce S_IOMAP_IMMUTABLE
Message-ID: <20170805094708.GB14930@lst.de>
References: <150181368442.32119.13336247800141074356.stgit@dwillia2-desk3.amr.corp.intel.com> <150181369070.32119.1019092252036976783.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <150181369070.32119.1019092252036976783.stgit@dwillia2-desk3.amr.corp.intel.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dan Williams <dan.j.williams@intel.com>
Cc: darrick.wong@oracle.com, Jan Kara <jack@suse.cz>, linux-nvdimm@lists.01.org, Dave Chinner <david@fromorbit.com>, linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, Jeff Moyer <jmoyer@redhat.com>, Alexander Viro <viro@zeniv.linux.org.uk>, luto@kernel.org, linux-fsdevel@vger.kernel.org, Ross Zwisler <ross.zwisler@linux.intel.com>, Christoph Hellwig <hch@lst.de>

NAK^4.

We should not allow users to create immutable files.  We have
proper ways to synchronize I/O, and this is just an invitation
for horrible abuses that should not be allowed, and which we've
always people told not to do.
