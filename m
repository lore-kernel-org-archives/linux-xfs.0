Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41284 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752419AbdKQKH2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 17 Nov 2017 05:07:28 -0500
Date: Fri, 17 Nov 2017 11:07:32 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [patch V2 01/11] Documentation: Add license-rules.rst to
 describe how to properly identify file licenses
Message-ID: <20171117100732.GA14762@kroah.com>
References: <20171116183306.103584007@linutronix.de>
 <20171116184358.398030394@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171116184358.398030394@linutronix.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Linus Torvalds <torvalds@linuxfoundation.org>, Andrew Morton <akpm@linuxfoundation.org>, Jonathan Corbet <corbet@lwn.net>, Kate Stewart <kate@linuxfoundation.org>, Philippe Ombredanne <pombredanne@nexb.com>, Christoph Hellwig <hch@lst.de>, Russell King <rmk+kernel@armlinux.org.uk>, Rob Herring <rob.herring@linaro.org>, Jonas Oberg <jonas@fsfe.org>, Joe Perches <joe@perches.com>, linux-xfs@vger.kernel.org, Charlemagne Lasse <charlemagnelasse@gmail.com>, Carmen Bianca Bakker <carmenbianca@fsfe.org>

On Thu, Nov 16, 2017 at 07:33:07PM +0100, Thomas Gleixner wrote:
> +2. Style:
> +
> +   The SPDX license identifier is added in form of a comment.  The comment
> +   style depends on the file type:
> +
> +   ::
> +
> +      C source:   // SPDX-License-Identifier: <SPDX License Expression>
> +      C header:   /* SPDX-License-Identifier: <SPDX License Expression> */
> +      ASM:        /* SPDX-License-Identifier: <SPDX License Expression> */
> +      scripts:    # SPDX-License-Identifier: <SPDX License Expression>
> +      .rst:	  .. SPDX-License-Identifier: <SPDX License Expression>

Minor nit, do you want a tab there on the .rst line or should it be all
spaces like the other lines above it to make things line up properly?

Otherwise, looks great to me:

	Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

