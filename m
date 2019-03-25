Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39411 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725747AbfCYOzT (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 25 Mar 2019 10:55:19 -0400
Reply-To: sandeen@redhat.com
Subject: Re: [PATCH] xfs: prohibit fstrim in norecovery mode
References: <20190323003720.GQ1183@magnolia>
From: Eric Sandeen <esandeen@redhat.com>
Message-ID: <3fa32770-f55d-514e-a969-7d7a0b64df5b@redhat.com>
Date: Mon, 25 Mar 2019 09:55:17 -0500
MIME-Version: 1.0
In-Reply-To: <20190323003720.GQ1183@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, xfs <linux-xfs@vger.kernel.org>
Cc: fstests <fstests@vger.kernel.org>, Eryu Guan <guaneryu@gmail.com>, linux-ext4 <linux-ext4@vger.kernel.org>

On 3/22/19 7:37 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> The xfs fstrim implementation uses the free space btrees to find free
> space that can be discarded.  If we haven't recovered the log, the bnobt
> will be stale and we absolutely *cannot* use stale metadata to zap the
> underlying storage.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/xfs_discard.c |    8 ++++++++
>  1 file changed, 8 insertions(+)

Yikes...

Looks good to me (I briefly thought about a norecovery mount with a clean log,
but then decided I didn't care about that)

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> diff --git a/fs/xfs/xfs_discard.c b/fs/xfs/xfs_discard.c
> index 93f07edafd81..9ee2a7d02e70 100644
> --- a/fs/xfs/xfs_discard.c
> +++ b/fs/xfs/xfs_discard.c
> @@ -161,6 +161,14 @@ xfs_ioc_trim(
>  		return -EPERM;
>  	if (!blk_queue_discard(q))
>  		return -EOPNOTSUPP;
> +
> +	/*
> +	 * We haven't recovered the log, so we cannot use our bnobt-guided
> +	 * storage zapping commands.
> +	 */
> +	if (mp->m_flags & XFS_MOUNT_NORECOVERY)
> +		return -EROFS;
> +
>  	if (copy_from_user(&range, urange, sizeof(range)))
>  		return -EFAULT;
>  
> 
