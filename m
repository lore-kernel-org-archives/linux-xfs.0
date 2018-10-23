Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wr1-f52.google.com ([209.85.221.52]:35549 "EHLO
        mail-wr1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726277AbeJWVjW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 23 Oct 2018 17:39:22 -0400
Received: by mail-wr1-f52.google.com with SMTP id w5-v6so1679407wrt.2
        for <linux-xfs@vger.kernel.org>; Tue, 23 Oct 2018 06:15:56 -0700 (PDT)
MIME-Version: 1.0
References: <CACj3i73FyABTkX1eCDvL+ccUhD1kWowS92=PFVyGiPvi6HWGFQ@mail.gmail.com>
 <20181022174316.GA28561@infradead.org> <90559dfb-5222-4faf-a9bb-a314cc645129@sandeen.net>
 <83eb725e-800d-b597-29d9-52d8a672c82c@sandeen.net> <CACj3i72hTgnkiM7Z99UVYYNJZaTQ2BM8hFYURDhxXbSX7enWgQ@mail.gmail.com>
 <392a4c28-9800-fe40-73b9-632370093d50@sandeen.net>
In-Reply-To: <392a4c28-9800-fe40-73b9-632370093d50@sandeen.net>
From: Jan Tulak <jtulak@redhat.com>
Date: Tue, 23 Oct 2018 15:15:44 +0200
Message-ID: <CACj3i71nxp+ktvCm31Gb3k4A8nYVaLHO1WxwruhbDjmwwyz1Jw@mail.gmail.com>
Subject: Re: xfsdump cleaning patchset
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Christoph Hellwig <hch@infradead.org>, linux-xfs <linux-xfs@vger.kernel.org>

On Tue, Oct 23, 2018 at 2:10 PM Eric Sandeen <sandeen@sandeen.net> wrote:
>
>
>
> On 10/23/18 3:16 AM, Jan Tulak wrote:
> >> I'm not a huge fan of "fix buffer overflows by making them arbitrarily
> >> bigger" - can we use i.e. snprintf to make sure it won't happen again,
> >> and maybe size them based on ... something, instead of "eh, [5000] is
> >> hopefully enough?"
> > I based the new size on gcc outputs, it said how much it can overflow.
> > But I checked the numbers only once or twice and didn't verify it for
> > other reports.
>
> It's always possible that I'm wrong and I'm missing something.  :)
> What did gcc say for the cases I pointed out?

For the txt[256] -> 300:

stobj.c: In function ‘stobjstrm_highlight’:
stobj.c:227:55: warning: ‘%s’ directive output may be truncated
writing up to 255 bytes into a regi
on of size between 230 and 231 [-Wformat-truncation=]
  snprintf(txt, sizeof(txt), "interrupted: %s, cmdarg: %s",
                                                       ^~
stobj.c:227:2: note: ‘snprintf’ output between 26 and 282 bytes into a
destination of size 256
  snprintf(txt, sizeof(txt), "interrupted: %s, cmdarg: %s",
  ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   (stobjstrm->st_interrupted == BOOL_TRUE) ? "yes" : "no",
   ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   stobjstrm->st_cmdarg);
   ~~~~~~~~~~~~~~~~~~~~~

So, I took the 282, added something, and rounded it to a number that
felt good and wasn't much larger than that.

Thanks,
Jan

-- 
Jan Tulak
