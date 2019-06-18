Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:44062 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729642AbfFRUx2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 18 Jun 2019 16:53:28 -0400
Date: Tue, 18 Jun 2019 13:52:52 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 1/4] xfs: separate inode geometry
Message-ID: <20190618205252.GR5387@magnolia>
References: <155968493259.1657505.18397791996876650910.stgit@magnolia>
 <155968493890.1657505.14039176301049696712.stgit@magnolia>
 <20190618181732.GA873@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190618181732.GA873@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org, Dave Chinner <dchinner@redhat.com>

On Tue, Jun 18, 2019 at 11:17:32AM -0700, Christoph Hellwig wrote:
> Sorry for spotting this so late, but this one is pretty bogus as-is.
> 
> The geometry information is not an on-disk structure in any sense,
> and has absolutely no business in xfs_format.h.

Ok I'll move it.

--D
