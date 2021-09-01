Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE131C432BE
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Sep 2021 06:29:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 974D860FE6
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Sep 2021 06:29:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242088AbhIAGan (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 1 Sep 2021 02:30:43 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:33758 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229910AbhIAGam (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 1 Sep 2021 02:30:42 -0400
Received: from dread.disaster.area (pa49-195-182-146.pa.nsw.optusnet.com.au [49.195.182.146])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 36765104E52D;
        Wed,  1 Sep 2021 16:29:44 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1mLJkl-007MKz-5Y; Wed, 01 Sep 2021 16:29:43 +1000
Date:   Wed, 1 Sep 2021 16:29:43 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Allison Henderson <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v24 00/11] Log Attribute Replay
Message-ID: <20210901062943.GX3657114@dread.disaster.area>
References: <20210824224434.968720-1-allison.henderson@oracle.com>
 <20210831002010.GS3657114@dread.disaster.area>
 <2b6b0478-b0df-7e35-b0ac-f02298ccf727@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2b6b0478-b0df-7e35-b0ac-f02298ccf727@oracle.com>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=Tu+Yewfh c=1 sm=1 tr=0
        a=QpfB3wCSrn/dqEBSktpwZQ==:117 a=QpfB3wCSrn/dqEBSktpwZQ==:17
        a=kj9zAlcOel0A:10 a=7QKq2e-ADPsA:10 a=7-415B0cAAAA:8
        a=oblMXyimVlj30a4j4JUA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Aug 31, 2021 at 11:27:48AM -0700, Allison Henderson wrote:
> 
> 
> On 8/30/21 5:20 PM, Dave Chinner wrote:
> > On Tue, Aug 24, 2021 at 03:44:23PM -0700, Allison Henderson wrote:
> > > Hi all,
> > > 
> > > This set is a subset of a larger series parent pointers. Delayed attributes allow
> > > attribute operations (set and remove) to be logged and committed in the same
> > > way that other delayed operations do. This allows more complex operations (like
> > > parent pointers) to be broken up into multiple smaller transactions. To do
> > > this, the existing attr operations must be modified to operate as a delayed
> > > operation.  This means that they cannot roll, commit, or finish transactions.
> > > Instead, they return -EAGAIN to allow the calling function to handle the
> > > transaction.  In this series, we focus on only the delayed attribute portion.
> > > We will introduce parent pointers in a later set.
> > > 
> > > The set as a whole is a bit much to digest at once, so I usually send out the
> > > smaller sub series to reduce reviewer burn out.  But the entire extended series
> > > is visible through the included github links.
> 
> Some of this we worked out in the chat last night, but I will echo it here
> for the archives
> 
> > 
> > Ok, so like I did with Darrick's deferred inactivation series, the
> > first thing I'm doing here is throwing this patchset at
> > scalability/performance worklaods and finding out what is different.
> > 
> > I've merged this series with 5.14 + xfs/for-next + xfs-cil-scale and
> > then run some tests on it. First up is fsmark creating zero length
> > files w/ 64 byte xattrs. This should stress only shortform attribute
> > manipulations.
> > 
> > I have not enabled delayed attributes yet (i.e.
> > /sys/fs/xfs/debug/larp = 0)
> > 
> > First thing I notice is the transaction commit rate during create is
> > up around 900k/s, so we are doing 3 transactions per inode - 1 for
> > create, 2 for attributes. That looks like a regression - existing
> > shortform attribute creation only takes a single transaction commit,
> > so this workload prior to this patchset only ran at 600k commits/s.
> > 
> > Note that hte only reason I'm getting 900k transactions/s is the
> > CIL scalability patchset - without that the system tops out at ~800k
> > transactions/s and so this would be a significant performance
> > regression (20%) vs the current xfs/for-next code.
> > 
> > Essentially, this looks like we are doing an extra transaction
> > commit to defer the creation of the attribute, then doing another
> > transaction to actually modify the attribute. i.e.:
> > 
> >   - 11.04% xfs_attr_set
> >      - 8.70% xfs_trans_commit
> >         - 8.69% __xfs_trans_commit
> > 	  - 5.10% xfs_defer_finish_noroll
> > 	     - 3.74% xfs_defer_trans_roll
> > 		- 3.57% xfs_trans_roll
> > 		   - 3.13% __xfs_trans_commit
> > 		      - 3.01% xlog_cil_commit
> > 			   0.66% down_read
> > 			   0.63% xfs_log_ticket_regrant
> > 	     - 1.16% xfs_attr_finish_item
> > 		- 1.06% xfs_trans_attr_finish_update
> > 		   - 1.03% xfs_attr_set_iter
> > 		      - 1.01% xfs_attr_sf_addname
> > 			 - 0.99% xfs_attr_try_sf_addname
> > 			    - 0.61% xfs_attr_shortform_addname
> > 				 0.55% xfs_attr_shortform_add
> > 
> > 
> > AFAICT, for non-delayed attributes, this first transaction commit
> > logs the inode but does not create intent or intent done items
> > (returns NULL for both operations), so just rolls and runs the
> > ->finish_item. So it would seem that the first transaction just
> > changes the inode timestamps and does nothing else.
> > 
> > Firstly, this means the inode timestamp change is not atomic w.r.t.
> > the attribute change the timestamp change relates to and it's
> > essentially new overhead for the non-delayed path.
> > 
> > Looking at the unlink path, I see the same thing - there's an extra
> > transaction for the attr remove path, the same as the attr set path.
> > This drives the unlink path to 1.1 million transaction commits/sec
> > instead of 800k/s, so it's likely that there's a substantial
> > performance regression here on a kernel without the CIL scalability
> > patchset.
> > 
> > IOWs, there's significant behavioural changes with the non-delayed
> > logging version of this patchset, both in terms of performance and
> > the atomicity of changes that appear in the journal and hence
> > recovery behaviour.
> > 
> > At this point I have to ask: why are we trying to retain the "old"
> > way of doing things (even for testing) if it is substantially
> > changing behaviour and on-disk journal contents for attribute
> > modifications?
> Per the chat discussion, we have to keep both methods since sb v4 would not
> use the new log entries.

Yup, but we likely have better reasons than this. Tests I've run
today have indicated that as the xattr size goes up, the performance
regression of the delayed attrs gets worse. At max sized xattrs,
performance is only ~25% of the existing attr implementation.

Largely the problem is the number of copies of the xattr value we
end up in memory when we are using delalyed attrs. In the current
case, we have this all in a single syscall context:

	- xattr value allocated by VFS
	- attached to xfs_da_args
	- xfs_da_args passed to xfs_attr_rmtval_set_value() where we
	  allocate buffer(s) to hold the encoded name.
	- buffer is written to disk.
	- xattr VFS value freed.

And the xfs_buf is freed when memory pressure occurs.

So, essentially we have two copies of the xattr value and two
memcpy()s of it to get it to disk.

Now, with delayed attrs we have this in the syscall context:

	- xattr value allocated by VFS
	- attached to xfs_da_args
	- attached to xfs_attri_item
	- attri item intent gets created, allocates a 64k+ shadow
	  buffer and memcpy()s the value into it.
	- intent gets committed and attached to the CIL
	- xfs_da_args passed to xfs_attr_rmtval_set_value() where we
	  allocate buffer(s) to hold the encoded name.
	- buffer is written to disk.
	- xattr VFS value freed.

Now userspace runs more xattr creation syscalls, all queuing up
shadow buffers on the CIL. memory footprint goes up massively.

Some time later, the CIL commits and we:
	- shadow buffer attached to CIL commit
	- memcpy() the value from the shadow buffer to the iclog
	- commit the CIL checkpoint
	- on CIL checkpoint completion, shadow buffer is freed.

And the xfs_bufs is freed when memory pressure occurs.

The result is that with delayed attrs, large attr creation hammers
the page allocator really badly - more than 50% of the CPU time is
spent trying to allocate pages and compact memory into contiguous
regions and so performance goes way down. e.g.

- 51.90% xlog_cil_commit
 - 36.96% kvmalloc_node
    - 36.51% __kmalloc_node
       - 36.32% kmalloc_large_node
	  - 36.24% __alloc_pages
	     - 34.53% __alloc_pages_slowpath.constprop.0
		- 33.80% __alloc_pages_direct_compact
		   - 33.62% try_to_compact_pages
		      - compact_zone_order
			 - 30.58% compact_zone
			      14.72% PageHuge

I suspect we need to look at our use of kvmalloc() and the flags we
pass it because I think if we can't get contiguous ranges
immediately, we should go straight to vmalloc rather than burn a
dozen CPUs trying to compact memory...

The amount we log also goes way up.  At 16 threads and 4kB xattrs,
the log alone is sustaining more than 1GB/s throughput at 50k xattrs
creates/s.  There is over 2GB/s going to disk.

With 64k xattrs, there is over 2.5GB/s being written to the log and
just over 3GB/s being written to disk. Performance is about 9000
xattr creates/s.

In comparison, with delayed attrs turned off for 64k xattrs, log
throughput is roughly 500MB/s, disk throughput is between 3.5-4GB/s
and the create rate is around 45,000 xattrs/s. So you can see that
logging large xattrs really hurts performance.

We want delayed attrs for modifying attributes atomically
with other inode modifications (i.e. parent pointers, security
labels, ACLs, etc) and none of these use cases use large xattrs -
they are all relatively small and so the logging and memory overhead
of delayed attrs isn't a huge deal for them. For anything else,
small or large, a 10-15% regression is a deal breaker (think ceph,
samba, etc).

So I think we're going to need to select attribute modification
behaviour at the call site. e.g. from xattr syscalls we don't get
any real integrity benefit from logging xattrs, so maybe this path
always uses the unlogged path. The we can change the internal create
path to use delayed attrs for parent pointers and security attrs.
As Darrick said, this is likely what the current larp debug knob
should turn into - caller selected behaviour.

> > Ok, there's the first failure.
> > 
> > This looks like it's a problem with xfs_attri_item_{size,format} in
> > calculating the number of bytes to log. They use ATTR_NVEC_SIZE() to
> > calculate the number of bytes of copy from the attribute item which
> > rounds up the length to copy to 4 byte aligned values. I'm not sure
> > what this function is calculating:
> > 
> > /* iovec length must be 32-bit aligned */
> > static inline size_t ATTR_NVEC_SIZE(size_t size)
> > {
> >          return size == sizeof(int32_t) ? size :
> > 	               sizeof(int32_t) + round_up(size, sizeof(int32_t));
> > }
> > 
> > It appears to be saying if the size == 4, then return 4, otherwise
> > return 4 + roundup(size)... which leads me to struct
> > xfs_attri_log_format:
> > 
> > struct xfs_attri_log_format {
> >          uint16_t        alfi_type;      /* attri log item type */
> >          uint16_t        alfi_size;      /* size of this item */
> >          uint32_t        __pad;          /* pad to 64 bit aligned */
> >          uint64_t        alfi_id;        /* attri identifier */
> >          uint64_t        alfi_ino;       /* the inode for this attr operation */
> >          uint32_t        alfi_op_flags;  /* marks the op as a set or remove */
> >          uint32_t        alfi_name_len;  /* attr name length */
> >          uint32_t        alfi_value_len; /* attr value length */
> >          uint32_t        alfi_attr_flags;/* attr flags */
> > };
> > 
> > I don't see where the extra 4 bytes for the attribute vector size
> > comes from. It's not needed to store the length, so this could
> > oversize the amount of data to be copied from the source
> > buffer by up to 7 bytes?
> > 
> > I can see that it might need rounding with the existing
> > log code (because the formatter is responsible for 32 bit alignment
> > of log vectors), but that goes away with the CIL scalability
> > patchset that always aligns iovecs to 4 byte alignment so the
> > formatters do not need to do that.
> 
> I think we figured this out last night, initially this was here for an
> assertion check in the log code, but I think just the round up will suffice
> for the check.

I've got a cleaner solution in the works - we should be hiding the
alignment behind the log iovec API, not force callers to know about
it and always get it right.

> > Hiding it in a "macro" is not necessary, either - look at how
> > xfs_inode_item_{data,attr}_fork_size handle the rounding up of the
> > local format fork size. They round up the fork byte count to 4
> > directly, and the format code copies those bytes because
> > xfs_idata_realloc() allocates those bytes.
> > 
> > However, for the attribute buffers, this isn't guaranteed. Look at
> > xfs_xattr_set():
> > 
> >          struct xfs_da_args      args = {
> >                  .dp             = XFS_I(inode),
> >                  .attr_filter    = handler->flags,
> >                  .attr_flags     = flags,
> >                  .name           = name,
> >                  .namelen        = strlen(name),
> >                  .value          = (void *)value,
> >                  .valuelen       = size,
> >          };
> > 
> > There is no rounding up of the name or value lengths, and these end
> > up directly referenced by the deferred logging via xfs_attr_log_item()
> > and attrip->da_args->...
> > 
> >          attrip->attri_name = (void *)attr->xattri_da_args->name;
> >          attrip->attri_value = attr->xattri_da_args->value;
> >          attrip->attri_name_len = attr->xattri_da_args->namelen;
> >          attrip->attri_value_len = attr->xattri_da_args->valuelen;
> > 
> > We then pass those pointers directly to xlog_iovec_copy() but with a
> > rounded up length that is longer than the source buffer:
> > 
> >          xlog_copy_iovec(lv, &vecp, XLOG_REG_TYPE_ATTR_NAME,
> >                          attrip->attri_name,
> >                          ATTR_NVEC_SIZE(attrip->attri_name_len));
> >          if (attrip->attri_value_len > 0)
> >                  xlog_copy_iovec(lv, &vecp, XLOG_REG_TYPE_ATTR_VALUE,
> >                                  attrip->attri_value,
> >                                  ATTR_NVEC_SIZE(attrip->attri_value_len));
> > 
> > So while this might not be the source of the above crash, it's
> > certainly a bug that needs fixing.
> > 
> > At this point, I'm just going to hack on the code to make it work,
> > and we can go from there...
> 
> I think when we left off last night, we are more concerned with the extra
> transaction overhead in the perf captures.  I will see if I can replicate
> what you are seeing with perf and maybe we can work out some short cuts.
> Thank for your help here!

Yup, there's a few issues. I've hacked out the initial transaction
for non-delayed attrs and that brings the commit count down as
expected. it might be acceptible, but we'll see.

I've also added intent whiteouts to try to avoid having to log
intents that are completed before the intent has been written to the
log. With that in place, the above large xattr creation workloads
have relatively consistent log throughput of around 600-700MB/s, and
performance for 4k and 64kB xattrs roughly doubles. It's still way
behind the current implementation, though, because it hammers the
page allocator even harder now. However, intent whiteouts are
generic, so I'll write this up into a separate patchset that
addresses all the other types of intents we have as well.

There's some other things we can potentially do to minimise the
memory footprint and the number of memcpy()s of the logged values,
so I'll look into these tomorrow.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
