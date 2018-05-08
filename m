Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:23290 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752954AbeEHAIZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 7 May 2018 20:08:25 -0400
Date: Tue, 8 May 2018 10:06:17 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 02/10] xfs: catch log items multiply joined to a
 transaction
Message-ID: <20180508000617.GL23861@dastard>
References: <20180502080157.11386-1-david@fromorbit.com>
 <20180502080157.11386-3-david@fromorbit.com>
 <20180507144825.GD7476@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180507144825.GD7476@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org

On Mon, May 07, 2018 at 07:48:25AM -0700, Christoph Hellwig wrote:
> Looks good, but I think this should be moved later in the series
> until you have actually fixed the existing issues that it did catch.
> 
> Then again once the log item descriptor is removed later in the series
> the flag added here becomes rather pointless as the core linked list
> debugging would also find these issues.

Yeah, you're right, it does become redundant. I'll drop this, and
add the extra check this patch does to the final "remove the lid"
patch.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
