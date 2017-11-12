Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ms.lwn.net ([45.79.88.28]:37844 "EHLO ms.lwn.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750977AbdKLUHs (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sun, 12 Nov 2017 15:07:48 -0500
Date: Sun, 12 Nov 2017 13:07:46 -0700
From: Jonathan Corbet <corbet@lwn.net>
Subject: Re: [patch 1/7] Documentation: Add license-rules.rst to describe
 how to properly identify file licenses
Message-ID: <20171112130746.607facb6@lwn.net>
In-Reply-To: <20171112192142.525567667@linutronix.de>
References: <20171112191821.240484206@linutronix.de>
        <20171112192142.525567667@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Linus Torvalds <torvalds@linuxfoundation.org>, Andrew Morton <akpm@linuxfoundation.org>, Kate Stewart <kate@linuxfoundation.org>, Philippe Ombredanne <pombredanne@nexb.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Christoph Hellwig <hch@lst.de>, Russell King <rmk+kernel@armlinux.org.uk>, Rob Herring <rob.herring@linaro.org>, Jonas Oberg <jonas@fsfe.org>, Joe Perches <joe@perches.com>, linux-xfs@vger.kernel.org, Kate Stewart <kstewart@linuxfoundation.org>

On Sun, 12 Nov 2017 20:18:22 +0100
Thomas Gleixner <tglx@linutronix.de> wrote:

> Add a file to the Documentation directory to describe how file licenses
> should be described in all kernel files, using the SPDX identifier, as well
> as where all licenses should be in the kernel source tree for people to
> refer to (LICENSES/).

Some nits...somebody's gotta do it...

>  
> --- /dev/null
> +++ b/Documentation/license-rules.rst
> @@ -0,0 +1,310 @@
> +Linux kernel licensing rules
> +============================
> +
> +The Linux Kernel is provided under the terms of the GNU General Public
> +License version 2 only (GPL-2.0), as published by the Free Software
> +Foundation, and provided in the COPYING file.  This documentation file is
> +not meant to replace the COPYING file, but provides a description of how
> +each source file should be annotated to make the licensing it is governed
> +under clear and unambiguous.
> +
> +The license in the COPYING file applies to the kernel source as a whole,
> +though individual source files can have a different license which is
> +required to be compatible with the GPL-2.0:
> +
> +::
> +
> +    GPL-1.0+  :  GNU General Public License v1.0 or later
> +    GPL-2.0+  :  GNU General Public License v2.0 or later
> +    LGPL-2.0  :  GNU Library General Public License v2 only
> +    LGPL-2.0+ :  GNU Library General Public License v2 or later
> +    LGPL-2.1  :  GNU Lesser General Public License v2.1 only
> +    LGPL-2.1+ :  GNU Lesser General Public License v2.1 or later
> +
> +Aside from that, individual files can be provided under a dual license,
> +i.e. one of the compatible GPL variants and alternatively under a
> +permissive license like BSD, MIT etc.
> +
> +The Userspace API (UAPI) header files, which describe the interface of user
> +space programs to the kernel are a special case.  According to the note

comma after "kernel"

> +in the kernel COPYING file the syscall interface is a clear boundary,

comma after "file"

> +which does not extend the GPL requirements to any software which uses
> +them to communicate with the kernel.  Because the UAPI headers must be

which uses *it* (subject is "the syscall interface")

> +includable into any source files which create an executable running on
> +the Linux kernel, the exception must be documented by a special license
> +expression.
> +
> +The common way of expressing the license of a source file is to add the
> +matching boiler plate text into the top comment of the file.  Due to
> +formatting, typos etc.  These "boiler plates" are hard to validate for
> +tools, which are used in the context of license compliance.
> +
> +To avoid license inconsistencies and to help tooling it is required to

I'd grab the comma from after "tools" two lines up and put it after
"tooling" instead.

> +add a Software Package Data Exchange (SPDX) license identifier to each
> +source file.  SPDX license identifiers are machine parsable and precise
> +shorthands for the license under which the content of the file is
> +contributed under.  SPDX license identifiers are managed by the SPDX

This is over-undered.  I'd delete the second 'under'.

> +Workgroup at the Linux Foundation and have been agreed on by partners
> +throughout the industry, tool vendors, and legal teams.  For further
> +information see https://spdx.org/
> +
> +The Linux kernel requires the precise SPDX identifier in all source files.
> +The valid identifiers used in the kernel are described in the section
> +`License identifiers`_ bottom of this file and have been retrieved from the
> +official SPDX license list at https://spdx.org/licenses/
> +
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

So I can't be the only person with nothing better to do than to wonder why
source and header files use a different comment syntax.  Maybe the document
could explain that?

> +    ASM:        /* SPDX-License-Identifier: <SPDX License Expression> */
> +    scripts:    # SPDX-License-Identifier: <SPDX License Expression>
> +
> +If a specific tool cannot handle the standard comment style, then the
> +appropriate comment mechanism which the tool accepts shall be used.
> +
> +An <SPDX License Expression> is either an SPDX short form license
> +identifier found on the SPDX License List, or when multiple licenses
> +apply, an expression consisting of keywords "AND", "OR", and "WITH"
> +separating SPDX short form license identifiers surrounded by "(", ")".
> +
> +License identifiers for licenses like [L]GPL with the 'or later' option
> +are constructed by using a "+" for indicating the 'or later' option.
> +
> +::
> +
> +   // SPDX-License-Identifier: GPL-2.0+
> +   // SPDX-License-Identifier: LGPL-2.1+
> +
> +WITH should be used when there is a modifier to a license needed.
> +For example, the linux kernel UAPI files use the expression:
> +
> +::
> +
> +    // SPDX-License-Identifier: (GPL-2.0 WITH Linux-syscall-note)
> +    // SPDX-License-Identifier: (GPL-2.0+ WITH Linux-syscall-note)
> +
> +Other examples using WITH exceptions found in the kernel are:
> +
> +::
> +
> +    (GPL-2.0 WITH mif-exception)
> +    (GPL-2.0+ WITH GCC-exception-2.0)
> +
> +OR should be used if the file is dual licensed and only one license is
> +to be selected.  For example, some dtsi files are available under dual
> +licenses:

It would be good to document the set of permissible WITH exceptions.  Or
people will surely get creative in making up new ones.

OK, I see that has been done, so amend that comment to suggest a line
saying that the set of exceptions is documented below.

Thanks,

jon
