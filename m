Return-Path: <SRS0=+9Bg=A4=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A78F2C433E3
	for <linux-xfs@archiver.kernel.org>; Fri, 17 Jul 2020 20:09:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 81E712065D
	for <linux-xfs@archiver.kernel.org>; Fri, 17 Jul 2020 20:09:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="B4UhzZWr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728432AbgGQUJf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 17 Jul 2020 16:09:35 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:59016 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726771AbgGQUJe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 17 Jul 2020 16:09:34 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06HK8CTn153973;
        Fri, 17 Jul 2020 20:09:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=lA37IPZvJ84ABk+CRcaItjSoDQDCwOQb3a5ru8DL4n4=;
 b=B4UhzZWrJD0SKDChj9040JWoB4nT/KDUJBA01DLYO8/OQ3qJgnse5hd+TMISIQ23BQcc
 yPkTjyo+CeHsP4MniR3LE5UxKV6Hebdr0TIoUB5N3OjpXMNc3exE4gAMiT6ZVrcsQ4NS
 NkRy7J6gMyauHhwb31quRY669OdIxi+q9/YXTlsQ3IGlZixwA5MBKI4PXgE7tc5VCXKj
 7sdUwqBQW0DhL2aSt2AQPi9Wc6eI9x/KCv+oCSFD1PiSsEiAhQFXdhb5IVO83we5Z56e
 lLDYAiTcSF29OnJcjxcW03zbC8Bmro1h8WmF3rnn/yBVfb7Ar6oElOufUCeWNE36Tcot 9Q== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2130.oracle.com with ESMTP id 327s65yka1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 17 Jul 2020 20:09:29 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06HJwnuF107420;
        Fri, 17 Jul 2020 20:07:29 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 32bjd3hh78-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 17 Jul 2020 20:07:29 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 06HK7SCh013387;
        Fri, 17 Jul 2020 20:07:28 GMT
Received: from localhost (/10.159.159.76)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 17 Jul 2020 13:07:27 -0700
Date:   Fri, 17 Jul 2020 13:07:26 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     Brian Foster <bfoster@redhat.com>,
        Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: fix inode allocation block res calculation
 precedence
Message-ID: <20200717200726.GO3151642@magnolia>
References: <20200715193310.22002-1-bfoster@redhat.com>
 <20200715222935.GI2005@dread.disaster.area>
 <20200716014759.GH3151642@magnolia>
 <20200716020209.GK2005@dread.disaster.area>
 <20200716121811.GB31705@bfoster>
 <9e464b84-7945-95b5-c6ff-ae3eb8bee878@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9e464b84-7945-95b5-c6ff-ae3eb8bee878@sandeen.net>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9685 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 mlxlogscore=999
 malwarescore=0 suspectscore=1 adultscore=0 phishscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007170135
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9685 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0
 phishscore=0 mlxscore=0 priorityscore=1501 lowpriorityscore=0 spamscore=0
 clxscore=1015 bulkscore=0 mlxlogscore=999 impostorscore=0 suspectscore=1
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007170136
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jul 17, 2020 at 10:16:02AM -0700, Eric Sandeen wrote:
> On 7/16/20 5:18 AM, Brian Foster wrote:
> > On Thu, Jul 16, 2020 at 12:02:09PM +1000, Dave Chinner wrote:
> 
> ...
> 
> >> i.e. XFS_IALLOC_SPACE_RES() is used in just 7 places in the code,
> >> 4 of them are in that same header file, so it's a simple, standalone
> >> patch that fixes the bug by addressing the underlying cause of
> >> the problem (i.e. nasty macro!).
> >>
> > I agree that the inline is nicer than the macro, but a transaction
> > reservation value seems misplaced to me in the IGEO. Perhaps having
> > something analogous to struct xfs_trans_resv might be more appropriate.
> 
> For whatever my opinion is worth these days, it seems like doing
> a survey to see how many of these reservations are static would be a
> good first step, and then decide where they should all go if they should
> move. I agree that IGEO might be a little odd, depending on what other
> static reservation types there are and what they're associated with.
> 
> I see both sides of the discussion re: how fixes like this move forward
> and what's easily backportable but in this case (and maybe I'm missing
> context) it seems like a wider survey would be wise before deciding to
> move this one value to IGEO in particular.

Agreed.  AFAICT the first patch is a bug fix for broken functionality,
so I will put it in the 5.9 branch update next week.

--D

> -Eric
