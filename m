Return-Path: <SRS0=WPjR=DA=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CDB8CC4727E
	for <linux-xfs@archiver.kernel.org>; Wed, 23 Sep 2020 15:22:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8FCEC221E7
	for <linux-xfs@archiver.kernel.org>; Wed, 23 Sep 2020 15:22:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="q+GMTq03"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726732AbgIWPWv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 23 Sep 2020 11:22:51 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:38818 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726687AbgIWPWu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 23 Sep 2020 11:22:50 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08NF9AAG061767;
        Wed, 23 Sep 2020 15:22:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=Ec8IjNyZuU/Av4vy0UR55B5zuJexGscyPXPolZ0eVD4=;
 b=q+GMTq03qio7eq/TruLI87uP0OawMiywdCIqF0/ekIeeLZr6DK/L64Ju9bUteg2FCACu
 80ayf2vpUO34HSZmHOprrFE8W20M+BAbe5uUvq94jHAcOLnBw8xf76An6/fl3QPdQj8K
 7F9ND01niZhNNDbH4LF0NmvDK243h7fTHDolT9iOkbiHUNRIgi0f5mFXwo1QScDNFnLW
 IoLX2NruLih6rf8jZ+FU5/fcDxj27ok/oQfgtHq7p8fhnxMKSmnISfV13C347Zmf9h4Y
 BtdlpdvlqiqrOZYZUbr4szCnzuHN3vrGupCds+5uN6N5lBdjYngXTh61wFKwAqDyIGDt dQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 33ndnuk68d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 23 Sep 2020 15:22:44 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08NF66ZJ022243;
        Wed, 23 Sep 2020 15:22:43 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 33r28vp938-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 23 Sep 2020 15:22:43 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 08NFMgM4005043;
        Wed, 23 Sep 2020 15:22:42 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 23 Sep 2020 08:22:41 -0700
Date:   Wed, 23 Sep 2020 08:22:40 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com
Subject: Re: [PATCH 3/3] xfs: xfs_defer_capture should absorb remaining
 transaction reservation
Message-ID: <20200923152240.GM7955@magnolia>
References: <160031334050.3624461.17900718410309670962.stgit@magnolia>
 <160031335967.3624461.12775342036527430147.stgit@magnolia>
 <20200923074953.GC31918@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200923074953.GC31918@infradead.org>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9753 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999
 suspectscore=1 adultscore=0 bulkscore=0 malwarescore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009230123
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9753 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 lowpriorityscore=0 phishscore=0 adultscore=0 suspectscore=1 bulkscore=0
 clxscore=1015 impostorscore=0 mlxlogscore=999 mlxscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009230123
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Sep 23, 2020 at 08:49:53AM +0100, Christoph Hellwig wrote:
> >  	list_for_each_entry_safe(dfc, next, dfops_freezers, dfc_list) {
> > -		error = xfs_trans_alloc(mp, &M_RES(mp)->tr_itruncate, 0,
> > -				0, XFS_TRANS_RESERVE, &tp);
> > +		error = xfs_trans_alloc(mp, &dfc->dfc_tres, 0, 0,
> > +				XFS_TRANS_RESERVE, &tp);
> 
> ... and this fixes the weird itruncate thing.  Nice!

Yep, Dave was also complaining about how weird the itruncate thing was.

--D
