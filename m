Return-Path: <SRS0=cOuX=EE=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C485DC4741F
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Oct 2020 21:01:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5632720809
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Oct 2020 21:01:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="mL+1tHiL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726320AbgJ2VB5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 29 Oct 2020 17:01:57 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:32780 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726090AbgJ2VB5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 29 Oct 2020 17:01:57 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09TI9fbC017302;
        Thu, 29 Oct 2020 18:27:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=NoqkkWewqqp0ZUzxkPJO2OQ/wdzoBoyaXchxDsU+Ywg=;
 b=mL+1tHiLMH2/W03XvnnkPSwr3NEYEwYUI4qjk7UQ/VctR4HN+cijcsGJ9Sa5fbQ29EB7
 FGxVkJ/7MQjUsVf4HofWZ6dUBCXgLBtBGZRTBFybY6necWCNdICTPj4nq+EmGAFRm4SQ
 mj13McwOtze87dApYS9DCL5o23UsG8P86y+bBwHXkjr2eaiTjofiUIiVMHs2J2U8lkSS
 wDOcyVOrYUtqIHwxA9CufhuBVL0ug5s/fPsumLT1HCGRPXNZN0ngHV+dIROnIB0Cq8ko
 2F3eotvqGvhIR4IvrrJEojBJUB9n8pfsEhpofCCFt+w+ur+LkXLFscH8ZsV6manLh8tD 5w== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 34cc7m6cfq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 29 Oct 2020 18:27:51 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09TIADt8108644;
        Thu, 29 Oct 2020 18:27:50 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 34cx60tv62-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Oct 2020 18:27:50 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 09TIRn8o018349;
        Thu, 29 Oct 2020 18:27:49 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 29 Oct 2020 11:27:49 -0700
Date:   Thu, 29 Oct 2020 11:27:47 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Eryu Guan <guaneryu@gmail.com>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        fstests <fstests@vger.kernel.org>,
        Deepa Dinamani <deepa.kernel@gmail.com>
Subject: Re: [PATCH 3/4] xfs: detect time limits from filesystem
Message-ID: <20201029182747.GU1061252@magnolia>
References: <160382543472.1203848.8335854864075548402.stgit@magnolia>
 <160382545348.1203848.12227735405144915534.stgit@magnolia>
 <CAOQ4uxhNpej-U-7NjA1VuU3OH=ttT7npwYrzODqThdta5Qka1A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxhNpej-U-7NjA1VuU3OH=ttT7npwYrzODqThdta5Qka1A@mail.gmail.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9789 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 mlxlogscore=999
 suspectscore=1 bulkscore=0 malwarescore=0 spamscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010290127
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9789 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 adultscore=0
 malwarescore=0 spamscore=0 clxscore=1011 mlxscore=0 suspectscore=1
 priorityscore=1501 impostorscore=0 bulkscore=0 phishscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010290127
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Oct 29, 2020 at 12:47:32PM +0200, Amir Goldstein wrote:
> On Wed, Oct 28, 2020 at 10:24 PM Darrick J. Wong
> <darrick.wong@oracle.com> wrote:
> >
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> >
> > Teach fstests to extract timestamp limits of a filesystem using the new
> > xfs_db timelimit command.
> >
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  common/rc         |    2 +-
> >  common/xfs        |   14 ++++++++++++++
> >  tests/xfs/911     |   44 ++++++++++++++++++++++++++++++++++++++++++++
> >  tests/xfs/911.out |   15 +++++++++++++++
> >  tests/xfs/group   |    1 +
> >  5 files changed, 75 insertions(+), 1 deletion(-)
> >  create mode 100755 tests/xfs/911
> >  create mode 100644 tests/xfs/911.out
> >
> >
> > diff --git a/common/rc b/common/rc
> > index 41f93047..162d957a 100644
> > --- a/common/rc
> > +++ b/common/rc
> > @@ -2029,7 +2029,7 @@ _filesystem_timestamp_range()
> >                 echo "0 $u32max"
> >                 ;;
> >         xfs)
> > -               echo "$s32min $s32max"
> > +               _xfs_timestamp_range "$device"
> >                 ;;
> >         btrfs)
> >                 echo "$s64min $s64max"
> > diff --git a/common/xfs b/common/xfs
> > index e548a0a1..19ccee03 100644
> > --- a/common/xfs
> > +++ b/common/xfs
> > @@ -994,3 +994,17 @@ _require_xfs_scratch_inobtcount()
> >                 _notrun "inobtcount not supported by scratch filesystem type: $FSTYP"
> >         _scratch_unmount
> >  }
> > +
> > +_xfs_timestamp_range()
> > +{
> > +       local use_db=0
> > +       local dbprog="$XFS_DB_PROG $device"

Heh, device isn't defined, I'll fix that.

> > +       test "$device" = "$SCRATCH_DEV" && dbprog=_scratch_xfs_db
> > +
> > +       $dbprog -f -c 'help timelimit' | grep -v -q 'not found' && use_db=1
> > +       if [ $use_db -eq 0 ]; then
> > +               echo "-$((1<<31)) $(((1<<31)-1))"
> 
> This embodies an assumption that the tested filesystem does not have
> bigtime enabled if xfs_db tool is not uptodate.

If the xfs_db tool doesn't support the timelimit command then it doesn't
support formatting with bigtime.  I don't think it's reasonable to
expect to be able to run fstests on a test filesystem that xfsprogs
doesn't support.  Hence it's fine to output the old limits if the
timelimit command doesn't exist.

> Maybe it makes sense, but it may be safer to return "-1 -1" and not_run
> generic/402 if xfs_db is not uptodate, perhaps with an extra message
> hinting the user to upgrade xfs_db.

TBH it boggles my mind that there *still* is no way to ask the kernel
for the supported timestamp range of a mounted filesystem.  The
timelimit command and this mess in fstests was supposed to be a
temporary workaround that would (in my ideal world) have become
unnecessary before this landed, but ... ugh.

--D

> Thanks,
> Amir.
