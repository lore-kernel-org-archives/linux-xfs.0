Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:38788 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756235AbeDXLfT (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 24 Apr 2018 07:35:19 -0400
Date: Tue, 24 Apr 2018 07:35:17 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: xfs fstrim and quota
Message-ID: <20180424113517.GC49785@bfoster.bfoster>
References: <c3cbf69c52f0e89631c796016449bbe3@berlin.de>
 <483b7b2c592450221bb5567e64bad84e@berlin.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <483b7b2c592450221bb5567e64bad84e@berlin.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: michael.arndt@berlin.de
Cc: linux-xfs@vger.kernel.org

On Tue, Apr 24, 2018 at 10:28:34AM +0200, michael.arndt@berlin.de wrote:
> Hello *
> 
> Will fstrim operations for a thin provisioning storage and xfs quota
> conflict with each other ?
> 

How so? fstrim should basically inform the underlying device of blocks
in the filesystem that are free. Free blocks in the fs aren't accounted
to any quota by definition, so there shouldn't be a conflict.

> If i understand fstrim code correctly, in case of xfs / thin provisioning
> storage it tells xfs to release unused blocks.
> 

Right... so an underlying thin block device can release blocks that are
unused in the fs.

> I have read indications that blocks are marked to the underlying storage as
> freed by zeroing them out.
> 
> Is the "write zeros" correct information, or will be commands like scsi
> unmap or FITRIM be sent to the storage ?
> 

The fs invokes the block layer discard mechanism. I can't really speak
to how this translates into device commands. My understanding is that a
dm-thin device would/could act on this to release associated blocks to
the pool, otherwise the behavior may depend on the physical
characteristics of the underlying device (i.e., SSD, non-dm thin
devices, etc.), supported commands or whatnot. Perhaps somebody else can
chime in on that or otherwise this might be a better question for the
block layer folks.

Brian

> I found many exact references to fstrim on SSD, but no technical description
> on which operation is implemented for thin provisioning storages.
> 
> TIA
> Micha
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
