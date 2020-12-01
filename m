Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB3A2C83022
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Dec 2020 16:56:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6ED2C2076C
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Dec 2020 16:56:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="dCa/Zpyo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404094AbgLAQ4E (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 1 Dec 2020 11:56:04 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:52978 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391824AbgLAQ4C (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 1 Dec 2020 11:56:02 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B1GswEs107444;
        Tue, 1 Dec 2020 16:55:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=QLGAAe7PW1j3c2Y3zlKhzP1a2czmmczYDqwdW9F9XKc=;
 b=dCa/ZpyoiesGar/0AXA8a2o24hsHZ/zrj0Mhn71GzEyx0E6S9luDuzraWUIvm19Sd6i+
 hNB/xa/+qK3VNdYoaxmijnwoJcqx3kX7ZdGvyQsLMdUDhHYGJR1HcqrVIQqozS5tdhD1
 Pe3la+nLxNNwNm87BED5qkGKtar23yPbQyCEtG0nxt3TCwcqeyHycxu8PGkzjyWfSKWz
 BYGnzf9br6y5RMcfkJPKHK6YWnj0AFN+5FM+E56Ikxoli7DFh1KmzEKFZd22/hbJO2KG
 IHOGI0PgYFUKHGI6hjeqCHLWvdCedwS4E/+LcGtldWMvX6dKDgfifstYYbyB8Vj8jmBN AA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 353egkkmd9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 01 Dec 2020 16:55:16 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B1GkGsT015242;
        Tue, 1 Dec 2020 16:55:15 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 3540asnbmu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 01 Dec 2020 16:55:15 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0B1GtEIH008949;
        Tue, 1 Dec 2020 16:55:14 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 01 Dec 2020 08:55:12 -0800
Date:   Tue, 1 Dec 2020 08:55:11 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Gao Xiang <hsiangkao@redhat.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/3] xfs: kill ialloced in xfs_dialloc()
Message-ID: <20201201165511.GE143045@magnolia>
References: <20201124155130.40848-1-hsiangkao@redhat.com>
 <20201124155130.40848-2-hsiangkao@redhat.com>
 <20201201102100.GF12730@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201201102100.GF12730@infradead.org>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9822 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0
 phishscore=0 mlxscore=0 adultscore=0 malwarescore=0 suspectscore=1
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012010103
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9822 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 suspectscore=1
 phishscore=0 mlxlogscore=999 lowpriorityscore=0 malwarescore=0
 priorityscore=1501 spamscore=0 impostorscore=0 clxscore=1015 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012010104
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Dec 01, 2020 at 10:21:00AM +0000, Christoph Hellwig wrote:
> On Tue, Nov 24, 2020 at 11:51:29PM +0800, Gao Xiang wrote:
> > It's enough to just use return code, and get rid of an argument.
> > 
> > Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
> > ---
> >  fs/xfs/libxfs/xfs_ialloc.c | 22 ++++++++++------------
> >  1 file changed, 10 insertions(+), 12 deletions(-)
> > 
> > diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
> > index 45cf7e55f5ee..5c8b0210aad3 100644
> > --- a/fs/xfs/libxfs/xfs_ialloc.c
> > +++ b/fs/xfs/libxfs/xfs_ialloc.c
> > @@ -607,13 +607,14 @@ xfs_inobt_insert_sprec(
> >  
> >  /*
> >   * Allocate new inodes in the allocation group specified by agbp.
> > - * Return 0 for success, else error code.
> > + * Return 0 for successfully allocating some inodes in this AG;
> > + *        1 for skipping to allocating in the next AG;
> 
> s/for/when/ for both lines I think.
> 
> > + *      < 0 for error code.
> 
> and < 0 for errors here maybe.  But I'm not a native speaker either.

"Returns 0 if inodes were allocated in this AG; 1 if there was no space
in this AG; or the usual negative error code." ?

--D

> Otherwise looks good:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
