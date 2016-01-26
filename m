Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 9B8C27CA2
	for <xfs@oss.sgi.com>; Tue, 26 Jan 2016 06:48:17 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 7A5048F8033
	for <xfs@oss.sgi.com>; Tue, 26 Jan 2016 04:48:17 -0800 (PST)
Received: from mga14.intel.com ([192.55.52.115]) by cuda.sgi.com with ESMTP id
	FIwWWnbpXHvyQeIK for <xfs@oss.sgi.com>;
	Tue, 26 Jan 2016 04:48:15 -0800 (PST)
Date: Tue, 26 Jan 2016 07:48:12 -0500
From: Matthew Wilcox <willy@linux.intel.com>
Subject: Re: [RFC PATCH] dax, ext2, ext4, XFS: fix data corruption race
Message-ID: <20160126124812.GJ2948@linux.intel.com>
References: <1453503971-5319-1-git-send-email-ross.zwisler@linux.intel.com>
	<20160124220107.GI20456@dastard>
	<20160125135921.GE24938@quack.suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160125135921.GE24938@quack.suse.cz>
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
Cc: Theodore Ts'o <tytso@mit.edu>, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, Andreas Dilger <adilger.kernel@dilger.ca>, Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.com>, linux-fsdevel@vger.kernel.org, Ross Zwisler <ross.zwisler@linux.intel.com>, linux-ext4@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Dan Williams <dan.j.williams@intel.com>

On Mon, Jan 25, 2016 at 02:59:21PM +0100, Jan Kara wrote:
> On Mon 25-01-16 09:01:07, Dave Chinner wrote:
> > What happens if we get rid of that DAX write fault optimisation that
> > skips the initial read fault? The write fault will always run on a
> > mapping that has a hole loaded, right?, so the race between
> > dax_load_hole() and dax_insert_mapping() goes away, because nothing
> > will be calling dax_load_hole() once the write fault is allocating
> > blocks....
> 
> So frankly I don't like mixing of page locks into the DAX fault locking.
> Also your scheme would require more tricks to deal with races between PMD
> write faults racing with PTE read faults since you don't want to require
> 2MB worth of hole-pages to be able to do a PMD write fault. Transparent
> huge pages deal with this issue using compound pages but I'd like to avoid
> that horror in the DAX path...

I *think* that what Dave's proposing (and if he isn't, I'm proposing it
for him) is that the filesystem takes its allocation lock shared during
the ->fault handler, then in the ->page_mkwrite handler, it knows that an
allocation is coming, so it takes its allocation lock in exclusive mode.

So read vs write faults won't be able to race because the allocation lock
will prevent it.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
