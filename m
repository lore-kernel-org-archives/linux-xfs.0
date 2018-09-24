Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from a9-112.smtp-out.amazonses.com ([54.240.9.112]:41036 "EHLO
        a9-112.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726218AbeIYADr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Sep 2018 20:03:47 -0400
Date: Mon, 24 Sep 2018 18:00:25 +0000
From: Christopher Lameter <cl@linux.com>
Subject: Re: block: DMA alignment of IO buffer allocated from slab
In-Reply-To: <1f88f59a-2cac-e899-4c2e-402e919b1034@kernel.dk>
Message-ID: <010001660cbd51ea-56e96208-564d-4f5d-a5fb-119a938762a9-000000@email.amazonses.com>
References: <CACVXFVOBq3L_EjSTCoiqUL1PH=HMR5EuNNQV0hNndFpGxmUK6g@mail.gmail.com> <20180920063129.GB12913@lst.de> <87h8ij0zot.fsf@vitty.brq.redhat.com> <20180921130504.GA22551@lst.de> <010001660c54fb65-b9d3a770-6678-40d0-8088-4db20af32280-000000@email.amazonses.com>
 <1f88f59a-2cac-e899-4c2e-402e919b1034@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jens Axboe <axboe@kernel.dk>
Cc: Christoph Hellwig <hch@lst.de>, Vitaly Kuznetsov <vkuznets@redhat.com>, Ming Lei <tom.leiming@gmail.com>, linux-block <linux-block@vger.kernel.org>, linux-mm <linux-mm@kvack.org>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, "open list:XFS FILESYSTEM" <linux-xfs@vger.kernel.org>, Dave Chinner <dchinner@redhat.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Ming Lei <ming.lei@redhat.com>

On Mon, 24 Sep 2018, Jens Axboe wrote:

> The situation is making me a little uncomfortable, though. If we export
> such a setting, we really should be honoring it...

Various subsystems create custom slab arrays with their particular
alignment requirement for these allocations.
