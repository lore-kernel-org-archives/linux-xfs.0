Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79966C05027
	for <linux-xfs@archiver.kernel.org>; Wed,  8 Feb 2023 19:03:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231447AbjBHTDw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 8 Feb 2023 14:03:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231520AbjBHTDv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 8 Feb 2023 14:03:51 -0500
Received: from mail-vs1-xe35.google.com (mail-vs1-xe35.google.com [IPv6:2607:f8b0:4864:20::e35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4143F58281
        for <linux-xfs@vger.kernel.org>; Wed,  8 Feb 2023 11:03:16 -0800 (PST)
Received: by mail-vs1-xe35.google.com with SMTP id l8so3183668vsi.12
        for <linux-xfs@vger.kernel.org>; Wed, 08 Feb 2023 11:03:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=jqH3xjdeQYKVsFoL0KfPb0aszj0oKE5i0CjwM3o8lDw=;
        b=VLA0rvWZydnEi6nPNXYTo5FCt66HqM79pfH3kC9jiJGncaJbZmWNZYK9R4l/0Egaq8
         rBPTzoEcKCZs6tDwQiuuuyZys3Pk8ZpXSkdwp3pYB9GoYFNwc78q6nalf9W4kbBz498r
         7p/n/UTE6hDfoo6mDpunG4FtHUtTkzxV0bUujlXspyhiaeqYXeIbmtUQRwMsRJ/aMwKM
         f9bfsvuhXSE1u+B98POWMUFJTMeetsUBtlFbOGDPUClbdU0wB64Wng/HTnK6/u3YCBqp
         mCnrX7BecKJfNWIXOuLIo3lmIfCWgwlYMueU6EMHAqcizHLBaR8+aMRFeEIdCDYAA/kO
         d4tA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jqH3xjdeQYKVsFoL0KfPb0aszj0oKE5i0CjwM3o8lDw=;
        b=kHBEAv8mXGGGSVMnLjaZ0e9+7cruO1ErRV1yyEvH0neZ1fnQXdXBCex9Wo0enDBuyj
         1zBPD+iO9pvEPVl10lTbZdutc2UPDFnA7ntbOqC79ZMrv1OEx3s6vGHtpQZig/JZX5pE
         4fipxHk+4PcIOYpWLEo6u9XmqN1n/dQQPq6w1NAzlplz2KCEF0db31GaT+ld44UiKYjK
         D5aNZZMacA1TkR1byJVjpM0EMG13qapFLY+n4cItBPalRIvrtKY7mum50VDMYXcURKVb
         uoY7QrT4Pi6oRjhOWilDF/y1IGK5fBHq5MIf+rgfBMsHAH0qOakeRwGU1eSJDLDqouCR
         o+2Q==
X-Gm-Message-State: AO0yUKVoK3Dnine/VU9VZfGF0592eiUwQeqaqUd2DaPoUkaZVxwRPzf/
        VZG14avlGE3wegRWbjAyA3LFUga+hKZdAZTrHdU=
X-Google-Smtp-Source: AK7set/pEZ1EBeRUG7zrFLvviUKNj8C9tsGau52EaQqJPdldPvZdjR9LK+iNHkzp0LgjlbA/2mKQOzN+sPSIewFzSCs=
X-Received: by 2002:a05:6102:390:b0:411:a54a:de01 with SMTP id
 m16-20020a056102039000b00411a54ade01mr1665335vsq.2.1675882989619; Wed, 08 Feb
 2023 11:03:09 -0800 (PST)
MIME-Version: 1.0
References: <20230208175228.2226263-1-leah.rumancik@gmail.com>
In-Reply-To: <20230208175228.2226263-1-leah.rumancik@gmail.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Wed, 8 Feb 2023 21:02:58 +0200
Message-ID: <CAOQ4uxgmHzWcxBDrzRb19ByCnNoayhha_MZ_eYN0YMC=RGTeMw@mail.gmail.com>
Subject: Re: [PATCH 5.15 CANDIDATE 00/10] more xfs fixes for 5.15
To:     Leah Rumancik <leah.rumancik@gmail.com>
Cc:     linux-xfs@vger.kernel.org, chandan.babu@oracle.com,
        Christian Brauner <brauner@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Feb 8, 2023 at 7:52 PM Leah Rumancik <leah.rumancik@gmail.com> wrote:
>
> Hello again,
>
> Here is the next batch of backports for 5.15.y. Testing included
> 25 runs of auto group on 12 xfs configs. No regressions were seen.
> I checked xfs/538 was run without issue as this test was mentioned
> in 56486f307100. Also, from 86d40f1e49e9, I ran ran xfs/117 with
> XFS compiled as a module and TEST_FS_MODULE_REOLOAD set, but I was
> unable to reproduce the issue.

Did you find any tests that started to pass or whose failure rate reduced?

There are very few Fixes: annotations in these commits so it is hard for
me to assess if any of them are relevant/important/worth the effort/risk
to backport to 5.10.

Unless I know of reproducible bugs in 5.10, I don't think I will invest
in backporting this series to 5.10.
Chandan, if you find any of these fixes relevant and important for 5.4
let me know and I will make the effort to consider them for 5.10.

Leah, please consider working on the SGID bug fixes for the next 5.15
update, because my 5.10 SGID fixes series [1] has been blocked for
months and because there are several reproducible test cases in xfstest.

I did not push on that until now because SGID test expectations were
a moving target, but since xfstests commit 81e6f628 ("generic: update
setgid tests") in this week's xfstests release, I think that tests should be
stable and we can finally start backporting all relevant SGID fixes to
align the SGID behavior of LTS kernels with that of upstream.

Thanks,
Amir.

[1] https://github.com/amir73il/linux/commits/xfs-5.10.y-sgid-fixes

>
> Below I've outlined which series the backports came from:
>
> series "xfs: intent whiteouts" (1):
> [01/10] cb512c921639613ce03f87e62c5e93ed9fe8c84d
>     xfs: zero inode fork buffer at allocation
> [02/10] c230a4a85bcdbfc1a7415deec6caf04e8fca1301
>     xfs: fix potential log item leak
>
> series "xfs: fix random format verification issues" (2):
> [1/4] dc04db2aa7c9307e740d6d0e173085301c173b1a
>     xfs: detect self referencing btree sibling pointers
> [2/4] 1eb70f54c445fcbb25817841e774adb3d912f3e8 -> already in 5.15.y
>     xfs: validate inode fork size against fork format
> [3/4] dd0d2f9755191690541b09e6385d0f8cd8bc9d8f
>     xfs: set XFS_FEAT_NLINK correctly
> [4/4] f0f5f658065a5af09126ec892e4c383540a1c77f
>     xfs: validate v5 feature fields
>
> series "xfs: small fixes for 5.19 cycle" (3):
> [1/3] 5672225e8f2a872a22b0cecedba7a6644af1fb84
>     xfs: avoid unnecessary runtime sibling pointer endian conversions
> [2/3] 5b55cbc2d72632e874e50d2e36bce608e55aaaea
>     fs: don't assert fail on perag references on teardown
> [2/3] 56486f307100e8fc66efa2ebd8a71941fa10bf6f
>     xfs: assert in xfs_btree_del_cursor should take into account error
>
> series "xfs: random fixes for 5.19" (4):
> [1/2] 86d40f1e49e9a909d25c35ba01bea80dbcd758cb
>     xfs: purge dquots after inode walk fails during quotacheck
> [2/2] a54f78def73d847cb060b18c4e4a3d1d26c9ca6d
>     xfs: don't leak btree cursor when insrec fails after a split
>
> (1) https://lore.kernel.org/all/20220503221728.185449-1-david@fromorbit.com/
> (2) https://lore.kernel.org/all/20220502082018.1076561-1-david@fromorbit.com/
> (3) https://lore.kernel.org/all/20220524022158.1849458-1-david@fromorbit.com/
> (4) https://lore.kernel.org/all/165337056527.993079.1232300816023906959.stgit@magnolia/
>
> Darrick J. Wong (2):
>   xfs: purge dquots after inode walk fails during quotacheck
>   xfs: don't leak btree cursor when insrec fails after a split
>
> Dave Chinner (8):
>   xfs: zero inode fork buffer at allocation
>   xfs: fix potential log item leak
>   xfs: detect self referencing btree sibling pointers
>   xfs: set XFS_FEAT_NLINK correctly
>   xfs: validate v5 feature fields
>   xfs: avoid unnecessary runtime sibling pointer endian conversions
>   xfs: don't assert fail on perag references on teardown
>   xfs: assert in xfs_btree_del_cursor should take into account error
>
>  fs/xfs/libxfs/xfs_ag.c         |   3 +-
>  fs/xfs/libxfs/xfs_btree.c      | 175 +++++++++++++++++++++++++--------
>  fs/xfs/libxfs/xfs_inode_fork.c |  12 ++-
>  fs/xfs/libxfs/xfs_sb.c         |  70 +++++++++++--
>  fs/xfs/xfs_bmap_item.c         |   2 +
>  fs/xfs/xfs_icreate_item.c      |   1 +
>  fs/xfs/xfs_qm.c                |   9 +-
>  fs/xfs/xfs_refcount_item.c     |   2 +
>  fs/xfs/xfs_rmap_item.c         |   2 +
>  9 files changed, 221 insertions(+), 55 deletions(-)
>
> --
> 2.39.1.519.gcb327c4b5f-goog
>
