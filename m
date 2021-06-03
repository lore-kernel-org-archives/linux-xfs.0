Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CEB9EC47096
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Jun 2021 16:57:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B9818613B1
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Jun 2021 16:57:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230352AbhFCQ7D (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 3 Jun 2021 12:59:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230328AbhFCQ7C (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 3 Jun 2021 12:59:02 -0400
Received: from mail-il1-x130.google.com (mail-il1-x130.google.com [IPv6:2607:f8b0:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8793EC06174A;
        Thu,  3 Jun 2021 09:57:01 -0700 (PDT)
Received: by mail-il1-x130.google.com with SMTP id z1so6295465ils.0;
        Thu, 03 Jun 2021 09:57:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=lX4hqTeojsCxlCjVcSyGtAHQBWJXcmm1DqJarIdm/sg=;
        b=MxP8ziVu/pVztEmMDq/vjvOwOyvBVul9k7MAWTaUD/lYB6pskSRfPR7FgMQswT2ecy
         UwrzS/lYX490cNxErGUnGeYaw25xuaO6IPstMp9xbdE0tL/JqJQ834XAlCDAMOjwzLq0
         GsYZMVKULHXCcTyYJMTOD74JMOwdzbjZvJVAw5+4WeiLWigzr5hH9Ixnhca3xzxD0IyH
         ZNIRDmLNclB2K7ufeXXpvIZnio6b9ggQbvavB2WXj1PY5ri9Z2JanJT5kKo0HJZxAYzW
         BvpfSoY4xt2pLtkmuEkSpZC5HyrPEJEohuHVKnoMoOQWx4Ov1FaFt6ytbP22BBopP5Fv
         LlVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=lX4hqTeojsCxlCjVcSyGtAHQBWJXcmm1DqJarIdm/sg=;
        b=hPPKTVVZwIayuDrnMz+mM+FbsYBfuaEgqYsOlQ6Y0jqtbkWyIMt1WzDGAotPHNVKVV
         NX8octo+Vzh6LawekWZitm5QfSnVBsxq6LTJP/D1DpKOduN5afMxcXO1K6LtY/++qAbx
         uhUQ4f6nlD43pzaJAl9fPbX59CCWlEtIG7woe4ju4iHL1EA/3CB8z/rABzMxgUK2+6Ca
         Q/vE2WziohsWKmuSK6d8VpiSDOYgo56XOasYzKSvFPDNuoMsv/621ey/0sRdD6+a3jO1
         Ii5R9hEftApsP9RoCb5RRE/QmbnNQdCvfKMTqN3+A6frPb1vTA246VNykIcY6OUoRa9U
         q7ng==
X-Gm-Message-State: AOAM533warm6/Aef1toTIvwZ9q/wGz85ahccoxyZRRqWYS2rC5nINiI7
        kXzLSWJv8ufmdTxv2OS5YOT8ud42QayE6UsaRQ+Mrtor
X-Google-Smtp-Source: ABdhPJwyiohAnkTSVWvFz2fjJtzKV9LYcLZ3GV52XDL4aFrPz+e2wydR68PKqf2Ej3oNDYaJQ7CS/DaWi0CTFHQXqLw=
X-Received: by 2002:a92:874b:: with SMTP id d11mr233050ilm.137.1622739420855;
 Thu, 03 Jun 2021 09:57:00 -0700 (PDT)
MIME-Version: 1.0
References: <162199360248.3744214.17042613373014687643.stgit@locust>
 <CAOQ4uxioTzuo5B3kEKX_GY_aDyps1WXHH7OsOw6N0sNyf31+7w@mail.gmail.com> <20210603153406.GV26380@locust>
In-Reply-To: <20210603153406.GV26380@locust>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Thu, 3 Jun 2021 19:56:49 +0300
Message-ID: <CAOQ4uxiVSCjMfCv8+tK84jLV6d9torFo-16esk3+15PNn_+T3w@mail.gmail.com>
Subject: Re: [PATCHSET RFC 00/10] fstests: move test group lists into test files
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Eryu Guan <guaneryu@gmail.com>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        fstests <fstests@vger.kernel.org>, Eryu Guan <guan@eryu.me>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jun 3, 2021 at 6:34 PM Darrick J. Wong <djwong@kernel.org> wrote:
>
> On Thu, Jun 03, 2021 at 09:32:16AM +0300, Amir Goldstein wrote:
> > On Wed, May 26, 2021 at 5:50 AM Darrick J. Wong <djwong@kernel.org> wrote:
> > >
> > > Hi all,
> > >
> > > Test group files (e.g. tests/generic/group) are a pain to keep up.
> > > Every week I rebase on Eryu's latest upstream, and every week I have to
> > > slog through dozens of trivial merge conflicts because of the
> > > groupfiles.  Moving tests is annoying because we have to maintain all
> > > this code to move the group associations from one /group file to
> > > another.
> > >
> > > It doesn't need to be this way -- we could move each test's group
> > > information into the test itself, and automatically generate the group
> > > files as part of the make process.  This series does exactly that.
> > >
> >
> > This looks very nice :)
> >
> > I do have one concern.
> > If the auto-generated group files keep the same path as the existing
> > source controlled group files, checkout of pre/post this change is
> > going to be challenging for developers running make in the source
> > directory.
>
> <nod> A temporary pain until everyone rebases, but you're right, that's
> going to annoy people unnecessarily.
>
> Admittedly I left it as tests/*/group to avoid making any other changes.
> All three lines' worth in check. :P
>
> > Also .gitignore entries are needed for the auto-generated group files.
>
> Heh, oops.  Will fix.
>
> > I wonder if it wouldn't be easier for everyone if the auto-generated
> > groups had a different name.
>
> Probably.  We could blast fstests 25 years into the future and change
> the name to "hashtag" :P
>
> How about "group.map" ?
>

<shrug> that's the hardest part ;-)

I'm fine with group.map group.list group.autogen or whatnot.

I am used to typing the prefix of the group file path in shell commands,
but auto-complete should take care of any suffix.

Thanks,
Amir.
