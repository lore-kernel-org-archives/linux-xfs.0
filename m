Return-Path: <SRS0=WPjR=DA=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3CF22C4727F
	for <linux-xfs@archiver.kernel.org>; Wed, 23 Sep 2020 15:55:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EF89B2311E
	for <linux-xfs@archiver.kernel.org>; Wed, 23 Sep 2020 15:55:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Gj1AAXnK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726820AbgIWPzl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 23 Sep 2020 11:55:41 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:55234 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726518AbgIWPzk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 23 Sep 2020 11:55:40 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08NFhVma113295;
        Wed, 23 Sep 2020 15:55:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=Jj41EYmvCrfQHfTC9L2TNSOfaOI1yP/p+Pk4UzzGT7c=;
 b=Gj1AAXnKak8fPeSwsDIVLFkG2+2v4x6Iaf99WI23x6rbQvdlAspjG8BEPOLgVsStJ+xl
 60lxD9Sbcd3NmD2bOF/Uc+j7OENf4VaSNAj8Me7C8XulNXywJ1L0k02xawH4BTdzxykJ
 BrF76hUfqQfw/SqOSXK5/8Xj4/fZ4MV0F6lItS86Hb8vKEW37fUtyVWc2kudDFmt1l6i
 5NQqNjpl2/tJ01bHGUuchwl4GGZpmid6ZVBaAqX797dlIwK5bEFC3/2nWSB7MgC8uVAj
 QRi/JvRnIkG2egxCS5wQSftI3w85/Em2RYdHc22HKDckh2sLqa42mjoFse8oOvcekF7l EQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 33qcpu0a39-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 23 Sep 2020 15:55:36 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08NFkOb6082275;
        Wed, 23 Sep 2020 15:55:36 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 33nujprss5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 23 Sep 2020 15:55:36 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 08NFtZ7u025110;
        Wed, 23 Sep 2020 15:55:35 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 23 Sep 2020 08:55:34 -0700
Date:   Wed, 23 Sep 2020 08:55:33 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com
Subject: Re: [PATCH 3/3] xfs: fix an incore inode UAF in xfs_bui_recover
Message-ID: <20200923155533.GO7955@magnolia>
References: <160031336397.3624582.9639363323333392474.stgit@magnolia>
 <160031338272.3624582.1273521883524627790.stgit@magnolia>
 <20200923072015.GC29203@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200923072015.GC29203@infradead.org>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9753 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0
 mlxlogscore=999 phishscore=0 adultscore=0 spamscore=0 suspectscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009230125
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9753 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxlogscore=999
 adultscore=0 bulkscore=0 mlxscore=0 lowpriorityscore=0 priorityscore=1501
 phishscore=0 spamscore=0 malwarescore=0 clxscore=1015 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009230125
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Sep 23, 2020 at 08:20:15AM +0100, Christoph Hellwig wrote:
> On Wed, Sep 16, 2020 at 08:29:42PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > In xfs_bui_item_recover, there exists a use-after-free bug with regards
> > to the inode that is involved in the bmap replay operation.  If the
> > mapping operation does not complete, we call xfs_bmap_unmap_extent to
> > create a deferred op to finish the unmapping work, and we retain a
> > pointer to the incore inode.
> > 
> > Unfortunately, the very next thing we do is commit the transaction and
> > drop the inode.  If reclaim tears down the inode before we try to finish
> > the defer ops, we dereference garbage and blow up.  Therefore, create a
> > way to join inodes to the defer ops freezer so that we can maintain the
> > xfs_inode reference until we're done with the inode.
> > 
> > Note: This imposes the requirement that there be enough memory to keep
> > every incore inode in memory throughout recovery.
> 
> As in every inode that gets recovered, not every inode in the system.
> I think the commit log could use a very slight tweak here.
> 
> Didn't we think of just storing the inode number for recovery, or
> did this turn out too complicated? (I'm pretty sure we dicussed this
> in detail before, but my memory gets foggy).

Initially I did just store the inode numbers, but that made the code
more clunky due to needing more _iget and _irele calls, and a bunch of
error handling for that.  Dave suggested on irc that I should retain the
reference to the incore inode to simplify the initial patch, and if we
run into ENOMEM then we can fix it later.

I wasn't 100% convinced of that, but Dave or Brian or someone (memory
foggy, don't remember who) countered that the system recovering the fs
is usually the system that crashed in the first place, and it certainly
had enough RAM to hold the inodes.

I think the link you're looking for is[1].

--D

[1] https://lore.kernel.org/linux-xfs/158864123329.184729.14504239314355330619.stgit@magnolia/
