Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-ot0-f177.google.com ([74.125.82.177]:33677 "EHLO
        mail-ot0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752553AbdBFQYz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 6 Feb 2017 11:24:55 -0500
Received: by mail-ot0-f177.google.com with SMTP id 73so65727618otj.0
        for <linux-xfs@vger.kernel.org>; Mon, 06 Feb 2017 08:24:55 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20170206143648.GA461@infradead.org>
References: <148615748258.43180.1690152053774975329.stgit@djiang5-desk3.ch.intel.com>
 <20170206143648.GA461@infradead.org>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 6 Feb 2017 08:24:48 -0800
Message-ID: <CAPcyv4jHYR2-_SgD7a6ab5vWigYsDoSb7FZdTchP8Xg+BF-2yg@mail.gmail.com>
Subject: Re: [PATCH] mm: replace FAULT_FLAG_SIZE with parameter to huge_fault
Content-Type: text/plain; charset=UTF-8
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: Dave Jiang <dave.jiang@intel.com>, Matthew Wilcox <mawilcox@microsoft.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Dave Hansen <dave.hansen@linux.intel.com>, linux-xfs@vger.kernel.org, Linux MM <linux-mm@kvack.org>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, Jan Kara <jack@suse.com>, Andrew Morton <akpm@linux-foundation.org>, linux-ext4 <linux-ext4@vger.kernel.org>, Vlastimil Babka <vbabka@suse.cz>

On Mon, Feb 6, 2017 at 6:36 AM, Christoph Hellwig <hch@infradead.org> wrote:
> On Fri, Feb 03, 2017 at 02:31:22PM -0700, Dave Jiang wrote:
>> Since the introduction of FAULT_FLAG_SIZE to the vm_fault flag, it has
>> been somewhat painful with getting the flags set and removed at the
>> correct locations. More than one kernel oops was introduced due to
>> difficulties of getting the placement correctly. Removing the flag
>> values and introducing an input parameter to huge_fault that indicates
>> the size of the page entry. This makes the code easier to trace and
>> should avoid the issues we see with the fault flags where removal of the
>> flag was necessary in the fallback paths.
>
> Why is this not in struct vm_fault?

Because this is easier to read and harder to get wrong. Same arguments
as getting rid of struct blk_dax_ctl.

> Also can be use this opportunity
> to fold ->huge_fault into ->fault?

Hmm, yes, just need a scheme to not attempt huge_faults on pte-only handlers.
