Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 15 Oct 2007 22:13:19 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with SMTP id l9G5D9xi020257
	for <xfs@oss.sgi.com>; Mon, 15 Oct 2007 22:13:13 -0700
Message-ID: <4714498A.8090902@sgi.com>
Date: Tue, 16 Oct 2007 15:18:02 +1000
From: Lachlan McIlroy <lachlan@sgi.com>
Reply-To: lachlan@sgi.com
MIME-Version: 1.0
Subject: Re: Review: Fix dbflush panic in xfs_qm_sync
References: <4713F7D3.2090201@sgi.com>
In-Reply-To: <4713F7D3.2090201@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Donald Douwsma <donaldd@sgi.com>
Cc: xfs-oss <xfs@oss.sgi.com>

Could mp->m_quotainfo become NULL after this check but before we
lock the list with xfs_qm_mplist_lock()?  There doesn't seem to
be any locking to protect changes to this field?

Donald Douwsma wrote:
> The recent behaviour layer removal dropped the check for quotas that 
> have been
> requested at mount time but have subsequently been turned off. This results
> in a panic when accessing m_quotainfo which has been freed.
> 
> This patch adds the check originally made by xfs_qm_syncall() to 
> xfs_qm_sync()
> 
> 
> Signed-off-by: Donald Douwsma <donaldd@sgi.com>
> 
> --- 2.6.x-xfs.orig/fs/xfs/quota/xfs_qm.c
> +++ 2.6.x-xfs/fs/xfs/quota/xfs_qm.c
> @@ -1007,6 +1007,9 @@ xfs_qm_sync(
>      boolean_t    nowait;
>      int        error;
> 
> +    if (! XFS_IS_QUOTA_ON(mp))
> +        return 0;
> +
>      restarts = 0;
>      /*
>       * We won't block unless we are asked to.
> 
> 
> 
