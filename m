Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from Galois.linutronix.de ([146.0.238.70]:59455 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750910AbdKLUUD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 12 Nov 2017 15:20:03 -0500
Date: Sun, 12 Nov 2017 21:19:55 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch 1/7] Documentation: Add license-rules.rst to describe
 how to properly identify file licenses
In-Reply-To: <20171112130746.607facb6@lwn.net>
Message-ID: <alpine.DEB.2.20.1711122114520.1993@nanos>
References: <20171112191821.240484206@linutronix.de> <20171112192142.525567667@linutronix.de> <20171112130746.607facb6@lwn.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jonathan Corbet <corbet@lwn.net>
Cc: LKML <linux-kernel@vger.kernel.org>, Linus Torvalds <torvalds@linuxfoundation.org>, Andrew Morton <akpm@linuxfoundation.org>, Philippe Ombredanne <pombredanne@nexb.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Christoph Hellwig <hch@lst.de>, Russell King <rmk+kernel@armlinux.org.uk>, Rob Herring <rob.herring@linaro.org>, Jonas Oberg <jonas@fsfe.org>, Joe Perches <joe@perches.com>, linux-xfs@vger.kernel.org, Kate Stewart <kstewart@linuxfoundation.org>

On Sun, 12 Nov 2017, Jonathan Corbet wrote:
> On Sun, 12 Nov 2017 20:18:22 +0100
> Thomas Gleixner <tglx@linutronix.de> wrote:
> > +    C source:   // SPDX-License-Identifier: <SPDX License Expression>
> > +    C header:   /* SPDX-License-Identifier: <SPDX License Expression> */
> 
> So I can't be the only person with nothing better to do than to wonder why
> source and header files use a different comment syntax.  Maybe the document
> could explain that?

Will do. The reason is that some build steps, one of them related to
generated .lds files fail with C++ style comments. Linus fixed the .lds
one, but there is at least an older ASM tool which doesn't like them.

> > +    ASM:        /* SPDX-License-Identifier: <SPDX License Expression> */
> > +OR should be used if the file is dual licensed and only one license is
> > +to be selected.  For example, some dtsi files are available under dual
> > +licenses:
> 
> It would be good to document the set of permissible WITH exceptions.  Or
> people will surely get creative in making up new ones.
>
> 
> OK, I see that has been done, so amend that comment to suggest a line
> saying that the set of exceptions is documented below.

Will do. The other thing is, that the exception files have the applicable
licenses in it so something like checkpatch.pl can verify it.

Thanks,

	tglx
