Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:60507 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S968369AbdIZOoV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 26 Sep 2017 10:44:21 -0400
Date: Tue, 26 Sep 2017 07:44:21 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: always swap the cow forks when swapping extents
Message-ID: <20170926144421.GB9530@infradead.org>
References: <20170923071208.GN5728@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170923071208.GN5728@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: xfs <linux-xfs@vger.kernel.org>

On Sat, Sep 23, 2017 at 12:12:08AM -0700, Darrick J. Wong wrote:
> Since the CoW fork exists as a secondary data structure to the data
> fork, we must always swap cow forks during swapext.  We also need to
> swap the extent counts and reset the cowblocks tags.

Do you have a test that triggers a problem without this? :)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
