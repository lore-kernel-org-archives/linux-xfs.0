Return-Path: <SRS0=A2Vo=7C=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B2D7C433E0
	for <linux-xfs@archiver.kernel.org>; Wed, 20 May 2020 01:50:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 53B5C20708
	for <linux-xfs@archiver.kernel.org>; Wed, 20 May 2020 01:50:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Hq3gZH8K"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728012AbgETBux (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 19 May 2020 21:50:53 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:48244 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726348AbgETBuw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 19 May 2020 21:50:52 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04K1lbBm066047;
        Wed, 20 May 2020 01:50:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : mime-version : content-type :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=hfH8aXlqiLVI6A2qPRAT4yuihGY0LcnSfdCzCpJGdt0=;
 b=Hq3gZH8KTJ4PVpCJEMU1I6vOg9zFe5Ad0z12DAj6AVSuA1jSKZKVegb5jW6ACYU5wN6u
 Psb9QFaw/QUuJ4BHCV7lkL2FnjamG5BQYD3S8lCgMti1pV4pgpWmvgbBYPA7UHhTnc9b
 QlPsvJHxuhkaS0gxKQDJH8cnWAORl1fMsZy1kd3dzqw/ovmdkbUT+/WiLrPFidEpkOEI
 QFRiCKyXR9o7U7EEJyNUyL9xn1rszDcBinhE21EMOwG1t6N2CNpaR+uAuZ7TIJl9En17
 RpcQIneU4PgAlX/25hnhXwXKjmXrAivp5/drfAe+3Y1okZQ8CDbhGYuDLS0xin9rL7bK iw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 3128tngfbq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 20 May 2020 01:50:46 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04K1n2tr140982;
        Wed, 20 May 2020 01:50:45 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 312t35yrdy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 20 May 2020 01:50:45 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 04K1oi87026448;
        Wed, 20 May 2020 01:50:44 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 19 May 2020 18:50:43 -0700
Subject: [PATCH v5 0/9] xfs_repair: use btree bulk loading
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     Eric Sandeen <sandeen@redhat.com>, linux-xfs@vger.kernel.org,
        bfoster@redhat.com
Date:   Tue, 19 May 2020 18:50:42 -0700
Message-ID: <158993944270.983175.4120094597556662259.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9626 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 mlxlogscore=999
 phishscore=0 mlxscore=0 malwarescore=0 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005200012
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9626 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 bulkscore=0 spamscore=0
 clxscore=1015 cotscore=-2147483648 suspectscore=0 lowpriorityscore=0
 adultscore=0 phishscore=0 mlxlogscore=999 mlxscore=0 priorityscore=1501
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2005200012
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

In preparation for landing the online fs repair feature, it was
necessary to design a generic btree bulk loading module that it could
use.  Fortunately, xfs_repair has four of these (for the four btree
types), so I synthesized one generic version and pushed it into the
kernel libxfs in 5.7.

That being done, port xfs_repair to use the generic btree bulk loader.
In addition to dropping a lot of code from xfs_repair, this also enables
us to control the fullness of the tree nodes in the rebuilt indices for
testing.

For v5 I rebased the support code from my kernel tree, and fixed some
of the more obvious warts that Brian found in v4.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=repair-bulk-load
