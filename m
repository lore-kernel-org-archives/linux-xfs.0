Return-Path: <SRS0=9CIi=XZ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96DE6C32792
	for <linux-xfs@archiver.kernel.org>; Mon, 30 Sep 2019 16:15:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 656FE20815
	for <linux-xfs@archiver.kernel.org>; Mon, 30 Sep 2019 16:15:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="fKTooDZ9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731967AbfI3QPQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 30 Sep 2019 12:15:16 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:50744 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731459AbfI3QPP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 30 Sep 2019 12:15:15 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8UG9oSF024232;
        Mon, 30 Sep 2019 16:15:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=5vbh0xNLyI6zBuJieN64BOOFRU8sgv249K7N8uy94RI=;
 b=fKTooDZ9jsWLoKsnBJJ3Nhq0NFzb8UUR+Pxm7xVOouHb02iODlrTmRxE+mmykMTIPXcN
 nXS4tEMLqM/SaF1w3DmcQ5fjqKTCkXEr22aebJxB501W/Dh+XYSpgFCIgJT/oaS3LfoB
 6wGsH+zNzKRPx9R/wGc7K6FVddJ+KlahleyciaUwqhF2X2XjoZfUYMcuKwk/N5xqlnOK
 Hv7uOIq6y3y/ld3+dTeVYB/GqPAKeMk0XeklsrG/EN/PenERWCV0STgT7JJcpSSrylSZ
 DH9px9yEdVNreWT/w0/Up/XW8BmOZDuxRv+qmJxJX9HwIvAoqcSAHPNoMWTucwP6jCf9 gA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2v9xxugcqy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 30 Sep 2019 16:15:09 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8UG9oRp182499;
        Mon, 30 Sep 2019 16:15:08 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 2vah1j1nxf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 30 Sep 2019 16:15:08 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x8UGF7a4018675;
        Mon, 30 Sep 2019 16:15:07 GMT
Received: from localhost (/67.161.8.12)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 30 Sep 2019 09:15:07 -0700
Date:   Mon, 30 Sep 2019 09:15:06 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 6/7] libfrog: convert scrub.c functions to negative error
 codes
Message-ID: <20190930161506.GB13108@magnolia>
References: <156944760161.302827.4342305147521200999.stgit@magnolia>
 <156944763836.302827.14950651793743078704.stgit@magnolia>
 <20190930075441.GH27886@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190930075441.GH27886@infradead.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9396 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1909300159
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9396 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1909300159
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Sep 30, 2019 at 12:54:41AM -0700, Christoph Hellwig wrote:
> On Wed, Sep 25, 2019 at 02:40:38PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Convert libfrog functions to return negative error codes like libxfs
> > does.
> 
> Looks fine, although in the places where you touch the whole switch
> statement I wonder why we just switch those to negative errnos instead
> of inverting and then checking for positive values..

This series only converts libfrog functions and callsites.  Next I'll
start converting utilities one by one, but there are already too many
patches out so I'm holding off until that after a series or two get
merged.

> Reviewed-by: Christoph Hellwig <hch@lst.de>

Thanks for the review!

--D
