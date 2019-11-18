Return-Path: <SRS0=mMHn=ZK=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C06CDC432C0
	for <linux-xfs@archiver.kernel.org>; Mon, 18 Nov 2019 04:52:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8D31B20720
	for <linux-xfs@archiver.kernel.org>; Mon, 18 Nov 2019 04:52:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nN3uIp7L"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726328AbfKREwv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 17 Nov 2019 23:52:51 -0500
Received: from mail-yw1-f68.google.com ([209.85.161.68]:35638 "EHLO
        mail-yw1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726314AbfKREwv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 17 Nov 2019 23:52:51 -0500
Received: by mail-yw1-f68.google.com with SMTP id r131so5441833ywh.2
        for <linux-xfs@vger.kernel.org>; Sun, 17 Nov 2019 20:52:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=oGhKAAq6QQAGBujD6voRlCjsUR4IHz5A1m8bu+79/oA=;
        b=nN3uIp7LJcoll5rlp8Q5BqEDtL7nfnTqvwU5lA30D+YGiLAHhBj5l6sPtQMCZFulLf
         bx2JYdzrN1w4zHw6JPWHKE53HJYbBRC42Dmvk9T6Go+dJec/8FqzVnvAMJ6sv2oWXn1N
         uTeSer0ZZdV8kuuq4WBnDPbJEk8JkQjRAFkZvgDaF0HQeKXs7u4TZenhkhC5pS98CmuV
         1rv5WhIZ4g4/H80QNNRFwVLKWDcdsnHvSgKhPSRercuKFGt2d+BYn1ga750zG5VxQZO/
         oPRdbZgsXphwpGtOEf+ItZHstTQOSmV/nWDqAqPkku28iEgWYmcaU+vooVc2qFwmUesM
         lfKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=oGhKAAq6QQAGBujD6voRlCjsUR4IHz5A1m8bu+79/oA=;
        b=SJ+1mxOiFDofcVsT1MxaiVkFWi6JZje3xo/9TpK7FimDfPjZAEDWpsS+5VSqWypPOR
         fQlzIX5zN0SloSdlK9mgXSjwpEa4/A4lS+ODEjxMc7J6+OMxbLxqT+n4g8URr1WPf08i
         Ojm+8mnGWhBefI3xTDtO3g3D856cqGPWfWrJQAouuy5ItoJXjh0YzGRbD0T7Ittp0jCA
         JwpPC/1JSKg1ahwBAiayhiOQY5Ze/vIHPwwWVqTtUl0HprfB3er35XT6d3pAgwPnPA+p
         KdGSajczwpX3mDlYUQuynV+f6H3g/qok3ufH7FSEfsu8dhHGkVaCJSESweqsgj4UQIcE
         StAA==
X-Gm-Message-State: APjAAAUQeQqsribQMW5H2a7Wfvx2/iTk2XGH9mm5e9UDhYa3PUXkkYYJ
        nrDpZNIj6/5+h/KEm7KtaGHpW4XuAEk+pj47+jI=
X-Google-Smtp-Source: APXvYqwaXosTOZyshbwQzTtuDUGhCkMaOm6lhL7eqB5w2PHDueZsz1LhsfVbV1OTVO8oAJsEKB5fCsRVAjhEMjHWsLs=
X-Received: by 2002:a81:1cd5:: with SMTP id c204mr18114934ywc.379.1574052770617;
 Sun, 17 Nov 2019 20:52:50 -0800 (PST)
MIME-Version: 1.0
References: <20191111213630.14680-1-amir73il@gmail.com> <20191111223508.GS6219@magnolia>
 <CAOQ4uxgC8Gz+uyCaV_Prw=uUVNtwv0j7US8sbkfoTphC4Z6b6A@mail.gmail.com>
 <20191112211153.GO4614@dread.disaster.area> <20191113035611.GE6219@magnolia>
 <CAOQ4uxi9vzR4c3T0B4N=bM6DxCwj_TbqiOxyOQLrurknnyw+oA@mail.gmail.com>
 <20191113045840.GR6219@magnolia> <CAOQ4uxh0T-cddZ9gwPcY6O=Eg=2g855jYbjic=VwihYPz2ZeBw@mail.gmail.com>
 <20191113052032.GU6219@magnolia>
In-Reply-To: <20191113052032.GU6219@magnolia>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Mon, 18 Nov 2019 06:52:39 +0200
Message-ID: <CAOQ4uxiTRWkeM6i6tyMe5dzSN8nsR=1XZEMEwwwVJAcJNVimGA@mail.gmail.com>
Subject: Re: [RFC][PATCH] xfs: extended timestamp range
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Dave Chinner <david@fromorbit.com>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Deepa Dinamani <deepa.kernel@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

> >
> > I wonder if your version has struct xfs_dinode_v3 or it could avoid it.
> > There is a benefit in terms of code complexity and test coverage
> > to keep the only difference between inode versions in the on-disk
> > parsers, while reading into the same struct, the same way as
> > old inode versions are read into struct xfs_dinode.
> >
> > Oh well, I can wait for tomorrow to see the polished version :-)
>
> Well now we noticed that Arnd also changed the disk quota structure
> format too, so that'll slow things down as we try to figure out how to
> reconcile 34-bit inode seconds vs. 40-bit quota timer seconds.
>
> (Or whatever happens with that)
>

Sigh. FWIW, I liked Arnd's 40-bit inode time patch because it
keeps the patch LoC for this conversion minimal.
I am *not* promoting backward compat migration, but using the
most of existing on-disk/in-core parser code and only adding
parsing of new fields in inode format v4 reduces code complexity
and improves test coverage.

Please let me know if there is anything I can do to help pushing
things forward.

Thanks,
Amir.
