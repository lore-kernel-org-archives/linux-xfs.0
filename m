Return-Path: linux-xfs-owner@vger.kernel.org
Received: from bombadil.infradead.org ([198.137.202.133]:44516 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731963AbfHOOED (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 15 Aug 2019 10:04:03 -0400
Date: Thu, 15 Aug 2019 07:03:55 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v5 01/18] xfs: compat_ioctl: use compat_ptr()
Message-ID: <20190815140355.GA11012@infradead.org>
References: <20190814204259.120942-1-arnd@arndb.de>
 <20190814204259.120942-2-arnd@arndb.de>
 <20190814213753.GP6129@dread.disaster.area>
 <20190815071314.GA6960@infradead.org>
 <CAK8P3a2Hjfd49XY18cDr04ZpvC5ZBGudzxqpCesbSsDf1ydmSA@mail.gmail.com>
 <20190815080211.GA17055@infradead.org>
 <20190815102649.GA10821@infradead.org>
 <20190815121511.GR6129@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190815121511.GR6129@dread.disaster.area>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@infradead.org>, Arnd Bergmann <arnd@arndb.de>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, Linux FS-devel Mailing List <linux-fsdevel@vger.kernel.org>, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs <linux-xfs@vger.kernel.org>, Brian Foster <bfoster@redhat.com>, Allison Collins <allison.henderson@oracle.com>, Nick Bowler <nbowler@draconx.ca>, Eric Sandeen <sandeen@sandeen.net>, Dave Chinner <dchinner@redhat.com>

On Thu, Aug 15, 2019 at 10:15:12PM +1000, Dave Chinner wrote:
> > http://git.infradead.org/users/hch/xfs.git/shortlog/refs/heads/xfs-ioctl-table
> 
> Lots to like in that handful of patches. :)
> 
> It can easily go before or after Arnd's patch, and the merge
> conflict either way would be minor, so I'm not really fussed either
> way this gets sorted out...

The other thing we could do is to just pick the two important ones:

http://git.infradead.org/users/hch/xfs.git/shortlog/refs/heads/xfs-ioctl-table-5.3

and throw that into Arnds series, or even 5.3, and then defer the
table thing until later.
