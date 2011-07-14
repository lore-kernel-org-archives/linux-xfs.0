Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6F02Yqs174931 for <xfs@oss.sgi.com>; Thu, 14 Jul 2011 19:02:35 -0500
Received: from fgwmail6.fujitsu.co.jp (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2DEDD11EE632
	for <xfs@oss.sgi.com>; Thu, 14 Jul 2011 17:02:33 -0700 (PDT)
Received: from fgwmail6.fujitsu.co.jp (fgwmail6.fujitsu.co.jp [192.51.44.36])
	by cuda.sgi.com with ESMTP id XfcJKE9Y0z9Bio22 for
	<xfs@oss.sgi.com>; Thu, 14 Jul 2011 17:02:33 -0700 (PDT)
Received: from m4.gw.fujitsu.co.jp (unknown [10.0.50.74])
	by fgwmail6.fujitsu.co.jp (Postfix) with ESMTP id B6A243EE0C0
	for <xfs@oss.sgi.com>; Fri, 15 Jul 2011 09:02:31 +0900 (JST)
Received: from smail (m4 [127.0.0.1])
	by outgoing.m4.gw.fujitsu.co.jp (Postfix) with ESMTP id 9BC1F45DF12
	for <xfs@oss.sgi.com>; Fri, 15 Jul 2011 09:02:31 +0900 (JST)
Received: from s4.gw.fujitsu.co.jp (s4.gw.fujitsu.co.jp [10.0.50.94])
	by m4.gw.fujitsu.co.jp (Postfix) with ESMTP id 7DF5F45DF0F
	for <xfs@oss.sgi.com>; Fri, 15 Jul 2011 09:02:31 +0900 (JST)
Received: from s4.gw.fujitsu.co.jp (localhost.localdomain [127.0.0.1])
	by s4.gw.fujitsu.co.jp (Postfix) with ESMTP id 6AFD91DB8037
	for <xfs@oss.sgi.com>; Fri, 15 Jul 2011 09:02:31 +0900 (JST)
Received: from m106.s.css.fujitsu.com (m106.s.css.fujitsu.com [10.240.81.146])
	by s4.gw.fujitsu.co.jp (Postfix) with ESMTP id 352A21DB8044
	for <xfs@oss.sgi.com>; Fri, 15 Jul 2011 09:02:31 +0900 (JST)
Date: Fri, 15 Jul 2011 08:55:20 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH 1/5] mm: vmscan: Do not writeback filesystem pages in
	direct reclaim
Message-Id: <20110715085520.23feca2d.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20110714150700.GC23587@infradead.org>
References: <1310567487-15367-1-git-send-email-mgorman@suse.de>
	<1310567487-15367-2-git-send-email-mgorman@suse.de>
	<20110714103801.83e10fdb.kamezawa.hiroyu@jp.fujitsu.com>
	<20110714044643.GA3203@infradead.org>
	<20110714134634.4a7a15c8.kamezawa.hiroyu@jp.fujitsu.com>
	<20110714150700.GC23587@infradead.org>
Mime-Version: 1.0
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
To: Christoph Hellwig <hch@infradead.org>
Cc: Rik van Riel <riel@redhat.com>, Jan Kara <jack@suse.cz>, LKML <linux-kernel@vger.kernel.org>, XFS <xfs@oss.sgi.com>, Linux-MM <linux-mm@kvack.org>, Mel Gorman <mgorman@suse.de>, Wu Fengguang <fengguang.wu@intel.com>, Johannes Weiner <jweiner@redhat.com>, Minchan Kim <minchan.kim@gmail.com>

On Thu, 14 Jul 2011 11:07:00 -0400
Christoph Hellwig <hch@infradead.org> wrote:

> On Thu, Jul 14, 2011 at 01:46:34PM +0900, KAMEZAWA Hiroyuki wrote:
> > > XFS and btrfs already disable writeback from memcg context, as does ext4
> > > for the typical non-overwrite workloads, and none has fallen apart.
> > > 
> > > In fact there's no way we can enable them as the memcg calling contexts
> > > tend to have massive stack usage.
> > > 
> > 
> > Hmm, XFS/btrfs adds pages to radix-tree in deep stack ?
> 
> We're using a fairly deep stack in normal buffered read/write,
> wich is almost 100% common code.  It's not just the long callchain
> (see below), but also that we put the unneeded kiocb and a vector
> of I/O vects on the stack:
> 
> vfs_writev
> do_readv_writev
> do_sync_write
> generic_file_aio_write
> __generic_file_aio_write
> generic_file_buffered_write
> generic_perform_write
> block_write_begin
> grab_cache_page_write_begin
> add_to_page_cache_lru
> add_to_page_cache
> add_to_page_cache_locked
> mem_cgroup_cache_charge
> 
> this might additionally come from in-kernel callers like nfsd,
> which has even more stack space used.  And at this point we only
> enter the memcg/reclaim code, which last time I had a stack trace
> ate up another about 3k of stack space.
> 

Hmm. I'll prepare 2 functions for memcg 
  1. asynchronous memory reclaim as kswapd does.
  2. dirty_ratio

please remove ->writepage 1st. It may break memcg but it happens sometimes.
We'll do fix.

Thanks,
-Kame

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
