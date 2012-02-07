Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q17EJOHO232567 for <xfs@oss.sgi.com>; Tue, 7 Feb 2012 08:19:24 -0600
Message-ID: <4F3132EC.8010903@sgi.com>
Date: Tue, 07 Feb 2012 08:19:24 -0600
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] Introduce SEEK_DATA/SEEK_HOLE support to XFS V7
References: <4F2FE66C.80303@oracle.com>
In-Reply-To: <4F2FE66C.80303@oracle.com>
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
To: jeff.liu@oracle.com
Cc: Christoph Hellwig <hch@infradead.org>, Ben Myers <bpm@sgi.com>, Chris Mason <chris.mason@oracle.com>, xfs@oss.sgi.com

On 02/06/12 08:40, Jeff Liu wrote:
> Hello,
>
> There is one bug fix in this version, in xfs_seek_data()/xfs_seek_hole(), call xfs_bmapi_read() or
> xfs_bmap_first_unused() maybe failed, they should return ENXIO in this case.
> Thanks Mark for pointing this out!
>
>
> Signed-off-by: Jie Liu<jeff.liu@oracle.com>
>
> ---
>   fs/xfs/xfs_file.c |  172 ++++++++++++++++++++++++++++++++++++++++++++++++++++-
>   1 files changed, 171 insertions(+), 1 deletions(-)
>
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index 753ed9b..3822b15 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -1141,8 +1141,178 @@ xfs_vm_page_mkwrite(
>   	return block_page_mkwrite(vma, vmf, xfs_get_blocks);


Looks good.

Reviewed-by: Mark Tinguely <tinguely@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
