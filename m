Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from a9-31.smtp-out.amazonses.com ([54.240.9.31]:37470 "EHLO
        a9-31.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726333AbfBZPU1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 26 Feb 2019 10:20:27 -0500
Date: Tue, 26 Feb 2019 15:20:26 +0000
From: Christopher Lameter <cl@linux.com>
Subject: Re: [PATCH] xfs: allocate sector sized IO buffer via
 page_frag_alloc
In-Reply-To: <5ad2ef83-8b3a-0a15-d72e-72652b807aad@suse.cz>
Message-ID: <010001692a648c57-4215863f-7d66-4086-90ba-2c0832117e3c-000000@email.amazonses.com>
References: <20190225040904.5557-1-ming.lei@redhat.com> <20190225043648.GE23020@dastard> <5ad2ef83-8b3a-0a15-d72e-72652b807aad@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Dave Chinner <david@fromorbit.com>, Ming Lei <ming.lei@redhat.com>, "Darrick J . Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, Vitaly Kuznetsov <vkuznets@redhat.com>, Dave Chinner <dchinner@redhat.com>, Christoph Hellwig <hch@lst.de>, Alexander Duyck <alexander.h.duyck@linux.intel.com>, Aaron Lu <aaron.lu@intel.com>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, linux-mm@kvack.org, linux-block@vger.kernel.org

On Mon, 25 Feb 2019, Vlastimil Babka wrote:

> What about kmem_cache_create() with align parameter? That *should* be
> guaranteed regardless of whatever debugging is enabled - if not, I would
> consider it a bug.

It definitely guarantees that. What would be the point of the alignment
parameter otherwise?
