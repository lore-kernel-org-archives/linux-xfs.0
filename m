Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wr1-f66.google.com ([209.85.221.66]:37340 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726319AbeKETep (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 5 Nov 2018 14:34:45 -0500
Received: by mail-wr1-f66.google.com with SMTP id o15-v6so5170751wrv.4
        for <linux-xfs@vger.kernel.org>; Mon, 05 Nov 2018 02:15:46 -0800 (PST)
MIME-Version: 1.0
References: <20181101110130.19489-1-jtulak@redhat.com> <20181102013618.GD19305@dastard>
 <CACj3i71FUf84iUCFKVhVPQVhjUOdb-_TDTsPVvrFe8hC_zLMeg@mail.gmail.com> <20181102223435.GE19305@dastard>
In-Reply-To: <20181102223435.GE19305@dastard>
From: Jan Tulak <jtulak@redhat.com>
Date: Mon, 5 Nov 2018 11:15:34 +0100
Message-ID: <CACj3i73fMu64uxrhrGTyP0k4a7Q4c1veUbJnviT7NddSzueLvQ@mail.gmail.com>
Subject: Re: [PATCH 0/2] xfsdump whitespace changes
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Chinner, Dave" <david@fromorbit.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>

On Fri, Nov 2, 2018 at 11:34 PM Dave Chinner <david@fromorbit.com> wrote:
>
> On Fri, Nov 02, 2018 at 12:43:18PM +0100, Jan Tulak wrote:
> > On Fri, Nov 2, 2018 at 2:36 AM Dave Chinner <david@fromorbit.com> wrote:
> > > On Thu, Nov 01, 2018 at 12:01:28PM +0100, Jan Tulak wrote:
> > > However, it's is the same change as what you originally posted to a
> >
> > Yes, it is the same thing, with changes where I found something
> > misaligned on top.
> >
> > > git tree, then it needs revision. basically, most of the change was
> > > converting vertically aligned function call parameters to use tabs,
> > > and that broke the vertical alignment.
> >
> > It is "s/    /\t/" limited to the beginning of the line.
>
> You mean 's/^    /\t/'?

Yes, but in multiple iterations to get \t, \t\t, \t\t\t, ...

[snip]

> > > I'd suggest that this is the least of the whitespace sins of
> > > xfsdump. yes, it's easy to script, but I don't think it's the right
> > > thing to do. The biggest problems I think we need to start with are:
> > >
> > > - reformat all the function definitions according to common XFS style
> > > - get rid of all the "( foo )" style white space aroudn parenthesis
> >
> > I already started working on it. It is too complex for awk/sed, so I'm
> > trying to find some better way through IDEs with autoformatting
> > capabilities.
>
> It should be relatively straight forward with sed. e.g. off the top
> of my head, stripping the space after "(" is this expression:
>
> $ echo "foo( bar" | sed -e 's/\([[:alnum:]](\) \([[:alnum:]]\)/\1\2/'
> foo(bar
> $

I tried something similar and the result was not ideal - it worked ok
for common cases, but not always.

>
> /me is slightly worried that he can now write non-trivial line noise
> in sed that does the right thing first go....
>
> Another option is coccinelle - it was specifically designed to do
> such semantic transformations to C code:

Thanks for the tip, I will look at it.

Cheers,
Jan

-- 
Jan Tulak
