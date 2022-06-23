Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45A8ECCA47C
	for <linux-xfs@archiver.kernel.org>; Thu, 23 Jun 2022 05:31:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229476AbiFWFbs (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 23 Jun 2022 01:31:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbiFWFbr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 23 Jun 2022 01:31:47 -0400
Received: from mail-vs1-xe29.google.com (mail-vs1-xe29.google.com [IPv6:2607:f8b0:4864:20::e29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F11AD3A5E0;
        Wed, 22 Jun 2022 22:31:42 -0700 (PDT)
Received: by mail-vs1-xe29.google.com with SMTP id 184so4118325vsz.2;
        Wed, 22 Jun 2022 22:31:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Jwsao8T1ShIZ3cq30KhHlFNF6ltOQKMqhnxaS2OFbEc=;
        b=gA6b6dc8brGoirKyezfIwxcWm9do3q1eHf3n2sQ+LQh8HEDKGgklVA7KiO9vqnWw48
         1/xErQnj6NZaH5vTpfLB//MdXNpn0gCi6M3Dpna6MBMKY4bXlSqH1INyvmOuNZO6sH5y
         CJpiY3XIlp0jWkXIaY9X72Sk+JOqGXew7T7/1Q38u9Ekzz/4Qk4lxKBTaJoQBXxCTvlt
         CKdkRk+p2GqhJAsqi/LfuJLofMbX/6ouujcnHVCGLUmQ/vadN/bpxCC+kCCVmMy7/Pwf
         XFZ5yDjNAvMXgYc8hCFZ+eRRqj0arY8GFLDqeXdSslrsMHWtU9dIPqrGb1f0qJotbyQ5
         uxyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Jwsao8T1ShIZ3cq30KhHlFNF6ltOQKMqhnxaS2OFbEc=;
        b=Ku8Z4gAkROWOkivVAJWMC0k6WJfVd2nfYjBoDbb2TOBod3LZJMdmQUng5YdlSAPAwo
         qkaIiUlTg7nCCUmdzuyJ6N4YkMrGH5zAdmnbOTmDWZhPvlEDmT4V4bD+5weH6aQOC82T
         wzPdjDJ7m04SNroe1OO84WrJqkeWwVH2sXQ8gSgzC3SZYiN3gSNz6hqYaps+lc/Y1wv9
         EkZeSIuyYxa785KF2yvhWpqpX0+HMfDghD9GcIsnnWZmsbqS3bLaflgpBWlZ1EadlcJf
         RvwZgu7w2huNsqUXskPuaRLEKPjfPGrHgRvnh7y5fjRA+pt8gDg50XF9G9eUc1Qa1s9a
         WcsA==
X-Gm-Message-State: AJIora+Kky1b/j8+2cdApRRkrJe1QsN2kywUi9w0oXlW/dTpSZuUfEHI
        AQkuOQ3QPBNzVtV7Or7RgZPq34MaJ5Pd5HRonv4=
X-Google-Smtp-Source: AGRyM1tL61W6Rzw7IdNnn4nNIgJgHg+Aj7Z9t7c8r2h8N0FfiEQItzLDCvjzgILSYhaQOSx5MONQV8fd9zRqmivUyI0=
X-Received: by 2002:a05:6102:5dc:b0:354:63f1:df8d with SMTP id
 v28-20020a05610205dc00b0035463f1df8dmr2955535vsf.72.1655962302101; Wed, 22
 Jun 2022 22:31:42 -0700 (PDT)
MIME-Version: 1.0
References: <20220616182749.1200971-1-leah.rumancik@gmail.com>
 <YrJdLhHBsolF83Rq@bombadil.infradead.org> <YrONPrBgopZQ2EUj@mit.edu>
In-Reply-To: <YrONPrBgopZQ2EUj@mit.edu>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Thu, 23 Jun 2022 08:31:30 +0300
Message-ID: <CAOQ4uxiNncOAM6cLPia6VNbKz0nZ4vUx1GHnHAN44JRgC6q1ug@mail.gmail.com>
Subject: Re: [PATCH 5.15 CANDIDATE v2 0/8] xfs stable candidate patches for
 5.15.y (part 1)
To:     "Theodore Ts'o" <tytso@mit.edu>
Cc:     Luis Chamberlain <mcgrof@kernel.org>,
        Leah Rumancik <leah.rumancik@gmail.com>,
        Josef Bacik <josef@toxicpanda.com>,
        Chuck Lever <chuck.lever@oracle.com>, chandanrmail@gmail.com,
        Sweet Tea Dorminy <sweettea-kernel@dorminy.me>,
        Pankaj Raghav <pankydev8@gmail.com>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        fstests <fstests@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

> It's optimized for developers, and for our use cases.  I'm sure
> kdevops is much more general, since it can work for hardware-based
> test machines, as well as many other cloud stacks, and it's also
> optimized for the QA department --- not surprising, since where
> kdevops has come from.
>

[...]

>
> We also have a very different philosophy about how to use expunge
> files.  In paticular, if there is test which is only failing 0.5% of
> the time, I don't think it makes sense to put that test into an
> expunge file.
>
> In general, we are only placing tests into expunge files when
> it causes the system under test to crash, or it takes *WAAAY* too
> long, or it's a clear test bug that is too hard to fix for real, so we
> just suppress the test for that config for now.  (Example: tests in
> xfstests for quota don't understand clustered allocation.)
>
> So we want to run the tests, even if we know it will fail, and have a
> way of annotating that a test is known to fail for a particular kernel
> version, or if it's a flaky test, what the expected flake percentage
> is for that particular test.  For flaky tests, we'd like to be able
> automatically retry running the test, and so we can flag when a flaky
> test has become a hard failure, or a flaky test has radically changed
> how often it fails.  We haven't implemented all of this yet, but this
> is something that we're exploring the design space at the moment.
>
> More generally, I think competition is a good thing, and for areas
> where we are still exploring the best way to automate tests, not just
> from a QA department's perspective, but from a file system developer's
> perspective, having multiple systems where we can explore these ideas
> can be a good thing.
>

I very much agree with Ted on that point.

As a user and big fan of both kdevops and fstests-bld I wouldn't
want to have to choose one over the other, not even to choose
a unified expunge list.

I think we are still at a point where this diversity makes our ecosystem
stronger rather than causing duplicate work.

To put it in more blunt terms, the core test suite, fstests, is not
very reliable. Neither kdevops nor fstests-bld address all the
reliability issue (and they contribute some of their own).
So we need the community to run both to get better and more
reliable filesystem test coverage.

Nevertheless, we should continue to share as much experience
and data points as we can during this co-opetition stage in order to
improve both systems.

Thanks,
Amir.
