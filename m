Return-Path: <SRS0=eQYP=24=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51AFEC282DD
	for <linux-xfs@archiver.kernel.org>; Tue,  7 Jan 2020 18:18:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2808A20848
	for <linux-xfs@archiver.kernel.org>; Tue,  7 Jan 2020 18:18:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Wq50f4O7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728358AbgAGSSL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 7 Jan 2020 13:18:11 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:53986 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727925AbgAGSSL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 7 Jan 2020 13:18:11 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 007IEFTs003485;
        Tue, 7 Jan 2020 18:17:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=Of636FIKHxndvNYXsJ3AfofjE+a+mmlzGYdy/h0HU/g=;
 b=Wq50f4O7LD0G0YeuKQY1X5cDg86qvsnoGrdXkHiXYcS7QuLvG6boRTB6122AeP1iViH4
 zlUyLXKeauw3OTPsSgtkzK/QSE3rZ+kfxX/l5/57uWhuNwAnvVZZi533BMy8wbZjiXFG
 eNitseMIZgHid36ntBJUYOMgkIT82wgmpz4QQYTlvbBXrh3tKS6U8VIKac8K/sqMRRBB
 XugVu8e+2RpzK8nxs9uZLPajFFCIOW+6o33Fra53NmUST5SOKLJn6vADZc27JD1dUc+W
 qxVWJ0KPzIbwVLKaqHBzaBRVOA7ciIPWkB9wl0AhcPXyv2XKAz62jlTzC3KzWEEkZsMZ Zw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2xaj4tydqy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 07 Jan 2020 18:17:55 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 007IEBII170742;
        Tue, 7 Jan 2020 18:17:55 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 2xcjvdq06n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 07 Jan 2020 18:17:54 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 007IHrgc008585;
        Tue, 7 Jan 2020 18:17:53 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 07 Jan 2020 10:17:52 -0800
Date:   Tue, 7 Jan 2020 10:17:51 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     "yukuai (C)" <yukuai3@huawei.com>
Cc:     bfoster@redhat.com, dchinner@redhat.com, sandeen@sandeen.net,
        cmaiolino@redhat.com, hch@lst.de, linux-xfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, zhengbin13@huawei.com,
        yi.zhang@huawei.com, houtao1@huawei.com
Subject: Re: [PATCH 2/2] xfs: fix stale data exposure problem when punch
 hole, collapse range or zero range across a delalloc extent
Message-ID: <20200107181751.GB917713@magnolia>
References: <20191226134721.43797-1-yukuai3@huawei.com>
 <20191226134721.43797-3-yukuai3@huawei.com>
 <20200106215755.GB472651@magnolia>
 <f4bf9490-0476-3a6a-55e0-786186669c6c@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f4bf9490-0476-3a6a-55e0-786186669c6c@huawei.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9492 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001070144
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9492 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001070144
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jan 07, 2020 at 10:09:44AM +0800, yukuai (C) wrote:
> 
> 
> On 2020/1/7 5:57, Darrick J. Wong wrote:
> > So your solution is to split the delalloc reservation to constrain the
> > allocation to the range that's being operated on?
> Yes, I'm trying to split delalloc reservation.
> > 
> > If so, I think a better solution (at least from the perspective of
> > reducing fragmentation) would be to map the extent unwritten and force a
> > post-writeback conversion[1] but I got shot down for performance reasons
> > the last time I suggested that.
> I'm wondering if spliting delalloc reservation have the same performance
> issue.

Probably not, but OTOH will doing so (a) have a noticeable effect on
fragmentation, and (b) will the kernel code choke on two adjacent
delalloc extents that could be merged?  (I think the answer is no since
we'll either complete the operation or the fs goes down...?)

--D

> Thanks!
> Yu Kuai
> 
