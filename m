Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:22312 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750952AbdIAPHr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 1 Sep 2017 11:07:47 -0400
Date: Fri, 1 Sep 2017 08:07:16 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] fsmap: fix documentation of FMR_OF_LAST
Message-ID: <20170901150716.GW3775@magnolia>
References: <20170831204918.GA7404@magnolia>
 <20170901080904.GA32746@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170901080904.GA32746@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs <linux-xfs@vger.kernel.org>, linux-api@vger.kernel.org, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-ext4 <linux-ext4@vger.kernel.org>

On Fri, Sep 01, 2017 at 01:09:04AM -0700, Christoph Hellwig wrote:
> On Thu, Aug 31, 2017 at 01:49:18PM -0700, Darrick J. Wong wrote:
> > The FMR_OF_LAST flag is set on the last fsmap record being returned for
> > the dataset requested, contrary to what the header file says.  Fix the
> > docs to reflect the behavior of all fsmap implementations.
> 
> Hmm.  What's the point of the flag then given that you can trivially
> deduce the last entry from fmh_entries?

fmh_entries is the number of records returned, not the number of records
in the dataset.  If, for example, you allocate space for 100 records and
perform a query for a block that has been reflinked 1000 times, the
dataset size is 1000 but fmh_entries is set to 100.  The lack of a LAST
flag on the 100th record tells you that there's more records to return.

If however you allocate space for 100 records and the block is reflinked
exactly 100 times, there's no way (without the flag) for userspace to
know that record 100 is the end of the dataset, so the only thing it can
do is to fsmap_advance() and try the query again, only to receive zero
results.  Granted I don't think fsmap queries are all /that/ expensive,
but it's trivial for the kernel to set the flag.

--D

> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
