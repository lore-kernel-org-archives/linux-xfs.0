Return-Path: <SRS0=R4OI=CF=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 416FAC433DF
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Aug 2020 16:00:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1498E2080C
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Aug 2020 16:00:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="MSbMoz7V"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726820AbgH0QAf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 27 Aug 2020 12:00:35 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:54006 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726234AbgH0QAf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 Aug 2020 12:00:35 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07RFxuoA176597
        for <linux-xfs@vger.kernel.org>; Thu, 27 Aug 2020 16:00:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to :
 subject : message-id : mime-version : content-type; s=corp-2020-01-29;
 bh=VYP6cUdNXWyrJWK+Fd6/IhOumYGayv1IzJgh55HtQBU=;
 b=MSbMoz7V1uKVgjMOixRUKM8LtPqIiotsFAakpc2gRR7iyAL6KG7I/0W54Dz6DG88xFeO
 Cw5ru+mCjOiYCNp/VpxPLEYeNnr08r6QuxcyX+NuXnaEFokJ0qH++s1JhszViBuLZNr8
 Rgum3kiffbOMhq3Mcrx6OPNxxANqXik2jnYz28bhZDhEE5DVqbqSsmRzPKnBHTJQah9y
 3omBNuV5mXnh70AFcYN0le51uvZ17pmxlqsGuykA7ku77yhjDzZumtbaO6CwMDTp7s2M
 +5fAuW3UpBq24ee4N3D6o7gHf4UIrj6rlJ5+Ox1RC8jazf/LV7yyD2nVoXN/l8xWL7Ra /Q== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 333dbs77m4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Thu, 27 Aug 2020 16:00:32 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07RG0Kwp141916
        for <linux-xfs@vger.kernel.org>; Thu, 27 Aug 2020 16:00:32 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 333rudcb8n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 27 Aug 2020 16:00:31 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 07RG0VtA021510
        for <linux-xfs@vger.kernel.org>; Thu, 27 Aug 2020 16:00:31 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 27 Aug 2020 09:00:30 -0700
Date:   Thu, 27 Aug 2020 09:00:30 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     xfs <linux-xfs@vger.kernel.org>
Subject: [ANNOUNCE] xfs-linux: for-next updated to 125eac243806
Message-ID: <20200827160030.GV6096@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9726 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 bulkscore=0 suspectscore=2 spamscore=0 mlxscore=0 adultscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008270118
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9726 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 clxscore=1015
 priorityscore=1501 impostorscore=0 phishscore=0 malwarescore=0
 mlxlogscore=999 spamscore=0 mlxscore=0 lowpriorityscore=0 suspectscore=2
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008270118
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
the next update.  We're still in the stabilization phase for 5.9, and I
wanted to get the fix for the <cough> nasty xattr bug moving asap.

The new head of the for-next branch is commit:

125eac243806 xfs: initialize the shortform attr header padding entry

New Commits:

Brian Foster (2):
      [9c516e0e4554] xfs: finish dfops on every insert range shift iteration
      [657f101930bc] xfs: fix off-by-one in inode alloc block reservation calculation

Darrick J. Wong (1):
      [125eac243806] xfs: initialize the shortform attr header padding entry

Eric Sandeen (1):
      [f4020438fab0] xfs: fix boundary test in xfs_attr_shortform_verify


Code Diffstat:

 fs/xfs/libxfs/xfs_attr_leaf.c   | 8 +++++---
 fs/xfs/libxfs/xfs_ialloc.c      | 4 ++--
 fs/xfs/libxfs/xfs_trans_space.h | 2 +-
 fs/xfs/xfs_bmap_util.c          | 2 +-
 4 files changed, 9 insertions(+), 7 deletions(-)
