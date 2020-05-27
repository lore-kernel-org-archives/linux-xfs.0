Return-Path: <SRS0=YlU2=7J=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68B2BC433E1
	for <linux-xfs@archiver.kernel.org>; Wed, 27 May 2020 18:49:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4C2FF2089D
	for <linux-xfs@archiver.kernel.org>; Wed, 27 May 2020 18:49:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="pyht2KcX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726450AbgE0StC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 27 May 2020 14:49:02 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:43980 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726467AbgE0StB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 27 May 2020 14:49:01 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04RIfcfA088898
        for <linux-xfs@vger.kernel.org>; Wed, 27 May 2020 18:49:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to :
 subject : message-id : mime-version : content-type; s=corp-2020-01-29;
 bh=aYyzXBc2wBIjnBV8MDNV2HVVEWN2eh/drmCoDK323hw=;
 b=pyht2KcX+6dVn+WYKn/Pnh4o/Obtgk6JtGaJTxettpa6Y53DeZUJdFLIl12cJd5Uxs9E
 iTSL/guA32wtgqEEoB/KXXPX1SDLVfFJBjYGWXBn4Jo+P7bb0LAFIL8NMEIqD2h1R2Gw
 RCmKSSX+uXF69oxKufDkU33YutceqJ83C+l7MZDEvKnK5J4ij/ZasT9puo6rPGDP0bIH
 QGcC/j1XA4xaWk89nunW5SmieQfaA1irgnkJ+H00Jq5Uc0tTOSozjzpk62sRVc9EhxFj
 fU7uX7YyEDjwYZy9NAECc/4WkL0CURoU/ItBA0f6bE2iF/Hv2T3wRBHiMcSVNOilstq/ ZA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 316u8r15q5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Wed, 27 May 2020 18:49:00 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04RIh3iA164417
        for <linux-xfs@vger.kernel.org>; Wed, 27 May 2020 18:49:00 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 317ddra6n6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 27 May 2020 18:49:00 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 04RImxKZ018082
        for <linux-xfs@vger.kernel.org>; Wed, 27 May 2020 18:48:59 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 27 May 2020 11:48:59 -0700
Date:   Wed, 27 May 2020 11:48:58 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     xfs <linux-xfs@vger.kernel.org>
Subject: [XFS SUMMIT] Ugh, Rebasing Sucks!
Message-ID: <20200527184858.GM8230@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9633 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0 mlxscore=0
 phishscore=0 adultscore=0 suspectscore=1 spamscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005270143
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9633 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0
 priorityscore=1501 spamscore=0 cotscore=-2147483648 suspectscore=1
 phishscore=0 clxscore=1015 mlxlogscore=999 bulkscore=0 adultscore=0
 lowpriorityscore=0 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2005270143
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi everyone,

Many of you have complained (both publicly and privately) about the
heavy cost of rebasing your development trees, particularly when you're
getting close to sending a series out for review.  I get it, there have
been a lot of large refactoring patchsets coming in the past few kernel
cycles, and this has caused a lot of treewide churn.  I don't mind
cleanups of things that have been weird and wonky about XFS for years,
but, frankly, rebasing is soul-grinding.

To that end, I propose reducing the frequency of (my own) for-next
pushes to reduce how often people feel compelled to rebase when they're
trying to get a series ready for review.

Specifically, I would like to make an informal for-next push schedule as
follows:

 1 Between -rc1 and -rc4, I'll collect critical bug fixes for the
   merge window that just closed.  These should be small changes, so
   I'll put them out incrementally with the goal of landing everything
   in -rc4, and they shouldn't cause major disruptions for anyone else
   working on a big patchset.  This is more or less what I've been doing
   up till now -- if it's been on the list for > 24h and someone's
   reviewed it, I'll put it in for-next for wider testing.

 2 A day or two after -rc4 drops.  This push is targeted for the next
   merge window.  Coming three weeks after -rc1, I hope this will give
   everyone enough time for a round of rebase, review, and debugging of
   large changesets after -rc1.  IOWs, the majority of patchsets should
   be ready to go in before we get halfway to the next merge window.

 3 Another push a day or two after -rc6 drops.  This will hopefully give
   everyone a second chance to land patchsets that were nearly ready but
   didn't quite make it for -rc4; or other cleanups that would have
   interfered with the first round.  Once this is out, we're more or
   less finished with the big patchsets.

 4 Perhaps another big push a day or two after -rc8 drops?  I'm not keen
   on doing this.  It's not often that the kernel goes beyond -rc6 and I
   find it really stressful when the -rc's drag on but people keep
   sending large new patchsets.  Talk about stumbling around in the
   dark...

 5 Obviously, I wouldn't hold back on critical bug fixes to things that
   are broken in for-next, since the goal is to promote testing, not
   hinder it.

Hopefully this will cut down on the "arrrgh I was almost ready to send
this but then for-next jumped and nggghghghg" feelings. :/

Thoughts?  Flames?

--D
