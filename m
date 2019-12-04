Return-Path: <SRS0=+YF0=Z2=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9E15C432C3
	for <linux-xfs@archiver.kernel.org>; Wed,  4 Dec 2019 00:14:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BB4462073C
	for <linux-xfs@archiver.kernel.org>; Wed,  4 Dec 2019 00:14:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="kv750daY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726350AbfLDAOu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 3 Dec 2019 19:14:50 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:45706 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726079AbfLDAOt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 3 Dec 2019 19:14:49 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xB40EVfk001694;
        Wed, 4 Dec 2019 00:14:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=d/VNCRyz4mt8bFIEbD+lPw4SZ0shQXFs5asH43n986M=;
 b=kv750daYkWr1nd3eKMtQVcTfaYYVdsXYE34dtMjVqvS676KEQSw3LfKqolZmmRYmNp8a
 Ps0HkDwOMtsrFiaPqvF75x+4de1gSnxwRKEUPXaPwjH/AnT7umyxhH5teuAduDA+LnSS
 mQlYgYpaT6gigo9dw8QF8Q6IgIUEJFYDI7ROKMVeaZnacH0uuKS7ac+fu0h9isVFfqEO
 g34mRy40blhfJ5KIjH4MMNOmNTCMRCfwmu541VplmgTqGOxD5UJTj2gr3WEBZQq3gJNJ
 cYdRl0BDWRrTMVcuvBjtHalQtL6deWQR7rS2+LQIKoICPu+XtiFvK9we96ZvfNIKmpdb 2A== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2wkfuuba1f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 04 Dec 2019 00:14:45 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xB3NTK42007505;
        Wed, 4 Dec 2019 00:12:45 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 2wnvqx8xed-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 04 Dec 2019 00:12:45 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xB40ChmA030349;
        Wed, 4 Dec 2019 00:12:43 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 03 Dec 2019 16:12:43 -0800
Date:   Tue, 3 Dec 2019 16:12:42 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Omar Sandoval <osandov@osandov.com>
Cc:     fstests@vger.kernel.org, kernel-team@fb.com,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH v3] generic: test truncating mixed written/unwritten XFS
 realtime extent
Message-ID: <20191204001242.GN7335@magnolia>
References: <110dbf3ff8c8004e4eecef2cc2e84dfe2d3ddd9f.1575416911.git.osandov@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <110dbf3ff8c8004e4eecef2cc2e84dfe2d3ddd9f.1575416911.git.osandov@fb.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9460 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1912030171
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9460 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1912040000
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Dec 03, 2019 at 03:51:52PM -0800, Omar Sandoval wrote:
> From: Omar Sandoval <osandov@fb.com>
> 
> The only XFS-specific part of this test is the setup, so we can make the
> rest a generic test. It's slow, though, as it needs to write 8GB to
> convert a big unwritten extent to written.
> 
> Signed-off-by: Omar Sandoval <osandov@fb.com>

