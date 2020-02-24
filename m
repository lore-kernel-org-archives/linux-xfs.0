Return-Path: <SRS0=6RgE=4M=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA866C3567B
	for <linux-xfs@archiver.kernel.org>; Mon, 24 Feb 2020 06:38:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8B13420714
	for <linux-xfs@archiver.kernel.org>; Mon, 24 Feb 2020 06:38:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XofHD8Rt"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726997AbgBXGi0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 24 Feb 2020 01:38:26 -0500
Received: from mail-il1-f196.google.com ([209.85.166.196]:45014 "EHLO
        mail-il1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726452AbgBXGi0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Feb 2020 01:38:26 -0500
Received: by mail-il1-f196.google.com with SMTP id s85so6782293ill.11
        for <linux-xfs@vger.kernel.org>; Sun, 23 Feb 2020 22:38:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7vkxhUaprIHy4bDGwpPikvwxxfjso7Os/BdVK/0VYTg=;
        b=XofHD8RtwVSlhsmmFtIHOcJm5URa9OLJCdH5QodB6MK9JgmCOgg4cJ+QTrVrGcLwKS
         Z+RoyGYaXi6hjsTmgXnGl43PBiaKam03ZYV5g60dRhrinfKYXNP67WRsptf3sklM6I4K
         RhIYPprn6ZYHTtvT/V5Dg+6bzKQMhiHnYGyHDMhElzk1oR9kPli0Kzy8fbpgn3OTWMQF
         ALXWz2JOTCVe0ZyuKz+vvdJLRB6TJ+d/zRx9kY0J2ZmX9XEdGeTjkqD0RuLjylJ4B7yg
         vNMNcXnozw/wlrQgHyFCdu+1N3G+EiSWw50N+x1IMORmYhgwZKUCudUbRZSy+wtRCHxy
         qlgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7vkxhUaprIHy4bDGwpPikvwxxfjso7Os/BdVK/0VYTg=;
        b=FmaB3sNrEmUG0k1HNdT4HQVRL4ScCznUB3D69PED9jzjCcFxbvZyI+jA0jgtvBmyaZ
         /RENwsaDDEJncD1xfWKRX/hKvKheoimIzOZgbtltztzNP9NZKFVqzZNlhaWUS7n3YGtn
         6Heg2I6bswIvQ0BlYKOaAZJUiedw6ShHvga3z0yyS96IWQXxNwDw2Wqy1wqzqIZ6d7vE
         nEnL32rS+Z8us3W8mVc04HkSZWJTrwSEknqSEAwq/8thhEdIFtYcDHxtKsgmM/CN8V8i
         OUvkmEFBlXbRm+A2EDR3JSodzXeiEky/oXdHtmhUpUVpmqGZ9qkBtrd74c7Qa6jh+tNy
         w/Mw==
X-Gm-Message-State: APjAAAVzQKX+//bAPmaqwM6KrNx7zN4WP4fOeAq17mQ/Tn/w8VbtFE8c
        r77S2mvJo0CZDwi5OmENAm8UyFoSsDjDfvF0WQs=
X-Google-Smtp-Source: APXvYqwH/xS5O9TOdNcFCn5tciKqo40938DWC9Z9mgJ63lhIYdYj4qjG+4ZQkIjStKxSZneUvv0nUzvkrKMVElCjPSQ=
X-Received: by 2002:a92:5c8a:: with SMTP id d10mr59562557ilg.137.1582526304024;
 Sun, 23 Feb 2020 22:38:24 -0800 (PST)
MIME-Version: 1.0
References: <20200223020611.1802-1-allison.henderson@oracle.com>
 <20200223020611.1802-8-allison.henderson@oracle.com> <CAOQ4uxj_X+Sm6A838CVsDqL8zkYy63G++RFuew1dYmLsXhOpQg@mail.gmail.com>
 <2abd5db4-bf0e-7ed0-3777-700dbc2e379e@oracle.com>
In-Reply-To: <2abd5db4-bf0e-7ed0-3777-700dbc2e379e@oracle.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Mon, 24 Feb 2020 08:38:12 +0200
Message-ID: <CAOQ4uxihN98SNE9SfHHc7Ajcs5siA-RXOYB5fgLqic+8ZDpGAQ@mail.gmail.com>
Subject: Re: [PATCH v7 07/19] xfs: Factor out xfs_attr_leaf_addname helper
To:     Allison Collins <allison.henderson@oracle.com>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Feb 23, 2020 at 8:38 PM Allison Collins
<allison.henderson@oracle.com> wrote:
>
> On 2/23/20 5:42 AM, Amir Goldstein wrote:
> > On Sun, Feb 23, 2020 at 4:07 AM Allison Collins
> > <allison.henderson@oracle.com> wrote:
> >>
> >> Factor out new helper function xfs_attr_leaf_try_add.
> >
> > Right. This should be the subject.
> > Not factor out xfs_attr_leaf_addname helper.
> >
> >> Because new delayed attribute
> >> routines cannot roll transactions, we carve off the parts of xfs_attr_leaf_addname
> >> that we can use, and move the commit into the calling function.
> >
> > And that is a different change.
> > It is hard enough to review a pure factor out of a helper.
> > Adding changed inside a pure re-factor is not good.
> >
> > Belongs to another change - move transaction commit to caller.
>
> Yes, this came up in the last review, but the reason I avoid it is
> because I think the transaction looks weird in either helper.  The
> reason the roll is here is because there is no room to add the attr as a
> leaf, and so we need to hand it off to the node subroutines.  But that
> seems like something that should be managed by the caller, not leaf
> helpers.  So I was concerned that separating the split and the hoist
> would generate more weird looks from people trying to understand the
> split until the see the hoist in the next patch.  If people really think
> it looks better that way, I can split them up.  But I know folks have a
> tough enough time trying to recall the discussion history, so I'm trying
> to avoid confusion of another type :-)
>
> Thoughts?
>

It's fine, so long as you document it properly in commit message.
See, we are so bad in this review process, that we rely on humans
to verify that logic preserving re-factoring patches are indeed logic
preserving. This is so lame to begin with, because there are static
checker bots out there that would gladly do that work for us :) ...
if we only annotated the logic preserving patches as such.
In the mean while, while we are substituting the review robots,
the least a developer could do is not call out a patch "re-factoring"
and sneak in a logic change without due notice to reviewers.

Thanks,
Amir.
