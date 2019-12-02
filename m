Return-Path: <SRS0=7G1E=ZY=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40953C432C0
	for <linux-xfs@archiver.kernel.org>; Mon,  2 Dec 2019 17:37:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 12A1320640
	for <linux-xfs@archiver.kernel.org>; Mon,  2 Dec 2019 17:37:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="rhpuOGZM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727842AbfLBRhR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 2 Dec 2019 12:37:17 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:52648 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727758AbfLBRhR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 2 Dec 2019 12:37:17 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xB2HZH6R035920;
        Mon, 2 Dec 2019 17:37:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : mime-version : content-type :
 content-transfer-encoding; s=corp-2019-08-05;
 bh=lVJTHBYIJNoUnoX3erqLgWHWyrCCe2vyPj07W9XBZvA=;
 b=rhpuOGZMYaWi8peoWVf2lAjn1ZLfV7EVKxjoot/OstYweuggWwRKi7Qn/RsAQAV4D8ka
 yLbFvaq8ssBZMYJGLzUYdUNB953L3zb4/dRXFAucAlwtJrE9PRfvIIPdYKGRSrfkU3Vf
 Hjaihuj0jgCVPYLLOriUGS3v6AbnvPz+GRUPhRi50GaQNvFJGGKhTh58k5W1P3fmlACw
 uMP/gD7K3Jtpq9Zlds4bzoH22ikdqpQZcROU2ILcFbXaCir6G372ohzu/mS5/T02gauP
 RU8Kwtfy4IGx7Vc/kl2x60fnEp035DT0TPlbbSDqRivNIwKLpMSSui7ngGPC4I6Bkd5q dQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2wkh2r1hqh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 02 Dec 2019 17:37:14 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xB2HYKtW190911;
        Mon, 2 Dec 2019 17:37:14 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 2wn4qn2j6f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 02 Dec 2019 17:37:14 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xB2HbD8Y012788;
        Mon, 2 Dec 2019 17:37:13 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 02 Dec 2019 09:37:13 -0800
Subject: [PATCH 0/2] xfs_admin: unify online/offline fs label setting
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 02 Dec 2019 09:37:12 -0800
Message-ID: <157530823239.128859.15834274920423410063.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9459 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=647
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1912020148
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9459 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=710 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1912020149
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

Here are two fixes for the xfs_admin script.  The first enables callers
to pass an external log device, because xfs_db requires that to work on
filesystems that do not have an internal log.

The second patch enables xfs_admin to call xfs_io, which is then used to
pass label get and set commands (-l and -L) to the kernel (via xfs_io) if
the filesystem is mounted.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D
