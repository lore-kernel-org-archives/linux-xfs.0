Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 7A71C7F77
	for <xfs@oss.sgi.com>; Sun,  6 Mar 2016 16:10:15 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 4EFCE30404E
	for <xfs@oss.sgi.com>; Sun,  6 Mar 2016 14:10:15 -0800 (PST)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id wz7UNyqc4jcYC90b (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Sun, 06 Mar 2016 14:10:10 -0800 (PST)
Date: Sun, 6 Mar 2016 14:09:35 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 13/12] xfs/209: filter scratch dir properly
Message-ID: <20160306220935.GB27960@birch.djwong.org>
References: <20160305003717.28738.98818.stgit@birch.djwong.org>
	<20160305202502.GI10245@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160305202502.GI10245@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org, fstests@vger.kernel.org, xfs@oss.sgi.com

Good catch,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

On Sat, Mar 05, 2016 at 12:25:02PM -0800, Christoph Hellwig wrote:
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> diff --git a/tests/xfs/209 b/tests/xfs/209
> index cecd9c7..9bf1f12 100755
> --- a/tests/xfs/209
> +++ b/tests/xfs/209
> @@ -73,7 +73,7 @@ echo "Check cowextsize settings"
>  seq 1 2 | while read nr; do
>  	seq 1 4 | while read nnr; do
>  		file="$testdir/dir-$nr/file-$nnr"
> -		$XFS_IO_PROG -c "cowextsize" $file
> +		$XFS_IO_PROG -c "cowextsize" $file | _filter_scratch
>  	done
>  done
>  
> diff --git a/tests/xfs/209.out b/tests/xfs/209.out
> index 109af34..b97fa96 100644
> --- a/tests/xfs/209.out
> +++ b/tests/xfs/209.out
> @@ -3,11 +3,11 @@ Format and mount
>  Set extsz and cowextsz on directory
>  Create a fake tree structure
>  Check cowextsize settings
> -[1048576] /opt/test-209/dir-1/file-1
> -[1048576] /opt/test-209/dir-1/file-2
> -[1048576] /opt/test-209/dir-1/file-3
> -[1048576] /opt/test-209/dir-1/file-4
> -[1048576] /opt/test-209/dir-2/file-1
> -[1048576] /opt/test-209/dir-2/file-2
> -[1048576] /opt/test-209/dir-2/file-3
> -[1048576] /opt/test-209/dir-2/file-4
> +[1048576] SCRATCH_MNT/test-209/dir-1/file-1
> +[1048576] SCRATCH_MNT/test-209/dir-1/file-2
> +[1048576] SCRATCH_MNT/test-209/dir-1/file-3
> +[1048576] SCRATCH_MNT/test-209/dir-1/file-4
> +[1048576] SCRATCH_MNT/test-209/dir-2/file-1
> +[1048576] SCRATCH_MNT/test-209/dir-2/file-2
> +[1048576] SCRATCH_MNT/test-209/dir-2/file-3
> +[1048576] SCRATCH_MNT/test-209/dir-2/file-4
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
