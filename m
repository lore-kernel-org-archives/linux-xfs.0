Return-Path: <SRS0=PA6D=YP=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07398CA9EB9
	for <linux-xfs@archiver.kernel.org>; Tue, 22 Oct 2019 18:48:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CAC2020B7C
	for <linux-xfs@archiver.kernel.org>; Tue, 22 Oct 2019 18:48:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="pFrXJFrL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729696AbfJVSsy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 22 Oct 2019 14:48:54 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:45976 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732615AbfJVSsy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 22 Oct 2019 14:48:54 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9MIiCNX109501;
        Tue, 22 Oct 2019 18:48:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : mime-version : content-type :
 content-transfer-encoding; s=corp-2019-08-05;
 bh=FWMIsQ3A/FpzstVNrj/VHUjnk3svTLOwN7rW4DbplJE=;
 b=pFrXJFrL9/RRC1v3ioZ10GiWbNW2jbHsSQpox6YQDp65YCfMpwWPE/gzdyiZ9E0e6VbQ
 tzPFUVUaUdLyTFWb4Ho3f0jBULI6M3OHCc41C+UHv0b8LvVi3AnafNaPf2UwchhCJSox
 4u/6LgGoCxBggxLNwEdIahoov4IKg68P0lmbx01keCGle6owLn5pwSfCApWFKsiAPHwm
 678UG5vNU3ECP6iuqjkd3FBr26g+7ck3/CqSyBSUl5I1h0fzInfBshDg+f/XKjeJmprb
 wQImxsOPIhvykDwGHseF1NseviDKXiDtoNWf4MNhhEraJQvqq4WUHjAczlnM3QMi7L4T yg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2vqswtguyx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Oct 2019 18:48:51 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9MIhNmV125149;
        Tue, 22 Oct 2019 18:48:51 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 2vsx239rgk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Oct 2019 18:48:50 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x9MImo96030033;
        Tue, 22 Oct 2019 18:48:50 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 22 Oct 2019 11:48:49 -0700
Subject: [PATCH 0/7] xfs_scrub: clean up error classifications
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 22 Oct 2019 11:48:49 -0700
Message-ID: <157177012894.1460394.4672572733673534420.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9418 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910220156
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9418 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910220156
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

In reviewing how xfs_scrub classifies errors, I noticed that there were
numerous things that could be improved.

First, I fixed some of the error reports that were simply in the wrong
category.

Next, I cleaned up some of the internal logic and error class tables in
preparation for future patches.

Then, I noticed that corruptions and some of the runtime errors were
being munged into a single errors_found counter.  I made this the
explicit corruptions counter, which can be incremented via
str_corrupt().  I then changed str_error() to mean runtime errors.

Having done that, I was then able to reclassify some str_info calls that
are really reporting runtime errors and therefore should use str_error.

Finally, I introduce a new category of errors that are unfixable by
scrub, and assign to this class all the media errors since there's
nothing XFS can do.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=scrub-reclassify-errors
