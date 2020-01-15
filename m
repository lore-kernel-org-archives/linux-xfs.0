Return-Path: <SRS0=S7Al=3E=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C32ACC32771
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Jan 2020 17:03:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 989C324671
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Jan 2020 17:03:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="XTXwcEU3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729043AbgAORDu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 15 Jan 2020 12:03:50 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:41414 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726574AbgAORDt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 15 Jan 2020 12:03:49 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00FGhxTt037403;
        Wed, 15 Jan 2020 17:03:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : mime-version : content-type :
 content-transfer-encoding; s=corp-2019-08-05;
 bh=p31igky5PgUSfj/p1Rn2FTTzqH6fA/ND+d9n9hQPpaY=;
 b=XTXwcEU3/GD8R7KcoxYEyEwabMZUn6ghpMPdDCsEIIG1N/WBgR8k90ZsiTsy4qg7sFg/
 7zA5JAbbJDutdNxoluE9NiMZeIy0oVO15cYo0YyG+l628JZD6IO07em95mz8o6lz4Czf
 twWG6q4oLuRNllHQpZ6TkQAoY3R5cxItaCaLq7WVBN/0glvOJJHpJdViM0XR4x3M4+ve
 BHADAN3ez8uZqWEOJcwKvvNBzva+LfFFkqomAo1zEF/8Z9rcODeag19Lxu7y3zGI4XT4
 yM53bfLiZmsRq+18nIRkT2Bcn5Ew9dzNHW3aBqFLrDwIJiTJKY4qldQn5/h05z1aLQPm 2Q== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2xf74sdeba-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Jan 2020 17:03:42 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00FGhwVY021561;
        Wed, 15 Jan 2020 17:03:42 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 2xj1prgnfc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Jan 2020 17:03:41 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 00FH3e8T023697;
        Wed, 15 Jan 2020 17:03:40 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 15 Jan 2020 09:03:40 -0800
Subject: [PATCH 0/9] xfs: make buffer functions return error codes
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org
Date:   Wed, 15 Jan 2020 09:03:39 -0800
Message-ID: <157910781961.2028217.1250106765923436515.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9501 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=903
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001150129
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9501 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=979 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001150129
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

This has been lightly tested with fstests.  Enjoy!
Comments and questions are, as always, welcome.

--D
