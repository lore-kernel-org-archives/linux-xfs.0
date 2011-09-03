Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p83Hr4kr138785 for <xfs@oss.sgi.com>; Sat, 3 Sep 2011 12:53:05 -0500
Received: from test.thunk.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0D0EA1977FDA
	for <xfs@oss.sgi.com>; Sat,  3 Sep 2011 10:53:02 -0700 (PDT)
Received: from test.thunk.org (li9-11.members.linode.com [67.18.176.11]) by
	cuda.sgi.com with ESMTP id 0GPyM3tVBftWOLIK for
	<xfs@oss.sgi.com>; Sat, 03 Sep 2011 10:53:02 -0700 (PDT)
Date: Sat, 3 Sep 2011 13:52:59 -0400
From: "Ted Ts'o" <tytso@mit.edu>
Subject: Re: [PATCH] Assume yes when test device is not partitioned
Message-ID: <20110903175259.GA3461@thunk.org>
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
> @@ -333,7 +333,7 @@ _scratch_mkfs_sized()
>  	_scratch_mkfs_xfs -d size=$fssize -b size=$blocksize
>  	;;
>      ext2|ext3|ext4|ext4dev)
> -	/sbin/mkfs.$FSTYP $MKFS_OPTIONS -b $blocksize $SCRATCH_DEV $blocks
> +	yes | ${MKFS_PROG}.$FSTYP $MKFS_OPTIONS -b $blocksize $SCRATCH_DEV $blocks
>  	;;
>      btrfs)
>  	$MKFS_BTRFS_PROG $MKFS_OPTIONS -b $fssize $SCRATCH_DEV

Why don't you just pass -f to mke2fs.ext[234]?

							- Ted

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
