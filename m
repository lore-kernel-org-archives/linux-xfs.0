Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:49598 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727503AbeJWWHB (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 23 Oct 2018 18:07:01 -0400
Subject: Re: xfsdump cleaning patchset
References: <CACj3i73FyABTkX1eCDvL+ccUhD1kWowS92=PFVyGiPvi6HWGFQ@mail.gmail.com>
 <20181022174316.GA28561@infradead.org>
 <90559dfb-5222-4faf-a9bb-a314cc645129@sandeen.net>
 <83eb725e-800d-b597-29d9-52d8a672c82c@sandeen.net>
 <CACj3i72hTgnkiM7Z99UVYYNJZaTQ2BM8hFYURDhxXbSX7enWgQ@mail.gmail.com>
 <392a4c28-9800-fe40-73b9-632370093d50@sandeen.net>
 <CACj3i71nxp+ktvCm31Gb3k4A8nYVaLHO1WxwruhbDjmwwyz1Jw@mail.gmail.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <e14292f4-8a49-fdb1-cffd-1c2ddc97dd35@sandeen.net>
Date: Tue, 23 Oct 2018 08:43:29 -0500
MIME-Version: 1.0
In-Reply-To: <CACj3i71nxp+ktvCm31Gb3k4A8nYVaLHO1WxwruhbDjmwwyz1Jw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jan Tulak <jtulak@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-xfs <linux-xfs@vger.kernel.org>

On 10/23/18 8:15 AM, Jan Tulak wrote:
> On Tue, Oct 23, 2018 at 2:10 PM Eric Sandeen <sandeen@sandeen.net> wrote:
>>
>>
>>
>> On 10/23/18 3:16 AM, Jan Tulak wrote:
>>>> I'm not a huge fan of "fix buffer overflows by making them arbitrarily
>>>> bigger" - can we use i.e. snprintf to make sure it won't happen again,
>>>> and maybe size them based on ... something, instead of "eh, [5000] is
>>>> hopefully enough?"
>>> I based the new size on gcc outputs, it said how much it can overflow.
>>> But I checked the numbers only once or twice and didn't verify it for
>>> other reports.
>>
>> It's always possible that I'm wrong and I'm missing something.  :)
>> What did gcc say for the cases I pointed out?
> 
> For the txt[256] -> 300:
> 
> stobj.c: In function ‘stobjstrm_highlight’:
> stobj.c:227:55: warning: ‘%s’ directive output may be truncated
> writing up to 255 bytes into a region of size between 230 and 231 [-Wformat-truncation=]
>   snprintf(txt, sizeof(txt), "interrupted: %s, cmdarg: %s",
>                                                        ^~
> stobj.c:227:2: note: ‘snprintf’ output between 26 and 282 bytes into a
> destination of size 256
>   snprintf(txt, sizeof(txt), "interrupted: %s, cmdarg: %s",
>   ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>    (stobjstrm->st_interrupted == BOOL_TRUE) ? "yes" : "no",
>    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>    stobjstrm->st_cmdarg);
>    ~~~~~~~~~~~~~~~~~~~~~
> 
> So, I took the 282, added something, and rounded it to a number that
> felt good and wasn't much larger than that.

Ok, I don't think that's one of the ones I commented on ;)

But let's look at this one.  For this string:

  "interrupted: %s, cmdarg: %s"

Treating the "%s" as 0 chars, we have 23 chars + NUL, so that's 24.

st_cmdarg is char st_cmdarg[INV_STRLEN] and INV_STRLEN is 128.

The "interrupted" string is at most 3 chars.

So we have 24+3+128=155 chars max AFAICT, maybe 156 w/ the NUL.

What are we missing?

Oh.  INV_STRLEN is defined differently in different places:

#define INV_STRLEN 128

and elsewhere

#define INV_STRLEN GLOBAL_HDR_STRING_SZ
#define GLOBAL_HDR_STRING_SZ 0x100

Ugh.  So, in this case, it would be much more foolproof to not pick
a magic number like "300" but instead do something like:

txt[INV_STRLEN+32]

which ensures we have enough for st_cmdarg[INV_STRLEN], as well as the more
obvious/easily-countable literal string lengths in the other partsof the message.
That way if somebody changes the INV_STRLEN for any reason, all the code still works.

(not sure +32 is sufficient, I didn't count closely, but you get the idea).

A little extra space is fine, I'm not saying we should count to the nearest
character! :)  But if a big part of the length depends an argument with a length
that depends on a defined macro, let's use that macro so the code doesn't break again later.

-eric
