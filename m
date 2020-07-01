Return-Path: <SRS0=D+gV=AM=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C97DC433E0
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jul 2020 19:02:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2E58A2082F
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jul 2020 19:02:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Qt+RkKlc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725812AbgGATCd (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 1 Jul 2020 15:02:33 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:34760 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725535AbgGATCd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 1 Jul 2020 15:02:33 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 061J2GKX063806;
        Wed, 1 Jul 2020 19:02:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=TZUAFIJDq6ewsViqvM5oK1YiOOpxUKSkKgmG5iJ8Vzo=;
 b=Qt+RkKlcTc7ksgdh0KbRCpmQXc4urcjLSgKolMYK2dHH5jxp4l5dqNg62b9R9hKAu0YH
 U1/Fec2UjUCoy7XeQnznlplLlLdTMy6FO7UpAMfQm28WDIChLT1RNIcu3KDMOJrAbSFn
 lfRSHIXAzmeubztykwTLi0+yPxLdTM9iNd1MtMfQWQVyiaE5FY+Vo0hQCAV5T0mYdwzk
 LRaM6zMjMxkP5VYI9t4OXTtAnhCgMnyJwmrx04TJLOFAgFj8t0XUUiHunlRwaYvtw6Te
 LUf++LmzepRPj7bhQunk4TgweyaTR6Ngy61tcr84UJXva1k+b4hYakxpUDM4/pIUU8St 8w== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 31xx1e1809-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 01 Jul 2020 19:02:29 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 061IroH2100883;
        Wed, 1 Jul 2020 19:02:28 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 31xg1yrdrx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 01 Jul 2020 19:02:28 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 061J2M18014033;
        Wed, 1 Jul 2020 19:02:22 GMT
Received: from localhost (/10.159.237.139)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 01 Jul 2020 19:02:22 +0000
Date:   Wed, 1 Jul 2020 12:02:21 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 04/18] xfs: stop using q_core.d_flags in the quota code
Message-ID: <20200701190221.GW7606@magnolia>
References: <159353170983.2864738.16885438169173786208.stgit@magnolia>
 <159353173676.2864738.5361850443664572160.stgit@magnolia>
 <20200701084714.GD25171@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200701084714.GD25171@infradead.org>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9669 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 phishscore=0
 malwarescore=0 mlxlogscore=999 adultscore=0 mlxscore=0 suspectscore=1
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2007010131
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9669 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 clxscore=1015 adultscore=0
 suspectscore=1 mlxlogscore=999 cotscore=-2147483648 lowpriorityscore=0
 malwarescore=0 phishscore=0 impostorscore=0 mlxscore=0 spamscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2007010132
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jul 01, 2020 at 09:47:14AM +0100, Christoph Hellwig wrote:
> >  #define XFS_DQ_ALLTYPES		(XFS_DQ_USER|XFS_DQ_PROJ|XFS_DQ_GROUP)
> >  
> > +#define XFS_DQ_ONDISK		(XFS_DQ_ALLTYPES)
> > +
> 
> I really wonder if we should split the on-disk type and the in-core
> flags properly instead.
> 
> That is propagate the u8 flags from the on-disk field directly,
> and use a separate field for the in-memory flags dirty and freeing
> flags, as that this kind of mixing up is bound to eventually create
> problems.

I was already half-inclined to try to separate them anyway, guess I'll
add that to this series.

--D
