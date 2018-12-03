Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wm1-f51.google.com ([209.85.128.51]:38406 "EHLO
        mail-wm1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725918AbeLCOm5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 3 Dec 2018 09:42:57 -0500
MIME-Version: 1.0
References: <20181129121458.GK19305@dastard> <20181129124756.GA25945@kroah.com>
 <20181129224019.GM19305@dastard> <20181130082203.GA26830@kroah.com>
 <20181130101441.GA213156@sasha-vm> <20181130215005.GP19305@dastard>
 <20181201074909.GC213156@sasha-vm> <CAOQ4uxhCH3oxVWDMVRcXMZO3JSTCA1Pp5AYnHP5pDxyNktqONw@mail.gmail.com>
 <20181202152547.GI221015@sasha-vm> <20181202161016.GA27696@infradead.org> <20181202200819.GA3932@kroah.com>
In-Reply-To: <20181202200819.GA3932@kroah.com>
From: Richard Weinberger <richard.weinberger@gmail.com>
Date: Mon, 3 Dec 2018 15:41:27 +0100
Message-ID: <CAFLxGvyx-n4fUbsv+PrAebAPRe=yGV1zLRA44XnOwtMaubS8cg@mail.gmail.com>
Subject: Re: XFS patches for stable
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Christoph Hellwig <hch@infradead.org>, sashal@kernel.org, amir73il@gmail.com, Dave Chinner <david@fromorbit.com>, stable <stable@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, dchinner@redhat.com, darrick.wong@oracle.com, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-xfs@vger.kernel.org, mcgrof@kernel.org, linux-mtd@lists.infradead.org, boris.brezillon@bootlin.com

On Sun, Dec 2, 2018 at 9:09 PM Greg KH <gregkh@linuxfoundation.org> wrote:
>
> On Sun, Dec 02, 2018 at 08:10:16AM -0800, Christoph Hellwig wrote:
> > As someone who has done xfs stable backports for a while I really don't
> > think the autoselection is helpful at all.
>
> autoselection for xfs patches has been turned off for a while, what
> triggered this email thread was a core vfs patch that was backported
> that was not obvious it was created by the xfs developers due to a
> problem they had found.

Sorry for hijacking this thread.
Can you please also disable autoselection for MTD, UBI and UBIFS?

fs/ubifs/
drivers/mtd/
include/linux/mtd/
include/uapi/mtd/

-- 
Thanks,
//richard
