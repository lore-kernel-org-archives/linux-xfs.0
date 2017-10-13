Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from quartz.orcorp.ca ([184.70.90.242]:43152 "EHLO quartz.orcorp.ca"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750722AbdJMQiw (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 13 Oct 2017 12:38:52 -0400
Date: Fri, 13 Oct 2017 10:38:22 -0600
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Subject: Re: [PATCH v9 0/6] MAP_DIRECT for DAX userspace flush
Message-ID: <20171013163822.GA17411@obsidianresearch.com>
References: <150776922692.9144.16963640112710410217.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20171012142319.GA11254@lst.de>
 <CAPcyv4gTON__Ohop0B5R2gsKXC71bycTBozqGmF3WmwG9C6LVA@mail.gmail.com>
 <20171013065716.GB26461@lst.de>
 <CAPcyv4gaLBBefOU+8f7_ypYnCTjSMk+9nq8NfCqBHAE+NbUusw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPcyv4gaLBBefOU+8f7_ypYnCTjSMk+9nq8NfCqBHAE+NbUusw@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dan Williams <dan.j.williams@intel.com>
Cc: Christoph Hellwig <hch@lst.de>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, linux-xfs@vger.kernel.org, Jan Kara <jack@suse.cz>, Arnd Bergmann <arnd@arndb.de>, "Darrick J. Wong" <darrick.wong@oracle.com>, Linux API <linux-api@vger.kernel.org>, Dave Chinner <david@fromorbit.com>, "J. Bruce Fields" <bfields@fieldses.org>, Linux MM <linux-mm@kvack.org>, Jeff Moyer <jmoyer@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, Andy Lutomirski <luto@kernel.org>, Ross Zwisler <ross.zwisler@linux.intel.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Jeff Layton <jlayton@poochiereds.net>, Linus Torvalds <torvalds@linux-foundation.org>, Andrew Morton <akpm@linux-foundation.org>

On Fri, Oct 13, 2017 at 08:14:55AM -0700, Dan Williams wrote:

> scheme specific to RDMA which seems like a waste to me when we can
> generically signal an event on the fd for any event that effects any
> of the vma's on the file. The FL_LAYOUT lease impacts the entire file,
> so as far as I can see delaying the notification until MR-init is too
> late, too granular, and too RDMA specific.

But for RDMA a FD is not what we care about - we want the MR handle so
the app knows which MR needs fixing.

Jason
