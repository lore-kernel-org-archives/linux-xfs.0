Return-Path: <SRS0=cOuX=EE=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23E48C55179
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Oct 2020 18:17:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B87FF207EA
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Oct 2020 18:17:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="0bBnDOoB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725915AbgJ2SRQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 29 Oct 2020 14:17:16 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:39774 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725747AbgJ2SRQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 29 Oct 2020 14:17:16 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09TI8jvt003364;
        Thu, 29 Oct 2020 18:17:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=eI7rG7pIwb4bSObzJBj/aGTA77R+R50mi2lqMNSUbcU=;
 b=0bBnDOoBngy09GweycFIStlpqVbhX7BEdndKkuVXdgQYPkDCNgtfwqQS+avOCbWeSjtr
 RqRVbRiTyds7gQqseg9ecNjRz61ep/46KWyt3PFL0H9fNPGaWRlIRC1c03kemDVNTKsK
 bjD7OAxaH9UeHpeFTwo2SsDCs6oq6++kd+TH3BAvGsDVxpXaj9ReugE0WMw4bjf6ysAa
 /2dmy3mrbGOKF0rixjA+3jVejun7SVIcBC+FCEc0iHtYUZNrR7+bgiJBCot7Iw4VcG8k
 u8uy6LyuEqlbtwfZU24nfLv2hHSh6l7HNWk5pVqXgJzl0S0gko8H+Jn6m1+8FHEEY9HW hg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 34dgm4bxjt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 29 Oct 2020 18:17:13 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09TIBRpd177138;
        Thu, 29 Oct 2020 18:17:13 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 34cx6ysgj4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Oct 2020 18:17:13 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 09TIHCAa007478;
        Thu, 29 Oct 2020 18:17:12 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 29 Oct 2020 11:17:12 -0700
Date:   Thu, 29 Oct 2020 11:17:11 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Eryu Guan <guaneryu@gmail.com>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        fstests <fstests@vger.kernel.org>
Subject: Re: [PATCH 7/7] xfs/122: fix test for xfs_attr_shortform_t conversion
Message-ID: <20201029181711.GS1061252@magnolia>
References: <160382535113.1203387.16777876271740782481.stgit@magnolia>
 <160382539620.1203387.14717204905418805283.stgit@magnolia>
 <CAOQ4uxgZ82k7y5QabzO0+2Xg6P0LDVf-ysyRvyMZeH6vm8os-g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxgZ82k7y5QabzO0+2Xg6P0LDVf-ysyRvyMZeH6vm8os-g@mail.gmail.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9789 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 spamscore=0
 bulkscore=0 malwarescore=0 mlxlogscore=999 mlxscore=0 suspectscore=1
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010290127
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9789 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 impostorscore=0
 adultscore=0 bulkscore=0 spamscore=0 phishscore=0 mlxlogscore=999
 suspectscore=1 clxscore=1015 mlxscore=0 malwarescore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010290127
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Oct 29, 2020 at 01:17:40PM +0200, Amir Goldstein wrote:
> On Wed, Oct 28, 2020 at 10:24 PM Darrick J. Wong
> <darrick.wong@oracle.com> wrote:
> >
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> >
> > The typedef xfs_attr_shortform_t was converted to a struct in 5.10.
> > Update this test to pass.
> >
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  tests/xfs/122.out |    1 +
> >  1 file changed, 1 insertion(+)
> >
> >
> > diff --git a/tests/xfs/122.out b/tests/xfs/122.out
> > index 45c42e59..cfe09c6d 100644
> > --- a/tests/xfs/122.out
> > +++ b/tests/xfs/122.out
> > @@ -62,6 +62,7 @@ sizeof(struct xfs_agfl) = 36
> >  sizeof(struct xfs_attr3_leaf_hdr) = 80
> >  sizeof(struct xfs_attr3_leafblock) = 88
> >  sizeof(struct xfs_attr3_rmt_hdr) = 56
> > +sizeof(struct xfs_attr_shortform) = 8
> >  sizeof(struct xfs_btree_block) = 72
> >  sizeof(struct xfs_btree_block_lhdr) = 64
> >  sizeof(struct xfs_btree_block_shdr) = 48
> >
> 
> Maybe remove comment
> 
> # missing:
> # xfs_attr_shortform_t
> 
> While at it.

I'll do that, thanks!

--D

> Thanks,
> Amir.
