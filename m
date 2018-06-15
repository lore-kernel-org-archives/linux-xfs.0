Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-it0-f67.google.com ([209.85.214.67]:40285 "EHLO
        mail-it0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755310AbeFOQzV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 15 Jun 2018 12:55:21 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.21.1806122111400.1592@nanos.tec.linutronix.de>
References: <20171228152710.891701433@linutronix.de> <20171228153308.286787253@linutronix.de>
 <alpine.DEB.2.20.1712282315030.1899@nanos> <CADRPPNTK1x_47fnk4Tor5QSPk2DEuEwNUQQ4dGu1P3QkQDyZeQ@mail.gmail.com>
 <alpine.DEB.2.21.1806122111400.1592@nanos.tec.linutronix.de>
From: Yang Li <pku.leo@gmail.com>
Date: Fri, 15 Jun 2018 11:55:20 -0500
Message-ID: <CADRPPNQzy+v8wqGJj=yhTDT2gCWiSmbs=VTfin_mwby-wJoF7A@mail.gmail.com>
Subject: Re: [patch V5 01/11] Documentation: Add license-rules.rst to describe
 how to properly identify file licenses
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Linus Torvalds <torvalds@linuxfoundation.org>, Andrew Morton <akpm@linuxfoundation.org>, Jonathan Corbet <corbet@lwn.net>, Kate Stewart <kstewart@linuxfoundation.org>, Philippe Ombredanne <pombredanne@nexb.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Christoph Hellwig <hch@lst.de>, Russell King <rmk+kernel@armlinux.org.uk>, Rob Herring <rob.herring@linaro.org>, Jonas Oberg <jonas@fsfe.org>, Joe Perches <joe@perches.com>, linux-xfs@vger.kernel.org, Charlemagne Lasse <charlemagnelasse@gmail.com>, Carmen Bianca Bakker <carmenbianca@fsfe.org>, "Darrick J. Wong" <darrick.wong@oracle.com>, Heiko Carstens <heiko.carstens@de.ibm.com>

On Tue, Jun 12, 2018 at 2:27 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
> Yang,
>
> On Tue, 12 Jun 2018, Yang Li wrote:
>> On Thu, Dec 28, 2017 at 4:17 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
>> > On Thu, 28 Dec 2017, Thomas Gleixner wrote:
>> >
>> > Sorry for the spam. I somehow missed to refresh the patch before generating
>> > the mbox. Find below the correct version of that one which has ALL braces
>> > removed which we don't need.
>
>> I'm not sure how we reached the conclusion that we should remove ALL
>> braces?  I cannot find related discussion in the archive except for
>> the "WITH" case.
>
> https://lkml.kernel.org/r/CAOFm3uEpM_tBErkOvqghcy+wbw0i4mSnafPBRC3HYZVQjsSyMw@mail.gmail.com

Thanks Thomas,  But this email is mostly discussing the "WITH" case as
I said, and it does mentioned that braces is (weakly) needed for other
cases.

>
>> This is conflicting with the current SPDX spec at
>> https://spdx.org/spdx-specification-21-web-version quoted below and
>> also the explenation in your own file.
>>
>> Quote from SPDX spec 2.1: More expressive composite license
>> expressions can be constructed using "OR", "AND", and "WITH" operators
>> similar to constructing mathematical expressions using arithmetic
>> operators. For the Tag:value format, any license expression that
>> consists of more than one license identifier and/or LicenseRef, should
>> be encapsulated by parentheses: "( )".
>
> This is not relevant here:
>
>    For the Tag:value format, .....
>
> The kernel does not generate SPDX files in Tag:value format. The kernel
> uses SPDX license identifiers to reflect the actual license of a file.

I'm not sure if I understood the Tag:value term correctly.  But it
looks like to me that the "SPDX-License-Identifier: <SPDX License
Expression>" is a tag:value in the SPDX spec.

"The tag should appear on its own line in the source file, generally
as part of a comment.

SPDX-License-Identifier: <SPDX License Expression>"


>
>> > +   A <SPDX License Expression> is either an SPDX short form license
>> > +   identifier found on the SPDX License List, or the combination of two
>> > +   SPDX short form license identifiers separated by "WITH" when a license
>> > +   exception applies. When multiple licenses apply, an expression consists
>> > +   of keywords "AND", "OR" separating sub-expressions and surrounded by
>> > +   "(", ")" .
>>
>> Conflicting with the example
>
> No, The keyword is 'separating sub-expressions'. It does not say license
> identifiers.

But the first sentense declared that an expression can just be a short
form license identifier.

And the examples provided in the spec also proves it:

"Examples:

SPDX-License-Identifier: (GPL-2.0 OR MIT)
SPDX-License-Identifier: (LGPL-2.1 AND BSD-2-CLAUSE)
SPDX-License-Identifier: (GPL-2.0+ WITH Bison-exception-2.2)"


>
> So these examples are completely compliant with the documentation:
>
>> > +      // SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note
>> > +      // SPDX-License-Identifier: GPL-2.0+ WITH Linux-syscall-note
>> > +      // SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
>
> Two license (exception) identifiers plus a operator. That's perfectly well
> defined.
>
>> > +      // SPDX-License-Identifier: (GPL-2.0 WITH Linux-syscall-note) OR MIT
>
> This is actually a case where you need parentheses and they separate the
> sub-expression 'ID with EXC'.
>
> Adding extra parentheses around any simple 'ID operator [ID|EXC]'
> expression is really overkill and does not make stuff more
> readable. Likewise in programming languages. Why would anyone write:
>
> C et al.:       a = (b || c);
> Pyhton:         a = (b and c)

I think I agree with you that not having parentheses in these cases
probably make more sense.  But I think we are having a conflict with
the spec now, probably we should update the SPDX spec to be aligned?
Actually a lot of the current SPDX tags in kernel tree are following
the spec to use the parentheses.  We should do something to avoid the
confusion in the future IMO.

Regards,
Leo
