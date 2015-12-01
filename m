Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 449967F5A
	for <xfs@oss.sgi.com>; Tue,  1 Dec 2015 08:43:35 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 31609304053
	for <xfs@oss.sgi.com>; Tue,  1 Dec 2015 06:43:35 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id rF25NMjrmrJX5NLF (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 01 Dec 2015 06:43:33 -0800 (PST)
Received: from int-mx14.intmail.prod.int.phx2.redhat.com
	(int-mx14.intmail.prod.int.phx2.redhat.com [10.5.11.27])
	by mx1.redhat.com (Postfix) with ESMTPS id BBB7D33E7F9
	for <xfs@oss.sgi.com>; Tue,  1 Dec 2015 14:43:32 +0000 (UTC)
Date: Tue, 1 Dec 2015 15:43:29 +0100
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [XFSTESTS 2/6] check: Enforce xfs filesystem recreation on
	$TEST_DEV
Message-ID: <20151201144329.GA28026@redhat.com>
References: <1447856269-7872-1-git-send-email-agruenba@redhat.com>
	<1447856269-7872-3-git-send-email-agruenba@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1447856269-7872-3-git-send-email-agruenba@redhat.com>
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
To: Andreas Gruenbacher <agruenba@redhat.com>
Cc: xfs@oss.sgi.com

On Wed, Nov 18, 2015 at 03:17:45PM +0100, Andreas Gruenbacher wrote:
> When recreating xfs filesystems on $TEST_DEV, pass option -f to enforce
> the filesystem creation instead of refusing to overwrite existing xfs
> filesystems.  We already do that for ext2/ext3/ext4 filesystems.
> 

I don't believe this is a right thing to do, $TEST_DEV isn't supposed to be
rebuilt, but, to be kept around over several xfstests runs, for filesystem aging
testing.

Having this here might cause a xfstests user to accidentally mkfs an aged
filesystem, which IMHO is not something we want to do with $TEST_DEV


> Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
> ---
>  common/rc | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/common/rc b/common/rc
> index 4c2f42c..ce6ae3d 100644
> --- a/common/rc
> +++ b/common/rc
> @@ -572,6 +572,9 @@ _test_mkfs()
>      btrfs)
>          $MKFS_BTRFS_PROG $MKFS_OPTIONS $* $TEST_DEV > /dev/null
>  	;;
> +    xfs)
> +	$MKFS_PROG -t $FSTYP -- -f $MKFS_OPTIONS $* $TEST_DEV
> +	;;
>      ext2|ext3|ext4)
>  	$MKFS_PROG -t $FSTYP -- -F $MKFS_OPTIONS $* $TEST_DEV
>  	;;
> -- 
> 2.5.0
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

-- 
Carlos

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
