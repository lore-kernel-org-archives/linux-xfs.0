Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 719FBC433EF
	for <linux-xfs@archiver.kernel.org>; Thu, 26 May 2022 18:47:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244430AbiEZSrk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 26 May 2022 14:47:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234426AbiEZSrj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 26 May 2022 14:47:39 -0400
Received: from mail-qt1-x82e.google.com (mail-qt1-x82e.google.com [IPv6:2607:f8b0:4864:20::82e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 824AF9FC4;
        Thu, 26 May 2022 11:47:38 -0700 (PDT)
Received: by mail-qt1-x82e.google.com with SMTP id h9so2745267qtx.2;
        Thu, 26 May 2022 11:47:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1oSwt00WNw6orq6T/Jm2yAJ1tsZDZcf1gPyOSl7Emgc=;
        b=nAOXNnwQRnlPdkNQMGdRuflkPHx4sozvC1rubaxgndKee3muKW/KjFgHs4GIZaq4YP
         zYawTnUdyDMpMwmoQl9FDNW5sZpogIsX7AbOInL/cJX+cOSnKCnPNWumq9LFLYTNHWGN
         kEaFfG5Mm0uFO6BjlR7PGHi/YOsRj5SN3FnoqhSd/zYlaWTfqNtUOAyfnLtWxErl+OVQ
         /NigE9e7lRVsymc93qPZ3z1sB76QovBPGoBCeTe/E7/Ry4QpDPE4/bNanWLJ0JgiAUX1
         ROPMu3r87+E87b0VmWjAzk7kzpXhmPsL6tBP6L83EVwmx9SNV2E/N2g6r8/tGyOZFCWQ
         gGXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1oSwt00WNw6orq6T/Jm2yAJ1tsZDZcf1gPyOSl7Emgc=;
        b=8GxMjPPSgZw7NEMM6UltKpRO7otC8Zxf8cMrS/IAf8aBuljue1SRJConLX65EEBXL1
         wPUa35Vur0RxN2VBXss//5LMqf3GJ//K+5V22vJ4FKDDeKqWYFk5k2ra9WMZXB7adLNK
         UOkpb1ibiRCPw5a2JtEMHojSPFUMqNvQ3ycSv9sIhea+/3hvkhvKpVx1eogFZ65yX41v
         KVR4T3bKK2eG/RDhOGgF6BotsVxT9yjUMKk1p77Hn7/WRdthwfrpVQnNx1mV0E8UOzha
         m3oJOI8hOvDjXHP09JD9dhez3F2HJMtsZaqYCEqN5EfCtHMMv+HIm/1QNgFbSqD+9dTh
         Sbew==
X-Gm-Message-State: AOAM533AsyjBlLcLSlZvIbjvSTC0kIn2X/PDm+mJNdKor4jvHp7U+ewX
        Mb0+0aQqHwHxNXOv+M8G2sic+XqCg+daHd1g30FWHYBDwug=
X-Google-Smtp-Source: ABdhPJy4Zwte7dDhAJgE9VGORxfSld5J4DKhtANT6j+e1QwNoXBwcYQ+18SveuQDtg3c9PLSsA5CtibfN2hQW47ksg0=
X-Received: by 2002:ac8:4e42:0:b0:2f4:fc3c:b0c8 with SMTP id
 e2-20020ac84e42000000b002f4fc3cb0c8mr30262742qtw.684.1653590857604; Thu, 26
 May 2022 11:47:37 -0700 (PDT)
MIME-Version: 1.0
References: <20220525111715.2769700-1-amir73il@gmail.com> <Yo+4jW0e4+fYIxX2@magnolia>
In-Reply-To: <Yo+4jW0e4+fYIxX2@magnolia>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Thu, 26 May 2022 21:47:26 +0300
Message-ID: <CAOQ4uxi+5bt5-hnjWLhZe++CH6zN8Ym=9nhJaCoA0NtoM2sMdw@mail.gmail.com>
Subject: Re: [PATH 5.10 0/4] xfs stable candidate patches for 5.10.y (part 1)
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Dave Chinner <david@fromorbit.com>,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        "Theodore Ts'o" <tytso@mit.edu>,
        Adam Manzanares <a.manzanares@samsung.com>,
        Tyler Hicks <code@tyhicks.com>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        fstests <fstests@vger.kernel.org>,
        Leah Rumancik <lrumancik@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, May 26, 2022 at 8:27 PM Darrick J. Wong <djwong@kernel.org> wrote:
>
> On Wed, May 25, 2022 at 02:17:11PM +0300, Amir Goldstein wrote:
> > Hi all!
> >
> > During LSFMM 2022, I have had an opportunity to speak with developers
> > from several different companies that showed interest in collaborating
> > on the effort of improving the state of xfs code in LTS kernels.
> >
> > I would like to kick-off this effort for the 5.10 LTS kernel, in the
> > hope that others will join me in the future to produce a better common
> > baseline for everyone to build on.
> >
> > This is the first of 6 series of stable patch candidates that
> > I collected from xfs releases v5.11..v5.18 [1].
> >
> > My intention is to post the parts for review on the xfs list on
> > a ~weekly basis and forward them to stable only after xfs developers
> > have had the chance to review the selection.
> >
> > I used a gadget that I developed "b4 rn" that produces high level
> > "release notes" with references to the posted patch series and also
> > looks for mentions of fstest names in the discussions on lore.
> > I then used an elimination process to select the stable tree candidate
> > patches. The selection process is documented in the git log of [1].
> >
> > After I had candidates, Luis has helped me to set up a kdevops testing
> > environment on a server that Samsung has contributed to the effort.
> > Luis and I have spent a considerable amount of time to establish the
> > expunge lists that produce stable baseline results for v5.10.y [2].
> > Eventually, we ran the auto group test over 100 times to sanitize the
> > baseline, on the following configurations:
> > reflink_normapbt (default), reflink, reflink_1024, nocrc, nocrc_512.
> >
> > The patches in this part are from circa v5.11 release.
> > They have been through 36 auto group runs with the configs listed above
> > and no regressions from baseline were observed.
>
> Woot!
>
> > At least two of the fixes have regression tests in fstests that were used
> > to verify the fix. I also annotated [3] the fix commits in the tests.
> >
> > I would like to thank Luis for his huge part in this still ongoing effort
> > and I would like to thank Samsung for contributing the hardware resources
> > to drive this effort.
> >
> > Your inputs on the selection in this part and in upcoming parts [1]
> > are most welcome!
>
> /me wonders if you need commit 9a5280b312e2 xfs: reorder iunlink remove
> operation in xfs_ifree ?  Or did that one already get pulled in?
>

Ok. I added it to my branch.
Note that 5.10.y was not getting any xfs fixes for 2 years, so for now I am
working my way up from v5.11 and not expediting any fixes, because if
downstream users waited for 2 years, they can wait a few more weeks.

My list of candidates was extracted at time of 5.18-rc1 and I intentionally
wanted to let the 5.18 patches soak before I consider them.
I will get to the 5.18 release when I am done posting fixes up to 5.17.

> The changes proposed look reasonable to me, and moreso with the testing
> to prove it.  Minor nit: patchsets should be tagged "PATCH", not "PATH".
>

Oy :)

I'll be sure to fix that when I post to stable.

Thanks,
Amir.
