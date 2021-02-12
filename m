Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46932C433DB
	for <linux-xfs@archiver.kernel.org>; Fri, 12 Feb 2021 22:29:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 19FF864E8E
	for <linux-xfs@archiver.kernel.org>; Fri, 12 Feb 2021 22:29:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232164AbhBLW3H (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 12 Feb 2021 17:29:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232200AbhBLW2r (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 12 Feb 2021 17:28:47 -0500
Received: from mail-qk1-x72d.google.com (mail-qk1-x72d.google.com [IPv6:2607:f8b0:4864:20::72d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF69AC061756
        for <linux-xfs@vger.kernel.org>; Fri, 12 Feb 2021 14:27:50 -0800 (PST)
Received: by mail-qk1-x72d.google.com with SMTP id q85so1150766qke.8
        for <linux-xfs@vger.kernel.org>; Fri, 12 Feb 2021 14:27:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZgnjDRLdnXUQQQoV68uYk9/ZwCV3N7Ug651HN+ZuSGM=;
        b=Wm23XgqpCkaQZzDFkGAnUZXfJlwhyCekerXROeFhq1de2GvYBy2+UFJ0on0UnGQbyi
         Ba8EzfJU2GFva9t3TG8H1gLwpERqg8b999Gn+T76gon08Ztmz4+MgFvasT1xG+ifQvha
         S41pzDzgdBZyGQGBXJ5J7H9rO3HoWZF+U2qno=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZgnjDRLdnXUQQQoV68uYk9/ZwCV3N7Ug651HN+ZuSGM=;
        b=c0rsfiFxg52MOEnvUpOPvnxNx3I5LG6RbryOxgYZLn6dGVj3KBUql6k6B/SMRL5P8Z
         aZ+q2jdQQFvdOEC2RPu4RBPJvytyYRFEaZGOBzImZKTWrSpuaoResCJaUoYpXgHei7Fn
         Kf0SwN/jNofaInUT6TdFHR9KGGlVHvJVrwH/xC9nWlmhv5qezwTeoEPzNuFZD96OV91K
         +PrLFKHcnmS40P8Q3lE6W1UryPjWTB4VA/lseoGu/mgvHPoymEDNxHJ1DZnAHoIZytUS
         hfB/OlSMlYSFpZym+q9WLwxX2P3tyPYLnrHnGXOd8j32RSRH2omM+zubsY07ho+7gz7y
         nCBg==
X-Gm-Message-State: AOAM5301mZrrff+2KcFvx6Vq+dJP4CvADT2SB6n5Iz8TfdXd4J9vBi9/
        cJO7vTzJ//ZTijhZ7+nRi1+UfJDkXYBoEFM6aljBvWGarx+goA==
X-Google-Smtp-Source: ABdhPJw17NNzaJBOOP+jYav1eDl79txL98rAtwibYpPMPFCtONZJEElNAaG9H/9jEeFeOCc5YGBuRSpL0N72CwPmg7c=
X-Received: by 2002:a37:8e06:: with SMTP id q6mr4894378qkd.402.1613168869752;
 Fri, 12 Feb 2021 14:27:49 -0800 (PST)
MIME-Version: 1.0
References: <20210212204849.1556406-1-mmayer@broadcom.com> <CAGt4E5tbyHpDEPtEGK8SYoB4w4srAfHpiBADkR+PpkQyguiLPg@mail.gmail.com>
 <36f95877-ad2d-a392-cacd-0a128d08fb44@sandeen.net> <CAGt4E5uA6futY0+AySLJTHsmoUp7OceNca=7ReXAg-o8mw0=7Q@mail.gmail.com>
 <5062240d-78a2-50f5-b966-493acff111e5@sandeen.net>
In-Reply-To: <5062240d-78a2-50f5-b966-493acff111e5@sandeen.net>
From:   Markus Mayer <mmayer@broadcom.com>
Date:   Fri, 12 Feb 2021 14:27:38 -0800
Message-ID: <CAGt4E5tQZw5qF--xhYR9dwqgn0iX3X=sgaFa9NnecFqHchOKcw@mail.gmail.com>
Subject: Re: [PATCH] include/buildrules: substitute ".o" for ".lo" only at the
 very end
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     Linux XFS <linux-xfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, 12 Feb 2021 at 14:15, Eric Sandeen <sandeen@sandeen.net> wrote:
>
> On 2/12/21 3:55 PM, Markus Mayer wrote:
> > On Fri, 12 Feb 2021 at 13:29, Eric Sandeen <sandeen@sandeen.net> wrote:
> >>
> >> On 2/12/21 2:51 PM, Markus Mayer wrote:
> >>>> To prevent issues when the ".o" extension appears in a directory path,
> >>>> ensure that the ".o" -> ".lo" substitution is only performed for the
> >>>> final file extension.
> >>>
> >>> If the subject should be "[PATCH] xfsprogs: ...", please let me know.
> >>
> >> Nah, that's fine, I noticed it.
> >>
> >> So did you have a path component that had ".o" in it that got substituted?
> >> Is that what the bugfix is?
> >
> > Yes and yes.
> >
> > Specifically, I was asked to name the build directory in our build
> > system "workspace.o" (or something else ending in .o) because that
> > causes the automated backup to skip backing up temporary build
> > directories, which is what we want. There is an existing exclusion
> > pattern that skips .o files during backup runs, and they didn't want
> > to create specialized rules for different projects. Hence the request
> > for the oddly named directory to make it match the existing pattern.
> >
> > We also have a symlink without the ".o" extension (workspace ->
> > workspace.o) which is commonly used to access the work space, but
> > symlinks  frequently get expanded when scripts run. In the end, the
> > xfsprogs build system saw the full path without the symlink
> > (".../workspace.o/.../xfsprogs-5.8.0/...") and started substituting
> > workspace.o with workspace.lo. And then the build died.
>
> haha, no comment on the strategy ;)

You won't hear an argument from me. *LOL* I had a sneaking suspicion
that the "workspace.o" strategy might trigger some fallout. Turns out
I wasn't wrong.

> But I agree that we should not be substituting anything but the root filename
> suffix, so the patch is fine by me.

Thanks,
-Markus

> -Eric
