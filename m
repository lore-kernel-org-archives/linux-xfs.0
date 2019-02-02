Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:34936 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727770AbfBBQ1h (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 2 Feb 2019 11:27:37 -0500
Date: Sat, 2 Feb 2019 08:27:37 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 5/8] xfs: refactor inode unlinked pointer update functions
Message-ID: <20190202162737.GC25154@infradead.org>
References: <154897667054.26065.13164381203002725289.stgit@magnolia>
 <154897670150.26065.2878806054016276963.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <154897670150.26065.2878806054016276963.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

> +	ASSERT(new_agino == NULLAGINO ||
> +	       xfs_verify_agino(mp, XFS_INO_TO_AGNO(mp, ino), new_agino));

We have quite a few uses of this pattern.  Shouldn't we just add a
a xfs_verify_agino_or_null helper?

Also given that the caller has the agno and we use it a few times
maybe pass it as an argument?

Also shouldn't new_agino be called something like next_agino or at
least have a little comment explaining what it stands for?

> +	xfs_trans_log_buf(tp, ibp, offset, (offset + sizeof(xfs_agino_t) - 1));

No need for the innter braces.

Otherwise this looks conceptually fine to me.
