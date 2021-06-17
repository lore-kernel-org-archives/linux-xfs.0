Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00CE6C2B9F4
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Jun 2021 14:23:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CB7A1613A9
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Jun 2021 14:23:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232013AbhFQOZP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 17 Jun 2021 10:25:15 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:23916 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231654AbhFQOZP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 17 Jun 2021 10:25:15 -0400
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15HE6nbd000994
        for <linux-xfs@vger.kernel.org>; Thu, 17 Jun 2021 14:23:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2020-01-29;
 bh=GQmxtQ0eau1e5fjPojt0ktyr+e+URkwW+D1Fe0fXzmg=;
 b=x5A+ODT5EwbaSm3XBueMz5Rzgi1n9ZKJxI3D6tqCL0TJ73/fiWLVTPExq1vKhrbrME7t
 AxLtbgrs7JEuaL0Fn2IUfwb+YxGOAjU3DFECwCaPxRfm2LefqSPGeU18CMropCzxmqDh
 3PFSCQnZbW5PBHYJFm5+G0wdzbS947qFWHzb144oGnFopESlPvF3VKV+Rl6fBMvkUWy3
 p9fIXVfGxTfzeEb2XptAeQ1pL2G+y20L/rMO394/NaRREX4nn4OSEx2gABz9fjE/SlPm
 nOsuUH6q/iQiiLQ9aomSbKGR2aoW3puEzcQtFjXoOcRe3buJL8ex+R8Nas+geP+LTlUv OA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 397mpthynd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 17 Jun 2021 14:23:07 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 15HEBYvY022122
        for <linux-xfs@vger.kernel.org>; Thu, 17 Jun 2021 14:23:06 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by userp3020.oracle.com with ESMTP id 396waxpdy5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 17 Jun 2021 14:23:06 +0000
Received: from userp3020.oracle.com (userp3020.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 15HEKwrR048689
        for <linux-xfs@vger.kernel.org>; Thu, 17 Jun 2021 14:23:06 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 396waxpdxu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 17 Jun 2021 14:23:06 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 15HEN5Z1031755;
        Thu, 17 Jun 2021 14:23:05 GMT
Received: from mwanda (/102.222.70.252)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 17 Jun 2021 07:23:04 -0700
Date:   Thu, 17 Jun 2021 17:22:59 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     allison.henderson@oracle.com
Cc:     Allison Henderson <allison.henderson@oracle.com>,
        linux-xfs@vger.kernel.org
Subject: [bug report] xfs: Add delay ready attr remove routines
Message-ID: <YMtaw9vsW69xGseU@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Proofpoint-GUID: eid6zDV5JfYTk66icdMDRF-9jLz444ic
X-Proofpoint-ORIG-GUID: eid6zDV5JfYTk66icdMDRF-9jLz444ic
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hello Allison Henderson,

The patch 2b74b03c13c4: "xfs: Add delay ready attr remove routines"
from Apr 26, 2021, leads to the following static checker warning:

	fs/xfs/libxfs/xfs_attr.c:1481 xfs_attr_remove_iter()
	error: uninitialized symbol 'error'.

fs/xfs/libxfs/xfs_attr.c
  1469                          return -EAGAIN;
  1470                  }
  1471  
  1472                  /* fallthrough */
  1473          case XFS_DAS_RM_SHRINK:
  1474                  /*
  1475                   * If the result is small enough, push it all into the inode.
  1476                   * This is our final state so it's safe to return a dirty
  1477                   * transaction.
  1478                   */
  1479                  if (xfs_attr_is_leaf(dp))
  1480                          error = xfs_attr_node_shrink(args, state);
  1481                  ASSERT(error != -EAGAIN);

Not initialized on the else path.  It should be zero right?

  1482                  break;
  1483          default:
  1484                  ASSERT(0);
  1485                  error = -EINVAL;
  1486                  goto out;
  1487          }
  1488  out:
  1489          if (state)
  1490                  xfs_da_state_free(state);
  1491          return error;
                ^^^^^^^^^^^^
returned here.

  1492  }

regards,
dan carpenter
