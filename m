Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17303C433F5
	for <linux-xfs@archiver.kernel.org>; Thu, 26 May 2022 20:56:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234046AbiEZU41 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 26 May 2022 16:56:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238799AbiEZU40 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 26 May 2022 16:56:26 -0400
Received: from mail-qk1-x733.google.com (mail-qk1-x733.google.com [IPv6:2607:f8b0:4864:20::733])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 293C41D0E6
        for <linux-xfs@vger.kernel.org>; Thu, 26 May 2022 13:56:24 -0700 (PDT)
Received: by mail-qk1-x733.google.com with SMTP id j6so2431096qkp.9
        for <linux-xfs@vger.kernel.org>; Thu, 26 May 2022 13:56:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zgBi8UbgQCCe4hIsuqD4Dl5WuawaEJzeAGZrsDKtevg=;
        b=avGSUPZIJU70CfwrgrcwgtAYhQxCB3FndlY3jLRYPN6uk5xydYCxTnwclacf+OAoCw
         iV1nFXBdCsi9DWHz73QBcrsgqta5KZLx7X+cPffC7o7Fp52EDt61hXUCH9a9wKc/jMrl
         sC+iH1J77eH7ByFtVchJHVJVRZyEodLfPM0gNYb2b2/kHVtogQ3PxZqPOI92nVQWxVbn
         uMg4ZHDYqswcYj4Zt3S9MNn5EHewspmg0fzF+7el12PkCVNUQ2rtnSTm9fCalrn+rjOu
         8thCsSv2QVjxvY8B3mggqQwM00nDgt++VT831SkPyu35ApKaYHxfDnsqVy5LJ68EOUPb
         wpCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zgBi8UbgQCCe4hIsuqD4Dl5WuawaEJzeAGZrsDKtevg=;
        b=0L+BbK6/onpXpnHVLdGRba6auWQPvxw7EI38Yy9FhDD727bRxAzdKkBrLVoSDWtkKs
         cUevrmchKsDbD60RNWIN+rN+KzeJxvPwPTw0QBGJIw4bdCkVrbWm9kGkuXY+eutwrvdB
         QhMUkTHFUOCzE/LgZeoYclqE/MXLvLuQe5ubLrhWQ83Jcfs54IxDvooXQJBlonuxvSFv
         i0tsd0lbP1+3dRhMZPQliFEToPYTWBPQOx9ALKuo6p7hOgha60ayrGSd4xxXxIH0bm3N
         17mB8RegmtBs/4kWIp2NO0A9NBeYfwXF1LmqHApP5PXuBqFvSc0Kb8WUlee8kCJtDDqT
         gC3w==
X-Gm-Message-State: AOAM533qYQ4y4qj6oYKD/0eiQ84+yeVsApH+Ps3Lezye6sPrcP25rJ8S
        CDFn1RrED0EA+BOjmH3NgYx06v7ESM8TSCsLErU=
X-Google-Smtp-Source: ABdhPJwixbo6xe2FGqiGFiAfiFyjy2NhaTVVLGriWPjg8IPzqcmZvHdYUFf4dJHt80PiwuniRdDha2hAzhyX/oAVauE=
X-Received: by 2002:a37:8802:0:b0:6a3:4aa4:7cb4 with SMTP id
 k2-20020a378802000000b006a34aa47cb4mr22483445qkd.722.1653598583062; Thu, 26
 May 2022 13:56:23 -0700 (PDT)
MIME-Version: 1.0
References: <20210222153442.897089-1-bfoster@redhat.com> <20210222182745.GA7272@magnolia>
 <20210223123106.GB946926@bfoster> <CAOQ4uxiWajRgGG2V=dYhBmVJYiRmdD+7YgkH2DMWGz6BAOXjvg@mail.gmail.com>
 <Yo+M6Jhjwt/ruOfi@bfoster> <CAOQ4uxjoLm_xwD1GBMNteHsd4zv_4vr+g7xF9_HoCquhq4yoFQ@mail.gmail.com>
 <Yo/ZZtqa5rkuh7VC@bfoster>
