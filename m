Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id E29D87F4E
	for <xfs@oss.sgi.com>; Fri, 30 Oct 2015 13:34:10 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 5870DAC002
	for <xfs@oss.sgi.com>; Fri, 30 Oct 2015 11:34:10 -0700 (PDT)
Received: from mail-wi0-f179.google.com (mail-wi0-f179.google.com
	[209.85.212.179]) by cuda.sgi.com with ESMTP id
	bwF82aAV6GWh0UUQ (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 30 Oct 2015 11:34:08 -0700 (PDT)
Received: by wijp11 with SMTP id p11so16826932wij.0
	for <xfs@oss.sgi.com>; Fri, 30 Oct 2015 11:34:07 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1446149535-16200-1-git-send-email-ross.zwisler@linux.intel.com>
References: <1446149535-16200-1-git-send-email-ross.zwisler@linux.intel.com>
Date: Fri, 30 Oct 2015 11:34:07 -0700
Message-ID: <CAPcyv4haGNytokPfgL3m-qOEw=BO4QF5dO3woLSYZDCRmL-YWg@mail.gmail.com>
Subject: Re: [RFC 00/11] DAX fsynx/msync support
From: Dan Williams <dan.j.williams@intel.com>
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
Cc: X86 ML <x86@kernel.org>, Theodore Ts'o <tytso@mit.edu>, Andrew Morton <akpm@linux-foundation.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Jan Kara <jack@suse.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com, "J. Bruce Fields" <bfields@fieldses.org>, Linux MM <linux-mm@kvack.org>, Ingo Molnar <mingo@redhat.com>, Andreas Dilger <adilger.kernel@dilger.ca>, Alexander Viro <viro@zeniv.linux.org.uk>, "H. Peter Anvin" <hpa@zytor.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Matthew Wilcox <willy@linux.intel.com>, Jeff Layton <jlayton@poochiereds.net>, linux-ext4@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>, Matthew Wilcox <matthew.r.wilcox@intel.com>

On Thu, Oct 29, 2015 at 1:12 PM, Ross Zwisler
<ross.zwisler@linux.intel.com> wrote:
> This patch series adds support for fsync/msync to DAX.
>
> Patches 1 through 8 add various utilities that the DAX code will eventually
> need, and the DAX code itself is added by patch 9.  Patches 10 and 11 are
> filesystem changes that are needed after the DAX code is added, but these
> patches may change slightly as the filesystem fault handling for DAX is
> being modified ([1] and [2]).
>
> I've marked this series as RFC because I'm still testing, but I wanted to
> get this out there so people would see the direction I was going and
> hopefully comment on any big red flags sooner rather than later.
>
> I realize that we are getting pretty dang close to the v4.4 merge window,
> but I think that if we can get this reviewed and working it's a much better
> solution than the "big hammer" approach that blindly flushes entire PMEM
> namespaces [3].
>
> [1] http://oss.sgi.com/archives/xfs/2015-10/msg00523.html
> [2] http://marc.info/?l=linux-ext4&m=144550211312472&w=2
> [3] https://lists.01.org/pipermail/linux-nvdimm/2015-October/002614.html
>
> Ross Zwisler (11):
>   pmem: add wb_cache_pmem() to the PMEM API
>   mm: add pmd_mkclean()
>   pmem: enable REQ_FLUSH handling
>   dax: support dirty DAX entries in radix tree
>   mm: add follow_pte_pmd()
>   mm: add pgoff_mkclean()
>   mm: add find_get_entries_tag()
>   fs: add get_block() to struct inode_operations
>   dax: add support for fsync/sync
>   xfs, ext2: call dax_pfn_mkwrite() on write fault
>   ext4: add ext4_dax_pfn_mkwrite()

This is great to have when the flush-the-world solution ends up
killing performance.  However, there are a couple mitigating options
for workloads that dirty small amounts and flush often that we need to
collect data on:

1/ Using cache management and pcommit from userspace to skip calls to
msync / fsync.  Although, this does not eliminate all calls to
blkdev_issue_flush as the fs may invoke it for other reasons.  I
suspect turning on REQ_FUA support eliminates a number of those
invocations, and pmem already satisfies REQ_FUA semantics by default.

2/ Turn off DAX and use the page cache.  As Dave mentions [1] we
should enable this control on a per-inode basis.  I'm folding in this
capability as a blkdev_ioctl for the next version of the raw block DAX
support patch.

It's entirely possible these mitigations won't eliminate the need for
a mechanism like this, but I think we have a bit more work to do to
find out how bad this is in practice as well as the crossover point
where walking the radix becomes prohibitive.

We also have the option of tracking open DAX extents in the driver.
Even at coarse granularities I'd be surprised if we can't mitigate
most of the overhead.

[1]: https://lists.01.org/pipermail/linux-nvdimm/2015-October/002598.html

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
