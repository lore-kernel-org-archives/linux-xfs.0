Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 594E67F4E
	for <xfs@oss.sgi.com>; Sun, 30 Jun 2013 21:06:41 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id E7046AC003
	for <xfs@oss.sgi.com>; Sun, 30 Jun 2013 19:06:37 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	TvEeRPFXOB5bM8G5 for <xfs@oss.sgi.com>;
	Sun, 30 Jun 2013 19:06:36 -0700 (PDT)
Date: Mon, 1 Jul 2013 12:06:34 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v10 09/11] xfs: Start using pquotaino from the superblock.
Message-ID: <20130701020634.GE27780@dastard>
References: <1372371914-11370-1-git-send-email-sekharan@us.ibm.com>
	<1372371914-11370-10-git-send-email-sekharan@us.ibm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1372371914-11370-10-git-send-email-sekharan@us.ibm.com>
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
To: Chandra Seetharaman <sekharan@us.ibm.com>
Cc: xfs@oss.sgi.com

On Thu, Jun 27, 2013 at 05:25:12PM -0500, Chandra Seetharaman wrote:
> Start using pquotino and define a macro to check if the
> superblock has pquotino.
> 
> Keep backward compatibilty by alowing mount of older superblock
> with no separate pquota inode.
> 
> Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>

This is unchanged from the previous version, so all of my review
comments from here:

http://oss.sgi.com/pipermail/xfs/2013-June/027637.html

are still unaddressed.

Also:

> @@ -885,6 +905,18 @@ reread:
>  	 */
>  	xfs_sb_from_disk(&mp->m_sb, XFS_BUF_TO_SBP(bp));
>  
> +	if (!xfs_sb_version_has_pquota(&mp->m_sb) && (XFS_IS_PQUOTA_ON(mp))) {
> +		/*
> +		 * On disk superblock only has sb_gquotino, and incore
> +		 * superblock has both sb_gquotino and sb_pquotino.
> +		 * But, only one them is supported at any point of time.
> +		 * So, if PQUOTA is set in disk superblock, copy over
> +		 * sb_gquotino to sb_pquotino.
> +		 */
> +		mp->m_sb.sb_pquotino = mp->m_sb.sb_gquotino;
> +		mp->m_sb.sb_gquotino = NULLFSINO;
> +	}
> +
>  	xfs_sb_quota_from_disk(&mp->m_sb);

This code should be inside xfs_sb_quota_from_disk()....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
