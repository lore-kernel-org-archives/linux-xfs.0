Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n0V0OSZQ061636 for <xfs@oss.sgi.com>; Fri, 30 Jan 2009 18:24:29 -0600
Date: Fri, 30 Jan 2009 16:22:52 -0800
From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] fs: Add new pre-allocation ioctls to vfs for
	compatibility with legacy xfs ioctls
Message-Id: <20090130162252.7bf9c1f4.akpm@linux-foundation.org>
In-Reply-To: <4980C71F.1010804@ankitjain.org>
References: <4980C71F.1010804@ankitjain.org>
Mime-Version: 1.0
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
To: Ankit Jain <me@ankitjain.org>
Cc: mfasheh@suse.com, joel.becker@oracle.com, linux-kernel@vger.kernel.org, hch@infradead.org, xfs-masters@oss.sgi.com, viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com, ocfs2-devel@oss.oracle.com

On Thu, 29 Jan 2009 02:29:11 +0530
Ankit Jain <me@ankitjain.org> wrote:

> --- xfs.orig/include/linux/falloc.h	2009-01-21 21:03:28.076324621 +0100
> +++ xfs/include/linux/falloc.h	2009-01-27 20:36:59.190423995 +0100
> @@ -3,4 +3,48 @@
>  
>  #define FALLOC_FL_KEEP_SIZE	0x01 /* default is extend size */
>  
> +#ifdef __KERNEL__
> +
> +/*
> + * Space reservation ioctls and argument structure
> + * are designed to be compatible with the legacy XFS ioctls.
> + */
> +struct space_resv {
> +	__s16		l_type;
> +	__s16		l_whence;
> +	__s64		l_start;
> +	__s64		l_len;		/* len == 0 means until end of file */
> +	__s32		l_sysid;
> +	__u32		l_pid;
> +	__s32		l_pad[4];	/* reserve area			    */
> +};
> +
> +#define F_IOC_RESVSP		_IOW('X', 40, struct space_resv)
> +#define F_IOC_RESVSP64		_IOW('X', 42, struct space_resv)

Should this stuff be inside #ifdef __KERNEL__?  It is shared with userspace.

Are we sure that the aligment of l_start will be reliably the same
across all compilers and versions thereof for all time?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
