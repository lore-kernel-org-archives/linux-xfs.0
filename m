Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-oi0-f45.google.com ([209.85.218.45]:35439 "EHLO
        mail-oi0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753651AbdBGQ5W (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 7 Feb 2017 11:57:22 -0500
Received: by mail-oi0-f45.google.com with SMTP id j15so68070685oih.2
        for <linux-xfs@vger.kernel.org>; Tue, 07 Feb 2017 08:56:57 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20170207084411.GA527@node.shutemov.name>
References: <148615748258.43180.1690152053774975329.stgit@djiang5-desk3.ch.intel.com>
 <20170206143648.GA461@infradead.org> <CAPcyv4jHYR2-_SgD7a6ab5vWigYsDoSb7FZdTchP8Xg+BF-2yg@mail.gmail.com>
 <20170206172731.GA17515@infradead.org> <CAPcyv4hiwWebCT=qPccKqaQKAHydMYsg9+=pYh=SPkNzakLc1A@mail.gmail.com>
 <20170207084411.GA527@node.shutemov.name>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 7 Feb 2017 08:56:56 -0800
Message-ID: <CAPcyv4h1LvbEqBi=F=BTtLrHHOvAH3MU2OBDs444-dzwNyupFQ@mail.gmail.com>
Subject: Re: [PATCH] mm: replace FAULT_FLAG_SIZE with parameter to huge_fault
Content-Type: text/plain; charset=UTF-8
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Christoph Hellwig <hch@infradead.org>, Matthew Wilcox <mawilcox@microsoft.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Dave Hansen <dave.hansen@linux.intel.com>, linux-xfs@vger.kernel.org, Linux MM <linux-mm@kvack.org>, Vlastimil Babka <vbabka@suse.cz>, Jan Kara <jack@suse.com>, Andrew Morton <akpm@linux-foundation.org>, linux-ext4 <linux-ext4@vger.kernel.org>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>

On Tue, Feb 7, 2017 at 12:44 AM, Kirill A. Shutemov
<kirill@shutemov.name> wrote:
> On Mon, Feb 06, 2017 at 09:30:22AM -0800, Dan Williams wrote:
>> On Mon, Feb 6, 2017 at 9:27 AM, Christoph Hellwig <hch@infradead.org> wrote:
>> > On Mon, Feb 06, 2017 at 08:24:48AM -0800, Dan Williams wrote:
>> >> > Also can be use this opportunity
>> >> > to fold ->huge_fault into ->fault?
>
> BTW, for tmpfs we already use ->fault for both small and huge pages.
> If ->fault returned THP, core mm look if it's possible to map the page as
> huge in this particular VMA (due to size/alignment). If yes mm maps the
> page with PMD, if not fallback to PTE.
>
> I think it would be nice to do the same for DAX: filesystem provides core
> mm with largest page this part of file can be mapped with (base aligned
> address + lenght for DAX) and core mm sort out the rest.

For DAX we would need plumb pfn_t into the core mm so that we have the
PFN_DEV and PFN_MAP flags beyond the raw pfn.

>
>> >> Hmm, yes, just need a scheme to not attempt huge_faults on pte-only handlers.
>> >
>> > Do we need anything more than checking vma->vm_flags for VM_HUGETLB?
>>
>> s/VM_HUGETLB/VM_HUGEPAGE/
>>
>> ...but yes as long as we specify that a VM_HUGEPAGE handler must
>> minimally handle pud and pmd.
>
> VM_HUGEPAGE is result of MADV_HUGEPAGE. It's not required to have THP in
> the VMA.

Filesystem-DAX and Device-DAX specify VM_HUGEPAGE by default.
