Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:45506 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753691AbdLHP3y (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 8 Dec 2017 10:29:54 -0500
Received: by mail-wm0-f68.google.com with SMTP id 9so3865326wme.4
        for <linux-xfs@vger.kernel.org>; Fri, 08 Dec 2017 07:29:53 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20171205065003.GB7782@osiris>
References: <20171204211927.673291734@linutronix.de> <20171204212120.484179273@linutronix.de>
 <20171205065003.GB7782@osiris>
From: Philippe Ombredanne <pombredanne@nexb.com>
Date: Fri, 8 Dec 2017 16:29:12 +0100
Message-ID: <CAOFm3uEpM_tBErkOvqghcy+wbw0i4mSnafPBRC3HYZVQjsSyMw@mail.gmail.com>
Subject: Re: [patch V4 01/11] Documentation: Add license-rules.rst to describe
 how to properly identify file licenses
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Heiko Carstens <heiko.carstens@de.ibm.com>, Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Linus Torvalds <torvalds@linuxfoundation.org>, Andrew Morton <akpm@linuxfoundation.org>, Jonathan Corbet <corbet@lwn.net>, Kate Stewart <kstewart@linuxfoundation.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Christoph Hellwig <hch@lst.de>, Russell King <rmk+kernel@armlinux.org.uk>, Rob Herring <rob.herring@linaro.org>, Jonas Oberg <jonas@fsfe.org>, Joe Perches <joe@perches.com>, xfs <linux-xfs@vger.kernel.org>, Charlemagne Lasse <charlemagnelasse@gmail.com>, Carmen Bianca Bakker <carmenbianca@fsfe.org>

On Tue, Dec 5, 2017 at 7:50 AM, Heiko Carstens
<heiko.carstens@de.ibm.com> wrote:
> On Mon, Dec 04, 2017 at 10:19:28PM +0100, Thomas Gleixner wrote:
>> +3. Syntax:
>> +
>> +   A <SPDX License Expression> is either an SPDX short form license
>> +   identifier found on the SPDX License List, or when multiple licenses
>> +   apply, an expression consisting of keywords "AND", "OR", and "WITH"
>> +   separating SPDX short form license identifiers surrounded by "(", ")".
>
> Here it is stated that SPDX identifiers using the keyword WITH must be
> surrounded by braces.

Heiko:
Darn! you have eagle eyes! Good catch. Thanks you++

Thomas:
The parens are not required in SPDX license identifiers and they only
(weakly) make sense when using expressions with OR and AND and not
for WITH expressions (which is a mouthful... don't we all love a bit
of boolean chat?).

Therefore I suggest to update the text above this way:

A <SPDX License Expression> is either an SPDX short form license
identifier found on the SPDX License List, or the combination of two
SPDX short form license identifiers separated by "WITH" when a license
exception applies. When multiple licenses apply, an expression
consists of keywords "AND", "OR" separating sub-expressions and
surrounded by "(", ")" .

>> +      // SPDX-License-Identifier: (GPL-2.0 WITH Linux-syscall-note)
>> +      // SPDX-License-Identifier: (GPL-2.0+ WITH Linux-syscall-note)
>
> Just like this example.

Thomas, this should become:

      // SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note
      // SPDX-License-Identifier: GPL-2.0+ WITH Linux-syscall-note

>> +   File format examples::
>> +
>> +      SPDX-Exception-Identifier: Linux-syscall-note
>> +      SPDX-URL: https://spdx.org/licenses/Linux-syscall-note.html
>> +      SPDX-Licenses: GPL-2.0, GPL-2.0+, GPL-1.0+, LGPL-2.0, LGPL-2.0+, LGPL-2.1, LGPL-2.1+
>> +      Usage-Guidance:
>> +        This exception is used together with one of the above SPDX-Licenses
>> +     to mark user-space API (uapi) header files so they can be included
>> +     into non GPL compliant user-space application code.
>> +        To use this exception add it with the keyword WITH to one of the
>> +     identifiers in the SPDX-Licenses tag:
>> +       SPDX-License-Identifier: <SPDX-License> WITH Linux-syscall-note
>
> But here it comes without braces.

It is correct and therefore no changes are needed here with the
proposed updates from above

>> +      Exception-Text:
>> +        Full exception text
>> +
>> +   ::
>> +
>> +      SPDX-Exception-Identifier: GCC-exception-2.0
>> +      SPDX-URL: https://spdx.org/licenses/GCC-exception-2.0.html
>> +      SPDX-Licenses: GPL-2.0, GPL-2.0+
>> +      Usage-Guidance:
>> +        The "GCC Runtime Library exception 2.0" is used together with one
>> +     of the above SPDX-Licenses for code imported from the GCC runtime
>> +     library.
>> +        To use this exception add it with the keyword WITH to one of the
>> +     identifiers in the SPDX-Licenses tag:
>> +       SPDX-License-Identifier: <SPDX-License> WITH GCC-exception-2.0
>
> Here as well.
>
> The whole kernel now got SPDX-License-Identifiers that look like this:
>
> SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note
>
> So this looks inconsistent to me, or did I miss something?

You did not miss anything, and you spotted this right on.
The SPDX-License-Identifier are correct, only the docs needs minor fixing.

Thanks again!

-- 
Cordially
Philippe Ombredanne
