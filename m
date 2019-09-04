Return-Path: <SRS0=tdPo=W7=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58E5EC3A59E
	for <linux-xfs@archiver.kernel.org>; Wed,  4 Sep 2019 05:20:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2B5F823401
	for <linux-xfs@archiver.kernel.org>; Wed,  4 Sep 2019 05:20:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AKp06vJz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726004AbfIDFUq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 4 Sep 2019 01:20:46 -0400
Received: from mail-yb1-f195.google.com ([209.85.219.195]:37061 "EHLO
        mail-yb1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725966AbfIDFUq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 4 Sep 2019 01:20:46 -0400
Received: by mail-yb1-f195.google.com with SMTP id t5so6886380ybt.4
        for <linux-xfs@vger.kernel.org>; Tue, 03 Sep 2019 22:20:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zVbBc/pZKgGURRUmRFigbYzr+ebWS+a1dUDlOJbydbg=;
        b=AKp06vJzpPeaI5bAlr1r2PyJhTp3NtAFkEhl4qq64Mbk1ArQV7ep4U6pXXTCB7HEsL
         QeqgbPqjDwGbMBrZyCPGMEUQpqAtKeYrdBFdKp1VZsCf/KVtLjh244cx0o/4OomK0Cbz
         k19PAdt8t7lAguwbSemMnwOJ/XaEKgXrc/N64m4fq4XAAJXiIVfSYvbdqpvnNlOY5Ila
         PQZQ5iGdSnV1a9AETSYf3CTL6Hyc9kFEaFg2CL6ppmmcsp3Cq2vQfDltYOC6U2l52Pzq
         sDeAURGbjeYiZ6uOVvZy1UyAL2JbI6SVkuOOOAnW7/DZ388qjQNosDli2OZC4j4pTMeP
         OwnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zVbBc/pZKgGURRUmRFigbYzr+ebWS+a1dUDlOJbydbg=;
        b=f9Yf0ouzoFydGaFvCgU5+BmUxANfSRy+vbw3jcXJWPQr1OrKeaYgzpoVaKNf7idolA
         4gVdS2Y//dzBKK2dkYvDzEyUXKCViMQxOV1lvYkvpaijNPoNx4sAWfBGDETpxU6YwDgs
         YEDDsqZs6VaDL98gCAMlzkRsT4zoRWKEFBMXXhqtlUxIDfhrTzLJw5EsOfxnwKO4sviC
         v80wj/WbbWlKqkbtlDF5++/LevW6l9zcObWVBMhWElseB6Xzzx0UZlF6+2NxB/eZbpgp
         shZLXYAqIx58h5D35Namvp8lurbqmzkV3bZZBmlRGbHvJ1pDrZ2iAFcugPRQh1cmvHPN
         Ln3Q==
X-Gm-Message-State: APjAAAVHVjP5DpoaE4H2D2pypz8XKpZJE/Men6GYhZfUFRMJ03qsdE3E
        PkKw7GCEW29NwmZurODdq+5o1oFG8bnCa9OKMNo=
X-Google-Smtp-Source: APXvYqxjZ+POtnihVv9d8QsL8xdA+NVknOgyAB+eqWhDdfv8L/Vgoeb3d1y+QfhTMtyWbKoY+WEmtU/RPS72zXeiaEQ=
X-Received: by 2002:a25:7005:: with SMTP id l5mr17486169ybc.428.1567574445592;
 Tue, 03 Sep 2019 22:20:45 -0700 (PDT)
MIME-Version: 1.0
References: <20190519150026.24626-1-zlang@redhat.com>
In-Reply-To: <20190519150026.24626-1-zlang@redhat.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Wed, 4 Sep 2019 08:20:34 +0300
Message-ID: <CAOQ4uxiHZzF5VdC-v3jzorc26RSUdou0v=Vx-XwYT3BAzSwyZA@mail.gmail.com>
Subject: Re: [PATCH v2] xfs_io: support splice data between two files
To:     Zorro Lang <zlang@redhat.com>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, May 19, 2019 at 8:31 PM Zorro Lang <zlang@redhat.com> wrote:
>
> Add splice command into xfs_io, by calling splice(2) system call.
>
> Signed-off-by: Zorro Lang <zlang@redhat.com>
> ---
>
> Hi,
>
> Thanks the reviewing from Eric.
>
> If 'length' or 'soffset' or 'length + soffset' out of source file
> range, splice hanging there. V2 fix this issue.
>
> Thanks,
> Zorro
>
>  io/Makefile       |   2 +-
>  io/init.c         |   1 +
>  io/io.h           |   1 +
>  io/splice.c       | 194 ++++++++++++++++++++++++++++++++++++++++++++++
>  man/man8/xfs_io.8 |  26 +++++++
>  5 files changed, 223 insertions(+), 1 deletion(-)
>  create mode 100644 io/splice.c
>
...
> +static void
> +splice_help(void)
> +{
> +       printf(_(
> +"\n"
> +" Splice a range of bytes from the given offset between files through pipe\n"
> +"\n"
> +" Example:\n"
> +" 'splice filename 0 4096 32768' - splice 32768 bytes from filename at offset\n"
> +"                                  0 into the open file at position 4096\n"
> +" 'splice filename' - splice all bytes from filename into the open file at\n"
> +" '                   position 0\n"
> +"\n"
> +" Copies data between one file and another.  Because this copying is done\n"
> +" within the kernel, sendfile does not need to transfer data to and from user\n"
> +" space.\n"
> +" -m -- SPLICE_F_MOVE flag, attempt to move pages instead of copying.\n"
> +" Offset and length in the source/destination file can be optionally specified.\n"
> +"\n"));
> +}
> +

splice belongs to a family of syscalls that can be used to transfer
data between files.

xfs_io already has several different sets of arguments for commands
from that family, providing different subset of control to user:

copy_range [-s src_off] [-d dst_off] [-l len] src_file | -f N -- Copy
a range of data between two files
dedupe infile src_off dst_off len -- dedupes a number of bytes at a
specified offset
reflink infile [src_off dst_off len] -- reflinks an entire file, or a
number of bytes at a specified offset
sendfile -i infile | -f N [off len] -- Transfer data directly between
file descriptors

I recently added '-f N' option to copy_range that was needed by a test.
Since you are adding a new command I must ask if it would not be
appropriate to add this capability in the first place.
Even if not added now, we should think about how the command options
would look like if we do want to add it later.
I would really hate to see a forth mutation of argument list...

An extreme solution would be to use the super set of all explicit options:

splice [-m] <-i infile | -f N> [-s src_off] [-d dst_off] [-l len]

We could later add optional support for -s -d -l -i flags to all of the
commands above and then we will have a unified format.

Personally, I have no objection that splice could also use the
"simple" arguments list as you implemented it, since reflink is
going to have to continue to support this usage anyway.

Thanks,
Amir.
