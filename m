Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ms.lwn.net ([45.79.88.28]:41322 "EHLO ms.lwn.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934397AbdKPPHZ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 16 Nov 2017 10:07:25 -0500
Date: Thu, 16 Nov 2017 08:07:23 -0700
From: Jonathan Corbet <corbet@lwn.net>
Subject: Re: [patch 1/7] Documentation: Add license-rules.rst to describe
 how to properly identify file licenses
Message-ID: <20171116080723.279591c8@lwn.net>
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

> --- /dev/null
> +++ b/Documentation/license-rules.rst
> @@ -0,0 +1,310 @@
> +Linux kernel licensing rules
> +============================
> +
> +The Linux Kernel is provided under the terms of the GNU General Public
> +License version 2 only (GPL-2.0), as published by the Free Software
> +Foundation, and provided in the COPYING file.  This documentation file is

One other thing that occurred to me is that documentation files, too,
are copyrightable and should have license identifiers.  So maybe the
documentation on these identifiers should set a good example :)  The RST
version would be:

	.. SPDX-License-Identifier: GPL-2.0

I'll try to find some time to start fixing up Documentation/ in general.

jon
