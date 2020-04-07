Return-Path: <SRS0=E2x8=5X=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC54DC2BABC
	for <linux-xfs@archiver.kernel.org>; Tue,  7 Apr 2020 05:52:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A2E6420753
	for <linux-xfs@archiver.kernel.org>; Tue,  7 Apr 2020 05:52:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="apWdtfpf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726448AbgDGFwr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 7 Apr 2020 01:52:47 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:53492 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726030AbgDGFwr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 7 Apr 2020 01:52:47 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0375m73F193235;
        Tue, 7 Apr 2020 05:50:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=T0Cu/TGDBoWX5XxzBmQWpYEbelp7BnfRS2XGBSPj8k8=;
 b=apWdtfpfbQzNsTEMda1Jnw0MmcVMlDLAiXIKrXnGtmvrJMS6dm1AUgbjiomFJi5An9EY
 dBSNn3W4fNl/y7jYk1nKP4dr1Uio3+y42iqSSm0MJi7j+flgvquFS9Ol0GkAXRknAydf
 iDbjnGPUfugI4+XyGXKJrwUZp0TCEvxjpuJ70VhQy7w7w4xdhmgXsN+d5MQgkhKmQm11
 6nVAG5GO57KQ/gF1YWXFgNrImOOupX3rSiKRv5O08mtj1Xf/iWucuDVo060FKka8bCb/
 Hlj0XwKqxpIwydcx/1v2KFf3VBoivcSHd1ZwfvZWJsk74TN838haiOitveKJDaB0NUio JA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 308ffd8pcb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 07 Apr 2020 05:50:33 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0375kd3J096753;
        Tue, 7 Apr 2020 05:48:32 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 3073src0ac-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 07 Apr 2020 05:48:32 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0375mN48010943;
        Tue, 7 Apr 2020 05:48:23 GMT
Received: from localhost (/10.159.247.61)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 06 Apr 2020 22:48:23 -0700
Date:   Mon, 6 Apr 2020 22:48:22 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Eryu Guan <guaneryu@gmail.com>
Cc:     Chandan Rajendra <chandanrlinux@gmail.com>,
        fstests@vger.kernel.org, chandan@linux.ibm.com, hch@infradead.org,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH] common/xfs: Execute _xfs_check only when explicitly asked
Message-ID: <20200407054822.GA6740@magnolia>
References: <20200330101203.12049-1-chandanrlinux@gmail.com>
 <20200406123030.GG3128153@desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200406123030.GG3128153@desktop>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9583 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 spamscore=0
 malwarescore=0 suspectscore=0 adultscore=0 bulkscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004070048
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9583 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 priorityscore=1501
 impostorscore=0 malwarescore=0 mlxlogscore=999 lowpriorityscore=0
 clxscore=1015 phishscore=0 mlxscore=0 bulkscore=0 adultscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004070048
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Apr 06, 2020 at 08:31:07PM +0800, Eryu Guan wrote:
> On Mon, Mar 30, 2020 at 03:42:03PM +0530, Chandan Rajendra wrote:
> > fsstress when executed as part of some of the tests (e.g. generic/270)
> > invokes chown() syscall many times by passing random integers as value
> > for the uid argument. For each such syscall invocation for which there
> > is no on-disk quota block, xfs invokes xfs_dquot_disk_alloc() which
> > allocates a new block and instantiates all the quota structures mapped
> > by the newly allocated block. For filesystems with 64k block size, the
> > number of on-disk quota structures created will be 16 times more than
> > that for a filesystem with 4k block size.
> > 
> > xfs_db's check command (executed after test script finishes execution)
> > will try to read in all of the on-disk quota structures into
> > memory. This causes the OOM event to be triggered when reading from
> > filesystems with 64k block size. For filesystems with sufficiently large
> > amount of system memory, this causes the test to execute for a very long
> > time.
> > 
> > Due to the above stated reasons, this commit disables execution of
> > xfs_db's check command unless explictly asked by the user by setting
> > $EXECUTE_XFS_DB_CHECK variable.
> > 
> > Signed-off-by: Chandan Rajendra <chandanrlinux@gmail.com>
> > ---
> >  README     |  2 ++
> >  common/xfs | 17 +++++++++++++----
> >  2 files changed, 15 insertions(+), 4 deletions(-)
> > 
> > diff --git a/README b/README
> > index 094a7742..c47569cd 100644
> > --- a/README
> > +++ b/README
> > @@ -88,6 +88,8 @@ Preparing system for tests:
> >                 run xfs_repair -n to check the filesystem; xfs_repair to rebuild
> >                 metadata indexes; and xfs_repair -n (a third time) to check the
> >                 results of the rebuilding.
> > +	     - set EXECUTE_XFS_DB_CHECK=1 to have _check_xfs_filesystem
> > +               run xfs_db's check command on the filesystem.
> 
> It seems spaces are used for indention instead of tab in README.
> 
> >               - xfs_scrub, if present, will always check the test and scratch
> >                 filesystems if they are still online at the end of the test.
> >                 It is no longer necessary to set TEST_XFS_SCRUB.
> > diff --git a/common/xfs b/common/xfs
> > index d9a9784f..93ebab75 100644
> > --- a/common/xfs
> > +++ b/common/xfs
> > @@ -455,10 +455,19 @@ _check_xfs_filesystem()
> >  		ok=0
> >  	fi
> >  
> > -	# xfs_check runs out of memory on large files, so even providing the test
> > -	# option (-t) to avoid indexing the free space trees doesn't make it pass on
> > -	# large filesystems. Avoid it.
> > -	if [ "$LARGE_SCRATCH_DEV" != yes ]; then
> > +	dbsize="$($XFS_INFO_PROG "${device}" | grep data.*bsize | sed -e 's/^.*bsize=//g' -e 's/\([0-9]*\).*$/\1/g')"
> 
> This is probably a left-over from v1 patch, which is not needed in v2.
> 
> > +
> > +	# xfs_check runs out of memory,
> > +	# 1. On large files. So even providing the test option (-t) to
> > +	# avoid indexing the free space trees doesn't make it pass on
> > +	# large filesystems.
> > +	# 2. When checking filesystems with large number of quota
> > +	# structures. This case happens consistently with 64k blocksize when
> > +	# creating large number of on-disk quota structures whose quota ids
> > +	# are spread across a large integer range.
> > +	#
> > +	# Hence avoid executing it unless explicitly asked by user.
> > +	if [ -n "$EXECUTE_XFS_DB_CHECK" -a "$LARGE_SCRATCH_DEV" != yes ]; then
> >  		_xfs_check $extra_log_options $device 2>&1 > $tmp.fs_check
> 
> Looks fine to me, I'd like to see xfs_check being disabled. But it'd be
> great if xfs folks could ack it as well.

I think I'd rather we just do the testing to see what things xfs_check
catches that xfs_repair doesn't, and then we can deprecate running
xfs_check in fstests (by default) entirely.  In the long run it doesn't
make sense to maintain /three/ separate metadata verification utilities.

--D

> Thanks,
> Eryu
> 
> >  	fi
> >  	if [ -s $tmp.fs_check ]; then
> > -- 
> > 2.19.1
> > 
