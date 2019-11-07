Return-Path: <SRS0=aC/G=Y7=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23EC2FA372C
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Nov 2019 01:08:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DD67B2166E
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Nov 2019 01:08:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Hh1nafxH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728171AbfKGBIH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 6 Nov 2019 20:08:07 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:47742 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727646AbfKGBIH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 6 Nov 2019 20:08:07 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA70xE0f148848;
        Thu, 7 Nov 2019 01:08:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=eVMpV8ENQFfb0g8iVWF7NpQSA0yJhVe5jcLL3457fAg=;
 b=Hh1nafxHJFMSIKfFjRJKezVoc0xQSZwnRwAU/Q0ZFFCRr/OC280riuSJ/B3gcZoAr/rS
 adxCyZOAyu2tWxDxycr0zTaUySfQCA8KC14lVWB6etGvI/K9n2J2Ge2rUOY2dCtd7aX2
 XbtjnKttdT7kuHG9/zUGayKCMJB/NDpCrfrdo6+2QPQTUwAdKzM3Vibh66ulXOy5YxML
 5VCZN/cFxnYh8d05wArCv7qny1BOLujiXq7yrop+fhwRHQmjg8tOZEGJJl2vvVQz93qh
 w14pJnEs6KusgtJX7YxjlDeQ7lu99lI+IIBP0i22gd4uC00bCx1QQ62tPxMQiV/WDgz9 9A== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2w41w0tmw7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 07 Nov 2019 01:08:00 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA70x97w030656;
        Thu, 7 Nov 2019 01:05:59 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 2w41wfbkh4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 07 Nov 2019 01:05:59 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xA715uOl028088;
        Thu, 7 Nov 2019 01:05:56 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 06 Nov 2019 17:05:56 -0800