Looks good to me,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
> Changes from v2 -> v3:
> 
> - Use _create_loop_device and _destroy_loop_device instead of losetup
> 
> Changes from v1 -> v2:
> 
> - If rtdev is not configured, fall back to loop device on test
>   filesystem
> - Use XFS_IO_PROG instead of fallocate/sync/dd
> - Use truncate instead of rm
> - Add comments explaining the steps
> 
>  tests/generic/589     | 100 ++++++++++++++++++++++++++++++++++++++++++
>  tests/generic/589.out |   2 +
>  tests/generic/group   |   1 +
>  3 files changed, 103 insertions(+)
>  create mode 100755 tests/generic/589
>  create mode 100644 tests/generic/589.out
> 
> diff --git a/tests/generic/589 b/tests/generic/589
> new file mode 100755
> index 00000000..aab37bb4
> --- /dev/null
> +++ b/tests/generic/589
> @@ -0,0 +1,100 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2019 Facebook.  All Rights Reserved.
> +#
> +# FS QA Test 589
> +#
> +# Test "xfs: fix realtime file data space leak" and "xfs: don't check for AG
> +# deadlock for realtime files in bunmapi". On XFS without the fix, truncate
> +# will hang forever. On other filesystems, this just tests writing into big
> +# fallocates.
> +#
> +seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
> +echo "QA output created by $seq"
> +
> +here=`pwd`
> +tmp=/tmp/$$
> +status=1	# failure is the default!
> +trap "_cleanup; exit \$status" 0 1 2 3 15
> +
> +_cleanup()
> +{
> +	cd /
> +	rm -f $tmp.*
> +	test -n "$loop" && _destroy_loop_device "$loop"
> +	rm -f "$TEST_DIR/$seq"
> +}
> +
> +. ./common/rc
> +. ./common/filter
> +
> +rm -f $seqres.full
> +
> +_supported_fs generic
> +_supported_os Linux
> +_require_scratch_nocheck
> +
> +maxextlen=$((0x1fffff))
> +bs=4096
> +rextsize=4
> +filesz=$(((maxextlen + 1) * bs))
> +
> +extra_options=""
> +# If we're testing XFS, set up the realtime device to reproduce the bug.
> +if [[ $FSTYP = xfs ]]; then
> +	# If we don't have a realtime device, set up a loop device on the test
> +	# filesystem.
> +	if [[ $USE_EXTERNAL != yes || -z $SCRATCH_RTDEV ]]; then
> +		_require_test
> +		loopsz="$((filesz + (1 << 26)))"
> +		_require_fs_space "$TEST_DIR" $((loopsz / 1024))
> +		$XFS_IO_PROG -c "truncate $loopsz" -f "$TEST_DIR/$seq"
> +		loop="$(_create_loop_device "$TEST_DIR/$seq")"
> +		USE_EXTERNAL=yes
> +		SCRATCH_RTDEV="$loop"
> +	fi
> +	extra_options="$extra_options -bsize=$bs"
> +	extra_options="$extra_options -r extsize=$((bs * rextsize))"
> +	extra_options="$extra_options -d agsize=$(((maxextlen + 1) * bs / 2)),rtinherit=1"
> +fi
> +_scratch_mkfs $extra_options >>$seqres.full 2>&1
> +_scratch_mount
> +_require_fs_space "$SCRATCH_MNT" $((filesz / 1024))
> +
> +# Allocate maxextlen + 1 blocks. As long as the allocator does something sane,
> +# we should end up with two extents that look something like:
> +#
> +# u3.bmx[0-1] = [startoff,startblock,blockcount,extentflag]
> +# 0:[0,0,2097148,1]
> +# 1:[2097148,2097148,4,1]
> +#
> +# Extent 0 has blockcount = ALIGN_DOWN(maxextlen, rextsize). Extent 1 is
> +# adjacent and has blockcount = rextsize. Both are unwritten.
> +$XFS_IO_PROG -c "falloc 0 $filesz" -c fsync -f "$SCRATCH_MNT/file"
> +
> +# Write extent 0 + one block of extent 1. Our extents should end up like so:
> +#
> +# u3.bmx[0-1] = [startoff,startblock,blockcount,extentflag]
> +# 0:[0,0,2097149,0]
> +# 1:[2097149,2097149,3,1]
> +#
> +# Extent 0 is written and has blockcount = ALIGN_DOWN(maxextlen, rextsize) + 1,
> +# Extent 1 is adjacent, unwritten, and has blockcount = rextsize - 1 and
> +# startblock % rextsize = 1.
> +#
> +# The -b is just to speed things up (doing GBs of I/O in 4k chunks kind of
> +# sucks).
> +$XFS_IO_PROG -c "pwrite -b 1M -W 0 $(((maxextlen + 2 - rextsize) * bs))" \
> +	"$SCRATCH_MNT/file" >> "$seqres.full"
> +
> +# Truncate the extents.
> +$XFS_IO_PROG -c "truncate 0" -c fsync "$SCRATCH_MNT/file"
> +
> +# We need to do this before the loop device gets torn down.
> +_scratch_unmount
> +_check_scratch_fs
> +
> +echo "Silence is golden"
> +status=0
> +exit
> diff --git a/tests/generic/589.out b/tests/generic/589.out
> new file mode 100644
> index 00000000..5ab6ab10
> --- /dev/null
> +++ b/tests/generic/589.out
> @@ -0,0 +1,2 @@
> +QA output created by 589
> +Silence is golden
> diff --git a/tests/generic/group b/tests/generic/group
> index 87d7441c..be6f4a43 100644
> --- a/tests/generic/group
> +++ b/tests/generic/group
> @@ -591,3 +591,4 @@
>  586 auto quick rw prealloc
>  587 auto quick rw prealloc
>  588 auto quick log clone
> +589 auto prealloc preallocrw dangerous
> -- 
> 2.24.0
> 
