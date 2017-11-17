Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from Galois.linutronix.de ([146.0.238.70]:51693 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751436AbdKQSLx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 17 Nov 2017 13:11:53 -0500
Date: Fri, 17 Nov 2017 19:11:41 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch V4 01/11] Documentation: Add license-rules.rst to describe
 how to properly identify file licenses
In-Reply-To: <20171117150639.0e706421@vento.lan>
Message-ID: <alpine.DEB.2.20.1711171850330.2186@nanos>
References: <20171116183306.103584007@linutronix.de> <20171116184358.398030394@linutronix.de> <alpine.DEB.2.20.1711171057240.1709@nanos> <20171117150639.0e706421@vento.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Linus Torvalds <torvalds@linuxfoundation.org>, Andrew Morton <akpm@linuxfoundation.org>, Jonathan Corbet <corbet@lwn.net>, Kate Stewart <kstewart@linuxfoundation.org>, Philippe Ombredanne <pombredanne@nexb.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Christoph Hellwig <hch@lst.de>, Russell King <rmk+kernel@armlinux.org.uk>, Rob Herring <rob.herring@linaro.org>, Jonas Oberg <jonas@fsfe.org>, Joe Perches <joe@perches.com>, linux-xfs@vger.kernel.org, Charlemagne Lasse <charlemagnelasse@gmail.com>, Carmen Bianca Bakker <carmenbianca@fsfe.org>

Mauro,

On Fri, 17 Nov 2017, Mauro Carvalho Chehab wrote:
> Em Fri, 17 Nov 2017 11:00:33 +0100 (CET)
> Thomas Gleixner <tglx@linutronix.de> escreveu:
> 
> > Subject: Documentation: Add license-rules.rst to describe how to properly identify file licenses
> > From: Thomas Gleixner <tglx@linutronix.de>
> > Date: Fri, 10 Nov 2017 09:30:00 +0100
> > 
> > Add a file to the Documentation directory to describe how file licenses
> > should be described in all kernel files, using the SPDX identifier, as well
> > as where all licenses should be in the kernel source tree for people to
> > refer to (LICENSES/).
> > 
> > Thanks to Kate, Greg and Jonathan for review and editing and Jonas for the
> > suggestions concerning the meta tags in the licenses files.
> > 
> > Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> 
> The document itself looks good, but I think it should also mention
> what would be the expected values for the MODULE_LICENSE() macro and
> how each license would be mapped into it.
> 
> Right now, include/linux/module.h says:
> 
> /*
>  * The following license idents are currently accepted as indicating free
>  * software modules
>  *
>  *	"GPL"				[GNU Public License v2 or later]
>  *	"GPL v2"			[GNU Public License v2]
>  *	"GPL and additional rights"	[GNU Public License v2 rights and more]
>  *	"Dual BSD/GPL"			[GNU Public License v2
>  *					 or BSD license choice]
>  *	"Dual MIT/GPL"			[GNU Public License v2
>  *					 or MIT license choice]
>  *	"Dual MPL/GPL"			[GNU Public License v2
>  *					 or Mozilla license choice]
>  *
>  * The following other idents are available
>  *
>  *	"Proprietary"			[Non free products]
>  *
>  * There are dual licensed components, but when running with Linux it is the
>  * GPL that is relevant so this is a non issue. Similarly LGPL linked with GPL
>  * is a GPL combined work.
>  *
>  * This exists for several reasons
>  * 1.	So modinfo can show license info for users wanting to vet their setup
>  *	is free
>  * 2.	So the community can ignore bug reports including proprietary modules
>  * 3.	So vendors can do likewise based on their own policies
>  */
> #define MODULE_LICENSE(_license) MODULE_INFO(license, _license)
> 
> In thesis, for every SPDX property at C or assembler files, we should have
> a mapping into one of those MODULE_LICENSE().

I know. This is on the list of things which need to be addressed. The
module license tags are a mess on their own and I have yet to come up with
something smart to make this consistent.

Whatever I came up with so far requires postprocessing.

For files which have MODULE_LICENSE("...."):

   1) Grab the SPDX identifier from the source file

   2) Check whether the module license string is matching the SPDX license
      id. This is limited because the module license strings are pretty
      restricted.

   2) Store the SPDX license id string in a separate module info variable

Introcude a MODULE_LICENSE_SPDX macro which flags the module info storage
as 'SPDXIFY' and let the postprocessor do:

   1) Grab the SPDX identifier from the source file

   2) Map it to the "known" module license string and store both in module
      info.

That way tools can get access to the SPDX identifier and start to support it.

I refrained from documenting anything in that area yet, because we really
need to sit down and figure out a solution first.

It's on that huge thingy which is append only, aka. todo list.

Thanks,

	tglx
