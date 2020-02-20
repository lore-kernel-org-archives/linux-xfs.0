Return-Path: <SRS0=u4TP=4I=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3BD8AC34031
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Feb 2020 04:29:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0FB8D2465D
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Feb 2020 04:29:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="os+rHtYQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727370AbgBTE3Z (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 19 Feb 2020 23:29:25 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:45230 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727922AbgBTE3Z (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 Feb 2020 23:29:25 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01K4JJdg039030;
        Thu, 20 Feb 2020 04:29:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=uaS2IxoL2+c+JzxZeaYDE/03J/1mt/NOZVv/zP17ww0=;
 b=os+rHtYQsMwifh8BAPEwRlkkr6Ww/yQ94NmA6p4/uaIgYxJGd1TW4ExFY31uCUnjWgY7
 tDzzB0VL1/+BolosOgM93Zsag3GhvPnrIfODPWjsLWG3hLb9EWPYNkw9m9dnHH9Iko/x
 ucIV1GF0Bz+PQGEwAbK8ywokJ/jOg9hkBMVZJiVQq2D/ccJphetLOyxUqTHGzB+XHhCI
 sJqdMkWKIrOIxrvrKyqlfzp+oWOQuS0VKFOWErUFjkDPcGGKAp91XghWAlaUQFLB7FIj
 D5CX8cn50t3nvl0GG5MxdhRfz0owPxZQKg3XXchmp2pO/a9s9mgKdRy+lGiiOWzcjdvq 4A== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2y8udkf7sv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 Feb 2020 04:29:23 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01K4RxtK137966;
        Thu, 20 Feb 2020 04:29:23 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 2y8uda28vs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 Feb 2020 04:29:23 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 01K4TMNG030082;
        Thu, 20 Feb 2020 04:29:22 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 19 Feb 2020 20:29:22 -0800
Date:   Wed, 19 Feb 2020 20:29:21 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     xfs <linux-xfs@vger.kernel.org>, fstests <fstests@vger.kernel.org>
Subject: Re: [RFC PATCH] xfs: make sure our default quota warning limits and
 grace periods survive quotacheck
