Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q58NCUmp014457 for <xfs@oss.sgi.com>; Fri, 8 Jun 2012 18:12:30 -0500
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	GPhACo2sTuMwNjqp for <xfs@oss.sgi.com>;
	Fri, 08 Jun 2012 16:12:29 -0700 (PDT)
Date: Sat, 9 Jun 2012 09:12:27 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: use INIT_WORK_ONSTACK in xfs_alloc_vextent()
Message-ID: <20120608231227.GY22848@dastard>
References: <4FD2535A.3050302@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4FD2535A.3050302@redhat.com>
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
To: Eric Sandeen <sandeen@redhat.com>
Cc: xfs-oss <xfs@oss.sgi.com>

On Fri, Jun 08, 2012 at 02:32:42PM -0500, Eric Sandeen wrote:
> w/o this change I was getting:
> 
> [  742.376495] ODEBUG: object is on stack, but not annotated
> [  742.377007] ------------[ cut here ]------------
> [  742.377007] WARNING: at lib/debugobjects.c:302 __debug_object_init+0x1c0/0x3d0()
> ...
> [  742.377007] Call Trace:
> [  742.377007]  [<ffffffff81060dbf>] warn_slowpath_common+0x7f/0xc0
> [  742.377007]  [<ffffffff81060e1a>] warn_slowpath_null+0x1a/0x20
> [  742.377007]  [<ffffffff81336640>] __debug_object_init+0x1c0/0x3d0
> [  742.377007]  [<ffffffff8133689f>] debug_object_init+0x1f/0x30
> [  742.377007]  [<ffffffff81081cd9>] __init_work+0x19/0x30
> [  742.377007]  [<ffffffffa0299f81>] xfs_alloc_vextent+0x101/0x190 [xfs]
> 
> on a debug 3.4 kernel.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Already posted by Jeff twice - I picked this up and started testing
it a couple of days ago:

http://marc.info/?l=linux-fsdevel&m=133877118608852&w=2
http://oss.sgi.com/archives/xfs/2012-06/msg00081.html

Sorry to burst you bubble, Eric, but I think Jeff gets this one. ;)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
