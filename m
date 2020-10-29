Return-Path: <SRS0=cOuX=EE=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21181C4363A
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Oct 2020 01:04:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BCC99207E8
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Oct 2020 01:04:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="d2Z7UnsG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730882AbgJ2BEQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 28 Oct 2020 21:04:16 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:55474 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730416AbgJ2BEP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 28 Oct 2020 21:04:15 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09T0l3m1022758;
        Thu, 29 Oct 2020 01:04:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=c3LNCcBqqLUo+k2y04dTOEa7tP0v+qRJt/Vn4t88m1I=;
 b=d2Z7UnsGjA3ShP3DOv6v+t4YYvRgNtR2OadX9+ubUr+0Ru681Bsp1yo5jSNbZpqKRs/T
 NOv0VXYpKTqPBdsCnIUCBUjW9olXyJ32yifD9HVnwR53jSqan7B0SvmoZcoEBEP3FbM/
 +VAXw0to9Nw9r07t6gofnOYp/979kgJTcWy/Owp4Ajcs/2o3QDG5PNrX6a7gWNiqzWoK
 LeTQ/PsphtiEHxI3TpYg7BCbhdmNey4YaWw3Mb07/072aUMgpBMJ42zTo6rNbxpfhWdB
 WaqXGjm/UVoDESfBslh5TxvzW5ftFrb0dt5JkPfyeJKYHDGfbWhJn0B6J5/OI4oMfh01 jA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 34dgm47y56-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 29 Oct 2020 01:04:06 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09T0jO0n028731;
        Thu, 29 Oct 2020 01:04:06 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 34cx6xvys4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Oct 2020 01:04:06 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 09T145ai022014;
        Thu, 29 Oct 2020 01:04:05 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 28 Oct 2020 18:04:05 -0700
Date:   Wed, 28 Oct 2020 18:04:04 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     guaneryu@gmail.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org
Subject: Re: [PATCH 8/9] check: run tests in a systemd scope for mandatory
 test cleanup
Message-ID: <20201029010404.GJ1061252@magnolia>
References: <160382528936.1202316.2338876126552815991.stgit@magnolia>
 <160382534122.1202316.7161591166906029132.stgit@magnolia>
 <20201028074407.GH2750@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201028074407.GH2750@infradead.org>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9788 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 spamscore=0
 bulkscore=0 malwarescore=0 mlxlogscore=999 mlxscore=0 suspectscore=1
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010290001
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9788 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 impostorscore=0
 adultscore=0 bulkscore=0 spamscore=0 phishscore=0 mlxlogscore=999
 suspectscore=1 clxscore=1015 mlxscore=0 malwarescore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010290001
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

[resend; I can't keep track of which messages actually got NOSEND
warnings and which ones just dropped off...]

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
