Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED6ECC433E0
	for <linux-xfs@archiver.kernel.org>; Sun, 24 Jan 2021 13:34:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B6566227C3
	for <linux-xfs@archiver.kernel.org>; Sun, 24 Jan 2021 13:34:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726294AbhAXNeV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 24 Jan 2021 08:34:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725788AbhAXNeS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 24 Jan 2021 08:34:18 -0500
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EF1FC061573;
        Sun, 24 Jan 2021 05:33:38 -0800 (PST)
Received: by mail-pl1-x632.google.com with SMTP id e9so5974547plh.3;
        Sun, 24 Jan 2021 05:33:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=DhSkzzlJRhDgO5mxl9oCYYdwSsBsir3z/jCswg5X5n4=;
        b=CMlTgEp+YD4RvJqNPEMLVrxAjlAkk8VaAt6Oghxud6DjhCCXtXIY8FeldnwnZXJy/+
         MoK5EYOin03NlG8vv+WKI5Myg+E0ojMLiDiUjCDNDL0vHTr5WcN2ERHEzvTJ3IB4MMjh
         Y5opkIYwWzCoV2w1iykK1QGD5fOYgfYny4/UEOuggFF8abTLsLf5sjzXdVKpy3JT84lw
         h+ndIEUzqt/Z/V+s6AGooZusm4R0P/nWmJGSjQKfp6xpi6Wn3KTVDW9fhvDjQMQQSsm1
         NkPX8SDaESWYEaHShxibWVq1gzXD1Fnruu55FtGakYHMRkm7JWY4fIjzecCLYy1PMv+M
         jBbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=DhSkzzlJRhDgO5mxl9oCYYdwSsBsir3z/jCswg5X5n4=;
        b=LOibxJpyYpOvtPYHGXDspQvixfzj4VbzQKpar2CH9gPuicf/jFy9QHJ5bW9nX6dvJp
         CtXO1E6QtlOPeuZcxNT+p8R4m7arHTa/MTfmEx7XzM3yYf/2a10C9/HyHvZ0eEcGDTVr
         9DSTHr5VC4X+6/m0nqrYO3GglahBtOXjeThr5dqcTWqE1ftMeG9Noi7Lw4Gg3dHsTtKR
         +T3eSKuMyAQdxcWeceo/AHxEVs0RaldvEZG1ay46PzGGWdU2rrJ8YOVZQDCMws6abnxM
         4/t4ZTE+ESxWKrQYIfxliGvdfKy6OY+3CZmGB8BRW6bfstk2RechD5D5LiFXel250ZaO
         7CTQ==
X-Gm-Message-State: AOAM532olVEed/nk3TJkNVx8dJU5opKqN4IFqT5YyYBca3vMczYLP3Co
        fmw/QQ+9laLwUjhjKAvoZJP2arh0DnU=
X-Google-Smtp-Source: ABdhPJxAKM4mkLnlNSgiqZFmgQ+NxkJAABsnk++S2gWP3wBsKS1aiZ+9vWg/zVM1EAZP1tJ4ewEpCA==
X-Received: by 2002:a17:902:ed8c:b029:de:8484:809 with SMTP id e12-20020a170902ed8cb02900de84840809mr2295591plj.23.1611495217815;
        Sun, 24 Jan 2021 05:33:37 -0800 (PST)
Received: from localhost ([47.89.231.86])
        by smtp.gmail.com with ESMTPSA id o1sm13543718pgq.1.2021.01.24.05.33.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 24 Jan 2021 05:33:37 -0800 (PST)
Date:   Sun, 24 Jan 2021 21:33:15 +0800
From:   Eryu Guan <guaneryu@gmail.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Dave Chinner <david@fromorbit.com>, fstests@vger.kernel.org,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: test mkfs.xfs config files
Message-ID: <20210124133315.GA2350@desktop>
References: <20201027205450.2824888-1-david@fromorbit.com>
 <20201029212713.GF1061260@magnolia>
 <20210116014607.GE3134581@magnolia>
 <20210117231848.GB78965@dread.disaster.area>
 <20210118042704.GG3134581@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210118042704.GG3134581@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Jan 17, 2021 at 08:27:04PM -0800, Darrick J. Wong wrote:
> On Mon, Jan 18, 2021 at 10:18:48AM +1100, Dave Chinner wrote:
> > On Fri, Jan 15, 2021 at 05:46:07PM -0800, Darrick J. Wong wrote:
> > > On Thu, Oct 29, 2020 at 02:27:13PM -0700, Darrick J. Wong wrote:
> > > > On Wed, Oct 28, 2020 at 07:54:50AM +1100, Dave Chinner wrote:
> > > > > +echo End of line comment
> > > > > +test_mkfs_config << ENDL
> > > > > +[metadata]
> > > > > +crc = 0 ; This is an eol comment.
> > > > 
> > > > Hey, wait a minute, the manpage didn't say I could use semicolon
> > > > comments! :)
> > > > 
> > > > The libinih page https://github.com/benhoyt/inih says you can though.
> > > > 
> > > > Would you mind making a note of that in patch 5 above, please?
> > > 
> > > Ping?  The mkfs code has been merged upstream; we ought to land the
> > > functionality tests.
> > 
> > Nothing in this patch needs to change, AFAIA, because you were
> > referring to the xfsprogs mkfs patchset in your comment. So this
> > is really only waiting on review, right? Do I need to repost it?
> 
> Probably, as it's entirely possible that it's gotten lost in Eryu's mail
> stream.

You were right, it's lost in my 'to-review' queue.. Thanks for the
reminder!

I did some minor modifications to the patches, such as update supported
fs from 'generic' to 'xfs', and change truncate command to $XFS_IO_PROG
-c "truncate".

Thanks,
Eryu

> 
> --D
> 
> > -Dave.
> > -- 
> > Dave Chinner
> > david@fromorbit.com
