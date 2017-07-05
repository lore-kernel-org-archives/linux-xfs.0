Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39904 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752144AbdGEP1i (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 5 Jul 2017 11:27:38 -0400
Date: Wed, 5 Jul 2017 11:27:31 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: generic/232 regression - bda250db ("xfs: rewrite
 xfs_dq_get_next_id using xfs_iext_lookup_extent")
Message-ID: <20170705152730.GD51285@bfoster.bfoster>
References: <20170705151158.GC51285@bfoster.bfoster>
 <20170705152259.GA2593@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170705152259.GA2593@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org, "Darrick J. Wong" <darrick.wong@oracle.com>

On Wed, Jul 05, 2017 at 05:22:59PM +0200, Christoph Hellwig wrote:
> Thanks Brian,
> 
> your fix looks correct to me.  I usually got for curly braces on
> both sides of the else if they are needed, but thay might be a bit
> too nitpicky..

Ok, I can fix that up and maybe add a comment too. Otherwise I'll write
up a commit log and send a proper patch. Thanks for the quick feedback..

Brian

> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
