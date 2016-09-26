Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:34980 "EHLO
        mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756269AbcIZJbX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 26 Sep 2016 05:31:23 -0400
Received: by mail-pf0-f195.google.com with SMTP id 6so8885535pfl.2
        for <linux-xfs@vger.kernel.org>; Mon, 26 Sep 2016 02:31:23 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20160923190806.GG2356@ZenIV.linux.org.uk>
References: <20160909023452.GO2356@ZenIV.linux.org.uk> <CA+55aFwHQMjO4-vtfB9-ytc=o+DRo-HXVGckvXLboUxgpwb7_g@mail.gmail.com>
 <20160909221945.GQ2356@ZenIV.linux.org.uk> <CA+55aFzTOOB6oEVaaGD0N7Uznk-W9+ULPwzsxS_L_oZqGVSeLA@mail.gmail.com>
 <20160914031648.GB2356@ZenIV.linux.org.uk> <CA+55aFznQaOWoSMNphgGJJWZ=8-odrc0DAUMzfGPQe+_N4UgNA@mail.gmail.com>
 <20160914042559.GC2356@ZenIV.linux.org.uk> <20160917082007.GA6489@ZenIV.linux.org.uk>
 <20160917190023.GA8039@ZenIV.linux.org.uk> <20160923190032.GA25771@ZenIV.linux.org.uk>
 <20160923190806.GG2356@ZenIV.linux.org.uk>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 26 Sep 2016 11:31:19 +0200
Message-ID: <CAELBmZDinbMbDQ3pCuMA=DNc0D76nCrLgvqcvQbAxnM5+yGUJg@mail.gmail.com>
Subject: Re: [PATCH 09/11] fuse_ioctl_copy_user(): don't open-code copy_page_{to,from}_iter()
Content-Type: text/plain; charset=UTF-8
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Dave Chinner <david@fromorbit.com>, CAI Qian <caiqian@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>, xfs@oss.sgi.com, Jens Axboe <axboe@kernel.dk>, Nick Piggin <npiggin@gmail.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>

On Fri, Sep 23, 2016 at 9:08 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
> ---
> [another cleanup, will be moved out of that branch]

Picked up and pushed to fuse.git #for-next

Thanks,
Miklos
