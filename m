Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:50984 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751303AbeFEDiE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 4 Jun 2018 23:38:04 -0400
Date: Mon, 4 Jun 2018 20:38:00 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 0/3] xfs: more verifications!
Message-ID: <20180605033800.GA9437@magnolia>
References: <20180605024313.18737-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180605024313.18737-1-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On Tue, Jun 05, 2018 at 12:43:10PM +1000, Dave Chinner wrote:
> Hi folks,
> 
> This patchset addresses a series of corruptions noticed in an image
> provided by Wen Xu. The patches only address detecting corruptions
> before they can do damage - it does not address/fix the crash the
> image caused but instead prevents the bad information from getting
> to the point where it can cause a crash.
> 
> The third patch addresses a general btree record validation issue;
> we should probably dirve this inwards to each btree implementation
> with a ->verify_record() callout, as this patch does not address
> all the places that btree records are traversed during searches. It
> will catch any attempt to use a bad record that a search lands on,
> however.
> 
> Comments?

So, uh, does xfs_repair catch all these things and fix them?

I wonder if online repair catches and fixes them too, but I won't yet
start heckling people about that. :P

--D

> -Dave.
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
