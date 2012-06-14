Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q5E2LkwJ209284 for <xfs@oss.sgi.com>; Wed, 13 Jun 2012 21:21:46 -0500
Received: from mail-ob0-f181.google.com (mail-ob0-f181.google.com
	[209.85.214.181]) by cuda.sgi.com with ESMTP id
	jS6sws2X7UdSuAEl (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Wed, 13 Jun 2012 19:21:45 -0700 (PDT)
Received: by obbuo19 with SMTP id uo19so1921906obb.26
	for <xfs@oss.sgi.com>; Wed, 13 Jun 2012 19:21:44 -0700 (PDT)
Date: Thu, 14 Jun 2012 11:21:32 +0900
From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] mm: add gfp_mask parameter to vm_map_ram()
Message-ID: <20120614022132.GA3766@dhcp-172-17-108-109.mtv.corp.google.com>
References: <20120612012134.GA7706@localhost> <20120613123932.GA1445@localhost>
	<20120614012026.GL3019@devil.redhat.com>
	<20120614014902.GB7289@localhost> <4FD94779.3030108@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4FD94779.3030108@kernel.org>
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
To: Minchan Kim <minchan@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, Linux Memory Management List <linux-mm@kvack.org>, Dave Chinner <dchinner@redhat.com>, linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Fengguang Wu <fengguang.wu@intel.com>

Hello, guys.

On Thu, Jun 14, 2012 at 11:07:53AM +0900, Minchan Kim wrote:
> It shouldn't work because vmap_page_range still can allocate
> GFP_KERNEL by pud_alloc in vmap_pud_range.  For it, I tried [1] but
> other mm guys want to add WARNING [2] so let's avoiding gfp context
> passing.
> 
> [1] https://lkml.org/lkml/2012/4/23/77
> [2] https://lkml.org/lkml/2012/5/2/340

Yeah, vmalloc area doesn't support !GFP_KERNEL allocations and as
Minchan said, changing this would require updating page table
allocation functions on all archs.  This is the same reason why percpu
allocator doesn't support !GFP_KERNEL allocations which in turn made
blk-throttle implement its own private percpu pool.

If xfs can't live without GFP_NOFS vmalloc allocations, either it has
to implement its own pool or maybe it's time to implement !GFP_KERNEL
allocs for vmalloc area.  I don't know.

Thanks.

-- 
tejun

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
