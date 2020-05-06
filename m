Return-Path: <SRS0=Htpe=6U=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96FDDC4724C
	for <linux-xfs@archiver.kernel.org>; Wed,  6 May 2020 16:50:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6FB4620CC7
	for <linux-xfs@archiver.kernel.org>; Wed,  6 May 2020 16:50:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="K6ogIeCb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730337AbgEFQsY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 6 May 2020 12:48:24 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:48690 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730145AbgEFQsX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 6 May 2020 12:48:23 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 046GjZ7R193464;
        Wed, 6 May 2020 16:48:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=zgoG0adZEhYMON9giYd/yT2OIRoEyWIx/FOyPehpp3U=;
 b=K6ogIeCb53S6u00sfVqNAYUB3hJwzAR6/w2+/WUQWQvZSup7QtsE+CCCA4KI0o4n+wQk
 YYz9sEOwjExgcmxDiph+vda17nYmoEyqjKnoeiq2rEOKkkkUcTTGv2X8gRgQ13l/OLSS
 A2jV4uEATLlCLBukKwsN89drPHAdbmaUfl2YFkbq8X+d+mDQM0Nohfw/M3B2L4xQ6cxP
 w8ogSg80mvukMbpiOoIR320TI3dDjWxP2RpNqZ2jpt34cBW1MQes96Q4KWm/rOVs84C0
 G8iVgR5voYpqvr/F7Nblat3Nibd8881Hzoecg7FMTQKH7k1ZvPm9kAzBkU02kfAFZ3LU fQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 30usgq2mqs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 06 May 2020 16:48:19 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 046GlTlG093377;
        Wed, 6 May 2020 16:48:19 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 30sjnk19jx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 06 May 2020 16:48:19 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 046GmIpu004644;
        Wed, 6 May 2020 16:48:18 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 06 May 2020 09:48:18 -0700
Date:   Wed, 6 May 2020 09:48:16 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 13/28] xfs: remove log recovery quotaoff item dispatch
 for pass2 commit functions
Message-ID: <20200506164816.GV5703@magnolia>
References: <158864103195.182683.2056162574447133617.stgit@magnolia>
 <158864111362.182683.13426589599394215389.stgit@magnolia>
 <20200506151611.GQ7864@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200506151611.GQ7864@infradead.org>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9613 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 adultscore=0 phishscore=0
 mlxlogscore=999 bulkscore=0 malwarescore=0 spamscore=0 suspectscore=1
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005060135
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9613 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 mlxscore=0
 priorityscore=1501 lowpriorityscore=0 malwarescore=0 clxscore=1015
 mlxlogscore=999 spamscore=0 adultscore=0 bulkscore=0 phishscore=0
 suspectscore=1 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005060134
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, May 06, 2020 at 08:16:11AM -0700, Christoph Hellwig wrote:
> > diff --git a/fs/xfs/xfs_dquot_item_recover.c b/fs/xfs/xfs_dquot_item_recover.c
> > index 07ff943972a3..a07c1c8344d8 100644
> > --- a/fs/xfs/xfs_dquot_item_recover.c
> > +++ b/fs/xfs/xfs_dquot_item_recover.c
> > @@ -197,4 +197,5 @@ xlog_recover_quotaoff_commit_pass1(
> >  const struct xlog_recover_item_ops xlog_quotaoff_item_ops = {
> >  	.item_type		= XFS_LI_QUOTAOFF,
> >  	.commit_pass1		= xlog_recover_quotaoff_commit_pass1,
> > +	.commit_pass2		= NULL, /* nothing to do in pass2 */
> 
> No need to initialize 0 or NULL fields in static structures.

Ok, I'll trim this line to only have the comment, to make it explicit
that quotaoff does no work for commit_pass2.

--D

> Otherwise looks good:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
