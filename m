Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wr1-f66.google.com ([209.85.221.66]:41092 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726319AbeKEThG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 5 Nov 2018 14:37:06 -0500
Received: by mail-wr1-f66.google.com with SMTP id x12-v6so8812908wrw.8
        for <linux-xfs@vger.kernel.org>; Mon, 05 Nov 2018 02:18:07 -0800 (PST)
MIME-Version: 1.0
References: <20181101110130.19489-1-jtulak@redhat.com> <20181102013618.GD19305@dastard>
 <CACj3i71FUf84iUCFKVhVPQVhjUOdb-_TDTsPVvrFe8hC_zLMeg@mail.gmail.com>
 <CACj3i73OTSmFYgonAhazAWO3fhH4LRgg6Lu7BQtVmK2jfPnZ4g@mail.gmail.com> <20181102225729.GF19305@dastard>
In-Reply-To: <20181102225729.GF19305@dastard>
From: Jan Tulak <jtulak@redhat.com>
Date: Mon, 5 Nov 2018 11:17:55 +0100
Message-ID: <CACj3i70K9sJMqtToJ8skVKWBopBiomSBA3ch9c_Azs6tPYfR4g@mail.gmail.com>
Subject: Re: [PATCH 0/2] xfsdump whitespace changes
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Chinner, Dave" <david@fromorbit.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>

On Fri, Nov 2, 2018 at 11:57 PM Dave Chinner <david@fromorbit.com> wrote:
>
> On Fri, Nov 02, 2018 at 05:54:59PM +0100, Jan Tulak wrote:
> >
> > Update: I found a reasonably working code prettifier with kernel-style
> > config. The disadvantage is that I'm not really able to split the
> > patches by type of change (indentation, spaces inside of parentheses,
> > vertical align...) and it did it all at once, but hopefully that is
> > not a big issue. You can look at it here [1] - it is 2,4MB in size of
> > the patch files (only the formatting changes) and I want to check it a
> > bit better before sending it here as emails, whether there is no new
> > warning in gcc, etc. But it compiles and passes xfstests, so feel free
> > to peek at it - I will be back online in the Monday.
> >
> > [1] https://github.com/jtulak/xfsdump/tree/for-review  (git clone
> > https://github.com/jtulak/xfsdump.git)
>
> IMO, it's largely unreviewable because not only does whitespace
> change, so does the way the code is laid out.
>
> e.g it removes {} around single line if/for/while, so that could
> introduce bugs if there are multi-expression macros that aren't
> correctly encapsulated (and there are!).

I didn't realize that possibility. Fixing...

>
> And that's really hard to see in amongst all the indenting changes,
> the whitespace removal, etc.  I'd much prefer "one type of
> change at a time" patches because they are much easier to review.

Yeah, I understand. Let's see what I can do... Anyway, thanks for the feedback.

Cheers,
Jan



-- 
Jan Tulak
