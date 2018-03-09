Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:49572 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751211AbeCIXo3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 9 Mar 2018 18:44:29 -0500
Date: Fri, 9 Mar 2018 15:44:22 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: fallocate on XFS for swap
Message-ID: <20180309234422.GA4860@magnolia>
References: <8C28C1CB-47F1-48D1-85C9-5373D29EA13E@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <8C28C1CB-47F1-48D1-85C9-5373D29EA13E@amazon.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Besogonov, Aleksei" <cyberax@amazon.com>
Cc: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, Dave Chinner <david@fromorbit.com>, xfs <linux-xfs@vger.kernel.org>

[you really ought to cc the xfs list]

On Fri, Mar 09, 2018 at 10:05:24PM +0000, Besogonov, Aleksei wrote:
> Hi!
> 
> We’re working at Amazon on making XFS our default root filesystem for
> the upcoming Amazon Linux 2 (now in prod preview). One of the problems
> that we’ve encountered is inability to use fallocated files for swap
> on XFS. This is really important for us, since we’re shipping our
> current Amazon Linux with hibernation support .

<shudder>

> I’ve traced the problem to bmap(), used in generic_swapfile_activate
> call, which returns 0 for blocks inside holes created by fallocate and
> Dave Chinner confirmed it in a private email. I’m thinking about ways
> to fix it, so far I see the following possibilities:
> 
> 1. Change bmap() to not return zeroes for blocks inside holes. But
> this is an ABI change and it likely will break some obscure userspace
> utility somewhere.

bmap is a horrible interface, let's leave it to wither and eventually go
away.

> 2. Change generic_swap_activate to use a more modern interface, by
> adding fiemap-like operation to address_space_operations with fallback
> on bmap().

Probably the best idea, but see fs/iomap.c since we're basically leasing
a chunk of file space to the kernel.  Leasing space to a user that wants
direct access is becoming rather common (rdma, map_sync, etc.)

> 3. Add an XFS-specific implementation of swapfile_activate.

Ugh no.

> What do the people think about it? I kinda like option 2, since it'll
> make fallocate() work for any other FS that implements fiemap.

--D
