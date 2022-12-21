Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8DD9CC4332F
	for <linux-xfs@archiver.kernel.org>; Wed, 21 Dec 2022 18:40:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234804AbiLUSkI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 21 Dec 2022 13:40:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229578AbiLUSkI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 21 Dec 2022 13:40:08 -0500
Received: from mail-qt1-x830.google.com (mail-qt1-x830.google.com [IPv6:2607:f8b0:4864:20::830])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3497226553
        for <linux-xfs@vger.kernel.org>; Wed, 21 Dec 2022 10:40:07 -0800 (PST)
Received: by mail-qt1-x830.google.com with SMTP id jr11so14350382qtb.7
        for <linux-xfs@vger.kernel.org>; Wed, 21 Dec 2022 10:40:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=j9DuR/4OGCoWN0467mEaULUjcAOjTyT79yl+s3BbH0w=;
        b=Nkz0zl1U7Q00ABqDvJs8hPQU8XJ56556QErttlJHjrbjT4dsyO7/Y4t9Jp2Ew+stEq
         gFsUEYQCsplVczcqKymUnU9LP8XGVsLIOTyIIRwCEkNY8vds1Y8r/m5EUc6N2LG1Vo6l
         3l7SEe3vrt0PT1/1BLwfj6utOP4gu2U0E/+dc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=j9DuR/4OGCoWN0467mEaULUjcAOjTyT79yl+s3BbH0w=;
        b=WaCasIzdW7p2cWty6+F49vI3UZXZMuLEr1aS6+dKNTUnXto8+Nh6jFH/Mc20mlPvMZ
         9IYDI5UpfUTkVrLNqb030KbErUdvNGZq/GMz+w4b2dQVZA5ux1j+FbWT5KVbFYE/cEwM
         6o2ba1Z6FJPbys/ev6mWDa2bSpbDlfrCUzifY5mQEQAgLIln6TteyTCbCBpgR7ksfSuW
         8HRDqkXirITGbL2s4d/omT566v7e11n8l6DmO+0X1QImLb586TGTe7iI2d8GlLu/ENoD
         YLJfJuL1MHI4N30BjUATAk1tYZEXyAbG6vki7jaEIC1WPfqtlMlSLT/8ZvT2pOT6j7/P
         pqgw==
X-Gm-Message-State: AFqh2koWnBWR2VXhAU7FmzAaWvD18p3tBqDG6nKg2FBFMhfnKvE+vbv1
        1fMMyf6bQdIyI9LBKZ+1R0qyeV1WkrkxBs8Y
X-Google-Smtp-Source: AMrXdXs1l8y5AtiPYsQ2E5ueQc1W5CKVQZnryzQLTfwkobXL1ul1I/1YDI3YohZeCFBafwEq7tYJLw==
X-Received: by 2002:a05:622a:59cb:b0:3a9:80b6:4c9c with SMTP id gc11-20020a05622a59cb00b003a980b64c9cmr3345420qtb.47.1671648006025;
        Wed, 21 Dec 2022 10:40:06 -0800 (PST)
Received: from mail-qk1-f175.google.com (mail-qk1-f175.google.com. [209.85.222.175])
        by smtp.gmail.com with ESMTPSA id bn35-20020a05620a2ae300b006ce76811a07sm11077117qkb.75.2022.12.21.10.40.04
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 21 Dec 2022 10:40:04 -0800 (PST)
Received: by mail-qk1-f175.google.com with SMTP id p12so2272004qkm.0
        for <linux-xfs@vger.kernel.org>; Wed, 21 Dec 2022 10:40:04 -0800 (PST)
X-Received: by 2002:ae9:ef49:0:b0:6fe:d4a6:dcef with SMTP id
 d70-20020ae9ef49000000b006fed4a6dcefmr97898qkg.594.1671648004539; Wed, 21 Dec
 2022 10:40:04 -0800 (PST)
MIME-Version: 1.0
References: <167155161011.40255.9717951395121213068.stg-ugh@magnolia>
In-Reply-To: <167155161011.40255.9717951395121213068.stg-ugh@magnolia>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed, 21 Dec 2022 10:39:48 -0800
X-Gmail-Original-Message-ID: <CAHk-=wjxdo-VBecNV90ye_X6C_zdkTUNqtqxuxbwz5OnL8Jhqg@mail.gmail.com>
Message-ID: <CAHk-=wjxdo-VBecNV90ye_X6C_zdkTUNqtqxuxbwz5OnL8Jhqg@mail.gmail.com>
Subject: Re: [GIT PULL] fsdax,xfs: fix data corruption problems
To:     "Darrick J. Wong" <djwong@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc:     allison.henderson@oracle.com, linux-xfs@vger.kernel.org,
        ruansy.fnst@fujitsu.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Dec 20, 2022 at 8:01 AM Darrick J. Wong <djwong@kernel.org> wrote:
>
> As usual, I did a test-merge with the main upstream branch as of a few
> minutes ago, and didn't see any conflicts.  Please let me know if you
> encounter any problems.

Well... There are no conflicts, because there are no changes.

All of these commits actually already came to me earlier through Andrew's tree.

I suspect you actually saw an empty diff when you did the test-merge,
but didn't realize that "empty diff" in this case was literally
exactly that (as opposed to "there was a diff, just that it was not
shown").

So for example, you had commit 3a0a36f143e4 ("fsdax,xfs: port unshare
to fsdax") but my tree got commit d984648e428b ("fsdax,xfs: port
unshare to fsdax") from Andrew Morton back last week when I did his MM
merge (my merge commit is e2ca6ba6ba01).

I'm skipping this pull request, because the end result ends up being
zero actual code changes, with all the commits having duplicates.

Git handled it fine, auto-merging it all, but it just doesn't seem
sensible to merge just to get that duplicate history.

Adding Andrew to the Cc, because obviously there was some
communication failure and confusion here. Quite often the dax changes
*do* fome through Andrew, so maybe the only issue this time was that
because it only really affected XFS, we ended up having that "xfs
people _also_ worked on it".

              Linus
