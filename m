Return-Path: <SRS0=QtPe=ZO=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BCA1BC432C3
	for <linux-xfs@archiver.kernel.org>; Fri, 22 Nov 2019 16:12:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 939712071C
	for <linux-xfs@archiver.kernel.org>; Fri, 22 Nov 2019 16:12:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="l9WCd2sv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726655AbfKVQMe (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 22 Nov 2019 11:12:34 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:39190 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726546AbfKVQMe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 22 Nov 2019 11:12:34 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAMG4bpE012753;
        Fri, 22 Nov 2019 16:12:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 content-transfer-encoding : in-reply-to; s=corp-2019-08-05;
 bh=W/UlRI2FhmOIhBuZwF0nQpI/K1vBEWjO799bMuwFbgQ=;
 b=l9WCd2svr2gMd/QTebAeLXowH8Bu6Qzw8Okf64R45lkdu1wKuBSRHnp9tkR5fdUaJMcD
 BaMBrwSjkInCXEnaRjBIVK6wTi8qAhCuFOB46weRFEA5BBctqfwMZBIQrUaNN1TFudK5
 x/cE0EXbT8OkYu94detxkymgy3uQFRhzb450MDffshqiVDq1RQh1fg4MnpzEVf/8+RLW
 vHgjCBssQxrQjyf5pj0VLgMTsFGx9WqnxdfiApYPyZPA1wtPnnlple56yxwVeSy0Enyx
 s7BSHRepBKxcf+G+z2F0JZtUuZBk7GwstCkD52XbNnCFtImg4CwLSOQVD+MowAjf5rhP yA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2wa8hubk01-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 22 Nov 2019 16:12:28 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAMG47wl018585;
        Fri, 22 Nov 2019 16:12:28 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 2wegqrg1x0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 22 Nov 2019 16:12:27 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xAMGCOKT020446;
        Fri, 22 Nov 2019 16:12:26 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 22 Nov 2019 08:12:23 -0800
Date:   Fri, 22 Nov 2019 08:12:22 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Andrew Carr <andrewlanecarr@gmail.com>
Cc:     Dave Chinner <david@fromorbit.com>,
        Eric Sandeen <sandeen@sandeen.net>, linux-xfs@vger.kernel.org
Subject: Re: Fwd: XFS Memory allocation deadlock in kmem_alloc
Message-ID: <20191122161222.GG6219@magnolia>
References: <CAKQeeLMxJR-ToX5HG9Q-z0-AL9vZG-OMjHyM+rnEEBP6k6nxHw@mail.gmail.com>
 <CAKQeeLNewDe6hu92Tu19=Opx_ao7F_fbpxOsEHaUH9e2NmLWaQ@mail.gmail.com>
 <e6222784-03a5-6902-0f2e-10303962749c@sandeen.net>
 <20191115234333.GP4614@dread.disaster.area>
 <CAKQeeLNm51r0g=hyH7xpe811nMTS7SP_AwAtAZMCZ0t3Fz4=4Q@mail.gmail.com>
 <CAKQeeLPzked5nptbF6HKdt=u_LkOU-RqOQ8V0r1f7PBS1xWejQ@mail.gmail.com>
 <20191119202038.GX4614@dread.disaster.area>
 <CAKQeeLMnkvx94ssht-nt0S8eU1uCFqVL4w2yxwY4M5X59RSROA@mail.gmail.com>
 <CAKQeeLMLj-inQ4sxCLBomuthjNWbd_85VRwAVWk4TvVhLMVC6A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAKQeeLMLj-inQ4sxCLBomuthjNWbd_85VRwAVWk4TvVhLMVC6A@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9448 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1911220138
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9448 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1911220138
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Nov 22, 2019 at 09:08:26AM -0500, Andrew Carr wrote:
> Hi Dave  / Others,
> 
> It appears upgrading to 4.17+ has indeed fixed the deadlock issue, or
> at least no deadlocks are occurring now.
> 
> There are segfaults in xfs_db appearing now though.  I am attempting
> to get the full syslog, here is an example.... thoughts?
> 
> [Thu Nov 21 10:43:20 2019] xfs_db[13076]: segfault at 12ff6001 ip
> 0000000000407922 sp 00007ffe1a27b2e0 error 4 in xfs_db[400000+8a000]
> [Thu Nov 21 10:43:20 2019] Code: 89 cc 55 48 89 d5 53 48 89 f3 48 83
> ec 48 0f b6 57 01 44 0f b6 4f 02 64 48 8b 04 25 28 00 00 00 48 89 44
> 24 38 31 c0 0f b6 07 <44> 0f b6 57 0d 48 8d 74 24 10 c1 e2 10 41 c1 e1
> 08 c1 e0 18 41 c1

