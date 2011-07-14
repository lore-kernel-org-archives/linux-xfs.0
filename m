Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6EF7BUJ142666 for <xfs@oss.sgi.com>; Thu, 14 Jul 2011 10:07:11 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 056D36D048
	for <xfs@oss.sgi.com>; Thu, 14 Jul 2011 08:07:10 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	EQ2SKN8CrB7wmRiE for <xfs@oss.sgi.com>;
	Thu, 14 Jul 2011 08:07:10 -0700 (PDT)
Date: Thu, 14 Jul 2011 11:07:00 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/5] mm: vmscan: Do not writeback filesystem pages in
	direct reclaim
Message-ID: <20110714150700.GC23587@infradead.org>
References: <1310567487-15367-1-git-send-email-mgorman@suse.de>
	<1310567487-15367-2-git-send-email-mgorman@suse.de>
	<20110714103801.83e10fdb.kamezawa.hiroyu@jp.fujitsu.com>
	<20110714044643.GA3203@infradead.org>
	<20110714134634.4a7a15c8.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110714134634.4a7a15c8.kamezawa.hiroyu@jp.fujitsu.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Rik van Riel <riel@redhat.com>, Jan Kara <jack@suse.cz>, LKML <linux-kernel@vger.kernel.org>, XFS <xfs@oss.sgi.com>, Christoph Hellwig <hch@infradead.org>, Linux-MM <linux-mm@kvack.org>, Mel Gorman <mgorman@suse.de>, Wu Fengguang <fengguang.wu@intel.com>, Johannes Weiner <jweiner@redhat.com>, Minchan Kim <minchan.kim@gmail.com>

On Thu, Jul 14, 2011 at 01:46:34PM +0900, KAMEZAWA Hiroyuki wrote:
> > XFS and btrfs already disable writeback from memcg context, as does ext4
> > for the typical non-overwrite workloads, and none has fallen apart.
> > 
> > In fact there's no way we can enable them as the memcg calling contexts
> > tend to have massive stack usage.
> > 
> 
> Hmm, XFS/btrfs adds pages to radix-tree in deep stack ?

We're using a fairly deep stack in normal buffered read/write,
wich is almost 100% common code.  It's not just the long callchain
(see below), but also that we put the unneeded kiocb and a vector
of I/O vects on the stack:

vfs_writev
do_readv_writev
do_sync_write
generic_file_aio_write
__generic_file_aio_write
generic_file_buffered_write
generic_perform_write
block_write_begin
grab_cache_page_write_begin
add_to_page_cache_lru
add_to_page_cache
add_to_page_cache_locked
mem_cgroup_cache_charge

this might additionally come from in-kernel callers like nfsd,
which has even more stack space used.  And at this point we only
enter the memcg/reclaim code, which last time I had a stack trace
ate up another about 3k of stack space.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
