Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:41656 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751378AbdAMWsX (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 13 Jan 2017 17:48:23 -0500
Subject: Re: [PATCH] xfs: don't wrap ID in xfs_dq_get_next_id
References: <f52de68d-abe6-1960-c0ef-1d199346f689@redhat.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <2a34fb42-015a-a6b6-b4d7-6b75fb0c74b4@sandeen.net>
Date: Fri, 13 Jan 2017 16:48:22 -0600
MIME-Version: 1.0
In-Reply-To: <f52de68d-abe6-1960-c0ef-1d199346f689@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>, djwong@djwong.org

On 12/16/16 6:05 PM, Eric Sandeen wrote:
> The GETNEXTQOTA ioctl takes whatever ID is sent in,
> and looks for the next active quota for an user
> equal or higher to that ID.
> 
> But if we are at the maximum ID and then ask for the "next"
> one, we may wrap back to zero.  In this case, userspace
> may loop forever, because it will start querying again
> at zero.
> 
> We'll fix this in userspace as well, but for the kernel,
> return -ENOENT if we ask for the next quota ID
> past UINT_MAX so the caller knows to stop.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Ping on this?  sorry for not noticing its absence sooner.
Has rvb:hch on the thread.

-Eric

> ---
> 
> diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
> index 7a30b8f..dbeddd9 100644
> --- a/fs/xfs/xfs_dquot.c
> +++ b/fs/xfs/xfs_dquot.c
> @@ -710,6 +710,10 @@
>  	/* Simple advance */
>  	next_id = *id + 1;
>  
> +	/* If we'd wrap past the max ID, stop */
> +	if (next_id < *id)
> +		return -ENOENT;
> +
>  	/* If new ID is within the current chunk, advancing it sufficed */
>  	if (next_id % mp->m_quotainfo->qi_dqperchunk) {
>  		*id = next_id;
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
