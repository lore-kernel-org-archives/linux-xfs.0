Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ul.coyote.org ([198.50.187.229]:38655 "EHLO ul.coyote.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751496AbdKUIgS (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 21 Nov 2017 03:36:18 -0500
Date: Tue, 21 Nov 2017 09:27:28 +0100
From: Jonas Oberg <jonas@fsfe.org>
Subject: Re: [patch V2 02/11] LICENSES: Add the GPL 2.0 license
Message-ID: <20171121082728.GD6859@silk.coyote.org>
References: <20171116183306.103584007@linutronix.de>
 <20171116184358.475929943@linutronix.de>
 <CAFGhKbxbW87yowc7trkiczjXV=37SqswwmOriTdSoxCXzFk-0A@mail.gmail.com>
 <CA+55aFz06uWZwjdgod4wd=dCY3wbU+4SdbhgNwsNzMFqUn2SiA@mail.gmail.com>
 <20171120153105.38d2b892@alans-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20171120153105.38d2b892@alans-desktop>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Alan Cox <gnomes@lxorguk.ukuu.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Charlemagne Lasse <charlemagnelasse@gmail.com>, Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@linuxfoundation.org>, Jonathan Corbet <corbet@lwn.net>, Kate Stewart <kstewart@linuxfoundation.org>, Philippe Ombredanne <pombredanne@nexb.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Christoph Hellwig <hch@lst.de>, Russell King <rmk+kernel@armlinux.org.uk>, Rob Herring <rob.herring@linaro.org>, Joe Perches <joe@perches.com>, linux-xfs <linux-xfs@vger.kernel.org>, Carmen Bianca Bakker <carmenbianca@fsfe.org>

Hi Alan,

> Which raises another question. If there are multiple GPL 2.0 texts which
> are *supposedly* legally identical but this has never been tested in law
> -that implies SPDX is wrong in tagging them identically in case they turn
> out not to be...

For the cases, and the differences we're talking about now, I believe the
current approach is fine. In the general case though, the FSFE's REUSE
recommendations are that for situations where the license in use differ
from the one included in SPDX, you make use of a local reference to the
license file instead of the SPDX identifier.

This is sometimes the case with the umpteen versions of the BSD licenses.
The way we recommend doing this is you define an identifier of the form
LicenseRef-<unique_code> (consistent with the SPDX specification).
Source code files would be marked up with:

   SPDX-License-Identifier: LicenseRef-MyBSD4

and the corresponding license file in LICENSES/ with:

   Valid-License-Identifier: LicenseRef-MyBSD4
   License-Text:
     ...


Best,

-- 
Jonas Öberg
Executive Director

FSFE e.V. - keeping the power of technology in your hands. Your
support enables our work, please join us today http://fsfe.org/join
