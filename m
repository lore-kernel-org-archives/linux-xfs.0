Return-Path: <SRS0=J5MO=ZF=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9BFF2C43331
	for <linux-xfs@archiver.kernel.org>; Wed, 13 Nov 2019 05:09:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 657B8222CA
	for <linux-xfs@archiver.kernel.org>; Wed, 13 Nov 2019 05:09:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="XfpGI2Fv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725939AbfKMFJP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 13 Nov 2019 00:09:15 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:53574 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725446AbfKMFJP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 13 Nov 2019 00:09:15 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAD593Bt006872;
        Wed, 13 Nov 2019 05:09:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=xs+91o45vOV/fOLbZQi0BjrfTspy1rw8IvYcHaumhlY=;
 b=XfpGI2FvQak3hNJoj0ncAC/Gl9CZBfmSA+7yqWvsK+Boy/yFKFZTUsv6F95+6Y9AZD64
 eObTg6P0Xtb9Ds7p59uK8w4uD6owR/6Wu5AqaOVKa+Ff84J0X9xjTAZ8S5lQOG1wutAJ
 U4zEebALaC2zPOLuCwbwbFE/Yiehc7w3lYQeXruqfKMpm3MGc3+S9J/gOGoQGDggCTYD
 zEvt2CtDqP3vuzyPDZJeTboqkMrV+3ZG+pjERJJai2VvCn3su5Ze8fNrbkYPq3T+MhNz
 dAJBqhmVngbBkWAqUwuZN6ueZRdsO9WN9+u8LjliIRtht6O8ZEXVtIW/rKrFufh0JDI+ Ng== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2w5mvtsqtv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 Nov 2019 05:09:11 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAD58rFI150907;
        Wed, 13 Nov 2019 05:09:11 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 2w7khmnbnj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 Nov 2019 05:09:11 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xAD59A73026441;
        Wed, 13 Nov 2019 05:09:10 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 12 Nov 2019 21:09:10 -0800
Date:   Tue, 12 Nov 2019 21:09:09 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: remove XFS_IOC_FSSETDM and XFS_IOC_FSSETDM_BY_HANDLE
Message-ID: <20191113050909.GT6219@magnolia>
References: <20191108052303.15052-1-hch@lst.de>
 <20191108064801.GM6219@magnolia>
 <20191108065032.GA30861@lst.de>
 <20191108074907.GS6219@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191108074907.GS6219@magnolia>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9439 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1910280000 definitions=main-1911130045
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9439 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1910280000
 definitions=main-1911130045
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Nov 07, 2019 at 11:49:07PM -0800, Darrick J. Wong wrote:
> On Fri, Nov 08, 2019 at 07:50:32AM +0100, Christoph Hellwig wrote:
> > On Thu, Nov 07, 2019 at 10:48:01PM -0800, Darrick J. Wong wrote:
> > > On Fri, Nov 08, 2019 at 06:23:03AM +0100, Christoph Hellwig wrote:
> > > > Thes ioctls set DMAPI specific flags in the on-disk inode, but there is
> > > > no way to actually ever query those flags.  The only known user is
> > > > xfsrestore with the -D option, which is documented to be only useful
> > > > inside a DMAPI enviroment, which isn't supported by upstream XFS.
> > > 
> > > Hmm, shouldn't we deprecate this at least for one or two releases?
> > > 
> > > Even if it's functionally pointless...
> > 
> > It sets a value we can't even retreive.  Not sure what the deprecation
> > would help with.
> 
> Dotting i's and crossing t's.  IOWs, not getting ourselves yelled at for
> killing something without any warning / bureaucracy. :/

OTOH Dave said the same thing, so:
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D


> --D
