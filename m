Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 4AD6F7F56
	for <xfs@oss.sgi.com>; Thu, 14 Nov 2013 08:09:21 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 26183304064
	for <xfs@oss.sgi.com>; Thu, 14 Nov 2013 06:09:18 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.9])
	by cuda.sgi.com with ESMTP id DESpn9xYQGA9uZan (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 14 Nov 2013 06:09:16 -0800 (PST)
Date: Thu, 14 Nov 2013 06:09:16 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfsprogs/quota: fix NULL pointer dereference in report_f
Message-ID: <20131114140916.GA13501@infradead.org>
References: <52849CC5.10109@oracle.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <52849CC5.10109@oracle.com>
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
To: Jeff Liu <jeff.liu@oracle.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Thu, Nov 14, 2013 at 05:49:57PM +0800, Jeff Liu wrote:
> From: Jie Liu <jeff.liu@oracle.com>
> 
> Run xfs_quota report against an invalid XFS path without desired quota
> limitation is enabled will hit SEGSEGV as fs_path is uninitialized, e.g.
> 
> # xfs_quota -xc 'report -up' /invalid_path
> xfs_quota: cannot setup path for mount /invalid_path: No such file or directory
> Segmentation fault (core dumped)
> 
> (gdb) r -xc 'report -up' /invalid_path
> xfs_quota: cannot setup path for mount /invalid_path: No such file or directory
> 
> Program received signal SIGSEGV, Segmentation fault.
> 0x0000000000408b4d in report_f (argc=2, argv=0x105ea70) at report.c:627
> 627			else if (fs_path->fs_flags & FS_MOUNT_POINT)
> 
> This patch fix report_f() to only do report if the fs_path is initialized.

quot_f in quot.c and various functions in state.c seem to have the same
issue, and need fixing as well.

I'd love to avoid having to expose fs_path as a global and just have a
few safe accessors:

char *global_fsname(void)
{
	return fs_path ? fs_path->fs_name : NULL;
}

char *global_dir(void)
{
	return fs_path ? fs_path->fs_dir : NULL;
}

char *global_mountpoint(void)
{
	if (fs_path && (fs_path->fs_flags & FS_MOUNT_POINT))
		return fs_path->fs_dir;
	return NULL;
}

Together with moving a bit of code from quota/init.c to libxcmd/path.c
that should allow mkaing fs_path and fs_table static there.


I'd also really love to see a regression test for xfstests.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
