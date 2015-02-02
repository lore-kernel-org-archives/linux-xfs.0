Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 379287F7B
	for <xfs@oss.sgi.com>; Mon,  2 Feb 2015 10:28:03 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 164CD8F804B
	for <xfs@oss.sgi.com>; Mon,  2 Feb 2015 08:28:02 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id BhBTtUvNSPU4T2LB (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 02 Feb 2015 08:28:01 -0800 (PST)
Date: Mon, 2 Feb 2015 11:27:55 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH] libxfs: report VERSION in libxfs_fs_repair_cmn_err()
Message-ID: <20150202162755.GA6096@laptop.bfoster>
References: <54CB2487.6040602@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <54CB2487.6040602@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs-oss <xfs@oss.sgi.com>

On Fri, Jan 30, 2015 at 12:28:23AM -0600, Eric Sandeen wrote:
> Because this is usually the first question asked...
> 
> Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
> ---

Good idea.

Reviewed-by: Brian Foster <bfoster@redhat.com>

> 
> diff --git a/libxfs/util.c b/libxfs/util.c
> index 9504e33..6464a1b 100644
> --- a/libxfs/util.c
> +++ b/libxfs/util.c
> @@ -718,6 +718,7 @@ libxfs_fs_repair_cmn_err(int level, xfs_mount_t *mp, char *fmt, ...)
>  	va_start(ap, fmt);
>  	vfprintf(stderr, fmt, ap);
>  	fprintf(stderr, "  This is a bug.\n");
> +	fprintf(stderr, "%s version %s\n", progname, VERSION);
>  	fprintf(stderr, "Please capture the filesystem metadata with "
>  			"xfs_metadump and\nreport it to xfs@oss.sgi.com.\n");
>  	va_end(ap);
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
