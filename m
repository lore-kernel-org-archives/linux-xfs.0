Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q5E3rjjT214218 for <xfs@oss.sgi.com>; Wed, 13 Jun 2012 22:53:46 -0500
Received: from mail-pz0-f53.google.com (mail-pz0-f53.google.com
	[209.85.210.53]) by cuda.sgi.com with ESMTP id ZxsCgdjRtpPawKJv
	(version=TLSv1 cipher=RC4-MD5 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 13 Jun 2012 20:53:44 -0700 (PDT)
Received: by dadg9 with SMTP id g9so2312370dad.26
	for <xfs@oss.sgi.com>; Wed, 13 Jun 2012 20:53:44 -0700 (PDT)
Date: Wed, 13 Jun 2012 20:53:42 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
Subject: Re: [PATCH] mm: add gfp_mask parameter to vm_map_ram()
In-Reply-To: <20120614033429.GD7339@dastard>
Message-ID: <alpine.DEB.2.00.1206132049540.6126@chino.kir.corp.google.com>
References: <20120612012134.GA7706@localhost> <20120613123932.GA1445@localhost>
	<20120614012026.GL3019@devil.redhat.com>
	<20120614014902.GB7289@localhost> <4FD94779.3030108@kernel.org>
	<20120614033429.GD7339@dastard>
MIME-Version: 1.0
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
To: Dave Chinner <david@fromorbit.com>
Cc: Linux Memory Management List <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, Minchan Kim <minchan@kernel.org>, Dave Chinner <dchinner@redhat.com>, linux-fsdevel@vger.kernel.org, Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Fengguang Wu <fengguang.wu@intel.com>

On Thu, 14 Jun 2012, Dave Chinner wrote:

> Oh, please. I have been hearing this for years, and are we any
> closer to it? No, we are further away from ever being able to
> acheive this than ever. Face it, filesystems require memory
> allocation to write dirty data to disk, and the amount is almost
> impossible to define. Hence mempools can't be used because we can't
> give any guarantees of forward progress. And for vmalloc?
> 
> Filesystems widely use vmalloc/vm_map_ram because kmalloc fails on
> large contiguous allocations. This renders kmalloc unfit for
> purpose, so we have to fall back to single page allocation and
> vm_map_ram or vmalloc so that the filesystem can function properly.
> And to avoid deadlocks, all memory allocation must be able to
> specify GFP_NOFS to prevent the MM subsystem from recursing into the
> filesystem. Therefore, vmalloc needs to support GFP_NOFS.
> 
> I don't care how you make it happen, just fix it. Trying to place
> the blame on the filesystem folk for using vmalloc in GFP_NOFS
> contexts is a total and utter cop-out, because mm folk of all people
> should know that non-zero order kmalloc is not a reliable
> alternative....
> 

I'd actually like to see a demonstrated problem (i.e. not theoretical) 
where vmalloc() stalls indefinitely because its passed GFP_NOFS.  I've 
never seen one reported.

This is because the per-arch pte allocators have hardwired GFP_KERNEL 
flags, but then again they also have __GFP_REPEAT which would cause them 
to loop infinitely in the page allocator if a page was not reclaimed, 
which has little success without __GFP_FS.  But nobody has ever reported a 
livelock that was triaged back to passing !__GFP_FS to vmalloc().

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
