Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7DB26C63697
	for <linux-xfs@archiver.kernel.org>; Mon, 23 Nov 2020 18:22:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3523A221FC
	for <linux-xfs@archiver.kernel.org>; Mon, 23 Nov 2020 18:22:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="A0+DNBYu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728803AbgKWSWi (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 23 Nov 2020 13:22:38 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:58092 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728576AbgKWSWi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 23 Nov 2020 13:22:38 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0ANIEVQe166312;
        Mon, 23 Nov 2020 18:22:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=6Vpx/jsURZ2a/K7FhgWqoIxjfGy5kOrxpuqulQp/Z6g=;
 b=A0+DNBYucA8NTgg/pF1JuwIdEORxsutXGkSY4XE84R8GXdmP7DIsBIPNQXb5SSnvU4Jy
 4ky6iuwo3l5LhISlvmOUuPsygq2vAhRFND8MJGnZHwfuZTQj+MoPtwoOQ5ZGt+zqvRrh
 Xl8wq68HVIyNzZg0DfnRBrWyeNaI+1JcaNK0GnCW98yvnv1LIHwFTaXNV/t0jhQRVfSp
 6z4XocL70O4Zdu/InG7L+pgMjewAD1V283vpJjyUSXNOnJwxyRHung9fNjAP/ZWfysQr
 E2lyNK62eFY5iVG9gvc13RdwXcYEw7maXwXebilmAHjDlXlA7n3qj1Hmq9JeeoU7Ths6 UQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 34xtukxmxm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 23 Nov 2020 18:22:33 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0ANIFpGP170692;
        Mon, 23 Nov 2020 18:20:32 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 34ycnr9p72-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 23 Nov 2020 18:20:32 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0ANIKVDC000384;
        Mon, 23 Nov 2020 18:20:31 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 23 Nov 2020 10:20:31 -0800
Date:   Mon, 23 Nov 2020 10:20:30 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Eryu Guan <guan@eryu.me>
Cc:     guaneryu@gmail.com, Chandan Babu R <chandanrlinux@gmail.com>,
        linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 0/7] various: test xfs things fixed in 5.10
Message-ID: <20201123182030.GC7880@magnolia>
References: <160505542802.1388823.10368384826199448253.stgit@magnolia>
 <20201122142744.GK3853@desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201122142744.GK3853@desktop>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9814 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0
 mlxlogscore=999 phishscore=0 spamscore=0 malwarescore=0 adultscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011230121
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9814 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 lowpriorityscore=0
 malwarescore=0 mlxlogscore=999 impostorscore=0 spamscore=0 mlxscore=0
 phishscore=0 clxscore=1015 suspectscore=0 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011230121
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Nov 22, 2020 at 10:27:44PM +0800, Eryu Guan wrote:
> On Tue, Nov 10, 2020 at 04:43:48PM -0800, Darrick J. Wong wrote:
> > Hi all,
> > 
> > Here are a bunch of new tests for problems that were fixed in 5.10.
> > Er.... 5.10 and 5.9.  I have not been good at sending to fstests
> > upstream lately. :( :(
> 
> It seems all these tests are regression tests for bugs that have been
> fixed in v5.10 cycle, and some of the tests didn't list the associated
> commits that fixed the bug, and some tests listed the patch titles but
> not the commit IDs. Would you please fix them up as well?

Yes, I'll do that.

--D

> > 
> > If you're going to start using this mess, you probably ought to just
> > pull from my git trees, which are linked below.
> > 
> > This is an extraordinary way to destroy everything.  Enjoy!
> > Comments and questions are, as always, welcome.
> > 
> > --D
> > 
> > fstests git tree:
> > https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=test-fixes-5.10
> > ---
> >  tests/generic/947     |  117 ++++++++++++++++++++++++++++++++
> >  tests/generic/947.out |   15 ++++
> >  tests/generic/948     |   90 ++++++++++++++++++++++++
> >  tests/generic/948.out |    9 ++
> >  tests/generic/group   |    2 +
> >  tests/xfs/122         |    1 
> >  tests/xfs/122.out     |    1 
> >  tests/xfs/758         |   59 ++++++++++++++++
> >  tests/xfs/758.out     |    2 +
> >  tests/xfs/759         |   99 +++++++++++++++++++++++++++
> >  tests/xfs/759.out     |    2 +
> >  tests/xfs/760         |   66 ++++++++++++++++++
> >  tests/xfs/760.out     |    9 ++
> >  tests/xfs/761         |   42 +++++++++++
> >  tests/xfs/761.out     |    1 
> 
> "Silence is golden" is missed in 761.out :)
> 
> Thanks,
> Eryu
> 
> >  tests/xfs/763         |  181 +++++++++++++++++++++++++++++++++++++++++++++++++
> >  tests/xfs/763.out     |   91 +++++++++++++++++++++++++
> >  tests/xfs/915         |  176 ++++++++++++++++++++++++++++++++++++++++++++++++
> >  tests/xfs/915.out     |  151 +++++++++++++++++++++++++++++++++++++++++
> >  tests/xfs/group       |    6 ++
> >  20 files changed, 1119 insertions(+), 1 deletion(-)
> >  create mode 100755 tests/generic/947
> >  create mode 100644 tests/generic/947.out
> >  create mode 100755 tests/generic/948
> >  create mode 100644 tests/generic/948.out
> >  create mode 100755 tests/xfs/758
> >  create mode 100644 tests/xfs/758.out
> >  create mode 100755 tests/xfs/759
> >  create mode 100644 tests/xfs/759.out
> >  create mode 100755 tests/xfs/760
> >  create mode 100644 tests/xfs/760.out
> >  create mode 100755 tests/xfs/761
> >  create mode 100644 tests/xfs/761.out
> >  create mode 100755 tests/xfs/763
> >  create mode 100644 tests/xfs/763.out
> >  create mode 100755 tests/xfs/915
> >  create mode 100644 tests/xfs/915.out
