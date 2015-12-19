Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 7FF307F52
	for <xfs@oss.sgi.com>; Fri, 18 Dec 2015 23:23:53 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 6F2ED8F8065
	for <xfs@oss.sgi.com>; Fri, 18 Dec 2015 21:23:53 -0800 (PST)
Received: from mga04.intel.com ([192.55.52.120]) by cuda.sgi.com with ESMTP id
	kpL9oPrvNmw1IDwJ for <xfs@oss.sgi.com>;
	Fri, 18 Dec 2015 21:23:52 -0800 (PST)
Date: Fri, 18 Dec 2015 22:23:49 -0700
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH v3 2/7] dax: support dirty DAX entries in radix tree
Message-ID: <20151219052349.GA3553@linux.intel.com>
References: <1449602325-20572-1-git-send-email-ross.zwisler@linux.intel.com>
	<1449602325-20572-3-git-send-email-ross.zwisler@linux.intel.com>
	<20151218090110.GB4297@quack.suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20151218090110.GB4297@quack.suse.cz>
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
To: Jan Kara <jack@suse.cz>
Cc: Dave Hansen <dave.hansen@linux.intel.com>, "J. Bruce Fields" <bfields@fieldses.org>, linux-mm@kvack.org, Andreas Dilger <adilger.kernel@dilger.ca>, "H. Peter Anvin" <hpa@zytor.com>, Jeff Layton <jlayton@poochiereds.net>, Dan Williams <dan.j.williams@intel.com>, linux-nvdimm@lists.01.org, x86@kernel.org, Ingo Molnar <mingo@redhat.com>, Matthew Wilcox <willy@linux.intel.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, linux-ext4@vger.kernel.org, xfs@oss.sgi.com, Alexander Viro <viro@zeniv.linux.org.uk>, Thomas Gleixner <tglx@linutronix.de>, Theodore Ts'o <tytso@mit.edu>, linux-kernel@vger.kernel.org, Jan Kara <jack@suse.com>, linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Matthew Wilcox <matthew.r.wilcox@intel.com>

On Fri, Dec 18, 2015 at 10:01:10AM +0100, Jan Kara wrote:
> On Tue 08-12-15 12:18:40, Ross Zwisler wrote:
> > Add support for tracking dirty DAX entries in the struct address_space
> > radix tree.  This tree is already used for dirty page writeback, and it
> > already supports the use of exceptional (non struct page*) entries.
> > 
> > In order to properly track dirty DAX pages we will insert new exceptional
> > entries into the radix tree that represent dirty DAX PTE or PMD pages.
> > These exceptional entries will also contain the writeback addresses for the
> > PTE or PMD faults that we can use at fsync/msync time.
> > 
> > There are currently two types of exceptional entries (shmem and shadow)
> > that can be placed into the radix tree, and this adds a third.  There
> > shouldn't be any collisions between these various exceptional entries
> > because only one type of exceptional entry should be able to be found in a
> > radix tree at a time depending on how it is being used.
> 
> I was thinking about this and I'm not sure the use of exceptional entries
> cannot collide. DAX uses page cache for read mapping of holes. When memory
> pressure happens, page can get evicted again and entry in the radix tree
> will get replaced with a shadow entry. So shadow entries *can* exist in DAX
> mappings. Thus at least your change to clear_exceptional_entry() looks
> wrong to me.
> 
> Also when we'd like to insert DAX radix tree entry, we have to count with
> the fact that there can be shadow entry in place and we have to tear it
> down properly.

You are right, thank you for catching this.

I think the correct thing to do is to just explicitly disallow having shadow
entries in trees for DAX mappings.  As you say the only usage is to track zero
page mappings for reading holes which will get minimal benefit from shadow
entries, and this choice makes the logic both in clear_exceptional_entry() and
in the rest of the DAX code simpler.

I've sent out a v5 that fixes this issue.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
