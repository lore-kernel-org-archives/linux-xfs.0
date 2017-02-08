Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54323 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752899AbdBHI4C (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 8 Feb 2017 03:56:02 -0500
Date: Wed, 8 Feb 2017 09:41:56 +0100
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] mm: replace FAULT_FLAG_SIZE with parameter to huge_fault
Message-ID: <20170208084156.GD26317@quack2.suse.cz>
References: <148615748258.43180.1690152053774975329.stgit@djiang5-desk3.ch.intel.com>
 <20170206143648.GA461@infradead.org>
 <CAPcyv4jHYR2-_SgD7a6ab5vWigYsDoSb7FZdTchP8Xg+BF-2yg@mail.gmail.com>
 <20170206172731.GA17515@infradead.org>
 <CAPcyv4hiwWebCT=qPccKqaQKAHydMYsg9+=pYh=SPkNzakLc1A@mail.gmail.com>
 <20170207084411.GA527@node.shutemov.name>
 <CAPcyv4h1LvbEqBi=F=BTtLrHHOvAH3MU2OBDs444-dzwNyupFQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPcyv4h1LvbEqBi=F=BTtLrHHOvAH3MU2OBDs444-dzwNyupFQ@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dan Williams <dan.j.williams@intel.com>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>, Christoph Hellwig <hch@infradead.org>, Matthew Wilcox <mawilcox@microsoft.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Dave Hansen <dave.hansen@linux.intel.com>, linux-xfs@vger.kernel.org, Linux MM <linux-mm@kvack.org>, Vlastimil Babka <vbabka@suse.cz>, Jan Kara <jack@suse.com>, Andrew Morton <akpm@linux-foundation.org>, linux-ext4 <linux-ext4@vger.kernel.org>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>

On Tue 07-02-17 08:56:56, Dan Williams wrote:
> On Tue, Feb 7, 2017 at 12:44 AM, Kirill A. Shutemov
> <kirill@shutemov.name> wrote:
> > On Mon, Feb 06, 2017 at 09:30:22AM -0800, Dan Williams wrote:
> >> On Mon, Feb 6, 2017 at 9:27 AM, Christoph Hellwig <hch@infradead.org> wrote:
> >> > On Mon, Feb 06, 2017 at 08:24:48AM -0800, Dan Williams wrote:
> >> >> > Also can be use this opportunity
> >> >> > to fold ->huge_fault into ->fault?
> >
> > BTW, for tmpfs we already use ->fault for both small and huge pages.
> > If ->fault returned THP, core mm look if it's possible to map the page as
> > huge in this particular VMA (due to size/alignment). If yes mm maps the
> > page with PMD, if not fallback to PTE.
> >
> > I think it would be nice to do the same for DAX: filesystem provides core
> > mm with largest page this part of file can be mapped with (base aligned
> > address + lenght for DAX) and core mm sort out the rest.
> 
> For DAX we would need plumb pfn_t into the core mm so that we have the
> PFN_DEV and PFN_MAP flags beyond the raw pfn.

So we can pass necessary information through struct vm_fault rather easily.
However due to DAX locking we cannot really "return" pfn for generic code
to install (we need to unlock radix tree locks after modifying page
tables). So if we want generic code to handle PFNs what needs to be done is
to teach finish_fault() to handle pfn_t which is passed to it and install
it in page tables.

Long term we could transition all page fault handlers (at least the
non-trivial ones) to using finish_fault() which would IMO make the code
flow easier to follow and export less of MM internals into drivers. However
there's so many fault handlers that I didn't have a good motivation to do
that yet.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
