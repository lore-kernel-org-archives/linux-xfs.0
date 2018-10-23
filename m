Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:55144 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726970AbeJWW6k (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 23 Oct 2018 18:58:40 -0400
Subject: Re: xfsdump cleaning patchset
References: <CACj3i73FyABTkX1eCDvL+ccUhD1kWowS92=PFVyGiPvi6HWGFQ@mail.gmail.com>
 <20181022174316.GA28561@infradead.org>
 <90559dfb-5222-4faf-a9bb-a314cc645129@sandeen.net>
 <83eb725e-800d-b597-29d9-52d8a672c82c@sandeen.net>
 <CACj3i72hTgnkiM7Z99UVYYNJZaTQ2BM8hFYURDhxXbSX7enWgQ@mail.gmail.com>
 <392a4c28-9800-fe40-73b9-632370093d50@sandeen.net>
 <CACj3i71nxp+ktvCm31Gb3k4A8nYVaLHO1WxwruhbDjmwwyz1Jw@mail.gmail.com>
 <e14292f4-8a49-fdb1-cffd-1c2ddc97dd35@sandeen.net>
 <CACj3i720J7vpENKOBAEBWMy4Frpy+FPdfC+ggyMnzwU62yUa9g@mail.gmail.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <6df1ed3b-ee0c-05e0-41d0-5691f413cd17@sandeen.net>
Date: Tue, 23 Oct 2018 09:34:56 -0500
MIME-Version: 1.0
In-Reply-To: <CACj3i720J7vpENKOBAEBWMy4Frpy+FPdfC+ggyMnzwU62yUa9g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jan Tulak <jtulak@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-xfs <linux-xfs@vger.kernel.org>



On 10/23/18 9:06 AM, Jan Tulak wrote:
> On Tue, Oct 23, 2018 at 3:43 PM Eric Sandeen <sandeen@sandeen.net> wrote:
>>
>> On 10/23/18 8:15 AM, Jan Tulak wrote:
>>> On Tue, Oct 23, 2018 at 2:10 PM Eric Sandeen <sandeen@sandeen.net> wrote:
> 
>>>> It's always possible that I'm wrong and I'm missing something.  :)
>>>> What did gcc say for the cases I pointed out?
>>>
>>> For the txt[256] -> 300:
>>>
>>> stobj.c: In function ‘stobjstrm_highlight’:
>>> stobj.c:227:55: warning: ‘%s’ directive output may be truncated
>>> writing up to 255 bytes into a region of size between 230 and 231 [-Wformat-truncation=]
>>>   snprintf(txt, sizeof(txt), "interrupted: %s, cmdarg: %s",
>>>                                                        ^~
>>> stobj.c:227:2: note: ‘snprintf’ output between 26 and 282 bytes into a
>>> destination of size 256
>>>   snprintf(txt, sizeof(txt), "interrupted: %s, cmdarg: %s",
>>>   ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>>>    (stobjstrm->st_interrupted == BOOL_TRUE) ? "yes" : "no",
>>>    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>>>    stobjstrm->st_cmdarg);
>>>    ~~~~~~~~~~~~~~~~~~~~~
>>>
>>> So, I took the 282, added something, and rounded it to a number that
>>> felt good and wasn't much larger than that.
>>
>> Ok, I don't think that's one of the ones I commented on ;)
> 
> You mentioned multiple cases, so I picked the first one I found. :-)
> If you ask for the 1024 -> 5000 bytes buffer, then it is probably this one:
> 
> invidx.c:253:37: warning: ‘%s’ directive output may be truncated
> writing up to 4095 bytes into a r$
> gion of size 1020 [-Wformat-truncation=]
>    snprintf(cmd, sizeof(cmd), "cp %s %s", stobjfile, dst_stobjfile);
>                                      ^~              ~~~~~~~~~~~~~
> invidx.c:253:3: note: ‘snprintf’ output 5 or more bytes (assuming
> 4100) into a destination of size
> 1024
>    snprintf(cmd, sizeof(cmd), "cp %s %s", stobjfile, dst_stobjfile);
>    ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> 
> I checked the MAXPATHLEN and we have:
> 
> ./man/man8/xfsrestore.8:775:must be 1023 characters (MAXPATHLEN) or less.
> And also /common/fs.h:27:#define FS_MAXPATHLEN_DEFAULT 1024

Except checking at build time I get:

invidx.c: In function ‘invidx_commit’:
invidx.c:125: note: #pragma message: MAXPATHLEN=4096

> 
> The exact declaration of MAXPATHLEN is missing in my grep (probably
> some magic created during build time), so, I'm not sure how exactly it
> gets the 4100, but in other places, we repeatedly do things like
> calloc( 1, 2 * MAXPATHLEN ), and if the default and manpage values are
> ok and the 2* propagates here, it makes it 4096+4=4100 without \0.

Right, so again, using the macro here makes it more foolproof.

Thanks,
-Eric
