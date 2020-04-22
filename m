Return-Path: <SRS0=4ojB=6G=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E27DCC54FCB
	for <linux-xfs@archiver.kernel.org>; Wed, 22 Apr 2020 23:05:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BE17920776
	for <linux-xfs@archiver.kernel.org>; Wed, 22 Apr 2020 23:05:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ev3vFO7O"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726426AbgDVXFK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 22 Apr 2020 19:05:10 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:45184 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726008AbgDVXFK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 22 Apr 2020 19:05:10 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03MMwpY6182329;
        Wed, 22 Apr 2020 23:05:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=8/ZMpnulr6xRwBPJhlF93AjtPrj182AM1RF1iqJk6zw=;
 b=ev3vFO7OwQrBySOBLXWOm+/CGN5jtLmY2kvjKQBv1uGAiAjgBIwAeQbYJq5WNza9n42X
 b5jYVopr4ZaZ1rhhZghmUccnYV5G1QYA7Tx+E7UAnWKS9BiWq1l1QOD3KzD90mgVqdxb
 VxhAZ4fCw5rh89Pk9DcercP5XauTBBJKFQJ5eN5L/WximZXFVvbG/8jojsIN742wdF2p
 Nk04GlpOI4RZPh8flI0pBnlPLFkKw3iqkas0QZZzEIc/hdxniZc4W4K977irc9ZkZhMP
 JfPo/xClOsYRV+/MlfrXqAINs9y/qU8dCtvoPqH2K5U50NzIvlD5u0BzTH159vXc4Iqm 4Q== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 30jhyc4f6w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 22 Apr 2020 23:05:07 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03MMwIP7081539;
        Wed, 22 Apr 2020 23:05:06 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 30gb1kep4g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 22 Apr 2020 23:05:06 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 03MN55Wh030202;
        Wed, 22 Apr 2020 23:05:05 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 22 Apr 2020 16:05:05 -0700
Date:   Wed, 22 Apr 2020 16:05:04 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     xfs <linux-xfs@vger.kernel.org>
Cc:     Amir Goldstein <amir73il@gmail.com>,
        Dave Chinner <david@fromorbit.com>
Subject: [XFS SUMMIT] Deferred inode inactivation and nonblocking inode
 reclaim
Message-ID: <20200422230504.GI6742@magnolia>
References: <20200422225851.GG6742@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200422225851.GG6742@magnolia>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9599 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=0 spamscore=0
 mlxlogscore=999 mlxscore=0 malwarescore=0 bulkscore=0 adultscore=0
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

Heh, only after I sent this did I think about tagging the subject line
and sending links to git branches when applicable.

On Wed, Apr 22, 2020 at 03:58:51PM -0700, Darrick J. Wong wrote:
> Hi everyone,
> 
> Here's a jumping-off point for a discussion about my patchset that
> implements deferred inode inactivation and Dave's patchset that moves
> inode buffer flushing out of reclaim.
> 
> The inactivation series moves the transactional updates that happen

https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git/log/?h=deferred-inactivation

> after a file loses its last reference (truncating attr/data forks,
> freeing the inode) out of drop_inode and reclaim by moving all that work
> to an intermediate workqueue.  This all can be done internally to XFS.
> 
> The reclaim series (Dave) removes inode flushing from reclaim, which

https://lore.kernel.org/linux-xfs/20191031234618.15403-1-david@fromorbit.com/

--D

> means that xfs stop holding up memory reclaim on IO.  It also contains a
> fair amount of surgery to the memory shrinker code, which is an added
> impediment to getting this series reviewed and upstream.
> 
> Because of the extra review needed for the reclaim series, does it make
> sense to keep the two separate?  Deferring inactivation alone won't get
> rid of the inode flushing that goes on in reclaim, but it at least means
> that we can handle things like "rm -rf $dir" a little more efficiently
> in that we can do all the directory shrinking at once and then handle
> the unlinked inodes in on-disk order.  It would also, erm, help me
> reduce the size of my dev tree. :)
> 
> --D
