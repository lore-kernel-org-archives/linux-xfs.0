Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:18055 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753124AbdGNQib (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 14 Jul 2017 12:38:31 -0400
Date: Fri, 14 Jul 2017 09:38:28 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] xfs_db: associate proper type with free inode btree root
Message-ID: <20170714163828.GA4224@magnolia>
References: <e6056fa4-40c5-26ab-60f0-8d09d42010ce@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e6056fa4-40c5-26ab-60f0-8d09d42010ce@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>

On Fri, Jul 14, 2017 at 10:52:20AM -0500, Eric Sandeen wrote:
> When navigating to the free inode btree root, the wrong type
> is set:
> 
> xfs_db> agi 0
> xfs_db> addr free_root
> xfs_db> type
> current type is "inobt"
> 
> Change this to type finobt / TYP_FINOBT
> 
> (There seems to be no actual difference, but if we have an explicit type
> name for the free inode btree, we should use it as appropriate)
> 

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> diff --git a/db/agi.c b/db/agi.c
> index 285a3c5..fb69210 100644
> --- a/db/agi.c
> +++ b/db/agi.c
> @@ -57,7 +57,7 @@ const field_t	agi_flds[] = {
>  	{ "uuid", FLDT_UUID, OI(OFF(uuid)), C1, 0, TYP_NONE },
>  	{ "lsn", FLDT_UINT64X, OI(OFF(lsn)), C1, 0, TYP_NONE },
>  	{ "crc", FLDT_CRC, OI(OFF(crc)), C1, 0, TYP_NONE },
> -	{ "free_root", FLDT_AGBLOCK, OI(OFF(free_root)), C1, 0, TYP_INOBT },
> +	{ "free_root", FLDT_AGBLOCK, OI(OFF(free_root)), C1, 0, TYP_FINOBT },
>  	{ "free_level", FLDT_UINT32D, OI(OFF(free_level)), C1, 0, TYP_NONE },
>  	{ NULL }
>  };
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
