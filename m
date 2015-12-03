Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id E4A2B7F5A
	for <xfs@oss.sgi.com>; Wed,  2 Dec 2015 23:51:33 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id D54B38F8037
	for <xfs@oss.sgi.com>; Wed,  2 Dec 2015 21:51:33 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id OCs9MD31Hp4vTQnb for <xfs@oss.sgi.com>;
	Wed, 02 Dec 2015 21:51:32 -0800 (PST)
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.4])
	(using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id C60B063C5A9F
	for <xfs@oss.sgi.com>; Wed,  2 Dec 2015 23:51:31 -0600 (CST)
Subject: Re: [PATCH 09/11] xfsprogs: xfs_repair: fix possible null dereference
	in traverse_int_dir2block
References: <1449055167-19936-1-git-send-email-t.vivek@samsung.com>
	<1449055167-19936-10-git-send-email-t.vivek@samsung.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <565FD863.3090105@sandeen.net>
Date: Wed, 2 Dec 2015 23:51:31 -0600
MIME-Version: 1.0
In-Reply-To: <1449055167-19936-10-git-send-email-t.vivek@samsung.com>
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

On 12/2/15 5:19 AM, Vivek Trivedi wrote:
> Fix possible null dereference in traverse_int_dir2block if buffer pointer is NULL.
> Reported by coverity.

Hm, against what version of xfsprogs?

traverse_int_dir2block has been gone for a while now.  Can you please recheck
against current git, and if there's still an issue, explain a bit more;
I don't see offhand how we get a bp back from da_read_buf with a null bp->b_addr.

thanks,
-Eric 

> Signed-off-by: Vivek Trivedi <t.vivek@samsung.com>
> ---
>  repair/dir2.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/repair/dir2.c b/repair/dir2.c
> index 61912d1..fe360dc 100644
> --- a/repair/dir2.c
> +++ b/repair/dir2.c
> @@ -1300,7 +1300,7 @@ _("block %" PRIu64 " for directory inode %" PRIu64 " is missing\n"),
>  		bp = da_read_buf(mp, nex, bmp, &xfs_dir3_data_buf_ops);
>  		if (bmp != &lbmp)
>  			free(bmp);
> -		if (bp == NULL) {
> +		if (bp == NULL || !bp->b_addr) {
>  			do_warn(
>  _("can't read block %" PRIu64 " for directory inode %" PRIu64 "\n"),
>  				dbno, ino);
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
