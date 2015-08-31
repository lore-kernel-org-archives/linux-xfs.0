Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 4111C7F47
	for <xfs@oss.sgi.com>; Mon, 31 Aug 2015 13:19:40 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id C5D4EAC006
	for <xfs@oss.sgi.com>; Mon, 31 Aug 2015 11:19:36 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id oTHIo0Y5fzrjGk5m (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 31 Aug 2015 11:19:35 -0700 (PDT)
Date: Mon, 31 Aug 2015 14:19:32 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH] xfs: add mssing inode cache attempts counter increment
Message-ID: <20150831181931.GB16371@bfoster.bfoster>
References: <1440702261-3018-1-git-send-email-dev@lynxeye.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1440702261-3018-1-git-send-email-dev@lynxeye.de>
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
To: Lucas Stach <dev@lynxeye.de>
Cc: xfs@oss.sgi.com

On Thu, Aug 27, 2015 at 09:04:21PM +0200, Lucas Stach wrote:
> Increasing the inode cache attempt counter was apparently dropped while
> refactoring the cache code and so stayed at the initial 0 value. Add the
> increment back to make the runtime stats more useful.
> 
> Signed-off-by: Lucas Stach <dev@lynxeye.de>
> ---

Heh, this goes back to:

	bf90424 [XFS] Combine the XFS and Linux inodes

... from 2008. :)

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_icache.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> index 76a9f27..0a326bd 100644
> --- a/fs/xfs/xfs_icache.c
> +++ b/fs/xfs/xfs_icache.c
> @@ -412,6 +412,8 @@ xfs_iget(
>  	if (!ino || XFS_INO_TO_AGNO(mp, ino) >= mp->m_sb.sb_agcount)
>  		return -EINVAL;
>  
> +	XFS_STATS_INC(xs_ig_attempts);
> +
>  	/* get the perag structure and ensure that it's inode capable */
>  	pag = xfs_perag_get(mp, XFS_INO_TO_AGNO(mp, ino));
>  	agino = XFS_INO_TO_AGINO(mp, ino);
> -- 
> 2.4.3
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