Date:   Wed, 6 Nov 2019 17:05:55 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 21/34] xfs: devirtualize ->sf_get_ino and ->sf_put_ino
Message-ID: <20191107010555.GT4153244@magnolia>
References: <20191101220719.29100-1-hch@lst.de>
 <20191101220719.29100-22-hch@lst.de>
 <20191104203334.GW4153244@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191104203334.GW4153244@magnolia>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9433 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1910280000 definitions=main-1911070009
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9433 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1910280000
 definitions=main-1911070009
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Nov 04, 2019 at 12:33:34PM -0800, Darrick J. Wong wrote:
> On Fri, Nov 01, 2019 at 03:07:06PM -0700, Christoph Hellwig wrote:
> > Replace the ->sf_get_ino and ->sf_put_ino dir ops methods with directly
> > called xfs_dir2_sf_get_ino nd xfs_dir2_sf_put_ino helpers that take care
> 
>                             ^^^ "and"
> 
> > of the difference between the directory format with and without the file
> > type field.  Also move xfs_dir2_sf_get_parent_ino and
> > xfs_dir2_sf_put_parent_ino to xfs_dir2_sf.c with the rest of the
> > low-level short form entry handling.
> > 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Looks ok, except...
> 
> <snip>
> 
> > diff --git a/fs/xfs/libxfs/xfs_dir2_sf.c b/fs/xfs/libxfs/xfs_dir2_sf.c
> > index f3a4f0ddfc1a..c33d838b1a5c 100644
> > --- a/fs/xfs/libxfs/xfs_dir2_sf.c
> > +++ b/fs/xfs/libxfs/xfs_dir2_sf.c
> > @@ -63,6 +63,69 @@ xfs_dir2_sf_nextentry(
> >  		((char *)sfep + xfs_dir2_sf_entsize(mp, hdr, sfep->namelen));
> >  }
> >  
> > +/*
> > + * In short-form directory entries the inode numbers are stored at variable
> > + * offset behind the entry name. If the entry stores a filetype value, then it
> > + * sits between the name and the inode number.  The actual inode numbers can
> > + * come in two formats as well, either 4 bytes or 8 bytes wide.
> > + */
> > +xfs_ino_t
> > +xfs_dir2_sf_get_ino(
> > +	struct xfs_mount		*mp,
> > +	struct xfs_dir2_sf_hdr		*hdr,
> > +	struct xfs_dir2_sf_entry	*sfep)
> > +{
> > +	uint8_t				*from = sfep->name + sfep->namelen;
> > +
> > +	if (xfs_sb_version_hasftype(&mp->m_sb))
> > +		from++;
> > +
> > +	if (!hdr->i8count)
> > +		return get_unaligned_be32(from);
> > +	return get_unaligned_be64(from) & 0x00ffffffffffffffULL;
> 
> ...maybe we ought to convert this to use XFS_MAXINUMBER instead of
> encoding magic numbers?
> 
> > +}
> > +
> > +void
> > +xfs_dir2_sf_put_ino(

Also, I think these helpers can be static now...

--D

> > +	struct xfs_mount		*mp,
> > +	struct xfs_dir2_sf_hdr		*hdr,
> > +	struct xfs_dir2_sf_entry	*sfep,
> > +	xfs_ino_t			ino)
> > +{
> > +	uint8_t				*to = sfep->name + sfep->namelen;
> > +
> > +	ASSERT((ino & 0xff00000000000000ULL) == 0);
> 
> Same here...
> 
> > +	if (xfs_sb_version_hasftype(&mp->m_sb))
> > +		to++;
> > +
> > +	if (hdr->i8count)
> > +		put_unaligned_be64(ino, to);
> > +	else
> > +		put_unaligned_be32(ino, to);
> > +}
> > +
> > +xfs_ino_t
> > +xfs_dir2_sf_get_parent_ino(
> > +	struct xfs_dir2_sf_hdr	*hdr)
> > +{
> > +	if (!hdr->i8count)
> > +		return get_unaligned_be32(hdr->parent);
> > +	return get_unaligned_be64(hdr->parent) & 0x00ffffffffffffffULL;
> 
> And here...
> 
> > +}
> > +
> > +void
> > +xfs_dir2_sf_put_parent_ino(
> > +	struct xfs_dir2_sf_hdr		*hdr,
> > +	xfs_ino_t			ino)
> > +{
> > +	ASSERT((ino & 0xff00000000000000ULL) == 0);
> 
> And here?
> 
> --D
> 
> > +	if (hdr->i8count)
> > +		put_unaligned_be64(ino, hdr->parent);
> > +	else
> > +		put_unaligned_be32(ino, hdr->parent);
> > +}
> > +
> >  /*
> >   * Given a block directory (dp/block), calculate its size as a shortform (sf)
> >   * directory and a header for the sf directory, if it will fit it the
> > @@ -240,7 +303,7 @@ xfs_dir2_block_to_sf(
> >  				(xfs_dir2_data_aoff_t)
> >  				((char *)dep - (char *)hdr));
> >  			memcpy(sfep->name, dep->name, dep->namelen);
> > -			dp->d_ops->sf_put_ino(sfp, sfep,
> > +			xfs_dir2_sf_put_ino(mp, sfp, sfep,
> >  					      be64_to_cpu(dep->inumber));
> >  			dp->d_ops->sf_put_ftype(sfep,
> >  					dp->d_ops->data_get_ftype(dep));
> > @@ -413,7 +476,7 @@ xfs_dir2_sf_addname_easy(
> >  	sfep->namelen = args->namelen;
> >  	xfs_dir2_sf_put_offset(sfep, offset);
> >  	memcpy(sfep->name, args->name, sfep->namelen);
> > -	dp->d_ops->sf_put_ino(sfp, sfep, args->inumber);
> > +	xfs_dir2_sf_put_ino(mp, sfp, sfep, args->inumber);
> >  	dp->d_ops->sf_put_ftype(sfep, args->filetype);
> >  
> >  	/*
> > @@ -503,7 +566,7 @@ xfs_dir2_sf_addname_hard(
> >  	sfep->namelen = args->namelen;
> >  	xfs_dir2_sf_put_offset(sfep, offset);
> >  	memcpy(sfep->name, args->name, sfep->namelen);
> > -	dp->d_ops->sf_put_ino(sfp, sfep, args->inumber);
> > +	xfs_dir2_sf_put_ino(mp, sfp, sfep, args->inumber);
> >  	dp->d_ops->sf_put_ftype(sfep, args->filetype);
> >  	sfp->count++;
> >  	if (args->inumber > XFS_DIR2_MAX_SHORT_INUM && !objchange)
> > @@ -620,7 +683,7 @@ xfs_dir2_sf_check(
> >  	     i < sfp->count;
> >  	     i++, sfep = xfs_dir2_sf_nextentry(dp->i_mount, sfp, sfep)) {
> >  		ASSERT(xfs_dir2_sf_get_offset(sfep) >= offset);
> > -		ino = dp->d_ops->sf_get_ino(sfp, sfep);
> > +		ino = xfs_dir2_sf_get_ino(dp->i_mount, sfp, sfep);
> >  		i8count += ino > XFS_DIR2_MAX_SHORT_INUM;
> >  		offset =
> >  			xfs_dir2_sf_get_offset(sfep) +
> > @@ -712,7 +775,7 @@ xfs_dir2_sf_verify(
> >  			return __this_address;
> >  
> >  		/* Check the inode number. */
> > -		ino = dops->sf_get_ino(sfp, sfep);
> > +		ino = xfs_dir2_sf_get_ino(mp, sfp, sfep);
> >  		i8count += ino > XFS_DIR2_MAX_SHORT_INUM;
> >  		error = xfs_dir_ino_validate(mp, ino);
> >  		if (error)
> > @@ -861,7 +924,7 @@ xfs_dir2_sf_lookup(
> >  								sfep->namelen);
> >  		if (cmp != XFS_CMP_DIFFERENT && cmp != args->cmpresult) {
> >  			args->cmpresult = cmp;
> > -			args->inumber = dp->d_ops->sf_get_ino(sfp, sfep);
> > +			args->inumber = xfs_dir2_sf_get_ino(mp, sfp, sfep);
> >  			args->filetype = dp->d_ops->sf_get_ftype(sfep);
> >  			if (cmp == XFS_CMP_EXACT)
> >  				return -EEXIST;
> > @@ -920,7 +983,7 @@ xfs_dir2_sf_removename(
> >  	     i++, sfep = xfs_dir2_sf_nextentry(mp, sfp, sfep)) {
> >  		if (xfs_da_compname(args, sfep->name, sfep->namelen) ==
> >  								XFS_CMP_EXACT) {
> > -			ASSERT(dp->d_ops->sf_get_ino(sfp, sfep) ==
> > +			ASSERT(xfs_dir2_sf_get_ino(mp, sfp, sfep) ==
> >  			       args->inumber);
> >  			break;
> >  		}
> > @@ -1041,9 +1104,10 @@ xfs_dir2_sf_replace(
> >  		     i++, sfep = xfs_dir2_sf_nextentry(mp, sfp, sfep)) {
> >  			if (xfs_da_compname(args, sfep->name, sfep->namelen) ==
> >  								XFS_CMP_EXACT) {
> > -				ino = dp->d_ops->sf_get_ino(sfp, sfep);
> > +				ino = xfs_dir2_sf_get_ino(mp, sfp, sfep);
> >  				ASSERT(args->inumber != ino);
> > -				dp->d_ops->sf_put_ino(sfp, sfep, args->inumber);
> > +				xfs_dir2_sf_put_ino(mp, sfp, sfep,
> > +						args->inumber);
> >  				dp->d_ops->sf_put_ftype(sfep, args->filetype);
> >  				break;
> >  			}
> > @@ -1148,8 +1212,8 @@ xfs_dir2_sf_toino4(
> >  		sfep->namelen = oldsfep->namelen;
> >  		memcpy(sfep->offset, oldsfep->offset, sizeof(sfep->offset));
> >  		memcpy(sfep->name, oldsfep->name, sfep->namelen);
> > -		dp->d_ops->sf_put_ino(sfp, sfep,
> > -				      dp->d_ops->sf_get_ino(oldsfp, oldsfep));
> > +		xfs_dir2_sf_put_ino(mp, sfp, sfep,
> > +				xfs_dir2_sf_get_ino(mp, oldsfp, oldsfep));
> >  		dp->d_ops->sf_put_ftype(sfep, dp->d_ops->sf_get_ftype(oldsfep));
> >  	}
> >  	/*
> > @@ -1220,8 +1284,8 @@ xfs_dir2_sf_toino8(
> >  		sfep->namelen = oldsfep->namelen;
> >  		memcpy(sfep->offset, oldsfep->offset, sizeof(sfep->offset));
> >  		memcpy(sfep->name, oldsfep->name, sfep->namelen);
> > -		dp->d_ops->sf_put_ino(sfp, sfep,
> > -				      dp->d_ops->sf_get_ino(oldsfp, oldsfep));
> > +		xfs_dir2_sf_put_ino(mp, sfp, sfep,
> > +				xfs_dir2_sf_get_ino(mp, oldsfp, oldsfep));
> >  		dp->d_ops->sf_put_ftype(sfep, dp->d_ops->sf_get_ftype(oldsfep));
> >  	}
> >  	/*
> > diff --git a/fs/xfs/xfs_dir2_readdir.c b/fs/xfs/xfs_dir2_readdir.c
> > index 7d150e914d00..9d318f091a73 100644
> > --- a/fs/xfs/xfs_dir2_readdir.c
> > +++ b/fs/xfs/xfs_dir2_readdir.c
> > @@ -114,7 +114,7 @@ xfs_dir2_sf_getdents(
> >  			continue;
> >  		}
> >  
> > -		ino = dp->d_ops->sf_get_ino(sfp, sfep);
> > +		ino = xfs_dir2_sf_get_ino(mp, sfp, sfep);
> >  		filetype = dp->d_ops->sf_get_ftype(sfep);
> >  		ctx->pos = off & 0x7fffffff;
> >  		if (!xfs_dir2_namecheck(sfep->name, sfep->namelen)) {
> > -- 
> > 2.20.1
> > 
