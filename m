Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1050.oracle.com ([156.151.31.82]:17872 "EHLO
        userp1050.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751011AbdBABad (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 31 Jan 2017 20:30:33 -0500
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81])
        by userp1050.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v111U4tp026661
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 1 Feb 2017 01:30:04 GMT
Date: Tue, 31 Jan 2017 17:28:29 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 7/7] xfs: mark speculative prealloc CoW fork extents
 unwritten
Message-ID: <20170201012829.GJ9134@birch.djwong.org>
References: <148582218411.12293.806854574193653038.stgit@birch.djwong.org>
 <148582223303.12293.11053073799262731296.stgit@birch.djwong.org>
 <20170131134135.GA10866@infradead.org>
 <20170131191120.GF9134@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170131191120.GF9134@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org

On Tue, Jan 31, 2017 at 11:11:20AM -0800, Darrick J. Wong wrote:
> On Tue, Jan 31, 2017 at 05:41:35AM -0800, Christoph Hellwig wrote:
> > Hi Darrick,
> > 
> > from a quick look the code looks reasonable, but I'm worried about
> > yet another set of transactions that modify all extents again.
> > 
> > Do you have any measurements of the overhead?  I'll see if I
> > can prototype my always COW idea to see how the approaches compare.
> 
> The overhead should be pretty low -- since the cow fork never goes to
> disk, the only thing we end up logging is the inode core (because the
> conversion function logs it unconditionally), and I'm not even sure
> that's necessary since we're performing a pure conversion of blocks that
> are already allocated.
> 
> In any case I didn't see any noticeable impact on performance other
> than the extra CPU overhead.

Reading a little closer, we don't actually change anything in the
on-disk inode, so we can get rid of transaction altogether.

--D

> 
> --D
> 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
