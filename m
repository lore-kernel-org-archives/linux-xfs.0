Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:60454 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726350AbeLKN6Y (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 11 Dec 2018 08:58:24 -0500
Date: Tue, 11 Dec 2018 05:58:18 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [GIT PULL] xfs: fixes for v4.20-rc6
Message-ID: <20181211135818.GA29626@infradead.org>
References: <20181208163639.GR24487@magnolia>
 <CAHk-=who9EqvvGaazise-dh7_DH6rLOULWXzysinyAPnHS4B0A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=who9EqvvGaazise-dh7_DH6rLOULWXzysinyAPnHS4B0A@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, Al Viro <viro@zeniv.linux.org.uk>, david@fromorbit.com, Linux List Kernel Mailing <linux-kernel@vger.kernel.org>, linux-xfs@vger.kernel.org, Eric Sandeen <sandeen@sandeen.net>

On Sat, Dec 08, 2018 at 11:24:48AM -0800, Linus Torvalds wrote:
> Honestly, I really wish you simply wouldn't send me "xfs" fixes that
> aren't really xfs-specific at all.
> 
> All the splice patches (and honestly, I feel some of the iomap ones
> too) that have come in through the xfs tree should have been handled
> separately as actual VFS patches. Or at least had acks from Al or
> something.

iomap came in through the XFS tree originally, and has been very much
maintained in combo, even though we now have another user with gfs.

Maybe we just need to make that official in MAINTAINERS?
