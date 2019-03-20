Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:42168 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727099AbfCTSx4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 20 Mar 2019 14:53:56 -0400
Date: Wed, 20 Mar 2019 11:53:47 -0700
From: Matthew Wilcox <willy@infradead.org>
Subject: Re: [RFC 0/2] guarantee natural alignment for kmalloc()
Message-ID: <20190320185347.GZ19508@bombadil.infradead.org>
References: <20190319211108.15495-1-vbabka@suse.cz>
 <01000169988d4e34-b4178f68-c390-472b-b62f-a57a4f459a76-000000@email.amazonses.com>
 <5d7fee9c-1a80-6ac9-ac1d-b1ce05ed27a8@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5d7fee9c-1a80-6ac9-ac1d-b1ce05ed27a8@suse.cz>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Christopher Lameter <cl@linux.com>, linux-mm@kvack.org, Pekka Enberg <penberg@kernel.org>, David Rientjes <rientjes@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, Ming Lei <ming.lei@redhat.com>, Dave Chinner <david@fromorbit.com>, "Darrick J . Wong" <darrick.wong@oracle.com>, Christoph Hellwig <hch@lst.de>, Michal Hocko <mhocko@kernel.org>, linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org

On Wed, Mar 20, 2019 at 09:48:47AM +0100, Vlastimil Babka wrote:
> Natural alignment to size is rather well defined, no? Would anyone ever
> assume a larger one, for what reason?
> It's now where some make assumptions (even unknowingly) for natural
> There are two 'odd' sizes 96 and 192, which will keep cacheline size
> alignment, would anyone really expect more than 64 bytes?

Presumably 96 will keep being aligned to 32 bytes, as aligning 96 to 64
just results in 128-byte allocations.
