Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:59494 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753690AbdHXQzx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 24 Aug 2017 12:55:53 -0400
Date: Thu, 24 Aug 2017 09:55:46 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v6 3/5] mm: introduce mmap3 for safely defining new mmap
 flags
Message-ID: <20170824165546.GA3121@infradead.org>
References: <150353211413.5039.5228914877418362329.stgit@dwillia2-desk3.amr.corp.intel.com>
 <150353213097.5039.6729469069608762658.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <150353213097.5039.6729469069608762658.stgit@dwillia2-desk3.amr.corp.intel.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dan Williams <dan.j.williams@intel.com>
Cc: akpm@linux-foundation.org, Jan Kara <jack@suse.cz>, Arnd Bergmann <arnd@arndb.de>, linux-nvdimm@lists.01.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, linux-mm@kvack.org, luto@kernel.org, linux-fsdevel@vger.kernel.org

On Wed, Aug 23, 2017 at 04:48:51PM -0700, Dan Williams wrote:
> The mmap(2) syscall suffers from the ABI anti-pattern of not validating
> unknown flags. However, proposals like MAP_SYNC and MAP_DIRECT need a
> mechanism to define new behavior that is known to fail on older kernels
> without the support. Define a new mmap3 syscall that checks for
> unsupported flags at syscall entry and add a 'mmap_supported_mask' to
> 'struct file_operations' so generic code can validate the ->mmap()
> handler knows about the specified flags. This also arranges for the
> flags to be passed to the handler so it can do further local validation
> if the requested behavior can be fulfilled.

What is the reason to not go with __MAP_VALID hack?  Adding new
syscalls is extremely painful, it will take forever to trickle this
through all architectures (especially with the various 32-bit
architectures having all kinds of different granularities for the
offset) and then the various C libraries, never mind applications.
