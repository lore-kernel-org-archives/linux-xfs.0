Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:52785 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753090AbdLNQdh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 14 Dec 2017 11:33:37 -0500
Date: Thu, 14 Dec 2017 08:33:37 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/3] xfs: ubsan fixes
Message-ID: <20171214163337.GA11003@infradead.org>
References: <151189079681.14861.10709810493861130558.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <151189079681.14861.10709810493861130558.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Tue, Nov 28, 2017 at 09:39:56AM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Fix some complaints from the UBSAN about signed integer addition overflows.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

I only noticed that now that it's in Linus' tree.  Need to find some
more time for the XFS list..

> -	if (offset + count > mp->m_super->s_maxbytes)
> +	if ((xfs_ufsize_t)offset + count > mp->m_super->s_maxbytes)
>  		count = mp->m_super->s_maxbytes - offset;

I don't think this fix is useful in any meaninfless way.  Yes,
signed overflow in C is undefined, and unsigned overflow is and this
will shut up UBSAN.  But it doesn't solve the problem at all.

Assuming we still need these checks and the VFS doesn't take care of
it already (I'd need to double check) we want to truncate at s_maxbytes,
and assuming s_maxbytes is close to ULLONG_MAX and count makes it
overflow this will give the wrong result, as it won't cap anything.

What we'd need instead would be something like:

	if (offset > mp->m_super->s_maxbytes - count)
		count = mp->m_super->s_maxbytes - offset;

as that does the right thing.
