Return-Path: <SRS0=A2Vo=7C=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9AFBC433DF
	for <linux-xfs@archiver.kernel.org>; Wed, 20 May 2020 18:54:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B0E49206C3
	for <linux-xfs@archiver.kernel.org>; Wed, 20 May 2020 18:54:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="DYzeiUHp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726697AbgETSyb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 20 May 2020 14:54:31 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:47234 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726548AbgETSyb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 20 May 2020 14:54:31 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04KIpfoT044001;
        Wed, 20 May 2020 18:54:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=6VwekH5DRsopwAtG+5uazZRpBmfTzYA8WzzhTL/ECXw=;
 b=DYzeiUHpEbKXwAYxCAK4bELo/QPZX0/T73jOY6d4t8HjOX8/ixpupd+PdJSVl9WyioR8
 kODEt8Gzpmig9ucCwZqPJqO8/WQrjXGG8dZtgUdW06Oq8+TiVTJc+fkLb1qHiIyBIIl3
 Wo1hmPMLzUD5Ekk4pl2ScXJb6UJgFxv2kHd4hFeTNL1RufS7SH3UmLrqS8yegMqcd4BJ
 M2JihuNK0k1zu5s7ZPTvt1Qh4sNafXIc4C7Gg4++AX06Xni361Oan08JPIkBV++VUsEO
 4bdw9iVZlbYRO4a0B8EbNUbHbudKVFhDTLq6dX0ZdcSyxwp2RcxxIQ91WbeyHEb/4E6y 7Q== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 3127krcvfb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 20 May 2020 18:54:27 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04KIqcIf152875;
        Wed, 20 May 2020 18:54:26 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 313gj410wd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 20 May 2020 18:54:26 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 04KIsPtA030511;
        Wed, 20 May 2020 18:54:25 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 20 May 2020 11:54:24 -0700
Date:   Wed, 20 May 2020 11:54:22 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 11/11] xfs: hide most of the incore inode walk interface
Message-ID: <20200520185422.GY17627@magnolia>
References: <158993911808.976105.13679179790848338795.stgit@magnolia>
 <158993918698.976105.6231244252663510379.stgit@magnolia>
 <20200520064643.GK2742@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200520064643.GK2742@lst.de>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9627 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 malwarescore=0
 mlxscore=0 adultscore=0 bulkscore=0 suspectscore=1 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005200152
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9627 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 spamscore=0
 bulkscore=0 clxscore=1015 priorityscore=1501 mlxscore=0 impostorscore=0
 suspectscore=1 mlxlogscore=999 malwarescore=0 cotscore=-2147483648
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2005200152
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, May 20, 2020 at 08:46:43AM +0200, Christoph Hellwig wrote:
> On Tue, May 19, 2020 at 06:46:27PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Hide the incore inode walk interface because callers outside of the
> > icache code don't need to know about iter_flags and radix tags and other
> > implementation details of the incore inode cache.
> 
> I don't really see the point here.  It isn't hiding much, and only from
> a single caller.  I have to say I also prefer the old naming over _ici_
> and find the _all postfix not exactly descriptive.

This last patch is more of a prep patch for the patchsets that come
after it: cleaning up the block gc stuff and deferred inode
inactivation.  It's getting kinda late so I didn't want to send 11 more
patches, but perhaps that would make it clearer where this is all
heading?

The quota dqrele_all code does not care about inode radix tree tags nor
does it need the ability to grab inodes /while/ they're in INEW state,
so there's no reason to pass those arguments around.

OTOH I guess I could have hid XFS_AGITER_INEW_WAIT in xfs_icache.c and
left the function names unchanged.

--D
