Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:55074 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726116AbeKTSsd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 20 Nov 2018 13:48:33 -0500
Date: Tue, 20 Nov 2018 00:20:40 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 6/7] xfs: don't ENOSPC on writeback when punching holes
Message-ID: <20181120082040.GF30481@infradead.org>
References: <20181119210459.8506-1-david@fromorbit.com>
 <20181119210459.8506-7-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181119210459.8506-7-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On Tue, Nov 20, 2018 at 08:04:58AM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Just tried to punch a 40T sparse file when enospc was triggered due
> to extent size hints consuming more space than expected. It failed
> with:
> 
> # sudo xfs_io -c "fpunch 0 40t" /mnt/fast/xfs-arekm.img
> fallocate: No space left on device
> #
> 
> because the writeback error of ENOSPC was being reported. We're
> going to free that space, so we don't care if there was a ENOSPC
> writeback error. So ignore ENOSPC errors and punch anyway.

How do even get -ENOSPC back from writeback?  It seems like we have
a much worse root cause lingering here.
