Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4084CC433F5
	for <linux-xfs@archiver.kernel.org>; Sat, 20 Nov 2021 17:15:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236534AbhKTRSx (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 20 Nov 2021 12:18:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:42870 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232180AbhKTRSw (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sat, 20 Nov 2021 12:18:52 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7709F60E9B;
        Sat, 20 Nov 2021 17:15:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637428548;
        bh=n4YhJX12UnoG42HAA6ZV18hwSD3hgO33zvbM1RVFks4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=YSxjOuV7cWc2gcSBgUsoJihryfHpnO3SOBXd955SFbZ/9dolU1j/3yV7xoPksjl5t
         aeoCIUFS/Fekv4J54X8OE7hxVXfU3QcZHe3kleDByfbWmcGWnXatcwKUXfVVkE/ErI
         DSsBXCaJFS7wqDFaipzdExXhGsjuTLOTxxdraCCDhZ/5uIEKwdMro5hBMadqTAvSGa
         AW2kw5UyZ/pBOH938F+nch1G8LQPTL7a64RWxhWchCelG1rUhaolgq3uZdwy7S1RFr
         R2pgSE2XiT0S3LNpqP3gMj0xj6/zyJcosH6rTPyePrxKD6V5Zbel1n1usOcJJULEdT
         fPqwgiorVqSwg==
Date:   Sat, 20 Nov 2021 09:15:48 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Helmut Grohne <helmut@subdivi.de>
Cc:     Dave Chinner <david@fromorbit.com>,
        Bastian Germann <bage@debian.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] debian: Fix FTCBFS: Skip crc32 test (Closes: #999879)
Message-ID: <20211120171548.GB24307@magnolia>
References: <20211119171241.102173-1-bage@debian.org>
 <20211119171241.102173-3-bage@debian.org>
 <20211119231105.GA449541@dread.disaster.area>
 <YZikmB1aLZUX8FC7@alf.mars>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YZikmB1aLZUX8FC7@alf.mars>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Nov 20, 2021 at 08:32:40AM +0100, Helmut Grohne wrote:
> Hi Dave,
> 
> On Sat, Nov 20, 2021 at 10:11:05AM +1100, Dave Chinner wrote:
> > I don't get it. The crcselftest does not use liburcu in
> > any way, nor does it try to link against liburcu, so it should not
> > fail because other parts of xfsprogs use liburcu.
> > 
> > What's the build error that occurs?
> 
> As the build log shows, that's not technically accurate. You can find
> logs of test builds for various architecture combinations at
> http://crossqa.debian.net/src/xfsprogs. This is also available as a link
> called "cross" in https://tracker.debian.org/xfsprogs.
> 
> The relevant part is:
> |     [TEST]    CRC32
> | In file included from crc32.c:35:
> | ../include/platform_defs.h:27:10: fatal error: urcu.h: No such file or directory
> |    27 | #include <urcu.h>
> |       |          ^~~~~~~~
> | compilation terminated.
> 
> I failed to figure a good way of dropping either include directive.
> 
> > We need to fix the generic cross-build problem in the xfsprogs code,
> > not slap a distro-specific build band-aid over it.
> 
> I fully agree with this in principle. However, when I fail to find that
> upstreamable solution, I try to at least provide a Debian-specific
> solution to iterate from.
> 
> Can you propose a way to drop either #include?

Frankly I don't really see the value in crc32selftest when cross
compiling -- sure, the crc32c code works correctly on the build host,
but that proves nothing about the (cross-)built binaries that end up in
the package.

The selftest code is modular enough that it's included in xfs_io and it
seems to run in under 500us even on my ancient raspberry pi 3b+
downclocked to 600mhz.  Why don't we just add it to mkfs and repair?
Those tools shouldn't be run all that frequently, and now we'll know
immediately if crc32c is broken on a user's system.

Then we don't need the build-time selftest at all.

--D

> Helmut
> 
