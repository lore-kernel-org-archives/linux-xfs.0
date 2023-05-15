Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E48CC77B75
	for <linux-xfs@archiver.kernel.org>; Mon, 15 May 2023 09:06:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238839AbjEOJG0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 15 May 2023 05:06:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239131AbjEOJFe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 15 May 2023 05:05:34 -0400
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBB8F199D
        for <linux-xfs@vger.kernel.org>; Mon, 15 May 2023 02:05:23 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id 5b1f17b1804b1-3f423c17bafso343205e9.0
        for <linux-xfs@vger.kernel.org>; Mon, 15 May 2023 02:05:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1684141522; x=1686733522;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tgQznShlcEU/owRXS5pB/bMBA0shOHO8fmj2OZ6DolA=;
        b=G1EFKyQhvfOB1DU+z3A4aXg+42N7In3liWiZG/Jh9/5e9ZxgZPtgVhnS4LmfVsL3fW
         3R6OLEaDm5y3mAW/Hc6e7Iau+vS5YtVdWZnAiBrIRNozqWeebVkcb9Bpj2PcmPicTuS5
         TxOQO70y9WcMN0GQuuG2e6mq72dFlxVQQXORUiLvwI4t2Hkfsxl4E3+nD8J9EP1Zvnpn
         KMY+sGDUQD7q5dIM9OSAzU6/Sbxg4JdSbHNPckBtJXbJEryjMe0sUBRGwJW+oKeYfFIr
         lnL67gCkCwkfoOxHT8cIPJvO3szgUVGkdUHW6xe9iVUlG3kfFwgagmE49KY2CND+yuX7
         yRhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684141522; x=1686733522;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tgQznShlcEU/owRXS5pB/bMBA0shOHO8fmj2OZ6DolA=;
        b=AnONIiFiMq69+ywq5GghHXBrhYJfZrw4VsFKBistQPRtB2jhwxtwce2G18/hEadNKn
         AlrW/wxgQEIbsMgHml06YCE783m6Xmccvh6W+hR8Nuk1PVMtNMvwdDHie6eVilUliKHU
         QweDAx0cjjJ+Xce2VUaWU7SJ4r2uELHOmN3MNXAL5umKY1Rt+2ISb9xnMnowwUnvFg6D
         7D8Qr9sVJRpHKG2IUZOzZtheQFdi6bmQkD77aNYIs6WpZ4muILviZSOVkrF8ZewN8By5
         +4aafXf5U1sjEs24AG02YyQfkXN1BQziyKosEtHGztu6GRp22VmtXTirnxowkBWcRCLv
         wGHg==
X-Gm-Message-State: AC+VfDzs1wv5AkS99HTsjJWyquOAC3Whkpl46geWEFi4NPLtWubF2i9K
        I1SPzbDK4IZ9E8/LkFZkWTrae50oh0LgnanRZCBIXw==
X-Google-Smtp-Source: ACHHUZ6WthzQz9qP/dl9280gK94WV7M4oXkVGcnS1LR3ZqMQqgt/Gt0cR1YOG5/Da/hzd9z/aBElFdN3hT3VqB5a/mI=
X-Received: by 2002:a05:600c:354a:b0:3f5:f63:d490 with SMTP id
 i10-20020a05600c354a00b003f50f63d490mr40224wmq.5.1684141522281; Mon, 15 May
 2023 02:05:22 -0700 (PDT)
MIME-Version: 1.0
References: <0000000000001ca8c205f0f3ee00@google.com> <0000000000001f239205fb969174@google.com>
In-Reply-To: <0000000000001f239205fb969174@google.com>
From:   Aleksandr Nogikh <nogikh@google.com>
Date:   Mon, 15 May 2023 11:05:10 +0200
Message-ID: <CANp29Y6G_1hKheTLG9NeSWv4+GYK=zOsUuu_sKCWqEBwGeOYig@mail.gmail.com>
Subject: Re: [syzbot] [xfs?] KASAN: use-after-free Read in xfs_btree_lookup_get_block
To:     syzbot <syzbot+7e9494b8b399902e994e@syzkaller.appspotmail.com>
Cc:     david@fromorbit.com, dchinner@redhat.com, djwong@kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-xfs@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, May 13, 2023 at 7:29=E2=80=AFPM syzbot
<syzbot+7e9494b8b399902e994e@syzkaller.appspotmail.com> wrote:
>
> syzbot suspects this issue was fixed by commit:
>
> commit 22ed903eee23a5b174e240f1cdfa9acf393a5210
> Author: Darrick J. Wong <djwong@kernel.org>
> Date:   Wed Apr 12 05:49:23 2023 +0000
>
>     xfs: verify buffer contents when we skip log replay
>
> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=3D12710f7a28=
0000
> start commit:   1b929c02afd3 Linux 6.2-rc1
> git tree:       upstream
> kernel config:  https://syzkaller.appspot.com/x/.config?x=3D68e0be42c8ee4=
bb4
> dashboard link: https://syzkaller.appspot.com/bug?extid=3D7e9494b8b399902=
e994e
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=3D172ff2e4480=
000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=3D11715ea848000=
0
>
> If the result looks correct, please mark the issue as fixed by replying w=
ith:
>
> #syz fix: xfs: verify buffer contents when we skip log replay

#syz fix: xfs: verify buffer contents when we skip log replay

>
> For information about bisection process see: https://goo.gl/tpsmEJ#bisect=
ion
>
