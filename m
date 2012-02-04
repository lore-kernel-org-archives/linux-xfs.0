Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q142h0MT179876 for <xfs@oss.sgi.com>; Fri, 3 Feb 2012 20:43:00 -0600
Received: from mail.sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com
	with ESMTP id AxqZhoQ3WjiO4pEP for <xfs@oss.sgi.com>;
	Fri, 03 Feb 2012 18:42:58 -0800 (PST)
Message-ID: <4F2C9B30.1030902@sandeen.net>
Date: Fri, 03 Feb 2012 20:42:56 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH 6/8] xfs: Use generic writers counter instead of
	m_active_trans counter
References: <1327091686-23177-1-git-send-email-jack@suse.cz>
	<1327091686-23177-7-git-send-email-jack@suse.cz>
In-Reply-To: <1327091686-23177-7-git-send-email-jack@suse.cz>
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
To: Jan Kara <jack@suse.cz>
Cc: Surbhi Palande <csurbhi@gmail.com>, Kamal Mostafa <kamal@canonical.com>, LKML <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, Dave Chinner <dchinner@redhat.com>, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org

On 1/20/12 2:34 PM, Jan Kara wrote:
> m_active_trans counter is racy wrt filesystem freezing. The patch replaces it
> with generic counter of running transactions which is properly synchronized
> with filesystem freezing. Things are a bit more complex because we need to log
> a dummy transaction and free block counters after the filesystem is frozen so
> we need to pass information to _xfs_trans_alloc() whether the transaction is
> part of filesystem freezing or not.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>
> ---

...

>  xfs_trans_t *
>  _xfs_trans_alloc(
>  	xfs_mount_t	*mp,
>  	uint		type,
> -	uint		memflags)
> +	uint		memflags,
> +	bool		freezing)
>  {
>  	xfs_trans_t	*tp;
>  
> -	atomic_inc(&mp->m_active_trans);
> -
> +	if (!freezing)
> +		sb_start_write(mp->m_super, SB_FREEZE_TRANS);
> +	else
> +		WARN_ON(xfs_test_for_freeze(mp) != SB_FREEZE_TRANS);

Hm this could be an issue because for both the umount path and the 
freeze / xfs_quiesce_attr path, we call xfs_log_sbcount which sends
"true" for freezing and we'll trip up here because we won't be
in SB_FREEZE_TRANS during umount.

I think we have to push the flag all the way up to xfs_log_sbcount
callers?

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
