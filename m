Return-Path: <SRS0=lRpT=32=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5DA6FC35247
	for <linux-xfs@archiver.kernel.org>; Thu,  6 Feb 2020 17:53:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3A634222C2
	for <linux-xfs@archiver.kernel.org>; Thu,  6 Feb 2020 17:53:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="mujHN48/";
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="qbw5dV9L"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727778AbgBFRxr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 6 Feb 2020 12:53:47 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:55860 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727607AbgBFRxr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 6 Feb 2020 12:53:47 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 016HmDk6092978;
        Thu, 6 Feb 2020 17:53:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=RcX2uCtVO6aBFoDsNCPIti1l422O9F51ezxnnoTBMoc=;
 b=mujHN48/lL76l5BeMpJS/cLF/SRqeestFmtWJG8yO3cL13VtCwDF3Jo2r++kkl/3+Wjs
 ORVDLNAzBtQAb5YRjMPHeH5vF9tv2Dm2LLQToKsNJGq+OKg0PscRiWqqUsJm2qZDlvDq
 VweE1Fx3mE421L4UFYppouRFcYJ/Yu4WZEmcrw4yRuANA5rTwM20K5MRsCFshOLcCJiC
 SyK8WIUY/pdXAgkxSsy3oEA3R2O/GJBx6o1qrDiOkTe7BKJroAXoUkN4FD+oSnLNwHlW
 oV5ggbP7xdl3qDt1fffEWoWtSioRYql7ZlD67XAma7hUv+Ge5tMleJw4sAhaX7JMDJnl ag== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=RcX2uCtVO6aBFoDsNCPIti1l422O9F51ezxnnoTBMoc=;
 b=qbw5dV9Lnnp5AOEZ2OdHD2dDZRZIxODl31mlVo/LI6UUDBk7heceZinacZFCm3922ZxJ
 g8fgDB80wyS5FtfRx0KXOkIk2K4rfLkN9M33ljvz4Q0KyswrFBSMoSYgRvuj5CKw+KMP
 pSZ8ib8wc9sIppDkRIzdosGtYIszAbxCmwY/O7whqJSEoir2JzuJNC1w8bNuLX/a+NWk
 PjQnVumYUltiHaFt5RXekawwuMjX7k+aMubgnQ/foCIhezbY+JuAXiU+hpnUQn3IxJJv
 OPikBCa1qjDP3J+z02CZOf8dzlllgDMZuHNjiH9yTRKzFlfjhOFLXigfjflCBOgSN3M6 aQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 2xykbpbbkj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 06 Feb 2020 17:53:45 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 016Hn6bx140992;
        Thu, 6 Feb 2020 17:53:45 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 2y080dq50x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 06 Feb 2020 17:53:44 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 016HriYu006379;
        Thu, 6 Feb 2020 17:53:44 GMT
Received: from localhost (/10.145.179.117)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 06 Feb 2020 09:53:44 -0800
Date:   Thu, 6 Feb 2020 09:53:42 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Eryu Guan <guaneryu@gmail.com>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        fstests <fstests@vger.kernel.org>
Subject: Re: [PATCH 2/2] xfs: test setting labels with xfs_admin
Message-ID: <20200206175342.GF6869@magnolia>
References: <158086094707.1990521.17646841467136148296.stgit@magnolia>
 <158086095935.1990521.3334372807118647101.stgit@magnolia>
 <CAOQ4uxi5i-iTZG7+BgybvS7SQqat94k5jQXUK2LW-9iDf2NgnQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxi5i-iTZG7+BgybvS7SQqat94k5jQXUK2LW-9iDf2NgnQ@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9523 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2002060133
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9523 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2002060133
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Feb 05, 2020 at 08:40:35AM +0200, Amir Goldstein wrote:
> On Wed, Feb 5, 2020 at 2:02 AM Darrick J. Wong <darrick.wong@oracle.com> wrote:
> >
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> >
> > Test setting filesystem labels with xfs_admin.
> >
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  tests/xfs/912     |  103 +++++++++++++++++++++++++++++++++++++++++++++++++++++
> >  tests/xfs/912.out |   43 ++++++++++++++++++++++
> >  tests/xfs/group   |    1 +
> >  3 files changed, 147 insertions(+)
> >  create mode 100755 tests/xfs/912
> >  create mode 100644 tests/xfs/912.out
> >
> >
> > diff --git a/tests/xfs/912 b/tests/xfs/912
> > new file mode 100755
> > index 00000000..1eef36cd
> > --- /dev/null
> > +++ b/tests/xfs/912
> > @@ -0,0 +1,103 @@
> > +#! /bin/bash
> > +# SPDX-License-Identifier: GPL-2.0-or-later
> > +# Copyright (c) 2020, Oracle and/or its affiliates.  All Rights Reserved.
> > +#
> > +# FS QA Test No. 912
> > +#
> > +# Check that xfs_admin can set and clear filesystem labels offline and online.
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
> > +       cd /
> 
> odd cleanup.
> I think the standard rm tmp files is needed for in-case common
> helpers generate tmp files.

