Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wr1-f67.google.com ([209.85.221.67]:46428 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726368AbeKEVp2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 5 Nov 2018 16:45:28 -0500
Received: by mail-wr1-f67.google.com with SMTP id 74-v6so9282397wrb.13
        for <linux-xfs@vger.kernel.org>; Mon, 05 Nov 2018 04:25:57 -0800 (PST)
MIME-Version: 1.0
References: <20181101110130.19489-1-jtulak@redhat.com> <20181102013618.GD19305@dastard>
 <CACj3i71FUf84iUCFKVhVPQVhjUOdb-_TDTsPVvrFe8hC_zLMeg@mail.gmail.com>
 <20181102223435.GE19305@dastard> <CACj3i73fMu64uxrhrGTyP0k4a7Q4c1veUbJnviT7NddSzueLvQ@mail.gmail.com>
 <20181105114831.GJ19305@dastard>
In-Reply-To: <20181105114831.GJ19305@dastard>
From: Jan Tulak <jtulak@redhat.com>
Date: Mon, 5 Nov 2018 13:25:45 +0100
Message-ID: <CACj3i73WO-GFdgKhyk6GBcQ2Ebfs+hiojY+O1+JfYyBTPAvjXQ@mail.gmail.com>
Subject: Re: [PATCH 0/2] xfsdump whitespace changes
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Chinner, Dave" <david@fromorbit.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>

On Mon, Nov 5, 2018 at 12:48 PM Dave Chinner <david@fromorbit.com> wrote:
>
> On Mon, Nov 05, 2018 at 11:15:34AM +0100, Jan Tulak wrote:
> > On Fri, Nov 2, 2018 at 11:34 PM Dave Chinner <david@fromorbit.com> wrote:
> > >
> > > On Fri, Nov 02, 2018 at 12:43:18PM +0100, Jan Tulak wrote:
> > > > On Fri, Nov 2, 2018 at 2:36 AM Dave Chinner <david@fromorbit.com> wrote:
> > > > > On Thu, Nov 01, 2018 at 12:01:28PM +0100, Jan Tulak wrote:
> > > > > However, it's is the same change as what you originally posted to a
> > > >
> > > > Yes, it is the same thing, with changes where I found something
> > > > misaligned on top.
> > > >
> > > > > git tree, then it needs revision. basically, most of the change was
> > > > > converting vertically aligned function call parameters to use tabs,
> > > > > and that broke the vertical alignment.
> > > >
> > > > It is "s/    /\t/" limited to the beginning of the line.
> > >
> > > You mean 's/^    /\t/'?
> >
> > Yes, but in multiple iterations to get \t, \t\t, \t\t\t, ...
>
> Which is handled by this regex: 's/^\(\t*\)*    /\1\t/'
>
> In this case, I'm using "*", which means "match zero or more of the
> preceding expression" - which in this case is \t. That regex is
> enclosed in \(...\) to group the result, which is then back
> referenced in the output expression by \1 (first group backref).
>
> Regexes are extremely and flexible once you've learnt how the
> multiple object matching rules work.

I know. But I don't see how your regex would take the number of
four-space groups and inserted the same number of \t, which is what I
was trying to do and AFAIK there is no way to do it with sed. I know
it could be done with awk, but writing it would take more time for me
than re-running s/^        /\t\t/ with a manually changed number of
occurrences, from one to say 5 levels (or until I stop getting any
changes).

Cheers,
Jan
