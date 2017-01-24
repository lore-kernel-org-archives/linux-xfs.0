Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:29121 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750716AbdAXRCo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 24 Jan 2017 12:02:44 -0500
Date: Tue, 24 Jan 2017 09:02:10 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: xfs/122 failure for a while
Message-ID: <20170124170210.GA9134@birch.djwong.org>
References: <20170124094054.GA8536@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170124094054.GA8536@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

On Tue, Jan 24, 2017 at 01:40:54AM -0800, Christoph Hellwig wrote:
> xfs/122 has been failing for me for a while with this error:
> 
> -sizeof(xfs_dsb_t) = 272
> +sizeof(xfs_dsb_t) = 264
> 
> That 272 numbers comes from:
> 
> 908ce96f ("xfs/122: add the realtime rmapbt inode and btree fields"),
> which don't seem to be features that made it into the kernel and
> xfsprogs so far.

Yeah... the realtime rmapbt tests got sucked into xfstests back when I
thought we were closer to landing that feature.  Then I decided to let
it sit on the backburner behind online scrub so that the disk format
could stay the same for longer.

I've wondered for a while if it would make sense to special-case
xfs_dsb_t not to complain about a smaller value (because if features
start falling off the kernel you're likely to notice) but arranging
the parsing for all that made my head hurt.

For now I'll just set it back to 264.

--D

> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
