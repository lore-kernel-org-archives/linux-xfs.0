Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:39816 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751487AbdCPNqf (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 16 Mar 2017 09:46:35 -0400
Subject: Re: [PATCH 3/8] nowait aio: return if direct write will trigger
 writeback
References: <20170315215107.5628-1-rgoldwyn@suse.de>
 <20170315215107.5628-4-rgoldwyn@suse.de>
 <20170316130824.GF4033@bombadil.infradead.org>
From: Goldwyn Rodrigues <rgoldwyn@suse.de>
Message-ID: <963ce6bd-730a-76e5-4d7e-d63552c94ff9@suse.de>
Date: Thu, 16 Mar 2017 08:46:27 -0500
MIME-Version: 1.0
In-Reply-To: <20170316130824.GF4033@bombadil.infradead.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Matthew Wilcox <willy@infradead.org>
Cc: linux-fsdevel@vger.kernel.org, jack@suse.com, hch@infradead.org, linux-block@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, sagi@grimberg.me, avi@scylladb.com, axboe@kernel.dk, linux-api@vger.kernel.org, Goldwyn Rodrigues <rgoldwyn@suse.com>



On 03/16/2017 08:08 AM, Matthew Wilcox wrote:
> On Wed, Mar 15, 2017 at 04:51:02PM -0500, Goldwyn Rodrigues wrote:
>> This introduces a new function filemap_range_has_page() which
>> returns true if the file's mapping has a page within the range
>> mentioned.
> 
> I thought you were going to replace this patch with one that starts
> writeback for these pages but does not wait for them?
> 

As mentioned by Jan, Flags to filemap_write_and_wait_range are
unnecessarily complicated. The AIO-DIO API users who eye for performance
usually are careful with page writes/evictions. As a fallback, they can
(and should) go the wait route (without  IOCB_RW_FLAG_NOWAIT).

Finally, my take on this is that we don't want to perform tasks for a
following system call, which may or may not immediately follow the
current one. May not, because an application (DB) will offload the task
from the CPU thread to the I/O thread in case of -EAGAIN. A system call
should be complete in itself (and do the minimum, what is asked).


-- 
Goldwyn
