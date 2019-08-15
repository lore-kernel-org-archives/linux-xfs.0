Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:42776 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728500AbfHOK0y (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 15 Aug 2019 06:26:54 -0400
Date: Thu, 15 Aug 2019 03:26:49 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v5 01/18] xfs: compat_ioctl: use compat_ptr()
Message-ID: <20190815102649.GA10821@infradead.org>
References: <20190814204259.120942-1-arnd@arndb.de>
 <20190814204259.120942-2-arnd@arndb.de>
 <20190814213753.GP6129@dread.disaster.area>
 <20190815071314.GA6960@infradead.org>
 <CAK8P3a2Hjfd49XY18cDr04ZpvC5ZBGudzxqpCesbSsDf1ydmSA@mail.gmail.com>
 <20190815080211.GA17055@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190815080211.GA17055@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Arnd Bergmann <arnd@arndb.de>
Cc: Christoph Hellwig <hch@infradead.org>, Dave Chinner <david@fromorbit.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, Linux FS-devel Mailing List <linux-fsdevel@vger.kernel.org>, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs <linux-xfs@vger.kernel.org>, Brian Foster <bfoster@redhat.com>, Allison Collins <allison.henderson@oracle.com>, Nick Bowler <nbowler@draconx.ca>, Eric Sandeen <sandeen@sandeen.net>, Dave Chinner <dchinner@redhat.com>

On Thu, Aug 15, 2019 at 01:02:11AM -0700, Christoph Hellwig wrote:
> In many ways I'd actually much rather have a table driven approach.
> Let me try something..

Ok, it seems like we don't even need a table containing native and
compat as we can just fall back.  The tables still seem nicer to read,
though.

Let me know what you think of this:

http://git.infradead.org/users/hch/xfs.git/shortlog/refs/heads/xfs-ioctl-table

I also wonder if we should life the ioctl handler tables to the
VFS..
