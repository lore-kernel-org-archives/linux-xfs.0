Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:55447 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750757AbdHaNbs (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 31 Aug 2017 09:31:48 -0400
Date: Thu, 31 Aug 2017 15:31:47 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 9/8] xfs: simplify the rmap code in xfs_bmse_merge
Message-ID: <20170831133147.GA5615@lst.de>
References: <20170829174835.2218-1-hch@lst.de> <20170830231047.GC3775@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170830231047.GC3775@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org

On Wed, Aug 30, 2017 at 04:10:47PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> In Christoph's patch to refactor xfs_bmse_merge, the updated rmap code
> does more work than it needs to (because map-extent auto-merges
> records).  Remove the unnecessary unmap and save ourselves a deferred
> op.

Looks fine,

Reviewed-by: Christoph Hellwig <hch@lst.de>
