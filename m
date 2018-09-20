Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:57811 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731240AbeITMOR (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 20 Sep 2018 08:14:17 -0400
Date: Thu, 20 Sep 2018 08:32:26 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: block: DMA alignment of IO buffer allocated from slab
Message-ID: <20180920063226.GC12913@lst.de>
References: <CACVXFVOBq3L_EjSTCoiqUL1PH=HMR5EuNNQV0hNndFpGxmUK6g@mail.gmail.com> <877ejh3jv0.fsf@vitty.brq.redhat.com> <20180919100256.GD23172@ming.t460p> <8736u53fij.fsf@vitty.brq.redhat.com> <20180920012836.GA27645@ming.t460p>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180920012836.GA27645@ming.t460p>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Ming Lei <ming.lei@redhat.com>
Cc: Vitaly Kuznetsov <vkuznets@redhat.com>, Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>, David Rientjes <rientjes@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, Andrew Morton <akpm@linux-foundation.org>, Ming Lei <tom.leiming@gmail.com>, linux-block <linux-block@vger.kernel.org>, linux-mm <linux-mm@kvack.org>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, "open list:XFS FILESYSTEM" <linux-xfs@vger.kernel.org>, Dave Chinner <dchinner@redhat.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>

On Thu, Sep 20, 2018 at 09:28:37AM +0800, Ming Lei wrote:
> > has e.g. PAGE_SIZE alignment requirement (this would likely imply that
> > it's sector size is also not 512 I guess)?
> 
> Yeah, that can be true if one controller has 4k-byte sector size, also
> its DMA alignment is 4K. But there shouldn't be cases in which the two
> doesn't match.

The general block storage worlds is that devices always need to have
an alignment requirement <= minimum LBAs size.  If they don't they'll
need to bounce buffer (in the driver!).
