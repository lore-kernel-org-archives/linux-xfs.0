Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 1AD357F37
	for <xfs@oss.sgi.com>; Wed, 13 Jan 2016 12:25:34 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 9E8CBAC00E
	for <xfs@oss.sgi.com>; Wed, 13 Jan 2016 10:25:33 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id GVPDArU5tWHP27oj for <xfs@oss.sgi.com>;
	Wed, 13 Jan 2016 10:25:27 -0800 (PST)
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.4])
	(using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id 7A9E563737DF
	for <xfs@oss.sgi.com>; Wed, 13 Jan 2016 12:25:27 -0600 (CST)
Subject: Re: [PATCH] xfs: check sizes of XFS on-disk structures at compile time
References: <20160111232657.GA7831@birch.djwong.org>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <56969696.2040206@sandeen.net>
Date: Wed, 13 Jan 2016 12:25:26 -0600
MIME-Version: 1.0
In-Reply-To: <20160111232657.GA7831@birch.djwong.org>
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
To: xfs@oss.sgi.com

On 1/11/16 5:26 PM, Darrick J. Wong wrote:

> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index 36bd882..31b69d1 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -1812,11 +1812,56 @@ xfs_destroy_workqueues(void)
>  	destroy_workqueue(xfs_alloc_wq);
>  }
>  
> +static void __init
> +xfs_check_ondisk_structs(void)
> +{
> +	/* on-disk structures */
> +	XFS_CHECK_STRUCT_SIZE(struct xfs_dsb,			264);
> +	XFS_CHECK_STRUCT_SIZE(struct xfs_agf,			224);
> +	XFS_CHECK_STRUCT_SIZE(struct xfs_agi,			336);
> +	XFS_CHECK_STRUCT_SIZE(struct xfs_agfl,			36);
> +	XFS_CHECK_STRUCT_SIZE(struct xfs_timestamp,		8);
> +	XFS_CHECK_STRUCT_SIZE(struct xfs_dinode,		176);

I'm not sure why, but all this hard-coded stuff in the codebase bugs me.

What if we did it as part of the build, but outside the code, something
like (pardon my bad Make-fu):

diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index f646391..da9ec6d 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -122,3 +122,8 @@ xfs-$(CONFIG_XFS_POSIX_ACL) += xfs_acl.o
 xfs-$(CONFIG_SYSCTL)           += xfs_sysctl.o
 xfs-$(CONFIG_COMPAT)           += xfs_ioctl32.o
 xfs-$(CONFIG_NFSD_PNFS)                += xfs_pnfs.o
+
+check_structures: $(obj)/xfs.o
+       $(src)/scripts/check_structures.sh $(obj)/xfs.o
+
+$(obj)/built-in.o: check_structures

where the script executes pahole or whatever we want, to check the
structure sizes and possibly even alignment explicitly?  Presumably
we could make running the check a Kconfig option as well...

similar tricks could surely be done for userspace as well.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
