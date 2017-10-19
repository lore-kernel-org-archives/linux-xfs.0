Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:44286 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751845AbdJSHfw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 19 Oct 2017 03:35:52 -0400
Date: Thu, 19 Oct 2017 00:35:51 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH V2] xfs: implement cgroup writeback support
Message-ID: <20171019073551.GA17333@infradead.org>
References: <20171015050751.dfznko2hxhi6jvra@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171015050751.dfznko2hxhi6jvra@kernel.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Shaohua Li <shli@kernel.org>
Cc: linux-xfs@vger.kernel.org, darrick.wong@oracle.com, david@fromorbit.com, tj@kernel.org, Kernel-team@fb.com

> -		wpc->ioend = xfs_alloc_ioend(inode, wpc->io_type, offset, bh);
> +		wpc->ioend = xfs_alloc_ioend(inode, wpc->io_type, offset, bh, wbc);

Too long line, please fix.

> +	sb->s_iflags |= SB_I_CGROUPWB;

Didn't Tejun just change this to a per-inode flag?
