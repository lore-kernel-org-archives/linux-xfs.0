Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6TG4H0p053668 for <xfs@oss.sgi.com>; Fri, 29 Jul 2011 11:04:17 -0500
Received: from rcsinet15.oracle.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 18E0811F7FBA
	for <xfs@oss.sgi.com>; Fri, 29 Jul 2011 09:04:38 -0700 (PDT)
Received: from rcsinet15.oracle.com (rcsinet15.oracle.com [148.87.113.117]) by
	cuda.sgi.com with ESMTP id jcYO0QY2DDLbYmbg for
	<xfs@oss.sgi.com>; Fri, 29 Jul 2011 09:04:38 -0700 (PDT)
Message-ID: <4E32D9EB.9020406@oracle.com>
Date: Fri, 29 Jul 2011 11:03:55 -0500
From: Dave Kleikamp <dave.kleikamp@oracle.com>
MIME-Version: 1.0
Subject: Re: [Jfs-discussion] [PATCH, RFC] jfs support for xfstests
References: <20110729155039.GA28306@infradead.org>
In-Reply-To: <20110729155039.GA28306@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: jfs-discussion@lists.sourceforge.net, xfs@oss.sgi.com

On 07/29/2011 10:50 AM, Christoph Hellwig wrote:
> The patch below adds basic jfs support to xfstests.  Unfortunately it
> doesn't get very far, as test 001 already blows up with a kernel crash,
> as do 011 and 013 as other random picks.

Great :-)

Seems to be a good idea to support jfs. I'll carve out some time to
reproduce and debug the crashes.

Thanks,
Shaggy

> 
> 
> Index: xfstests-dev/common.rc
> ===================================================================
> --- xfstests-dev.orig/common.rc	2011-07-29 15:36:52.000000000 +0000
> +++ xfstests-dev/common.rc	2011-07-29 15:39:41.000000000 +0000
> @@ -102,6 +102,9 @@ _mkfs_opts()
>      gfs2)
>  	export MKFS_OPTIONS="$GFS2_MKFS_OPTIONS -O -p lock_nolock"
>  	;;
> +    jfs)
> +	export MKFS_OPTIONS="$JFS_MKFS_OPTIONS -q"
> +	;;
>      *)
>  	;;
>      esac
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
