Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q98EQxCV079811 for <xfs@oss.sgi.com>; Mon, 8 Oct 2012 09:26:59 -0500
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id u4NujWUHx7LUhmkd (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 08 Oct 2012 07:28:28 -0700 (PDT)
Date: Mon, 8 Oct 2012 15:28:23 +0100
From: Mel Gorman <mgorman@suse.de>
Subject: Re: [PATCH] mm: Fix XFS oops due to dirty pages without buffers on
	s390
Message-ID: <20121008142823.GL29125@suse.de>
References: <1349108796-32161-1-git-send-email-jack@suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1349108796-32161-1-git-send-email-jack@suse.cz>
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
To: Jan Kara <jack@suse.cz>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>, linux-mm@kvack.org, linux-s390@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com

On Mon, Oct 01, 2012 at 06:26:36PM +0200, Jan Kara wrote:
> On s390 any write to a page (even from kernel itself) sets architecture
> specific page dirty bit. Thus when a page is written to via standard write, HW
> dirty bit gets set and when we later map and unmap the page, page_remove_rmap()
> finds the dirty bit and calls set_page_dirty().
> 
> Dirtying of a page which shouldn't be dirty can cause all sorts of problems to
> filesystems. The bug we observed in practice is that buffers from the page get
> freed, so when the page gets later marked as dirty and writeback writes it, XFS
> crashes due to an assertion BUG_ON(!PagePrivate(page)) in page_buffers() called
> from xfs_count_page_state().
> 
> Similar problem can also happen when zero_user_segment() call from
> xfs_vm_writepage() (or block_write_full_page() for that matter) set the
> hardware dirty bit during writeback, later buffers get freed, and then page
> unmapped.
> 
> Fix the issue by ignoring s390 HW dirty bit for page cache pages in
> page_mkclean() and page_remove_rmap(). This is safe because when a page gets
> marked as writeable in PTE it is also marked dirty in do_wp_page() or
> do_page_fault(). When the dirty bit is cleared by clear_page_dirty_for_io(),
> the page gets writeprotected in page_mkclean(). So pagecache page is writeable
> if and only if it is dirty.
> 
> CC: Martin Schwidefsky <schwidefsky@de.ibm.com>
> CC: Mel Gorman <mgorman@suse.de>
> CC: linux-s390@vger.kernel.org
> Signed-off-by: Jan Kara <jack@suse.cz>

Acked-by: Mel Gorman <mgorman@suse.de>

-- 
Mel Gorman
SUSE Labs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
