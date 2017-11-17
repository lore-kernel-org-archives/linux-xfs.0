Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38224 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934362AbdKQI52 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 17 Nov 2017 03:57:28 -0500
Date: Fri, 17 Nov 2017 09:57:31 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [patch 1/7] Documentation: Add license-rules.rst to describe how
 to properly identify file licenses
Message-ID: <20171117085731.GA28421@kroah.com>
References: <20171112191821.240484206@linutronix.de>
 <20171112192142.525567667@linutronix.de>
 <20171116080723.279591c8@lwn.net>
 <20171116151540.GA18500@silk.coyote.org>
 <CAOFm3uFANvJa0yxiKPcR7KER22951+uO8-qez+hKRY9PzzNskw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOFm3uFANvJa0yxiKPcR7KER22951+uO8-qez+hKRY9PzzNskw@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Philippe Ombredanne <pombredanne@nexb.com>
Cc: Jonas Oberg <jonas@fsfe.org>, Jonathan Corbet <corbet@lwn.net>, Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>, Linus Torvalds <torvalds@linuxfoundation.org>, Andrew Morton <akpm@linuxfoundation.org>, Christoph Hellwig <hch@lst.de>, Russell King <rmk+kernel@armlinux.org.uk>, Rob Herring <rob.herring@linaro.org>, Joe Perches <joe@perches.com>, xfs <linux-xfs@vger.kernel.org>, Kate Stewart <kstewart@linuxfoundation.org>

On Fri, Nov 17, 2017 at 08:37:28AM +0100, Philippe Ombredanne wrote:
> Or fix the non-standard redefinition of the MODULE_LICENSE macro as
> DRIVER_LICENSE as in [2]  and found elsewhere with
> grep -r . -e "DRIVER_LICENSE"
> 
> These break the otherwise nicely grepable MODULE_LICENSE macros
> with this kind of warty redirection I stumbled upon while reviewing kernel
> license scans:
> 
> #define DRIVER_LICENSE "GPL"
> [...]
> MODULE_LICENSE(DRIVER_LICENSE);

Yes, those should be cleaned up, there's only 11 instances of them,
should be simple enough to do.  I can knock up a patch series for
them...

thanks,

greg k-h