Message-ID: <20200220042921.GG9504@magnolia>
References: <20200219003423.GB9511@magnolia>
 <20200220043144.GE14282@dhcp-12-102.nay.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200220043144.GE14282@dhcp-12-102.nay.redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9536 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 phishscore=0 suspectscore=0 mlxscore=0 malwarescore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002200029
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9536 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 suspectscore=0
 spamscore=0 priorityscore=1501 adultscore=0 mlxscore=0 clxscore=1015
 malwarescore=0 mlxlogscore=999 phishscore=0 impostorscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002200029
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Feb 20, 2020 at 12:31:44PM +0800, Zorro Lang wrote:
> On Tue, Feb 18, 2020 at 04:34:23PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Make sure that the default quota grace period and maximum warning limits
> > set by the administrator survive quotacheck.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> > This is the testcase to go with 'xfs: preserve default grace interval
> > during quotacheck', though Eric and I haven't figured out how we're
> > going to land that one...
> > ---
> >  tests/xfs/913     |   69 +++++++++++++++++++++++++++++++++++++++++++++++++++++
> >  tests/xfs/913.out |   13 ++++++++++
> >  tests/xfs/group   |    1 +
> >  3 files changed, 83 insertions(+)
> >  create mode 100755 tests/xfs/913
> >  create mode 100644 tests/xfs/913.out
> > 
> > diff --git a/tests/xfs/913 b/tests/xfs/913
> 
> Hi,
> 
> Can "_require_xfs_quota_foreign" help this case to be a generic case?
> 
> > new file mode 100755
> > index 00000000..94681b02
> > --- /dev/null
> > +++ b/tests/xfs/913
> > @@ -0,0 +1,69 @@
> > +#! /bin/bash
> > +# SPDX-License-Identifier: GPL-2.0-or-later
> > +# Copyright (c) 2020, Oracle and/or its affiliates.  All Rights Reserved.
> > +#
> > +# FS QA Test No. 913
> > +#
> > +# Make sure that the quota default grace period and maximum warning limits
> > +# survive quotacheck.
> > +
> > +seq=`basename $0`
> > +seqres=$RESULT_DIR/$seq
> > +echo "QA output created by $seq"
> > +
> > +here=`pwd`
> > +tmp=/tmp/$$
> > +status=1    # failure is the default!
> > +trap "_cleanup; exit \$status" 0 1 2 3 15
> > +
> > +_cleanup()
> > +{
> > +	cd /
> > +	rm -f $tmp.*
> > +}
> > +
> > +# get standard environment, filters and checks
> > +. ./common/rc
> > +. ./common/filter
> > +. ./common/quota
> > +
> > +# real QA test starts here
> > +_supported_fs xfs
> > +_supported_os Linux
> > +_require_quota
> > +
> > +rm -f $seqres.full
> > +
> > +# Format filesystem and set up quota limits
> > +_scratch_mkfs > $seqres.full
> > +_qmount_option "usrquota"
> > +_scratch_mount >> $seqres.full
> > +
> > +$XFS_QUOTA_PROG -x -c 'timer -u 300m' $SCRATCH_MNT
> > +$XFS_QUOTA_PROG -x -c 'state' $SCRATCH_MNT | grep 'grace time'
> > +_scratch_unmount
> > +
> > +# Remount and check the limits
> > +_scratch_mount >> $seqres.full
> > +$XFS_QUOTA_PROG -x -c 'state' $SCRATCH_MNT | grep 'grace time'
> > +_scratch_unmount
> > +
> > +# Run repair to force quota check
> > +_scratch_xfs_repair >> $seqres.full 2>&1
> 
> I've sent a case looks like do similar test as this:
>   [PATCH 1/2] generic: per-type quota timers set/get test
> 
> But it doesn't do fsck before cycle-mount. And ...[below]
> 
> > +
> > +# Remount (this time to run quotacheck) and check the limits.  There's a bug
> > +# in quotacheck where we would reset the ondisk default grace period to zero
> > +# while the incore copy stays at whatever was read in prior to quotacheck.
> > +# This will show up after the /next/ remount.
> > +_scratch_mount >> $seqres.full
> > +$XFS_QUOTA_PROG -x -c 'state' $SCRATCH_MNT | grep 'grace time'
> > +_scratch_unmount
> > +
> > +# Remount and check the limits
> > +_scratch_mount >> $seqres.full
> > +$XFS_QUOTA_PROG -x -c 'state' $SCRATCH_MNT | grep 'grace time'
> > +_scratch_unmount
> 
> It doesn't do twice cycle mount either. Do you think the fsck is necessary?

This test is looking for a bug in quotacheck, so I use xfs_repair to
force a quotacheck.

> And do you think these two cases can be merged into one case?

<shrug> Probably.  I don't see a problem in having one testcase poke
related problems, and it can always come after the bits that are already
in the growing pile of quota tests (see the one that Eric sent...)

--D

> Thanks,
> Zorro
> 
> > +
> > +# success, all done
> > +status=0
> > +exit
> > diff --git a/tests/xfs/913.out b/tests/xfs/913.out
> > new file mode 100644
> > index 00000000..ee989388
> > --- /dev/null
> > +++ b/tests/xfs/913.out
> > @@ -0,0 +1,13 @@
> > +QA output created by 913
> > +Blocks grace time: [0 days 05:00:00]
> > +Inodes grace time: [0 days 05:00:00]
> > +Realtime Blocks grace time: [0 days 05:00:00]
> > +Blocks grace time: [0 days 05:00:00]
> > +Inodes grace time: [0 days 05:00:00]
> > +Realtime Blocks grace time: [0 days 05:00:00]
> > +Blocks grace time: [0 days 05:00:00]
> > +Inodes grace time: [0 days 05:00:00]
> > +Realtime Blocks grace time: [0 days 05:00:00]
> > +Blocks grace time: [0 days 05:00:00]
> > +Inodes grace time: [0 days 05:00:00]
> > +Realtime Blocks grace time: [0 days 05:00:00]
> > diff --git a/tests/xfs/group b/tests/xfs/group
> > index 056072fb..87b3c75d 100644
> > --- a/tests/xfs/group
> > +++ b/tests/xfs/group
> > @@ -539,4 +539,5 @@
> >  910 auto quick inobtcount
> >  911 auto quick bigtime
> >  912 auto quick label
> > +913 auto quick quota
> >  997 auto quick mount
> > 
> 
