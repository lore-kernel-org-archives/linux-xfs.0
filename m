Return-Path: <SRS0=Pbt4=DF=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48643C4741F
	for <linux-xfs@archiver.kernel.org>; Mon, 28 Sep 2020 16:43:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EE20021548
	for <linux-xfs@archiver.kernel.org>; Mon, 28 Sep 2020 16:43:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="F/dmfUos"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726504AbgI1Qnq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 28 Sep 2020 12:43:46 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:50596 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726344AbgI1Qnq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 28 Sep 2020 12:43:46 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08SGd0Bj105410;
        Mon, 28 Sep 2020 16:43:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=qYMqHlY01xtQH0784IwawErPxD2BUGWVBgCVZKbwVDQ=;
 b=F/dmfUosN5EgvQHSOx43zJTiMeW0y2WSgSsAiXK7gadbktzBfYL7YuykQZ/ALxQ42MgZ
 l5PdFt+p5asXAtEQnrCAovF5JdN4E0oLvG+XjvXit3VbZaZEhLIiQ/qtUvZNYdK0hqq+
 I+l5U9Cry8KEMKiy5uFW+HwIA/Jm17BaYDHpleij2r2H8YBcGSJkx4X8vwlNjEAzHs4z
 wvUpWQ7WqvFVCePAiLP+Gf5PZxkVjKfpMaPdcjvYrdjC8ZUbMW2V+lqKAo1washYtB9R
 8A6vJ8rz8lwG5GHY/H6xPGeYdYTDQPhmtTBlvFMnEd84MTN8/7buaf2pXDmn9sL4cf5o ng== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 33sx9mx34p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 28 Sep 2020 16:43:37 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08SGemTZ070897;
        Mon, 28 Sep 2020 16:43:36 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 33tf7kja95-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 28 Sep 2020 16:43:36 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 08SGhZ68031430;
        Mon, 28 Sep 2020 16:43:35 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 28 Sep 2020 09:43:34 -0700
Date:   Mon, 28 Sep 2020 09:43:33 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com, bfoster@redhat.com
Subject: Re: [PATCH 1/4] xfs: remove xfs_defer_reset
Message-ID: <20200928164333.GB49559@magnolia>
References: <160125006793.174438.10683462598722457550.stgit@magnolia>
 <160125007449.174438.15988765709988942671.stgit@magnolia>
 <20200928062034.GA15425@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200928062034.GA15425@lst.de>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9758 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 suspectscore=1 adultscore=0 malwarescore=0 phishscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009280129
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9758 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=1
 phishscore=0 mlxscore=0 lowpriorityscore=0 adultscore=0 clxscore=1015
 spamscore=0 impostorscore=0 malwarescore=0 bulkscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009280129
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Sep 28, 2020 at 08:20:34AM +0200, Christoph Hellwig wrote:
> On Sun, Sep 27, 2020 at 04:41:14PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Remove this one-line helper.
> 
> Maybe expand the rationale here a little more?

I'll change it to:
"Remove this one-line helper since the assert is trivially true in one
call site and the rest just obscures a bitmask operation."

--D

> Otherwise looks fine:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
