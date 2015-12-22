Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id D333529DF5
	for <xfs@oss.sgi.com>; Tue, 22 Dec 2015 16:44:47 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id B4F88304032
	for <xfs@oss.sgi.com>; Tue, 22 Dec 2015 14:44:44 -0800 (PST)
Received: from mail.linuxfoundation.org (mail.linuxfoundation.org
	[140.211.169.12]) by cuda.sgi.com with ESMTP id
	ijMW8cWMOPPvyDgb (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 22 Dec 2015 14:44:42 -0800 (PST)
Date: Tue, 22 Dec 2015 14:44:40 -0800
From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v5 1/7] pmem: add wb_cache_pmem() to the PMEM API
Message-Id: <20151222144440.1ad9e076464f4751f3de6a1f@linux-foundation.org>
In-Reply-To: <1450502540-8744-2-git-send-email-ross.zwisler@linux.intel.com>
References: <1450502540-8744-1-git-send-email-ross.zwisler@linux.intel.com>
	<1450502540-8744-2-git-send-email-ross.zwisler@linux.intel.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: x86@kernel.org, Theodore Ts'o <tytso@mit.edu>, linux-nvdimm@ml01.01.org, Jan Kara <jack@suse.com>, linux-kernel@vger.kernel.org, Dave Hansen <dave.hansen@linux.intel.com>, xfs@oss.sgi.com, "J. Bruce Fields" <bfields@fieldses.org>, linux-mm@kvack.org, Ingo Molnar <mingo@redhat.com>, Andreas Dilger <adilger.kernel@dilger.ca>, Alexander Viro <viro@zeniv.linux.org.uk>, "H. Peter Anvin" <hpa@zytor.com>, linux-fsdevel@vger.kernel.org, Matthew Wilcox <willy@linux.intel.com>, Jeff Layton <jlayton@poochiereds.net>, linux-ext4@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>, Dan Williams <dan.j.williams@intel.com>, Matthew Wilcox <matthew.r.wilcox@intel.com>

On Fri, 18 Dec 2015 22:22:14 -0700 Ross Zwisler <ross.zwisler@linux.intel.com> wrote:

> The function __arch_wb_cache_pmem() was already an internal implementation
> detail of the x86 PMEM API, but this functionality needs to be exported as
> part of the general PMEM API to handle the fsync/msync case for DAX mmaps.
> 
> One thing worth noting is that we really do want this to be part of the
> PMEM API as opposed to a stand-alone function like clflush_cache_range()
> because of ordering restrictions.  By having wb_cache_pmem() as part of the
> PMEM API we can leave it unordered, call it multiple times to write back
> large amounts of memory, and then order the multiple calls with a single
> wmb_pmem().
> 
> @@ -138,7 +139,7 @@ static inline void arch_clear_pmem(void __pmem *addr, size_t size)
>  	else
>  		memset(vaddr, 0, size);
>  
> -	__arch_wb_cache_pmem(vaddr, size);
> +	arch_wb_cache_pmem(addr, size);
>  }
>  

reject.  I made this

	arch_wb_cache_pmem(vaddr, size);

due to Dan's
http://www.ozlabs.org/~akpm/mmots/broken-out/pmem-dax-clean-up-clear_pmem.patch

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
