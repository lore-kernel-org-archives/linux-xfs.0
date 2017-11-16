Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from Galois.linutronix.de ([146.0.238.70]:45887 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S964791AbdKPNM3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Nov 2017 08:12:29 -0500
Date: Thu, 16 Nov 2017 14:12:19 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch 2/7] LICENSES: Add the GPL 2.0 license
In-Reply-To: <20171116114639.GA16946@silk.coyote.org>
Message-ID: <alpine.DEB.2.20.1711161410150.2191@nanos>
References: <20171112191821.240484206@linutronix.de> <20171112192142.614461013@linutronix.de> <20171116114639.GA16946@silk.coyote.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jonas Oberg <jonas@fsfe.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Linus Torvalds <torvalds@linuxfoundation.org>, Andrew Morton <akpm@linuxfoundation.org>, Jonathan Corbet <corbet@lwn.net>, Kate Stewart <kate@linuxfoundation.org>, Philippe Ombredanne <pombredanne@nexb.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Christoph Hellwig <hch@lst.de>, Russell King <rmk+kernel@armlinux.org.uk>, Rob Herring <rob.herring@linaro.org>, Joe Perches <joe@perches.com>, linux-xfs@vger.kernel.org, Kate Stewart <kstewart@linuxfoundation.org>

Jonas,

On Thu, 16 Nov 2017, Jonas Oberg wrote:

> Hi Thomas,
> 
> I do appreciate your work on this, it's a welcome addition!
> 
> > +SPDX-License-Identifier: GPL-2.0  // GPLv2 only
> > +SPDX-License-Identifier: GPL-2.0+ // GPLv2 or later
> 
> I am concerned about this though, as the SPDX-License-Identifier is well
> known to refer to the license of the document in which it appears, and
> it would be beneficial to avoid a situation where a tool reading this
> make the assumption the license text itself it under a particular
> license. Essentially, let's avoid overloading if we can.

Makes sense

> >From my reading, there are two intentions with the above reading:
> 
>  1) To give usage guidelines and signal that for any source file, adding
>     this exact line would be a valid license identifier, and
>  2) To make the license identifiers computer understandable such that
>     tools can be updated to validate whether source code includes a
>     license identifier which corresponds to one of the licenses in
>     LICENSES/
> 
> I'd propose to not try to do both at the same time and would propose
> a 'Valid-License-Identifier' tag to meet your second criteria, and
> a 'Usage-Guidance' tag to meet your first one. The header would then
> be:
> 
> Valid-License-Identifier: GPL-2.0
> Valid-License-Identifier: GPL-2.0+
> Usage-Guidance:
>  To use this license in source code, you can use either of the following tags
>  and values:
>  .
>  SPDX-License-Identifier: GPL-2.0   // For GPLv2 only
>  SPDX-License-Identifier: GPL-2.0+  // For GPLv2 or any later version

I can live with that.

Thanks for looking over this!

       tglx
