Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-lf0-f67.google.com ([209.85.215.67]:37229 "EHLO
        mail-lf0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1161274AbeBOTCp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 15 Feb 2018 14:02:45 -0500
Received: by mail-lf0-f67.google.com with SMTP id f137so967193lfe.4
        for <linux-xfs@vger.kernel.org>; Thu, 15 Feb 2018 11:02:45 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20180215054436.GN7000@dastard>
References: <20180206060840.kj2u6jjmkuk3vie6@destitution> <CABXGCsOgcYyj8Xukn7Pi_M2qz2aJ1MJZTaxaSgYno7f_BtZH6w@mail.gmail.com>
 <1517974845.4352.8.camel@gmail.com> <20180207065520.66f6gocvxlnxmkyv@destitution>
 <1518255240.31843.6.camel@gmail.com> <1518255352.31843.8.camel@gmail.com>
 <20180211225657.GA6778@dastard> <1518643669.6070.21.camel@gmail.com>
 <20180214215245.GI7000@dastard> <1518666178.6070.25.camel@gmail.com> <20180215054436.GN7000@dastard>
From: Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>
Date: Fri, 16 Feb 2018 00:02:28 +0500
Message-ID: <CABXGCsOpJU4WU2w5DYBA+Q1nquh14zN0oCW6OfCbhTOFYLwO5w@mail.gmail.com>
Subject: Re: freezing system for several second on high I/O [kernel 4.15]
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>

On 15 February 2018 at 10:44, Dave Chinner <david@fromorbit.com> wrote:
> I've already explained that we can't annotate these memory
> allocations to turn off the false positives because that will also
> turning off all detection of real deadlock conditions.  Lockdep has
> many, many limitations, and this happens to be one of them.
>
> FWIW, is there any specific reason you running lockdep on your
> desktop system?

Because I wanna make open source better (help fixing all freezing)

>
> I think I've already explained that, too. The graphics subsystem -
> which is responsible for updating the cursor - requires memory
> allocation. The machine is running low on memory, so it runs memory
> reclaim, which recurses back into the filesystem and blocks waiting
> for IO to be completed (either writing dirty data pages or flushing
> dirty metadata) so it can free memory.

Which means machine is running low on memory?
How many memory needed?

$ free -h
              total        used        free      shared  buff/cache   available
Mem:            30G         17G        2,1G        1,4G         10G         12G
Swap:           59G          0B         59G

As can we see machine have 12G available memory. Is this means low memory?

> IOWs, your problems all stem from long IO latencies caused by the
> overloaded storage subsystem - they are propagate to all
> aspects of the OS via direct memory reclaim blocking on IO....

I'm surprised that no QOS analog for disk I/O.
This is reminiscent of the situation in past where a torrent client
clogs the entire channel on the cheap router and it causes problems
with opening web pages. In nowadays it never happens with modern
routers even with overloaded network channel are possible video calls
.
In 2018 my personaly expectation that user can run any set of
applications on computer and this never shoudn't harm system.

--
Best Regards,
Mike Gavrilov.