Actual coredumps of the crashed xfs_db would help.

--D

> Thanks so much in advance!
> Andrew
> 
> On Wed, Nov 20, 2019 at 10:43 AM Andrew Carr <andrewlanecarr@gmail.com> wrote:
> >
> > Genius Dave, Thanks so much!
> >
> > On Tue, Nov 19, 2019 at 3:21 PM Dave Chinner <david@fromorbit.com> wrote:
> > >
> > > On Tue, Nov 19, 2019 at 10:49:56AM -0500, Andrew Carr wrote:
> > > > Dave / Eric / Others,
> > > >
> > > > Syslog: https://pastebin.com/QYQYpPFY
> > > >
> > > > Dmesg: https://pastebin.com/MdBCPmp9
> > >
> > > which shows no stack traces, again.
> > >
> > >
> > >
> > > Anyway, you've twiddled mkfs knobs on these filesystems, and that
> > > is the likely cause of the issue: the filesystem is using 64k
> > > directory blocks - the allocation size is larger than 64kB:
> > >
> > > [Sun Nov 17 21:40:05 2019] XFS: nginx(31293) possible memory allocation deadlock size 65728 in kmem_alloc (mode:0x250)
> > >
> > > Upstream fixed this some time ago:
> > >
> > > $ ▶ gl -n 1 -p cb0a8d23024e
> > > commit cb0a8d23024e7bd234dea4d0fc5c4902a8dda766
> > > Author: Dave Chinner <dchinner@redhat.com>
> > > Date:   Tue Mar 6 17:03:28 2018 -0800
> > >
> > >     xfs: fall back to vmalloc when allocation log vector buffers
> > >
> > >     When using large directory blocks, we regularly see memory
> > >     allocations of >64k being made for the shadow log vector buffer.
> > >     When we are under memory pressure, kmalloc() may not be able to find
> > >     contiguous memory chunks large enough to satisfy these allocations
> > >     easily, and if memory is fragmented we can potentially stall here.
> > >
> > >     TO avoid this problem, switch the log vector buffer allocation to
> > >     use kmem_alloc_large(). This will allow failed allocations to fall
> > >     back to vmalloc and so remove the dependency on large contiguous
> > >     regions of memory being available. This should prevent slowdowns
> > >     and potential stalls when memory is low and/or fragmented.
> > >
> > >     Signed-Off-By: Dave Chinner <dchinner@redhat.com>
> > >     Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> > >     Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > >
> > >
> > > Cheers,
> > >
> > > Dave.
> > > --
> > > Dave Chinner
> > > david@fromorbit.com
> >
> >
> >
> > --
> > With Regards,
> > Andrew Carr
> >
> > e. andrewlanecarr@gmail.com
> > w. andrew.carr@openlogic.com
> > c. 4239489206
> > a. P.O. Box 1231, Greeneville, TN, 37744
> 
> 
> 
> -- 
> With Regards,
> Andrew Carr
> 
> e. andrewlanecarr@gmail.com
> w. andrew.carr@openlogic.com
> c. 4239489206
> a. P.O. Box 1231, Greeneville, TN, 37744
