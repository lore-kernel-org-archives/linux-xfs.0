Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:40530 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387546AbfEWWja (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 23 May 2019 18:39:30 -0400
Date: Fri, 24 May 2019 08:39:26 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 06/20] xfs: don't use REQ_PREFLUSH for split log writes
Message-ID: <20190523223926.GS29573@dread.disaster.area>
References: <20190523173742.15551-1-hch@lst.de>
 <20190523173742.15551-7-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190523173742.15551-7-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

On Thu, May 23, 2019 at 07:37:28PM +0200, Christoph Hellwig wrote:
> If we have to split a log write because it wraps the end of the log we
> can't just use REQ_PREFLUSH to flush before the first log write,
> as the writes might get reordered somewhere in the I/O stack.  Issue
> a manual flush in that case so that the ordering of the two log I/Os
> doesn't matter.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Yup, we clear the flush flag from the second buffer so this is
actually necessary. Very subtle, nice catch.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com
