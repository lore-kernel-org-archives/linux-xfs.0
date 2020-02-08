Return-Path: <SRS0=5CkV=34=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B100CC35250
	for <linux-xfs@archiver.kernel.org>; Sat,  8 Feb 2020 12:45:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 873BE217BA
	for <linux-xfs@archiver.kernel.org>; Sat,  8 Feb 2020 12:45:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727131AbgBHMpu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 8 Feb 2020 07:45:50 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:39012 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727118AbgBHMpu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 8 Feb 2020 07:45:50 -0500
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 018CceKn129954
        for <linux-xfs@vger.kernel.org>; Sat, 8 Feb 2020 07:45:49 -0500
Received: from e06smtp04.uk.ibm.com (e06smtp04.uk.ibm.com [195.75.94.100])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2y1tp9m3v3-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-xfs@vger.kernel.org>; Sat, 08 Feb 2020 07:45:49 -0500
Received: from localhost
        by e06smtp04.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-xfs@vger.kernel.org> from <chandan@linux.ibm.com>;
        Sat, 8 Feb 2020 12:45:47 -0000
Received: from b06cxnps4075.portsmouth.uk.ibm.com (9.149.109.197)
        by e06smtp04.uk.ibm.com (192.168.101.134) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Sat, 8 Feb 2020 12:45:45 -0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 018Cjikj51970224
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 8 Feb 2020 12:45:44 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 73F164C040;
        Sat,  8 Feb 2020 12:45:44 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4D67C4C04A;
        Sat,  8 Feb 2020 12:45:43 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.85.68.130])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Sat,  8 Feb 2020 12:45:43 +0000 (GMT)
From:   Chandan Rajendra <chandan@linux.ibm.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org,
        Allison Collins <allison.henderson@oracle.com>,
        "Darrick J . Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 17/30] xfs: factor out a xfs_attr_match helper
Date:   Sat, 08 Feb 2020 18:18:29 +0530
Organization: IBM
In-Reply-To: <20200129170310.51370-18-hch@lst.de>
References: <20200129170310.51370-1-hch@lst.de> <20200129170310.51370-18-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-TM-AS-GCONF: 00
x-cbid: 20020812-0016-0000-0000-000002E4F7A0
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20020812-0017-0000-0000-00003347E45C
Message-Id: <1773489.ADBAkTHOFr@localhost.localdomain>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-08_02:2020-02-07,2020-02-08 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 spamscore=0 impostorscore=0 lowpriorityscore=0 malwarescore=0 bulkscore=0
 clxscore=1015 mlxlogscore=999 mlxscore=0 suspectscore=1 adultscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002080100
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wednesday, January 29, 2020 10:32 PM Christoph Hellwig wrote: 
> Factor out a helper that compares an on-disk attr vs the name, length and
> flags specified in struct xfs_da_args.
>

The newly introduced changes logically match with the code flow that existed
earlier.

Reviewed-by: Chandan Rajendra <chandanrlinux@gmail.com>

> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_attr_leaf.c | 80 +++++++++++++----------------------
>  1 file changed, 30 insertions(+), 50 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
> index b0658eb8fbcc..8852754153ba 100644
> --- a/fs/xfs/libxfs/xfs_attr_leaf.c
> +++ b/fs/xfs/libxfs/xfs_attr_leaf.c
> @@ -445,14 +445,21 @@ xfs_attr3_leaf_read(
>   * Namespace helper routines
>   *========================================================================*/
> 
> -/*
> - * If namespace bits don't match return 0.
> - * If all match then return 1.
> - */
> -STATIC int
> -xfs_attr_namesp_match(int arg_flags, int ondisk_flags)
> +static bool
> +xfs_attr_match(
> +	struct xfs_da_args	*args,
> +	uint8_t			namelen,
> +	unsigned char		*name,
> +	int			flags)
>  {
> -	return XFS_ATTR_NSP_ONDISK(ondisk_flags) == XFS_ATTR_NSP_ARGS_TO_ONDISK(arg_flags);
> +	if (args->namelen != namelen)
> +		return false;
> +	if (memcmp(args->name, name, namelen) != 0)
> +		return false;
> +	if (XFS_ATTR_NSP_ARGS_TO_ONDISK(args->flags) !=
> +	    XFS_ATTR_NSP_ONDISK(flags))
> +		return false;
> +	return true;
>  }
> 
>  static int
> @@ -678,15 +685,8 @@ xfs_attr_shortform_add(xfs_da_args_t *args, int forkoff)
>  	sf = (xfs_attr_shortform_t *)ifp->if_u1.if_data;
>  	sfe = &sf->list[0];
>  	for (i = 0; i < sf->hdr.count; sfe = XFS_ATTR_SF_NEXTENTRY(sfe), i++) {
> -#ifdef DEBUG
> -		if (sfe->namelen != args->namelen)
> -			continue;
> -		if (memcmp(args->name, sfe->nameval, args->namelen) != 0)
> -			continue;
> -		if (!xfs_attr_namesp_match(args->flags, sfe->flags))
> -			continue;
> -		ASSERT(0);
> -#endif
> +		ASSERT(!xfs_attr_match(args, sfe->namelen, sfe->nameval,
> +			sfe->flags));
>  	}
> 
>  	offset = (char *)sfe - (char *)sf;
> @@ -749,13 +749,9 @@ xfs_attr_shortform_remove(xfs_da_args_t *args)
>  	for (i = 0; i < end; sfe = XFS_ATTR_SF_NEXTENTRY(sfe),
>  					base += size, i++) {
>  		size = XFS_ATTR_SF_ENTSIZE(sfe);
> -		if (sfe->namelen != args->namelen)
> -			continue;
> -		if (memcmp(sfe->nameval, args->name, args->namelen) != 0)
> -			continue;
> -		if (!xfs_attr_namesp_match(args->flags, sfe->flags))
> -			continue;
> -		break;
> +		if (xfs_attr_match(args, sfe->namelen, sfe->nameval,
> +				sfe->flags))
> +			break;
>  	}
>  	if (i == end)
>  		return -ENOATTR;
> @@ -816,13 +812,9 @@ xfs_attr_shortform_lookup(xfs_da_args_t *args)
>  	sfe = &sf->list[0];
>  	for (i = 0; i < sf->hdr.count;
>  				sfe = XFS_ATTR_SF_NEXTENTRY(sfe), i++) {
> -		if (sfe->namelen != args->namelen)
> -			continue;
> -		if (memcmp(args->name, sfe->nameval, args->namelen) != 0)
> -			continue;
> -		if (!xfs_attr_namesp_match(args->flags, sfe->flags))
> -			continue;
> -		return -EEXIST;
> +		if (xfs_attr_match(args, sfe->namelen, sfe->nameval,
> +				sfe->flags))
> +			return -EEXIST;
>  	}
>  	return -ENOATTR;
>  }
> @@ -847,14 +839,10 @@ xfs_attr_shortform_getvalue(
>  	sfe = &sf->list[0];
>  	for (i = 0; i < sf->hdr.count;
>  				sfe = XFS_ATTR_SF_NEXTENTRY(sfe), i++) {
> -		if (sfe->namelen != args->namelen)
> -			continue;
> -		if (memcmp(args->name, sfe->nameval, args->namelen) != 0)
> -			continue;
> -		if (!xfs_attr_namesp_match(args->flags, sfe->flags))
> -			continue;
> -		return xfs_attr_copy_value(args, &sfe->nameval[args->namelen],
> -						sfe->valuelen);
> +		if (xfs_attr_match(args, sfe->namelen, sfe->nameval,
> +				sfe->flags))
> +			return xfs_attr_copy_value(args,
> +				&sfe->nameval[args->namelen], sfe->valuelen);
>  	}
>  	return -ENOATTR;
>  }
> @@ -2409,23 +2397,15 @@ xfs_attr3_leaf_lookup_int(
>  		}
>  		if (entry->flags & XFS_ATTR_LOCAL) {
>  			name_loc = xfs_attr3_leaf_name_local(leaf, probe);
> -			if (name_loc->namelen != args->namelen)
> -				continue;
> -			if (memcmp(args->name, name_loc->nameval,
> -							args->namelen) != 0)
> -				continue;
> -			if (!xfs_attr_namesp_match(args->flags, entry->flags))
> +			if (!xfs_attr_match(args, name_loc->namelen,
> +					name_loc->nameval, entry->flags))
>  				continue;
>  			args->index = probe;
>  			return -EEXIST;
>  		} else {
>  			name_rmt = xfs_attr3_leaf_name_remote(leaf, probe);
> -			if (name_rmt->namelen != args->namelen)
> -				continue;
> -			if (memcmp(args->name, name_rmt->name,
> -							args->namelen) != 0)
> -				continue;
> -			if (!xfs_attr_namesp_match(args->flags, entry->flags))
> +			if (!xfs_attr_match(args, name_rmt->namelen,
> +					name_rmt->name, entry->flags))
>  				continue;
>  			args->index = probe;
>  			args->rmtvaluelen = be32_to_cpu(name_rmt->valuelen);
> 


-- 
chandan



