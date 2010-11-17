Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oAH9KhFQ217317 for <xfs@oss.sgi.com>; Wed, 17 Nov 2010 03:20:43 -0600
Received: from idcmail-mo2no.shaw.ca (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E3594188DDD
	for <xfs@oss.sgi.com>; Wed, 17 Nov 2010 01:19:53 -0800 (PST)
Received: from idcmail-mo2no.shaw.ca (idcmail-mo2no.shaw.ca [64.59.134.9]) by
	cuda.sgi.com with ESMTP id AjcSaAH6p2d6GrHs for
	<xfs@oss.sgi.com>; Wed, 17 Nov 2010 01:19:53 -0800 (PST)
Subject: Re: [PATCH 1/6] fs: add hole punching to fallocate
Mime-Version: 1.0 (Apple Message framework v1081)
From: Andreas Dilger <adilger@dilger.ca>
In-Reply-To: <20101117021150.GL22876@dastard>
Date: Wed, 17 Nov 2010 03:19:49 -0600
Message-Id: <7CF30C2C-44CE-4DFC-BB8B-92A207E4052A@dilger.ca>
References: <1289840723-3056-1-git-send-email-josef@redhat.com>
	<1289840723-3056-2-git-send-email-josef@redhat.com>
	<20101116111611.GA4757@quack.suse.cz>
	<20101116114346.GB4757@quack.suse.cz>
	<20101116125249.GB31957@dhcp231-156.rdu.redhat.com>
	<20101116131451.GH4757@quack.suse.cz>
	<18ACAA85-8847-4B12-9839-F99FB6C7B3E4@dilger.ca>
	<20101117021150.GL22876@dastard>
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
Cc: Jan Kara <jack@suse.cz>, ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, cluster-devel@redhat.com, cmm@us.ibm.com, Josef Bacik <josef@redhat.com>, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org

On 2010-11-16, at 20:11, Dave Chinner wrote:
> On Tue, Nov 16, 2010 at 06:22:47PM -0600, Andreas Dilger wrote:
>> IMHO, it makes more sense for consistency and "get what users
>> expect" that these be treated as flags.  Some users will want
>> KEEP_SIZE, but in other cases it may make sense that a hole punch
>> at the end of a file should shrink the file (i.e. the opposite of
>> an append).
> 
> What's wrong with ftruncate() for this?

It makes the API usage from applications more consistent.  It would be inconvenient, for example, if applications had to use a different system call if they were writing in the middle of the file vs. at the end, wouldn't it?

Similarly, if multiple threads are appending vs. punching (let's assume non-overlapping regions, for sanity, like a producer/consumer model punching out completed records) then using ftruncate() to remove the last record and shrink the file would require locking the whole file from userspace (unlike the append, which does this in the kernel), or risk discarding unprocessed data beyond the record that was punched out.

> There's plenty of open questions about the interface if we allow
> hole punching to change the file size. e.g. where do we set the EOF
> (offset or offset+len)?

I would think it natural that the new size is the start of the region, like an "anti-write" (where write sets the size at the end of the added bytes).

>  What do we do with the rest of the blocks that are now beyond EOF?
> We weren't asked to punch them out, so do we leave them behind?

I definitely think they should be left as is.  If they were in the punched-out range, they would be deallocated, and if they are beyond EOF they will remain as they are - we didn't ask to remove them unless the punched-out range went to ~0ULL (which would make it equivalent to an ftruncate()).

> What if we are leaving written blocks beyond EOF - does any filesystem other than XFS support that (i.e. are we introducing different behaviour on different filesystems)?

I'm not sure I understand what a "written block beyond EOF" means.  How can there be data beyond EOF?  I think the KEEP_SIZE flag is only relevant if the punch is spanning EOF, like the opposite of a write that is spanning EOF.  If KEEP_SIZE is set, then it leaves the size unchanged, and if unset and punch spans EOF it reduces the file size.  If the punch is not at EOF it doesn't change the file size, just like a write that is not at EOF.

> And what happens if the offset is beyond EOF? Do we extend the file, and if so why wouldn't you just use ftruncate() instead?

Even if the effects were the same, it makes sense because applications may be using fallocate(PUNCH_HOLE) to punch out records, and having them special case the use of ftruncate() to get certain semantics at the end of the file adds needless complexity.

Cheers, Andreas





_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
