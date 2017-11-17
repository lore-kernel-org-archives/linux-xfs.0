Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from Galois.linutronix.de ([146.0.238.70]:49763 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751601AbdKQJtF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 17 Nov 2017 04:49:05 -0500
Date: Fri, 17 Nov 2017 10:48:57 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch V3 01/11] Documentation: Add license-rules.rst to describe
 how to properly identify file licenses
In-Reply-To: <20171116135730.265a8323@lwn.net>
Message-ID: <alpine.DEB.2.20.1711171040290.1709@nanos>
References: <20171116183306.103584007@linutronix.de> <20171116184358.398030394@linutronix.de> <20171116135730.265a8323@lwn.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jonathan Corbet <corbet@lwn.net>
Cc: LKML <linux-kernel@vger.kernel.org>, Linus Torvalds <torvalds@linuxfoundation.org>, Andrew Morton <akpm@linuxfoundation.org>, Kate Stewart <kstewart@linuxfoundation.org>, Philippe Ombredanne <pombredanne@nexb.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Christoph Hellwig <hch@lst.de>, Russell King <rmk+kernel@armlinux.org.uk>, Rob Herring <rob.herring@linaro.org>, Jonas Oberg <jonas@fsfe.org>, Joe Perches <joe@perches.com>, linux-xfs@vger.kernel.org, Charlemagne Lasse <charlemagnelasse@gmail.com>, Carmen Bianca Bakker <carmenbianca@fsfe.org>

On Thu, 16 Nov 2017, Jonathan Corbet wrote:

> The following is all extreme nits; you can ignore all of it and the file
> will be just fine.

No.

> I assume you're planning to merge this directly with the rest; feel free to
> add my ack if that's worth anything.  If you want me to take it, instead,
> just let me know.

Ok.

> On Thu, 16 Nov 2017 19:33:07 +0100
> > +The following describes the license of the Linux kernel source code
> > +(GPLv2), how to properly mark the license of individual files in the source
> > +tree, as well as links to the full license text.
> > +
> > +.. toctree::
> > +   :maxdepth: 2
> > +
> > +   process/license-rules.rst
> > +
> 
> I'll confess that I'm not convinced that information on license identifiers
> is the very first thing readers should encounter when entering the kernel's
> documentation.  But I'll not quibble about it for now, we can always move
> it later :)

Any suggestions for a better place?

> > +The license in the COPYING file applies to the kernel source as a whole,
> > +though individual source files can have a different license which is
> > +required to be compatible with the GPL-2.0:
> > +
> > +::
> 
> So this sort of construction (line ending with colon followed by a literal
> block) can also be done like this:
> 
> 	required to be compatible with the GPL-2.0::
> 
>     		GPL-1.0+  :  GNU General Public License v1.0 or later
> 		GPL-2.0+  :  GNU General Public License v2.0 or later
> 
> (i.e. just put the "::" at the end of the text line).  The end result is
> the same, but the source document is a bit more compact and less
> alien-looking.  If you concur, there's lots of places that could be fixed
> up this way.

Done. Thanks for the free rst training!

> > +Aside from that, individual files can be provided under a dual license,
> > +i.e. one of the compatible GPL variants and alternatively under a
> > +permissive license like BSD, MIT etc.
> 
> Wanna see now nitly I can get?  "i.e." ("id est") is an identity mapping;
> you want "e.g." here.

Right you are.

> > +
> > +The Userspace API (UAPI) header files, which describe the interface of user
> > +space programs to the kernel are a special case.  According to the note
> 
> I might suggest being consistent between "userspace" and "user space" (or
> "user-space" as an adjective).  I prefer the latter, but that's just me.

Done

> > +in the kernel COPYING file the syscall interface is a clear boundary,
> 
> comma after "file"

Correctly placing commatas was never one of my key skills and I fear this
will persist.

> > +which does not extend the GPL requirements to any software which uses
> > +it to communicate with the kernel.  Because the UAPI headers must be
> > +includable into any source files which create an executable running on
> > +the Linux kernel, the exception must be documented by a special license
> > +expression.
> > +
> > +The common way of expressing the license of a source file is to add the
> > +matching boiler plate text into the top comment of the file.  Due to
> > +formatting, typos etc. these "boiler plates" are hard to validate for
> > +tools which are used in the context of license compliance.
> > +
> > +To avoid license inconsistencies and to help tooling, it is required to add
> > +a Software Package Data Exchange (SPDX) license identifier to each source
> > +file.  SPDX license identifiers are machine parsable and precise shorthands
> > +for the license under which the content of the file is contributed.  SPDX
> > +license identifiers are managed by the SPDX Workgroup at the Linux
> > +Foundation and have been agreed on by partners throughout the industry,
> > +tool vendors, and legal teams.  For further information see
> > +https://spdx.org/
> > +
> > +The Linux kernel requires the precise SPDX identifier in all source files.
> 
> This is redundant with the first line of the previous paragraph.  I'd fix
> it by keeping the first paragraph true to its topic of introducing SPDX and
> replacing its first line with something like:
> 
> 	An alternative to boilerplate text is the use of Software Package
> 	Data Exchange (SPDX) license identifiers in each source file.

Indeed.

> > +The valid identifiers used in the kernel are explained in the section
> > +`License identifiers`_ and have been retrieved from the official SPDX
> > +license list at https://spdx.org/licenses/ along with the license texts.
> 
> [...]
> 
> > +License identifiers
> > +-------------------
> > +
> > +The licenses currently used, as well as the licenses for code added to the
> > +kernel can be broken down into:
> 
> comma after "kernel"
> 
> [ran out of things to quibble about here]

Phew :)

Thanks for looking at it!

       tglx
