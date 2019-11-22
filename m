Return-Path: <SRS0=QtPe=ZO=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65F35C432C0
	for <linux-xfs@archiver.kernel.org>; Fri, 22 Nov 2019 18:49:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 300CA20707
	for <linux-xfs@archiver.kernel.org>; Fri, 22 Nov 2019 18:49:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="oIoRhOpb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726187AbfKVStz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 22 Nov 2019 13:49:55 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:55706 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726062AbfKVStz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 22 Nov 2019 13:49:55 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAMIi7gO122062;
        Fri, 22 Nov 2019 18:49:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 content-transfer-encoding : in-reply-to; s=corp-2019-08-05;
 bh=Lu+2VOzdpKH/SXIal5TpI/ZUdYsvPgVodb6h1AvCboI=;
 b=oIoRhOpbyqCz4NKGCL6Ht04knbjEnR1ghdGHVbf3oPDQCkUNPMHaOAI7KvrPPRrUk9fG
 3678QdhN7GQkImoE6+ndow/gfaCZwuIfIgtfPBVt5DiG5scODz91DXyAYNwI243YR4Sh
 +9IfZ19IPujZTZPhsA/KFqYmdJCgn8wslvdMYTFfXYFgCc6Qhf9iHDAkvm/NGvCjnvnn
 5QFqH2QVwk983XDUp876FpRPndBupSuUHQn3hOTN79lXIwUBF4xJd4tahSI6TS5BXJ6H
 2cgEj+DIrBNbEAC5P+JevXoG+ss95ttVqlZaHlVss8Yz/5fa7ydCNi0jQh8U6sFgPQQ9 iA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2wa9rr4a4k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 22 Nov 2019 18:49:48 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAMImvlT053800;
        Fri, 22 Nov 2019 18:49:48 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 2wec29apry-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 22 Nov 2019 18:49:48 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xAMInk66007476;
        Fri, 22 Nov 2019 18:49:47 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 22 Nov 2019 10:49:46 -0800
Date:   Fri, 22 Nov 2019 10:49:45 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Blake Golliher <bgolliher@box.com>
Cc:     Andrew Carr <andrewlanecarr@gmail.com>,
        Dave Chinner <david@fromorbit.com>,
        Eric Sandeen <sandeen@sandeen.net>, linux-xfs@vger.kernel.org
Subject: Re: Fwd: XFS Memory allocation deadlock in kmem_alloc
Message-ID: <20191122184945.GE2981917@magnolia>
References: <CAKQeeLNewDe6hu92Tu19=Opx_ao7F_fbpxOsEHaUH9e2NmLWaQ@mail.gmail.com>
 <e6222784-03a5-6902-0f2e-10303962749c@sandeen.net>
 <20191115234333.GP4614@dread.disaster.area>
 <CAKQeeLNm51r0g=hyH7xpe811nMTS7SP_AwAtAZMCZ0t3Fz4=4Q@mail.gmail.com>
 <CAKQeeLPzked5nptbF6HKdt=u_LkOU-RqOQ8V0r1f7PBS1xWejQ@mail.gmail.com>
 <20191119202038.GX4614@dread.disaster.area>
 <CAKQeeLMnkvx94ssht-nt0S8eU1uCFqVL4w2yxwY4M5X59RSROA@mail.gmail.com>
 <CAKQeeLMLj-inQ4sxCLBomuthjNWbd_85VRwAVWk4TvVhLMVC6A@mail.gmail.com>
 <20191122161222.GG6219@magnolia>
 <CAC752A=7x+gh9Jr8-koQtuZDvMzrs6qRc+saj=TMC3js9EdHbg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAC752A=7x+gh9Jr8-koQtuZDvMzrs6qRc+saj=TMC3js9EdHbg@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9449 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1911220154
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9449 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1911220154
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Nov 22, 2019 at 10:17:33AM -0800, Blake Golliher wrote:
> Where would those core dumps be?  Are they automatically dumped or do we
> have to set a flag, then trigger the condition?

ulimit -c 9999999999, then run whatever it was you were running that
invokes xfs_db.

--D

