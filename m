Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id C059E29DF8
	for <xfs@oss.sgi.com>; Tue, 17 Dec 2013 23:33:53 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 5EF19AC001
	for <xfs@oss.sgi.com>; Tue, 17 Dec 2013 21:33:47 -0800 (PST)
Received: from mx4-phx2.redhat.com (mx4-phx2.redhat.com [209.132.183.25]) by
	cuda.sgi.com with ESMTP id TcWtYypKP7lK5oTJ for
	<xfs@oss.sgi.com>; Tue, 17 Dec 2013 21:33:46 -0800 (PST)
Date: Wed, 18 Dec 2013 00:33:42 -0500 (EST)
From: Boris Ranto <branto@redhat.com>
Message-ID: <1676964890.8345887.1387344822858.JavaMail.root@redhat.com>
In-Reply-To: <1387318722-3050-2-git-send-email-jayr@google.com>
References: <1387318722-3050-1-git-send-email-jayr@google.com>
	<1387318722-3050-2-git-send-email-jayr@google.com>
Subject: Re: [PATCH v2 02/12] xfstests: _scratch_mkfs_sized() for tmpfs
MIME-Version: 1.0
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
To: Junho Ryu <jayr@google.com>
Cc: tytso@mit.edu, hughd@google.com, xfs@oss.sgi.com

Same here, the patch uses -d instead of -b option.

----- Original Message -----
> From: Hugh Dickins <hughd@google.com>
> 
> _scratch_mkfs_sized() avoid blockdev and update MOUNT_OPTIONS with
> required size on tmpfs, so those tests using it can now run.
> 
> Signed-off-by: Hugh Dickins <hughd@google.com>
> Signed-off-by: Junho Ryu <jayr@google.com>
> ---
> 
> v2: same as v1
> 
>  common/rc | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/common/rc b/common/rc
> index a2005c9..c78356e 100644
> --- a/common/rc
> +++ b/common/rc
> @@ -590,7 +590,7 @@ _scratch_mkfs_sized()
>  
>      blocks=`expr $fssize / $blocksize`
>  
> -    if [ "$HOSTOS" == "Linux" ]; then
> +    if [ "$HOSTOS" == "Linux" -a -d "$SCRATCH_DEV" ]; then
>  	devsize=`blockdev --getsize64 $SCRATCH_DEV`
>  	[ "$fssize" -gt "$devsize" ] && _notrun "Scratch device too small"
>      fi
> @@ -611,6 +611,9 @@ _scratch_mkfs_sized()
>      btrfs)
>  	$MKFS_BTRFS_PROG $MKFS_OPTIONS -b $fssize $SCRATCH_DEV
>  	;;
> +    tmpfs)
> +	export MOUNT_OPTIONS="-o size=$fssize $TMPFS_MOUNT_OPTIONS"
> +	;;
>      *)
>  	_notrun "Filesystem $FSTYP not supported in _scratch_mkfs_sized"
>  	;;
> --
> 1.8.5.1
> 
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
