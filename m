Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id E236C7CBE
	for <xfs@oss.sgi.com>; Fri, 26 Apr 2013 14:18:29 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id A81308F8033
	for <xfs@oss.sgi.com>; Fri, 26 Apr 2013 12:18:29 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 5rma0CK4cmDV0FIJ for
	<xfs@oss.sgi.com>; Fri, 26 Apr 2013 12:18:28 -0700 (PDT)
Message-ID: <517AD302.4000905@redhat.com>
Date: Fri, 26 Apr 2013 14:18:26 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: Re: [PATCH] [PATCH] xfstests: use -F when making scratch ext4 fs
References: <1367003813-17686-1-git-send-email-jbacik@fusionio.com>
In-Reply-To: <1367003813-17686-1-git-send-email-jbacik@fusionio.com>
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
To: Josef Bacik <jbacik@fusionio.com>
Cc: linux-ext4@vger.kernel.org, xfs@oss.sgi.com

On 4/26/13 2:16 PM, Josef Bacik wrote:
> mkfs.ext4 will ask you if you are sure if you try to mkfs an entire disk instead
> of just a partition, so any xfstest that uses a scratch device and you specify a
> full disk will appear to hang because it's waiting for you to say yes.  This
> fixes the problem by just forcing it to do its thing.  Thanks,
> 
> Signed-off-by: Josef Bacik <jbacik@fusionio.com>

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

The whole-disk test is pretty derpy anyway. Too bad -F overrides
much more than just that, but this is probably a decent
thing to do.

Thanks,
-Eric

> ---
>  common/rc |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/common/rc b/common/rc
> index ff18cc2..9d1c3fc 100644
> --- a/common/rc
> +++ b/common/rc
> @@ -485,7 +485,7 @@ _scratch_mkfs_ext4()
>  {
>  	local tmp_dir=/tmp/
>  
> -	/sbin/mkfs -t $FSTYP -- $MKFS_OPTIONS $* $SCRATCH_DEV \
> +	/sbin/mkfs -t $FSTYP -- -F $MKFS_OPTIONS $* $SCRATCH_DEV \
>  			2>$tmp_dir.mkfserr 1>$tmp_dir.mkfsstd
>  	local mkfs_status=$?
>  
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
