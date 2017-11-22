Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:37056 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751260AbdKVTxU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 22 Nov 2017 14:53:20 -0500
Date: Wed, 22 Nov 2017 11:53:18 -0800
From: Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH 01/18] mm: introduce MAP_SHARED_VALIDATE, a mechanism to
 safely define new mmap flags
Message-ID: <20171122195318.GA29485@bombadil.infradead.org>
References: <20171101153648.30166-1-jack@suse.cz>
 <20171101153648.30166-2-jack@suse.cz>
 <638b3b80-5cb9-97c2-5055-fef3a1ec25b9@suse.cz>
 <CAPcyv4gGRHWc6AH5Enb7njtmqHgd=g+0-mYMdd5wWjJMW0+d7g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPcyv4gGRHWc6AH5Enb7njtmqHgd=g+0-mYMdd5wWjJMW0+d7g@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dan Williams <dan.j.williams@intel.com>
Cc: Vlastimil Babka <vbabka@suse.cz>, Jan Kara <jack@suse.cz>, Ross Zwisler <ross.zwisler@linux.intel.com>, Christoph Hellwig <hch@infradead.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Linux MM <linux-mm@kvack.org>, Linux API <linux-api@vger.kernel.org>, linux-ext4 <linux-ext4@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, "Darrick J . Wong" <darrick.wong@oracle.com>, Arnd Bergmann <arnd@arndb.de>, Andy Lutomirski <luto@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@kernel.org>, Kees Cook <keescook@chromium.org>, Florian Weimer <fweimer@redhat.com>, John Hubbard <jhubbard@nvidia.com>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, linux-parisc@vger.kernel.org

On Wed, Nov 22, 2017 at 08:52:37AM -0800, Dan Williams wrote:
> On Wed, Nov 22, 2017 at 4:02 AM, Vlastimil Babka <vbabka@suse.cz> wrote:
> > On 11/01/2017 04:36 PM, Jan Kara wrote:
> >> From: Dan Williams <dan.j.williams@intel.com>
> >>
> >> The mmap(2) syscall suffers from the ABI anti-pattern of not validating
> >> unknown flags. However, proposals like MAP_SYNC need a mechanism to
> >> define new behavior that is known to fail on older kernels without the
> >> support. Define a new MAP_SHARED_VALIDATE flag pattern that is
> >> guaranteed to fail on all legacy mmap implementations.
> >
> > So I'm trying to make sense of this together with Michal's attempt for
> > MAP_FIXED_SAFE [1] where he has to introduce a completely new flag
> > instead of flag modifier exactly for the reason of not validating
> > unknown flags. And my conclusion is that because MAP_SHARED_VALIDATE
> > implies MAP_SHARED and excludes MAP_PRIVATE, MAP_FIXED_SAFE as a
> > modifier cannot build on top of this. Wouldn't thus it be really better
> > long-term to introduce mmap3 at this point? ...
> 
> We have room to define MAP_PRIVATE_VALIDATE in MAP_TYPE on every arch
> except parisc. Can we steal an extra bit for MAP_TYPE from somewhere
> else on parisc?

It looks like 0x08 should work.  But I don't have an HPUX machine around
to check that HP didn't use that bit for something else.

It'd probably help to cc the linux-parisc mailing list when asking
questions about PARISC, eh?
