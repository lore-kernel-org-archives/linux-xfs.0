Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 157FA7CA1
	for <xfs@oss.sgi.com>; Wed, 20 Jul 2016 11:14:54 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id CEB8E304048
	for <xfs@oss.sgi.com>; Wed, 20 Jul 2016 09:14:53 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id BgtRLO109vmWHLGn (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 20 Jul 2016 09:14:52 -0700 (PDT)
Received: from int-mx09.intmail.prod.int.phx2.redhat.com
	(int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mx1.redhat.com (Postfix) with ESMTPS id B3B5DC05AA43
	for <xfs@oss.sgi.com>; Wed, 20 Jul 2016 16:14:51 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-104.bos.redhat.com [10.18.41.104])
	by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id u6KGEpZS020191
	for <xfs@oss.sgi.com>; Wed, 20 Jul 2016 12:14:51 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH] xfs: skip dirty pages in ->releasepage()
Date: Wed, 20 Jul 2016 12:14:50 -0400
Message-Id: <1469031290-18087-1-git-send-email-bfoster@redhat.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

XFS has had scattered reports of delalloc blocks present at
->releasepage() time. This results in a warning with a stack trace
similar to the following:

 ...
 Call Trace:
  [<ffffffffa23c5b8f>] dump_stack+0x63/0x84
  [<ffffffffa20837a7>] warn_slowpath_common+0x97/0xe0
  [<ffffffffa208380a>] warn_slowpath_null+0x1a/0x20
  [<ffffffffa2326caf>] xfs_vm_releasepage+0x10f/0x140
  [<ffffffffa218c680>] ? page_mkclean_one+0xd0/0xd0
  [<ffffffffa218d3a0>] ? anon_vma_prepare+0x150/0x150
  [<ffffffffa21521c2>] try_to_release_page+0x32/0x50
  [<ffffffffa2166b2e>] shrink_active_list+0x3ce/0x3e0
  [<ffffffffa21671c7>] shrink_lruvec+0x687/0x7d0
  [<ffffffffa21673ec>] shrink_zone+0xdc/0x2c0
  [<ffffffffa2168539>] kswapd+0x4f9/0x970
  [<ffffffffa2168040>] ? mem_cgroup_shrink_node_zone+0x1a0/0x1a0
  [<ffffffffa20a0d99>] kthread+0xc9/0xe0
  [<ffffffffa20a0cd0>] ? kthread_stop+0x100/0x100
  [<ffffffffa26b404f>] ret_from_fork+0x3f/0x70
  [<ffffffffa20a0cd0>] ? kthread_stop+0x100/0x100

This occurs because it is possible for shrink_active_list() to send
pages marked dirty to ->releasepage() when certain buffer_head threshold
conditions are met. shrink_active_list() doesn't check the page dirty
state apparently to handle an old ext3 corner case where in some cases
clean pages would not have the dirty bit cleared, thus it is up to the
filesystem to determine how to handle the page.

XFS currently handles the delalloc case properly, but this behavior
makes the warning spurious. Update the XFS ->releasepage() handler to
explicitly skip dirty pages. Retain the existing delalloc/unwritten
checks so we continue to warn if such buffers exist on clean pages when
they shouldn't.

Diagnosed-by: Dave Chinner <david@fromorbit.com>
Signed-off-by: Brian Foster <bfoster@redhat.com>
---

This is in response to the discussion here[1] that seemingly resulted in
no resolution in the mm. As a result, it's left to the fs to deal with
this particular situation.

After discussing this with Dave on IRC, the initial plan was to include
a WARN_ON_ONCE(PageDirty()) check. I've dropped the warning because as
it turns out, block_invalidatepage() sends invalidated-but-dirty pages
through ->releasepage(). In other words,  a simple 'xfs_io -fc "pwrite 0
4k" $file; unlink $file' invokes the warning. In fact, it turned into a
consistent boot time warning on both systems I ran it against so far.

So this patch changes behavior in that particular case where a page is
dirty but invalidated. If we want to try and preserve existing behavior,
I do have another (so far untested) variant that does something like
this:

	if (PageDirty(page) && (delalloc || unwritten))
		return 0;
	else if (WARN_ON_ONCE(delalloc))
		return 0;
	else if (WARN_ON_ONCE(unwritten))
		return 0;
	...

... to avoid the spurious warnings yet continue to try to free buffers
on dirty pages. I lean more towards this patch as it is less logic and
more consistent with other filesystems. Thoughts?

Brian

[1] http://oss.sgi.com/pipermail/xfs/2016-May/049136.html

 fs/xfs/xfs_aops.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index b368277..332b672 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -1040,6 +1040,20 @@ xfs_vm_releasepage(
 
 	trace_xfs_releasepage(page->mapping->host, page, 0, 0);
 
+	/*
+	 * mm accommodates an old ext3 case where clean pages might not have had
+	 * the dirty bit cleared. Thus, it can send actual dirty pages to
+	 * ->releasepage() via shrink_active_list(). Conversely,
+	 * block_invalidatepage() can send pages that are still marked dirty
+	 * but otherwise have invalidated buffers.
+	 *
+	 * We've historically freed buffers on the latter. Instead, quietly
+	 * filter out all dirty pages to avoid spurious buffer state warnings.
+	 * This can likely be removed once shrink_active_list() is fixed.
+	 */
+	if (PageDirty(page))
+		return 0;
+
 	xfs_count_page_state(page, &delalloc, &unwritten);
 
 	if (WARN_ON_ONCE(delalloc))
-- 
2.5.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
