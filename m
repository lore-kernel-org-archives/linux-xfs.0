Return-Path: <SRS0=Yj0O=D2=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D87EC433DF
	for <linux-xfs@archiver.kernel.org>; Mon, 19 Oct 2020 16:09:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D82A22225F
	for <linux-xfs@archiver.kernel.org>; Mon, 19 Oct 2020 16:09:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="pIvS9SAr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730532AbgJSQJR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 19 Oct 2020 12:09:17 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:42858 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730525AbgJSQJR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 19 Oct 2020 12:09:17 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09JFxASq148462;
        Mon, 19 Oct 2020 16:08:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=fcICSu5KU68i6OTz5rBjraK2aum9WytxcX/X7xf6G9U=;
 b=pIvS9SArk8VZrQmjz6Z4j/R4H0BhNbQ4mqE2/x61tpjHLU45CDNpi6jV33Uy+HGfyCC7
 /ob25SFoC744+fXrNFYrqVS7ZopS+maK+kHDoUPESZy8YTHO9MtGNsZ/QGpjeWHtZQ7Y
 YTr9EtNI3Mzp8eNoBfMORYx78xyxfpGfzVhksMa8oI/t5wnTC1mxxo4Ich1fXMGOQ974
 7KzWwkWE81v+tp7iDM/bgj9B99FuWeRg1RUj8ouv+FK6I0AOh4cbSWvsbzl6519XWUYg
 MKM4IxbQXsC1QOvQ+OSGSFrPFe0wGvGKeqmWSx73IwL9yKIFrSPjQjUGAlReKhEfS6Fq uQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 347rjkpbp5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 19 Oct 2020 16:08:07 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09JFxwFS192075;
        Mon, 19 Oct 2020 16:08:07 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 348a6m2xp4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 19 Oct 2020 16:08:07 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 09JG83H5030174;
        Mon, 19 Oct 2020 16:08:04 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 19 Oct 2020 09:08:03 -0700
Date:   Mon, 19 Oct 2020 09:08:02 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     xiakaixu1987@gmail.com, linux-xfs@vger.kernel.org,
        Kaixu Xia <kaixuxia@tencent.com>
Subject: Re: [PATCH] xfs: remove the unused BBMASK macro
Message-ID: <20201019160802.GI9832@magnolia>
References: <1603100845-12205-1-git-send-email-kaixuxia@tencent.com>
 <c1453fb1-3e84-677c-15ab-7f51ca758862@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c1453fb1-3e84-677c-15ab-7f51ca758862@sandeen.net>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9778 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=999
 bulkscore=0 spamscore=0 adultscore=0 suspectscore=1 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010190110
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9778 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999 bulkscore=0
 spamscore=0 priorityscore=1501 impostorscore=0 lowpriorityscore=0
 phishscore=0 suspectscore=1 clxscore=1015 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010190110
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Oct 19, 2020 at 08:54:28AM -0500, Eric Sandeen wrote:
> On 10/19/20 4:47 AM, xiakaixu1987@gmail.com wrote:
> > From: Kaixu Xia <kaixuxia@tencent.com>
> > 
> > There are no callers of the BBMASK macro, so remove it.
> > 
> > Signed-off-by: Kaixu Xia <kaixuxia@tencent.com>
> > ---
> >  fs/xfs/libxfs/xfs_fs.h | 1 -
> >  1 file changed, 1 deletion(-)
> > 
> > diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
> > index 2a2e3cfd94f0..8fd1e20f0d73 100644
> > --- a/fs/xfs/libxfs/xfs_fs.h
> > +++ b/fs/xfs/libxfs/xfs_fs.h
> > @@ -847,7 +847,6 @@ struct xfs_scrub_metadata {
> >   */
> >  #define BBSHIFT		9
> >  #define BBSIZE		(1<<BBSHIFT)
> > -#define BBMASK		(BBSIZE-1)
> >  #define BTOBB(bytes)	(((__u64)(bytes) + BBSIZE - 1) >> BBSHIFT)
> >  #define BTOBBT(bytes)	((__u64)(bytes) >> BBSHIFT)
> >  #define BBTOB(bbs)	((bbs) << BBSHIFT)
> 
> 
> This header is shared with userspace, and the macro is used there,
> though only once.
> 
> This header is also shipped as part of the "install-dev" fileset, and
> defines a public API, though I don't think BBMSK is actually used
> in any userspace interface.

$ grep BBMASK /usr/include/
/usr/include/xfs/xfs_fs.h:868:#define BBMASK            (BBSIZE-1)

This ships in a user-visible header file, so it can only be removed by
going through the deprecation process.

--D

> 
> -Eric
