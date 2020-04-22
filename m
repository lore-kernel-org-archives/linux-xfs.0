Return-Path: <SRS0=4ojB=6G=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4B5AC54FCB
	for <linux-xfs@archiver.kernel.org>; Wed, 22 Apr 2020 22:58:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8DD4A20724
	for <linux-xfs@archiver.kernel.org>; Wed, 22 Apr 2020 22:58:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="e5tr8hNn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726002AbgDVW6z (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 22 Apr 2020 18:58:55 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:39604 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725839AbgDVW6y (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 22 Apr 2020 18:58:54 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03MMwsBP182653
        for <linux-xfs@vger.kernel.org>; Wed, 22 Apr 2020 22:58:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to :
 subject : message-id : mime-version : content-type; s=corp-2020-01-29;
 bh=+EgJwSZ9dqRycZUJrapx4+Xn9Tqgi/v9K1IceXdmZ1Q=;
 b=e5tr8hNnwlFhlcScu5ubM0VauiAJedeOfPJR5sLqCu4vZiiClxrZLRaOj1UgSt9v2aXr
 mELIPe0hnHO7D62g6UjJAWE/1rgZBpK4RyMrtI4N0wTX/QhSZ2Rw1HFAogO0qDfMjt8N
 vKneGNP6rBz+HFwzWYy1SQVFGL89lm86z13YkMiqnDibxS10OXcenG3Cbh0Q7vtMW+hQ
 mArAaSs42pAb6pPd9gZAZ7/4BS59r7oo1bNre7Z23ZefXwiJRMzf1B58RcvCHWuK8o4E
 X3jO90OOxamkXWFIHndLS/saWv6ozwijspa0vAcnpDEWqAP6Z7QSVFZb514uF2du/2RQ DA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 30jhyc4epk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 22 Apr 2020 22:58:54 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03MMvdXu093653
        for <linux-xfs@vger.kernel.org>; Wed, 22 Apr 2020 22:58:53 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 30gb3um8qr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 22 Apr 2020 22:58:53 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 03MMwq4d029105
        for <linux-xfs@vger.kernel.org>; Wed, 22 Apr 2020 22:58:52 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 22 Apr 2020 15:58:51 -0700
Date:   Wed, 22 Apr 2020 15:58:51 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     xfs <linux-xfs@vger.kernel.org>
Subject: Deferred inode inactivation and nonblocking inode reclaim
Message-ID: <20200422225851.GG6742@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9599 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0 adultscore=0
 mlxlogscore=999 phishscore=0 suspectscore=0 bulkscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004220174
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9599 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 spamscore=0 mlxscore=0
 clxscore=1015 suspectscore=0 phishscore=0 lowpriorityscore=0 bulkscore=0
 impostorscore=0 malwarescore=0 priorityscore=1501 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004220174
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi everyone,

Here's a jumping-off point for a discussion about my patchset that
implements deferred inode inactivation and Dave's patchset that moves
inode buffer flushing out of reclaim.

The inactivation series moves the transactional updates that happen
after a file loses its last reference (truncating attr/data forks,
freeing the inode) out of drop_inode and reclaim by moving all that work
to an intermediate workqueue.  This all can be done internally to XFS.

The reclaim series (Dave) removes inode flushing from reclaim, which
means that xfs stop holding up memory reclaim on IO.  It also contains a
fair amount of surgery to the memory shrinker code, which is an added
impediment to getting this series reviewed and upstream.

Because of the extra review needed for the reclaim series, does it make
sense to keep the two separate?  Deferring inactivation alone won't get
rid of the inode flushing that goes on in reclaim, but it at least means
that we can handle things like "rm -rf $dir" a little more efficiently
in that we can do all the directory shrinking at once and then handle
the unlinked inodes in on-disk order.  It would also, erm, help me
reduce the size of my dev tree. :)

--D
