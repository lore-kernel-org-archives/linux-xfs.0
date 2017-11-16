Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ul.coyote.org ([198.50.187.229]:51205 "EHLO ul.coyote.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751086AbdKPL4P (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 16 Nov 2017 06:56:15 -0500
Date: Thu, 16 Nov 2017 12:46:39 +0100
From: Jonas Oberg <jonas@fsfe.org>
Subject: Re: [patch 2/7] LICENSES: Add the GPL 2.0 license
Message-ID: <20171116114639.GA16946@silk.coyote.org>
References: <20171112191821.240484206@linutronix.de>
 <20171112192142.614461013@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20171112192142.614461013@linutronix.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Linus Torvalds <torvalds@linuxfoundation.org>, Andrew Morton <akpm@linuxfoundation.org>, Jonathan Corbet <corbet@lwn.net>, Kate Stewart <kate@linuxfoundation.org>, Philippe Ombredanne <pombredanne@nexb.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Christoph Hellwig <hch@lst.de>, Russell King <rmk+kernel@armlinux.org.uk>, Rob Herring <rob.herring@linaro.org>, Joe Perches <joe@perches.com>, linux-xfs@vger.kernel.org, Kate Stewart <kstewart@linuxfoundation.org>

Hi Thomas,

I do appreciate your work on this, it's a welcome addition!

> +SPDX-License-Identifier: GPL-2.0  // GPLv2 only
> +SPDX-License-Identifier: GPL-2.0+ // GPLv2 or later

I am concerned about this though, as the SPDX-License-Identifier is well
known to refer to the license of the document in which it appears, and
it would be beneficial to avoid a situation where a tool reading this
make the assumption the license text itself it under a particular
license. Essentially, let's avoid overloading if we can.

>From my reading, there are two intentions with the above reading:

 1) To give usage guidelines and signal that for any source file, adding
    this exact line would be a valid license identifier, and
 2) To make the license identifiers computer understandable such that
    tools can be updated to validate whether source code includes a
    license identifier which corresponds to one of the licenses in
    LICENSES/

I'd propose to not try to do both at the same time and would propose
a 'Valid-License-Identifier' tag to meet your second criteria, and
a 'Usage-Guidance' tag to meet your first one. The header would then
be:

Valid-License-Identifier: GPL-2.0
Valid-License-Identifier: GPL-2.0+
Usage-Guidance:
 To use this license in source code, you can use either of the following tags
 and values:
 .
 SPDX-License-Identifier: GPL-2.0   // For GPLv2 only
 SPDX-License-Identifier: GPL-2.0+  // For GPLv2 or any later version


Best,

-- 
Jonas Öberg
Executive Director

FSFE e.V. - keeping the power of technology in your hands. Your
support enables our work, please join us today http://fsfe.org/join
