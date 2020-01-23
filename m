Return-Path: <SRS0=OHiL=3M=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07AE3C33CAA
	for <linux-xfs@archiver.kernel.org>; Thu, 23 Jan 2020 04:51:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C7ECE24673
	for <linux-xfs@archiver.kernel.org>; Thu, 23 Jan 2020 04:51:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ikjcqCFi"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726049AbgAWEvz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 22 Jan 2020 23:51:55 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:42542 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726004AbgAWEvy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 22 Jan 2020 23:51:54 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00N4mmdM009253
        for <linux-xfs@vger.kernel.org>; Thu, 23 Jan 2020 04:51:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2019-08-05;
 bh=A3Ckpq/oNUi1W39970WQBW2eyu//2XE+D54Pnewd+V0=;
 b=ikjcqCFimg3tjGGcxLs55279QGNXez3X7TcMHwzzg5kPJtkEuYHn8bjS3Y8th/Ec7fHg
 lnk00f/i6f5VUcC8nQh2uIOHbU6LfxGFMOlb2lAmzH8gCIYEj/UV3YuwJ45WfgmDgQE0
 ftA3hLNoTvTgSN8elMmFef4lMgB93BtfM/+/oLV80NFOW+NjpGqDgEMyrvi7ekfx/+DL
 zmqtDp4Ss9vFmwKUaYRejAOy7/BYggebWpmMCa7/iJYvQJsEo4KTGwym3N06uQ/Uc/s5
 eiWSEbQdovZPwni9aBhwiO9Don4k+hefAPkEPsevK7EJfgn5FvVz+DQarOeNeHXZsd3p Mw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2xksyqfuwd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 23 Jan 2020 04:51:53 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00N4mjAQ087006
        for <linux-xfs@vger.kernel.org>; Thu, 23 Jan 2020 04:51:52 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 2xpt6ndpem-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 23 Jan 2020 04:51:52 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 00N4ppcx028553
        for <linux-xfs@vger.kernel.org>; Thu, 23 Jan 2020 04:51:51 GMT
Received: from kili.mountain (/129.205.23.165)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 22 Jan 2020 20:51:51 -0800
Date:   Thu, 23 Jan 2020 07:51:44 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Subject: [bug report] xfs: streamline xfs_attr3_leaf_inactive
Message-ID: <20200123045144.ue4mbfoswd4xj3ua@kili.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: NeoMutt/20170113 (1.7.2)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9508 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=670
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001230040
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9508 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=726 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001230040
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hello Darrick J. Wong,

The patch 0bb9d159bd01: "xfs: streamline xfs_attr3_leaf_inactive"
from Jan 14, 2020, leads to the following static checker warning:

	fs/xfs/xfs_attr_inactive.c:122 xfs_attr3_leaf_inactive()
	error: uninitialized symbol 'error'.

fs/xfs/xfs_attr_inactive.c
    90          struct xfs_attr_leaf_entry      *entry;
    91          struct xfs_attr_leaf_name_remote *name_rmt;
    92          int                             error;
                                                ^^^^^

    93          int                             i;
    94  
    95          xfs_attr3_leaf_hdr_from_disk(mp->m_attr_geo, &ichdr, leaf);
    96  
    97          /*
    98           * Find the remote value extents for this leaf and invalidate their
    99           * incore buffers.
   100           */
   101          entry = xfs_attr3_leaf_entryp(leaf);
   102          for (i = 0; i < ichdr.count; entry++, i++) {

Smatch complains that we might not enter this loop or maybe we always
hit a continue statement.

   103                  int             blkcnt;
   104  
   105                  if (!entry->nameidx || (entry->flags & XFS_ATTR_LOCAL))
   106                          continue;
   107  
   108                  name_rmt = xfs_attr3_leaf_name_remote(leaf, i);
   109                  if (!name_rmt->valueblk)
   110                          continue;
   111  
   112                  blkcnt = xfs_attr3_rmt_blocks(dp->i_mount,
   113                                  be32_to_cpu(name_rmt->valuelen));
   114                  error = xfs_attr3_rmt_stale(dp,
   115                                  be32_to_cpu(name_rmt->valueblk), blkcnt);
   116                  if (error)
   117                          goto err;
   118          }
   119  
   120          xfs_trans_brelse(*trans, bp);
   121  err:
   122          return error;

Possibly uninitialized

   123  }

regards,
dan carpenter
