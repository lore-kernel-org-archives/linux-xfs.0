Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:44486 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726634AbfBDVtp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 4 Feb 2019 16:49:45 -0500
Date: Mon, 4 Feb 2019 13:49:32 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 06/10] xfs: refactor inode unlinked pointer update
 functions
Message-ID: <20190204214932.GC7991@magnolia>
References: <154930313674.31814.17994684613232167921.stgit@magnolia>
 <154930318001.31814.5345699579287768446.stgit@magnolia>
 <20190204205628.GE30334@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190204205628.GE30334@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org

On Mon, Feb 04, 2019 at 12:56:28PM -0800, Christoph Hellwig wrote:
> > +	/* Make sure the old pointer isn't garbage. */
> > +	old_value = be32_to_cpu(dip->di_next_unlinked);
> > +	if (old_value != NULLAGINO && !xfs_verify_agino(mp, agno, old_value)) {
> 
> Couldn't this use xfs_verify_agino_or_null?

Oops, missed that.  Will fix.

--D

> Otherwise looks fine:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
