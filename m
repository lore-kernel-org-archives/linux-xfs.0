Return-Path: <SRS0=Jdan=EO=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BCC02C55ABD
	for <linux-xfs@archiver.kernel.org>; Sun,  8 Nov 2020 17:23:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 72E2F20731
	for <linux-xfs@archiver.kernel.org>; Sun,  8 Nov 2020 17:23:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="F+jhItV7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728765AbgKHRXn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 8 Nov 2020 12:23:43 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:59238 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727570AbgKHRXn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 8 Nov 2020 12:23:43 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0A8HLG19035200;
        Sun, 8 Nov 2020 17:23:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=7mMuOXewHH2gDKdI+XEH/kD1aOQ26wKvm3w0FcIgKX4=;
 b=F+jhItV7aQ7NkdfEDxy/9j/yWdNhzMchksLuUimNg9hFJDUekjVqczhaEQBv3e8sJUHu
 Lq0sVghKKckCRvDtU5cJ26avsJY8JjAbr3yuGERvBv6265X5VX05K6uP1HRdU9qndNqU
 8Q8xhTqwTeBgqZxRAGKP9yZeSQ36oaK535TRjor0Jfbh9qYEK0FtjOf86kl2bA8wVQVC
 SRI/HoaK5nD6O3yCXton7e8rUUhkpbVRmA3G5hIrZQShjbj2pak2Em4ouupZJCnqDKOC
 10x+jplZVh8MHpsx37tR2r+i1GbS12TcdtKIF+hXLvqWSkY627MZREo1uS/mGifMAv+m oQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 34nkhkjwjg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sun, 08 Nov 2020 17:23:38 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0A8HL4bF191890;
        Sun, 8 Nov 2020 17:23:38 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 34p55k0me1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 08 Nov 2020 17:23:38 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0A8HNZOY008372;
        Sun, 8 Nov 2020 17:23:37 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 08 Nov 2020 09:23:35 -0800
Date:   Sun, 8 Nov 2020 09:23:33 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Eryu Guan <guan@eryu.me>
Cc:     guaneryu@gmail.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org
Subject: Re: [PATCH 0/9] xfstests: random fixes
Message-ID: <20201108172333.GB9695@magnolia>
References: <160382528936.1202316.2338876126552815991.stgit@magnolia>
 <20201108100532.GI3853@desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201108100532.GI3853@desktop>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9799 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0 phishscore=0
 mlxlogscore=999 mlxscore=0 malwarescore=0 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011080124
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9799 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 priorityscore=1501
 mlxscore=0 suspectscore=0 mlxlogscore=999 lowpriorityscore=0 spamscore=0
 malwarescore=0 adultscore=0 clxscore=1015 bulkscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011080124
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Nov 08, 2020 at 06:05:32PM +0800, Eryu Guan wrote:
> Hi Darric,
> 
> On Tue, Oct 27, 2020 at 12:01:29PM -0700, Darrick J. Wong wrote:
> > Hi all,
> > 
> > This series contains random fixes to fstests.
> 
> I applied patch 2-7 in this patchset, which were reviewed by Christoph,
> and seems other patches need rework.
> 
> And regarding to your other patchsets, I'm a bit lost, it seems some of
> them need rework as well. So I'd wait for your refresh version :)

Yes.  I'll try to send a revised series this week, though I got bogged
down in a bug hunt.

--D

> Thanks,
> Eryu
> 
> > 
> > If you're going to start using this mess, you probably ought to just
> > pull from my git trees, which are linked below.
> > 
> > This is an extraordinary way to destroy everything.  Enjoy!
> > Comments and questions are, as always, welcome.
> > 
> > --D
> > 
> > kernel git tree:
> > https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=random-fixes
> > 
> > xfsprogs git tree:
> > https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=random-fixes
> > 
> > fstests git tree:
> > https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=random-fixes
> > ---
> >  check             |   21 ++++++++++++++++++++-
> >  common/populate   |    5 +++++
> >  common/rc         |   13 ++++++++++---
> >  common/repair     |    1 +
> >  common/xfs        |   20 ++++++++++++++++++++
> >  tests/xfs/030     |    1 +
> >  tests/xfs/272     |    3 +++
> >  tests/xfs/276     |    8 +++++++-
> >  tests/xfs/327     |   18 ++++++++++++++++--
> >  tests/xfs/327.out |   13 +++++++------
> >  tests/xfs/328     |    2 +-
> >  tests/xfs/341     |    8 +++++---
> >  tests/xfs/520     |    3 +++
> >  13 files changed, 99 insertions(+), 17 deletions(-)
