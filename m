Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:56871 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751119AbdICIlC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 3 Sep 2017 04:41:02 -0400
Date: Sun, 3 Sep 2017 01:41:02 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] fsmap: fix documentation of FMR_OF_LAST
Message-ID: <20170903084102.GC32385@infradead.org>
References: <20170831204918.GA7404@magnolia>
 <20170901080904.GA32746@infradead.org>
 <20170901150716.GW3775@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170901150716.GW3775@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs <linux-xfs@vger.kernel.org>, linux-api@vger.kernel.org, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-ext4 <linux-ext4@vger.kernel.org>

On Fri, Sep 01, 2017 at 08:07:16AM -0700, Darrick J. Wong wrote:
> fmh_entries is the number of records returned, not the number of records
> in the dataset.  If, for example, you allocate space for 100 records and
> perform a query for a block that has been reflinked 1000 times, the
> dataset size is 1000 but fmh_entries is set to 100.  The lack of a LAST
> flag on the 100th record tells you that there's more records to return.
> 
> If however you allocate space for 100 records and the block is reflinked
> exactly 100 times, there's no way (without the flag) for userspace to
> know that record 100 is the end of the dataset, so the only thing it can
> do is to fsmap_advance() and try the query again, only to receive zero
> results.  Granted I don't think fsmap queries are all /that/ expensive,
> but it's trivial for the kernel to set the flag.

Oh, ok - it had to look up this defintion of dataset first.  With
that the explanation makes total sense:

Reviewed-by: Christoph Hellwig <hch@lst.de>
