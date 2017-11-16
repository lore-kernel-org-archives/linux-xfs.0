Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from Galois.linutronix.de ([146.0.238.70]:47703 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934573AbdKPTNs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Nov 2017 14:13:48 -0500
Message-Id: <20171116183306.103584007@linutronix.de>
Date: Thu, 16 Nov 2017 19:33:06 +0100
From: Thomas Gleixner <tglx@linutronix.de>
Subject: [patch V2 00/11] LICENSES: Add documentation and initial License files
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: LKML <linux-kernel@vger.kernel.org>
Cc: Linus Torvalds <torvalds@linuxfoundation.org>, Andrew Morton <akpm@linuxfoundation.org>, Jonathan Corbet <corbet@lwn.net>, Kate Stewart <kate@linuxfoundation.org>, Philippe Ombredanne <pombredanne@nexb.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Christoph Hellwig <hch@lst.de>, Russell King <rmk+kernel@armlinux.org.uk>, Rob Herring <rob.herring@linaro.org>, Jonas Oberg <jonas@fsfe.org>, Joe Perches <joe@perches.com>, linux-xfs@vger.kernel.org, Charlemagne Lasse <charlemagnelasse@gmail.com>, Carmen Bianca Bakker <carmenbianca@fsfe.org>

This is the second version of the licensing rules documentation.

Changes since v1 [1]:

 - Addressing the review comments from Jon, Joe and Jonas:

   - Moved the documentation file into Documentation/process, but kept the
     topic entry in the top level index file so it stands out. (Joe)

   - Changed the license file metatags so they are not overloading
     SPDX-License-Identifier (Jonas)

   - Cleaned up the inconsistencies in the document (Jon, Joe)

   - Added the comment style fior .rst files (Jon)

 - Added a few more links and cursed restructured text to make it render
   halfways sensible.

 - Added the license files for the SPDX tags which are already in tree and
   moved GPL-1.0 to the 'other' directory as it really does not belong into
   the preferrred category.

 - Removed the Reviewed-by tags as they not longer apply. 

Please go over it with a fine comb again. I'm sure that I screwed up
something on the way, but me staring more at it doesn't help.

Thanks to everyone who provided input!

It turned out that the original approach was incidentaly close to what the
FSFE REUSE initiative docuemented and I think we are now nearing the point
where we can wear the REUSE sticker if Jonas does not find any other holes
in it. :)

Thanks,

	tglx


[1] https://lkml.kernel.org/r/20171112191821.240484206@linutronix.de


