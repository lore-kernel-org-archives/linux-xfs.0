Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA2C6C433EF
	for <linux-xfs@archiver.kernel.org>; Sat, 20 Nov 2021 07:42:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236677AbhKTHpF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 20 Nov 2021 02:45:05 -0500
Received: from isilmar-4.linta.de ([136.243.71.142]:55166 "EHLO
        isilmar-4.linta.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237115AbhKTHpF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 20 Nov 2021 02:45:05 -0500
X-Greylist: delayed 544 seconds by postgrey-1.27 at vger.kernel.org; Sat, 20 Nov 2021 02:45:04 EST
Received: from isilmar-4.linta.de (isilmar.linta [10.0.0.1])
        by isilmar-4.linta.de (Postfix) with ESMTP id 0F8B02010E0;
        Sat, 20 Nov 2021 07:32:57 +0000 (UTC)
Date:   Sat, 20 Nov 2021 08:32:40 +0100
From:   Helmut Grohne <helmut@subdivi.de>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Bastian Germann <bage@debian.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] debian: Fix FTCBFS: Skip crc32 test (Closes: #999879)
Message-ID: <YZikmB1aLZUX8FC7@alf.mars>
References: <20211119171241.102173-1-bage@debian.org>
 <20211119171241.102173-3-bage@debian.org>
 <20211119231105.GA449541@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211119231105.GA449541@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Dave,

On Sat, Nov 20, 2021 at 10:11:05AM +1100, Dave Chinner wrote:
> I don't get it. The crcselftest does not use liburcu in
> any way, nor does it try to link against liburcu, so it should not
> fail because other parts of xfsprogs use liburcu.
> 
> What's the build error that occurs?

As the build log shows, that's not technically accurate. You can find
logs of test builds for various architecture combinations at
http://crossqa.debian.net/src/xfsprogs. This is also available as a link
called "cross" in https://tracker.debian.org/xfsprogs.

The relevant part is:
|     [TEST]    CRC32
| In file included from crc32.c:35:
| ../include/platform_defs.h:27:10: fatal error: urcu.h: No such file or directory
|    27 | #include <urcu.h>
|       |          ^~~~~~~~
| compilation terminated.

I failed to figure a good way of dropping either include directive.

> We need to fix the generic cross-build problem in the xfsprogs code,
> not slap a distro-specific build band-aid over it.

I fully agree with this in principle. However, when I fail to find that
upstreamable solution, I try to at least provide a Debian-specific
solution to iterate from.

Can you propose a way to drop either #include?

Helmut

