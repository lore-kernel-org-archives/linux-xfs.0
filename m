Return-Path: <SRS0=tdPo=W7=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12DC1C3A5A7
	for <linux-xfs@archiver.kernel.org>; Wed,  4 Sep 2019 11:15:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D844121670
	for <linux-xfs@archiver.kernel.org>; Wed,  4 Sep 2019 11:15:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="tAzeLLFE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727787AbfIDLPG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 4 Sep 2019 07:15:06 -0400
Received: from mail-yb1-f194.google.com ([209.85.219.194]:43331 "EHLO
        mail-yb1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727768AbfIDLPG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 4 Sep 2019 07:15:06 -0400
Received: by mail-yb1-f194.google.com with SMTP id o82so7141153ybg.10
        for <linux-xfs@vger.kernel.org>; Wed, 04 Sep 2019 04:15:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=OtzD42/j4BiONMXbM2ny7epraJDu0XgoXsc6I4YMgpg=;
        b=tAzeLLFEgT6ApZppeVu4CmN8y1RlRe4/fppoN/kTm9SGI9Fv2mFhp+C0q5nGU10Zkk
         gAujSQMvY9zk2bDR++bHi1vCxu8XqbijU52knnRrhlvAVDVA+SYGZvbGyIqDhd0j1tuH
         WOHm72ZL5o2lfF/N9dPFglAZe9JijH2RqG732F/KtmJBFFs9IMb7jLsZrv+JT7TShCKq
         agVvW+wrJ4UJMFPsqoWfee3lC3iJnCLOgWeKlJI3Z+ez7UV6r0g+TwJ8mb8ghKU/WLYX
         JMHgxcyxhEgeFaRc97BBrQqQRv9QMiCP76IWzmAEjaYrBO5ylTCjFzM0b0k2MMWsrfBn
         /BNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OtzD42/j4BiONMXbM2ny7epraJDu0XgoXsc6I4YMgpg=;
        b=Rf6QZSer73SvsY5Mr/32HLag5qL5m10dNWJbzVpX3fvFfk/AWTjiZvkiJOSJZBWgKR
         0YXMyVwIZwlpA0VIphGlKiOTLEoS3A5dvpzTbnQ5IOKYgOT0sja6/UF1Fc6hiYH5HmRL
         1+ek07ZlPG/DCLXiUyzJV3UcC/Qga+Xwom7XS8Ia4qil2hV+tqIlVe3OMiIT9G/2ruLC
         ejnNRktjGf4IAihydVABsPPBPfzxG2uXAzkHmh8vxA+T9k28B8KjI+902qJnneTircgx
         ptjAElsjQ+zmhEcG1BrJMVrLDmV0pR3lHDGI1BzTgDWY+yDmeqCawJpz2vPoBzVe1mkL
         hK8A==
X-Gm-Message-State: APjAAAWVLKDWw+BDIXcVZHApoq/Gg+4CVzpdAnQT+xDKnOPtebq4bWGT
        S83opzmX+UbumrHgWwFJpVzQG6NI6TQr1OR5CHVAS7Kw
X-Google-Smtp-Source: APXvYqyAJQsrUkldeH/qlPvIbDLE6DyKpz4vKxAgyDwC4jIbItcDEUc3pPv3y9ntX01qPrgtrjuw8EjirZOaQVr7Q1U=
X-Received: by 2002:a5b:981:: with SMTP id c1mr27167299ybq.14.1567595705186;
 Wed, 04 Sep 2019 04:15:05 -0700 (PDT)
MIME-Version: 1.0
References: <20190519150026.24626-1-zlang@redhat.com> <CAOQ4uxiHZzF5VdC-v3jzorc26RSUdou0v=Vx-XwYT3BAzSwyZA@mail.gmail.com>
 <20190904054715.GX7239@dhcp-12-102.nay.redhat.com>
In-Reply-To: <20190904054715.GX7239@dhcp-12-102.nay.redhat.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Wed, 4 Sep 2019 14:14:54 +0300
Message-ID: <CAOQ4uxjuT-5Y0F9N38TuaD0SCU8e57EAdg2Y+=59Kdqveur4Uw@mail.gmail.com>
Subject: Re: [PATCH v2] xfs_io: support splice data between two files
To:     Zorro Lang <zlang@redhat.com>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Sep 4, 2019 at 8:40 AM Zorro Lang <zlang@redhat.com> wrote:
>
> On Wed, Sep 04, 2019 at 08:20:34AM +0300, Amir Goldstein wrote:
> > On Sun, May 19, 2019 at 8:31 PM Zorro Lang <zlang@redhat.com> wrote:
> > >
> > > Add splice command into xfs_io, by calling splice(2) system call.
> > >
> > > Signed-off-by: Zorro Lang <zlang@redhat.com>
> > > ---
> > >
> > > Hi,
> > >
> > > Thanks the reviewing from Eric.
> > >
> > > If 'length' or 'soffset' or 'length + soffset' out of source file
> > > range, splice hanging there. V2 fix this issue.
> > >
> > > Thanks,
> > > Zorro
> > >
> > >  io/Makefile       |   2 +-
> > >  io/init.c         |   1 +
> > >  io/io.h           |   1 +
> > >  io/splice.c       | 194 ++++++++++++++++++++++++++++++++++++++++++++++
> > >  man/man8/xfs_io.8 |  26 +++++++
> > >  5 files changed, 223 insertions(+), 1 deletion(-)
> > >  create mode 100644 io/splice.c
> > >
> > ...
> > > +static void
> > > +splice_help(void)
> > > +{
> > > +       printf(_(
> > > +"\n"
> > > +" Splice a range of bytes from the given offset between files through pipe\n"
> > > +"\n"
> > > +" Example:\n"
> > > +" 'splice filename 0 4096 32768' - splice 32768 bytes from filename at offset\n"
> > > +"                                  0 into the open file at position 4096\n"
> > > +" 'splice filename' - splice all bytes from filename into the open file at\n"
> > > +" '                   position 0\n"
> > > +"\n"
> > > +" Copies data between one file and another.  Because this copying is done\n"
> > > +" within the kernel, sendfile does not need to transfer data to and from user\n"
> > > +" space.\n"
> > > +" -m -- SPLICE_F_MOVE flag, attempt to move pages instead of copying.\n"
> > > +" Offset and length in the source/destination file can be optionally specified.\n"
> > > +"\n"));
> > > +}
> > > +
> >
> > splice belongs to a family of syscalls that can be used to transfer
> > data between files.
> >
> > xfs_io already has several different sets of arguments for commands
> > from that family, providing different subset of control to user:
> >
> > copy_range [-s src_off] [-d dst_off] [-l len] src_file | -f N -- Copy
> > a range of data between two files
> > dedupe infile src_off dst_off len -- dedupes a number of bytes at a
> > specified offset
> > reflink infile [src_off dst_off len] -- reflinks an entire file, or a
> > number of bytes at a specified offset
> > sendfile -i infile | -f N [off len] -- Transfer data directly between
> > file descriptors
> >
> > I recently added '-f N' option to copy_range that was needed by a test.
> > Since you are adding a new command I must ask if it would not be
> > appropriate to add this capability in the first place.
> > Even if not added now, we should think about how the command options
> > would look like if we do want to add it later.
> > I would really hate to see a forth mutation of argument list...
> >
> > An extreme solution would be to use the super set of all explicit options:
> >
> > splice [-m] <-i infile | -f N> [-s src_off] [-d dst_off] [-l len]
> >
> > We could later add optional support for -s -d -l -i flags to all of the
> > commands above and then we will have a unified format.
>
> I'd like to see an uniform option format too. When I write this patch,
> I don't know which 'format' is *official*, so I have to choose one I prefer
> personally. How to decide which one is better?
>
> Another problem is, if we're going to make all these commands' format
> to unify, it'll cause incompatible issue, for example xfstests has lots
> of cases use xfs_io commands.

I meant not to deprecate old format, but add support for new format.
There is no ambiguity when parsing either of these formats:

reflink infile src_off dst_off len
reflink infile
reflink -i infile -s src_off -d dst_off -l len
reflink infile -l len

If you *want* to write an xfstest that uses new command format,
see 3996a90a common/rc: check support for xfs_io copy_range -f N

Thanks,
Amir.
