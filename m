Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:60740 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932120AbeCKL2D (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 11 Mar 2018 07:28:03 -0400
Date: Sun, 11 Mar 2018 12:27:26 +0100
From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH v5 08/11] wait_bit: introduce {wait_on,wake_up}_atomic_one
Message-ID: <20180311112725.GC4043@hirez.programming.kicks-ass.net>
References: <152066488891.40260.14605734226832760468.stgit@dwillia2-desk3.amr.corp.intel.com>
 <152066493247.40260.10849841915366086021.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <152066493247.40260.10849841915366086021.stgit@dwillia2-desk3.amr.corp.intel.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-nvdimm@lists.01.org, Ingo Molnar <mingo@redhat.com>, Christoph Hellwig <hch@lst.de>, david@fromorbit.com, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, jack@suse.cz, ross.zwisler@linux.intel.com, linux-kernel@vger.kernel.org

On Fri, Mar 09, 2018 at 10:55:32PM -0800, Dan Williams wrote:
> Add a generic facility for awaiting an atomic_t to reach a value of 1.
> 
> Page reference counts typically need to reach 0 to be considered a
> free / inactive page. However, ZONE_DEVICE pages allocated via
> devm_memremap_pages() are never 'onlined', i.e. the put_page() typically
> done at init time to assign pages to the page allocator is skipped.
> 
> These pages will have their reference count elevated > 1 by
> get_user_pages() when they are under DMA. In order to coordinate DMA to
> these pages vs filesytem operations like hole-punch and truncate the
> filesystem-dax implementation needs to capture the DMA-idle event i.e.
> the 2 to 1 count transition).
> 
> For now, this implementation does not have functional behavior change,
> follow-on patches will add waiters for these page-idle events.

Argh, no no no.. That whole wait_for_atomic_t thing is a giant
trainwreck already and now you're making it worse still.

Please have a look here:

  https://lkml.kernel.org/r/20171101190644.chwhfpoz3ywxx2m7@hirez.programming.kicks-ass.net



