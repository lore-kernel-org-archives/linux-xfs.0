Return-Path: <SRS0=CuST=WZ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46E0CC3A59F
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Aug 2019 22:13:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1644D2166E
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Aug 2019 22:13:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Z/UKYV8N"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727959AbfH2WNe (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 29 Aug 2019 18:13:34 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:33012 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728093AbfH2WNe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 29 Aug 2019 18:13:34 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7TM5veZ008205;
        Thu, 29 Aug 2019 22:13:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=3ta6kchig/y49yvbpKJWebsyM2oB/T4xAstI33yvsQI=;
 b=Z/UKYV8NhRBN8PmFbAXLHY3NunTeN1Yjb43Imdl21wj3EubGAQ6UigibfNnC8ItiM07G
 WKF4P1cySLRfCATE/896ewP58HrlFS+H2KXYS9wQ+UH44ErlmObxWZtmaGLdPG8uKIK4
 p8sK9iNcoavwfymLsySGz1NoNnjMcX2wMVIvt5r1YeTPSh7tJ5g0AiEehSBsvZpaamK7
 kaRWCRLDcXNHWcrZB2J872ct+PaJ1SgMSgZ2ompHAaJwFsCf3naARzTIiBINluTIJ1eV
 8cMzhfOCVgqizY+tag2eOuBRxSBYmUK5/VKSIPfYFQld2qxJwBjDAJa6ZWN3aI/KXT4W Iw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2upq6y811t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Aug 2019 22:13:32 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7TM47ks099670;
        Thu, 29 Aug 2019 22:13:31 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 2upkrfh1vt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Aug 2019 22:13:31 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x7TMDUYl006929;
        Thu, 29 Aug 2019 22:13:30 GMT
Received: from localhost (/10.145.178.11)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 29 Aug 2019 22:13:30 +0000
Date:   Thu, 29 Aug 2019 15:13:29 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH 1/2] xfs: remove all *_ITER_ABORT values
Message-ID: <20190829221329.GD5360@magnolia>
References: <20190829162122.GH5354@magnolia>
 <20190829162229.GB5360@magnolia>
 <20190829220045.GV1119@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190829220045.GV1119@dread.disaster.area>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9364 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908290220
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9364 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908290220
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Aug 30, 2019 at 08:00:45AM +1000, Dave Chinner wrote:
> On Thu, Aug 29, 2019 at 09:22:29AM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Use -ECANCELED to signal "stop iterating" instead of these magical
> > *_ITER_ABORT values, since it's duplicative.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Looks fine to me. One nit:
> 
> > diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
> > index fa3cd8ab9aba..0099053d2a18 100644
> > --- a/fs/xfs/libxfs/xfs_btree.h
> > +++ b/fs/xfs/libxfs/xfs_btree.h
> > @@ -466,7 +466,6 @@ unsigned long long xfs_btree_calc_size(uint *limits, unsigned long long len);
> >  
> >  /* return codes */
> >  #define XFS_BTREE_QUERY_RANGE_CONTINUE	(XFS_ITER_CONTINUE) /* keep iterating */
> > -#define XFS_BTREE_QUERY_RANGE_ABORT	(XFS_ITER_ABORT)    /* stop iterating */
> >  typedef int (*xfs_btree_query_range_fn)(struct xfs_btree_cur *cur,
> >  		union xfs_btree_rec *rec, void *priv);
> 
> Can you add an explicit comment to describe the iteration return
> values here so that a reader will know what behaviour to expect
> from the query range functions...
> 
> I'd suggest the same thing for each of the iteration functions
> that we're removing the special defines from if they don't already
> have them.
> 
> Same for the next patch, which also looks fine apart from
> describing the "return 0 means continue" comments.

Ok will do.

--D

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
