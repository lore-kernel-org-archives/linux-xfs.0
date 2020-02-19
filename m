Return-Path: <SRS0=TUUv=4H=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB5ACC3404E
	for <linux-xfs@archiver.kernel.org>; Wed, 19 Feb 2020 00:58:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C1C0C24658
	for <linux-xfs@archiver.kernel.org>; Wed, 19 Feb 2020 00:58:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="TO6Q/NYX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726655AbgBSA64 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 18 Feb 2020 19:58:56 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:47606 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726482AbgBSA6z (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 18 Feb 2020 19:58:55 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01J0rv0u178495;
        Wed, 19 Feb 2020 00:58:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=46lZfCznpJFz+XpNW/8bsULWfOgeJ7V93HVO+dYMZEI=;
 b=TO6Q/NYXliwRQVw3fHQ5yWDiTEW1ZC8WGe/lE5A/EuEepRBEwGFExiDkWR+U4nT2N416
 +p0XMO3AAxwzOyYQ/umobMIIyoEXRCOaNqoIoL1R4oVH5IcOhvR/BABj0EhIphiin02k
 3JZJJOVUCg8fd+YdMrVyY+sIHaSaK0c2MAosyrChB4U3UZ9eVRkRV8EsS6DM9nfhuMrH
 gWVAgQ8crUkFeLMPLodiK3YPp2w9eDlUfXZwAV04xqKPsBqacz0Apz9YGleeC30v+mR/
 DXJfrE//nmUklb3nl/aWDOt62x3HO29CnCqdO7ST4ZlWNptrKPQpT/FHNqh3R3yGfgSh QA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2y8e1hn9e9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 19 Feb 2020 00:58:50 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01J0wNS1077580;
        Wed, 19 Feb 2020 00:58:49 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 2y6t4kd9y7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 19 Feb 2020 00:58:49 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 01J0wmKq013092;
        Wed, 19 Feb 2020 00:58:48 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 18 Feb 2020 16:58:48 -0800
Date:   Tue, 18 Feb 2020 16:58:47 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org,
        Allison Collins <allison.henderson@oracle.com>
Subject: Re: [PATCH 23/31] xfs: properly type the buffer field in struct
 xfs_fsop_attrlist_handlereq
Message-ID: <20200219005847.GG9506@magnolia>
References: <20200217125957.263434-1-hch@lst.de>
 <20200217125957.263434-24-hch@lst.de>
 <20200217235315.GY10776@dread.disaster.area>
 <20200218153924.GB21780@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200218153924.GB21780@lst.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9535 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0
 mlxlogscore=999 phishscore=0 mlxscore=0 malwarescore=0 suspectscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002190001
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9535 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0
 mlxlogscore=999 mlxscore=0 malwarescore=0 clxscore=1015 adultscore=0
 lowpriorityscore=0 spamscore=0 bulkscore=0 priorityscore=1501
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002190001
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Feb 18, 2020 at 04:39:24PM +0100, Christoph Hellwig wrote:
> On Tue, Feb 18, 2020 at 10:53:16AM +1100, Dave Chinner wrote:
> > > diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
> > > index ae77bcd8c05b..21920f613d42 100644
> > > --- a/fs/xfs/libxfs/xfs_fs.h
> > > +++ b/fs/xfs/libxfs/xfs_fs.h
> > > @@ -597,7 +597,7 @@ typedef struct xfs_fsop_attrlist_handlereq {
> > >  	struct xfs_attrlist_cursor	pos; /* opaque cookie, list offset */
> > >  	__u32				flags;	/* which namespace to use */
> > >  	__u32				buflen;	/* length of buffer supplied */
> > > -	void				__user *buffer;	/* returned names */
> > > +	struct xfs_attrlist __user	*buffer;/* returned names */
> > >  } xfs_fsop_attrlist_handlereq_t;
> > 
> > This changes the userspace API, right? So, in theory, it could break
> > compilation of userspace applications that treat it as an attrlist_t
> > and don't specifically cast the assignment because it's currently
> > a void pointer?
> 
> IFF userspace was using this header it would change the API.  But
> userspace uses the libattr definition exclusively.

Assuming most userspace will use libhandle (and not call the ioctl
directly) then this "shouldn't" be a problem because libhandle treats
the attrlist buffer as a void pointer.

(I dunno, how difficult /is/ it to say "program to the library, not the
kernel ABI" here?)

--D
