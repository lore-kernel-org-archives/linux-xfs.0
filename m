Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:57797 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731851AbeITMNT (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 20 Sep 2018 08:13:19 -0400
Date: Thu, 20 Sep 2018 08:31:29 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: block: DMA alignment of IO buffer allocated from slab
Message-ID: <20180920063129.GB12913@lst.de>
References: <CACVXFVOBq3L_EjSTCoiqUL1PH=HMR5EuNNQV0hNndFpGxmUK6g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACVXFVOBq3L_EjSTCoiqUL1PH=HMR5EuNNQV0hNndFpGxmUK6g@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Ming Lei <tom.leiming@gmail.com>
Cc: linux-block <linux-block@vger.kernel.org>, linux-mm <linux-mm@kvack.org>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, "open list:XFS FILESYSTEM" <linux-xfs@vger.kernel.org>, Dave Chinner <dchinner@redhat.com>, Vitaly Kuznetsov <vkuznets@redhat.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, Ming Lei <ming.lei@redhat.com>

On Wed, Sep 19, 2018 at 05:15:43PM +0800, Ming Lei wrote:
> 1) does kmalloc-N slab guarantee to return N-byte aligned buffer?  If
> yes, is it a stable rule?

This is the assumption in a lot of the kernel, so I think if somethings
breaks this we are in a lot of pain.
