Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 1AD6F7F37
	for <xfs@oss.sgi.com>; Tue, 16 Apr 2013 12:21:17 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 08A92304039
	for <xfs@oss.sgi.com>; Tue, 16 Apr 2013 10:21:13 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id TjaAvDmiVjKkjSo8 for
	<xfs@oss.sgi.com>; Tue, 16 Apr 2013 10:21:13 -0700 (PDT)
Message-ID: <516D87E3.2010605@redhat.com>
Date: Tue, 16 Apr 2013 13:18:27 -0400
From: Brian Foster <bfoster@redhat.com>
MIME-Version: 1.0
Subject: Re: xfs_iunlink_remove: xfs_inotobp() returned error 22 -- debugging
References: <516C89DF.4070904@redhat.com> <20130416162417.GC13938@destitution>
In-Reply-To: <20130416162417.GC13938@destitution>
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
To: Dave Chinner <david@fromorbit.com>
Cc: sandeen@sandeen.net, yongtaofu@gmail.com, xfs@oss.sgi.com

On 04/16/2013 12:24 PM, Dave Chinner wrote:
> On Mon, Apr 15, 2013 at 07:14:39PM -0400, Brian Foster wrote:
>> Hi,
>>
>> Thanks for the data in the previous thread:
>>
>> http://oss.sgi.com/archives/xfs/2013-04/msg00327.html
>>
...
>>
>> 	echo 1 > /sys/kernel/debug/tracing/events/xfs/xfs_iunlink/enable
>> 	echo 1 > /sys/kernel/debug/tracing/events/xfs/xfs_iunlink_remove/enable
>> 	... reproduce ...
>> 	cat /sys/kernel/debug/tracing/trace > trace.output
> 
> It's better to use trace-cmd for this. it will result in less
> dropped events. i.e.:
> 
> 	$ trace-cmd record -e xfs_iunlink\*
> 	... reproduce ...
> 	^C
> 	$ trace-cmd report > trace.output
> 
>> --- a/fs/xfs/linux-2.6/xfs_trace.h
>> +++ b/fs/xfs/linux-2.6/xfs_trace.h
>> @@ -581,6 +581,8 @@ DEFINE_INODE_EVENT(xfs_file_fsync);
...
> 
> I would suggest that the the tracing shoul dbe at entry of the
> function, otherwise we won't get a tracepoint for the operation that
> triggers the shutdown. (That's the reason most tracepoints in XFS
> are at function entry...)
> 

Good points, thanks Dave. A v2 that pulls up the tracepoints towards
function entry is appended.

Brian

>From 280943e78ebe0b97a774cba51e7815c42f044b55 Mon Sep 17 00:00:00 2001
From: Brian Foster <bfoster@redhat.com>
Date: Mon, 15 Apr 2013 18:16:24 -0400
Subject: [PATCH v2] xfs: add tracepoints for xfs_iunlink and
xfs_iunlink_remove

---
 fs/xfs/linux-2.6/xfs_trace.h |    2 ++
 fs/xfs/xfs_inode.c           |    4 ++++
 2 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_trace.h b/fs/xfs/linux-2.6/xfs_trace.h
index adc6ec4..338a0f9 100644
--- a/fs/xfs/linux-2.6/xfs_trace.h
+++ b/fs/xfs/linux-2.6/xfs_trace.h
@@ -583,6 +583,8 @@ DEFINE_INODE_EVENT(xfs_file_fsync);
 DEFINE_INODE_EVENT(xfs_destroy_inode);
 DEFINE_INODE_EVENT(xfs_dirty_inode);
 DEFINE_INODE_EVENT(xfs_clear_inode);
+DEFINE_INODE_EVENT(xfs_iunlink);
+DEFINE_INODE_EVENT(xfs_iunlink_remove);

 DEFINE_INODE_EVENT(xfs_dquot_dqalloc);
 DEFINE_INODE_EVENT(xfs_dquot_dqdetach);
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 19900f0..d705c77 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1615,6 +1615,8 @@ xfs_iunlink(

 	mp = tp->t_mountp;

+	trace_xfs_iunlink(ip);
+
 	/*
 	 * Get the agi buffer first.  It ensures lock ordering
 	 * on the list.
@@ -1694,6 +1696,8 @@ xfs_iunlink_remove(
 	mp = tp->t_mountp;
 	agno = XFS_INO_TO_AGNO(mp, ip->i_ino);

+	trace_xfs_iunlink_remove(ip);
+
 	/*
 	 * Get the agi buffer first.  It ensures lock ordering
 	 * on the list.
-- 
1.7.7.6

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
