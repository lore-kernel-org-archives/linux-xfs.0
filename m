Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 190037F37
	for <xfs@oss.sgi.com>; Tue, 22 Dec 2015 18:00:21 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 914CDAC004
	for <xfs@oss.sgi.com>; Tue, 22 Dec 2015 16:00:17 -0800 (PST)
Received: from mga01.intel.com ([192.55.52.88]) by cuda.sgi.com with ESMTP id
	3nriHoIE9miGi9qF for <xfs@oss.sgi.com>;
	Tue, 22 Dec 2015 16:00:16 -0800 (PST)
Date: Tue, 22 Dec 2015 17:00:10 -0700
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH v5 1/7] pmem: add wb_cache_pmem() to the PMEM API
Message-ID: <20151223000010.GB24124@linux.intel.com>
References: <1450502540-8744-1-git-send-email-ross.zwisler@linux.intel.com>
	<1450502540-8744-2-git-send-email-ross.zwisler@linux.intel.com>
	<20151222144440.1ad9e076464f4751f3de6a1f@linux-foundation.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20151222144440.1ad9e076464f4751f3de6a1f@linux-foundation.org>
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
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-nvdimm@ml01.01.org, Dave Hansen <dave.hansen@linux.intel.com>, "J. Bruce Fields" <bfields@fieldses.org>, linux-mm@kvack.org, Andreas Dilger <adilger.kernel@dilger.ca>, "H. Peter Anvin" <hpa@zytor.com>, Jeff Layton <jlayton@poochiereds.net>, Dan Williams <dan.j.williams@intel.com>, x86@kernel.org, Ingo Molnar <mingo@redhat.com>, Matthew Wilcox <willy@linux.intel.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, linux-ext4@vger.kernel.org, xfs@oss.sgi.com, Alexander Viro <viro@zeniv.linux.org.uk>, Thomas Gleixner <tglx@linutronix.de>, Theodore Ts'o <tytso@mit.edu>, linux-kernel@vger.kernel.org, Jan Kara <jack@suse.com>, linux-fsdevel@vger.kernel.org, Matthew Wilcox <matthew.r.wilcox@intel.com>

On Tue, Dec 22, 2015 at 02:44:40PM -0800, Andrew Morton wrote:
> On Fri, 18 Dec 2015 22:22:14 -0700 Ross Zwisler <ross.zwisler@linux.intel.com> wrote:
> 
> > The function __arch_wb_cache_pmem() was already an internal implementation
> > detail of the x86 PMEM API, but this functionality needs to be exported as
> > part of the general PMEM API to handle the fsync/msync case for DAX mmaps.
> > 
> > One thing worth noting is that we really do want this to be part of the
> > PMEM API as opposed to a stand-alone function like clflush_cache_range()
> > because of ordering restrictions.  By having wb_cache_pmem() as part of the
> > PMEM API we can leave it unordered, call it multiple times to write back
> > large amounts of memory, and then order the multiple calls with a single
> > wmb_pmem().
> > 
> > @@ -138,7 +139,7 @@ static inline void arch_clear_pmem(void __pmem *addr, size_t size)
> >  	else
> >  		memset(vaddr, 0, size);
> >  
> > -	__arch_wb_cache_pmem(vaddr, size);
> > +	arch_wb_cache_pmem(addr, size);
> >  }
> >  
> 
> reject.  I made this
> 
> 	arch_wb_cache_pmem(vaddr, size);
> 
> due to Dan's
> http://www.ozlabs.org/~akpm/mmots/broken-out/pmem-dax-clean-up-clear_pmem.patch

The first argument seems wrong to me - in arch_clear_pmem() 'addr' and 'vaddr'
are the same address, with the only difference being 'addr' has the __pmem
annotation.

As of this patch arch_wb_cache_pmem() follows the lead of the rest of the
exported PMEM API functions and takes an argument that has the __pmem
annotation, so I believe it should be:

arch_wb_cache_pmem(addr, size);

Without this I think you'll get a sparse warning.

This will be fixed up in the next version of my series which build upon Dan's
patches.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
