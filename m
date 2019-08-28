Return-Path: <SRS0=H+3G=WY=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2F48C3A5A1
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Aug 2019 21:51:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6E98522CF8
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Aug 2019 21:51:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="bb9reuRF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726787AbfH1Vv2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 28 Aug 2019 17:51:28 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:37056 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726735AbfH1Vv1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 28 Aug 2019 17:51:27 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7SLn5WV098772;
        Wed, 28 Aug 2019 21:51:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 content-transfer-encoding : in-reply-to; s=corp-2019-08-05;
 bh=qbP4B9RqyD7liUs+1o7tdIzeaA+HMtSz5ktInxhdkkI=;
 b=bb9reuRFgCMjafPlW5yShn2sk6SIL3E/capUXjvmCIMV4Bb1pCHqfzRpD6p9WIuoiVJs
 IkCKJUZKJvAnUhf42Q18/DFcdaoBHzBUT+pZuLoICgcyOWYppY6IP/2kmBIuNfcoq1i7
 QOioid17dtxjEFTUlmT4EEPvkgPtkEbG/w5he0Xo5XzGASWURulDMziNyr5OZxsAX3fn
 WBrsyuFIpKQRjMJqn2bg+PtuyRgUAxqykrFsdLYV2DIqOBqnzoEQz2AaiS3Ng+Nv5SHC
 XbC6r8hlUBxMW4V/BINf4QGoOjowI2KpNyvu4fot/br1CgBccxb1hhW7v1ULP8NHmUwU AQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2up1ncg297-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 28 Aug 2019 21:51:25 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7SLmKr1185020;
        Wed, 28 Aug 2019 21:51:24 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 2undw7x8qu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 28 Aug 2019 21:51:24 +0000
Received: from abhmp0022.oracle.com (abhmp0022.oracle.com [141.146.116.28])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x7SLpNfE016575;
        Wed, 28 Aug 2019 21:51:23 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 28 Aug 2019 14:51:23 -0700
Date:   Wed, 28 Aug 2019 14:51:18 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Austin Kim <austindh.kim@gmail.com>
Cc:     linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] xfs: Use WARN_ON rather than BUG() for bailout
 mount-operation
Message-ID: <20190828215118.GH1037350@magnolia>
References: <20190828064749.GA165571@LGEARND20B15>
 <20190828151411.GC1037350@magnolia>
 <CADLLry50iDrEfDrL3kZP_gku6jnO23qi5VVyuFY3g2BubWg0ww@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CADLLry50iDrEfDrL3kZP_gku6jnO23qi5VVyuFY3g2BubWg0ww@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9363 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908280209
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9363 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908280209
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Aug 29, 2019 at 06:30:43AM +0900, Austin Kim wrote:
> Dear Mr. Darrick J. Wong
> 
> Thanks for reviewing patch. BTW, I have a question for you.
> 
> Do I have to update the patch again with 'a space before the brace'?
> Or could I just wait for the patch to be imported?
> 
> It would be thankful if you give me a feedback.

I made the correction when I imported your patch into my testing tree,
so you don't need to resubmit the patch just to fix that one thing.

However, if you decide to send a new revision *for some other reason*,
then please make the correction in your own tree before resubmitting.

--D

> BR,
> Guillermo Austin Kim
> 
> 2019년 8월 29일 (목) 오전 12:14, Darrick J. Wong <darrick.wong@oracle.com>님이 작성:
> >
> > On Wed, Aug 28, 2019 at 03:47:49PM +0900, Austin Kim wrote:
> > > If the CONFIG_BUG is enabled, BUG() is executed and then system is crashed.
> > > However, the bailout for mount is no longer proceeding.
> > >
> > > For this reason, using WARN_ON rather than BUG() could prevent this situation.
> > > ---
> > >  fs/xfs/xfs_mount.c | 3 +--
> > >  1 file changed, 1 insertion(+), 2 deletions(-)
> > >
> > > diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
> > > index 322da69..10fe000 100644
> > > --- a/fs/xfs/xfs_mount.c
> > > +++ b/fs/xfs/xfs_mount.c
> > > @@ -213,8 +213,7 @@ xfs_initialize_perag(
> > >                       goto out_hash_destroy;
> > >
> > >               spin_lock(&mp->m_perag_lock);
> > > -             if (radix_tree_insert(&mp->m_perag_tree, index, pag)) {
> > > -                     BUG();
> > > +             if (WARN_ON(radix_tree_insert(&mp->m_perag_tree, index, pag))){
> >
> > Need a space before the brace.
> >
> > Will fix on import,
> > Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> >
> > --D
> >
> > >                       spin_unlock(&mp->m_perag_lock);
> > >                       radix_tree_preload_end();
> > >                       error = -EEXIST;
> > > --
> > > 2.6.2
> > >
