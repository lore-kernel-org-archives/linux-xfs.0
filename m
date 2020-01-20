Return-Path: <SRS0=roPR=3J=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72689C32771
	for <linux-xfs@archiver.kernel.org>; Mon, 20 Jan 2020 22:56:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 39BCF22522
	for <linux-xfs@archiver.kernel.org>; Mon, 20 Jan 2020 22:56:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="RZk7m7sf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726752AbgATW4i (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 20 Jan 2020 17:56:38 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:46832 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726607AbgATW4i (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 20 Jan 2020 17:56:38 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00KMuWjs038129;
        Mon, 20 Jan 2020 22:56:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : mime-version : content-type :
 content-transfer-encoding; s=corp-2019-08-05;
 bh=gesP3lfqXRagrMo4dagsIltsi87WtfPx0FJsGxNOurA=;
 b=RZk7m7sf0SE7kb8dt9FWjX5/KIEOOVPp6HbTnlQ1frqWHC/5BTBGcX8iRgFgV4OpJRp4
 YqaUL3tF4kMMoxuw4lHyuru3gtnNB3PMcf/wpv7GQnqr02zOKsCxX/7IDpDLfUnVQ7Zv
 BF1uk+R4tDPQI+7CEm6Eij0LQ0eFABRUzg6wA4jv128AgZp+hwMc40Gn8zx87KaKOFll
 YVpbSDsyCJqMu6tLLrJ/0jBu1aN9LnZZhemypG91KVX6/eYJzPsWcW+6EcWvlCKK+jKx
 /dGIhpF/xAuE6GSxtFsn3pOMIhHIR/iQB9vCwU1vmaMsfPi+ahIypeqHK2bZgqaozj6X lw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 2xksyq1nr3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 20 Jan 2020 22:56:32 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00KMnDou060613;
        Mon, 20 Jan 2020 22:56:32 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 2xmc656n5b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 20 Jan 2020 22:56:32 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 00KMuUgT012001;
        Mon, 20 Jan 2020 22:56:30 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 20 Jan 2020 14:56:30 -0800
Subject: [PATCH v3 00/13] xfs: make buffer functions return error codes
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org, david@fromorbit.com
Date:   Mon, 20 Jan 2020 14:56:29 -0800
Message-ID: <157956098906.1166689.13651975861399490259.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9506 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=848
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001200192
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9506 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=902 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001200192
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
EAGAIN checks; and then we refactor the code that handles buffer state
changes and logging after an IO/verifier error so that we handle all of
that from within the buffer functions instead of open-coding that
everywhere.

This has been lightly tested with fstests.  Enjoy!
Comments and questions are, as always, welcome.

--D
