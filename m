Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wr1-f42.google.com ([209.85.221.42]:42154 "EHLO
        mail-wr1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726277AbeJWW3v (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 23 Oct 2018 18:29:51 -0400
Received: by mail-wr1-f42.google.com with SMTP id a9so1865818wrx.9
        for <linux-xfs@vger.kernel.org>; Tue, 23 Oct 2018 07:06:15 -0700 (PDT)
MIME-Version: 1.0
References: <CACj3i73FyABTkX1eCDvL+ccUhD1kWowS92=PFVyGiPvi6HWGFQ@mail.gmail.com>
 <20181022174316.GA28561@infradead.org> <90559dfb-5222-4faf-a9bb-a314cc645129@sandeen.net>
 <83eb725e-800d-b597-29d9-52d8a672c82c@sandeen.net> <CACj3i72hTgnkiM7Z99UVYYNJZaTQ2BM8hFYURDhxXbSX7enWgQ@mail.gmail.com>
 <392a4c28-9800-fe40-73b9-632370093d50@sandeen.net> <CACj3i71nxp+ktvCm31Gb3k4A8nYVaLHO1WxwruhbDjmwwyz1Jw@mail.gmail.com>
 <e14292f4-8a49-fdb1-cffd-1c2ddc97dd35@sandeen.net>
In-Reply-To: <e14292f4-8a49-fdb1-cffd-1c2ddc97dd35@sandeen.net>
From: Jan Tulak <jtulak@redhat.com>
Date: Tue, 23 Oct 2018 16:06:02 +0200
Message-ID: <CACj3i720J7vpENKOBAEBWMy4Frpy+FPdfC+ggyMnzwU62yUa9g@mail.gmail.com>
Subject: Re: xfsdump cleaning patchset
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Christoph Hellwig <hch@infradead.org>, linux-xfs <linux-xfs@vger.kernel.org>

On Tue, Oct 23, 2018 at 3:43 PM Eric Sandeen <sandeen@sandeen.net> wrote:
>
> On 10/23/18 8:15 AM, Jan Tulak wrote:
> > On Tue, Oct 23, 2018 at 2:10 PM Eric Sandeen <sandeen@sandeen.net> wrote:

> >> It's always possible that I'm wrong and I'm missing something.  :)
> >> What did gcc say for the cases I pointed out?
> >
> > For the txt[256] -> 300:
> >
> > stobj.c: In function ‘stobjstrm_highlight’:
> > stobj.c:227:55: warning: ‘%s’ directive output may be truncated
> > writing up to 255 bytes into a region of size between 230 and 231 [-Wformat-truncation=]
> >   snprintf(txt, sizeof(txt), "interrupted: %s, cmdarg: %s",
> >                                                        ^~
> > stobj.c:227:2: note: ‘snprintf’ output between 26 and 282 bytes into a
> > destination of size 256
> >   snprintf(txt, sizeof(txt), "interrupted: %s, cmdarg: %s",
> >   ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> >    (stobjstrm->st_interrupted == BOOL_TRUE) ? "yes" : "no",
> >    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> >    stobjstrm->st_cmdarg);
> >    ~~~~~~~~~~~~~~~~~~~~~
> >
> > So, I took the 282, added something, and rounded it to a number that
> > felt good and wasn't much larger than that.
>
> Ok, I don't think that's one of the ones I commented on ;)

You mentioned multiple cases, so I picked the first one I found. :-)
If you ask for the 1024 -> 5000 bytes buffer, then it is probably this one:

invidx.c:253:37: warning: ‘%s’ directive output may be truncated
writing up to 4095 bytes into a r$
gion of size 1020 [-Wformat-truncation=]
   snprintf(cmd, sizeof(cmd), "cp %s %s", stobjfile, dst_stobjfile);
                                     ^~              ~~~~~~~~~~~~~
invidx.c:253:3: note: ‘snprintf’ output 5 or more bytes (assuming
4100) into a destination of size
1024
   snprintf(cmd, sizeof(cmd), "cp %s %s", stobjfile, dst_stobjfile);
   ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

I checked the MAXPATHLEN and we have:

./man/man8/xfsrestore.8:775:must be 1023 characters (MAXPATHLEN) or less.
And also /common/fs.h:27:#define FS_MAXPATHLEN_DEFAULT 1024


The exact declaration of MAXPATHLEN is missing in my grep (probably
some magic created during build time), so, I'm not sure how exactly it
gets the 4100, but in other places, we repeatedly do things like
calloc( 1, 2 * MAXPATHLEN ), and if the default and manpage values are
ok and the 2* propagates here, it makes it 4096+4=4100 without \0.

>
> But let's look at this one.  For this string:
>
>   "interrupted: %s, cmdarg: %s"
>
> Treating the "%s" as 0 chars, we have 23 chars + NUL, so that's 24.
>
> st_cmdarg is char st_cmdarg[INV_STRLEN] and INV_STRLEN is 128.
>
> The "interrupted" string is at most 3 chars.
>
> So we have 24+3+128=155 chars max AFAICT, maybe 156 w/ the NUL.
>
> What are we missing?
>
> Oh.  INV_STRLEN is defined differently in different places:
>
> #define INV_STRLEN 128
>
> and elsewhere
>
> #define INV_STRLEN GLOBAL_HDR_STRING_SZ
> #define GLOBAL_HDR_STRING_SZ 0x100
>
> Ugh.  So, in this case, it would be much more foolproof to not pick
> a magic number like "300" but instead do something like:
>
> txt[INV_STRLEN+32]
>
> which ensures we have enough for st_cmdarg[INV_STRLEN], as well as the more
> obvious/easily-countable literal string lengths in the other partsof the message.
> That way if somebody changes the INV_STRLEN for any reason, all the code still works.
>
> (not sure +32 is sufficient, I didn't count closely, but you get the idea).

Yeah, that looks better.

Thanks,
Jan

>
> A little extra space is fine, I'm not saying we should count to the nearest
> character! :)  But if a big part of the length depends an argument with a length
> that depends on a defined macro, let's use that macro so the code doesn't break again later.
>
> -eric



--
Jan Tulak
