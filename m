Return-Path: <SRS0=JklA=3N=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DEB17C2D0CE
	for <linux-xfs@archiver.kernel.org>; Fri, 24 Jan 2020 05:19:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A133D2071A
	for <linux-xfs@archiver.kernel.org>; Fri, 24 Jan 2020 05:19:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="GvmyMZLN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727025AbgAXFTH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 24 Jan 2020 00:19:07 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:54158 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726296AbgAXFTG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 24 Jan 2020 00:19:06 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00O5II2h021874;
        Fri, 24 Jan 2020 05:18:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : mime-version : content-type :
 content-transfer-encoding; s=corp-2019-08-05;
 bh=uLI72duFXdNrKEaOw7av6YOSZbUHo/3mP5ow1okP1VQ=;
 b=GvmyMZLNFDu2AJWimER7TOYYZNfAuomLnTQDhHI5T+J18zZuvGl56q4fwTAzkNyZEsBM
 kmE5cMdtloegxv30GDGqlclpfcaZV67/NWXzwQfFdEBn8joSjZHyV8jNWJIl6nuGAuYL
 gWhXbBKENzIiYkJRcunc61oY28HnKwlkVVrKUCAx402rpm147usiXeCBtqngO8FNpPmN
 ySwXVlfj2NFDz1UyIEiVJyHRLX+4SIvIIF2NsIbIgzXYVS1nWu0x5xsGfEWI8Qu5/Num
 Hbp6GUtcZ4DE+EZh0MKmOKcMBqcmhgspYuTedhwDSWVnpdi4L2K4tmvUDbmLZHN8HOR2 Bg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2xksyqpxmv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 24 Jan 2020 05:18:58 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00O5IHh1031198;
        Fri, 24 Jan 2020 05:18:57 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 2xqmwcksss-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 24 Jan 2020 05:18:57 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 00O5Ivqw020398;
        Fri, 24 Jan 2020 05:18:57 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 23 Jan 2020 21:18:57 -0800
Subject: [PATCH v5 00/12] xfs: make buffer functions return error codes
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org, david@fromorbit.com
Date:   Thu, 23 Jan 2020 21:18:56 -0800
Message-ID: <157984313582.3139258.1136501362141645797.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9509 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001240042
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9509 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001240042
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

In v5 of this series I rearranged some of the patches so that the return
type conversions go from the lower levels of the buffer code upwards.
This eases some of the awkward warts of previous submissions.

This has been lightly tested with fstests.  Enjoy!
Comments and questions are, as always, welcome.

--D
