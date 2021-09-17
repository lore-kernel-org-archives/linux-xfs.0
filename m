Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6C14C433EF
	for <linux-xfs@archiver.kernel.org>; Fri, 17 Sep 2021 02:31:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 80B676113A
	for <linux-xfs@archiver.kernel.org>; Fri, 17 Sep 2021 02:31:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242740AbhIQCc7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Sep 2021 22:32:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235118AbhIQCc6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Sep 2021 22:32:58 -0400
Received: from mail-io1-xd36.google.com (mail-io1-xd36.google.com [IPv6:2607:f8b0:4864:20::d36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DF84C061574;
        Thu, 16 Sep 2021 19:31:37 -0700 (PDT)
Received: by mail-io1-xd36.google.com with SMTP id g9so10355499ioq.11;
        Thu, 16 Sep 2021 19:31:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NuvBmw6cCGiq3RJD+Zt4hkm198hAaQNjVtZlomWjdxg=;
        b=d6YPwq9pMMWXRwDrAQMcdm592xgFXZgFsvKGT0Yd1m6baLguOlhYDj96zsCDAFOOs7
         2I0iOxonrgYVGEIbHgG6mXsHnZGKGn4WSRxNg7T+oyHj1MyWcZwpI4s6/GbSP0M/xEuS
         DsalqapgmzBFjdXGkBgkVmUxOhYkLQj5JP1VttVpzXVKe7r+XUnNWSdfGuRinba/3coe
         HgJ2cOkyvld0pdhiIWeeBKeoqDLda6nbA0uiqjPlkahxCzb4C/E/5MzNc8LjfSEzbDO1
         8GLIu2XQ/slqUDV4hmimKpv7B+1yQFo7Jjq16vkjQoaA8ehHa8UsuJ1Ar4O3v1FjB0O6
         8YYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NuvBmw6cCGiq3RJD+Zt4hkm198hAaQNjVtZlomWjdxg=;
        b=MoMTL13FqR0oGhyNNfndEHlBbU/MDu2Xc5GFMPi8vs9uhu8GorP3uhSx7JkoR+R7Oi
         LS4/De4/8r+WIBHwJOHPtev9fXQp6iFlkf4GfuysGLbYY1l1gTKX5zFEVYAJ/Iqj7sWJ
         hnUspau3CI1DgC8+DZXfXblEfMcYvbl8UHOES4dSoxnnsNVHmuBKLYn1gJ64AuBNqAch
         ES0ilRqxaC1q7N5G1hz9UxF/VvWdzYgQRDJwVn9DHC0zk/UAxDcAcCMeCtbCAaDDmOVz
         CKwROWGxRVsJc/FPylGNXaTAe3HUlTlxRaQE5c9gR3xWjk1SmaC361wgRsq9o21q2Lsc
         5SgQ==
X-Gm-Message-State: AOAM531Gf12xAfvTlOcb8tjpSSXhx9dk1Pz9cQvl4UHI7Rw/kPBx4039
        9rScQr4Ocr5XSs9QQBySPzanSXoo4x3UYO1edmwff/F4
X-Google-Smtp-Source: ABdhPJzKqEUJKQ6zf8NTDfGVBMPYTEolQ1qRxJ2ldNGdpWGjR2DTGMRS5YyXuIs+RUN0LM6IC2cmzT2b/tRiJ6e6JcM=
X-Received: by 2002:a6b:6f18:: with SMTP id k24mr6750022ioc.196.1631845896734;
 Thu, 16 Sep 2021 19:31:36 -0700 (PDT)
MIME-Version: 1.0
References: <163174935747.380880.7635671692624086987.stgit@magnolia>
 <163174940659.380880.14564845266535022734.stgit@magnolia> <CAOQ4uxh6fZNzCX2wAQdhmz4Z+4xGbZMF0zfSkKUZKjS0KZhpOA@mail.gmail.com>
 <20210916225306.GB34846@magnolia>
In-Reply-To: <20210916225306.GB34846@magnolia>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Fri, 17 Sep 2021 05:31:25 +0300
Message-ID: <CAOQ4uxiXFw9t61S3J3MPULqrS9RvGEUPQf3Eq54P9qtjL8zMcw@mail.gmail.com>
Subject: Re: [PATCH 9/9] new: don't allow new tests in group 'other'
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Eryu Guan <guaneryu@gmail.com>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        fstests <fstests@vger.kernel.org>, Eryu Guan <guan@eryu.me>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Sep 17, 2021 at 1:53 AM Darrick J. Wong <djwong@kernel.org> wrote:
>
> On Thu, Sep 16, 2021 at 09:40:54AM +0300, Amir Goldstein wrote:
> > On Thu, Sep 16, 2021 at 2:43 AM Darrick J. Wong <djwong@kernel.org> wrote:
> > >
> > > From: Darrick J. Wong <djwong@kernel.org>
> > >
> > > The 'other' group is vaguely defined at best -- other than what?  It's
> > > not clear what tests belong in this group, and it has become a dumping
> > > ground for random stuff that are classified in other groups.  Don't let
> > > people create new other group tests.
> > >
> > > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > > ---
> > >  new |    7 +++++--
> > >  1 file changed, 5 insertions(+), 2 deletions(-)
> > >
> > >
> > > diff --git a/new b/new
> > > index 6b7dc5d4..5cf96c50 100755
> > > --- a/new
> > > +++ b/new
> > > @@ -96,9 +96,9 @@ then
> > >
> > >      while true
> > >      do
> > > -       echo -n "Add to group(s) [other] (separate by space, ? for list): "
> > > +       echo -n "Add to group(s) [auto] (separate by space, ? for list): "
> > >         read ans
> > > -       [ -z "$ans" ] && ans=other
> > > +       [ -z "$ans" ] && ans=auto
> > >         if [ "X$ans" = "X?" ]
> > >         then
> > >             echo $(group_names)
> > > @@ -109,6 +109,9 @@ then
> > >                 echo "Invalid characters in group(s): $inval"
> > >                 echo "Only lower cases, digits and underscore are allowed in groups, separated by space"
> > >                 continue
> > > +           elif echo "$ans" | grep -q -w "other"; then
> > > +               echo "Do not add more tests to group \"other\"."
> > > +               continue
> >
> > Should we also filter out "other" from group_names(), so it is not listed
> > for "?"?
>
> No; there are drawbacks to that, as you point out below.
>
> > With this patch, "other" does not emit a warning when passed in as a script
> > command line argument.
>
> Done.
>
> > If we filter "other" from group_names(), then the warning in "expert mode"
> > will be a bit confusing (group "other" not defined in documentation).
>
> I will filter it out in the specific case case that the interactive user
> specified "?" to list the groups.
>
> > Also, it is not clear to me if this is intentional behavior that interactive
> > mode allows non-dcumented groups (with valid chars validation) and
> > expert mode does not allow non-documented groups?
>
> Probably not.
>
> > It may be simpler to use the same helper in both modes (is_group_valid)
> > to emit the correct warning and either proceed (expert mode) or get
> > back to prompt (interactive mode).
>
> This is getting farther afield from where I wanted this thing to go.
> Very well, I'll split the ./new cleanups into its own series, but TBH
> I've gotten tired of people asking for more and more cleanups out of me.
>

Fair enough.
TBH I just wanted to point out the inconsistencies that I noticed.
I don't really mind if they are fixed.
I should have been more clear about this point.

Thanks,
Amir.
