Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:45479 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750744AbdL2WSg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 29 Dec 2017 17:18:36 -0500
Received: by mail-wm0-f67.google.com with SMTP id 9so50104830wme.4
        for <linux-xfs@vger.kernel.org>; Fri, 29 Dec 2017 14:18:35 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20171229185404.GD11757@thunk.org>
References: <20171228152710.891701433@linutronix.de> <20171228153308.286787253@linutronix.de>
 <alpine.DEB.2.20.1712282315030.1899@nanos> <CAOFm3uG_Sj1+jf32CvCeuWZV_nK1f-8B6POd_nZXAEJghnB08w@mail.gmail.com>
 <1514564399.10256.7.camel@perches.com> <20171229185404.GD11757@thunk.org>
From: Philippe Ombredanne <pombredanne@nexb.com>
Date: Fri, 29 Dec 2017 23:17:54 +0100
Message-ID: <CAOFm3uHm5ye7VdbVYcu+a_-3paO7phazNSGzhRL3wzGFcx-MkQ@mail.gmail.com>
Subject: Re: [patch V5 01/11] Documentation: Add license-rules.rst to describe
 how to properly identify file licenses
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Theodore Ts'o <tytso@mit.edu>, Joe Perches <joe@perches.com>, Philippe Ombredanne <pombredanne@nexb.com>, Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>, Linus Torvalds <torvalds@linuxfoundation.org>, Andrew Morton <akpm@linuxfoundation.org>, Jonathan Corbet <corbet@lwn.net>, Kate Stewart <kstewart@linuxfoundation.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Christoph Hellwig <hch@lst.de>, Russell King <rmk+kernel@armlinux.org.uk>, Rob Herring <rob.herring@linaro.org>, Jonas Oberg <jonas@fsfe.org>, xfs <linux-xfs@vger.kernel.org>, Charlemagne Lasse <charlemagnelasse@gmail.com>, Carmen Bianca Bakker <carmenbianca@fsfe.org>, "Darrick J. Wong" <darrick.wong@oracle.com>, Heiko Carstens <heiko.carstens@de.ibm.com>

On Fri, Dec 29, 2017 at 7:54 PM, Theodore Ts'o <tytso@mit.edu> wrote:
> On Fri, Dec 29, 2017 at 08:19:59AM -0800, Joe Perches wrote:
>>
>> Has it been legally reviewed and accepted that removal
>> of the BSD license text from individual source files is
>> appropriate and meets the legal requirements of
>> following the BSD license on a per-file basis?
>>
>> And if so, who did this review?
>>
>> Is there any license that does not allow removal of the
>> license text and does not allow simple substitution of
>> the SPDX license identifier in each individual file?
>
> The work to use SPDX lines instead of individual licenses was done by
> Greg K-H in close consultation with Linux Foundation counsels, so I
> would assume that they did look at that particular issue.

This is correct. And this is in addition to the discussion in the SPDX
group  at the LF (that includes several FOSS-savvy and prominent FOSS
lawyers) that did design the SPDX spec.

> IANAL, but I've talked to lawyers about this issue, and in my
> experience if you talk to three lawyers you will easily get six
> opinions.

And that's on a good day: you may get more than six on a bad one. But
on the other hand, they tend also to defer to standards, and
established community norms.

> As far as I know, none of the licenses explicitly say
> copyright license must be on each file.  Just that the distribution of
> source must include the copyright and license statement.  Exactly how
> that is done is not explicitly specified.

This is also my take. What is done here is not much different than
refactoring duplicated code so it leaves in a single place:

- by "value" at the root in COPYING and in the Documentation.
- by "reference" in the code proper as SPDX ids.

Therefore essential and common requirements to include the license
text is fulfilled in the kernel.

Note that there are a few offenders that will need to clean up their
acts as they came up will both long and "un-removable and
un-alterable" crazy legalese blurbs [1] prefix this:

"DO NOT ALTER OR REMOVE COPYRIGHT NOTICES OR THIS FILE HEADER"

These will have to be taken care on a case by case basis. These are
pretty stupid and IMHO should have never been allowed to be added to
the kernel in the first place and are ugly warts. It could very well
be that these are not really GPL-compliant notices FWIW: keeping
notices and copyrights is quite different from a restriction of
altering things by moving them around which is exactly what is
happening with the SPDX-ification here.

[1] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/drivers/staging/lustre/include/linux/libcfs/libcfs.h?h=v4.15-rc5#n5

-- 
Cordially
Philippe Ombredanne
