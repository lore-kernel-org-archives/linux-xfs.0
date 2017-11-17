Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:36535 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934274AbdKQHiK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 17 Nov 2017 02:38:10 -0500
Received: by mail-wm0-f67.google.com with SMTP id r68so4563901wmr.1
        for <linux-xfs@vger.kernel.org>; Thu, 16 Nov 2017 23:38:09 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20171116151540.GA18500@silk.coyote.org>
References: <20171112191821.240484206@linutronix.de> <20171112192142.525567667@linutronix.de>
 <20171116080723.279591c8@lwn.net> <20171116151540.GA18500@silk.coyote.org>
From: Philippe Ombredanne <pombredanne@nexb.com>
Date: Fri, 17 Nov 2017 08:37:28 +0100
Message-ID: <CAOFm3uFANvJa0yxiKPcR7KER22951+uO8-qez+hKRY9PzzNskw@mail.gmail.com>
Subject: Re: [patch 1/7] Documentation: Add license-rules.rst to describe how
 to properly identify file licenses
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jonas Oberg <jonas@fsfe.org>
Cc: Jonathan Corbet <corbet@lwn.net>, Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>, Linus Torvalds <torvalds@linuxfoundation.org>, Andrew Morton <akpm@linuxfoundation.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Christoph Hellwig <hch@lst.de>, Russell King <rmk+kernel@armlinux.org.uk>, Rob Herring <rob.herring@linaro.org>, Joe Perches <joe@perches.com>, xfs <linux-xfs@vger.kernel.org>, Kate Stewart <kstewart@linuxfoundation.org>

On Thu, Nov 16, 2017 at 4:15 PM, Jonas Oberg <jonas@fsfe.org> wrote:
> Hi,
>
>> One other thing that occurred to me is that documentation files, too,
>> are copyrightable and should have license identifiers.
>
> Would it make sense to take an incremental approach to this? Get the
> source code and identifiers worked on by Thomas et al through first, then
> think about and fix up potential other issues, like the top level COPYING
> file, or documentation :-)

I could not agree more... code first!
FWIW I scanned the whole docs with scancode as part of this exercise.
They are rather ... messy license-wise, but even though I got through
it eventually they also generally less critical license-wise IMHO.

You can see some details of these scans in [1] though they are not
100% up to date: I did not post every intermediate scans and review
there as things are moving at a fast pace.

There are probably more pressing things to fix such as discrepancies
between a MODULE_LICENSE and the licensing of a file when they do not
match.

Here [2] the top level comment is a plain GPL-2.0 "only" while the
MODULE_LICENSE  is a GPL-2.0+ "or later"  (based on the plain "GPL"
definition in module.h [3] and this is just  one of many examples of this
weirdness.

Or fix the non-standard redefinition of the MODULE_LICENSE macro as
DRIVER_LICENSE as in [2]  and found elsewhere with
grep -r . -e "DRIVER_LICENSE"

These break the otherwise nicely grepable MODULE_LICENSE macros
with this kind of warty redirection I stumbled upon while reviewing kernel
license scans:

#define DRIVER_LICENSE "GPL"
[...]
MODULE_LICENSE(DRIVER_LICENSE);

[1] https://github.com/pombredanne/linux-kernel-scans/
[2] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/arch/alpha/kernel/srm_env.c?h=v4.14#n13
[3] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/include/linux/module.h?h=v4.14#n174
[4] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/drivers/gpu/drm/gma500/psb_drv.h?h=v4.14#n39
-- 
Cordially
Philippe Ombredanne
