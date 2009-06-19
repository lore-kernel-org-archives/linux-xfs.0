Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n5JJFti2077083 for <xfs@oss.sgi.com>; Fri, 19 Jun 2009 14:15:55 -0500
Received: from estes.americas.sgi.com (estes.americas.sgi.com [128.162.236.10])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 5603B8F804B
	for <xfs@oss.sgi.com>; Fri, 19 Jun 2009 12:16:21 -0700 (PDT)
Message-Id: <7D909252-70A0-44C2-A5D7-D56A4B6CD244@sgi.com>
From: Felix Blyakher <felixb@sgi.com>
In-Reply-To: <1245434013-9433-3-git-send-email-tytso@mit.edu>
Mime-Version: 1.0 (Apple Message framework v926)
Subject: Re: [PATCH 3/3] Fix _require_scratch test for extN, resierfs, gfs2,
	and btrfs
Date: Fri, 19 Jun 2009 14:16:20 -0500
References: <1245434013-9433-1-git-send-email-tytso@mit.edu>
	<1245434013-9433-3-git-send-email-tytso@mit.edu>
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
To: Theodore Ts'o <tytso@mit.edu>
Cc: xfs@oss.sgi.com


On Jun 19, 2009, at 12:53 PM, Theodore Ts'o wrote:

> The extN, reiserfs, gfs2, and btrfs filesysytem types should use the
> same check for a block device as XFS and UDF, and not the test for
> NFS, which was checking for host:/foo/bar/baz when checking for a
> scratch device.
>
> Also, the NFS logic was also incorrect, in that it would allow a
> zero-length SCRATCH_DEV to continue.

This part wasn't addressed in the patch, right?

> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

Reviewed-by: Felix Blyakher <felixb@sgi.com>

>
> ---
> common.rc |    4 ++--
> 1 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/common.rc b/common.rc
> index 581cfba..8b9ba7d 100644
> --- a/common.rc
> +++ b/common.rc
> @@ -593,7 +593,7 @@ _supported_os()
> _require_scratch()
> {
>     case "$FSTYP" in
> -	xfs|udf)
> +	xfs|udf|ext2|ext3|ext4|reiserfs|gfs2|btrfs)
> 		 if [ -z "$SCRATCH_DEV" -o "`_is_block_dev $SCRATCH_DEV`" = "" ]
> 		 then
> 		     _notrun "this test requires a valid \$SCRATCH_DEV"
> @@ -603,7 +603,7 @@ _require_scratch()
> 		     _notrun "this test requires a valid \$SCRATCH_DEV"
> 		 fi
> 		 ;;
> -	nfs*|ext2|ext3|ext4|reiserfs|gfs2|btrfs)
> +	nfs*)
> 		 echo $SCRATCH_DEV | grep -q ":" > /dev/null 2>&1
> 		 if [ ! -z "$SCRATCH_DEV" -a ! -b "$SCRATCH_DEV" -a "$?" != "0" ]
> 		 then
> -- 
> 1.6.3.2.1.gb9f7d.dirty
>
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
