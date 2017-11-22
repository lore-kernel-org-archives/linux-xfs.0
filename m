Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47678 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751651AbdKVRxm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 22 Nov 2017 12:53:42 -0500
Date: Wed, 22 Nov 2017 18:53:46 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: WTF? Re: [PATCH] License cleanup: add SPDX GPL-2.0 license
 identifier to files with no license
Message-ID: <20171122175346.GB6528@kroah.com>
References: <20171107020607.GA26910@magnolia>
 <20171107072040.GB4586@infradead.org>
 <20171107073940.GB4654@kroah.com>
 <20171107172042.GB26910@magnolia>
 <20171107182903.GA4588@kroah.com>
 <20171107184658.56b87d41@alans-desktop>
 <20171107191526.x3rzfcnnlmaz264d@thunk.org>
 <20171107192846.GA24617@infradead.org>
 <CAOFm3uFLRCZwtw4F884Rd=5=yZnX_ibzBzyiC4f+=5iju4k81Q@mail.gmail.com>
 <20171122170713.GD12684@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171122170713.GD12684@amd>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Pavel Machek <pavel@ucw.cz>
Cc: Philippe Ombredanne <pombredanne@nexb.com>, Christoph Hellwig <hch@infradead.org>, Theodore Ts'o <tytso@mit.edu>, Alan Cox <gnomes@lxorguk.ukuu.org.uk>, "Darrick J. Wong" <darrick.wong@oracle.com>, Eric Sandeen <sandeen@redhat.com>, xfs <linux-xfs@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Kate Stewart <kstewart@linuxfoundation.org>

On Wed, Nov 22, 2017 at 06:07:13PM +0100, Pavel Machek wrote:
> Lets look at random file in usb:
> 
> // SPDX-License-Identifier: GPL-2.0+
> /*
>  * Driver for SMSC USB3503 USB 2.0 hub controller driver
>  *
>  * Copyright (c) 2012-2013 Dongjin Kim (tobetter@gmail.com)
>  */
> ...
> MODULE_LICENSE("GPL");
> 
> ...do we agree that this is nowhere near distration-free? Ugly //
> comment that screams for attention, away from other copyright info, it
> hurts your eyes...
> 
> This would be improvement:
> 
> /*
>  * Driver for SMSC USB3503 USB 2.0 hub controller driver
>  *
>  * Copyright (c) 2012-2013 Dongjin Kim (tobetter@gmail.com)
>  *
>  * SPDX-License-Identifier: GPL-2.0+
>  */
> 
> ...but what is above is just uuuugly.
> 
> ...as is MODULE_LICENSE having completely different tags from SPDX.
> 
> This would be even better:
> 
> /*
>  * Driver for SMSC USB3503 USB 2.0 hub controller driver
>  *
>  * Copyright (c) 2012-2013 Dongjin Kim (tobetter@gmail.com)
>  */
> ...
> SPDX_MODULE_LICENSE("GPL-2.0+")
> 
> So yes, SPDX can be improvement. But in current implementation it is
> not.

Again, as people seem to keep still missing this point, Linus asked for
the format to look like it does today, using // at the top.  Thomas and
I originally did it first the way with the SPDX line in the big comment
block.

If you don't like the format, complain and convince him otherwise, you
are not getting anywhere by responding to this old topic about it
again.

Having it be the first line of the file is good, it's obvious, and
stands out, which is the point, you want it to, it's a license :)

thanks,

greg k-h
