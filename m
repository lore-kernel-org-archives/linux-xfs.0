Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:56780 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731746AbeGTQxw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 20 Jul 2018 12:53:52 -0400
Date: Fri, 20 Jul 2018 09:04:55 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/8] xfs: trivial xfs_btree_del_cursor cleanups
Message-ID: <20180720160455.GB12054@infradead.org>
References: <153192902811.31685.11590100183112248407.stgit@magnolia>
 <153192905163.31685.17441257298247003323.stgit@magnolia>
 <20180719164353.GF10151@infradead.org>
 <20180719192230.GM4813@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180719192230.GM4813@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org

On Thu, Jul 19, 2018 at 12:22:30PM -0700, Darrick J. Wong wrote:
> Eventually, yes.  The remaining usages are not so trivial to fix and
> require more careful auditing.

I think a simple s/XFS_BTREE_NOERROR/0/g, s/XFS_BTREE_ERROR/-EIO/g
should do the job.
