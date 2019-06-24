Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail106.syd.optusnet.com.au ([211.29.132.42]:48325 "EHLO
        mail106.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726551AbfFXXAP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Jun 2019 19:00:15 -0400
Date: Tue, 25 Jun 2019 08:59:04 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 06/12] xfs: remove XFS_TRANS_NOFS
Message-ID: <20190624225904.GB7777@dread.disaster.area>
References: <20190624055253.31183-1-hch@lst.de>
 <20190624055253.31183-7-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190624055253.31183-7-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: "Darrick J . Wong" <darrick.wong@oracle.com>, Damien Le Moal <Damien.LeMoal@wdc.com>, Andreas Gruenbacher <agruenba@redhat.com>, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org

On Mon, Jun 24, 2019 at 07:52:47AM +0200, Christoph Hellwig wrote:
> Instead of a magic flag for xfs_trans_alloc, just ensure all callers
> that can't relclaim through the file system use memalloc_nofs_save to
> set the per-task nofs flag.

I'm thinking that it would be a good idea to add comments to explain
exactly what the memalloc_nofs_save/restore() are protecting where
they are used. Right now the XFS_TRANS_NOFS flag is largely
undocumented, so a reader is left guessing as to why the flag is
necessary and what contexts it may apply to. Hence I think we should
fix that while we are changing over to a different GFP_NOFS
allocation context mechanism....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
