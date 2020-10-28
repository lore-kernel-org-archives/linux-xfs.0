Return-Path: <SRS0=cOuX=EE=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6660CC5517A
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Oct 2020 02:05:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 15AA020878
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Oct 2020 02:05:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="RZjGUbIp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726875AbgJ2CFN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 28 Oct 2020 22:05:13 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:35110 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727104AbgJ1Vik (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 28 Oct 2020 17:38:40 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09SGwbte122155;
        Wed, 28 Oct 2020 17:00:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=/4YJNh38xmau0yMblFKeliWyF6Lq47JEshrOtDZUbMc=;
 b=RZjGUbIplMnN/yTh4D6ycuI/lo39CVn1uao67rWqtKFvZvtMOa6PP+207ooLP4ykTT23
 kqFMLP0Sx08SlBZc6oe3LNvu0OJQLHIXblK4/UkDQ2StJ6iOZ8OpYC7vmDXndKN7FXKf
 FpOK317EbNWrDKKO0MAxqQW/Nv6vnaJP4uqJJkIA9j5FifohW7qaxEKZ+eZPWfbB7xnq
 xxoguq5R1qh8h/7oqDBB8G1L9DvqMyons2AMZEVY5CpyRlRxlflPqgNcSd3mSY3IGnic
 tK237mIHQXyC3iyP0KffEGc9ycKJbGLHLYAYUW8wx6q8Pwa/RfackQFXio2UCQwyz/jp 4g== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 34dgm468j0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 28 Oct 2020 17:00:28 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09SGoVxb167634;
        Wed, 28 Oct 2020 16:58:27 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 34cwuntc78-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 28 Oct 2020 16:58:27 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 09SGwQWu006903;
        Wed, 28 Oct 2020 16:58:26 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 28 Oct 2020 09:58:26 -0700
Date:   Wed, 28 Oct 2020 09:58:25 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     guaneryu@gmail.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org
Subject: Re: [PATCH 8/9] check: run tests in a systemd scope for mandatory
 test cleanup
Message-ID: <20201028165825.GD1061252@magnolia>
References: <160382528936.1202316.2338876126552815991.stgit@magnolia>
 <160382534122.1202316.7161591166906029132.stgit@magnolia>
 <20201028074407.GH2750@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201028074407.GH2750@infradead.org>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9788 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 bulkscore=0
 spamscore=0 adultscore=0 malwarescore=0 mlxlogscore=999 suspectscore=1
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010280113
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9788 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 impostorscore=0
 adultscore=0 bulkscore=0 spamscore=0 phishscore=0 mlxlogscore=999
 suspectscore=1 clxscore=1015 mlxscore=0 malwarescore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010280114
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Oct 28, 2020 at 07:44:07AM +0000, Christoph Hellwig wrote:
> On Tue, Oct 27, 2020 at 12:02:21PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > If systemd is available, run each test in its own temporary systemd
> > scope.  This enables the test harness to forcibly clean up all of the
> > test's child processes (if it does not do so itself) so that we can move
> > into the post-test unmount and check cleanly.
> 
> Can you explain what this mean in more detail?  Most importantly what
> problems it fixes.

I'll answer these in reverse order. :)

I frequently run fstests in "low" memory situations (2GB!) to force the
kernel to do interesting things.  There are a few tests like generic/224
and generic/561 that put processes in the background and occasionally
trigger the OOM killer.  Most of the time the OOM killer correctly
shoots down fsstress or duperemove, but once in a while it's stupid
enough to shoot down the test control process (i.e. tests/generic/224)
instead.  fsstress is still running in the background, and the one
process that knew about that is dead.

When the control process dies, ./check moves on to the post-test fsck,
which fails because fsstress is still running and we can't unmount.
After fsck fails, ./check moves on to the next test, which fails because
fsstress is /still/ writing to the filesystem and we can't unmount or
format.

The end result is that that one OOM kill causes cascading test failures,
and I have to re-start fstests to see if I get a clean(er) run.  This is
frustrating in the -rc1 days, where I more frequently observe problems
with memory reclaim and OOM kills.  (Note: those problems are usually
gone by -rc3.)

So, the solution I present in this patch is to teach ./check to try to
run the test script in a systemd scope.  If that succeeds, ./check will
tell systemd to kill the scope when the test script exits and returns
control to ./check.  Concretely, this means that systemd creates a new
cgroup, stuffs the processes in that cgroup, and when we kill the scope,
systemd kills all the processes in that cgroup and deletes the cgroup.

The end result is that fstests now has an easy way to ensure that /all/
child processes of a test are dead before we try to unmount the test and
scratch devices.  I've designed this to be optional, because not
everyone does or wants or likes to run systemd, but it makes QA easier.

Hmm, this might make a better commit log.  I'll excerpt this into the
patch message.

--D
