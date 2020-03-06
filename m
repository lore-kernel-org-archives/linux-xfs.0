Return-Path: <SRS0=P3J0=4X=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23DC5C10F25
	for <linux-xfs@archiver.kernel.org>; Fri,  6 Mar 2020 15:41:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F0E082084E
	for <linux-xfs@archiver.kernel.org>; Fri,  6 Mar 2020 15:41:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="HMT83YCo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726859AbgCFPlk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 6 Mar 2020 10:41:40 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:35368 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726237AbgCFPlk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 6 Mar 2020 10:41:40 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 026Fcekd060882;
        Fri, 6 Mar 2020 15:41:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=Auw50HVJRWHELW6YqQftAAMiW8KTK2yjt9xrqdvtO+U=;
 b=HMT83YCopdKWf7B3CIg/+njrtbW6trYUwj2/hy6hWX4RzFQKZ+OpSncGxJDklVUeorvV
 uiMzxtTTFDANVkI9xXQvrmmbgwQc/zQUDjxn+vc/QvYP9/9KwGL4uq8ZmpxNg/0SSAMs
 Qjwd83nIDDHNXyYI/d8i+uWuFAwMnvfsuh+b8keSAhSYHwQ+BzSYSJ+6BU5SULA6Qoaw
 ywmiGlXI0JfLWgvVx/IWCqm8QphY/zra5LkYr/XTyt45bh//blXpS06Gude+Iyoozt8R
 YmoXdghGQ872HpO2rrVFR1LDRunZ76KCC4O9lpAIBmWJme/rz9fQ4Iy/JmzT6JNdIUWW fg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2yffwrbxpr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 06 Mar 2020 15:41:38 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 026FbbWd050346;
        Fri, 6 Mar 2020 15:41:37 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 2yg1pdkyag-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 06 Mar 2020 15:41:37 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 026Ffab6012318;
        Fri, 6 Mar 2020 15:41:36 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 06 Mar 2020 07:41:36 -0800
Date:   Fri, 6 Mar 2020 07:41:34 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/3] xfs: make sure xfs_db/xfs_quota commands are
 documented
Message-ID: <20200306154134.GW8045@magnolia>
References: <158328998787.2374922.4223951558305234252.stgit@magnolia>
 <158329000698.2374922.9344618703224232004.stgit@magnolia>
 <20200306100655.GZ14282@dhcp-12-102.nay.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200306100655.GZ14282@dhcp-12-102.nay.redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9552 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0
 mlxlogscore=999 mlxscore=0 spamscore=0 adultscore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2003060109
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9552 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 spamscore=0
 impostorscore=0 malwarescore=0 mlxlogscore=999 mlxscore=0 suspectscore=0
 phishscore=0 clxscore=1015 bulkscore=0 adultscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2003060109
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Mar 06, 2020 at 06:06:55PM +0800, Zorro Lang wrote:
> On Tue, Mar 03, 2020 at 06:46:47PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Make sure all the xfs_db/xfs_quota commands are documented.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> 
> The test cases make sense, and looks good to me, although it fails
> on most of xfsprogs versions currently. I think someone is fixing
> these missed docs, right :)

Yes, the missing command documentation should be in 5.5.

> One thing I noticed that:
>   $CAT "$MANPAGE" | egrep -q "^\.B.*$COMMAND"
> 
> The "^\.B.*$COMMAND" can match ".B report", but can't match something
> likes:
> "
> .B
> limit
> "
> 
> If we don't recommend this format, we'd be better to change and avoid it in
> manual pages.

I also fixed that.

> Reviewd-by: Zorro Lang <zlang@redhat.com>

        ^ need an 'e' here...

--D

