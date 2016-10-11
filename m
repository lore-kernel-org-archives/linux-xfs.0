Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1050.oracle.com ([156.151.31.82]:16681 "EHLO
        userp1050.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754410AbcJKW0d (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 11 Oct 2016 18:26:33 -0400
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81])
        by userp1050.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id u9BIf16w015159
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 11 Oct 2016 18:41:01 GMT
Date: Tue, 11 Oct 2016 11:39:53 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] xfs: convert COW blocks to real blocks before unwritten
 extent conversion
Message-ID: <20161011183953.GE5619@birch.djwong.org>
References: <1476104794-28175-1-git-send-email-hch@lst.de>
 <20161011073825.GI23194@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161011073825.GI23194@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org

On Tue, Oct 11, 2016 at 06:38:25PM +1100, Dave Chinner wrote:
> On Mon, Oct 10, 2016 at 03:06:34PM +0200, Christoph Hellwig wrote:
> > We need to splice COW blocks we've completed in xfs_end_io_direct_write
> > into the data fork before converting unwritten extents.  Otherwise
> > xfs_bmapi_write might first allocate blocks for any holes in the data
> > fork, which isn't only not needed but also harmful as it might cause
> > reserved block underruns in the transaction.
> > 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Committed and pushe dout to the for-next branch (commit
> feac470e3642e8956ac9b7f14224e6b301b9219d). If there's no more
> late-breaking, urgent fixes, then this is what I'll ask Linus to
> pull tomorrow....

Everything looks ok from here!

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
