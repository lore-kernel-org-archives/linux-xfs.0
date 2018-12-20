Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:60068 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729578AbeLTU5Y (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 20 Dec 2018 15:57:24 -0500
Date: Fri, 21 Dec 2018 07:57:21 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] iomap: Revert "fs/iomap.c: get/put the page in
 iomap_page_create/release()"
Message-ID: <20181220205721.GD4205@dastard>
References: <20181220122324.17082-1-david@fromorbit.com>
 <20181220122825.GA17138@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181220122825.GA17138@kroah.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Greg KH <gregkh@linuxfoundation.org>
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, pjaroszynski@nvidia.com, william.kucharski@oracle.com, stable@vger.kernel.org, hch@lst.de, akpm@linux-foundation.org, torvalds@linux-foundation.org

On Thu, Dec 20, 2018 at 01:28:25PM +0100, Greg KH wrote:
> On Thu, Dec 20, 2018 at 11:23:24PM +1100, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > This reverts commit 61c6de667263184125d5ca75e894fcad632b0dd3.

<snip>

> <formletter>
> 
> This is not the correct way to submit patches for inclusion in the
> stable kernel tree.  Please read:
>     https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
> for how to do this properly.
> 
> </formletter>

This wasn't a stable kernel patch submission. This was to let the
stable kernel maintainers know that a commit that was submitted for
stable kernel inclusion (via a cc stable in the commit message) is
buggy and should not be backported. i.e. if you've already queued/
backported 61c6de6672 then you need to drop it from your trees.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
