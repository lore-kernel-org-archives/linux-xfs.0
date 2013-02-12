Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id BF42E7F75
	for <xfs@oss.sgi.com>; Tue, 12 Feb 2013 09:11:43 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id AF67A8F8049
	for <xfs@oss.sgi.com>; Tue, 12 Feb 2013 07:11:43 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id NfGiOAwrS1tOW50p for <xfs@oss.sgi.com>;
	Tue, 12 Feb 2013 07:11:39 -0800 (PST)
Message-ID: <511A5BAA.5000203@sandeen.net>
Date: Tue, 12 Feb 2013 09:11:38 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs_mkfs: Do not discard if '-N' is provided
References: <1360670381-19838-1-git-send-email-lczerner@redhat.com>
In-Reply-To: <1360670381-19838-1-git-send-email-lczerner@redhat.com>
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
To: Lukas Czerner <lczerner@redhat.com>
Cc: xfs@oss.sgi.com

On 2/12/13 5:59 AM, Lukas Czerner wrote:
> When '-N' is specified we really should not write anything to the
> device, neither we should attempt to discard the device.
> 
> This commit fixes xfs_mkfs to not attempt to discard the device in the
> case user specified '-N' flag.

Thanks, and yes - ouch, this shouldn't happen with -N, that's bad!

But it doesn't look like this is against the current git tree,
it applies only with a lot of fuzz & offsets.

-Eric

> Signed-off-by: Lukas Czerner <lczerner@redhat.com>
> ---
>  mkfs/xfs_mkfs.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> index a889620..95e27e0 100644
> --- a/mkfs/xfs_mkfs.c
> +++ b/mkfs/xfs_mkfs.c
> @@ -2010,7 +2010,7 @@ _("block size %d cannot be smaller than logical sector size %d\n"),
>  			exit(1);
>  		}
>  
> -	if (discard) {
> +	if (discard && !Nflag) {
>  		discard_blocks(xi.ddev, xi.dsize);
>  		if (xi.rtdev)
>  			discard_blocks(xi.rtdev, xi.rtsize);
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
