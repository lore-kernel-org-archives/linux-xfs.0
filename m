Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85634C433EF
	for <linux-xfs@archiver.kernel.org>; Sat, 16 Apr 2022 17:31:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232706AbiDPRdo (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 16 Apr 2022 13:33:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232696AbiDPRdl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 16 Apr 2022 13:33:41 -0400
Received: from mail-qt1-x82c.google.com (mail-qt1-x82c.google.com [IPv6:2607:f8b0:4864:20::82c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 140BE27CCB;
        Sat, 16 Apr 2022 10:31:08 -0700 (PDT)
Received: by mail-qt1-x82c.google.com with SMTP id ay4so7718577qtb.11;
        Sat, 16 Apr 2022 10:31:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=zRtyE3kTqpeT6ORgzV4r5W8Jc7LhVq8yachWxEnoRbQ=;
        b=lVtGTNqjYI/16P69e9FOmCRvmAXVlpMA4F6sVOmxtE/+BEzKO2OXODJi3VuobaYv2g
         XKp3VyIlhH6tXVOvTVUMitOjYpx3kzsy2It7foJfDS7T0c0sIY5FW9ribMg+RpUtsx86
         a52yKuOc2bAb9j2wlls23HD8lwaObZvrWq65UGtrz2jE6H3acTz4OG7xSJJWwxgvUrvz
         XzzIUbRDwufW2+z8cpvD4YqeNd641TM8e84IZFccC/iEoJWxCRoaXgRKRijbU1RyPcz0
         D4T8N9K/VOiUOfViS5wAdACBlSHKklp6bzIQsk3bQvB1BET8zLSpTrbOIJb9B9RMAbSa
         3aEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=zRtyE3kTqpeT6ORgzV4r5W8Jc7LhVq8yachWxEnoRbQ=;
        b=zhgYNW3Agt46fdmZCb1alqqWcaUBZutqDULsfr2Pjwy1V+fv/HgOSoOvA4Y4+2ygFj
         pVx+J61IfMk1P0MKCI8BdWP2QlcWoInogSM0KbAtq8jQIg/rNTpXZRZBKTCx78QvccMO
         exvuPWqJfjI4xS2YtHwW2Zh6wFwlTz8viq2QhhD21khD3d5hWXu0quUTi2Tccjr0hGWF
         clCXLRBx69fmwZqi4z4eLXElStANa3hOCJldOk+yer7NaXoKIzFH4B2oIjEa2yxA6p7H
         sc5kZVDGvHz9jAHPipYTV8djmLgDGIdKCENSlo8FzrIGOhrT5Oh2BEvdQLIo5mErK1gU
         yt8A==
X-Gm-Message-State: AOAM530lDFgim+oT4PtiD58T3f5ZoOR5CuhvvcjLIBSqFWI8g9YvcqTR
        1h9MMeQZY9Gwzu/nq17e0o4UlZhCHRf0oRzJwJr+b+Enovo=
X-Google-Smtp-Source: ABdhPJxF5qAkL9OaUs4Hx7SzT86sFwmHzHfmewJoO6RbwVKvBjivul46t0JorYHPT1EEekSgt78aiBmC2DFwGchaUBs=
X-Received: by 2002:ac8:5dcb:0:b0:2e1:ce48:c186 with SMTP id
 e11-20020ac85dcb000000b002e1ce48c186mr2810230qtx.2.1650130267213; Sat, 16 Apr
 2022 10:31:07 -0700 (PDT)
MIME-Version: 1.0
References: <164971767143.169983.12905331894414458027.stgit@magnolia>
 <164971768254.169983.13280225265874038241.stgit@magnolia> <20220412115205.d6jjudlkxs72vezd@zlang-mailbox>
 <CAOQ4uxiDW6=qgWtH8uHkOmAyZBR7vfgwgt-DA_Rn0QVihQZQLw@mail.gmail.com>
 <20220413154401.vun2usvgwlfers2r@zlang-mailbox> <20220414155007.GC17014@magnolia>
 <20220414191017.jmv7jmwwhfy2n75z@zlang-mailbox> <CAOQ4uxgSmxaOHCj1RdCOX2p1Zmu5enkc4f_fkOLC_muPiMk=PA@mail.gmail.com>
 <20220416140158.fd7jjle5aeomg6cp@zlang-mailbox>
In-Reply-To: <20220416140158.fd7jjle5aeomg6cp@zlang-mailbox>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Sat, 16 Apr 2022 20:30:55 +0300
Message-ID: <CAOQ4uxhrdHbc7xerq4Q+Qo0gF6oG=DuaEXU87LE2hma2367ynQ@mail.gmail.com>
Subject: Re: [PATCH 2/4] generic: ensure we drop suid after fallocate
To:     Amir Goldstein <amir73il@gmail.com>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Eryu Guan <guaneryu@gmail.com>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        fstests <fstests@vger.kernel.org>, Eryu Guan <guan@eryu.me>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Apr 16, 2022 at 5:02 PM Zorro Lang <zlang@redhat.com> wrote:
>
> On Fri, Apr 15, 2022 at 04:42:33PM +0300, Amir Goldstein wrote:
> > > Hi Darrick, that's another story, you don't need to worry about that in this case :)
> > > I'd like to ack this patch, but hope to move it from generic/ to shared/ . Maybe
> > > Eryu can help to move it, or I can do that after I get the push permission.
> > >
> > > The reason why I intend moving it to shared is:
> > > Although we are trying to get rid of tests/shared/, but the tests/shared/ still help to
> > > remind us what cases are still not real generic cases. We'll try to help all shared
> > > cases to be generic. When the time is ready, I'd like to move this case to generic/
> > > and change _supported_fs from "xfs btrfs ext4" to "generic".
> > >
> >
> > Sorry, but I have to object to this move.
> > I do not think that is what tests/shared should be used for.
> >
> > My preferences are:
> > 1. _suppoted_fs generic && _require_xfs_io_command "finsert"
>
> There is:
> "verb=finsert
>  _require_xfs_io_command $verb"
>
> This patch has not only one case, different cases test different mode of fallocate,
> and I think Darrick has given them different _require_xfs_io_command.
>

I know. I meant that the tests for verbs finsert/fcollapse can definitely use
generic as there are very few fs that support those verbs and those fs
should be fixed, not hide the failure.

cifs maintainer btw is using whitelists of tests for CI, so new
failing tests  are
not likely to affect cifs testing.

> > 2. _suppoted_fs generic
> > 3. _supported_fs xfs btrfs ext4 (without moving to tests/shared)
>
> There's not any generic cases write like this, only shared cases like that. My personal
> opinion is *(2)* or make it shared if it insists "_supported_fs xfs btrfs ext4" (then
> will move it back to generic and "_suppoted_fs generic" when Darrick think it's time).
>

Let's wait to hear what Darrick has to say.
I just don't understand the incentive to hide test failures from buggy fs even
if this is a change of long time behavior.

BTW, here is untested draft of what I started working on:
https://github.com/amir73il/xfstests/commits/hints

With the new helpers, this test could also be classified as:

_suppoted_fs generic
_known_issue_on_fs ^xfs ^btrfs ^ext4

Meaning that the test runs on all fs, unless tester opts-out with
-x known_issues
and if test is run an fails an hint is printed:
"You _MAY_ be hit by a known issue on $FSTYP."

I'll probably be done with testing those patches and post them tomorrow.

Thanks,
Amir.
