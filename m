Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q58Jc7h2249917 for <xfs@oss.sgi.com>; Fri, 8 Jun 2012 14:38:08 -0500
Date: Fri, 8 Jun 2012 14:44:50 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH] xfs: use INIT_WORK_ONSTACK in xfs_alloc_vextent()
Message-ID: <20120608194450.GP4721@sgi.com>
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

Looks pretty good.  ;)
Reviewed-by: Ben Myers <bpm@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
