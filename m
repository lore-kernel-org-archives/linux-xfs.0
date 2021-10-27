Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E737EC4332F
	for <linux-xfs@archiver.kernel.org>; Wed, 27 Oct 2021 23:37:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D166660232
	for <linux-xfs@archiver.kernel.org>; Wed, 27 Oct 2021 23:37:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229519AbhJ0Xjj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 27 Oct 2021 19:39:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229521AbhJ0Xjj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 27 Oct 2021 19:39:39 -0400
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5694CC0613B9
        for <linux-xfs@vger.kernel.org>; Wed, 27 Oct 2021 16:37:13 -0700 (PDT)
Received: by mail-pg1-x52e.google.com with SMTP id e65so4534598pgc.5
        for <linux-xfs@vger.kernel.org>; Wed, 27 Oct 2021 16:37:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WMTMh4JidQFbMhcZT2VkZGNAi1C8CcA8jtm6BrftSss=;
        b=6OnySiysF1hhuv+2jxJ9FfAfSmA8y9LXelAKat7WynBZQg+6PZ/Y6CL3zM18cMG3JD
         GEnUquiuE3quJvpTuotuNPBGhT162UmD7avG0jDOAcziSvLYUVDywCngB4p3fQ58ZM0M
         zEqOMtq2uc82z3Hyo8SHcJ4wrgy4SICUQMJg3EUzEQ97cTDTxpAJL+ZjXMrC9Pd6Yd4I
         Hv+o6S8B5+bjhFZmSyXmvoK3vkD+a/tR7V2R1bzY3az6V1C7tt1S3O/yFi5MScIMNOJo
         whD2gxewZ5pTPcAORmeXbNAMaeToO/lIBwIX5Bv5eefUsLjTlEzVx3onl1Zq5iL+vzm0
         cGOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WMTMh4JidQFbMhcZT2VkZGNAi1C8CcA8jtm6BrftSss=;
        b=ElimtMrHMsZ/5ri3N98W8iQEUSW2gcQvP6nzCKEy7Sf+WiNAPAldxKd/RQ4+UlfYYG
         3+lRB9qwKV21kMvFnIkdlZHPwxirOfDPjjydfLc3WcZOH1drsgN1e+9Xdxr0w2U6zZ9C
         cpw7S0hCxKHJNcmFDoZvr2ldIs3P9fNKr1ncvkq9F5d5bnWH36WpeuC6U96ODcTRBhT7
         aC6ap4F8ALX/ufLwNoq442ka7oR2AFe475Zo0Rl2RrwV9CFdpoymJx3eYNh/qC8BrUi8
         Z2xp+BcU0VSs85cquiK63gDgIKZ1w6m6gdF4rBkvL0poXd5xPuwsCqF5REsJG8robD1b
         is9g==
X-Gm-Message-State: AOAM5324cyzUgXkNYOb+bbDIpqTuhXc88fnGmB+0BMFT5zeS+I0bhcW2
        6xbBqgcniOqcos+6Cu6BMljhJCW7GVOyngRA9qek46iF/NA=
X-Google-Smtp-Source: ABdhPJxcsU50q4uGsTOaoj9w67NPN0ee0O0WC5tw2bEynUFc2bhlW22w0QMQKH9wvcSAfLnnolzJDk1LCiKsNt9RVYY=
X-Received: by 2002:a63:1e0e:: with SMTP id e14mr608862pge.5.1635377832818;
 Wed, 27 Oct 2021 16:37:12 -0700 (PDT)
MIME-Version: 1.0
References: <20211018044054.1779424-1-hch@lst.de> <20211018044054.1779424-7-hch@lst.de>
 <20211018164351.GT24307@magnolia> <20211019072326.GA23171@lst.de>
In-Reply-To: <20211019072326.GA23171@lst.de>
From:   Dan Williams <dan.j.williams@intel.com>
Date:   Wed, 27 Oct 2021 16:37:01 -0700
Message-ID: <CAPcyv4hbLur8rN40zaqmBw7VH37FoPAzvj-U_NT7Lk2-v5JhSQ@mail.gmail.com>
Subject: Re: [PATCH 06/11] xfs: factor out a xfs_setup_dax helper
To:     Christoph Hellwig <hch@lst.de>
Cc:     "Darrick J. Wong" <djwong@kernel.org>,
        Mike Snitzer <snitzer@redhat.com>,
        Ira Weiny <ira.weiny@intel.com>,
        device-mapper development <dm-devel@redhat.com>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        Linux NVDIMM <nvdimm@lists.linux.dev>,
        linux-s390 <linux-s390@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-erofs@lists.ozlabs.org,
        linux-ext4 <linux-ext4@vger.kernel.org>,
        virtualization@lists.linux-foundation.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Oct 19, 2021 at 12:24 AM Christoph Hellwig <hch@lst.de> wrote:
>
> On Mon, Oct 18, 2021 at 09:43:51AM -0700, Darrick J. Wong wrote:
> > > --- a/fs/xfs/xfs_super.c
> > > +++ b/fs/xfs/xfs_super.c
> > > @@ -339,6 +339,32 @@ xfs_buftarg_is_dax(
> > >                     bdev_nr_sectors(bt->bt_bdev));
> > >  }
> > >
> > > +static int
> > > +xfs_setup_dax(
> >
> > /me wonders if this should be named xfs_setup_dax_always, since this
> > doesn't handle the dax=inode mode?
>
> Sure, why not.

I went ahead and made that change locally.

>
> > The only reason I bring that up is that Eric reminded me a while ago
> > that we don't actually print any kind of EXPERIMENTAL warning for the
> > auto-detection behavior.
>
> Yes, I actually noticed that as well when preparing this series.

The rest looks good to me.
