Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id D2B487CA0
	for <xfs@oss.sgi.com>; Wed, 20 Jul 2016 17:22:19 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 8B5CA8F8039
	for <xfs@oss.sgi.com>; Wed, 20 Jul 2016 15:22:19 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	QldUIRLOvw7hIMv6 for <xfs@oss.sgi.com>;
	Wed, 20 Jul 2016 15:22:13 -0700 (PDT)
Date: Thu, 21 Jul 2016 08:22:11 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: skip dirty pages in ->releasepage()
Message-ID: <20160720222211.GL16044@dastard>
References: <1469031290-18087-1-git-send-email-bfoster@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1469031290-18087-1-git-send-email-bfoster@redhat.com>
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
Cc: xfs@oss.sgi.com

On Wed, Jul 20, 2016 at 12:14:50PM -0400, Brian Foster wrote:
> XFS has had scattered reports of delalloc blocks present at
> ->releasepage() time. This results in a warning with a stack trace
> similar to the following:
> 
>  ...
>  Call Trace:
>   [<ffffffffa23c5b8f>] dump_stack+0x63/0x84
>   [<ffffffffa20837a7>] warn_slowpath_common+0x97/0xe0
>   [<ffffffffa208380a>] warn_slowpath_null+0x1a/0x20
>   [<ffffffffa2326caf>] xfs_vm_releasepage+0x10f/0x140
>   [<ffffffffa218c680>] ? page_mkclean_one+0xd0/0xd0
>   [<ffffffffa218d3a0>] ? anon_vma_prepare+0x150/0x150
>   [<ffffffffa21521c2>] try_to_release_page+0x32/0x50
>   [<ffffffffa2166b2e>] shrink_active_list+0x3ce/0x3e0
>   [<ffffffffa21671c7>] shrink_lruvec+0x687/0x7d0
>   [<ffffffffa21673ec>] shrink_zone+0xdc/0x2c0
>   [<ffffffffa2168539>] kswapd+0x4f9/0x970
>   [<ffffffffa2168040>] ? mem_cgroup_shrink_node_zone+0x1a0/0x1a0
>   [<ffffffffa20a0d99>] kthread+0xc9/0xe0
>   [<ffffffffa20a0cd0>] ? kthread_stop+0x100/0x100
>   [<ffffffffa26b404f>] ret_from_fork+0x3f/0x70
>   [<ffffffffa20a0cd0>] ? kthread_stop+0x100/0x100
> 
> This occurs because it is possible for shrink_active_list() to send
> pages marked dirty to ->releasepage() when certain buffer_head threshold
> conditions are met. shrink_active_list() doesn't check the page dirty
> state apparently to handle an old ext3 corner case where in some cases
> clean pages would not have the dirty bit cleared, thus it is up to the
> filesystem to determine how to handle the page.
> 
> XFS currently handles the delalloc case properly, but this behavior
> makes the warning spurious. Update the XFS ->releasepage() handler to
> explicitly skip dirty pages. Retain the existing delalloc/unwritten
> checks so we continue to warn if such buffers exist on clean pages when
> they shouldn't.
> 
> Diagnosed-by: Dave Chinner <david@fromorbit.com>
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> ---
> 
> This is in response to the discussion here[1] that seemingly resulted in
> no resolution in the mm. As a result, it's left to the fs to deal with
> this particular situation.
> 
> After discussing this with Dave on IRC, the initial plan was to include
> a WARN_ON_ONCE(PageDirty()) check. I've dropped the warning because as
> it turns out, block_invalidatepage() sends invalidated-but-dirty pages
> through ->releasepage(). In other words,  a simple 'xfs_io -fc "pwrite 0
> 4k" $file; unlink $file' invokes the warning. In fact, it turned into a
> consistent boot time warning on both systems I ran it against so far.
> 
> So this patch changes behavior in that particular case where a page is
> dirty but invalidated. If we want to try and preserve existing behavior,
> I do have another (so far untested) variant that does something like
> this:
> 
> 	if (PageDirty(page) && (delalloc || unwritten))
> 		return 0;
> 	else if (WARN_ON_ONCE(delalloc))
> 		return 0;
> 	else if (WARN_ON_ONCE(unwritten))
> 		return 0;
> 	...
> 
> ... to avoid the spurious warnings yet continue to try to free buffers
> on dirty pages. I lean more towards this patch as it is less logic and
> more consistent with other filesystems. Thoughts?

I think the simpler code in the patch you posted makes more sense.
There's no need to be fancy if the simple code does the job. I'll
queue it up for testing.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
