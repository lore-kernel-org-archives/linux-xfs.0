Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p83HEhk1137285 for <xfs@oss.sgi.com>; Sat, 3 Sep 2011 12:14:43 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 86258132959
	for <xfs@oss.sgi.com>; Sat,  3 Sep 2011 10:14:38 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	FttKAJHaDG1euNod for <xfs@oss.sgi.com>;
	Sat, 03 Sep 2011 10:14:38 -0700 (PDT)
Date: Sat, 3 Sep 2011 13:14:37 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] Assume yes when test device is not partitioned
Message-ID: <20110903171437.GA2755@infradead.org>
References: <1315038723-2009-1-git-send-email-prasadjoshi.linux@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1315038723-2009-1-git-send-email-prasadjoshi.linux@gmail.com>
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
To: Prasad Joshi <prasadjoshi.linux@gmail.com>
Cc: linux-ext4@vger.kernel.org, Chaitanya Kulkarni <chaitanyakulkarni15@gmail.com>, xfs@oss.sgi.com

On Sat, Sep 03, 2011 at 02:02:03PM +0530, Prasad Joshi wrote:
> The patch also replaces hard coded mkfs path with MKFS_PROG variable.

Which has nothing to do with the subject of this patch, so do it
separately, with a proper rationale for it.

>+++ b/common.rc
> @@ -314,7 +314,7 @@ _scratch_mkfs()
>          $MKFS_BTRFS_PROG $MKFS_OPTIONS $* $SCRATCH_DEV > /dev/null
>  	;;
>      *)
> -	/sbin/mkfs -t $FSTYP -- $MKFS_OPTIONS $* $SCRATCH_DEV
> +	yes | $MKFS_PROG -t $FSTYP -- $MKFS_OPTIONS $* $SCRATCH_DEV

Please do this for extN only as the braindamage is in mke2fs, not
generic mkfs.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