Heh, ok, will add that.

> > +}
> > +
> > +# get standard environment, filters and checks
> > +. ./common/rc
> > +
> > +# real QA test starts here
> > +_supported_fs xfs
> > +_supported_os Linux
> > +_require_scratch
> > +_require_xfs_db_command label
> > +_require_xfs_io_command label
> > +grep -q "xfs_io" "$(which xfs_admin)" || \
> > +       _notrun "xfs_admin does not support online label setting of any kind"
> 
> odd test. If it cannot be prettier than than perhaps hide this inside
> a _require helper?

There's only one user of it so far, though I guess if I'm going to add
get/set fs uuid ioctls then maybe this should get refactored...

...assuming Eric doesn't just nuke xfs_admin online updates out of
existence entirely. :)

--D

> > +
> > +rm -f $seqres.full
> > +
> > +echo
> > +echo "Format with label"
> > +_scratch_mkfs -L "label0" > $seqres.full
> > +
> > +echo "Read label offline"
> > +_scratch_xfs_admin -l
> > +
> > +echo "Read label online"
> > +_scratch_mount
> > +_scratch_xfs_admin -l
> > +
> > +echo
> > +echo "Set label offline"
> > +_scratch_unmount
> > +_scratch_xfs_admin -L "label1"
> > +
> > +echo "Read label offline"
> > +_scratch_xfs_admin -l
> > +
> > +echo "Read label online"
> > +_scratch_mount
> > +_scratch_xfs_admin -l
> > +
> > +echo
> > +echo "Set label online"
> > +_scratch_xfs_admin -L "label2"
> > +
> > +echo "Read label online"
> > +_scratch_xfs_admin -l
> > +
> > +echo "Read label offline"
> > +_scratch_unmount
> > +_scratch_xfs_admin -l
> > +
> > +echo
> > +echo "Clear label online"
> > +_scratch_mount
> > +_scratch_xfs_admin -L "--"
> > +
> > +echo "Read label online"
> > +_scratch_xfs_admin -l
> > +
> > +echo "Read label offline"
> > +_scratch_unmount
> > +_scratch_xfs_admin -l
> > +
> > +echo
> > +echo "Set label offline"
> > +_scratch_xfs_admin -L "label3"
> > +
> > +echo "Read label offline"
> > +_scratch_xfs_admin -l
> > +
> > +echo
> > +echo "Clear label offline"
> > +_scratch_xfs_admin -L "--"
> > +
> > +echo "Read label offline"
> > +_scratch_xfs_admin -l
> > +
> > +echo "Read label online"
> > +_scratch_mount
> > +_scratch_xfs_admin -l
> > +
> > +# success, all done
> > +status=0
> > +exit
> > diff --git a/tests/xfs/912.out b/tests/xfs/912.out
> > new file mode 100644
> > index 00000000..186d827f
> > --- /dev/null
> > +++ b/tests/xfs/912.out
> > @@ -0,0 +1,43 @@
> > +QA output created by 912
> > +
> > +Format with label
> > +Read label offline
> > +label = "label0"
> > +Read label online
> > +label = "label0"
> > +
> > +Set label offline
> > +writing all SBs
> > +new label = "label1"
> > +Read label offline
> > +label = "label1"
> > +Read label online
> > +label = "label1"
> > +
> > +Set label online
> > +label = "label2"
> > +Read label online
> > +label = "label2"
> > +Read label offline
> > +label = "label2"
> > +
> > +Clear label online
> > +label = ""
> > +Read label online
> > +label = ""
> > +Read label offline
> > +label = ""
> > +
> > +Set label offline
> > +writing all SBs
> > +new label = "label3"
> > +Read label offline
> > +label = "label3"
> > +
> > +Clear label offline
> > +writing all SBs
> > +new label = ""
> > +Read label offline
> > +label = ""
> > +Read label online
> > +label = ""
> > diff --git a/tests/xfs/group b/tests/xfs/group
> > index edffef9a..898bd9e4 100644
> > --- a/tests/xfs/group
> > +++ b/tests/xfs/group
> > @@ -512,3 +512,4 @@
> >  512 auto quick acl attr
> >  747 auto quick scrub
> >  748 auto quick scrub
> > +912 auto quick label
> >
