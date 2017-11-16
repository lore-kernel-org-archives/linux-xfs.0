Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:53872 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753346AbdKPTpR (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 16 Nov 2017 14:45:17 -0500
Received: from mail-wm0-f46.google.com (mail-wm0-f46.google.com [74.125.82.46])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 257E62197A
        for <linux-xfs@vger.kernel.org>; Thu, 16 Nov 2017 19:45:16 +0000 (UTC)
Received: by mail-wm0-f46.google.com with SMTP id y80so2432266wmd.0
        for <linux-xfs@vger.kernel.org>; Thu, 16 Nov 2017 11:45:16 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20171116184358.398030394@linutronix.de>
References: <20171116183306.103584007@linutronix.de> <20171116184358.398030394@linutronix.de>
From: Rob Herring <robh@kernel.org>
Date: Thu, 16 Nov 2017 13:44:54 -0600
Message-ID: <CABGGiszKA_AwmoYC=og3XdSA0rCuC+a1bpFC6oyKzaZXCKq8Aw@mail.gmail.com>
Subject: Re: [patch V2 01/11] Documentation: Add license-rules.rst to describe
 how to properly identify file licenses
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Linus Torvalds <torvalds@linuxfoundation.org>, Andrew Morton <akpm@linuxfoundation.org>, Jonathan Corbet <corbet@lwn.net>, Kate Stewart <kate@linuxfoundation.org>, Philippe Ombredanne <pombredanne@nexb.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Christoph Hellwig <hch@lst.de>, Russell King <rmk+kernel@armlinux.org.uk>, Jonas Oberg <jonas@fsfe.org>, Joe Perches <joe@perches.com>, linux-xfs@vger.kernel.org, Charlemagne Lasse <charlemagnelasse@gmail.com>, Carmen Bianca Bakker <carmenbianca@fsfe.org>

On Thu, Nov 16, 2017 at 12:33 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
> Add a file to the Documentation directory to describe how file licenses
> should be described in all kernel files, using the SPDX identifier, as well
> as where all licenses should be in the kernel source tree for people to
> refer to (LICENSES/).
>
> Thanks to Kate and Greg for review and editing and Jonas for the
> suggestions concerning the meta tags in the licenses files.
>
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> ---

[...]

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
> +      .rst:      .. SPDX-License-Identifier: <SPDX License Expression>

.dts{i}  // SPDX-License-Identifier: <SPDX License Expression>

Or use "DT source"

Rob