> 
> Thanks,
> Zorro
> 
> >  tests/xfs/754     |   57 +++++++++++++++++++++++++++++++++++++++++++++++++++++
> >  tests/xfs/754.out |    2 ++
> >  tests/xfs/755     |   53 +++++++++++++++++++++++++++++++++++++++++++++++++
> >  tests/xfs/755.out |    2 ++
> >  tests/xfs/group   |    2 ++
> >  5 files changed, 116 insertions(+)
> >  create mode 100755 tests/xfs/754
> >  create mode 100644 tests/xfs/754.out
> >  create mode 100755 tests/xfs/755
> >  create mode 100644 tests/xfs/755.out
> > 
> > 
> > diff --git a/tests/xfs/754 b/tests/xfs/754
> > new file mode 100755
> > index 00000000..ba0885be
> > --- /dev/null
> > +++ b/tests/xfs/754
> > @@ -0,0 +1,57 @@
> > +#! /bin/bash
> > +# SPDX-License-Identifier: GPL-2.0-or-newer
> > +# Copyright (c) 2020, Oracle and/or its affiliates.  All Rights Reserved.
> > +#
> > +# FS QA Test No. 754
> > +#
> > +# Ensure all xfs_db commands are documented.
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
> > +	rm -f $tmp.* $file
> > +}
> > +
> > +# get standard environment, filters and checks
> > +. ./common/rc
> > +
> > +# real QA test starts here
> > +_supported_fs xfs
> > +_supported_os Linux
> > +_require_command "$XFS_DB_PROG" "xfs_db"
> > +_require_command "$MAN_PROG" man
> > +_require_test
> > +
> > +echo "Silence is golden"
> > +
> > +MANPAGE=$($MAN_PROG --path xfs_db)
> > +
> > +case "$MANPAGE" in
> > +*.gz|*.z\|*.Z)	CAT=zcat;;
> > +*.bz2)		CAT=bzcat;;
> > +*.xz)		CAT=xzcat;;
> > +*)		CAT=cat;;
> > +esac
> > +_require_command `which $CAT` $CAT
> > +
> > +file=$TEST_DIR/xx.$seq
> > +truncate -s 128m $file
> > +$MKFS_XFS_PROG $file >> /dev/null
> > +
> > +for COMMAND in `$XFS_DB_PROG -x -c help $file | awk '{print $1}' | grep -v "^Use"`; do
> > +  $CAT "$MANPAGE" | egrep -q "^\.B.*$COMMAND" || \
> > +	echo "$COMMAND not documented in the xfs_db manpage"
> > +done
> > +
> > +# success, all done
> > +status=0
> > +exit
> > diff --git a/tests/xfs/754.out b/tests/xfs/754.out
> > new file mode 100644
> > index 00000000..9e7cda82
> > --- /dev/null
> > +++ b/tests/xfs/754.out
> > @@ -0,0 +1,2 @@
> > +QA output created by 754
> > +Silence is golden
> > diff --git a/tests/xfs/755 b/tests/xfs/755
> > new file mode 100755
> > index 00000000..0e5d85ab
> > --- /dev/null
> > +++ b/tests/xfs/755
> > @@ -0,0 +1,53 @@
> > +#! /bin/bash
> > +# SPDX-License-Identifier: GPL-2.0-or-newer
> > +# Copyright (c) 2020, Oracle and/or its affiliates.  All Rights Reserved.
> > +#
> > +# FS QA Test No. 755
> > +#
> > +# Ensure all xfs_quota commands are documented.
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
> > +	rm -f $tmp.* $file
> > +}
> > +
> > +# get standard environment, filters and checks
> > +. ./common/rc
> > +
> > +# real QA test starts here
> > +_supported_fs xfs
> > +_supported_os Linux
> > +_require_command "$XFS_QUOTA_PROG" "xfs_quota"
> > +_require_command "$MAN_PROG" man
> > +_require_test
> > +
> > +echo "Silence is golden"
> > +
> > +MANPAGE=$($MAN_PROG --path xfs_quota)
> > +
> > +case "$MANPAGE" in
> > +*.gz|*.z\|*.Z)	CAT=zcat;;
> > +*.bz2)		CAT=bzcat;;
> > +*.xz)		CAT=xzcat;;
> > +*)		CAT=cat;;
> > +esac
> > +_require_command `which $CAT` $CAT
> > +
> > +for COMMAND in `$XFS_QUOTA_PROG -x -c help $file | awk '{print $1}' | grep -v "^Use"`; do
> > +  $CAT "$MANPAGE" | egrep -q "^\.B.*$COMMAND" || \
> > +	echo "$COMMAND not documented in the xfs_quota manpage"
> > +done
> > +
> > +# success, all done
> > +status=0
> > +exit
> > diff --git a/tests/xfs/755.out b/tests/xfs/755.out
> > new file mode 100644
> > index 00000000..7c9ea51c
> > --- /dev/null
> > +++ b/tests/xfs/755.out
> > @@ -0,0 +1,2 @@
> > +QA output created by 755
> > +Silence is golden
> > diff --git a/tests/xfs/group b/tests/xfs/group
> > index 522d4bc4..aadbb971 100644
> > --- a/tests/xfs/group
> > +++ b/tests/xfs/group
> > @@ -511,3 +511,5 @@
> >  511 auto quick quota
> >  512 auto quick acl attr
> >  513 auto mount
> > +754 auto quick db
> > +755 auto quick quota
> > 
> 
