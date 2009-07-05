Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n65KKg0K047328 for <xfs@oss.sgi.com>; Sun, 5 Jul 2009 15:20:42 -0500
Received: from estes.americas.sgi.com (estes.americas.sgi.com [128.162.236.10])
	by relay1.corp.sgi.com (Postfix) with ESMTP id A983A8F8035
	for <xfs@oss.sgi.com>; Sun,  5 Jul 2009 13:21:13 -0700 (PDT)
Message-Id: <AB0A491A-6253-47A7-8E3D-DA6D05390F3A@sgi.com>
From: Felix Blyakher <felixb@sgi.com>
In-Reply-To: <4A50E197.3070209@sandeen.net>
Mime-Version: 1.0 (Apple Message framework v930.3)
Subject: Re: [PATCH (trivial)] remove XFS_INO64_OFFSET
Date: Sun, 5 Jul 2009 15:21:11 -0500
References: <4A50E197.3070209@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs-oss <xfs@oss.sgi.com>


On Jul 5, 2009, at 12:23 PM, Eric Sandeen wrote:

> Commit a19d9f887d81106d52cacbc9930207b487e07e0e removed the
> ino64 option but left the XFS_INO64_OFFSET define it used
> in place - just remove it.
>
> Signed-off-by: Eric Sandeen <sandeen@sandeen.net>

Reviewed-by: Felix Blyakher <felixb@sgi.com>

>
> ---
>
> diff --git a/fs/xfs/xfs_inum.h b/fs/xfs/xfs_inum.h
> index 7a28191..b8e4ee4 100644
> --- a/fs/xfs/xfs_inum.h
> +++ b/fs/xfs/xfs_inum.h
> @@ -72,7 +72,6 @@ struct xfs_mount;
>
> #if XFS_BIG_INUMS
> #define	XFS_MAXINUMBER		((xfs_ino_t)((1ULL << 56) - 1ULL))
> -#define	XFS_INO64_OFFSET	((xfs_ino_t)(1ULL << 32))
> #else
> #define	XFS_MAXINUMBER		((xfs_ino_t)((1ULL << 32) - 1ULL))
> #endif
>
>
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
