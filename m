Return-Path: <SRS0=Htpe=6U=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43B75C28CBC
	for <linux-xfs@archiver.kernel.org>; Wed,  6 May 2020 19:28:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1A6D82087E
	for <linux-xfs@archiver.kernel.org>; Wed,  6 May 2020 19:28:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="o5+jFn4L"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728991AbgEFT2u (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 6 May 2020 15:28:50 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:40612 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728953AbgEFT2u (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 6 May 2020 15:28:50 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 046JRgk4093795;
        Wed, 6 May 2020 19:28:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=G3UFGOxg4uH2qo6URHL+EB2jyAjVZvfsZmp3RyevREU=;
 b=o5+jFn4LpvefPdAzMvqdezJwuxt0jpEgKijtGdxrkB28yYUlR9e1W78XUUjOrmEgidtr
 ML6v3Lc/ZusvEkwg15WNeKnpBNtZdpb8SCKrCzkEgjhX4LT5b2VdyBeB3zG0wQ14Op1X
 LRx2xnNwz7omAFXDCA10d6gH0usMHaAfqSmyTJSHhi73QjaWAh03xRdZB/Tfp1VnxoQq
 q/KbZ3SnyFAHSUu/WnqPA5ljm+TpqtOMMZA5mwpSktWMxyrfA7Eqkhb5dsN9l5wl2xh+
 bh/SxjHkerYMpjZGtg7AsfFsmG8ViI1AXcjYNhocw80ESIyN8Oxl97BHKkivzZrHewN2 DQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 30s09rcc98-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 06 May 2020 19:28:41 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 046JRTf8126473;
        Wed, 6 May 2020 19:28:40 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 30sjnkeqw3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 06 May 2020 19:28:40 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 046JSdS5016952;
        Wed, 6 May 2020 19:28:39 GMT
Received: from localhost (/10.159.237.186)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 06 May 2020 12:28:39 -0700
Date:   Wed, 6 May 2020 12:28:37 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 22/28] xfs: refactor adding recovered intent items to the
 log
Message-ID: <20200506192837.GD6714@magnolia>
References: <158864103195.182683.2056162574447133617.stgit@magnolia>
 <158864117369.182683.15552207685086345850.stgit@magnolia>
 <20200506153110.GA7864@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200506153110.GA7864@infradead.org>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9613 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 adultscore=0 phishscore=0
 mlxlogscore=999 bulkscore=0 malwarescore=0 spamscore=0 suspectscore=1
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005060157
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9613 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0
 lowpriorityscore=0 spamscore=0 adultscore=0 clxscore=1015 suspectscore=1
 priorityscore=1501 malwarescore=0 mlxlogscore=999 phishscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005060157
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, May 06, 2020 at 08:31:10AM -0700, Christoph Hellwig wrote:
> On Mon, May 04, 2020 at 06:12:53PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > During recovery, every intent that we recover from the log has to be
> > added to the AIL.  Replace the open-coded addition with a helper.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > Reviewed-by: Christoph Hellwig <hch@lst.de>
> 
> Second thoughts: given that the helper is totally generic, maybe
> name it xfs_trans_ail_insert and keep it in the generic AIL code?

Ok, renamed to xfs_trans_ail_insert and moved to xfs_trans_ail.c.

--D
