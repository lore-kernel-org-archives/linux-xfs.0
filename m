Return-Path: <SRS0=QPje=ZI=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F58AC43141
	for <linux-xfs@archiver.kernel.org>; Sat, 16 Nov 2019 16:19:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EBD9F214DE
	for <linux-xfs@archiver.kernel.org>; Sat, 16 Nov 2019 16:19:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="qOsMbstT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729998AbfKPQTi (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 16 Nov 2019 11:19:38 -0500
Received: from mail-lf1-f67.google.com ([209.85.167.67]:42220 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729306AbfKPQTh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 16 Nov 2019 11:19:37 -0500
Received: by mail-lf1-f67.google.com with SMTP id z12so10365474lfj.9
        for <linux-xfs@vger.kernel.org>; Sat, 16 Nov 2019 08:19:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/PnjqmIIlIHhXzdop+zDlbZL76CmLM1wbNePGOXOi8o=;
        b=qOsMbstTL/yjHDwu8+8uGA+TBymVR/0cP0UYnx0+B+Dw6W/vS3T3WzYYp3raGcvmC3
         6awQuAST4Kc01dzN18hw55AZVA/yEBPxYX38LRLCXT8TBSV0lT5pEMasXCsrw8niuVPV
         7Y9zF2Z9UQBWYFEGzUGLNlqX7+P+QNQGSaIv0R3mXaDTV6wk12BhYPcuRbxavzYWVOb+
         YX7MbXFmi212f80pEtANDKrxH1HyZO98IQRYrkDVyXiLhbNO8HJhCAAc6DVvl8Bh9iuM
         rApsV8HDI9DAJ/ma9XoArumjGuu9FVdAs3zf4KCKbyZQpCVopldqwjeEQ6pZDnLWU+Ml
         510w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/PnjqmIIlIHhXzdop+zDlbZL76CmLM1wbNePGOXOi8o=;
        b=gJJcFgma9ebcji5Xlsfa//R77CV+Z1PAPE7cZyLjwGM2ZLqejnK+f0lpKzio5fthek
         q5sGIUwcsUjCdHZJGPi3E2LcZYLNcVfTeIX+Rz4HH+p5BwnnMFkWL0qhs5YLriekChKf
         RZRAow+Ikx9H9u9QNh1dgIxM+rKxXQJwrLGfq8dCU5b40svFDGy8jrrYj7D6DtWG+7vI
         LHXlBP4DGm19GkU2oCARqCvnf3TfwE3vAzjd97+TEj3BdvjIuaFsTijw4d/WVjJW0Dzs
         79Qj6ZKHQqJ/GbVgXFqGQnTsByhdY1safUZEyactMM2fa7UzfzgDXCNQlUfANpLEf1Ho
         jFzQ==
X-Gm-Message-State: APjAAAUOrtTKiZtb3JwiNkjvvZpfGKati2aPCmTbvt9HRg/uNsE1kfCp
        kJh7ICc07CXL6k3S/H5jE/ymbfSblU3ZbJJrW84=
X-Google-Smtp-Source: APXvYqxeOEszu8pr2B+bGc1fQZp7rWmg2ZIG7TxIVyS3lkRhUohjykGZX9RBo+leXIV3t0zz3MQC5esES9VsTrIMfEA=
X-Received: by 2002:a19:cc1:: with SMTP id 184mr459248lfm.3.1573921174721;
 Sat, 16 Nov 2019 08:19:34 -0800 (PST)
MIME-Version: 1.0
References: <CAKQeeLMxJR-ToX5HG9Q-z0-AL9vZG-OMjHyM+rnEEBP6k6nxHw@mail.gmail.com>
 <CAKQeeLNewDe6hu92Tu19=Opx_ao7F_fbpxOsEHaUH9e2NmLWaQ@mail.gmail.com>
 <e6222784-03a5-6902-0f2e-10303962749c@sandeen.net> <20191115234333.GP4614@dread.disaster.area>
In-Reply-To: <20191115234333.GP4614@dread.disaster.area>
From:   Andrew Carr <andrewlanecarr@gmail.com>
Date:   Sat, 16 Nov 2019 11:19:23 -0500
Message-ID: <CAKQeeLNm51r0g=hyH7xpe811nMTS7SP_AwAtAZMCZ0t3Fz4=4Q@mail.gmail.com>
Subject: Re: Fwd: XFS Memory allocation deadlock in kmem_alloc
To:     Dave Chinner <david@fromorbit.com>
Cc:     Eric Sandeen <sandeen@sandeen.net>, linux-xfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Thanks Dave,
Checking now.

On Fri, Nov 15, 2019 at 6:43 PM Dave Chinner <david@fromorbit.com> wrote:
>
> On Fri, Nov 15, 2019 at 01:52:57PM -0600, Eric Sandeen wrote:
> > On 11/15/19 1:11 PM, Andrew Carr wrote:
> > > Hello,
> > >
> > > This list has recommended enabling stack traces to determine the root
> > > cause of issues with XFS deadlocks occurring in Centos 7.7
> > > (3.10.0-1062).
> > >
> > > Based on what was recommended by Eric Sandeen, we have tried updating
> > > the following files to generate XFS stack traces:
> > >
> > > # echo 11 > /proc/sys/fs/xfs/error_level
> > >
> > > And
> > >
> > > # echo 3 > /proc/sys/fs/xfs/error_level
> > >
> > > But no stack traces are printed to dmesg.  I was thinking of
> > > re-compiling the kernel with debug flags enabled.  Do you think this
> > > is necessary?
>
> dmesg -n 7 will remove all filters on the console/dmesg output - if
> you've utrned this down in the past you may not be seeing messages
> of the error level XFS is using...
>
> Did you check syslog - that should have all the unfiltered messages
> in it...
>
> Cheers,
>
> Dave.
> --
> Dave Chinner
> david@fromorbit.com



-- 
With Regards,
Andrew Carr

e. andrewlanecarr@gmail.com
w. andrew.carr@openlogic.com
c. 4239489206
a. P.O. Box 1231, Greeneville, TN, 37744
