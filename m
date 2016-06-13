Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 605A97CA0
	for <xfs@oss.sgi.com>; Mon, 13 Jun 2016 16:58:06 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id DEE12AC004
	for <xfs@oss.sgi.com>; Mon, 13 Jun 2016 14:58:03 -0700 (PDT)
Received: from yamato.tf-network.de (yamato.tf-network.de [93.186.202.221]) by
	cuda.sgi.com with ESMTP id AQ6GjxI9rUSpWHMB (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 13 Jun 2016 14:57:56 -0700 (PDT)
Received: from amavis3.tf-network.de ([IPv6:2001:4ba0:ffa0:1b::d1:221])
	by yamato.tf-network.de (Postfix) with ESMTP id 3rT68f6m53z45m1
	for <xfs@oss.sgi.com>; Mon, 13 Jun 2016 23:57:54 +0200 (CEST)
Received: from smtp.tf-network.de ([93.186.202.221])
	by amavis3.tf-network.de ([IPv6:2001:4ba0:ffa0:1b::d1:221])
	(amavisd-new, port 10024)
	with LMTP id JeBIUkEnd1eZ for <xfs@oss.sgi.com>;
	Mon, 13 Jun 2016 23:57:54 +0200 (CEST)
Received: from [192.168.2.10] (pD9F15652.dip0.t-ipconnect.de [217.241.86.82])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128
	bits)) (No client certificate requested)
	by smtp.tf-network.de (Postfix) with ESMTPSA id 3rT68f18LTz45ls
	for <xfs@oss.sgi.com>; Mon, 13 Jun 2016 23:57:54 +0200 (CEST)
From: "Thomas D." <whissi@whissi.de>
Subject: Something badly broken with the latest XFS changeset in all stable
	kernels?
Message-ID: <75808782-835f-4bc9-5243-b25cab00d6f3@whissi.de>
Date: Mon, 13 Jun 2016 23:57:53 +0200
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
To: xfs@oss.sgi.com

Hi,

can anybody confirm if there's something broken with the latest XFS
change set which is now applied on all stable kernels?

I found https://forums.grsecurity.net/viewtopic.php?t=4489&p=16355 and
grsec changelog says

> commit 1f621dc42acbabb71bd69f6ba606cee56e7ad3bc
> Author: Brad Spengler <spender@grsecurity.net>
> Date:   Sat Jun 11 08:14:32 2016 -0400
> 
>     Fix Greg KH's broken XFS backport, caused a benign case to be detected
>     as disk corruption
>     Problem was due to a tree-wide conversion of error codes to their negative
>     counterparts, which would likely never be backported to older kernels, but
>     the backports didn't account for the change
> 
>  fs/xfs/xfs_inode.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

This is the change grsec applied:

> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index fb8579d..af807d8 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -3098,7 +3111,7 @@ xfs_iflush(
>  	 */
>  	error = xfs_imap_to_bp(mp, NULL, &ip->i_imap, &dip, &bp, XBF_TRYLOCK,
>  			       0);
> -	if (error == -EAGAIN) {
> +	if (error == EAGAIN) {
>  		xfs_ifunlock(ip);
>  		return error;
>  	}

The bad commit according to grsec's statement is

> From b1438f477934f5a4d5a44df26f3079a7575d5946 Mon Sep 17 00:00:00 2001
> From: Dave Chinner <dchinner@redhat.com>
> Date: Wed, 18 May 2016 13:53:42 +1000
> Subject: [PATCH] xfs: xfs_iflush_cluster fails to abort on error

Would be nice to get some clarification.

Thanks.


-- 
Regards,
Thomas

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
