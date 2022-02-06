Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 477E7C433EF
	for <linux-xfs@archiver.kernel.org>; Sun,  6 Feb 2022 22:34:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229752AbiBFWeZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 6 Feb 2022 17:34:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229564AbiBFWeY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 6 Feb 2022 17:34:24 -0500
X-Greylist: delayed 955 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sun, 06 Feb 2022 14:34:24 PST
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1DDCFC06173B
        for <linux-xfs@vger.kernel.org>; Sun,  6 Feb 2022 14:34:24 -0800 (PST)
Received: from dread.disaster.area (pa49-180-69-7.pa.nsw.optusnet.com.au [49.180.69.7])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 0EB4E52C302;
        Mon,  7 Feb 2022 09:34:22 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nGq6v-008vst-ES; Mon, 07 Feb 2022 09:34:21 +1100
Date:   Mon, 7 Feb 2022 09:34:21 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Sean Caron <scaron@umich.edu>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] metadump: handle corruption errors without aborting
Message-ID: <20220206223421.GD59729@dread.disaster.area>
References: <CAA43vkVeMb0SrvLmc8MCU7K8yLUBqHOVk3=JGOi+KDh3zs9Wfw@mail.gmail.com>
 <20220201233312.GX59729@dread.disaster.area>
 <CAA43vkV_nDTJjXqtWw-jpc8KVWwa2jQ8-2bNbNJZBcsBSHV8dw@mail.gmail.com>
 <20220202024430.GZ59729@dread.disaster.area>
 <20220202074242.GA59729@dread.disaster.area>
 <CAA43vkXxyHmQdu-GqVukmeOqEh8g-xJDCDD6sx7t4f-MVn+BBA@mail.gmail.com>
 <CAA43vkX6au8gmO97otOT4LQOzspomodGSO__qPMmFozzMsrRQg@mail.gmail.com>
 <CAA43vkUFW3Y_0L7dFc+iAySdf4j3cX4M9Xoz+3eU4raoavmnew@mail.gmail.com>
 <20220202220559.GB59729@dread.disaster.area>
 <CAA43vkXsEydXtf8urxSBKo2WN4arbMDKw3+8mA7YSAJ9ZJwg9w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAA43vkXsEydXtf8urxSBKo2WN4arbMDKw3+8mA7YSAJ9ZJwg9w@mail.gmail.com>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=e9dl9Yl/ c=1 sm=1 tr=0 ts=62004cef
        a=NB+Ng1P8A7U24Uo7qoRq4Q==:117 a=NB+Ng1P8A7U24Uo7qoRq4Q==:17
        a=kj9zAlcOel0A:10 a=oGFeUVbbRNcA:10 a=7-415B0cAAAA:8
        a=Js-4oTtIJLNWQo4jlsYA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Feb 02, 2022 at 06:45:34PM -0500, Sean Caron wrote:
> Sure! Please see gdb backtrace output below.
> 
> (gdb) bt
> #0  __GI_raise (sig=sig@entry=6) at ../sysdeps/unix/sysv/linux/raise.c:51
> #1  0x00007f289d5c7921 in __GI_abort () at abort.c:79
> #2  0x00007f289d610967 in __libc_message (action=action@entry=do_abort,
>     fmt=fmt@entry=0x7f289d73db0d "%s\n") at ../sysdeps/posix/libc_fatal.c:181
> #3  0x00007f289d6179da in malloc_printerr (
>     str=str@entry=0x7f289d73f368 "malloc_consolidate(): invalid chunk
> size") at malloc.c:5342
> #4  0x00007f289d617c7e in malloc_consolidate
> (av=av@entry=0x7f289d972c40 <main_arena>)
>     at malloc.c:4471
> #5  0x00007f289d61b968 in _int_malloc (av=av@entry=0x7f289d972c40 <main_arena>,
>     bytes=bytes@entry=33328) at malloc.c:3713
> #6  0x00007f289d620275 in _int_memalign (bytes=32768, alignment=512,
> av=0x7f289d972c40 <main_arena>)
>     at malloc.c:4683

Ok, so there's nothing wrong with the memalign() parameters being
passed to glibc, so something has previously caused heap corruption
that is only now being tripped over trying to allocate memory for a
new inode cluster buffer.

I wonder if it was the zeroing of the "unused" part of the inode
data fork area that did this (perhaps a corrupt inode fork offset?)
so maybe it is worth turning off the stale data zeroing function
(-a to copy all metadata blocks) so that it doesn't try to interpret
corrupt metadata to determine what is unused areas or not...

If that does get past this inode, then we'll need to make the
stale region zeroing a lot more careful and avoid zeroing in the
case of badly broken metadata.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
