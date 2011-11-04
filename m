Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pA45iRTc074245 for <xfs@oss.sgi.com>; Fri, 4 Nov 2011 00:44:29 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5316121EDA5
	for <xfs@oss.sgi.com>; Thu,  3 Nov 2011 22:39:09 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	w8WGGYLvfRn7MYDL for <xfs@oss.sgi.com>;
	Thu, 03 Nov 2011 22:39:09 -0700 (PDT)
Date: Fri, 4 Nov 2011 01:39:08 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/2] xfstests: meet btrfs fs size requirement in
	_scratch_mkfs_sized()
Message-ID: <20111104053908.GB16720@infradead.org>
References: <1320374284-1534-1-git-send-email-guaneryu@gmail.com>
	<1320374284-1534-2-git-send-email-guaneryu@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1320374284-1534-2-git-send-email-guaneryu@gmail.com>
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
To: Eryu Guan <guaneryu@gmail.com>
Cc: linux-btrfs@vger.kernel.org, xfs@oss.sgi.com

On Fri, Nov 04, 2011 at 10:38:04AM +0800, Eryu Guan wrote:
> btrfs requires at least 256M file system size, so check 'fssize' in
> _scratch_mkfs_sized first and give it a proper value. Otherwise
> mkfs.btrfs will complain something like
> 
> "File system size 267386880 bytes is too small, 256M is required at least"
> 
> This makes 015 077 and 083 run on btrfs.

But it's not really going to test the ENOSPC conditions it was designed
to exercise.  It would be better to either find a way to make btrfs run on
smaller filesystem, or call _notrun for too small filesystems on btrfs
from _scratch_mkfs_sized.

> 
> Signed-off-by: Eryu Guan <guaneryu@gmail.com>
> ---
>  common.rc |    5 +++++
>  1 files changed, 5 insertions(+), 0 deletions(-)
> 
> diff --git a/common.rc b/common.rc
> index e948169..ab61786 100644
> --- a/common.rc
> +++ b/common.rc
> @@ -356,6 +356,11 @@ _scratch_mkfs_sized()
>  	/sbin/mkfs.$FSTYP $MKFS_OPTIONS -b $blocksize $SCRATCH_DEV $blocks
>  	;;
>      btrfs)
> +    # btrfs needs at least 256M file system size
> +	if [ $fssize -lt $((256*1024*1024)) ]
> +	then
> +		fssize=$((256*1024*1024))
> +	fi
>  	$MKFS_BTRFS_PROG $MKFS_OPTIONS -b $fssize $SCRATCH_DEV
>  	;;
>      *)
> -- 
> 1.7.7.1
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
---end quoted text---

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
