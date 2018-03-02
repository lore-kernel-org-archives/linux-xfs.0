Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:38374 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932836AbeCBW7I (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 2 Mar 2018 17:59:08 -0500
Date: Fri, 2 Mar 2018 23:59:06 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] [RFC] iomap: Use FUA for pure data O_DSYNC DIO writes
Message-ID: <20180302225906.GA31359@lst.de>
References: <20180301014144.28892-1-david@fromorbit.com> <20180302222031.GA30818@lst.de> <20180302225319.GW30854@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180302225319.GW30854@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

On Sat, Mar 03, 2018 at 09:53:19AM +1100, Dave Chinner wrote:
> I thought about that, but as you noticed the DAX case gets in the
> way so I didn't bother for a RFC patch.
> 
> I'll have a look at making the DAX iomap code do something similar
> with generic_write_sync() so we can simplify this high level code.

I suspect it might make sense to juse move generic_write_sync into
each of the three write routines as a prep patch before the prep
patch, which should clean everything up nicely.
