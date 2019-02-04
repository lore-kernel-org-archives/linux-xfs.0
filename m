Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:37644 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725855AbfBDU43 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 4 Feb 2019 15:56:29 -0500
Date: Mon, 4 Feb 2019 12:56:28 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 06/10] xfs: refactor inode unlinked pointer update
 functions
Message-ID: <20190204205628.GE30334@infradead.org>
References: <154930313674.31814.17994684613232167921.stgit@magnolia>
 <154930318001.31814.5345699579287768446.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <154930318001.31814.5345699579287768446.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

> +	/* Make sure the old pointer isn't garbage. */
> +	old_value = be32_to_cpu(dip->di_next_unlinked);
> +	if (old_value != NULLAGINO && !xfs_verify_agino(mp, agno, old_value)) {

Couldn't this use xfs_verify_agino_or_null?

Otherwise looks fine:

Reviewed-by: Christoph Hellwig <hch@lst.de>
