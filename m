Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q8EDgpCH110833 for <xfs@oss.sgi.com>; Fri, 14 Sep 2012 08:42:51 -0500
Received: from mail.sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com
	with ESMTP id ZBKDdIv325v02IIG for <xfs@oss.sgi.com>;
	Fri, 14 Sep 2012 06:43:57 -0700 (PDT)
Message-ID: <5053349C.20106@sandeen.net>
Date: Fri, 14 Sep 2012 08:43:56 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstests: 275, Don't remove all the files in SCRATCH_MNT.
References: <1347620592-3420-1-git-send-email-tm@tao.ma>
In-Reply-To: <1347620592-3420-1-git-send-email-tm@tao.ma>
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
To: Tao Ma <tm@tao.ma>
Cc: xfs@oss.sgi.com

On 9/14/12 6:03 AM, Tao Ma wrote:
> From: Tao Ma <boyu.mt@taobao.com>
> 
> After the volume is mkfsed, it should have no other files that
> need to be rmed. And what's more, it makes ext4 complain since
> lost+found is also removed.
> 
> So remove this useless "rm -rf $SCRATCH_MNT/*".

Oh, sigh, after all the review how did I miss that :/

Reviewed-by: Eric Sandeen <sandeen@sandeen.net>

SGI: I won't be pushing this to kernel.org trees per the emails yesterday.

Thanks,
-Eric

> Cc: Eric Sandeen <sandeen@sandeen.net>
> Signed-off-by: Tao Ma <boyu.mt@taobao.com>
> ---
>  275 |    2 --
>  1 files changed, 0 insertions(+), 2 deletions(-)
> 
> diff --git a/275 b/275
> index 69b2895..06db775 100755
> --- a/275
> +++ b/275
> @@ -57,8 +57,6 @@ umount $SCRATCH_DEV 2>/dev/null
>  _scratch_mkfs_sized $((2 * 1024 * 1024 * 1024)) >>$seq.full 2>&1
>  _scratch_mount
>  
> -rm -rf $SCRATCH_MNT/*
> -
>  dd if=/dev/zero of=$SCRATCH_MNT/tmp1 bs=256K count=1 >>$seq.full 2>&1
>  [ $? -ne 0 ] && _fail "Error creating file"
>  
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
