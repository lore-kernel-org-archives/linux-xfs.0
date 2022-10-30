Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ABECDECAAA1
	for <linux-xfs@archiver.kernel.org>; Sun, 30 Oct 2022 16:45:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229695AbiJ3QpN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 30 Oct 2022 12:45:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229494AbiJ3QpN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 30 Oct 2022 12:45:13 -0400
Received: from mail-io1-xd35.google.com (mail-io1-xd35.google.com [IPv6:2607:f8b0:4864:20::d35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74F621A9
        for <linux-xfs@vger.kernel.org>; Sun, 30 Oct 2022 09:45:12 -0700 (PDT)
Received: by mail-io1-xd35.google.com with SMTP id y6so5213574iof.9
        for <linux-xfs@vger.kernel.org>; Sun, 30 Oct 2022 09:45:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=XlWj+7OPxazKwQOnaTkktpd6K4xuw2QvZW50J/xbE24=;
        b=A1KpOAc2u/XgrFM7lyBa0qeSn2/8lrV/9Cn8Aw///xCB+/ROIPFWnDPDMu/Yn6DhxE
         THAP82ZJi0mT1S6ByEydHNSqge/EZcbrmR1Fw1E0FBWjQ+1z6r/URhzi7QD0Sb8WF0GB
         B3HLVXDnF7jpixBf+bQet95N6lAfRvv2ufQiaa1fIJA/YktU+L+Gyhi+TYoQsj7bJmIT
         IryUc5njY/O0yI2tHYzNzSxTOeU9xY0CvF66+f4I0nRxyg8kUwoHcISC/UlPvRqbf2vI
         I1co0dg5wbdWqPNTRGRrTGZmlFTWKOLOq5hVvz4lom1gwBBbW+s7VZKpCvCLqGU+v5tA
         A5ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XlWj+7OPxazKwQOnaTkktpd6K4xuw2QvZW50J/xbE24=;
        b=5an/MBZDtxUTDT5HwAceWiy9gJalVNamryf64CAnpZlCRX3t1e2T/U40e1uizMS8M3
         0Dg0iyWqEIYGMfzwXjaYPV5JMy+7cvecHG4MYoZpcZ67rRIeRXOC1M30g+M/aE/RsT0t
         q268S/FaTYaiQnxYcdZw6n4tTOZSx0tClGALMbClJtcVbqHoA66GMuUJCrbPBCkPLqkc
         h9rpGglcLszTCTnMPp/+yO1q0nhhGMSYVLd4PFihKDmvxiPS+B0KGYm+P9Nn1XyAoFPR
         ciumbh/YPoU08aI4cm8E7pfugESQ6dnH+y2xWsF/ER2/+rZCoIpK5E3a5AJ0pC2fAm1i
         YTQQ==
X-Gm-Message-State: ACrzQf1HJEgZUAAD3hv/42N07lCrIFE4hoVWePVwiJQE6tXT83rFeMRV
        nqz97fzho1qUgeSH/qyT13xncI7zt5WDzisFwmsq0Oct
X-Google-Smtp-Source: AMsMyM7glsiia0vRRzeOSgULx2PI7Az3NJp02h2CKqVXo1z117bti+LV8CIvQBkr/9fRtIcwhMULgOJKC+8QLPN0R7Q=
X-Received: by 2002:a05:6602:2b09:b0:67f:c159:91b9 with SMTP id
 p9-20020a0566022b0900b0067fc15991b9mr4593495iov.182.1667148311845; Sun, 30
 Oct 2022 09:45:11 -0700 (PDT)
MIME-Version: 1.0
References: <CAB-bdyRWCJLDde4izM_H-Bh9wPg-Enas+D4VvTROWEpVy0ZgZg@mail.gmail.com>
 <CAB-bdyTJjM7ju-ku6w1Tib06r70FbZ8r0y8mfBaKu4XQDuMeUw@mail.gmail.com> <20221029210117.GE3600936@dread.disaster.area>
In-Reply-To: <20221029210117.GE3600936@dread.disaster.area>
From:   Shawn <neutronsharc@gmail.com>
Date:   Sun, 30 Oct 2022 09:44:35 -0700
Message-ID: <CAB-bdyTLOrb265pDXJFbkwB=6FqVi8uyWnQzSozWGVKdLs=h7A@mail.gmail.com>
Subject: Re: Fwd: does xfs support aio_fsync?
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Yes I upgraded to kernel 4.18 and async fsync works as expected.
Thank you Darrick, and Dave for your quick response!


Shawn

On Sat, Oct 29, 2022 at 2:01 PM Dave Chinner <david@fromorbit.com> wrote:
>
> On Fri, Oct 28, 2022 at 03:11:15PM -0700, Neutron Sharc wrote:
> > Hello all,
> > I have a workload that benefits the most if I can issue async fsync
> > after many async writes are completed. I was under the impression that
> > xfs/ext4 both support async fsync so I can use libaio to submit fsync.
> > When I tested with io_submit(fsync),  it always returned EINVAL.  So I
> > browsed the linux source (both kernel 3.10,  4.14)  and I found
> > xfs/xfs_file.c doesn't implement "aio_fsync", nor does ext4/file.c.
>
> Generic support for IOCB_CMD_FSYNC and IOCB_CMD_FDSYNC was added
> into 4.17. As a result it should be supported by almost all
> filesystems, not just XFS....
>
> > I found an old post which said aio_fsync was already included in xfs
> > (https://www.spinics.net/lists/xfs/msg28408.html)
>
> Yeah, the code that went into fs/aio.c was pretty much a generic
> version of this.
>
> > What xfs or kernel version should I use to get aio_fsync working?  Thanks all.
>
> Just a kernel that isn't ancient. If you are looking for features,
> always check latest code first, then go back and find when it was
> merged (git log, git blame, etc). That's all I did....
>
> -Dave.
> --
> Dave Chinner
> david@fromorbit.com
