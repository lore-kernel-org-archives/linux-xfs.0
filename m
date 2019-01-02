Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:55934 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725879AbfABVZd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 2 Jan 2019 16:25:33 -0500
Date: Wed, 2 Jan 2019 13:25:31 -0800
From: Matthew Wilcox <willy@infradead.org>
Subject: Re: [BUG, TOT] xfs w/ dax failure in __follow_pte_pmd()
Message-ID: <20190102212531.GK6310@bombadil.infradead.org>
References: <20190102211332.GL4205@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190102211332.GL4205@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org, linux-mm@kvack.org, Dan Williams <dan.j.williams@intel.com>, =?iso-8859-1?B?Suly9G1l?= Glisse <jglisse@redhat.com>, Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>, Jan Kara <jack@suse.cz>, akpm@linux-foundation.org

On Thu, Jan 03, 2019 at 08:13:32AM +1100, Dave Chinner wrote:
> Hi folks,
> 
> An overnight test run on a current TOT kernel failed generic/413
> with the following dmesg output:
> 
> [ 9487.276402] RIP: 0010:__follow_pte_pmd+0x22d/0x340
> [ 9487.305065] Call Trace:
> [ 9487.307310]  dax_entry_mkclean+0xbb/0x1f0

We've only got one commit touching dax_entry_mkclean and it's Jerome's.
Looking through ac46d4f3c43241ffa23d5bf36153a0830c0e02cc, I'd say
it's missing a call to mmu_notifier_range_init().
