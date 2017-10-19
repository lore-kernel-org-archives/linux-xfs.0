Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from quartz.orcorp.ca ([184.70.90.242]:50118 "EHLO quartz.orcorp.ca"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751468AbdJSGD1 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 19 Oct 2017 02:03:27 -0400
Date: Thu, 19 Oct 2017 00:02:49 -0600
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Subject: Re: [PATCH v9 0/6] MAP_DIRECT for DAX userspace flush
Message-ID: <20171019060249.GA6555@obsidianresearch.com>
References: <20171012142319.GA11254@lst.de>
 <CAPcyv4gTON__Ohop0B5R2gsKXC71bycTBozqGmF3WmwG9C6LVA@mail.gmail.com>
 <20171013065716.GB26461@lst.de>
 <CAPcyv4gaLBBefOU+8f7_ypYnCTjSMk+9nq8NfCqBHAE+NbUusw@mail.gmail.com>
 <20171013163822.GA17411@obsidianresearch.com>
 <CAPcyv4jDHp8z2VgVfyRK1WwMzixYVQnh54LZoPD57HB3yqSPPQ@mail.gmail.com>
 <20171013173145.GA18702@obsidianresearch.com>
 <CAPcyv4jZJRto1jwmNU--pqH_6dOVMyj=68ZwEjAmmkgX=mRk7w@mail.gmail.com>
 <20171014015752.GA25172@obsidianresearch.com>
 <e29eb9ed-2d87-cde8-4efa-50de1fff0c04@grimberg.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e29eb9ed-2d87-cde8-4efa-50de1fff0c04@grimberg.me>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Sagi Grimberg <sagi@grimberg.me>
Cc: Dan Williams <dan.j.williams@intel.com>, "J. Bruce Fields" <bfields@fieldses.org>, Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, Arnd Bergmann <arnd@arndb.de>, "Darrick J. Wong" <darrick.wong@oracle.com>, Linux API <linux-api@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org, Linux MM <linux-mm@kvack.org>, Al Viro <viro@zeniv.linux.org.uk>, Andy Lutomirski <luto@kernel.org>, Jeff Layton <jlayton@poochiereds.net>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>, Christoph Hellwig <hch@lst.de>

On Mon, Oct 16, 2017 at 03:02:52PM +0300, Sagi Grimberg wrote:
> But why should the kernel ever need to mangle the CQ? if a lease break
> would deregister the MR the device is expected to generate remote
> protection errors on its own.

The point is to avoid protection errors - hittles change over when the
DAX mapping changes like ODP does.

Theonly way to get there is to notify the app before the mappings
change.. Dan suggested having ibv_pollcq return this indication..

Jason
