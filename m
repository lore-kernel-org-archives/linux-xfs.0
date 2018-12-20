Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:54638 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387666AbeLTUxr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 20 Dec 2018 15:53:47 -0500
Date: Fri, 21 Dec 2018 07:53:42 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] iomap: Revert "fs/iomap.c: get/put the page in
 iomap_page_create/release()"
Message-ID: <20181220205342.GC4205@dastard>
References: <20181220122324.17082-1-david@fromorbit.com>
 <20181220174130.GA21065@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181220174130.GA21065@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, pjaroszynski@nvidia.com, william.kucharski@oracle.com, stable@vger.kernel.org, akpm@linux-foundation.org, torvalds@linux-foundation.org

On Thu, Dec 20, 2018 at 06:41:30PM +0100, Christoph Hellwig wrote:
> Lets fix the problem instead.  I'll dig into it.

I'd say we still need to revert this for 4.20 which is due for
release in a couple of days. Most of us are going to be on holidays
and away from computers for the next week, so I don't think we
have time to adequately review and test a new fix (which doesn't
exist yet) before the release occurs.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
