Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 1C3477CA1
	for <xfs@oss.sgi.com>; Mon, 20 Jun 2016 05:42:03 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 953FFAC002
	for <xfs@oss.sgi.com>; Mon, 20 Jun 2016 03:41:59 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id SFHKyvBLFvP0D7Qf (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 20 Jun 2016 03:41:55 -0700 (PDT)
Received: from int-mx09.intmail.prod.int.phx2.redhat.com
	(int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mx1.redhat.com (Postfix) with ESMTPS id 76F5C46203
	for <xfs@oss.sgi.com>; Mon, 20 Jun 2016 10:41:54 +0000 (UTC)
Date: Mon, 20 Jun 2016 12:41:50 +0200
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH] xfs_copy: fix minor sparse endian nit
Message-ID: <20160620104150.GA28212@redhat.com>
References: <a51bba5e-01ba-d73b-6fe6-ac3a411c7283@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <a51bba5e-01ba-d73b-6fe6-ac3a411c7283@redhat.com>
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
To: Eric Sandeen <sandeen@redhat.com>
Cc: xfs-oss <xfs@oss.sgi.com>

On Fri, Jun 17, 2016 at 11:44:44AM -0500, Eric Sandeen wrote:
> The intermediate variable should not have been endian-annotated;
> it is the local cpu representation not the on-disk representation.
> 

Looks good, you can add:

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> diff --git a/copy/xfs_copy.c b/copy/xfs_copy.c
> index 2119a0b..1bc5163 100644
> --- a/copy/xfs_copy.c
> +++ b/copy/xfs_copy.c
> @@ -506,7 +506,7 @@ sb_update_uuid(
>  	 */
>  	if (!uuid_equal(&tcarg->uuid, &ag_hdr->xfs_sb->sb_uuid) &&
>  	    xfs_sb_version_hascrc(sb) && !xfs_sb_version_hasmetauuid(sb)) {
> -		__be32 feat;
> +		__uint32_t feat;
>  
>  		feat = be32_to_cpu(ag_hdr->xfs_sb->sb_features_incompat);
>  		feat |= XFS_SB_FEAT_INCOMPAT_META_UUID;
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

-- 
Carlos

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
