Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:41377 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752850AbdIURNZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 21 Sep 2017 13:13:25 -0400
Date: Thu, 21 Sep 2017 10:12:58 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] xfs: perag initialization should only touch
 m_ag_max_usable for AG 0
Message-ID: <20170921171258.GI7112@magnolia>
References: <20170919181041.GC7112@magnolia>
 <20170921140421.GA24142@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170921140421.GA24142@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs <linux-xfs@vger.kernel.org>

On Thu, Sep 21, 2017 at 07:04:21AM -0700, Christoph Hellwig wrote:
> On Tue, Sep 19, 2017 at 11:10:41AM -0700, Darrick J. Wong wrote:
> > We call __xfs_ag_resv_init to make a per-AG reservation for each AG.
> > This makes the reservation per-AG, not per-filesystem.  Therefore, it
> > is incorrect to adjust m_ag_max_usable for each AG.  Adjust it only
> > when we're reserving AG 0's blocks so that we only do it once per fs.
> 
> This looks correct to me, but I hate how we manipulate a per-mount
> value.  Is there a way we can just move this to the caller?

I'm not sure which caller you're referring to -- if you mean
xfs_ag_resv_init, then we'd still have the "if (pag->agno == 0)
xfs_mod_fdblocks(...)"; and if xfs_fs_reserve_ag_blocks then you'd have
to bubble the two ask values up out of xfs_ag_resv_init, which also
seems like a layering violation.  Modifying fdblocks in
__xfs_ag_resv_init (Dave I think is sharpening his axe on that) smells
kinda funny but it's less code intensive.

<confused>

--D

> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
