Return-Path: <SRS0=FA12=W2=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80966C3A59F
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Aug 2019 00:28:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4625121874
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Aug 2019 00:28:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="LweIiZho"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726988AbfH3A17 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 29 Aug 2019 20:27:59 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:34556 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726825AbfH3A17 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 29 Aug 2019 20:27:59 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7U0ROkl124739;
        Fri, 30 Aug 2019 00:27:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to :
 subject : message-id : mime-version : content-type; s=corp-2019-08-05;
 bh=vwYDtLZZYmhYEjqEJ2D8o0b7hy8AuzjU53SxSoSaNz4=;
 b=LweIiZho//EcL1LnVovjepxAD+byGzBnZAN4b5//A7Xsw+UTr7niuGmhu9KNukaF29Tj
 TWYXO+QbwzTSIYzf5G7IuJ+TRidCrqxa5tXXsy3Sx+PIFLVb7YnyFF9eQ/92vmBsoAL8
 nzKB/JteiS0YdqNtLgsFGSRes+VBI/nQetRETOBi4btF0ht7s6RyuhFdmN12QwdM1Vnn
 1iR6E1HG0aaua7forXkklmUtLNAk/LhY1FiLnW6V+X2q2z/9KiL389MmEr5k5sOh8xu6
 Nt8CeMGu4KIhpxoCXP48GV7aSGqXLhG9GnuB0PQpV8zQxpdDbxZQKKoaLe/09LWGriKw Kg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2ups7c80hh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 30 Aug 2019 00:27:56 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7U0NhlM097709;
        Fri, 30 Aug 2019 00:25:55 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 2uphauf0j8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 30 Aug 2019 00:25:55 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x7U0Psvp004889;
        Fri, 30 Aug 2019 00:25:54 GMT
Received: from localhost (/10.145.178.11)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 29 Aug 2019 17:25:54 -0700
Date:   Thu, 29 Aug 2019 17:25:54 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     xfs <linux-xfs@vger.kernel.org>, Dave Chinner <david@fromorbit.com>
Subject: [PATCH v2 0/2] xfs: get rid of _ITER_{ABORT,CONTINUE}
Message-ID: <20190830002554.GT5354@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9364 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=508
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908300001
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9364 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=576 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908300001
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

I have recently realized that the _ITER_CONTINUE/_ITER_ABORT defines are
a giant thinko -- the _CONTINUE variants map to zero, and -ECANCELED can
handle the _ABORT case just fine.  This series scrapes both of them out
of the kernel.

In this v2 of the patch we add comments to point out the special meaning
of 0 and -ECANCELED, which replace the _ITER_* defines.

--D
