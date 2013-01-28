Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id E14237F7B
	for <xfs@oss.sgi.com>; Mon, 28 Jan 2013 16:42:02 -0600 (CST)
Date: Mon, 28 Jan 2013 16:42:02 -0600
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH]xfs: Fix xfs_swap_extents() after removal of
	xfs_flushinval_pages()
Message-ID: <20130128224202.GE27055@sgi.com>
References: <20130120102449.397b3f8b@googlemail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130120102449.397b3f8b@googlemail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Torsten Kaiser <just.for.lkml@googlemail.com>
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com

On Sun, Jan 20, 2013 at 10:24:49AM +0100, Torsten Kaiser wrote:
> From: Torsten Kaiser <just.for.lkml@googlemail.com>
> 
> Commit fb59581404ab7ec5075299065c22cb211a9262a9 removed
> xfs_flushinval_pages() and changed its callers to use
> filemap_write_and_wait() and  truncate_pagecache_range() directly.
> 
> But in xfs_swap_extents() this change accidental switched the argument
> for 'tip' to 'ip'. This patch switches it back to 'tip'
> 
> Signed-off-by: Torsten Kaiser <just.for.lkml@googlemail.com>

Looks good.
Reviewed-by: Ben Myers <bpm@sgi.com>

Thanks Torsten!

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
