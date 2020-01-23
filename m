Return-Path: <SRS0=OHiL=3M=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44D79C33CAA
	for <linux-xfs@archiver.kernel.org>; Thu, 23 Jan 2020 07:42:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1626224125
	for <linux-xfs@archiver.kernel.org>; Thu, 23 Jan 2020 07:42:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Czpaxmk2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725818AbgAWHl7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 23 Jan 2020 02:41:59 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:56274 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725777AbgAWHl7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 23 Jan 2020 02:41:59 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00N7c9Md170827;
        Thu, 23 Jan 2020 07:41:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : mime-version : content-type :
 content-transfer-encoding; s=corp-2019-08-05;
 bh=gmGbRRIzAEHWnyRb5ye+zzdPuHeEFJH9mEkE+FG4RHw=;
 b=Czpaxmk2ixgMDvTGDH17NQpdibqSs3d3aXE8Xrcc13kcKdxZhu8GSoWqb/R+Djz7MVVZ
 capYcvpTPQXJ6E8AivSEa3ilf5ifCKbeQBlDOxLumdaw+ZC3DH8oOKPYUuuclPD1/d7V
 gPEcO0C0baWNp1BO1ouelecp2pYdcKcemogP608KqlnSWq8qUDul0L55ZyOFZhBlgr/c
 4jujv+BlLJLI59FdcrMmyCl6levw1TneEBoEC/DqFcdaGSksXVEF3+koNV/KTTtzRO1N
 chrvxUEecB8MhvmaNX2G/2fJNMsO+sDKHQPseegsEzzsRDtMX4jxKs/WUGIO8vDGCZ+F Bg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2xkseurkru-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 23 Jan 2020 07:41:52 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00N7cvx3163794;
        Thu, 23 Jan 2020 07:41:52 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 2xpq7m4q6t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 23 Jan 2020 07:41:52 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 00N7fpRX017839;
        Thu, 23 Jan 2020 07:41:51 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 22 Jan 2020 23:41:51 -0800
Subject: [PATCH v4 00/12] xfs: make buffer functions return error codes
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org, david@fromorbit.com
Date:   Wed, 22 Jan 2020 23:41:50 -0800
Message-ID: <157976531016.2388944.3654360225810285604.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9508 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001230065
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9508 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001230065
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

Let's fix all the xfs read/get buffer functions to return the usual
integer error codes and pass the buffer pointer as a out-argument.  This
makes it so that we can return useful error output instead of making
callers infer ENOMEM or EAGAIN or whatever other reality they crave from
the NULL pointer that they get when things don't go perfectly.

FWIW, all XBF_TRYLOCK callers must now trigger retries if they receive
EAGAIN.  This may lead to a slight behavioral change in that TRYLOCK
callers will no longer retry for things like ENOMEM, though I didn't see
any obvious changes in user-visible behavior when running fstests.

After finishing the error code conversion, we straighten out the TRYLOCK
callers to remove all this null pointer checks in favor of explicit
EAGAIN checks; and then we change the buffer IO/corruption error
reporting so that we report whoever called the buffer code even when
reading a buffer in transaction context.

This has been lightly tested with fstests.  Enjoy!
Comments and questions are, as always, welcome.

--D
