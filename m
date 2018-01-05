Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.free-electrons.com ([62.4.15.54]:41840 "EHLO
        mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751278AbeAENF3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 5 Jan 2018 08:05:29 -0500
Date: Fri, 5 Jan 2018 14:05:26 +0100
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: Re: [V4, 01/11] Documentation: Add license-rules.rst to describe how
 to properly identify file licenses
Message-ID: <20180105130526.GA31648@piout.net>
References: <alpine.DEB.2.20.1711171057240.1709@nanos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.20.1711171057240.1709@nanos>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Linus Torvalds <torvalds@linuxfoundation.org>, Andrew Morton <akpm@linuxfoundation.org>, Jonathan Corbet <corbet@lwn.net>, Kate Stewart <kstewart@linuxfoundation.org>, Philippe Ombredanne <pombredanne@nexb.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Christoph Hellwig <hch@lst.de>, Russell King <rmk+kernel@armlinux.org.uk>, Rob Herring <rob.herring@linaro.org>, Jonas Oberg <jonas@fsfe.org>, Joe Perches <joe@perches.com>, linux-xfs@vger.kernel.org, Charlemagne Lasse <charlemagnelasse@gmail.com>, Carmen Bianca Bakker <carmenbianca@fsfe.org>

Hi,

I'm definitively late to the party but...

On 17/11/2017 at 11:00:33 +0100, Thomas Gleixner wrote:
> +2. Style:
> +
> +   The SPDX license identifier is added in form of a comment.  The comment
> +   style depends on the file type::
> +
> +      C source:   // SPDX-License-Identifier: <SPDX License Expression>
> +      C header:   /* SPDX-License-Identifier: <SPDX License Expression> */
> +      ASM:        /* SPDX-License-Identifier: <SPDX License Expression> */
> +      scripts:    # SPDX-License-Identifier: <SPDX License Expression>
> +      .rst:	  .. SPDX-License-Identifier: <SPDX License Expression>
> +      .dts{i}:	  // SPDX-License-Identifier: <SPDX License Expression>

dtc doesn't handle // comments. This works in the kernel tree because
dts files are preprocessed by CPP. But this doesn't work when using dtc
directly (most likely when compiling DT overlays). So, the choice is
between making dtc handle // comments or changing the documentation.

I don't have an opinion and Rob doesn't seem to care but I think we need
to do something now instead of letting each maintainer have to handle
this issue.

> +   If a specific tool cannot handle the standard comment style, then the
> +   appropriate comment mechanism which the tool accepts shall be used. This
> +   is the reason for having the "/\* \*/" style comment in C header
> +   files. There was build breakage observed with generated .lds files where
> +   'ld' failed to parse the C++ comment. This has been fixed by now, but
> +   there are still older assembler tools which cannot handle C++ style
> +   comments.
> +
-- 
Alexandre Belloni, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com
