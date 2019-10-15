Return-Path: <SRS0=TKSY=YI=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13BEFECE588
	for <linux-xfs@archiver.kernel.org>; Tue, 15 Oct 2019 16:51:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C8D1020650
	for <linux-xfs@archiver.kernel.org>; Tue, 15 Oct 2019 16:51:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="rIrRyrit"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727643AbfJOQvE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 15 Oct 2019 12:51:04 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:33292 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726362AbfJOQvE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 15 Oct 2019 12:51:04 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9FGdFCL039453
        for <linux-xfs@vger.kernel.org>; Tue, 15 Oct 2019 16:51:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to :
 subject : message-id : mime-version : content-type; s=corp-2019-08-05;
 bh=Hvlf18eQF4OmD+KQBeA80aiHBYVHam8Ox/WUosPGVSI=;
 b=rIrRyritih8PkxQvEDRf/0tOPqPMd/X1IfXm6nWX7Mkz3Lx0XiiJTNsOE0E0IQ31lZ/+
 xyvRfkWRY5PZq7OPF3iaw2hyLQYVKvCaOoyVcdgXZ0xp+L59B2dQmyTKYqAdPp175Rti
 UFEem/kM+SfisHIh2DaxFiwbp69Ugo29fw2dMxqDOu4zJtSZqDsbkbPdseLs3m7PjtHl
 sfrrKREPR5WlsYaOxInzIrABbrfwDrhVh1szKcCZCBtWyLuxyRPY9bxk9jeGjrmjbY/7
 ljaiuSTObLzl/s4HPPoqFNcs3ylx5PbK/66gzyGt65f7gQfRpCrcj8176U5xX9BWGTz0 zA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2vk68uhf25-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 15 Oct 2019 16:51:02 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9FGdXFP049684
        for <linux-xfs@vger.kernel.org>; Tue, 15 Oct 2019 16:51:02 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 2vnf7rj1ed-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 15 Oct 2019 16:51:01 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x9FGp0N2032629
        for <linux-xfs@vger.kernel.org>; Tue, 15 Oct 2019 16:51:01 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 15 Oct 2019 16:51:00 +0000
Date:   Tue, 15 Oct 2019 09:50:59 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     xfs <linux-xfs@vger.kernel.org>
Subject: [ANNOUNCE] xfs-linux: for-next updated to 5e0cd1ef6474
Message-ID: <20191015165059.GG13108@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9411 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=964
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910150145
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9411 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910150145
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi folks,

The for-next branch of the xfs-linux repository at:

	git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git

has just been updated.

Patches often get missed, so please check if your outstanding patches
were in this update. If they have not been in this update, please
resubmit them to linux-xfs@vger.kernel.org so they can be picked up in
the next update.  Hopefully this is the last of the 5.4 fixes.

The new head of the for-next branch is commit:

5e0cd1ef6474 xfs: change the seconds fields in xfs_bulkstat to signed

New Commits:

Darrick J. Wong (1):
      [5e0cd1ef6474] xfs: change the seconds fields in xfs_bulkstat to signed


Code Diffstat:

 fs/xfs/libxfs/xfs_fs.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)
