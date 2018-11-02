Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wm1-f66.google.com ([209.85.128.66]:40091 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726318AbeKCCC7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 2 Nov 2018 22:02:59 -0400
Received: by mail-wm1-f66.google.com with SMTP id b203-v6so2450000wme.5
        for <linux-xfs@vger.kernel.org>; Fri, 02 Nov 2018 09:55:11 -0700 (PDT)
MIME-Version: 1.0
References: <20181101110130.19489-1-jtulak@redhat.com> <20181102013618.GD19305@dastard>
 <CACj3i71FUf84iUCFKVhVPQVhjUOdb-_TDTsPVvrFe8hC_zLMeg@mail.gmail.com>
In-Reply-To: <CACj3i71FUf84iUCFKVhVPQVhjUOdb-_TDTsPVvrFe8hC_zLMeg@mail.gmail.com>
From: Jan Tulak <jtulak@redhat.com>
Date: Fri, 2 Nov 2018 17:54:59 +0100
Message-ID: <CACj3i73OTSmFYgonAhazAWO3fhH4LRgg6Lu7BQtVmK2jfPnZ4g@mail.gmail.com>
Subject: Re: [PATCH 0/2] xfsdump whitespace changes
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Chinner, Dave" <david@fromorbit.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>

On Fri, Nov 2, 2018 at 12:43 PM Jan Tulak <jtulak@redhat.com> wrote:
>
> On Fri, Nov 2, 2018 at 2:36 AM Dave Chinner <david@fromorbit.com> wrote:
> >
> > On Thu, Nov 01, 2018 at 12:01:28PM +0100, Jan Tulak wrote:
> > > (I'm splitting the previous set into smaller ones, so changes doesn't
> > >  have to wait.)
> > >
> > > This set is dealing with whitespaces only, no functional change, code
> > > shuffling, etc. should be present. The first patch clears out trailing
> > > whitespaces, the second one sorts out the crazy mishmash of tabs and
> > > spaces.
> >
> > patch 2 Didn't come through - it'll be too large for the list.
>
> Ah, I see.
>
> >
> > However, it's is the same change as what you originally posted to a
>
> Yes, it is the same thing, with changes where I found something
> misaligned on top.
>
> > git tree, then it needs revision. basically, most of the change was
> > converting vertically aligned function call parameters to use tabs,
> > and that broke the vertical alignment.
>
> It is "s/    /\t/" limited to the beginning of the line. The function
> parameters were caught in it too, but I don't think they would make
> the most of the lines.
>
> >
> > I'd suggest that this is the least of the whitespace sins of
> > xfsdump. yes, it's easy to script, but I don't think it's the right
> > thing to do. The biggest problems I think we need to start with are:
> >
> > - reformat all the function definitions according to common XFS style
> > - get rid of all the "( foo )" style white space aroudn parenthesis
>
> I already started working on it. It is too complex for awk/sed, so I'm
> trying to find some better way through IDEs with autoformatting
> capabilities.
>
> > - convert all the code with 4 space indents to tabs, leaving
> >   vertically aligned function call parameters alone.
>
> Part of the issue is that xfsdump is not even consistently using the
> number of spaces. E.g. just a two random functions in
> invutil/stobj.c:335-486 in master, you find that both 2 and 4 spaces
> per indent level are used and even stuff like \t<space*4> inside of
> "if", without it being a function parameter.
>
> And the indentation of the parameters will change anyway, as we have
> parameters indented with tabs only, and with spaces only, and with
> some mix that makes no sense unless you configure your editor to show
> \t as an odd number of spaces except on the first Thursday of a month,
> but only on years that make a power of 2... Same as the rest of the
> code. :-) So I expect the resulting set to be roughly the same size as
> it is now. But I will break the patch by component, it should pass
> through then.
>
> Thanks,
> Jan
>

Update: I found a reasonably working code prettifier with kernel-style
config. The disadvantage is that I'm not really able to split the
patches by type of change (indentation, spaces inside of parentheses,
vertical align...) and it did it all at once, but hopefully that is
not a big issue. You can look at it here [1] - it is 2,4MB in size of
the patch files (only the formatting changes) and I want to check it a
bit better before sending it here as emails, whether there is no new
warning in gcc, etc. But it compiles and passes xfstests, so feel free
to peek at it - I will be back online in the Monday.

[1] https://github.com/jtulak/xfsdump/tree/for-review  (git clone
https://github.com/jtulak/xfsdump.git)

Thanks,
Jan

> >
> > This will be a much smaller set of cleanups than a blanket
> > space-to-tab script does...
> >
> > Cheers,
> >
> > Dave.
> > --
> > Dave Chinner
> > david@fromorbit.com



-- 
Jan Tulak
