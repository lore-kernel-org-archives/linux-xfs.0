Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:42907 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752610AbdHKLY4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 11 Aug 2017 07:24:56 -0400
Date: Fri, 11 Aug 2017 04:24:54 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs_db: free field list when failing out of fuzz
Message-ID: <20170811112454.GB10698@infradead.org>
References: <20170805161122.GK24087@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170805161122.GK24087@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Eric Sandeen <sandeen@redhat.com>, xfs <linux-xfs@vger.kernel.org>

On Sat, Aug 05, 2017 at 09:11:22AM -0700, Darrick J. Wong wrote:
> Fix a missed opportunity to free the field list when we fail out of the
> fuzz command by refactoring the error clauses to use a common cleanup
> clause.
> 
> Fixes-coverity-id: 1416141
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
