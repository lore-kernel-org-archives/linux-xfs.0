Return-Path: <SRS0=CuST=WZ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9444C3A59F
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Aug 2019 16:21:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8BB282339E
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Aug 2019 16:21:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="sezUp59y"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726784AbfH2QV0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 29 Aug 2019 12:21:26 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:40438 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726739AbfH2QVZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 29 Aug 2019 12:21:25 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7TGJ3vM050412
        for <linux-xfs@vger.kernel.org>; Thu, 29 Aug 2019 16:21:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to :
 subject : message-id : mime-version : content-type; s=corp-2019-08-05;
 bh=Tf1qOUxhDikqWTH4ZtDItu54I7CUoMqyUwo9C3Rog5I=;
 b=sezUp59yoDs0rtokSsFHpNxoYsQnacxXMyI+RW4hJlwxF8aR2lDg8ZGyXC88fMC4RwgZ
 QDKXNO86Vp4Iuaqsl4Gq4oHPgzCcZXSIVI1RPiwjZStMDBRIiJAZfnJHUYTrIKeJ9oji
 r7uMlTc9iBmQWXg28/fcDIZASMJE9Xi/++G7HiI1dOShM12gSAAr6zN+NgyFWUX/6JXJ
 KemGz5Yeeue414g5c5YU2iR5go0DA4SldiBP9g62XpfGOZqZMRgoV0+s3uf32o8S2SMA
 ZEVu/qOSIAPNv3sAaD8AIU6k9wMP8pe3PwXNvTO9W/TMYTD4H/q1/7pJ/mDsR3pXSR8j mQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2uphyc0318-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 29 Aug 2019 16:21:24 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7TGIx0J162674
        for <linux-xfs@vger.kernel.org>; Thu, 29 Aug 2019 16:21:24 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 2untev9kqk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 29 Aug 2019 16:21:24 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x7TGLNxC002598
        for <linux-xfs@vger.kernel.org>; Thu, 29 Aug 2019 16:21:23 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 29 Aug 2019 09:21:23 -0700
Date:   Thu, 29 Aug 2019 09:21:22 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     xfs <linux-xfs@vger.kernel.org>, darrick.wong@oracle.com
Subject: [PATCH 0/2] xfs: get rid of _ITER_{ABORT,CONTINUE}
Message-ID: <20190829162122.GH5354@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9364 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=534
 adultscore=1 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908290172
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9364 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=603 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908290172
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

I have recently realized that the _ITER_CONTINUE/_ITER_ABORT defines are
a giant thinko -- the _CONTINUE variants map to zero, and -ECANCELED can
handle the _ABORT case just fine.  This series scrapes both of them out
of the kernel.

--D
