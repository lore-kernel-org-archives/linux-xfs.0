Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:47683 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932752AbeGJMNz (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 10 Jul 2018 08:13:55 -0400
Date: Tue, 10 Jul 2018 14:15:30 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 21/22] xfs: add support for sub-pagesize writeback
        without buffer_heads
Message-ID: <20180710121530.GA765@lst.de>
References: <20180702145813.22496-1-hch@lst.de> <20180702145813.22496-22-hch@lst.de> <20180703123603.GB22789@bfoster> <20180703220501.GX32415@magnolia> <20180708151615.GC14418@lst.de> <20180710010202.GA5835@killians.ges.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180710010202.GA5835@killians.ges.redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

On Mon, Jul 09, 2018 at 09:02:02PM -0400, Brian Foster wrote:
> It looks to me that if the page itself isn't uptodate, we
> overwrite a block of that page and then the writepage fails, clearing
> the buffer uptodate status means that the next read would return what is
> on disk (not what was just written to the page).

With iomap we never clear the uptodate bit, and we only set it when
the part of the page contains valid data.  With buffer heads we might
indeed clear the uptodate bit after a write error.  Now if the whole
page is set uptodate we won't re-read it, but if the whole page wasn't
uptodate it seems like the buffer head code will lose data in that
case, which looks wrong to me.

> I'm not sure that's
> what happens if the page was already uptodate before the
> overwrite/writepage, however, I didn't notice anything that cleared page
> uptodate status on a writepage I/O error..?

Yes, the buffer head code seems inconsistent in how it treats the buffer
vs page uptodate bits.
