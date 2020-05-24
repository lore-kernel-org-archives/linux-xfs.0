Return-Path: <SRS0=zOU/=7G=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CEA96C433E1
	for <linux-xfs@archiver.kernel.org>; Sun, 24 May 2020 17:20:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ADECD206C3
	for <linux-xfs@archiver.kernel.org>; Sun, 24 May 2020 17:20:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="r8OrbeYm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387726AbgEXRUU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 24 May 2020 13:20:20 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:44720 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387707AbgEXRUU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 24 May 2020 13:20:20 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04OHHbv1055836;
        Sun, 24 May 2020 17:20:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=jmEIjMmvJVIF9L5jVo6wkn6qlPJp23/w8YSV1is0J9g=;
 b=r8OrbeYmjWL8xgWidLYsg+fwJgOlqjO9IzNr/3udTDowQhXOEwCzBmFoJSdW9z4pTWRy
 Jo78ujWp7vnlNzlDpLISh6dy+KNzj0lSmxwhWS468rA+oQdPZWL21TsDhC6jAKwevGD2
 ybvyj7TGSxDhfEJHHqFzQMOq7xXNnWs++PdBjqtFVeETUIOSXe8+Xgtdi+aFH6KZ6CUG
 Qpg+NtApP2oZuyjn7gkH6KFRxA+Sg5jxzz44lSOeCytDuC0AKrsSvJFx/fchwUIqP+I0
 tTctsgdjbShIIuX6BNUkx9eCmw1BK3QWFBsd9eYW05J6r7W7Xn7iFP4Tv7pDsMy2Ry5d vA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 316vfn3399-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sun, 24 May 2020 17:20:13 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04OHCedK055366;
        Sun, 24 May 2020 17:18:13 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 317dru62qx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 24 May 2020 17:18:12 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 04OHIBAA019664;
        Sun, 24 May 2020 17:18:12 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 24 May 2020 10:18:11 -0700
Date:   Sun, 24 May 2020 10:18:10 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Eryu Guan <guan@eryu.me>
Cc:     Donald Douwsma <ddouwsma@redhat.com>, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org
Subject: Re: [PATCH v2] xfstests: add test for xfs_repair progress reporting
Message-ID: <20200524171810.GB252930@magnolia>
References: <20200519160125.GB17621@magnolia>
 <20200520035258.298516-1-ddouwsma@redhat.com>
 <20200524164648.GB3363@desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200524164648.GB3363@desktop>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9631 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 malwarescore=0
 mlxlogscore=999 adultscore=0 suspectscore=2 bulkscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005240143
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9631 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 clxscore=1011
 priorityscore=1501 mlxscore=0 malwarescore=0 spamscore=0 impostorscore=0
 mlxlogscore=999 lowpriorityscore=0 bulkscore=0 adultscore=0 suspectscore=2
 cotscore=-2147483648 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2005240144
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, May 25, 2020 at 12:46:48AM +0800, Eryu Guan wrote:
> On Wed, May 20, 2020 at 01:52:58PM +1000, Donald Douwsma wrote:
> > xfs_repair's interval based progress has been broken for
> > some time, create a test based on dmdelay to stretch out
> > the time and use ag_stride to force parallelism.
> > 
> > Signed-off-by: Donald Douwsma <ddouwsma@redhat.com>
> > ---
> > Changes since v1:
> > - Use _scratch_xfs_repair
> > - Filter only repair output
> > - Make the filter more tolerant of whitespace and plurals
> > - Take golden output from 'xfs_repair: fix progress reporting'
> 
> I saw failures like below, and I'm using v5.7-rc4 kernel and v5.4.0
> xfsprogs, is this expected failure?
> 
> @@ -2,8 +2,6 @@
>  Format and populate
>  Introduce a dmdelay
>  Run repair
> - - #:#:#: Phase #: #% done - estimated remaining time # minute, # second
> - - #:#:#: Phase #: elapsed time # second - processed # inodes per minute
>   - #:#:#: check for inodes claiming duplicate blocks - # of # inodes done
>   - #:#:#: process known inodes and inode discovery - # of # inodes done
>   - #:#:#: process newly discovered inodes - # of # allocation groups done
> @@ -12,4 +10,3 @@
>   - #:#:#: scanning filesystem freespace - # of # allocation groups done
>   - #:#:#: setting up duplicate extent list - # of # allocation groups done
>   - #:#:#: verify and correct link counts - # of # allocation groups done
> - - #:#:#: zeroing log - # of # blocks done

Yeah, there's an xfsprogs patch pending, IIRC.

--D

