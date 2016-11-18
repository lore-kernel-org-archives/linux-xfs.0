Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:56524 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752301AbcKRNU1 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 18 Nov 2016 08:20:27 -0500
Date: Fri, 18 Nov 2016 08:20:25 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 07/14] xfs: use new extent lookup helpers
 xfs_file_iomap_begin_delay
Message-ID: <20161118132025.GB60705@bfoster.bfoster>
References: <1479143565-30615-1-git-send-email-hch@lst.de>
 <1479143565-30615-8-git-send-email-hch@lst.de>
 <20161117183330.GI49658@bfoster.bfoster>
 <20161118082047.GC28286@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161118082047.GC28286@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

On Fri, Nov 18, 2016 at 09:20:47AM +0100, Christoph Hellwig wrote:
> On Thu, Nov 17, 2016 at 01:33:30PM -0500, Brian Foster wrote:
> > My cow prealloc series is going to end up adding this right back, fwiw.
> > Though at that point it's not really "prev" as used throughout the
> > extent manipulation code, but rather just an extent on which to base the
> > initial prealloc size.
> 
> Oh, well.  I could keep the argument for now, but doing the lookups
> in the caller just for the prev value that's not even always used
> seems a little silly.

It's probably not worth it. This looks like a good clean up to me as it
is... I just wanted to call that out since I was using/changing 'prev'.
Looking again, the cow prealloc stuff is still going to use the data
extent record. I may be able to convert 'prev' to 'base' within
*_prealloc_size() just the same without changing the function signature
back.

Brian

> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
