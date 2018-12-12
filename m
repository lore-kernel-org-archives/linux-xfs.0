Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:52536 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727748AbeLLSR3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 12 Dec 2018 13:17:29 -0500
Date: Wed, 12 Dec 2018 10:16:58 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [GIT PULL] xfs: fixes for v4.20-rc6
Message-ID: <20181212181658.GA24487@magnolia>
References: <20181208163639.GR24487@magnolia>
 <CAHk-=who9EqvvGaazise-dh7_DH6rLOULWXzysinyAPnHS4B0A@mail.gmail.com>
 <20181211135818.GA29626@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181211135818.GA29626@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Al Viro <viro@zeniv.linux.org.uk>, david@fromorbit.com, Linux List Kernel Mailing <linux-kernel@vger.kernel.org>, linux-xfs@vger.kernel.org, Eric Sandeen <sandeen@sandeen.net>

On Tue, Dec 11, 2018 at 05:58:18AM -0800, Christoph Hellwig wrote:
> On Sat, Dec 08, 2018 at 11:24:48AM -0800, Linus Torvalds wrote:
> > Honestly, I really wish you simply wouldn't send me "xfs" fixes that
> > aren't really xfs-specific at all.
> > 
> > All the splice patches (and honestly, I feel some of the iomap ones
> > too) that have come in through the xfs tree should have been handled
> > separately as actual VFS patches. Or at least had acks from Al or
> > something.
> 
> iomap came in through the XFS tree originally, and has been very much
> maintained in combo, even though we now have another user with gfs.
> 
> Maybe we just need to make that official in MAINTAINERS?

Yes, though who should be the official maintainer?  You wrote most of
the iomap code; do you want to maintain it yourself?  Or have people
funnel them wherever XFS patches go? :)

--D
