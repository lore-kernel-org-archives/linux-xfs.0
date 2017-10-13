Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-oi0-f48.google.com ([209.85.218.48]:43445 "EHLO
        mail-oi0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752278AbdJMRBF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 13 Oct 2017 13:01:05 -0400
Received: by mail-oi0-f48.google.com with SMTP id c77so15273521oig.0
        for <linux-xfs@vger.kernel.org>; Fri, 13 Oct 2017 10:01:05 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20171013163822.GA17411@obsidianresearch.com>
References: <150776922692.9144.16963640112710410217.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20171012142319.GA11254@lst.de> <CAPcyv4gTON__Ohop0B5R2gsKXC71bycTBozqGmF3WmwG9C6LVA@mail.gmail.com>
 <20171013065716.GB26461@lst.de> <CAPcyv4gaLBBefOU+8f7_ypYnCTjSMk+9nq8NfCqBHAE+NbUusw@mail.gmail.com>
 <20171013163822.GA17411@obsidianresearch.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 13 Oct 2017 10:01:04 -0700
Message-ID: <CAPcyv4jDHp8z2VgVfyRK1WwMzixYVQnh54LZoPD57HB3yqSPPQ@mail.gmail.com>
Subject: Re: [PATCH v9 0/6] MAP_DIRECT for DAX userspace flush
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: Christoph Hellwig <hch@lst.de>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, linux-xfs@vger.kernel.org, Jan Kara <jack@suse.cz>, Arnd Bergmann <arnd@arndb.de>, "Darrick J. Wong" <darrick.wong@oracle.com>, Linux API <linux-api@vger.kernel.org>, Dave Chinner <david@fromorbit.com>, "J. Bruce Fields" <bfields@fieldses.org>, Linux MM <linux-mm@kvack.org>, Jeff Moyer <jmoyer@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, Andy Lutomirski <luto@kernel.org>, Ross Zwisler <ross.zwisler@linux.intel.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Jeff Layton <jlayton@poochiereds.net>, Linus Torvalds <torvalds@linux-foundation.org>, Andrew Morton <akpm@linux-foundation.org>

On Fri, Oct 13, 2017 at 9:38 AM, Jason Gunthorpe
<jgunthorpe@obsidianresearch.com> wrote:
> On Fri, Oct 13, 2017 at 08:14:55AM -0700, Dan Williams wrote:
>
>> scheme specific to RDMA which seems like a waste to me when we can
>> generically signal an event on the fd for any event that effects any
>> of the vma's on the file. The FL_LAYOUT lease impacts the entire file,
>> so as far as I can see delaying the notification until MR-init is too
>> late, too granular, and too RDMA specific.
>
> But for RDMA a FD is not what we care about - we want the MR handle so
> the app knows which MR needs fixing.

I'd rather put the onus on userspace to remember where it used a
MAP_DIRECT mapping and be aware that all the mappings of that file are
subject to a lease break. Sure, we could build up a pile of kernel
infrastructure to notify on a per-MR basis, but I think that would
only be worth it if leases were range based. As it is, the entire file
is covered by a lease instance and all MRs that might reference that
file get one notification. That said, we can always arrange for a
per-driver callback at lease-break time so that it can do something
above and beyond the default notification.
