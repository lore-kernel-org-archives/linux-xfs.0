Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n98JZbj4026571 for <xfs@oss.sgi.com>; Thu, 8 Oct 2009 14:35:37 -0500
Content-class: urn:content-classes:message
MIME-Version: 1.0
Subject: RE: [PATCH 8/8] fs/xfs/xfs_log_recover.c: Use %pU to print UUIDs
Date: Thu, 8 Oct 2009 14:36:04 -0500
Message-ID: <1AB9A794DBDDF54A8A81BE2296F7BDFE83AD41@cf--amer001e--3.americas.sgi.com>
In-Reply-To: <d3ce3dab424deedd43322990503af8944f751a73.1254884776.git.joe@perches.com>
From: "Alex Elder" <aelder@sgi.com>
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
To: Joe Perches <joe@perches.com>
Cc: xfs@oss.sgi.com

Joe Perches wrote:
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  fs/xfs/xfs_log_recover.c |   14 ++++----------
>  1 files changed, 4 insertions(+), 10 deletions(-)

I think this looks OK, but I'm going to hold of until
I see the core support in lib/vsprintf.c committed
before I pull it into the XFS repository.

					-Alex
 
> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> index 1099395..3b8e3df 100644
> --- a/fs/xfs/xfs_log_recover.c
> +++ b/fs/xfs/xfs_log_recover.c
> @@ -225,16 +225,10 @@ xlog_header_check_dump(
>  	xfs_mount_t		*mp,
>  	xlog_rec_header_t	*head)
>  {
> -	int			b;
> -
> -	cmn_err(CE_DEBUG, "%s:  SB : uuid = ", __func__);
> -	for (b = 0; b < 16; b++)
> -		cmn_err(CE_DEBUG, "%02x", ((__uint8_t *)&mp->m_sb.sb_uuid)[b]);
> -	cmn_err(CE_DEBUG, ", fmt = %d\n", XLOG_FMT);
> -	cmn_err(CE_DEBUG, "    log : uuid = ");
> -	for (b = 0; b < 16; b++)
> -		cmn_err(CE_DEBUG, "%02x", ((__uint8_t *)&head->h_fs_uuid)[b]);
> -	cmn_err(CE_DEBUG, ", fmt = %d\n", be32_to_cpu(head->h_fmt));
> +	cmn_err(CE_DEBUG, "%s:  SB : uuid = %pU, fmt = %d\n",
> +		__func__, &mp->m_sb.sb_uuid, XLOG_FMT);
> +	cmn_err(CE_DEBUG, "    log : uuid = %pU, fmt = %d\n",
> +		&head->h_fs_uuid, be32_to_cpu(head->h_fmt));
>  }
>  #else
>  #define xlog_header_check_dump(mp, head)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
