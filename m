Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from smtprelay0103.hostedemail.com ([216.40.44.103]:57978 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751097AbdKYV5i (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 25 Nov 2017 16:57:38 -0500
Message-ID: <1511647053.2503.22.camel@perches.com>
Subject: Re: WTF? Re: [PATCH] License cleanup: add SPDX GPL-2.0 license
 identifier to files with no license
From: Joe Perches <joe@perches.com>
Date: Sat, 25 Nov 2017 13:57:33 -0800
In-Reply-To: <20171125191223.GC5114@amd>
References: <20171107072040.GB4586@infradead.org>
         <20171107073940.GB4654@kroah.com> <20171107172042.GB26910@magnolia>
         <20171107182903.GA4588@kroah.com> <20171107184658.56b87d41@alans-desktop>
         <20171107191526.x3rzfcnnlmaz264d@thunk.org>
         <20171107192846.GA24617@infradead.org>
         <CAOFm3uFLRCZwtw4F884Rd=5=yZnX_ibzBzyiC4f+=5iju4k81Q@mail.gmail.com>
         <20171122170713.GD12684@amd> <20171122175346.GB6528@kroah.com>
         <20171125191223.GC5114@amd>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Pavel Machek <pavel@ucw.cz>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: Philippe Ombredanne <pombredanne@nexb.com>, Christoph Hellwig <hch@infradead.org>, Theodore Ts'o <tytso@mit.edu>, Alan Cox <gnomes@lxorguk.ukuu.org.uk>, "Darrick J. Wong" <darrick.wong@oracle.com>, Eric Sandeen <sandeen@redhat.com>, xfs <linux-xfs@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Kate Stewart <kstewart@linuxfoundation.org>

On Sat, 2017-11-25 at 20:12 +0100, Pavel Machek wrote:
> [Linus Torvalds...]
> > Having it be the first line of the file is good, it's obvious, and
> > stands out, which is the point, you want it to, it's a license :)
> 
> What is good about that? License is about the least interesting thing
> about the file. Point of SPDX conversion (see the mail I was replying
> to?) was to make license information _less_ intrusive, not more. Tools
> can find SPDX anywhere in the file for the people that really care.
> 
> That's how it works in U-Boot, which people are using as example of
> reasonable SPDX conversion:
> 
> /*
>  * Copyright (c) 2012 The Chromium OS Authors. All rights reserved.
>  * Copyright (c) 2010-2011 NVIDIA Corporation
>  *  NVIDIA Corporation <www.nvidia.com>
>  *
>  * SPDX-License-ers/ d

> .c:     GPL-2.0+
>  */

fwiw: I agree with Pavel.

My preferred header listing order:

// Simple description/purpose
// Copyright/Author
// License


