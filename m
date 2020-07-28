Return-Path: <SRS0=dxv4=BH=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7950AC433E3
	for <linux-xfs@archiver.kernel.org>; Tue, 28 Jul 2020 11:58:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 51E14206D7
	for <linux-xfs@archiver.kernel.org>; Tue, 28 Jul 2020 11:58:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="xjKWwMZq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728364AbgG1L6w (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 28 Jul 2020 07:58:52 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:58690 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728129AbgG1L6w (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 28 Jul 2020 07:58:52 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06SBvshP046593
        for <linux-xfs@vger.kernel.org>; Tue, 28 Jul 2020 11:58:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2020-01-29;
 bh=+Yhm6uljOZ1ZygJZTARUeL4mynmOR4OiGWSrSvONlFY=;
 b=xjKWwMZqL+qIp2q/7ndl59tDY8BI6uAXwIBFYxou6evbrwnyLGQCoOJx+9ymVec0OC3b
 Gj7Lm/JYOn5fgjO2FUcIMN/+OjMn4nwNQ2e7uYrvnD0kBCdi1+hHgOla2J1UWieXjvve
 W8KcSvFR70F2pldGrILZACrlWaWhKZU8AdzR1RE6EGx3brwfEcyf8o65jm2H1G1uIY3Q
 VldiTTgZz7ikhLRNhZMrt5fZt+uLjo57hdh4PDRiaMg4gEe9Ywy4nBuRgYLO0y65kamh
 IOMRO9NZLnJMFyRBnc6D2vEG2klCslCtmSBy3cMS3oKPku2+qIj6O4Re0XnlYG5x7IzM hA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 32hu1j70u9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Tue, 28 Jul 2020 11:58:26 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06SBwPBZ088513
        for <linux-xfs@vger.kernel.org>; Tue, 28 Jul 2020 11:58:26 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 32hu5tn0w9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 28 Jul 2020 11:58:26 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 06SBvwnZ011435
        for <linux-xfs@vger.kernel.org>; Tue, 28 Jul 2020 11:58:01 GMT
Received: from mwanda (/41.57.98.10)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 28 Jul 2020 04:57:57 -0700
Date:   Tue, 28 Jul 2020 14:57:52 +0300
From:   <dan.carpenter@oracle.com>
To:     allison.henderson@oracle.com
Cc:     linux-xfs@vger.kernel.org
Subject: [bug report] xfs: Add xfs_has_attr and subroutines
Message-ID: <20200728115752.GA426300@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9695 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=11 adultscore=0
 bulkscore=0 malwarescore=0 mlxscore=0 spamscore=0 mlxlogscore=597
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007280091
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9695 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 mlxlogscore=570
 lowpriorityscore=0 malwarescore=0 clxscore=1011 mlxscore=0 impostorscore=0
 phishscore=0 adultscore=0 suspectscore=11 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007280091
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hello Allison Collins,

The patch cfe3d8821c6f: "xfs: Add xfs_has_attr and subroutines" from
Jul 20, 2020, leads to the following Smatch warning:

	fs/xfs/libxfs/xfs_attr.c:1431 xfs_attr_node_get()
	warn: variable dereferenced before check 'state' (see line 1426)

fs/xfs/libxfs/xfs_attr.c
  1398  STATIC int
  1399  xfs_attr_node_get(
  1400          struct xfs_da_args      *args)
  1401  {
  1402          struct xfs_da_state     *state;
  1403          struct xfs_da_state_blk *blk;
  1404          int                     i;
  1405          int                     error;
  1406  
  1407          trace_xfs_attr_node_get(args);
  1408  
  1409          /*
  1410           * Search to see if name exists, and get back a pointer to it.
  1411           */
  1412          error = xfs_attr_node_hasname(args, &state);
  1413          if (error != -EEXIST)
  1414                  goto out_release;
                        ^^^^^^^^^^^^^^^^
state can be NULL.

  1415  
  1416          /*
  1417           * Get the value, local or "remote"
  1418           */
  1419          blk = &state->path.blk[state->path.active - 1];
  1420          error = xfs_attr3_leaf_getvalue(blk->bp, args);
  1421  
  1422          /*
  1423           * If not in a transaction, we have to release all the buffers.
  1424           */
  1425  out_release:
  1426          for (i = 0; i < state->path.active; i++) {
                                ^^^^^^^^^^^^^^^^^^
Dereference

  1427                  xfs_trans_brelse(args->trans, state->path.blk[i].bp);
  1428                  state->path.blk[i].bp = NULL;
  1429          }
  1430  
  1431          if (state)
                    ^^^^^
To late.

  1432                  xfs_da_state_free(state);
  1433          return error;
  1434  }

regards,
dan carpenter