> On Fri, Nov 22, 2019 at 8:12 AM Darrick J. Wong <darrick.wong@oracle.com>
> wrote:
> 
> >
> >
> > CAUTION: External Email
> >
> >
> >
> >
> > On Fri, Nov 22, 2019 at 09:08:26AM -0500, Andrew Carr wrote:
> > > Hi Dave  / Others,
> > >
> > > It appears upgrading to 4.17+ has indeed fixed the deadlock issue, or
> > > at least no deadlocks are occurring now.
> > >
> > > There are segfaults in xfs_db appearing now though.  I am attempting
> > > to get the full syslog, here is an example.... thoughts?
> > >
> > > [Thu Nov 21 10:43:20 2019] xfs_db[13076]: segfault at 12ff6001 ip
> > > 0000000000407922 sp 00007ffe1a27b2e0 error 4 in xfs_db[400000+8a000]
> > > [Thu Nov 21 10:43:20 2019] Code: 89 cc 55 48 89 d5 53 48 89 f3 48 83
> > > ec 48 0f b6 57 01 44 0f b6 4f 02 64 48 8b 04 25 28 00 00 00 48 89 44
> > > 24 38 31 c0 0f b6 07 <44> 0f b6 57 0d 48 8d 74 24 10 c1 e2 10 41 c1 e1
> > > 08 c1 e0 18 41 c1
> >
> > Actual coredumps of the crashed xfs_db would help.
> >
> > --D
> >
> > > Thanks so much in advance!
> > > Andrew
> > >
> > > On Wed, Nov 20, 2019 at 10:43 AM Andrew Carr <andrewlanecarr@gmail.com>
> > wrote:
> > > >
> > > > Genius Dave, Thanks so much!
> > > >
> > > > On Tue, Nov 19, 2019 at 3:21 PM Dave Chinner <david@fromorbit.com>
> > wrote:
> > > > >
> > > > > On Tue, Nov 19, 2019 at 10:49:56AM -0500, Andrew Carr wrote:
> > > > > > Dave / Eric / Others,
> > > > > >
> > > > > > Syslog:
> > https://urldefense.proofpoint.com/v2/url?u=https-3A__pastebin.com_QYQYpPFY&d=DwIDaQ&c=4dvmKrCYCD_MWOWC_k7VMw&r=NRVQX89iLxYf06dcpbIrijtLC-DKd-z7vxj002MWTmI&m=gtReaQZA21GCSFtWKk0Ycbpr-Ra30apUfn69fetsCyI&s=cFo_9R18qcbqlKAa2jfsMB02h74aHd4m04zbNPYS1-I&e=
> > > > > >
> > > > > > Dmesg:
> > https://urldefense.proofpoint.com/v2/url?u=https-3A__pastebin.com_MdBCPmp9&d=DwIDaQ&c=4dvmKrCYCD_MWOWC_k7VMw&r=NRVQX89iLxYf06dcpbIrijtLC-DKd-z7vxj002MWTmI&m=gtReaQZA21GCSFtWKk0Ycbpr-Ra30apUfn69fetsCyI&s=E9ryV4GnH02exSAsoFGbq1arjRLkyffNjka_kZ4MV60&e=
> > > > >
> > > > > which shows no stack traces, again.
> > > > >
> > > > >
> > > > >
> > > > > Anyway, you've twiddled mkfs knobs on these filesystems, and that
> > > > > is the likely cause of the issue: the filesystem is using 64k
> > > > > directory blocks - the allocation size is larger than 64kB:
> > > > >
> > > > > [Sun Nov 17 21:40:05 2019] XFS: nginx(31293) possible memory
> > allocation deadlock size 65728 in kmem_alloc (mode:0x250)
> > > > >
> > > > > Upstream fixed this some time ago:
> > > > >
> > > > > $ ▶ gl -n 1 -p cb0a8d23024e
> > > > > commit cb0a8d23024e7bd234dea4d0fc5c4902a8dda766
> > > > > Author: Dave Chinner <dchinner@redhat.com>
> > > > > Date:   Tue Mar 6 17:03:28 2018 -0800
> > > > >
> > > > >     xfs: fall back to vmalloc when allocation log vector buffers
> > > > >
> > > > >     When using large directory blocks, we regularly see memory
> > > > >     allocations of >64k being made for the shadow log vector buffer.
> > > > >     When we are under memory pressure, kmalloc() may not be able to
> > find
> > > > >     contiguous memory chunks large enough to satisfy these
> > allocations
> > > > >     easily, and if memory is fragmented we can potentially stall
> > here.
> > > > >
> > > > >     TO avoid this problem, switch the log vector buffer allocation to
> > > > >     use kmem_alloc_large(). This will allow failed allocations to
> > fall
> > > > >     back to vmalloc and so remove the dependency on large contiguous
> > > > >     regions of memory being available. This should prevent slowdowns
> > > > >     and potential stalls when memory is low and/or fragmented.
> > > > >
> > > > >     Signed-Off-By: Dave Chinner <dchinner@redhat.com>
> > > > >     Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> > > > >     Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > > > >
> > > > >
> > > > > Cheers,
> > > > >
> > > > > Dave.
> > > > > --
> > > > > Dave Chinner
> > > > > david@fromorbit.com
> > > >
> > > >
> > > >
> > > > --
> > > > With Regards,
> > > > Andrew Carr
> > > >
> > > > e. andrewlanecarr@gmail.com
> > > > w. andrew.carr@openlogic.com
> > > > c. 4239489206
> > > > a. P.O. Box 1231, Greeneville, TN, 37744
> > >
> > >
> > >
> > > --
> > > With Regards,
> > > Andrew Carr
> > >
> > > e. andrewlanecarr@gmail.com
> > > w. andrew.carr@openlogic.com
> > > c. 4239489206
> > > a. P.O. Box 1231, Greeneville, TN, 37744
> >
