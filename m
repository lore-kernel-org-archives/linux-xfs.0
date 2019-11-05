Return-Path: <SRS0=V6/9=Y5=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 381E8CA9ED3
	for <linux-xfs@archiver.kernel.org>; Tue,  5 Nov 2019 00:51:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 06A7520717
	for <linux-xfs@archiver.kernel.org>; Tue,  5 Nov 2019 00:51:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="pPnpUzGK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729737AbfKEAvh (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 4 Nov 2019 19:51:37 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:57576 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729035AbfKEAvh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 4 Nov 2019 19:51:37 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA50nBgG131164;
        Tue, 5 Nov 2019 00:51:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=13zjd7XibsCkYNn7GvS/qiHQu/IPcNeEqAG9SlQRHKA=;
 b=pPnpUzGK4xzdrodALsZyBhp3AcaO+yt+nXnGrGkncpWa3L7Wh65UogVqPyPzWy/XeRwp
 2RcMq9PIbgJCmevIsXeI+PrUieu9pg+fc2jjfMKR3S7BlDxSw5Kv/mu8Jbt2/MTfulJc
 bZvCwdwZMqzkI6sH+HWeS4V/n3meBtwZEmJjDN61nDDOiIFge61WNfRcvAO4hmVbiyyG
 sq6CKpdjomPKo8jCYCodQZJuaVTEfA6fX4o+TH2Al7t+FRRsO9SJcV/magsnRSUrv15b
 x56JKUIJu5la+RMoNDun5FjGmECeg9u28qwsoDEvIHstQnYvMnB2VdFE8mJUSH0A/a52 jQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2w117ttxbb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 Nov 2019 00:51:29 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA50mcur046499;
        Tue, 5 Nov 2019 00:51:29 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 2w1k8vt4jc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 Nov 2019 00:51:29 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xA50pPYq000938;
        Tue, 5 Nov 2019 00:51:25 GMT
Received: from localhost (/10.159.233.45)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 04 Nov 2019 16:51:25 -0800
Date:   Mon, 4 Nov 2019 16:51:24 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/6] xfs: add a XFS_CORRUPT_ON macro
Message-ID: <20191105005124.GU4153244@magnolia>
References: <157281984457.4151907.11281776450827989936.stgit@magnolia>
 <157281987010.4151907.6435110079992395504.stgit@magnolia>
 <20191105004828.GD22247@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191105004828.GD22247@infradead.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9431 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=949
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1911050004
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9431 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1911050004
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Nov 04, 2019 at 04:48:28PM -0800, Christoph Hellwig wrote:
> On Sun, Nov 03, 2019 at 02:24:30PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Add a new macro, XFS_CORRUPT_ON, which we will use to integrate some
> > corruption reporting when the corruption test expression is true.  This
> > will be used in the next patch to remove the ugly XFS_WANT_CORRUPT*
> > macros.
> 
> I don't particularly like the XFS_CORRUPT_ON name, and seeing how it
> is used I like it even less.
> 
> Maybe XFS_IS_CORRUPT instead?

Fine with me.

I'd derived the name from WARN_ON, then realized that if you squint just
right it becomes "XFS_CORRUPTION" and then wondered if I should just
shorten it to "IS_BAD()" but sent it out anyway. :)

--D
