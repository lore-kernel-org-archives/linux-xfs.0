Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from www.llwyncelyn.cymru ([82.70.14.225]:40482 "EHLO fuzix.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727630AbeI3UuP (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sun, 30 Sep 2018 16:50:15 -0400
Date: Sun, 30 Sep 2018 15:16:52 +0100
From: Alan Cox <gnomes@lxorguk.ukuu.org.uk>
Subject: Re: Leaking Path in XFS's ioctl interface(missing LSM check)
Message-ID: <20180930151652.6975610c@alans-desktop>
In-Reply-To: <20180927013812.GF31060@dastard>
References: <5EF0D46A-C098-4B51-AD13-225FFCA35D4C@vt.edu>
        <20180926013329.GD31060@dastard>
        <20180926192426.472360ea@alans-desktop>
        <20180927013812.GF31060@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: TongZhang <ztong@vt.edu>, darrick.wong@oracle.com, linux-xfs@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, linux-security-module@vger.kernel.org, Wenbo Shen <shenwenbosmile@gmail.com>

> > CAP_SYS_ADMIN is also a bit weird because low level access usually
> > implies you can bypass access controls so you should also check
> > CAP_SYS_DAC ?  
> 
> Do you mean CAP_DAC_READ_SEARCH as per the newer handle syscalls?
> But that only allows bypassing directory search operations, so maybe
> you mean CAP_DAC_OVERRIDE?

It depends what the ioctl allows you to do. If it allows me to bypass
DAC and manipulate the file system to move objects around then it's a
serious issue.

The underlying problem is if CAP_SYS_ADMIN is able to move objects around
then I can move modules around. We already have a problem with
CAP_DAC_OVERRIDE giving you CAP_SYS_RAWIO (ie totally owning the machine)
unless the modules are signed, if xfs allows ADMIN as well then
CAP_SYS_ADMIN is much easier to obtain and you'd get total system
ownership from it.

Not good.

> Regardless, this horse bolted long before those syscalls were
> introduced.  The time to address this issue was when XFS was merged
> into linux all those years ago, back when the apps that run in
> highly secure restricted environments that use these interfaces were
> being ported to linux. We can't change this now without breaking
> userspace....

That's what people said about setuid shell scripts.

I'd like to understand better what can be done. We can argue afterwards
about what if anything to do about it and if it is possible to abuse it.

Alan
