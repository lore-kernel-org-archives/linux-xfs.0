Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wr1-f67.google.com ([209.85.221.67]:33665 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728169AbeKQBcA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 16 Nov 2018 20:32:00 -0500
Received: by mail-wr1-f67.google.com with SMTP id u9-v6so25261383wrr.0
        for <linux-xfs@vger.kernel.org>; Fri, 16 Nov 2018 07:19:12 -0800 (PST)
MIME-Version: 1.0
References: <20181109143004.24963-1-jtulak@redhat.com> <9a951869-5852-2689-a6ef-084c770f16fb@sandeen.net>
 <CACj3i70u6hS2RgSRwHMqLZtKexdEz6GnSH10tyYF6DiHXimnug@mail.gmail.com> <c242400e-bd0b-404a-ec49-226fde9a23db@sandeen.net>
In-Reply-To: <c242400e-bd0b-404a-ec49-226fde9a23db@sandeen.net>
From: Jan Tulak <jtulak@redhat.com>
Date: Fri, 16 Nov 2018 16:19:00 +0100
Message-ID: <CACj3i72_TEELRcRuLCFvxOc0trhpKjztn3AwBUmmbTX-K-eorQ@mail.gmail.com>
Subject: Re: [PATCH 00/24] xfsdump: code style change
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: linux-xfs <linux-xfs@vger.kernel.org>

On Thu, Nov 15, 2018 at 5:12 PM Eric Sandeen <sandeen@sandeen.net> wrote:
>
> On 11/15/18 6:40 AM, Jan Tulak wrote:
> > On Wed, Nov 14, 2018 at 9:36 PM Eric Sandeen <sandeen@sandeen.net> wrote:

...

> >> 3) This creates /many/ more > 80 char lines.  Per:
> >>
> >> # for F in */*.[ch]; do expand $F | grep '.\{81\}'; done
> >>
> >> the codebase goes from 794 such lines to 1806.  IOWs, some of the "missing"
> >> whitespace may have been intentional, to stay under 80 cols.  New lines
> >> vs. compressed lines is a judgement call, I guess.  Bleah.
> >>
> >> So... sorry about that, but if the goal is to format better, let's be
> >> sure to keep observing other basic rules like "< 80 cols"
> >
> > Yeah. I'm not sure there is an easy way to automate that...
>
> Well, I think that's kind of the point here.  Do your automated replacement,
> but then manually inspect the result - you can look for 80col problems with
> the example above.  Then manually fix up as needed.  Then proceed to the next
> patch.
>
> Reviewers will need to look at the changes closely nyway, so you may as well
> do it before submission.  ;)
>

It's about all the rebase conflicts that arises after any change in
previous patches. If it was a thing I write once, then so be it. But
if I have to rewrite it again after any change in one of the previous
patches, well, that doesn't scale. :-) But I hope I can solve this
somehow.

Thanks,
Jan


-- 
Jan Tulak
