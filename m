Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:48110 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751485AbeAHUUA (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 8 Jan 2018 15:20:00 -0500
Subject: Re: [PATCH] xfs: clarify units in the failed metadata io message
References: <20180108194015.GT5602@magnolia>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <fb402d1c-c609-77de-8ae8-6cb19aadd448@sandeen.net>
Date: Mon, 8 Jan 2018 14:19:58 -0600
MIME-Version: 1.0
In-Reply-To: <20180108194015.GT5602@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, xfs <linux-xfs@vger.kernel.org>

On 1/8/18 1:40 PM, Darrick J. Wong wrote:> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> If a metadata IO error happens, we report the location of the failed IO
> request in units of daddrs.  However, the printk message misleads people
> into thinking that the units are fs blocks, so fix the reported units.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/xfs_buf.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index 1981ef7..582c64a 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -1196,7 +1196,7 @@ xfs_buf_ioerror_alert(
>  	const char		*func)
>  {
>  	xfs_alert(bp->b_target->bt_mount,
> -"metadata I/O error: block 0x%llx (\"%s\") error %d numblks %d",
> +"metadata I/O error: daddr 0x%llx (\"%s\") error %d numblks %d",
>  		(uint64_t)XFS_BUF_ADDR(bp), func, -bp->b_error, bp->b_length);
Ok, so I might have nodded in approval on IRC a little early; if "block"
was misleading, I think "numblks" is too.  So if you change one to
daddr, I wonder if the other should be changed as well to, um ...


"metadata I/O error: daddr 0x%llx (\"%s\") error %d count %d"

?  That's a bit vague but at least not misleadingly containing a form of
"blocks" - whatchathink?  Maybe "len?"  Even "sectors" is a bit overloaded
now.  :(

-Eric
