Return-Path: <SRS0=oH8U=3G=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF359C33CB1
	for <linux-xfs@archiver.kernel.org>; Fri, 17 Jan 2020 06:23:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A0D0420748
	for <linux-xfs@archiver.kernel.org>; Fri, 17 Jan 2020 06:23:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="MgKy5G0y"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726827AbgAQGXp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 17 Jan 2020 01:23:45 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:53514 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726151AbgAQGXo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 17 Jan 2020 01:23:44 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00H68KuA166669;
        Fri, 17 Jan 2020 06:23:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : mime-version : content-type :
 content-transfer-encoding; s=corp-2019-08-05;
 bh=iS7iQAY7oAOVojpt8hwChsh02RhXjnwHGf64l1hZpP0=;
 b=MgKy5G0y9boYEdyAv0XOYvXpIVBNc5ZKdggHNiFZbgfQ5KtWvwQOYRjhEZZyqU9I9XLs
 6pSxwMq0TqYMXI4vX/wS68/wVs2golNcOPGRE4P3Qkj3/gUGRYxcoA7bbWh9SoK7oTJX
 BpaV9HXDmSVDRRcVZsCHAJmEs79HLS5g6bbQgbRCF9S0+Ks5GZE2NxQ63WK/Jp41q4Hu
 DUNaQ1/yM041X9yitj67h3GgqIDbnMEtRHMehwv2csOs7nqv8s1KhXdq2BKT/xIyCvMm
 WJvGmUxitH8UQgEWPa/G8iMVO+mv0DGGT6GkYhRPHwpe5/BCgbuNsQ5iJAopf3qJuMNX 1w== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2xf73yxu5s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 17 Jan 2020 06:23:37 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00H68uiA162010;
        Fri, 17 Jan 2020 06:23:36 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 2xk24eejex-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 17 Jan 2020 06:23:36 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 00H6NXdf002341;
        Fri, 17 Jan 2020 06:23:34 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 16 Jan 2020 22:23:33 -0800
Subject: [PATCH v2 00/11] xfs: make buffer functions return error codes
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org
Date:   Thu, 16 Jan 2020 22:23:31 -0800
Message-ID: <157924221149.3029431.1461924548648810370.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9502 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001170048
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9502 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001170048
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

This time around I dug further into the TRYLOCK callers, though I haven't
yet rearranged the io error reporting while I determine whether there's
enough of a pattern to refactor.

This has been lightly tested with fstests.  Enjoy!
Comments and questions are, as always, welcome.

--D
