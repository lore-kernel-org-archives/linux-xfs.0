Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:51952 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751132AbeFCW7G (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 3 Jun 2018 18:59:06 -0400
Date: Sun, 3 Jun 2018 15:59:01 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: NULL pointer dereference in xfs_bmap_extents_to_btree() when
 mounting and operating a crafted image
Message-ID: <20180603225901.GJ7825@magnolia>
References: <CANrHXgzLvaud2HEv3jAFGTfn5S80d7Rwj-ztJNWPT8eyFTohMg@mail.gmail.com>
 <20180603223435.GU10363@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180603223435.GU10363@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Wen Xu <xuwen.sjtu@gmail.com>
Cc: Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org

On Mon, Jun 04, 2018 at 08:34:35AM +1000, Dave Chinner wrote:
> On Sun, Jun 03, 2018 at 06:19:54PM -0400, Wen Xu wrote:
> > Hi XFS developers and maintainers,
> > Please check: https://bugzilla.kernel.org/show_bug.cgi?id=199915
> 
> Please report bugs straight to this list - it's much easier to
> track and faster to discuss bugs through email than it is through
> bugzilla.

Seconded.

I appreciate your wokr on the suggested code patch, but it needs a
Signed-off-by tag with your name on it.  The patch ought to be sent to
the list so that we can record it with all the other patch traffic.

Also, the patch needs to release all the resources that the function
acquires prior to the 'return -EFSCORRUPTED'.

--D

> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
