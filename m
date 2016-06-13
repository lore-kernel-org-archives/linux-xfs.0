Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 00FC37CA0
	for <xfs@oss.sgi.com>; Mon, 13 Jun 2016 16:32:39 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 5D71CAC001
	for <xfs@oss.sgi.com>; Mon, 13 Jun 2016 14:32:31 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id jom1uKYxaD3U24IY for <xfs@oss.sgi.com>;
	Mon, 13 Jun 2016 14:32:22 -0700 (PDT)
Received: from [10.0.0.4] (liberator [10.0.0.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id 9F10DB55
	for <xfs@oss.sgi.com>; Mon, 13 Jun 2016 16:32:22 -0500 (CDT)
Subject: Re: [PATCH] xfs: hide unused variable
References: <1460838665-1249242-1-git-send-email-arnd@arndb.de>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <24741415-3bd6-18cd-6ba7-cd86b1d4149d@sandeen.net>
Date: Mon, 13 Jun 2016 16:32:22 -0500
MIME-Version: 1.0
In-Reply-To: <1460838665-1249242-1-git-send-email-arnd@arndb.de>
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

On 4/16/16 3:30 PM, Arnd Bergmann wrote:
> The newly added xfs_finish_page_writeback() function causes
> a harmless gcc warning when debugging is disabled:
> 
> fs/xfs/xfs_aops.c: In function 'xfs_finish_page_writeback':
> fs/xfs/xfs_aops.c:97:16: error: unused variable 'blockmask' [-Werror=unused-variable]
>   unsigned int  blockmask = (1 << inode->i_blkbits) - 1;
>                 ^~~~~~~~~
> 
> This adds an #ifdef around the variable declaration to hide
> it whenever the ASSERT macro is defined as a stub, following
> the same style as used elsewhere in xfs.

Thanks Arnd - 

This got fixed by hch's patch,

690a787 xfs: fix warning in xfs_finish_page_writeback for non-debug builds

-Eric

 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Fixes: 37992c18bba3 ("xfs: don't release bios on completion immediately")
> ---
>  fs/xfs/xfs_aops.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
> index e5c3a457c191..737d028914a2 100644
> --- a/fs/xfs/xfs_aops.c
> +++ b/fs/xfs/xfs_aops.c
> @@ -94,7 +94,9 @@ xfs_finish_page_writeback(
>  	struct bio_vec		*bvec,
>  	int			error)
>  {
> +#if defined(DEBUG) || defined(XFS_WARN)
>  	unsigned int		blockmask = (1 << inode->i_blkbits) - 1;
> +#endif
>  	unsigned int		end = bvec->bv_offset + bvec->bv_len - 1;
>  	struct buffer_head	*head, *bh;
>  	unsigned int		off = 0;
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
