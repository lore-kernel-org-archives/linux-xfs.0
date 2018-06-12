Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-io0-f193.google.com ([209.85.223.193]:32869 "EHLO
        mail-io0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754047AbeFLTDc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 12 Jun 2018 15:03:32 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.20.1712282315030.1899@nanos>
References: <20171228152710.891701433@linutronix.de> <20171228153308.286787253@linutronix.de>
 <alpine.DEB.2.20.1712282315030.1899@nanos>
From: Yang Li <pku.leo@gmail.com>
Date: Tue, 12 Jun 2018 14:03:31 -0500
Message-ID: <CADRPPNTK1x_47fnk4Tor5QSPk2DEuEwNUQQ4dGu1P3QkQDyZeQ@mail.gmail.com>
Subject: Re: [patch V5 01/11] Documentation: Add license-rules.rst to describe
 how to properly identify file licenses
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Linus Torvalds <torvalds@linuxfoundation.org>, Andrew Morton <akpm@linuxfoundation.org>, Jonathan Corbet <corbet@lwn.net>, Kate Stewart <kstewart@linuxfoundation.org>, Philippe Ombredanne <pombredanne@nexb.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Christoph Hellwig <hch@lst.de>, Russell King <rmk+kernel@armlinux.org.uk>, Rob Herring <rob.herring@linaro.org>, Jonas Oberg <jonas@fsfe.org>, Joe Perches <joe@perches.com>, linux-xfs@vger.kernel.org, Charlemagne Lasse <charlemagnelasse@gmail.com>, Carmen Bianca Bakker <carmenbianca@fsfe.org>, "Darrick J. Wong" <darrick.wong@oracle.com>, Heiko Carstens <heiko.carstens@de.ibm.com>

On Thu, Dec 28, 2017 at 4:17 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
> On Thu, 28 Dec 2017, Thomas Gleixner wrote:
>
> Sorry for the spam. I somehow missed to refresh the patch before generating
> the mbox. Find below the correct version of that one which has ALL braces
> removed which we don't need.

Hi Thomas,

I'm not sure how we reached the conclusion that we should remove ALL
braces?  I cannot find related discussion in the archive except for
the "WITH" case.

This is conflicting with the current SPDX spec at
https://spdx.org/spdx-specification-21-web-version quoted below and
also the explenation in your own file.

Quote from SPDX spec 2.1: More expressive composite license
expressions can be constructed using "OR", "AND", and "WITH" operators
similar to constructing mathematical expressions using arithmetic
operators. For the Tag:value format, any license expression that
consists of more than one license identifier and/or LicenseRef, should
be encapsulated by parentheses: "( )".


> +
> +   A <SPDX License Expression> is either an SPDX short form license
> +   identifier found on the SPDX License List, or the combination of two
> +   SPDX short form license identifiers separated by "WITH" when a license
> +   exception applies. When multiple licenses apply, an expression consists
> +   of keywords "AND", "OR" separating sub-expressions and surrounded by
> +   "(", ")" .

Conflicting with the example

> +
> +   License identifiers for licenses like [L]GPL with the 'or later' option
> +   are constructed by using a "+" for indicating the 'or later' option.::
> +
> +      // SPDX-License-Identifier: GPL-2.0+
> +      // SPDX-License-Identifier: LGPL-2.1+
> +
> +   WITH should be used when there is a modifier to a license needed.
> +   For example, the linux kernel UAPI files use the expression::
> +
> +      // SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note
> +      // SPDX-License-Identifier: GPL-2.0+ WITH Linux-syscall-note
> +
> +   Other examples using WITH exceptions found in the kernel are::
> +
> +      // SPDX-License-Identifier: GPL-2.0 WITH mif-exception
> +      // SPDX-License-Identifier: GPL-2.0+ WITH GCC-exception-2.0
> +
> +   Exceptions can only be used with particular License identifiers. The
> +   valid License identifiers are listed in the tags of the exception text
> +   file. For details see the point `Exceptions`_ in the chapter `License
> +   identifiers`_.
> +
> +   OR should be used if the file is dual licensed and only one license is
> +   to be selected.  For example, some dtsi files are available under dual
> +   licenses::
> +
> +      // SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
> +
> +   Examples from the kernel for license expressions in dual licensed files::
> +
> +      // SPDX-License-Identifier: GPL-2.0 OR MIT
> +      // SPDX-License-Identifier: GPL-2.0 OR BSD-2-Clause
> +      // SPDX-License-Identifier: GPL-2.0 OR Apache-2.0
> +      // SPDX-License-Identifier: GPL-2.0 OR MPL-1.1
> +      // SPDX-License-Identifier: (GPL-2.0 WITH Linux-syscall-note) OR MIT
> +      // SPDX-License-Identifier: GPL-1.0+ OR BSD-3-Clause OR OpenSSL
> +
> +   AND should be used if the file has multiple licenses whose terms all
> +   apply to use the file. For example, if code is inherited from another
> +   project and permission has been given to put it in the kernel, but the
> +   original license terms need to remain in effect::
> +
> +      // SPDX-License-Identifier: (GPL-2.0 WITH Linux-syscall-note) AND MIT
> +
> +   Another other example where both sets of license terms need to be
> +   adhered to is::
> +
> +      // SPDX-License-Identifier: GPL-1.0+ AND LGPL-2.1+
> +
