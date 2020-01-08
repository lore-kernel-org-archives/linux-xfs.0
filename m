Return-Path: <SRS0=Z9mQ=25=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06F54C00523
	for <linux-xfs@archiver.kernel.org>; Wed,  8 Jan 2020 04:17:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CCB34206ED
	for <linux-xfs@archiver.kernel.org>; Wed,  8 Jan 2020 04:17:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="VLNUCl2F"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726210AbgAHERi (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 7 Jan 2020 23:17:38 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:58490 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725908AbgAHERh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 7 Jan 2020 23:17:37 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 0084EEFW048999
        for <linux-xfs@vger.kernel.org>; Wed, 8 Jan 2020 04:17:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : mime-version : content-type :
 content-transfer-encoding; s=corp-2019-08-05;
 bh=KGvp7vPHqV0BIniiXQ18ig/cPFzLoFVrIjYEGA6gi0Q=;
 b=VLNUCl2Fl9DW4McyOqtZqyP1sEmsQQTKfVgzWoqsL0rNcxY3kimkzpsKIhjNySohwUKQ
 GqYtXNCWHfOrARiNNYgIvY8eV0gPoIrlXc6aTw0KIf0JORbtmMWgVClKLydReEv3FwwC
 SHZR+Xh2c7CxGE1i5eH84m3F7EZyGiBPYzmmu6KSM5WvkOc1fjsgHSlOGF1NldlkGOnd
 J+dzt3jS8+WO/j5/yYT5IGcASR/8GsrEwJMRz8iPt9LySeWiA+Ayyw6poCkpZ5GpMNKS
 b0H+AJheDPEa6xvgGSLJg2yr3LoMK3/FdfVX6gTAV6MntPd2bOjVUderxmeY/oyWHcWd wQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2xaj4u1k21-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 08 Jan 2020 04:17:36 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 0084EEBI064927
        for <linux-xfs@vger.kernel.org>; Wed, 8 Jan 2020 04:17:36 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 2xcpcrrwyu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 08 Jan 2020 04:17:36 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0084HYc0007690
        for <linux-xfs@vger.kernel.org>; Wed, 8 Jan 2020 04:17:34 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 07 Jan 2020 20:17:34 -0800
Subject: [PATCH v2 0/3] xfs: fix maxbytes problems on 32-bit systems
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 07 Jan 2020 20:17:32 -0800
Message-ID: <157845705246.82882.11480625967486872968.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9493 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=715
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001080036
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9493 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=795 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001080036
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
