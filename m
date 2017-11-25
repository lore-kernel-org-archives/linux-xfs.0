Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wm0-f49.google.com ([74.125.82.49]:37453 "EHLO
        mail-wm0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751835AbdKYXl7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 25 Nov 2017 18:41:59 -0500
Received: by mail-wm0-f49.google.com with SMTP id v186so28384012wma.2
        for <linux-xfs@vger.kernel.org>; Sat, 25 Nov 2017 15:41:58 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20171125185140.GA5114@amd>
References: <20171116183306.103584007@linutronix.de> <20171116184358.398030394@linutronix.de>
 <alpine.DEB.2.20.1711171057240.1709@nanos> <20171117150639.0e706421@vento.lan>
 <20171125185140.GA5114@amd>
From: Philippe Ombredanne <pombredanne@nexb.com>
Date: Sun, 26 Nov 2017 00:41:16 +0100
Message-ID: <CAOFm3uHoTGeS3V8bZUAsGVrPPfxHi7FU1etyfrFnCx3U+LDx4Q@mail.gmail.com>
Subject: Re: [patch V4 01/11] Documentation: Add license-rules.rst to describe
 how to properly identify file licenses
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Pavel Machek <pavel@ucw.cz>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>, Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>, Linus Torvalds <torvalds@linuxfoundation.org>, Andrew Morton <akpm@linuxfoundation.org>, Jonathan Corbet <corbet@lwn.net>, Kate Stewart <kstewart@linuxfoundation.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Christoph Hellwig <hch@lst.de>, Russell King <rmk+kernel@armlinux.org.uk>, Rob Herring <rob.herring@linaro.org>, Jonas Oberg <jonas@fsfe.org>, Joe Perches <joe@perches.com>, xfs <linux-xfs@vger.kernel.org>, Charlemagne Lasse <charlemagnelasse@gmail.com>, Carmen Bianca Bakker <carmenbianca@fsfe.org>

Pavel:

On Sat, Nov 25, 2017 at 7:51 PM, Pavel Machek <pavel@ucw.cz> wrote:
> On Fri 2017-11-17 15:06:39, Mauro Carvalho Chehab wrote:
>> Hi Thomas,
>>
>> Em Fri, 17 Nov 2017 11:00:33 +0100 (CET)
>> Thomas Gleixner <tglx@linutronix.de> escreveu:
>>
>> > Subject: Documentation: Add license-rules.rst to describe how to properly identify file licenses
>> > From: Thomas Gleixner <tglx@linutronix.de>
>> > Date: Fri, 10 Nov 2017 09:30:00 +0100
>> >
>> > Add a file to the Documentation directory to describe how file licenses
>> > should be described in all kernel files, using the SPDX identifier, as well
>> > as where all licenses should be in the kernel source tree for people to
>> > refer to (LICENSES/).
>> >
>> > Thanks to Kate, Greg and Jonathan for review and editing and Jonas for the
>> > suggestions concerning the meta tags in the licenses files.
>> >
>> > Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
>>
>> The document itself looks good, but I think it should also mention
>> what would be the expected values for the MODULE_LICENSE() macro and
>> how each license would be mapped into it.
>>
>> Right now, include/linux/module.h says:
>>
>> /*
>>  * The following license idents are currently accepted as indicating free
>>  * software modules
>>  *
>>  *    "GPL"                           [GNU Public License v2 or later]
>
> Hmm. AFAICT Greg translated GPL as GPL v1 or later. That seemed
> wrong... and now it seems even more wrong.

While this may come out as weird or wrong, this is neither wrong nor
"more wrong" when you dive in the details:

1. the meaning of a bare "GPL" in MODULE_LICENSE is well defined in
module.h as "GPL 2.0 or later" so there is no ambiguity there. It
would have been best to align this with SPDX, but this would break
instantly so many out of tree kernel modules and module loading tools
that expect these hard coded values and conventions that it is not
worth changing it IMHO.

2. the meaning of a bare "GPL" as a the only license notice is also
well defined in the GPL 2.0 text itself  in section 9 [1] and means
any version of the GPL that therefore can be made clear as GPL-1.0 or
later, i.e. GPL-1.+:
" If the Program does not specify a version number of this License,
you may choose any version ever published by the Free Software
Foundation. "

Therefore I do not think Greg did any translation and got anything
wrong but used exactly the convention in 2.

For instance when the only license notice in a file was a terse and
unclear: "Copyright (c) Jane Doe, GPL" or "Copyright (c) John Doe,
GPL'ed" then the resulting SPDX license id applied was  "GPL-1.0+"

I personally think this is unfortunate that we have warts like this:
it could have been the intent of author, or an oversight, or the
author may have meant 2.0.... we can only guess! What is clear is that
in these cases and short of any other indication, "GPL-1.0+" is the
precise meaning that "GPL" or "GPL'ed" has in a notice outside of the
MODULE_LICENSE macro.

Note that no MODULE_LICENSE macro was harmed in the process.... though
having SPDX ids makes quite visible some discrepancies as you noticed
such as when:
- a MODULE_LICENSE is "GPL"  and the top level license is "GPL 2.0
only": here the MODULE_LICENSE would need to be fixed to "GPL v2"
- or MODULE_LICENSE is "GPL v2" and the top level license is "GPL 2.0
or later": here the MODULE_LICENSE would need to be fixed to "GPL"

These will need to be fixed over time and this is made easier with the
clarity brought by the SPDX id. My take there is that the best
approach is likely:

1. the top level license notice should take precedence over the
MODULE_LICENSE and MODULE_LICENSE should be updated accordingly
2. you might want an ack or a review from the original author in these
weird cases of mismatch

[1] https://www.gnu.org/licenses/old-licenses/gpl-2.0.html#section9
-- 
Cordially
Philippe Ombredanne
