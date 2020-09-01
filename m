Return-Path: <SRS0=ZxTw=CK=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5DD46C433E6
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Sep 2020 16:55:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2D1D3207D3
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Sep 2020 16:55:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="hcmPXvjc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729785AbgIAQzU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 1 Sep 2020 12:55:20 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:38732 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729875AbgIAPYB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 1 Sep 2020 11:24:01 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 081FK6v0114232;
        Tue, 1 Sep 2020 15:23:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=JGy3GYbxInrxU0/MA3jBWR7QwwLBjuB+Wi6STJ95QhY=;
 b=hcmPXvjcrjqZwyoTms2PsiWmMiYwZY2Zd7BvGwjAdcGpfijoVxRM2JvlSECPkxe5EuF3
 4OYha5SCBuMGc001l3GFLRgVqdVlMYEYQiyJRruxwdDkMfMXV+bcRDzGuHdlCLlb+MMy
 cqyK2WhaO5p2kxoUUkOp51BahqylyKYzNLzI5Jp2g1HcdjoNNnbJtAXtzLeqm3qpCRGG
 MALBpf7erFPqxzh4wuAh2sl16jUyXbEcWKR0AMW+jh6ESH/OgJ0oNzRUQq6fN7Sh8nBl
 t56iYGhuwBzPnnZBiTbx9Cg+1D7FJ112plhb4Oz3bdb7VFj1aO6DTLVf54A7/KItbdva AQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 337eym4yaa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 01 Sep 2020 15:23:57 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 081FL2pN020396;
        Tue, 1 Sep 2020 15:23:56 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 3380srxgrw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 01 Sep 2020 15:23:56 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 081FNtwP031291;
        Tue, 1 Sep 2020 15:23:55 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 01 Sep 2020 08:23:55 -0700
Date:   Tue, 1 Sep 2020 08:23:59 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     Carlos Maiolino <cmaiolino@redhat.com>, linux-xfs@vger.kernel.org
Subject: Re: [RFC PATCH] xfs: add inline helper to convert from data fork to
 xfs_attr_shortform
Message-ID: <20200901152359.GD6096@magnolia>
References: <20200901095919.238598-1-cmaiolino@redhat.com>
 <20200901141341.GB174813@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200901141341.GB174813@bfoster>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9731 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 phishscore=0 malwarescore=0 mlxscore=0 spamscore=0 bulkscore=0
 suspectscore=1 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009010126
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9731 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 adultscore=0
 priorityscore=1501 phishscore=0 mlxlogscore=999 mlxscore=0
 lowpriorityscore=0 clxscore=1015 spamscore=0 bulkscore=0 impostorscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009010126
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Sep 01, 2020 at 10:13:41AM -0400, Brian Foster wrote:
> On Tue, Sep 01, 2020 at 11:59:19AM +0200, Carlos Maiolino wrote:
> > Hi folks, while working on the attr structs cleanup, I've noticed there
> > are so many places where we do:
> > 
> > (struct xfs_attr_shortform *)dp->i_afp->if_u1.if_data;
> > 
> > So, I thought it would be worth to add another inline function to do
> > this conversion and remove all these casts.
> > 
> > To achieve this, it will be required to include xfs_inode.h header on
> > xfs_attr_sf.h, so it can access the xfs_inode definition. Also, if this
> > patch is an acceptable idea, it will make sense then to keep the
> > xfs_attr_sf_totsize() function also inside xfs_attr_sf.h (which has been
> > moved on my series to avoid the additional #include), so, I thought on
> > sending this RFC patch to get comments if it's a good idea or not, and,
> > if it is, I'll add this patch to my series before sending it over.
> > 
> > I didn't focus on check if this patch is totally correct (only build
> > test), since my idea is to gather you guys opinions about having this
> > new inline function, so don't bother on reviewing the patch itself by
> > now, only the function name if you guys prefer some other name.
> > 
> > Also, this patch is build on top of my clean up series (V2), not yet
> > sent to the list, so it won't apply anyway.
> > 
> > Cheers.
> > 
> > Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
> > ---
> >  fs/xfs/libxfs/xfs_attr.c      |  4 ++--
> >  fs/xfs/libxfs/xfs_attr_leaf.c | 16 ++++++++--------
> >  fs/xfs/libxfs/xfs_attr_sf.h   |  6 ++++++
> >  fs/xfs/xfs_attr_list.c        |  2 +-
> >  4 files changed, 17 insertions(+), 11 deletions(-)
> > 
> ...
> > diff --git a/fs/xfs/libxfs/xfs_attr_sf.h b/fs/xfs/libxfs/xfs_attr_sf.h
> > index 540ad3332a9c8..a51aed1dab6c1 100644
> > --- a/fs/xfs/libxfs/xfs_attr_sf.h
> > +++ b/fs/xfs/libxfs/xfs_attr_sf.h
> > @@ -3,6 +3,8 @@
> >   * Copyright (c) 2000,2002,2005 Silicon Graphics, Inc.
> >   * All Rights Reserved.
> >   */
> > +
> > +#include "xfs_inode.h"
> 
> FWIW, I thought we tried to avoid including headers from other headers
> like this. I'm also wondering if it's an issue that we'd be including a
> a header that is external to libxfs from a libxfs header. Perhaps this
> could be simplified by passing the xfs_ifork pointer to the new helper
> rather than the xfs_inode and/or moving the helper to
> libxfs/xfs_inode_fork.h and putting a forward declaration of
> xfs_attr_shortform in there..?

If you change if_data to a (void *), all the casts become unnecessary,
right?

--D

> Brian
> 
> >  #ifndef __XFS_ATTR_SF_H__
> >  #define	__XFS_ATTR_SF_H__
> >  
> > @@ -47,4 +49,8 @@ xfs_attr_sf_nextentry(struct xfs_attr_sf_entry *sfep) {
> >  					    xfs_attr_sf_entsize(sfep));
> >  }
> >  
> > +static inline struct xfs_attr_shortform *
> > +xfs_attr_ifork_to_sf(struct xfs_inode *ino) {
> > +	return (struct xfs_attr_shortform *)ino->i_afp->if_u1.if_data;
> > +}
> >  #endif	/* __XFS_ATTR_SF_H__ */
> > diff --git a/fs/xfs/xfs_attr_list.c b/fs/xfs/xfs_attr_list.c
> > index 8f8837fe21cf0..7c0ebdeb43567 100644
> > --- a/fs/xfs/xfs_attr_list.c
> > +++ b/fs/xfs/xfs_attr_list.c
> > @@ -61,7 +61,7 @@ xfs_attr_shortform_list(
> >  	int				error = 0;
> >  
> >  	ASSERT(dp->i_afp != NULL);
> > -	sf = (struct xfs_attr_shortform *)dp->i_afp->if_u1.if_data;
> > +	sf = xfs_attr_ifork_to_sf(dp);
> >  	ASSERT(sf != NULL);
> >  	if (!sf->hdr.count)
> >  		return 0;
> > -- 
> > 2.26.2
> > 
> 
