Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:34510 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751745AbeD2F0c (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sun, 29 Apr 2018 01:26:32 -0400
Date: Sun, 29 Apr 2018 07:26:17 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: LICENSES: Missing ISC text & possibly a category ("Not
 recommended" vs. "Preferred licenses")
Message-ID: <20180429052617.GC24294@kroah.com>
References: <CACna6rz_Ms2Uv1P6E0gCGNsRwK4nm=PMAOaJ5Uk9aJxs2VSamQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACna6rz_Ms2Uv1P6E0gCGNsRwK4nm=PMAOaJ5Uk9aJxs2VSamQ@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>, Jonathan Corbet <corbet@lwn.net>, DOCUMENTATION <linux-doc@vger.kernel.org>, Linus Torvalds <torvalds@linuxfoundation.org>, Andrew Morton <akpm@linuxfoundation.org>, Kate Stewart <kate@linuxfoundation.org>, Philippe Ombredanne <pombredanne@nexb.com>, Christoph Hellwig <hch@lst.de>, Russell King <rmk+kernel@armlinux.org.uk>, Rob Herring <rob.herring@linaro.org>, Jonas Oberg <jonas@fsfe.org>, Joe Perches <joe@perches.com>, linux-xfs@vger.kernel.org, Kate Stewart <kstewart@linuxfoundation.org>, Florian Fainelli <f.fainelli@gmail.com>

On Sat, Apr 28, 2018 at 11:25:17PM +0200, Rafał Miłecki wrote:
> Hi,
> 
> Due to some maintainers *preferring* BSD-compatible license for DTS
> files [0], I was writing mine using ISC. I had no very special reason
> for it: I was choosing between BSD-2-Clause, MIT and ISC. I've chosen
> ISC as I read about its "removal of language deemed unnecessary".
> 
> I took a moment to look at the new SPDX thing and noticed that:
> 1) File license-rules.rst provides "LICENSES/other/ISC" as an example

Yeah, bad example, we should fix that text up.  Care to send a patch? :)

> 2) License file LICENSES/other/ISC doesn't exist
> 3) ISC is listed as an *example* under the "Not recommended licenses"

Yes, please don't use it if at all possible.

> First of all, as ISC is used by some files in the Linux kernel, I
> think it's worth adding to the LICENSE/*/ISC.

I see it is only used in a very small number of dts files.  Why not just
use BSD-2-Clause instead?  What do you find in ISC that is not available
to you with just BSD?

> Secondly, it isn't 100% clear to me if ISC is preferred or not
> recommended. File license-rules.rst suggests the later by listing it
> as an example for "Not recommended". It's just an example though, so
> I'm not 100% sure without seeing it in either: "preferred" or "other"
> directories. Also if anyone finds it "Not recommended", can we get a
> short explanation why is it so, please?

The license is functionally equalivant to BSD-2, so why would you want
to add more complexity here and have two licenses that are the same be
"recommended"?

thanks,

greg k-h
