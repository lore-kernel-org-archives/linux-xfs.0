Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id E1BCD7F3F
	for <xfs@oss.sgi.com>; Mon, 30 Nov 2015 09:49:34 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id D21AE304067
	for <xfs@oss.sgi.com>; Mon, 30 Nov 2015 07:49:34 -0800 (PST)
Received: from mail-lf0-f54.google.com (mail-lf0-f54.google.com
	[209.85.215.54]) by cuda.sgi.com with ESMTP id Bm6QCkmtmBrpu7eo
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Mon, 30 Nov 2015 07:49:28 -0800 (PST)
Received: by lfdl133 with SMTP id l133so201519125lfd.2
	for <xfs@oss.sgi.com>; Mon, 30 Nov 2015 07:49:27 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20151130141000.GC24765@bfoster.bfoster>
References: <CAD-J=zZh1dtJsfrW_Gwxjg+qvkZMu7ED-QOXrMMO6B-G0HY2-A@mail.gmail.com>
	<20151130141000.GC24765@bfoster.bfoster>
Date: Mon, 30 Nov 2015 10:49:27 -0500
Message-ID: <CAD-J=zZrKbOAUzj5dJYOPkukPQV4V7YMr_c+W6_SXHNzGgOxdQ@mail.gmail.com>
Subject: Re: sleeps and waits during io_submit
From: Glauber Costa <glauber@scylladb.com>
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
To: Brian Foster <bfoster@redhat.com>
Cc: Avi Kivity <avi@scylladb.com>, xfs@oss.sgi.com

Hi Brian

>> 1) xfs_buf_lock -> xfs_log_force.
>>
>> I've started wondering what would make xfs_log_force sleep. But then I
>> have noticed that xfs_log_force will only be called when a buffer is
>> marked stale. Most of the times a buffer is marked stale seems to be
>> due to errors. Although that is not my case (more on that), it got me
>> thinking that maybe the right thing to do would be to avoid hitting
>> this case altogether?
>>
>
> I'm not following where you get the "only if marked stale" part..? It
> certainly looks like that's one potential purpose for the call, but this
> is called in a variety of other places as well. E.g., forcing the log
> via pushing on the ail when it has pinned items is another case. The ail
> push itself can originate from transaction reservation, etc., when log
> space is needed. In other words, I'm not sure this is something that's
> easily controlled from userspace, if at all. Rather, it's a significant
> part of the wider state machine the fs uses to manage logging.

I understand that in general xfs_log_force can be called from many
places. But in our traces the ones we see sleeping are coming from
xfs_buf_lock. The code for xfs_buf_lock reads:

    if (atomic_read(&bp->b_pin_count) && (bp->b_flags & XBF_STALE))
        xfs_log_force(bp->b_target->bt_mount, 0);


which if I read correctly, will be called only for stale buffers. True
thing they happen to be pinned as well, but somehow the stale part
caught my attention. It seemed to me from briefly looking that the
stale condition was a more "avoidable" one. (keep in mind I am not an
awesome XFSer, may be missing something)

>
>> The file example-stale.txt contains a backtrace of the case where we
>> are being marked as stale. It seems to be happening when we convert
>> the the inode's extents from unwritten to real. Can this case be
>> avoided? I won't pretend I know the intricacies of this, but couldn't
>> we be keeping extents from the very beginning to avoid creating stale
>> buffers?
>>
>
> This is down in xfs_fs_evict_inode()->xfs_inactive(), which is generally
> when an inode is evicted from cache. In this case, it looks like the
> inode is unlinked (permanently removed), the extents are being removed
> and a bmap btree block is being invalidated as part of that overall
> process. I don't think this has anything to do with unwritten extents.
>

Cool. If the inode is indeed unliked, could that sill be triggering
that condition in xfs_buf_lock? I am not even close to fully
understanding how XFS manages and/or recycles buffers, but it seems to
me that if an inode is going away, there isn't really any reason to
contend for its buffers.

>> 2) xfs_buf_lock -> down
>> This is one I truly don't understand. What can be causing contention
>> in this lock? We never have two different cores writing to the same
>> buffer, nor should we have the same core doingCAP_FOWNER so.
>>
>
> This is not one single lock. An XFS buffer is the data structure used to
> modify/log/read-write metadata on-disk and each buffer has its own lock
> to prevent corruption. Buffer lock contention is possible because the
> filesystem has bits of "global" metadata that has to be updated via
> buffers.

I see. Since I hate guessing, is there any way you would recommend for
us to probe the system to determine if this contention scenario is
indeed the one we are seeing?

We usually open a file, write to it from a single core only,
sequentially, direct IO only, as well behavedly as we can, with all
the effort in the world to be good kids to the extent Santa will bring
us presents without us even asking.

So we were very puzzled to see contention. Contention for global
metadata updates is the best explanation we've had so far, and would
be great if we could verify it is indeed the case.

>
> For example, usually one has multiple allocation groups to maximize
> parallelism, but we still have per-ag metadata that has to be tracked
> globally with respect to each AG (e.g., free space trees, inode
> allocation trees, etc.). Any operation that affects this metadata (e.g.,
> block/inode allocation) has to lock the agi/agf buffers along with any
> buffers associated with the modified btree leaf/node blocks, etc.
>
> One example in your attached perf traces has several threads looking to
> acquire the AGF, which is a per-AG data structure for tracking free
> space in the AG. One thread looks like the inode eviction case noted
> above (freeing blocks), another looks like a file truncate (also freeing
> blocks), and yet another is a block allocation due to a direct I/O
> write. Were any of these operations directed to an inode in a separate
> AG, they would be able to proceed in parallel (but I believe they would
> still hit the same codepaths as far as perf can tell).

This is great, great, awesome info Brian. Thanks. We are so far
allocating inodes and truncating them when we need a new one, but
maybe there is some allocation pattern that is friendlier to the AG? I
understand that with such a data structure it may very well be
impossible to get rid of all waiting, but we will certainly do all we
can to mitigate it.

>
>> 3) xfs_file_aio_write_checks -> file_update_time -> xfs_vn_update_time
>>
>> You guys seem to have an interface to avoid that, by setting the
>> FMODE_NOCMTIME flag. This is done by issuing the open by handle ioctl,
>> which will set this flag for all regular files. That's great, but that
>> ioctl required CAP_SYS_ADMIN, which is a big no for us, since we run
>> our server as an unprivileged user. I don't understand, however, why
>> such an strict check is needed. If we have full rights on the
>> filesystem, why can't we issue this operation? In my view, CAP_FOWNER
>> should already be enough.I do understand the handles have to be stable
>> and a file can have its ownership changed, in which case the previous
>> owner would keep the handle valid. Is that the reason you went with
>> the most restrictive capability ?
>
> I'm not familiar enough with the open-by-handle stuff to comment on the
> permission constraints. Perhaps Dave or others can comment further on
> this bit...
>
> Brian

Thanks again Brian. The pointer to the AG stuff was really helpful.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
