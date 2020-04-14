Return-Path: <SRS0=w6e5=56=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C58A1C2BA19
	for <linux-xfs@archiver.kernel.org>; Tue, 14 Apr 2020 17:20:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A252B20737
	for <linux-xfs@archiver.kernel.org>; Tue, 14 Apr 2020 17:20:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="EVIqCvHa"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407606AbgDNRUY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 14 Apr 2020 13:20:24 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:41268 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2407532AbgDNRUX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 14 Apr 2020 13:20:23 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03EHABUR173255
        for <linux-xfs@vger.kernel.org>; Tue, 14 Apr 2020 17:20:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to :
 subject : message-id : mime-version : content-type; s=corp-2020-01-29;
 bh=oRMIToFAMZAySqacHm0Gki9s2l84yx9OQpCyWFqNuuA=;
 b=EVIqCvHa2ZLc9ObL+6bZFk7b2A+IOTQ+uHlk8TiE5eYcIdiPfHJzGlldVDfKhwnmjalB
 +PduYKyOp89igmTOibyrH7WDPwXveYAi1rGH5hmRzCdyV8nRGxZv8NJqRQhRTWEjHiD/
 dCpOtG71fcjrTv+HUs6+p8iuDvw3L7GV0vEb2a59oT7d3QrF2Mz16Y8TGaeEsAQ+9fYr
 S80q4WknRXcJDD2AWtNMJMtJb3uNaaknXDEXL+WfQ3KHvTw06udCtqJlp6SYs/Uxrabj
 ANtjRZKik5RPsFjhENN+EMzgxEc9gaibu0qUX0KgkbMVwNZ6JknY1Ej75utWvgON35Ct qw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 30b5um6712-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 14 Apr 2020 17:20:21 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03EH7ExQ116448
        for <linux-xfs@vger.kernel.org>; Tue, 14 Apr 2020 17:18:20 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 30ctaaqk91-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 14 Apr 2020 17:18:20 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 03EHIKRi013217
        for <linux-xfs@vger.kernel.org>; Tue, 14 Apr 2020 17:18:20 GMT
Received: from localhost (/10.159.239.16)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 14 Apr 2020 10:18:20 -0700
Date:   Tue, 14 Apr 2020 10:18:19 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     xfs <linux-xfs@vger.kernel.org>
Subject: [ANNOUNCE] xfs-linux: for-next updated to c142932c29e5
Message-ID: <20200414171819.GG6742@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9591 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=0
 spamscore=0 adultscore=0 mlxscore=0 phishscore=0 mlxlogscore=999
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004140131
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9591 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1015 bulkscore=0 mlxscore=0
 mlxlogscore=999 lowpriorityscore=0 impostorscore=0 adultscore=0
 phishscore=0 spamscore=0 suspectscore=0 malwarescore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004140131
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
the next update.  (Yes, this is bugfixes for 5.7.)

The new head of the for-next branch is commit:

c142932c29e5 xfs: fix partially uninitialized structure in xfs_reflink_remap_extent

New Commits:

Brian Foster (1):
      [4b674b9ac852] xfs: acquire superblock freeze protection on eofblocks scans

Darrick J. Wong (1):
      [c142932c29e5] xfs: fix partially uninitialized structure in xfs_reflink_remap_extent


Code Diffstat:

 fs/xfs/xfs_icache.c  | 10 ++++++++++
 fs/xfs/xfs_ioctl.c   |  5 ++++-
 fs/xfs/xfs_reflink.c |  1 +
 3 files changed, 15 insertions(+), 1 deletion(-)
