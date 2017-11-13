Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-qk0-f194.google.com ([209.85.220.194]:51238 "EHLO
        mail-qk0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751515AbdKMKgb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 13 Nov 2017 05:36:31 -0500
MIME-Version: 1.0
In-Reply-To: <20171112192142.525567667@linutronix.de>
References: <20171112192142.525567667@linutronix.de>
From: Charlemagne Lasse <charlemagnelasse@gmail.com>
Date: Mon, 13 Nov 2017 11:04:24 +0100
Message-ID: <CAFGhKbyJheVH-qrh3jYfWyTjSzFeY2yUJGYuscqLQf+SsvEzqA@mail.gmail.com>
Subject: Re: [1/7] Documentation: Add license-rules.rst to describe how to
 properly identify file licenses
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Linus Torvalds <torvalds@linuxfoundation.org>, Andrew Morton <akpm@linuxfoundation.org>, Jonathan Corbet <corbet@lwn.net>, Kate Stewart <kate@linuxfoundation.org>, Philippe Ombredanne <pombredanne@nexb.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Christoph Hellwig <hch@lst.de>, Russell King <rmk+kernel@armlinux.org.uk>, Rob Herring <rob.herring@linaro.org>, Jonas Oberg <jonas@fsfe.org>, Joe Perches <joe@perches.com>, linux-xfs@vger.kernel.org, Kate Stewart <kstewart@linuxfoundation.org>, Carmen Bianca Bakker <carmenbianca@fsfe.org>

Hi,

Looks like this superseeds my patches

- https://patchwork.kernel.org/patch/10054727/
- https://patchwork.kernel.org/patch/10054719/
- https://patchwork.kernel.org/patch/10054721/
- https://patchwork.kernel.org/patch/10054725/
- https://patchwork.kernel.org/patch/10054723/


> +License identifier syntax
> +-------------------------
> +
> +The SPDX license identifier in kernel files shall be added at the first
> +possible line in a file which can contain a comment.  For the majority
> +of files this is the first line, except for scripts which require the
> +'#!PATH_TO_INTERPRETER' in the first line.  For those scripts the SPDX
> +identifier goes into the second line.
> +
> +The SPDX license identifier is added in form of a comment.  The comment
> +style depends on the file type:
> +
> +::
> +
> +    C source:   // SPDX-License-Identifier: <SPDX License Expression>
> +    C header:   /* SPDX-License-Identifier: <SPDX License Expression> */
> +    ASM:        /* SPDX-License-Identifier: <SPDX License Expression> */
> +    scripts:    # SPDX-License-Identifier: <SPDX License Expression>
> +
> +If a specific tool cannot handle the standard comment style, then the
> +appropriate comment mechanism which the tool accepts shall be used.

Most of the things sound good. But I really don't get the first-line
thing and the C++ single line comments in C sources.

First there are already tools [1] from the FSFE REUSE project [2] that
support it after the copyright header. For example, the REUSE example
project uses this style for cURL [3]. But is also looks quite out of
place in the source files.

Here what it looks like right now in the kernel:

// SPDX-License-Identifier: GPL-2.0
/*
 * Copyright(c) 2015 EZchip Technologies.
 *
 * This program is free software; you can redistribute it and/or modify it
 * under the terms and conditions of the GNU General Public License,
 * version 2, as published by the Free Software Foundation.
 *
 * This program is distributed in the hope it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
 * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
 * more details.
 *
 * The full GNU General Public License is included in this distribution in
 * the file called "COPYING".
 */

The REUSE cURL way would look more like:

/*
 * Copyright(c) 2015 EZchip Technologies.
 *
 * This program is free software; you can redistribute it and/or modify it
 * under the terms and conditions of the GNU General Public License,
 * version 2, as published by the Free Software Foundation.
 *
 * This program is distributed in the hope it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
 * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
 * more details.
 *
 * License-Filename: LICENSES/preferred/GPL-2.0
 * SPDX-License-Identifier: GPL-2.0
 */

And to the C++ style comments in C-source files. Way wouldn't it
possible to use a common style in C source files an C header files?

C source:   /* SPDX-License-Identifier: <SPDX License Expression> */
C header:   /* SPDX-License-Identifier: <SPDX License Expression> */

Thanks,
Charlemagne Lasse

[1] https://git.fsfe.org/reuse/reuse
[2] https://reuse.software/
[3] https://git.fsfe.org/jonas/curl/src/reuse-compliant/src/slist_wc.c
