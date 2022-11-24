Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85BE5C4332F
	for <linux-xfs@archiver.kernel.org>; Thu, 24 Nov 2022 08:08:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229554AbiKXIIj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 24 Nov 2022 03:08:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229711AbiKXIIi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 24 Nov 2022 03:08:38 -0500
Received: from mail-yb1-xb31.google.com (mail-yb1-xb31.google.com [IPv6:2607:f8b0:4864:20::b31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 245E59A5D5
        for <linux-xfs@vger.kernel.org>; Thu, 24 Nov 2022 00:08:37 -0800 (PST)
Received: by mail-yb1-xb31.google.com with SMTP id e76so1007538yba.5
        for <linux-xfs@vger.kernel.org>; Thu, 24 Nov 2022 00:08:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=1H8eACwsPHCorcFfJu+1RNheIDT08lbVO89iT+IwrnE=;
        b=hcvgfywrs5CNQciRKRok+L2IOwPt9pTi98wn0IlvOxeiwBYuar9JGTQ2hv4dCeko7M
         ZBp13zhDouAH4H5ECU0rGau8v+fdckbM7MJ9GpMrCJImdG9wrE3G3Rn/B2lXzeZj4Aqa
         i9Ocixhl+jm3HmWdBvG29olLeMYvewUdacS45whUJ0/oeDIcjU7ZRgkx/XHIIc7oCjcr
         UwrhwSKungivUzxn29AlDs3wEtz5pe4aSHNPOqX/xAdFHlVHvOqkUU3+KgWzlPcw3cjD
         3bprMUoOubz2SOrxrtB8biAA5z2xwfZ0bl4gqJR2HqGhPAGYHNBH6I5qy2mawLlHTHjh
         A0GA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1H8eACwsPHCorcFfJu+1RNheIDT08lbVO89iT+IwrnE=;
        b=AuXdVtXxnHunMMJ0QTKJ0rEHMzSxLyHWgUM+VidXD/qon1SPPRzuXTGiGSMuyMtCac
         4g94Y9d/Yhw/uzdgOQDWazmnVobIsup7FI+Xoyz3QglN9s2TGRej3JV/BW4nH4sSBvXn
         KFs5xmbx6BjH13GLOSyLI1fu8aJ9329eKJ0k/RrzZWn9DZjRL5m8bLmYPSrw5f73zvUJ
         pvvQB/bErKNGaWJ/SRM6uNVew+qMwyk2Trl+4U1qxm0sZri9Y2QxARDW2A/77r9Id+wF
         gcR3YVfbTKu7mAc3k51x51qRDmWMvjomfhI59nCTj/V5qUV3FibHQz55Gep9rcKrXBPN
         rvSg==
X-Gm-Message-State: ANoB5pmuTFrdT9MAXBPCviKKJ52vgs2yhTGzYu4R9mporSt2J7Ijd7KA
        5ZrAtNT1K9D5mWYlUDCXIORt34wSgh/gnyo935LVOg==
X-Google-Smtp-Source: AA0mqf6Hbdl6bOW3lnt8Z2632YBw3AlpSzi59Dc46vuxtwqXTS9h2hH8z8cCGrtUctrK50at+cr6iD8ez62zNLmX+ss=
X-Received: by 2002:a5b:b43:0:b0:6de:1554:867b with SMTP id
 b3-20020a5b0b43000000b006de1554867bmr11396138ybr.16.1669277316282; Thu, 24
 Nov 2022 00:08:36 -0800 (PST)
MIME-Version: 1.0
References: <00000000000063536805ee0769d8@google.com> <20221122043504.GR3600936@dread.disaster.area>
In-Reply-To: <20221122043504.GR3600936@dread.disaster.area>
From:   Marco Elver <elver@google.com>
Date:   Thu, 24 Nov 2022 09:07:59 +0100
Message-ID: <CANpmjNNH0woaJEzviEj5sfzeOyFXCcE4U-UwUcgjL97aU7LVxg@mail.gmail.com>
Subject: Re: [syzbot] kernel BUG in assfail
To:     Dave Chinner <david@fromorbit.com>
Cc:     syzbot <syzbot+1d8c82e66f2e76b6b427@syzkaller.appspotmail.com>,
        djwong@kernel.org, linux-kernel@vger.kernel.org,
        linux-xfs@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

#syz invalid

On Tue, 22 Nov 2022 at 05:35, Dave Chinner <david@fromorbit.com> wrote:
...
> Turn off CONFIG_XFS_DEBUG, and this failure will return
> -EFSCORRUPTED as expected because syzbot fed it a corrupt log. THe
> mount will simply fail as you'd expect given the malicious
> corruption that syzbot has performed.
>
> If syzbot is going to maliciously corrupt XFS filesytsems and then
> try to abuse them, then syzbot has two choices. Either:
>
> 1. do not enable CONFIG_XFS_DEBUG; or

We've disabled CONFIG_XFS_DEBUG - reports like this should no longer be sent.

Thanks,
-- Marco