In-Reply-To: <Yo/ZZtqa5rkuh7VC@bfoster>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Thu, 26 May 2022 23:56:11 +0300
Message-ID: <CAOQ4uxh0NE4zHUSEqHv8nbpD4RR49Wd_S_DnXhiWCbNqgC0dSQ@mail.gmail.com>
Subject: Re: [PATCH] xfs: don't reuse busy extents on extent trim
To:     Brian Foster <bfoster@redhat.com>
Cc:     "Darrick J. Wong" <djwong@kernel.org>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        "Luis R. Rodriguez" <mcgrof@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

> > I tested it on top of 5.10.109 + these 5 patches:
> > https://github.com/amir73il/linux/commits/xfs-5.10.y-1
> >
> > I can test it in isolation if you like. Let me know if there are
> > other forensics that you would like me to collect.
> >
>
> Hm. Still no luck if I move to .109 and pull in those few patches. I
> assume there's nothing else potentially interesting about the test env
> other than the sparse file scratch dev (i.e., default mkfs options,

Oh! right, this guest is debian/10 with xfsprogs 4.20, so the defaults
are reflink=0.

Actually, the section I am running is reflink_normapbt, but...

** mkfs failed with extra mkfs options added to "-f -m
reflink=1,rmapbt=0, -i sparse=1," by test 076 **
** attempting to mkfs using only test 076 options: -m crc=1 -i sparse **
** mkfs failed with extra mkfs options added to "-f -m
reflink=1,rmapbt=0, -i sparse=1," by test 076 **
** attempting to mkfs using only test 076 options: -d size=50m -m
crc=1 -i sparse **

mkfs.xfs does not accept double sparse argument, so the
test falls back to mkfs defaults (+ sparse)

I checked and xfsprogs 5.3 behaves the same, I did not check newer
xfsprogs, but that seems like a test bug(?)

IWO, unless xfsprogs was changed to be more tolerable to repeating
arguments, then maybe nobody is testing xfs/076 with reflink=0 (?)

> etc.)? If so and you can reliably reproduce, I suppose it couldn't hurt
> to try and grab a tracepoint dump of the test when it fails (feel free
> to send directly or upload somewhere as the list may punt it, and please
> also include the dmesg output that goes along with it) and I can see if
> that shows anything helpful.
>
> I think what we want to know initially is what error code we're
> producing (-ENOSPC?) and where it originates, and from there we can
> probably work out how the transaction might be dirty. I'm not sure a
> trace dump will express that conclusively. If you wanted to increase the
> odds of getting some useful information it might be helpful to stick a
> few trace_printk() calls in the various trans cancel error paths out of
> xfs_create() to determine whether it's the inode allocation attempt that
> fails or the subsequent attempt to create the directory entry..
>

Well, the full output is filled with ENOSPC (also in a good run), so it's
probably that, but I will try to get to that failing stack, no need for all the
noisy traces. Signing off the day. hope I will get to it tomorrow.

Thanks,
Amir.

P.S: this is how 076.full ends if it makes any difference:

touch: cannot touch '/media/scratch/offset.21889024/63': No space left on device
touch: cannot touch '/media/scratch/offset.21823488/63': No space left on device
touch: cannot touch '/media/scratch/offset.21757952/63': No space left on device
touch: cannot touch '/media/scratch/offset.21692416/63': No space left on device
touch: cannot touch '/media/scratch/offset.21626880/63': No space left on device
touch: cannot touch '/media/scratch/offset.21561344/63': No space left on device
touch: cannot touch '/media/scratch/offset.21495808/63': No space left on device
touch: cannot touch '/media/scratch/offset.21430272/63': No space left on device
stat: Input/output error
fpunch failed
