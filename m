Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 31A737F3F
	for <xfs@oss.sgi.com>; Wed, 23 Apr 2014 01:12:37 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 14A9B304043
	for <xfs@oss.sgi.com>; Tue, 22 Apr 2014 23:12:37 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	SjTIStehSUuiGWXR for <xfs@oss.sgi.com>;
	Tue, 22 Apr 2014 23:12:35 -0700 (PDT)
Date: Wed, 23 Apr 2014 16:12:33 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v3 13/20] xfsprogs/repair: account for finobt in ag 0
	geometry pre-calculation
Message-ID: <20140423061233.GN15995@dastard>
References: <1397146270-42993-1-git-send-email-bfoster@redhat.com>
	<1397146270-42993-14-git-send-email-bfoster@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1397146270-42993-14-git-send-email-bfoster@redhat.com>
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
To: Brian Foster <bfoster@redhat.com>
Cc: xfs@oss.sgi.com

On Thu, Apr 10, 2014 at 12:11:03PM -0400, Brian Foster wrote:
> Account for the finobt in calc_mkfs().
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> ---
>  repair/xfs_repair.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
> index 08b25f0..356125b 100644
> --- a/repair/xfs_repair.c
> +++ b/repair/xfs_repair.c
> @@ -407,6 +407,8 @@ calc_mkfs(xfs_mount_t *mp)
>  	bcntbt_root = bnobt_root + 1;
>  	inobt_root = bnobt_root + 2;
>  	fino_bno = inobt_root + XFS_MIN_FREELIST_RAW(1, 1, mp) + 1;
> +	if (xfs_sb_version_hasfinobt(&mp->m_sb))
> +		fino_bno++;

The comment about this code needs updating, too.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