> 
> > 
> >  tests/xfs/516     | 76 +++++++++++++++++++++++++++++++++++++++++++++++
> >  tests/xfs/516.out | 15 ++++++++++
> >  tests/xfs/group   |  1 +
> >  3 files changed, 92 insertions(+)
> >  create mode 100755 tests/xfs/516
> >  create mode 100644 tests/xfs/516.out
> > 
> > diff --git a/tests/xfs/516 b/tests/xfs/516
> > new file mode 100755
> > index 00000000..1c0508ef
> > --- /dev/null
> > +++ b/tests/xfs/516
> > @@ -0,0 +1,76 @@
> > +#! /bin/bash
> > +# SPDX-License-Identifier: GPL-2.0
> > +# Copyright (c) 2020 Red Hat, Inc.  All Rights Reserved.
> > +#
> > +# FS QA Test 516
> > +#
> > +# Test xfs_repair's progress reporting
> > +#
> > +seq=`basename $0`
> > +seqres=$RESULT_DIR/$seq
> > +echo "QA output created by $seq"
> > +
> > +here=`pwd`
> > +tmp=/tmp/$$
> > +status=1	# failure is the default!
> > +trap "_cleanup; exit \$status" 0 1 2 3 15
> > +
> > +_cleanup()
> > +{
> 
> 	rm -f $tmp.*
> 
> As some common helpers would use $tmp. files as well.
> 
> > +	cd /
> > +	_dmsetup_remove delay-test > /dev/null 2>&1
> 
> I think we could do _cleanup_delay here and discard the outputs.
> 
> > +}
> > +
> > +# get standard environment, filters and checks
> > +. ./common/rc
> > +. ./common/filter
> > +. ./common/dmdelay
> > +. ./common/populate
> > +
> > +# remove previous $seqres.full before test
> > +rm -f $seqres.full
> > +
> > +# real QA test starts here
> > +
> > +# Modify as appropriate.
> > +_supported_fs xfs
> > +_supported_os Linux
> > +_require_scratch
> > +_require_dm_target delay
> > +
> > +# Filter output specific to the formatters in xfs_repair/progress.c
> > +# Ideally we'd like to see hits on anything that matches
> > +# awk '/{FMT/' repair/progress.c
> > +_filter_repair()
> 
> Function names with the leading underscore are reserved for common
> helpers, filter_repair would be fine.
> 
> > +{
> > +	sed -ne '
> > +	s/[0-9]\+/#/g;
> > +	s/^\s\+/ /g;
> > +	s/\(second\|minute\)s/\1/g
> > +	/#:#:#:/p
> > +	'
> > +}
> > +
> > +echo "Format and populate"
> > +_scratch_populate_cached nofill > $seqres.full 2>&1
> > +
> > +echo "Introduce a dmdelay"
> > +_init_delay
> > +
> > +# Introduce a read I/O delay
> > +# The default in common/dmdelay is a bit too agressive
> > +BLK_DEV_SIZE=`blockdev --getsz $SCRATCH_DEV`
> > +DELAY_TABLE_RDELAY="0 $BLK_DEV_SIZE delay $SCRATCH_DEV 0 100 $SCRATCH_DEV 0 0"
> > +_load_delay_table $DELAY_READ
> > +
> > +echo "Run repair"
> > +SCRATCH_DEV=$DELAY_DEV _scratch_xfs_repair -o ag_stride=4 -t 1 2>&1 |
> > +        tee -a $seqres.full > $seqres.xfs_repair.out
> > +
> > +cat $seqres.xfs_repair.out | _filter_repair | sort -u
> 
> I agreed with Darrick here. redirect output to $tmp.repair is better, as
> we already cleanup $tmp.* in _cleanup, and no one is cleaning up
> $seqres.xfs_repair.out file.
> 
> > +
> > +_cleanup_delay
> 
> We could remove this one if do it in _cleanup.
> 
> > +
> > +# success, all done
> > +status=0
> > +exit
> > diff --git a/tests/xfs/516.out b/tests/xfs/516.out
> > new file mode 100644
> > index 00000000..85018b93
> > --- /dev/null
> > +++ b/tests/xfs/516.out
> > @@ -0,0 +1,15 @@
> > +QA output created by 516
> > +Format and populate
> > +Introduce a dmdelay
> > +Run repair
> > + - #:#:#: Phase #: #% done - estimated remaining time # minute, # second
> > + - #:#:#: Phase #: elapsed time # second - processed # inodes per minute
> > + - #:#:#: check for inodes claiming duplicate blocks - # of # inodes done
> > + - #:#:#: process known inodes and inode discovery - # of # inodes done
> > + - #:#:#: process newly discovered inodes - # of # allocation groups done
> > + - #:#:#: rebuild AG headers and trees - # of # allocation groups done
> > + - #:#:#: scanning agi unlinked lists - # of # allocation groups done
> > + - #:#:#: scanning filesystem freespace - # of # allocation groups done
> > + - #:#:#: setting up duplicate extent list - # of # allocation groups done
> > + - #:#:#: verify and correct link counts - # of # allocation groups done
> > + - #:#:#: zeroing log - # of # blocks done
> > diff --git a/tests/xfs/group b/tests/xfs/group
> > index 12eb55c9..aeeca23f 100644
> > --- a/tests/xfs/group
> > +++ b/tests/xfs/group
> > @@ -513,3 +513,4 @@
> >  513 auto mount
> >  514 auto quick db
> >  515 auto quick quota
> > +516 repair
> 
> Should be in auto group as well? Only tests in auto (and quick, which is
> a sub-set of auto) will be run by default.
> 
> Thanks,
> Eryu
> 
> > -- 
> > 2.18.4
