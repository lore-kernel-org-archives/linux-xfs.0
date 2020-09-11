Return-Path: <SRS0=CRyL=CU=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D7ABC433E2
	for <linux-xfs@archiver.kernel.org>; Fri, 11 Sep 2020 16:05:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B99C521D47
	for <linux-xfs@archiver.kernel.org>; Fri, 11 Sep 2020 16:05:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="HO5og/R7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726308AbgIKQEv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 11 Sep 2020 12:04:51 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:57166 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726572AbgIKQDx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 11 Sep 2020 12:03:53 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08BG0CTU107632;
        Fri, 11 Sep 2020 16:03:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=1w3n2CMiZHvxkG6zJpt/AznDLnSWylpcUPu/2eleBX4=;
 b=HO5og/R7qh/342P5DPHI/Og6bfNp5kU5q/MtvwFb1AaBrxH8dxW0km3hZgYba1/BRaGa
 AG137wdK+nEY0Tj/f/JSDFzZ7+ZVidjVY6QCQ6W/bSC9PwE/zO9iJvSuWzHqxM1o14ba
 Pi8JubAARLaIvp2na1zX6gvY3V56zbjbbl/vpCrDwpy00MkbaQD0f6Y0p3vyLQhVKU1n
 ZbhlLSh+jJ9nJeWMePYf0nF95+MGUZ0+wjNxMVPLhWDtC5ze3+V6R0tQW8T4tFr8YozB
 afZ9PcCiQFHnvBnmfAfqnn0S56aKk2y+i0vdH6hI5Dt/tDEnzJiXQMz5XJvSwiDiZz6t fw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 33c3anf051-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 11 Sep 2020 16:03:49 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08BG1Eba103298;
        Fri, 11 Sep 2020 16:03:48 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 33cmkdc657-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 11 Sep 2020 16:03:48 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 08BG3kbb004122;
        Fri, 11 Sep 2020 16:03:47 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 11 Sep 2020 09:03:46 -0700
Date:   Fri, 11 Sep 2020 09:03:45 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Colin Ian King <colin.king@canonical.com>
Cc:     linux-xfs@vger.kernel.org, Brian Foster <bfoster@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: xfs: support inode btree blockcounts in online repair
Message-ID: <20200911160345.GT7955@magnolia>
References: <7c612801-682a-0115-2b37-5d21b933960d@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7c612801-682a-0115-2b37-5d21b933960d@canonical.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9741 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 phishscore=0
 mlxlogscore=999 bulkscore=0 adultscore=0 mlxscore=0 suspectscore=1
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009110130
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9741 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 priorityscore=1501
 clxscore=1011 bulkscore=0 malwarescore=0 lowpriorityscore=0
 mlxlogscore=999 suspectscore=1 adultscore=0 mlxscore=0 impostorscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009110130
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Sep 11, 2020 at 12:16:33PM +0100, Colin Ian King wrote:
> Hi,
> 
> Static analysis with Coverity has detected an issue with the following
> commit:
> 
> commit 30deae31eab501f568aadea45cfb3258b9e522f5
> Author: Darrick J. Wong <darrick.wong@oracle.com>
> Date:   Wed Aug 26 10:48:50 2020 -0700
> 
>     xfs: support inode btree blockcounts in online repair
> 
> the analysis is as follows:
> 
> 830                cur = xfs_inobt_init_cursor(mp, sc->tp, agi_bp,
> sc->sa.agno,
> 831                                XFS_BTNUM_FINO);

xfs_inobt_init_cursor can't return NULL (because we guarantee the
allocation cannot fail) so all that really needs to be done here is to
remove the pointless error check in lines 832-833.

--D

> const: At condition error, the value of error must be equal to 0.
> dead_error_condition: The condition error cannot be true.
> 
>  832                if (error)
> 
> CID: Logically dead code (DEADCODE)dead_error_line: Execution cannot
> reach this statement: goto err;.
> 
>  833                        goto err;
> 
> While it is tempting to change the if (error) check to if (cur), the
> exit error path uses the errnoeous cur as follows:
> 
>  842 err:
>  843       xfs_btree_del_cursor(cur, error);
>  844       return error;
> 
> so the error exit path needs some sorting out too.
