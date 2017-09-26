Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:17128 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S966178AbdIZQC1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 26 Sep 2017 12:02:27 -0400
Date: Tue, 26 Sep 2017 09:01:58 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] xfs: always swap the cow forks when swapping extents
Message-ID: <20170926160158.GG5020@magnolia>
References: <20170923071208.GN5728@magnolia>
 <20170926144421.GB9530@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170926144421.GB9530@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs <linux-xfs@vger.kernel.org>

On Tue, Sep 26, 2017 at 07:44:21AM -0700, Christoph Hellwig wrote:
> On Sat, Sep 23, 2017 at 12:12:08AM -0700, Darrick J. Wong wrote:
> > Since the CoW fork exists as a secondary data structure to the data
> > fork, we must always swap cow forks during swapext.  We also need to
> > swap the extent counts and reset the cowblocks tags.
> 
> Do you have a test that triggers a problem without this? :)

Yes, but it doesn't trigger it reliably, so I've not yet sent it.

--D

> 
> Looks good:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
