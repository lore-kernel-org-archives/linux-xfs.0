Return-Path: <SRS0=q11v=YV=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3660CA9EC0
	for <linux-xfs@archiver.kernel.org>; Mon, 28 Oct 2019 18:22:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9D9FF214B2
	for <linux-xfs@archiver.kernel.org>; Mon, 28 Oct 2019 18:22:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="E9lyjOK6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391086AbfJ1SWh (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 28 Oct 2019 14:22:37 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:60494 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730690AbfJ1SWh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 28 Oct 2019 14:22:37 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9SI9dnw152472;
        Mon, 28 Oct 2019 18:22:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=E2T4Gys/y98XBamnGnhhbNZIub5g0i6kHcz84W7CMUk=;
 b=E9lyjOK6Imoa3wNdWmo0OahEedb1ADsN3ccIHo1f3ZPijfwSlp87ZcFkbuvgk1zQ3N47
 7AlxgGd1VVSFFU03r1Zj8O7lWm8xJvK3VJs+sif6tOPMGbtIxiwZol/u7QUK6nV/4A7M
 gOlCPGTEIri+DHuQRK64LArwF501MxWBU9zcdqAQcUdF4Afv5lGMIdQFct400RBIz3VO
 sR++1qcsUngqmovGZzqWvnzoyqPBKhEmMRA99kGcQcuSis4GQ6EoyrQc0TnSnKgY3eet
 rSx5/RdF8uqpBGHVHEJTqxoeiLiA+TUCKllI+ckPSJtDISWkg9D8mN0gXB4w7zMlLMCr mQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2vvdju3y9y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 28 Oct 2019 18:22:21 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9SI8rv3056302;
        Mon, 28 Oct 2019 18:22:20 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 2vw09g7mkn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 28 Oct 2019 18:22:20 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x9SIMIkn000564;
        Mon, 28 Oct 2019 18:22:18 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 28 Oct 2019 11:22:18 -0700
Date:   Mon, 28 Oct 2019 11:22:17 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/4] xfs: namecheck attribute names before listing them
Message-ID: <20191028182217.GW15222@magnolia>
References: <157198048552.2873445.18067788660614948888.stgit@magnolia>
 <157198049955.2873445.974102983711142585.stgit@magnolia>
 <20191028181857.GC26529@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191028181857.GC26529@bfoster>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9424 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910280176
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9424 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910280176
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Oct 28, 2019 at 02:18:57PM -0400, Brian Foster wrote:
> On Thu, Oct 24, 2019 at 10:14:59PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Actually call namecheck on attribute names before we hand them over to
> > userspace.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  fs/xfs/libxfs/xfs_attr_leaf.h |    4 ++--
> >  fs/xfs/xfs_attr_list.c        |   40 ++++++++++++++++++++++++++++++++--------
> >  2 files changed, 34 insertions(+), 10 deletions(-)
> > 
> > 
> ...
> > diff --git a/fs/xfs/xfs_attr_list.c b/fs/xfs/xfs_attr_list.c
> > index 00758fdc2fec..3a1158a1347d 100644
> > --- a/fs/xfs/xfs_attr_list.c
> > +++ b/fs/xfs/xfs_attr_list.c
> ...
> > @@ -174,6 +179,11 @@ xfs_attr_shortform_list(xfs_attr_list_context_t *context)
> >  			cursor->hashval = sbp->hash;
> >  			cursor->offset = 0;
> >  		}
> > +		if (!xfs_attr_namecheck(sbp->name, sbp->namelen)) {
> > +			XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW,
> > +					 context->dp->i_mount);
> > +			return -EFSCORRUPTED;
> > +		}
> 
> It looks like we still need to handle freeing sbuf in this path.

Fixed.  Good catch! :)

> >  		context->put_listent(context,
> >  				     sbp->flags,
> >  				     sbp->name,
> ...
> > @@ -557,6 +574,13 @@ xfs_attr_put_listent(
> >  	ASSERT(context->firstu >= sizeof(*alist));
> >  	ASSERT(context->firstu <= context->bufsize);
> >  
> > +	if (!xfs_attr_namecheck(name, namelen)) {
> > +		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW,
> > +				 context->dp->i_mount);
> > +		context->seen_enough = -EFSCORRUPTED;
> > +		return;
> > +	}
> > +
> 
> Any reason we call this here and the ->put_listent() callers?

Oops.  I guess I got overzealous.

--D

> Brian
> 
> >  	/*
> >  	 * Only list entries in the right namespace.
> >  	 */
> > 
> 
