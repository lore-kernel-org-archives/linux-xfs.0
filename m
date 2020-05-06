Return-Path: <SRS0=Htpe=6U=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB650C28CBC
	for <linux-xfs@archiver.kernel.org>; Wed,  6 May 2020 16:53:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C34F3208CA
	for <linux-xfs@archiver.kernel.org>; Wed,  6 May 2020 16:53:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="e4z9Crfp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729702AbgEFQxX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 6 May 2020 12:53:23 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:52718 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729341AbgEFQxW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 6 May 2020 12:53:22 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 046GrKhs005057;
        Wed, 6 May 2020 16:53:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=D2qCm1ckWHuEOdQ3Aqti4zOsCfL2QdYe0hXrnaq/Na0=;
 b=e4z9CrfpAWGswxSS6soH2ZjG1x2G3pnixlKv2nBBpLwmhZ+TpJ6UnSQu+RZvlspqcYbk
 V31cggkkTMm7GAITkjc/8ZAu/x1+ZKqsccf+K2ypBUFWXRgZ/4O6YOucWWTlO/Fj7uKX
 /RsOklvWOBCxQT7TMzZgNOuN7N5lZRq5QgwHNnxWCiRP3BiUaBZwBC8B9YRa1LtXPTmQ
 Y3HPJTBVamiTvC72uyPxSJnmUt1OeIZysj/OGX18nWR85fjutktSgr86psgKsKzVSDKU
 2JPunAG3Y8FhN+qxX8H44BLRpZ7O3n6tYEf3SvMh8UBR1OroH/SAyeWeRQKtLd1ztCL3 mA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 30usgq2ngf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 06 May 2020 16:53:19 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 046GlTjX093387;
        Wed, 6 May 2020 16:51:19 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 30sjnk1j2j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 06 May 2020 16:51:19 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 046GpItC006612;
        Wed, 6 May 2020 16:51:18 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 06 May 2020 09:51:17 -0700
Date:   Wed, 6 May 2020 09:51:17 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 18/28] xfs: refactor unlinked inode recovery
Message-ID: <20200506165117.GW5703@magnolia>
References: <158864103195.182683.2056162574447133617.stgit@magnolia>
 <158864114901.182683.2099772155374609732.stgit@magnolia>
 <20200506152609.GW7864@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200506152609.GW7864@infradead.org>
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
 engine=8.12.0-2003020000 definitions=main-2005060136
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, May 06, 2020 at 08:26:09AM -0700, Christoph Hellwig wrote:
> On Mon, May 04, 2020 at 06:12:29PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Move the code that processes unlinked inodes into a separate file in
> > preparation for centralizing the log recovery bits that have to walk
> > every AG.  No functional changes.
> 
> Is this really worth another tiny source file?

Later I plan to move into this file the code that cleans out stale COW
staging extents, since it should only be necessary to do that as part of
log recovery.

> At least the interface seems very right.
> 
> > +out_error:
> > +	xfs_warn(mp, "%s: failed to clear agi %d. Continuing.", __func__, agno);
> > +	return;
> > +}
> 
> No need for a return at the end of a void function.
> 
> > +	struct xfs_mount	*mp;
> > +	struct xfs_agi		*agi;
> > +	struct xfs_buf		*agibp;
> > +	xfs_agnumber_t		agno;
> > +	xfs_agino_t		agino;
> > +	int			bucket;
> > +	int			error;
> > +
> > +	mp = log->l_mp;
> 
> Please initialize mp on the line where it is declared.

Ok, will fix.

--D
