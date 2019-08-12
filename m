Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-qk1-f194.google.com ([209.85.222.194]:35798 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728475AbfHLM2Q (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 12 Aug 2019 08:28:16 -0400
Received: by mail-qk1-f194.google.com with SMTP id r21so76795068qke.2
        for <linux-xfs@vger.kernel.org>; Mon, 12 Aug 2019 05:28:15 -0700 (PDT)
Date: Mon, 12 Aug 2019 09:28:14 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [RFC PATCH v2 15/19] mm/gup: Introduce vaddr_pin_pages()
Message-ID: <20190812122814.GC24457@ziepe.ca>
References: <20190809225833.6657-1-ira.weiny@intel.com>
 <20190809225833.6657-16-ira.weiny@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190809225833.6657-16-ira.weiny@intel.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: ira.weiny@intel.com
Cc: Andrew Morton <akpm@linux-foundation.org>, Dan Williams <dan.j.williams@intel.com>, Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>, Theodore Ts'o <tytso@mit.edu>, John Hubbard <jhubbard@nvidia.com>, Michal Hocko <mhocko@suse.com>, Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-nvdimm@lists.01.org, linux-ext4@vger.kernel.org, linux-mm@kvack.org

On Fri, Aug 09, 2019 at 03:58:29PM -0700, ira.weiny@intel.com wrote:
> From: Ira Weiny <ira.weiny@intel.com>
> 
> The addition of FOLL_LONGTERM has taken on additional meaning for CMA
> pages.
> 
> In addition subsystems such as RDMA require new information to be passed
> to the GUP interface to track file owning information.  As such a simple
> FOLL_LONGTERM flag is no longer sufficient for these users to pin pages.
> 
> Introduce a new GUP like call which takes the newly introduced vaddr_pin
> information.  Failure to pass the vaddr_pin object back to a vaddr_put*
> call will result in a failure if pins were created on files during the
> pin operation.

Is this a 'vaddr' in the traditional sense, ie does it work with
something returned by valloc?

Maybe another name would be better?

I also wish GUP like functions took in a 'void __user *' instead of
the unsigned long to make this clear :\

Jason
