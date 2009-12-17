Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nBH0KHbX104208 for <xfs@oss.sgi.com>; Wed, 16 Dec 2009 18:20:17 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8FDEBE466BF
	for <xfs@oss.sgi.com>; Wed, 16 Dec 2009 16:20:52 -0800 (PST)
Received: from mail.internode.on.net (bld-mail18.adl2.internode.on.net
	[150.101.137.103]) by cuda.sgi.com with ESMTP id
	4eBVtGg4slse5Qd5 for <xfs@oss.sgi.com>;
	Wed, 16 Dec 2009 16:20:52 -0800 (PST)
Date: Thu, 17 Dec 2009 11:20:07 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [GIT PULL] XFS update for 2.6.33-rc1
Message-ID: <20091217002007.GF4850@discord.disaster>
References: <200912162126.nBGLQAbZ012632@stout.americas.sgi.com>
	<20091216135512.2675a0e3.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20091216135512.2675a0e3.randy.dunlap@oracle.com>
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
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: akpm@linux-foundation.org, xfs@oss.sgi.com, torvalds@linux-foundation.org, linux-kernel@vger.kernel.org, Alex Elder <aelder@sgi.com>

On Wed, Dec 16, 2009 at 01:55:12PM -0800, Randy Dunlap wrote:
> On Wed, 16 Dec 2009 15:26:10 -0600 Alex Elder wrote:
> 
> > One more XFS update for -rc1, now that the new XFS tracing code has
> > been committed.
> 
> Sorry if I have missed it, but have the printk format warnings
> on i386 builds been fixed?

I don't see any here w/ gcc 4.3.4 x86-64 compiling i386 kernels....

/me hates gcc's warning inconsistencies with a passion.

> e.g.:
> 
> In file included from linux-next-20091216/include/trace/ftrace.h:398,
>                  from linux-next-20091216/include/trace/define_trace.h:69,
>                  from linux-next-20091216/fs/xfs/linux-2.6/xfs_trace.h:1369,
>                  from linux-next-20091216/fs/xfs/linux-2.6/xfs_trace.c:75:
> linux-next-20091216/fs/xfs/linux-2.6/./xfs_trace.h: In function 'ftrace_raw_output_id_xfs_iomap_enter':
> linux-next-20091216/fs/xfs/linux-2.6/./xfs_trace.h:830: warning: format '%llx' expects type 'long long unsigned int', but argument 12 has type 'xfs_fsblock_t'

Patch that should fix this below.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com


XFS: Format xfs_fsblock_t correctly in tracing code.

Fixes printk build warnings on i386.

Reported-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 fs/xfs/linux-2.6/xfs_trace.h |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_trace.h b/fs/xfs/linux-2.6/xfs_trace.h
index c40834b..d4ded59 100644
--- a/fs/xfs/linux-2.6/xfs_trace.h
+++ b/fs/xfs/linux-2.6/xfs_trace.h
@@ -815,7 +815,7 @@ TRACE_EVENT(name, \
 	), \
 	TP_printk("dev %d:%d ino 0x%llx size 0x%llx new_size 0x%llx " \
 		  "offset 0x%llx count %zd flags %s " \
-		  "startoff 0x%llx startblock 0x%llx blockcount 0x%llx", \
+		  "startoff 0x%llx startblock %s blockcount 0x%llx", \
 		  MAJOR(__entry->dev), MINOR(__entry->dev), \
 		  __entry->ino, \
 		  __entry->size, \
@@ -824,7 +824,7 @@ TRACE_EVENT(name, \
 		  __entry->count, \
 		  __print_flags(__entry->flags, "|", BMAPI_FLAGS), \
 		  __entry->startoff, \
-		  __entry->startblock, \
+		  xfs_fmtfsblock(__entry->startblock), \
 		  __entry->blockcount) \
 )
 DEFINE_IOMAP_EVENT(xfs_iomap_enter);
@@ -1201,7 +1201,7 @@ TRACE_EVENT(name, \
 	TP_printk("dev %d:%d agno %u agbno %u minlen %u maxlen %u mod %u " \
 		  "prod %u minleft %u total %u alignment %u minalignslop %u " \
 		  "len %u type %s otype %s wasdel %d wasfromfl %d isfl %d " \
-		  "userdata %d firstblock 0x%llx", \
+		  "userdata %d firstblock %s", \
 		  MAJOR(__entry->dev), MINOR(__entry->dev), \
 		  __entry->agno, \
 		  __entry->agbno, \
@@ -1220,7 +1220,7 @@ TRACE_EVENT(name, \
 		  __entry->wasfromfl, \
 		  __entry->isfl, \
 		  __entry->userdata, \
-		  __entry->firstblock) \
+		  xfs_fmtfsblock(__entry->firstblock)) \
 )
 
 DEFINE_ALLOC_EVENT(xfs_alloc_exact_done);

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
