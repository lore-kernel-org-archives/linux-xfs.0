Return-Path: <SRS0=Nxvu=26=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE6E5C282DD
	for <linux-xfs@archiver.kernel.org>; Thu,  9 Jan 2020 18:44:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B8A6C2072E
	for <linux-xfs@archiver.kernel.org>; Thu,  9 Jan 2020 18:44:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="c1M1mmVT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729409AbgAISoV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 9 Jan 2020 13:44:21 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:51008 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727980AbgAISoV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 9 Jan 2020 13:44:21 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 009IdEmq130533
        for <linux-xfs@vger.kernel.org>; Thu, 9 Jan 2020 18:44:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : mime-version : content-type :
 content-transfer-encoding; s=corp-2019-08-05;
 bh=KGvp7vPHqV0BIniiXQ18ig/cPFzLoFVrIjYEGA6gi0Q=;
 b=c1M1mmVTXZqkliHTZMzK6MA4xk6K6XIUEdzvMh9qGTVZJfDdhpJFWoQMwtUXSucrvdFW
 USs4jGBJieSA7jg9oslLahVSbaWP5fB2MBK/7FB0LoR163RrqOIPvA0FeZai/b5X8x3k
 kQ5qj837BieHY66mKmAUNgy/EFaotTSsi+rbaDKpVuXTUIqc0LlRoCVSAnT/wcAVn5YC
 Y3alMFXmTLFcrMzlY3Fd5o63FMkDjfzK74OU8Z5ItAPkkoHxAjg2ezlpYKN3Lq+jqzkn
 foI8ZgIAtCdQ+Og/OjtOoFSJFmV4K4+d6dQmM0JArb5QapO7GJY1hiohE+rQFTV1KWvT Ww== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 2xajnqcrr2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 09 Jan 2020 18:44:19 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 009IdaA9050595
        for <linux-xfs@vger.kernel.org>; Thu, 9 Jan 2020 18:44:19 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 2xdj4r949h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 09 Jan 2020 18:44:19 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 009IiHQP030196
        for <linux-xfs@vger.kernel.org>; Thu, 9 Jan 2020 18:44:18 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 09 Jan 2020 10:44:17 -0800
Subject: [PATCH v3 0/3] xfs: fix maxbytes problems on 32-bit systems
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Thu, 09 Jan 2020 10:44:16 -0800
Message-ID: <157859545662.163942.11245536419486956862.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9495 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=718
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001090154
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9495 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=798 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001090154
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

Here's a series of patches to fix some problems related to s_maxbytes
that I found by running fstests in a 32-bit VM.  The first step is to
fix bunmapi during inactivation so that it cleans out /all/ the blocks
of an unlinked file instead of leaking them; and the second is to fix
the s_maxbytes computation to avoid setting a limit larger than what the
pagecache supports.

This has been lightly tested with fstests.  Enjoy!
Comments and questions are, as always, welcome.

--D
