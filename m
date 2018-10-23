Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wr1-f44.google.com ([209.85.221.44]:42806 "EHLO
        mail-wr1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727210AbeJWQi4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 23 Oct 2018 12:38:56 -0400
Received: by mail-wr1-f44.google.com with SMTP id a9so595943wrx.9
        for <linux-xfs@vger.kernel.org>; Tue, 23 Oct 2018 01:16:37 -0700 (PDT)
MIME-Version: 1.0
References: <CACj3i73FyABTkX1eCDvL+ccUhD1kWowS92=PFVyGiPvi6HWGFQ@mail.gmail.com>
 <20181022174316.GA28561@infradead.org> <90559dfb-5222-4faf-a9bb-a314cc645129@sandeen.net>
 <83eb725e-800d-b597-29d9-52d8a672c82c@sandeen.net>
In-Reply-To: <83eb725e-800d-b597-29d9-52d8a672c82c@sandeen.net>
From: Jan Tulak <jtulak@redhat.com>
Date: Tue, 23 Oct 2018 10:16:25 +0200
Message-ID: <CACj3i72hTgnkiM7Z99UVYYNJZaTQ2BM8hFYURDhxXbSX7enWgQ@mail.gmail.com>
Subject: Re: xfsdump cleaning patchset
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Christoph Hellwig <hch@infradead.org>, linux-xfs <linux-xfs@vger.kernel.org>

On Mon, Oct 22, 2018 at 9:25 PM Eric Sandeen <sandeen@sandeen.net> wrote:
>
> First, what testing was done on the patchset?

Except for xfstests, I tried some combinations of arguments by hand,
but not all possible ones.

>
> For Coverity issues, please use:
>
> Addresses-Coverity-ID: XYZ
>
> or even i.e.
>
> Addresses-Coverity-ID: XYZ ("Missing break in switch")

OK

[snip]

>
> I'd also kind of hoped to do more whitespace/style fixup before
> making code changes but that'll make your later patches impossible
> to apply, so maybe we'll just leave it for now.

Yeah, I realized that too, but it was already too late.

>
>
> I'm not a huge fan of "fix buffer overflows by making them arbitrarily
> bigger" - can we use i.e. snprintf to make sure it won't happen again,
> and maybe size them based on ... something, instead of "eh, [5000] is
> hopefully enough?"

I based the new size on gcc outputs, it said how much it can overflow.
But I checked the numbers only once or twice and didn't verify it for
other reports.

[snip]

>
>
> From spot-checking a few commits, please take another careful pass
> through to look at context and code history to be sure that you're
> really fixing the code properly and not just making coverity and/or
> gcc be quiet; for example in
>
> 0ab032a8 common/drive_minrmt.c: remove a dead code (CID 1056289)
>
> you saw that coverity spotted dead code and so you removed it, but it
> shouldn't be dead, it should be somewhere else, I think - look up about
> 30 lines from your change for a hint.  :)
>

I see...

>
> For some of the resource leak fixes, you might consider using something
> like "goto out_free;" rather than adding cleanup repeatedly at multiple
> return points.  Sometimes that's cleaner.

OK, I will consider that.


>
>
> TBH each of these is going to take careful review, nobody really
> knows how xfsdump works anymore so we'll have to be very careful that
> nothing breaks.
>
> Anyway, give it another check through, make sure you understand the
> code you're changing to be sure you aren't just taking the fast path
> to making coverity shut up, reformat the changelogs as above, be ready
> to tell us what fairly comprehensive testing you did on the result, and we
> can take a pass at review on the list.
>
>

Sure. Well, back to the drawing board. :-)


Thanks,
Jan


-- 
Jan Tulak
