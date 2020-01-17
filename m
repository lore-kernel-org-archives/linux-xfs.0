Return-Path: <SRS0=oH8U=3G=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C0A7C33CB1
	for <linux-xfs@archiver.kernel.org>; Fri, 17 Jan 2020 16:25:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E2CCC2072E
	for <linux-xfs@archiver.kernel.org>; Fri, 17 Jan 2020 16:25:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="T95Kq+42"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726944AbgAQQZW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 17 Jan 2020 11:25:22 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:52232 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726958AbgAQQZW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 17 Jan 2020 11:25:22 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00HGMngK091510;
        Fri, 17 Jan 2020 16:25:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=eB+AkeyrCAmmYrQVAgo/C2BHPlAF/hZ0SiouYO34HOU=;
 b=T95Kq+42aEkj3J1Q4YRWUz/HBO5Z28Ol0tpLMRAkNXIYU7Tl9mpKTwYj+3fXa4Rch5J+
 xZcY1ukUiqCfUDFYXJzq9D69WHg/WlZMHXnqSk3l3eLkHi4D50j4ba8kG03/1jOs4i1W
 OU2yXGOezyVEgsHMHegXyPRolaJypTOd7YuRB6eSbyHB1xB32G8dwQkgLuETpp4ZWLBw
 5ohFwLgRPZhH45TB6laikxIqXS5h+tkdMfn39U3zrT5rT7XQBEETrOD2GS2WG9xvlnGy
 u2d+vVWydZMtfRXBXjeNmrJ5sfML8k1qIdaZtocDtyjOcOQ4Y3DaXccd0yafdClZ/jmX kA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2xf74ssmyv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 17 Jan 2020 16:25:01 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00HGOWmR030015;
        Fri, 17 Jan 2020 16:25:00 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 2xk24f99d2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 17 Jan 2020 16:25:00 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 00HGOgWu030311;
        Fri, 17 Jan 2020 16:24:42 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 17 Jan 2020 08:24:41 -0800
Date:   Fri, 17 Jan 2020 08:24:39 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     "yukuai (C)" <yukuai3@huawei.com>, Jan Kara <jack@suse.cz>
Cc:     hch@infradead.org, linux-xfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        houtao1@huawei.com, zhengbin13@huawei.com, yi.zhang@huawei.com
Subject: Re: [RFC] iomap: fix race between readahead and direct write
Message-ID: <20200117162439.GT8247@magnolia>
References: <20200116063601.39201-1-yukuai3@huawei.com>
 <20200116153206.GF8446@quack2.suse.cz>
 <ce4bc2f3-a23e-f6ba-0ef1-66231cd1057d@huawei.com>
 <20200117110536.GE17141@quack2.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200117110536.GE17141@quack2.suse.cz>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9503 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001170126
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9503 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001170126
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jan 17, 2020 at 12:05:36PM +0100, Jan Kara wrote:
> On Fri 17-01-20 17:39:03, yukuai (C) wrote:
> > On 2020/1/16 23:32, Jan Kara wrote:
> > > Thanks for the report and the patch. But the data integrity when mixing
> > > buffered and direct IO like this is best effort only. We definitely do not
> > > want to sacrifice performance of common cases or code complexity to make
> > > cases like this work reliably.
> > 
> > In the patch, the only thing that is diffrent is that iomap_begin() will
> > be called for each page. However, it seems the performance in sequential
> > read didn't get worse. Is there a specific case that the performance
> > will get worse?
> 
> Well, one of the big points of iomap infrastructure is that you call
> filesystem once to give you large extent instead of calling it to provide
> allocation for each page separately. The additional CPU overhead will be
> visible if you push the machine hard enough. So IMHO the overhead just is
> not worth it for a corner-case like you presented. But that's just my
> opinion, Darrick and Christoph are definitive arbiters here...

Does the problem go away if you apply[1]?  If I understand the race
correctly, marking the extents unwritten and leaving them that way until
after we've written the disk should eliminate the exposure vector...? :)

[1] https://lore.kernel.org/linux-xfs/157915535059.2406747.264640456606868955.stgit@magnolia/

--D

> 								Honza
> 
> -- 
> Jan Kara <jack@suse.com>
> SUSE Labs, CR
