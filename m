Return-Path: <SRS0=3Xx9=C6=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24FA5C43466
	for <linux-xfs@archiver.kernel.org>; Mon, 21 Sep 2020 16:24:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BE82423719
	for <linux-xfs@archiver.kernel.org>; Mon, 21 Sep 2020 16:24:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="F/2nUypR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726430AbgIUQYJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 21 Sep 2020 12:24:09 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:58840 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728129AbgIUQYI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 21 Sep 2020 12:24:08 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08LGIceR075559;
        Mon, 21 Sep 2020 16:24:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=q4Ez382Gne2FhW1b/1+i5dccSAf54jpFNIwquB2rSc0=;
 b=F/2nUypRmZz+Y2ACm+J+RNyQAmwftq9xFYvtYM2F08lfSR/gpyq5hDk3b0sPt4+rC1Zb
 8589uwBBqlny99pPIE84pM5rq+mRICLj1oE9GwjC2eA4TR3Z3S/33WNExaTBqe52L98i
 IiH2xc4FU8cBVlKPEFfofiB4jNN8h2bfNJwo/mBt43bnRwCaRCTlYGanRzMyJRI3dk9R
 eKNjPE6keYrZ3JlrheYtrHQXeNyX5jiCaSqKgU7Xikq6U0dp+jJ/EpRdPTI0JgzI1jXm
 SPtPhzJx9bTk80tQgYJCWz+W800VlcE417lgvM1u2jy1MD2vTncQ2fNoGQk+XfRTX/eF 6Q== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 33ndnu6rdu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 21 Sep 2020 16:24:06 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08LGJm8R107139;
        Mon, 21 Sep 2020 16:24:05 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 33nuw18ve0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 21 Sep 2020 16:24:05 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 08LGO5Jj011876;
        Mon, 21 Sep 2020 16:24:05 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 21 Sep 2020 09:24:05 -0700
Date:   Mon, 21 Sep 2020 09:24:04 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Zheng Wu <zhengwu0330@gmail.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: The feature of Block size > PAGE_SIZE support
Message-ID: <20200921162404.GC7955@magnolia>
References: <CADQqeeS9SWv_R5XNsNRq=pLiP-9r56-YyhCw7JP32-aR=jsK+w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CADQqeeS9SWv_R5XNsNRq=pLiP-9r56-YyhCw7JP32-aR=jsK+w@mail.gmail.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9751 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 malwarescore=0
 mlxscore=0 suspectscore=1 adultscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009210115
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9751 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 lowpriorityscore=0 phishscore=0 adultscore=0 suspectscore=1 bulkscore=0
 clxscore=1011 impostorscore=0 mlxlogscore=999 mlxscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009210115
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Sep 21, 2020 at 11:12:54AM +0800, Zheng Wu wrote:
> Hi experts,
> 
> We know that the feature of Block size > PAGE_SIZE will be supported in XFS.
> Just, I can't test successfully in the last version of Linux.
> 
> When is this feature of  Block size > PAGE_SIZE available in upstream?

It's not currently in upstream.  Some day, perhaps, after THP support
gets added to iomap.

--D

> Thanks.
> 
> Best Regards
> Zheng Wu
