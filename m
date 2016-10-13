Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:42368 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750869AbcJMHCE (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 13 Oct 2016 03:02:04 -0400
Date: Thu, 13 Oct 2016 09:01:18 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 7/9] xfs: optimize xfs_reflink_cancel_cow_blocks
Message-ID: <20161013070118.GD10579@lst.de>
References: <1476106685-29048-1-git-send-email-hch@lst.de> <1476106685-29048-8-git-send-email-hch@lst.de> <20161012141324.GC56019@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161012141324.GC56019@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org, darrick.wong@oracle.com

On Wed, Oct 12, 2016 at 10:13:25AM -0400, Brian Foster wrote:
> How about using a while loop..?
> 
> 	while (got.br_startoff < end_fsb) {
> 		...
> 
> Otherwise, looks fine:

Sure.  My initial version had a real do {} while loop, but the helper
to make that possible was dropped from this series and will be sent
separately.
