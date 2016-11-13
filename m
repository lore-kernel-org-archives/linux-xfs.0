Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:38047 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752708AbcKMA1C (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 12 Nov 2016 19:27:02 -0500
Date: Sat, 12 Nov 2016 16:26:34 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: EFI SLAB use after free in generic/388 run
Message-ID: <20161113002634.GI16813@birch.djwong.org>
References: <20161112174049.GB27521@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161112174049.GB27521@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org

On Sat, Nov 12, 2016 at 09:40:49AM -0800, Christoph Hellwig wrote:
> Just saw this during a xfstests auto run on virtio with default
> XFS parameters.  I don't think I saw this before when running the
> same config, so it might not be 100% reproducible.  I'd be surpised
> if my laptop has bad ram, but who knows..

Does your kernel have commit b77428b12b5 ("xfs: defer should abort
intent items if the trans roll fails") in it?  I saw similar symptoms
and fixed them with that patch.

(Patch should appear in -rc5 tomorrow.)

--D

> 
> [ 2412.538076] XFS (vdc): Mounting V5 Filesystem
> [ 2412.783150] XFS (vdc): Starting recovery (logdev: internal)
> [ 2412.998385] XFS (vdc): Ending recovery (logdev: internal)
> [ 2413.014579] Slab corruption (Tainted: G        W      ): xfs_efi_item start=ffff88008636ac18, len=408
> [ 2413.015789] Redzone: 0x9f911029d74e35b/0x9f911029d74e35b
> [ 2413.017236] Last user:
> [<ffffffff815c6689>](xfs_efi_item_free+0x29/0x40)
> [ 2413.018854] 070: 6b 6b 6b 6b 6b 6b 6b 6b 6a 6b 6b 6b 6b 6b 6b 6b kkkkkkkkjkkkkkkk
> [ 2413.019815] Single bit error detected. Probably bad RAM.
> [ 2413.020350] Run memtest86+ or a similar memory test tool.
> [ 2413.020915] Prev obj: start=ffff88008636aa68, len=408
> [ 2413.021645] Redzone: 0x9f911029d74e35b/0x9f911029d74e35b
> [ 2413.022191] Last user: [<ffffffff815c6689>](xfs_efi_item_free+0x29/0x40)
> [ 2413.023397] 000: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
> [ 2413.024217] 010: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
> [ 2413.026503] Next obj: start=ffff88008636adc8, len=408
> [ 2413.027304] Redzone: 0x9f911029d74e35b/0x9f911029d74e35b
> [ 2413.027941] Last user: [<ffffffff815c6689>](xfs_efi_item_free+0x29/0x40)
> [ 2413.028695] 000: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
> [ 2413.029616] 010: [ 2413.029810] 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
