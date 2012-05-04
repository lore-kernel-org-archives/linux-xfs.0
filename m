Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q44KvkWl087919 for <xfs@oss.sgi.com>; Fri, 4 May 2012 15:57:46 -0500
Date: Fri, 4 May 2012 16:01:09 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 1/4] xfstests: Fix a problem where using bsize was not
	working as expected
Message-ID: <20120504210109.GX16881@sgi.com>
References: <20120221165833.23253.38042.sendpatchset@chandra-lucid.austin.ibm.com>
	<20120221165839.23253.45298.sendpatchset@chandra-lucid.austin.ibm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120221165839.23253.45298.sendpatchset@chandra-lucid.austin.ibm.com>
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
To: Chandra Seetharaman <sekharan@us.ibm.com>
Cc: xfs@oss.sgi.com

On Tue, Feb 21, 2012 at 10:58:39AM -0600, Chandra Seetharaman wrote:
> >From d60824ddc4a60c7902a53fded6773b3385180cc6 Mon Sep 17 00:00:00 2001
> From: Chandra Seetharaman <sekharan@us.ibm.com>
> Date: Wed, 8 Feb 2012 10:02:37 -0600
> Subject: [PATCH 1/3] Fix a problem wherein the bsize argument setting to mkfs fails to be
>  included since MKFS_OPTIONS already has bsize.
> 
> Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>
> ---
>  common.rc |    5 ++++-
>  1 files changed, 4 insertions(+), 1 deletions(-)
> 
> diff --git a/common.rc b/common.rc
> index cab0b64..61889b0 100644
> --- a/common.rc
> +++ b/common.rc
> @@ -350,7 +350,10 @@ _scratch_mkfs_sized()
>  
>      case $FSTYP in
>      xfs)
> -	_scratch_mkfs_xfs -d size=$fssize -b size=$blocksize
> +	# replace bsize= in MKFS_OPTIONS if already defined
> +	export MKFS_OPTIONS=$(echo $MKFS_OPTIONS | \
> +			 sed -e "s/-bsize=[0-9]*/-bsize=$blocksize/")
> +	_scratch_mkfs_xfs "-d size=$fssize"

What if bsize wasn't specified already in MKFS_OPTIONS?  It looks like you
wouldn't be passing in a blocksize.

-Ben

>  	;;
>      ext2|ext3|ext4|ext4dev)
>  	/sbin/mkfs.$FSTYP $MKFS_OPTIONS -b $blocksize $SCRATCH_DEV $blocks
> -- 
> 1.7.1
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
