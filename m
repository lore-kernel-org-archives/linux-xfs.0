Return-Path: <SRS0=PyEN=B4=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A08ADC433DF
	for <linux-xfs@archiver.kernel.org>; Tue, 18 Aug 2020 15:21:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 755CC207DE
	for <linux-xfs@archiver.kernel.org>; Tue, 18 Aug 2020 15:21:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="x+3JNjmJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727835AbgHRPVf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 18 Aug 2020 11:21:35 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:37530 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726630AbgHRPVc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 18 Aug 2020 11:21:32 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07IF7QBe057927;
        Tue, 18 Aug 2020 15:21:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 content-transfer-encoding : in-reply-to; s=corp-2020-01-29;
 bh=hJ5HFHX+fJiHH+k0sECbS3I+mdQ2Dc4/79qOjc9Z4LM=;
 b=x+3JNjmJY3fRYZCHAJ/B+mOGRxWDNT1WhHX/H3f6+Y6khHWIkGIlONPT6HQLCqzFxOWu
 clURHfjlIRvDX5ARbb9g4sGfFTKpghYmb3V1FEREMU3AGfEz165MHocNSBnlyrrwgL85
 blX1Eb8qCDdin9dGH45G0C/Vx71y4H9gDDi+ncrYZwTFzV8Rn8pd4J9G7+rlFAcITUHM
 x0gZvOMBLgsUitKd4sCBtZKA8mCe2/RKe32d/gnbvZsR0Zxp7xYBd2mI9dFOTssB6tcr
 wVSDC6dmg184KnEEUXHBm8nGd4ybhmmp4LL+uCfDMKiwbOEF8ULN1PT5nE9aTumKW3Q2 Jg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 32x7nmdggg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 18 Aug 2020 15:21:27 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07IF8EoD003662;
        Tue, 18 Aug 2020 15:19:27 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 32xsfs0eb4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 18 Aug 2020 15:19:27 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 07IFJObv002497;
        Tue, 18 Aug 2020 15:19:26 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 18 Aug 2020 08:19:24 -0700
Date:   Tue, 18 Aug 2020 08:19:23 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Eric Sandeen <sandeen@sandeen.net>,
        linux-xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH 3/7] xfs_db: add bigtime upgrade path
Message-ID: <20200818151923.GN6096@magnolia>
References: <159770508586.3958545.417872750558976156.stgit@magnolia>
 <159770510435.3958545.6606540263072605314.stgit@magnolia>
 <CAOQ4uxiL3Ja6dH9TbpQVtZfegc6jz2_pB7qE-a4Bg0XQLeLcAw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <CAOQ4uxiL3Ja6dH9TbpQVtZfegc6jz2_pB7qE-a4Bg0XQLeLcAw@mail.gmail.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9716 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=788
 spamscore=0 suspectscore=1 mlxscore=0 phishscore=0 bulkscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008180111
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9716 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 spamscore=0
 impostorscore=0 priorityscore=1501 adultscore=0 mlxscore=0 mlxlogscore=799
 lowpriorityscore=0 bulkscore=0 phishscore=0 malwarescore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008180111
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Aug 18, 2020 at 05:14:27PM +0300, Amir Goldstein wrote:
> On Tue, Aug 18, 2020 at 2:24 AM Darrick J. Wong <darrick.wong@oracle.com>=
 wrote:
> >
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> >
> > Enable users to upgrade their filesystems to bigtime support.
>=20
> That was supposed to be "inobtcount" (title as well)

Fixed, thanks. :)

--D

> Thanks,
> Amir.
