Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E96DEECAAA1
	for <linux-xfs@archiver.kernel.org>; Wed, 31 Aug 2022 01:54:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231799AbiHaByT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 30 Aug 2022 21:54:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231620AbiHaByN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 30 Aug 2022 21:54:13 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CFF2B2854;
        Tue, 30 Aug 2022 18:54:08 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id u9-20020a17090a1f0900b001fde6477464so6590233pja.4;
        Tue, 30 Aug 2022 18:54:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=8zMEcOSvN6yaNSQQmvY6Gpxsx8iQRLMImtSa6KDNgVs=;
        b=g+J4rHJIOkxA6KlQOPkvng8bCnxK+Pj8yKi7bfElyIdJGeeTcdeDXW40RQ7skjPoFZ
         vJ3cO54ySjAsbrr+3IiiXwup9+01ZSwfnQZlMvnZ74abwLcqdElUCdlQxdYfWlAZWqBF
         1t7eQgdT8he/R82szEzPFAlu7V/yC4AA1+bHXQcw7trV79KMhTQk+6GiBZYrCwNYPIFh
         JQB172ouafu+OR6XBWWtWCOUWZkfWP/EbAlLQPo0r1j3CSa0t66QPwunDPFQ9e7IpKrI
         JXTgZSPBefb7fcTGV1IY2Fa+2nNpqLnCNnNWS+N9hZ86T6frTT0XsxEwxb8/V3ga4lkc
         vxcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=8zMEcOSvN6yaNSQQmvY6Gpxsx8iQRLMImtSa6KDNgVs=;
        b=ybGb52fth3U0Vo+Q8QhcxlGDcY0CaZnVmEPbMRTucQ/mlw1iUasX6pCEmxKHfiUJGj
         qzG65zeQgjMEyo1/6rviZr7eLK6laSPJpA3+DAlsLOpBJzwfa/j2F0lCFfEsAeYI709A
         2BOD6zKh8EkPAhYG565j3rXk3Fo5oVo8dNlslNwqzZ9x5zLUbcNek7RqhjdHH7kN5erp
         Uyr2MVYJg59tccIlK0bFirZNZ08ri1tOscgKoM5SYWm8/eu4HaO749ERC4Ils8Ws/qw0
         mw5pnEGT1ioI1CLSkeZhYzH0t2dHBMtY71FASoY8h9b1SYIvTPemAeieVJFPclav6oky
         d3hA==
X-Gm-Message-State: ACgBeo2Di1oJCuqV3l1/sBj15PDFo1EsfmBlWvSn7XflsFRjUlOH0aCp
        evq6UftdPjTeaWBPhQO1NRjAIEbmzcBOx5SVdSP7XdYhkcM=
X-Google-Smtp-Source: AA6agR4lhgI0C/EZ6MeuTTLqsDrOPyll8MBG7Ybwmhs2f7MdQulTf3nOwwukHy0QHxDGjjduDj6krYOAYOtrxLICuDk=
X-Received: by 2002:a17:902:8503:b0:173:368b:dce3 with SMTP id
 bj3-20020a170902850300b00173368bdce3mr23848556plb.104.1661910847078; Tue, 30
 Aug 2022 18:54:07 -0700 (PDT)
MIME-Version: 1.0
References: <20220830044433.1719246-1-jencce.kernel@gmail.com>
 <20220830044433.1719246-2-jencce.kernel@gmail.com> <20220830073634.7qklqvl2la53kbv4@zlang-mailbox>
 <Yw4i0Pxz80ez7m0X@magnolia> <20220830190748.nnylphtuugxxmoy3@zlang-mailbox> <CADJHv_tFtH_fihVFGLUB=GyjGJ+Neo-pj8S5DGJDFOHrW12EOA@mail.gmail.com>
In-Reply-To: <CADJHv_tFtH_fihVFGLUB=GyjGJ+Neo-pj8S5DGJDFOHrW12EOA@mail.gmail.com>
From:   Murphy Zhou <jencce.kernel@gmail.com>
Date:   Wed, 31 Aug 2022 09:53:55 +0800
Message-ID: <CADJHv_v1sJSythY2RDA6tYBtuY7O_0zgKLxXhAPw7zpvMunXvA@mail.gmail.com>
Subject: Re: [PATCH v3 1/4] tests: increase fs size for mkfs
To:     Zorro Lang <zlang@redhat.com>
Cc:     "Darrick J. Wong" <djwong@kernel.org>,
        fstests <fstests@vger.kernel.org>,
        linux-xfs <linux-xfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Oops.. Darrick left a workaround in the xfsprogs code for fstests. My
test setup missed TEST_DEV export somehow and the workaround was not
working.

Nevermind for this patchset..  My bloody hours...

On Wed, Aug 31, 2022 at 8:18 AM Murphy Zhou <jencce.kernel@gmail.com> wrote:
>
> On Wed, Aug 31, 2022 at 3:07 AM Zorro Lang <zlang@redhat.com> wrote:
> >
> > On Tue, Aug 30, 2022 at 07:46:40AM -0700, Darrick J. Wong wrote:
> > > On Tue, Aug 30, 2022 at 03:36:34PM +0800, Zorro Lang wrote:
> > > > On Tue, Aug 30, 2022 at 12:44:30PM +0800, Murphy Zhou wrote:
> > > > > Since this xfsprogs commit:
> > > > >   6e0ed3d19c54 mkfs: stop allowing tiny filesystems
> > > > > XFS requires filesystem size bigger then 300m.
> > > >
> > > > I'm wondering if we can just use 300M, or 512M is better. CC linux-xfs to
> > > > get more discussion about how to deal with this change on mkfs.xfs.
> > > >
> > > > >
> > > > > Increase thoese numbers to 512M at least. There is no special
> > > > > reason for the magic number 512, just double it from original
> > > > > 256M and being reasonable small.
> > > >
> > > > Hmm... do we need a global parameter to define the minimal XFS size,
> > > > or even minimal local fs size? e.g. MIN_XFS_SIZE, or MIN_FS_SIZE ...
> > >
> > > I think it would be a convenient time to create a helper to capture
> > > that, seeing as the LTP developers recently let slip that they have such
> > > a thing somewhere, and min fs size logic is scattered around fstests.
> >
> > It's a little hard to find out all cases which use the minimal fs size.
> > But for xfs, I think we can do that with this chance. We can have:
> >
> >   export XFS_MIN_SIZE=$((300 * 1024 * 1024))
> >   export XFS_MIN_LOG_SIZE=$((64 * 1024 * 1024))
> >
> > at first, then init minimal $FSTYP size likes:
> >
> >   init_min_fs_size()
> >   {
> >       case $FSTYP in
> >       xfs)
> >           FS_MIN_SIZE=$XFS_MIN_SIZE
> >           ;;
> >       *)
> >           FS_MIN_SIZE="unlimited"  # or a big enough size??
> >           ;;
> >       esac
> >   }
> >
> > Then other fs can follow this to add their size limitation.
> > Any better ideas?
>
> In generic/042 f2fs has a similar kind of limitation.
>
> Let me check how LTP guys handle this.
>
> Thanks,
> Murphy
>
> >
> > Thanks,
> > Zorro
> >
> > >
> >
> snipped
> >
