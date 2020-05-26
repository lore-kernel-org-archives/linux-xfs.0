Return-Path: <SRS0=dAFJ=7I=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2E57C433E0
	for <linux-xfs@archiver.kernel.org>; Tue, 26 May 2020 15:59:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B01662075F
	for <linux-xfs@archiver.kernel.org>; Tue, 26 May 2020 15:59:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="mRjrVzL8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730210AbgEZP7c (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 26 May 2020 11:59:32 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:44796 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729102AbgEZP7c (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 26 May 2020 11:59:32 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04QFw6cT045518;
        Tue, 26 May 2020 15:59:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=xXMed94Tel1l7LWoYtye3UdQNB2BjxqtZigR3lUDAmg=;
 b=mRjrVzL8efM/8EkeXfxmWCsTCVwEae+qCjZQcHsI1gaIcXA8c13vTL6Zb28u5h3DmasU
 AEoKFAn75ciQcpSv8drFcOtgRKNkZgNY33Th5w4fMGMWGPqO4ZD/L1gda9rKpNAphrhN
 WzFiJK99MNPaUphoHekrL13Ci825X/FOsAtLVOpG+pudiSsVc7kd3rx4WkZFUkkkLEFg
 kGGQ4YNnnXDzOahl3huBRQwHO3rTD1s4T99lSHu9xsoKQi4XkgSVJRM0o/8LGXY9EMMr
 iv+Kjvq2OOr15oGfb7v4aNZIYd2kcAIuAg9e815UdDyM1s69JoA98t8qAmgFo+WxhEiM IA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 318xbjtrxw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 26 May 2020 15:59:27 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04QFmvQ2006089;
        Tue, 26 May 2020 15:57:27 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 317drxpv26-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 26 May 2020 15:57:26 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 04QFvQ4o015276;
        Tue, 26 May 2020 15:57:26 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 26 May 2020 08:57:25 -0700
Date:   Tue, 26 May 2020 08:57:24 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>,
        Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH 00/14] xfs: widen timestamps to deal with y2038
Message-ID: <20200526155724.GJ8230@magnolia>
References: <157784106066.1364230.569420432829402226.stgit@magnolia>
 <CAOQ4uxjhrW3EkzNm8y7TmCTWQS82VreAVy608X7naaLPfWSFeA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxjhrW3EkzNm8y7TmCTWQS82VreAVy608X7naaLPfWSFeA@mail.gmail.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9633 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 malwarescore=0
 mlxlogscore=999 adultscore=0 suspectscore=0 bulkscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005260122
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9633 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 spamscore=0 mlxscore=0
 lowpriorityscore=0 priorityscore=1501 phishscore=0 cotscore=-2147483648
 suspectscore=0 bulkscore=0 clxscore=1015 impostorscore=0 malwarescore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2005260123
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, May 26, 2020 at 12:20:59PM +0300, Amir Goldstein wrote:
> On Wed, Jan 1, 2020 at 3:11 AM Darrick J. Wong <darrick.wong@oracle.com> wrote:
> >
> > Hi all,
> >
> > This series performs some refactoring of our timestamp and inode
> > encoding functions, then retrofits the timestamp union to handle
> > timestamps as a 64-bit nanosecond counter.  Next, it refactors the quota
> > grace period expiration timer code a bit before implementing bit
> > shifting to widen the effective counter size to 34 bits.  This enables
> > correct time handling on XFS through the year 2486.
> >
> 
> I intend to start review of this series.
> I intend to focus on correctness of conversions and on backward
> forward compatibility.
> 
> I saw Eric's comments on quota patches and that you mentioned
> you addressed some of them. I do not intend to review correctness
> of existing quota code anyway ;-)
> 
> I see that you updated the branch 3 days ago and that patch 2/14
> was dropped. I assume the rest of the series is mostly unchanged,
> but I can verify that before reviewing each patch.
> 
> As far as you are concerned, should I wait for v2 or can I continue
> to review this series?

I plan to rebase the whole series after 5.8-rc1, but if you'd like to
look at the higher level details (particularly in the quota code, which
is a bit murky) sooner than later, I don't mind emailing out what I have
now.

--D

> Thanks,
> Amir.
> 
> 
> 
> > If you're going to start using this mess, you probably ought to just
> > pull from my git trees, which are linked below.
> >
> > This is an extraordinary way to destroy everything.  Enjoy!
> > Comments and questions are, as always, welcome.
> >
> > --D
> >
> > kernel git tree:
> > https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=bigtime
> >
> > xfsprogs git tree:
> > https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=bigtime
> >
> > fstests git tree:
> > https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=bigtime
