Return-Path: <SRS0=xgbg=7A=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BFBC3C433DF
	for <linux-xfs@archiver.kernel.org>; Mon, 18 May 2020 17:36:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9BFAA20674
	for <linux-xfs@archiver.kernel.org>; Mon, 18 May 2020 17:36:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="fTBfRiic"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728213AbgERRg3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 18 May 2020 13:36:29 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:40664 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727006AbgERRg3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 18 May 2020 13:36:29 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04IHXQa2167817;
        Mon, 18 May 2020 17:36:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=ZhwV6kq0+I4gCl4bZpEqldxfIg48DPCqM+TIozsGcsQ=;
 b=fTBfRiicyo44eOXbIqqit+lJseKEOvG+GWn0c6KhPwshBg5Gzfm40H1T8DyUxk1TNhKH
 iln2tx+QflR3pjAUYe3NPbt7UsWg+XqrPGSAayVa7Wmzg0ZL1xIucsmU2/t08bzxvrH8
 6b+D8G48ZPuCjrzb3dlhyQiRlA79/wFpk4o5R9dF9iVxkK9LWLfA7qY7iVneYiaDd8z+
 XHFGaWJHiI3AdI7185esd6ODH1/zw6r22fEt8H2NT8qh3YvSCJVDmMNHdK1WdfGc7i8f
 4rIJXIRgJ9eI2fMxxnK/dnAyq7NiWuT/cKcI4LjEdLNNRFhlodHIE1tN4r4D8GfJfXcP Jg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 3128tn83fj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 18 May 2020 17:36:25 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04IHX3Y8141780;
        Mon, 18 May 2020 17:36:25 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 312sxqvqxj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 18 May 2020 17:36:24 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 04IHaOlM024357;
        Mon, 18 May 2020 17:36:24 GMT
Received: from localhost (/10.159.132.30)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 18 May 2020 10:36:23 -0700
Date:   Mon, 18 May 2020 10:36:22 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: dinode reading cleanups v2
Message-ID: <20200518173622.GE17627@magnolia>
References: <20200508063423.482370-1-hch@lst.de>
 <20200518064859.GA19510@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200518064859.GA19510@lst.de>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9625 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 malwarescore=0
 mlxlogscore=734 bulkscore=0 mlxscore=0 suspectscore=2 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005180147
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9625 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 bulkscore=0 spamscore=0
 clxscore=1015 cotscore=-2147483648 suspectscore=2 lowpriorityscore=0
 adultscore=0 phishscore=0 mlxlogscore=781 mlxscore=0 priorityscore=1501
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2005180147
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, May 18, 2020 at 08:48:59AM +0200, Christoph Hellwig wrote:
> As there were some conflicts due to the code moves for the log
> refactoring I've pushed out a new v3 branch here:
> 
>     git://git.infradead.org/users/hch/xfs.git xfs-inode-read-cleanup.3
> 
> Gitweb:
> 
>     http://git.infradead.org/users/hch/xfs.git/shortlog/refs/heads/xfs-inode-read-cleanup.3
> 
> The only other change is extra indentation for the local fork verifiers.
> I don't think it is worth reposting for that, unless you want me to.

I already pulled in the v2 series (with the indentation changes); are
there any additional changes in v3?  I didn't see any changes diffing
your branch to mine, so I think everything is fine.

--D
