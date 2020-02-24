Return-Path: <SRS0=6RgE=4M=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51BD5C3567B
	for <linux-xfs@archiver.kernel.org>; Mon, 24 Feb 2020 07:27:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2427420578
	for <linux-xfs@archiver.kernel.org>; Mon, 24 Feb 2020 07:27:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OMYl9C4m"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726628AbgBXH1M (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 24 Feb 2020 02:27:12 -0500
Received: from mail-il1-f193.google.com ([209.85.166.193]:40607 "EHLO
        mail-il1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726216AbgBXH1M (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Feb 2020 02:27:12 -0500
Received: by mail-il1-f193.google.com with SMTP id i7so6880812ilr.7
        for <linux-xfs@vger.kernel.org>; Sun, 23 Feb 2020 23:27:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=obCpQ6XZdQwr84gdqSWP440r94XMDfn/MSGqGVq1rxY=;
        b=OMYl9C4m24zKvctCg1QYiwoXf6MF4LRlykAm52cq5Lutb3eHx9TjH479d5ZlmysUZp
         7T8TQguIz5d5e67vLHZHggG3Vos/5CPQbfcdyuZcD5jJHr48SPC7P+6bb48UJ0lbzY8r
         gEOvow8mqaX7I6Ss5sdtf/FkZ9X59ApwQ31jy0ygEgRC+GUNFAsaWX+8D9HXKd3/taDz
         ctk5Nj+hGhVkDTVqtwL9bpGlah/JocxD8FACzLUjp6UwfjYaPAK3o8oahlV4GHmBaqTZ
         OyHLigWNWPRb6VQSIoUEeGpB2sJWHEYhou1Wr5JujrjmtX+J792oYTcGLBBP+Oy35RFd
         k50Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=obCpQ6XZdQwr84gdqSWP440r94XMDfn/MSGqGVq1rxY=;
        b=D9Tc4+vFif8BnoNrJhfuISPnzMIgcsT3Uf2WQFWyjL4YoRbJKQP+/55mTi7PaArBd5
         qnwIREbwuq3wdtz5hWeM3hQOPWUSbQ6FBpBSeHjirQOfSCKiDcxhPSGokp55sa+K5JNo
         DgxZAGGVCtv74HaNrowJXYRrjFglWmQpXfzpf3Mo6csee+r3BD4XRv4Q8otY3vWN4HFT
         OfnWrtZ/H/4PkhPVo34QxZ2IM+FBUyiMZJbMssHHCtu4rf8N109WHI8bZYz+HYV/wwJI
         g2O8kWGZrMrS2nqnWGtIZzTdimUAxdYWxlgvRpb0njAyqwmKjkWOUt01ljcYJxdNSbtK
         GkLg==
X-Gm-Message-State: APjAAAW3wAYYQPHgmKGNJH9EEn5tWcGmQ/TWS6lH3ZZR9ki5492GP4p0
        +dUdnS7WZRISz61BM1tTX6mW3KsGqpPy+qvuIghpVA==
X-Google-Smtp-Source: APXvYqxcUUWulUOGsot2XKnL8vBqi4nBsw21mBB3txaClCZ/Hr1sJgOzZRkfkbcZyX4XIVjDp49t+tHNLVbI14MtpXQ=
X-Received: by 2002:a92:d5c3:: with SMTP id d3mr55482568ilq.250.1582529231822;
 Sun, 23 Feb 2020 23:27:11 -0800 (PST)
MIME-Version: 1.0
References: <20200223020611.1802-1-allison.henderson@oracle.com>
 <20200223020611.1802-8-allison.henderson@oracle.com> <CAOQ4uxj_X+Sm6A838CVsDqL8zkYy63G++RFuew1dYmLsXhOpQg@mail.gmail.com>
 <2abd5db4-bf0e-7ed0-3777-700dbc2e379e@oracle.com> <CAOQ4uxihN98SNE9SfHHc7Ajcs5siA-RXOYB5fgLqic+8ZDpGAQ@mail.gmail.com>
 <0c916507-fd00-c767-62d9-305d6b22e252@oracle.com>
In-Reply-To: <0c916507-fd00-c767-62d9-305d6b22e252@oracle.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Mon, 24 Feb 2020 09:27:00 +0200
Message-ID: <CAOQ4uxi6=10T3AWSfvKj2q3zznD9VGhnaXrey-GGKU4i_OYFbw@mail.gmail.com>
Subject: Re: [PATCH v7 07/19] xfs: Factor out xfs_attr_leaf_addname helper
To:     Allison Collins <allison.henderson@oracle.com>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Feb 24, 2020 at 9:09 AM Allison Collins
<allison.henderson@oracle.com> wrote:
>
>
>
> On 2/23/20 11:38 PM, Amir Goldstein wrote:
> > On Sun, Feb 23, 2020 at 8:38 PM Allison Collins
> > <allison.henderson@oracle.com> wrote:
> >>
> >> On 2/23/20 5:42 AM, Amir Goldstein wrote:
> >>> On Sun, Feb 23, 2020 at 4:07 AM Allison Collins
> >>> <allison.henderson@oracle.com> wrote:
> >>>>
> >>>> Factor out new helper function xfs_attr_leaf_try_add.
> >>>
> >>> Right. This should be the subject.
> >>> Not factor out xfs_attr_leaf_addname helper.
> >>>
> >>>> Because new delayed attribute
> >>>> routines cannot roll transactions, we carve off the parts of xfs_attr_leaf_addname
> >>>> that we can use, and move the commit into the calling function.
> >>>
> >>> And that is a different change.
> >>> It is hard enough to review a pure factor out of a helper.
> >>> Adding changed inside a pure re-factor is not good.
> >>>
> >>> Belongs to another change - move transaction commit to caller.
> >>
> >> Yes, this came up in the last review, but the reason I avoid it is
> >> because I think the transaction looks weird in either helper.  The
> >> reason the roll is here is because there is no room to add the attr as a
> >> leaf, and so we need to hand it off to the node subroutines.  But that
> >> seems like something that should be managed by the caller, not leaf
> >> helpers.  So I was concerned that separating the split and the hoist
> >> would generate more weird looks from people trying to understand the
> >> split until the see the hoist in the next patch.  If people really think
> >> it looks better that way, I can split them up.  But I know folks have a
> >> tough enough time trying to recall the discussion history, so I'm trying
> >> to avoid confusion of another type :-)
> >>
> >> Thoughts?
> >>
> >
> > It's fine, so long as you document it properly in commit message.
> > See, we are so bad in this review process, that we rely on humans
> > to verify that logic preserving re-factoring patches are indeed logic
> > preserving. This is so lame to begin with, because there are static
> > checker bots out there that would gladly do that work for us :) ...
> I didnt know there were tools out there that did that.  They sound
> helpful though!
>
> > if we only annotated the logic preserving patches as such.
> > In the mean while, while we are substituting the review robots,
> > the least a developer could do is not call out a patch "re-factoring"
> > and sneak in a logic change without due notice to reviewers.
> Ok, what if the title were to say something like:
> xfs: Split out node handling from xfs_attr_leaf_addname
>
> Or maybe just "Split apart xfs_attr_leaf_addname"?  Does that sound like
> it would be a better description here?
>

Sure, both are fine.
All I'm saying is that "factor out" is a well established keyword
that shouldn't be abused.

Thanks,
Amir.
