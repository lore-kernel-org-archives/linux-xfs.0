Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:39532 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726833AbeLCQ4W (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 3 Dec 2018 11:56:22 -0500
Date: Mon, 3 Dec 2018 11:56:15 -0500
From: Sasha Levin <sashal@kernel.org>
Subject: Re: XFS patches for stable
Message-ID: <20181203165615.GL235790@sasha-vm>
References: <20181129224019.GM19305@dastard>
 <20181130082203.GA26830@kroah.com>
 <20181130101441.GA213156@sasha-vm>
 <20181130215005.GP19305@dastard>
 <20181201074909.GC213156@sasha-vm>
 <CAOQ4uxhCH3oxVWDMVRcXMZO3JSTCA1Pp5AYnHP5pDxyNktqONw@mail.gmail.com>
 <20181202152547.GI221015@sasha-vm>
 <20181202161016.GA27696@infradead.org>
 <20181202200819.GA3932@kroah.com>
 <CAFLxGvyx-n4fUbsv+PrAebAPRe=yGV1zLRA44XnOwtMaubS8cg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CAFLxGvyx-n4fUbsv+PrAebAPRe=yGV1zLRA44XnOwtMaubS8cg@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Richard Weinberger <richard.weinberger@gmail.com>
Cc: Greg KH <gregkh@linuxfoundation.org>, Christoph Hellwig <hch@infradead.org>, amir73il@gmail.com, Dave Chinner <david@fromorbit.com>, stable <stable@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, dchinner@redhat.com, darrick.wong@oracle.com, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-xfs@vger.kernel.org, mcgrof@kernel.org, linux-mtd@lists.infradead.org, boris.brezillon@bootlin.com

On Mon, Dec 03, 2018 at 03:41:27PM +0100, Richard Weinberger wrote:
>On Sun, Dec 2, 2018 at 9:09 PM Greg KH <gregkh@linuxfoundation.org> wrote:
>>
>> On Sun, Dec 02, 2018 at 08:10:16AM -0800, Christoph Hellwig wrote:
>> > As someone who has done xfs stable backports for a while I really don't
>> > think the autoselection is helpful at all.
>>
>> autoselection for xfs patches has been turned off for a while, what
>> triggered this email thread was a core vfs patch that was backported
>> that was not obvious it was created by the xfs developers due to a
>> problem they had found.
>
>Sorry for hijacking this thread.
>Can you please also disable autoselection for MTD, UBI and UBIFS?
>
>fs/ubifs/
>drivers/mtd/
>include/linux/mtd/
>include/uapi/mtd/

Sure, done!

--
Thanks,
Sasha
