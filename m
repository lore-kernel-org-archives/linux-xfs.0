Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 15F437F3F
	for <xfs@oss.sgi.com>; Sat, 27 Jul 2013 13:00:43 -0500 (CDT)
Message-ID: <51F40ACA.40601@sgi.com>
Date: Sat, 27 Jul 2013 13:00:42 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 22/49] xfs: minor cleanups
References: <1374215120-7271-1-git-send-email-david@fromorbit.com>
	<1374215120-7271-23-git-send-email-david@fromorbit.com>
In-Reply-To: <1374215120-7271-23-git-send-email-david@fromorbit.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On 07/19/13 01:24, Dave Chinner wrote:
> From: Dave Chinner<dchinner@redhat.com>
>
> These come from syncing the shared userspace and kernel code. Small
> whitespace and trivial cleanups.
>
> Signed-off-by: Dave Chinner<dchinner@redhat.com>
> ---

okay, minor clean-ups

Don't understand the change from min_t to min:

> diff --git a/fs/xfs/xfs_attr_remote.c b/fs/xfs/xfs_attr_remote.c
> index 13a0ed9..b42926a 100644
> --- a/fs/xfs/xfs_attr_remote.c
> +++ b/fs/xfs/xfs_attr_remote.c
> @@ -251,7 +251,7 @@ xfs_attr_rmtval_copyout(
>   		int hdr_size = 0;
>   		int byte_cnt = XFS_ATTR3_RMT_BUF_SPACE(mp, XFS_LBSIZE(mp));
>
> -		byte_cnt = min_t(int, *valuelen, byte_cnt);
> +		byte_cnt = min(*valuelen, byte_cnt);
>
>   		if (xfs_sb_version_hascrc(&mp->m_sb)) {
>   			if (!xfs_attr3_rmt_hdr_ok(mp, src, ino, *offset,

but looks good:

Reviewed-by: Mark Tinguely <tinguely@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
