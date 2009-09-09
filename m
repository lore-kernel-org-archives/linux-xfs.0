Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n89H3K1m171378 for <xfs@oss.sgi.com>; Wed, 9 Sep 2009 12:03:30 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6294A43A36C
	for <xfs@oss.sgi.com>; Wed,  9 Sep 2009 10:04:11 -0700 (PDT)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id BoXfrVwcu43i51iZ for
	<xfs@oss.sgi.com>; Wed, 09 Sep 2009 10:04:11 -0700 (PDT)
Message-ID: <4AA7E00A.1060201@sandeen.net>
Date: Wed, 09 Sep 2009 12:04:10 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfsprogs: fix the -V option for various shell scripts
References: <20090902174451.GB9759@infradead.org>
In-Reply-To: <20090902174451.GB9759@infradead.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: Michael Monnerie <michael.monnerie@is.it-management.at>, xfs@oss.sgi.com

Christoph Hellwig wrote:
> For most of the shellscripts wrapping xfs_db or xfs_growfs the -V option
> is not implemented correctly.  If we just add -V to the options for the
> underlying binaries we will never actually call it because the mandatory
> device / mount point argument is missing.  Instead just call the underlying
> command with -V directly and exit early.  This is what xfs_bmap.sh,
> xfs_mkfile and xfs_metadump.sh are already doing.
> 
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reported-by: Michael Monnerie <michael.monnerie@is.it-management.at>

Reviewed-by: Eric Sandeen <sandeen@sandeen.net>

> Index: xfsprogs-dev/db/xfs_admin.sh
> ===================================================================
> --- xfsprogs-dev.orig/db/xfs_admin.sh	2009-09-02 14:36:22.045272960 -0300
> +++ xfsprogs-dev/db/xfs_admin.sh	2009-09-02 14:38:28.497305969 -0300
> @@ -19,7 +19,10 @@ do
>  	L)	DB_OPTS=$DB_OPTS" -c 'label "$OPTARG"'";;
>  	u)	DB_OPTS=$DB_OPTS" -r -c uuid";;
>  	U)	DB_OPTS=$DB_OPTS" -c 'uuid "$OPTARG"'";;
> -	V)	DB_OPTS=$DB_OPTS" -V";;
> +	V)	xfs_db -p xfs_admin -V
> +		status=$?
> +		exit $status
> +		;;
>  	\?)	echo $USAGE 1>&2
>  		exit 2
>  		;;
> Index: xfsprogs-dev/db/xfs_check.sh
> ===================================================================
> --- xfsprogs-dev.orig/db/xfs_check.sh	2009-09-02 14:36:22.069271261 -0300
> +++ xfsprogs-dev/db/xfs_check.sh	2009-09-02 14:38:28.501271696 -0300
> @@ -13,11 +13,14 @@ do
>  	s)	OPTS=$OPTS"-s ";;
>  	t)	OPTS=$OPTS"-t ";;
>  	v)	OPTS=$OPTS"-v ";;
> -	V)	OPTS=$OPTS"-V ";;
>  	i)	OPTS=$OPTS"-i "$OPTARG" ";;
>  	b)	OPTS=$OPTS"-b "$OPTARG" ";;
>  	f)	DBOPTS=$DBOPTS" -f";;
>  	l)	DBOPTS=$DBOPTS" -l "$OPTARG" ";;
> +	V)	xfs_db -p xfs_check -V
> +		status=$?
> +		exit $status
> +		;;
>  	\?)	echo $USAGE 1>&2
>  		exit 2
>  		;;
> Index: xfsprogs-dev/db/xfs_ncheck.sh
> ===================================================================
> --- xfsprogs-dev.orig/db/xfs_ncheck.sh	2009-09-02 14:36:22.089271988 -0300
> +++ xfsprogs-dev/db/xfs_ncheck.sh	2009-09-02 14:38:28.501271696 -0300
> @@ -14,9 +14,12 @@ do
>  	s)	OPTS=$OPTS"-s ";;
>  	i)	OPTS=$OPTS"-i "$OPTARG" ";;
>  	v)	OPTS=$OPTS"-v ";;
> -	V)	OPTS=$OPTS"-V ";;
>  	f)	DBOPTS=$DBOPTS" -f";;
>  	l)	DBOPTS=$DBOPTS" -l "$OPTARG" ";;
> +	V)	xfs_db -p xfs_ncheck -V
> +		status=$?
> +		exit $status
> +		;;
>  	\?)	echo $USAGE 1>&2
>  		exit 2
>  		;;
> Index: xfsprogs-dev/growfs/xfs_info.sh
> ===================================================================
> --- xfsprogs-dev.orig/growfs/xfs_info.sh	2009-09-02 14:36:22.101270370 -0300
> +++ xfsprogs-dev/growfs/xfs_info.sh	2009-09-02 14:38:28.505312364 -0300
> @@ -10,7 +10,10 @@ while getopts "t:V" c
>  do
>  	case $c in
>  	t)	OPTS="-t $OPTARG" ;;
> -	V)	OPTS="-V $OPTARG" ;;
> +	V)	xfs_growfs -p xfs_info -V
> +		status=$?
> +		exit $status
> +		;;
>  	*)	echo $USAGE 1>&2
>  		exit 2
>  		;;
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
