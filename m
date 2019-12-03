Return-Path: <SRS0=2geO=ZZ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0AEADC432C0
	for <linux-xfs@archiver.kernel.org>; Tue,  3 Dec 2019 22:37:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C218B2073C
	for <linux-xfs@archiver.kernel.org>; Tue,  3 Dec 2019 22:37:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="OnJGL9TD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727731AbfLCWhd (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 3 Dec 2019 17:37:33 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:36910 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727714AbfLCWha (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 3 Dec 2019 17:37:30 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xB3MYA6f127058;
        Tue, 3 Dec 2019 22:37:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=pcdYAd8DVmJj+FnKLKln0utt48/+qxa4xTXV11/1fGo=;
 b=OnJGL9TDTKJlC0U2DsLKw4x2kI3uLMTy8EdIUPh+iedK1055UaUFXlJnmRlcSCD7dAs9
 XjlYkz64GLcaAqYD51F5lIjptBR4u9YcMPWtEErphGjmHr7uOZ7TYuyR4AohsolB/LXN
 1U61AvspypNPSViPD7PlUPvrcRLvmIr58lkChKf5EGHDefmjU1kHWSb18kP351A/P0+P
 0qK8Fe8TzC5WEa64VHlWUCJ7tfR51QxCfw6USUYMUokQo5zFCH1aX0R9Pq8wbe/6b5G9
 kc43nK58h/H8bhzhbygktjGilMpO60r5GEHRnrskzEWDgowG0z5C69UJVee2zzb4mxuv vw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2wkfuuayjm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 03 Dec 2019 22:37:26 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xB3MY80O188834;
        Tue, 3 Dec 2019 22:37:25 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 2wnb81tgqy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 03 Dec 2019 22:37:25 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xB3MbN7D016966;
        Tue, 3 Dec 2019 22:37:24 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 03 Dec 2019 14:37:23 -0800
Date:   Tue, 3 Dec 2019 14:37:22 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Omar Sandoval <osandov@osandov.com>
Cc:     fstests@vger.kernel.org, kernel-team@fb.com,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2] generic: test truncating mixed written/unwritten XFS
 realtime extent
Message-ID: <20191203223722.GC7328@magnolia>
References: <d1c820e50399a16f968b5e0dd32b21234568b163.1575404627.git.osandov@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d1c820e50399a16f968b5e0dd32b21234568b163.1575404627.git.osandov@fb.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9460 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1912030165
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9460 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1912030165
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Dec 03, 2019 at 12:25:01PM -0800, Omar Sandoval wrote:
> From: Omar Sandoval <osandov@fb.com>
> 
> The only XFS-specific part of this test is the setup, so we can make the
> rest a generic test. It's slow, though, as it needs to write 8GB to
> convert a big unwritten extent to written.
> 
> Signed-off-by: Omar Sandoval <osandov@fb.com>
> ---
> Changes from v1:
> 
> - If rtdev is not configured, fall back to loop device on test
>   filesystem
> - Use XFS_IO_PROG instead of fallocate/sync/dd
> - Use truncate instead of rm
> - Add comments explaining the steps
> 
>  tests/generic/589     | 102 ++++++++++++++++++++++++++++++++++++++++++
>  tests/generic/589.out |   2 +
>  tests/generic/group   |   1 +
>  3 files changed, 105 insertions(+)
>  create mode 100755 tests/generic/589
>  create mode 100644 tests/generic/589.out
> 
> diff --git a/tests/generic/589 b/tests/generic/589
> new file mode 100755
> index 00000000..3ca1d100
> --- /dev/null
> +++ b/tests/generic/589
> @@ -0,0 +1,102 @@
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
> +	if [[ -n $loop ]]; then
> +		losetup -d "$loop" > /dev/null 2>&1

test -n "$loop" && _destroy_loop_device "$loop"

> +	fi
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
> +		loop="$(losetup -f --show "$TEST_DIR/$seq")"

loop=$(_create_loop_device $TEST_DIR/$seq)

Otherwise, this looks good to me.

--D

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
