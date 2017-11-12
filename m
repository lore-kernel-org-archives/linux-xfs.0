Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from smtprelay0055.hostedemail.com ([216.40.44.55]:55862 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1750977AbdKLUEY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 12 Nov 2017 15:04:24 -0500
Received: from smtprelay.hostedemail.com (10.5.19.251.rfc1918.com [10.5.19.251])
        by smtpgrave05.hostedemail.com (Postfix) with ESMTP id DE88E18289F7F
        for <linux-xfs@vger.kernel.org>; Sun, 12 Nov 2017 19:54:39 +0000 (UTC)
Message-ID: <1510516474.10883.59.camel@perches.com>
Subject: Re: [patch 1/7] Documentation: Add license-rules.rst to describe
 how to properly identify file licenses
From: Joe Perches <joe@perches.com>
Date: Sun, 12 Nov 2017 11:54:34 -0800
In-Reply-To: <20171112192142.525567667@linutronix.de>
References: <20171112191821.240484206@linutronix.de>
         <20171112192142.525567667@linutronix.de>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>
Cc: Linus Torvalds <torvalds@linuxfoundation.org>, Andrew Morton <akpm@linuxfoundation.org>, Jonathan Corbet <corbet@lwn.net>, Kate Stewart <kate@linuxfoundation.org>, Philippe Ombredanne <pombredanne@nexb.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Christoph Hellwig <hch@lst.de>, Russell King <rmk+kernel@armlinux.org.uk>, Rob Herring <rob.herring@linaro.org>, Jonas Oberg <jonas@fsfe.org>, linux-xfs@vger.kernel.org, Kate Stewart <kstewart@linuxfoundation.org>

On Sun, 2017-11-12 at 20:18 +0100, Thomas Gleixner wrote:
> Add a file to the Documentation directory to describe how file licenses
> should be described in all kernel files, using the SPDX identifier, as well
> as where all licenses should be in the kernel source tree for people to
> refer to (LICENSES/).
> 
> Thanks to Kate, Philippe and Greg for review and editing!
p[
> --- /dev/null
> +++ b/Documentation/license-rules.rst
[]
> +The common way of expressing the license of a source file is to add the
> +matching boiler plate text into the top comment of the file.  Due to
> +formatting, typos etc.  These "boiler plates" are hard to validate for
> +tools, which are used in the context of license compliance.

There is bad sentence construction here and it is a
little difficult to parse what is intended.

"These" should not be capitalized.

This SPDX info should also be place in the Documentation/process
content somewhere.

