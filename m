Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 62EFC7F54
	for <xfs@oss.sgi.com>; Thu,  6 Feb 2014 07:09:44 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 583708F8073
	for <xfs@oss.sgi.com>; Thu,  6 Feb 2014 05:09:41 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id Giycukp0q8rwcHG2 for
	<xfs@oss.sgi.com>; Thu, 06 Feb 2014 05:09:37 -0800 (PST)
Received: from int-mx10.intmail.prod.int.phx2.redhat.com
	(int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s16D9aao022284
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Thu, 6 Feb 2014 08:09:36 -0500
Received: from laptop.bfoster (vpn-62-13.rdu2.redhat.com [10.10.62.13])
	by int-mx10.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id s16D9Zcf015665
	(version=TLSv1/SSLv3 cipher=DHE-RSA-CAMELLIA256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Thu, 6 Feb 2014 08:09:36 -0500
Message-ID: <52F3898F.8020304@redhat.com>
Date: Thu, 06 Feb 2014 08:09:35 -0500
From: Brian Foster <bfoster@redhat.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs_db: fix attribute leaf output for ATTR3 format
References: <1391587365-5066-1-git-send-email-david@fromorbit.com>
In-Reply-To: <1391587365-5066-1-git-send-email-david@fromorbit.com>
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
To: xfs@oss.sgi.com

On 02/05/2014 03:02 AM, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> attr3_leaf_entries_count() checks against the wrong magic number.
> hence returns zero for an entry count when it should be returning a
> value. Fixing this makes xfs/021 pass on CRC enabled filesystems.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  db/attr.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/db/attr.c b/db/attr.c
> index 740d564..caa154e 100644
> --- a/db/attr.c
> +++ b/db/attr.c
> @@ -170,7 +170,7 @@ attr3_leaf_entries_count(
>  	struct xfs_attr3_leafblock *leaf = obj;
>  
>  	ASSERT(startoff == 0);
> -	if (be16_to_cpu(leaf->hdr.info.hdr.magic) != XFS_ATTR_LEAF_MAGIC)
> +	if (be16_to_cpu(leaf->hdr.info.hdr.magic) != XFS_ATTR3_LEAF_MAGIC)
>  		return 0;
>  	return be16_to_cpu(leaf->hdr.count);
>  }
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
