Return-Path: <SRS0=/CVM=XI=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3AF49C49ED7
	for <linux-xfs@archiver.kernel.org>; Fri, 13 Sep 2019 17:36:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0EEC62081B
	for <linux-xfs@archiver.kernel.org>; Fri, 13 Sep 2019 17:36:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731054AbfIMRg2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 13 Sep 2019 13:36:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53366 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728811AbfIMRg1 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 13 Sep 2019 13:36:27 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 242B518C4273;
        Fri, 13 Sep 2019 17:36:27 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 5AB915C207;
        Fri, 13 Sep 2019 17:36:26 +0000 (UTC)
Date:   Fri, 13 Sep 2019 13:36:24 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     kaixuxia <xiakaixu1987@gmail.com>
Cc:     fstests@vger.kernel.org, linux-xfs@vger.kernel.org,
        Eryu Guan <guaneryu@gmail.com>,
        "Darrick J. Wong" <darrick.wong@oracle.com>, newtongao@tencent.com,
        jasperwang@tencent.com
Subject: Re: [PATCH 2/2] xfs: test the deadlock between the AGI and AGF with
 RENAME_WHITEOUT
Message-ID: <20190913173624.GD28512@bfoster>
References: <58163375-dcd9-b954-c8d2-89fef20b8246@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <58163375-dcd9-b954-c8d2-89fef20b8246@gmail.com>
User-Agent: Mutt/1.12.0 (2019-05-25)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.62]); Fri, 13 Sep 2019 17:36:27 +0000 (UTC)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Sep 11, 2019 at 09:17:08PM +0800, kaixuxia wrote:
> There is ABBA deadlock bug between the AGI and AGF when performing
> rename() with RENAME_WHITEOUT flag, and add this testcase to make
> sure the rename() call works well.
> 
> Signed-off-by: kaixuxia <kaixuxia@tencent.com>
> ---
>  tests/xfs/512     | 99 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/512.out |  2 ++
>  tests/xfs/group   |  1 +
>  3 files changed, 102 insertions(+)
>  create mode 100755 tests/xfs/512
>  create mode 100644 tests/xfs/512.out
> 
> diff --git a/tests/xfs/512 b/tests/xfs/512
> new file mode 100755
> index 0000000..754f102
> --- /dev/null
> +++ b/tests/xfs/512
> @@ -0,0 +1,99 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2019 Tencent.  All Rights Reserved.
> +#
> +# FS QA Test 512
> +#
> +# Test the ABBA deadlock case between the AGI and AGF When performing
> +# rename operation with RENAME_WHITEOUT flag.
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
> +}
> +
> +# get standard environment, filters and checks
> +. ./common/rc
> +. ./common/filter
> +. ./common/renameat2
> +
> +rm -f $seqres.full
> +
> +# real QA test starts here
> +_supported_fs xfs
> +_supported_os Linux
> +_require_scratch_nocheck

Why _nocheck? AFAICT the filesystem shouldn't end up intentionally
corrupted.

> +_requires_renameat2 whiteout
> +
> +prepare_file()
> +{
> +	# create many small files for the rename with RENAME_WHITEOUT
> +	i=0
> +	while [ $i -le $files ]; do
> +		file=$SCRATCH_MNT/f$i
> +		echo > $file >/dev/null 2>&1
> +		let i=$i+1
> +	done

Something like the following is a bit more simple, IMO:

	for i in $(seq 1 $files); do
		touch $SCRATCH_MNT/f.$i
	done

The same goes for the other while loops below that increment up to
$files.

> +}
> +
> +rename_whiteout()
> +{
> +	# create the rename targetdir
> +	renamedir=$SCRATCH_MNT/renamedir
> +	mkdir $renamedir
> +
> +	# a long filename could increase the possibility that target_dp
> +	# allocate new blocks(acquire the AGF lock) to store the filename
> +	longnamepre=FFFsafdsagafsadfagasdjfalskdgakdlsglkasdg
> +

The max filename length is 256 bytes. You could do something like the
following to increase name length (leaving room for the file index and
terminating NULL) if it helps the test:

	prefix=`for i in $(seq 0 245); do echo -n a; done`

> +	# now try to do rename with RENAME_WHITEOUT flag
> +	i=0
> +	while [ $i -le $files ]; do
> +		src/renameat2 -w $SCRATCH_MNT/f$i $renamedir/$longnamepre$i >/dev/null 2>&1
> +		let i=$i+1
> +	done
> +}
> +
> +create_file()
> +{
> +	# create the targetdir
> +	createdir=$SCRATCH_MNT/createdir
> +	mkdir $createdir
> +
> +	# try to create file at the same time to hit the deadlock
> +	i=0
> +	while [ $i -le $files ]; do
> +		file=$createdir/f$i
> +		echo > $file >/dev/null 2>&1
> +		let i=$i+1
> +	done
> +}

You could generalize this function to take a target directory parameter
and just call it twice (once to prepare and again for the create
workload).

> +
> +_scratch_mkfs_xfs -bsize=1024 -dagcount=1 >> $seqres.full 2>&1 ||
> +	_fail "mkfs failed"

Why -bsize=1k? Does that make the reproducer more effective?

> +_scratch_mount
> +
> +files=250000
> +

Have you tested effectiveness of reproducing the issue with smaller file
counts? A brief comment here to document where the value comes from
might be useful. Somewhat related, how long does this test take on fixed
kernels?

> +prepare_file
> +rename_whiteout &
> +create_file &
> +
> +wait
> +echo Silence is golden
> +
> +# Failure comes in the form of a deadlock.
> +

I wonder if this should be in the dangerous group as well. I go back and
forth on that though because I tend to filter out dangerous tests and
the test won't be so risky once the fix proliferates. Perhaps that's
just a matter of removing it from the dangerous group after a long
enough period of time.

Brian

> +# success, all done
> +status=0
> +exit
> diff --git a/tests/xfs/512.out b/tests/xfs/512.out
> new file mode 100644
> index 0000000..0aabdef
> --- /dev/null
> +++ b/tests/xfs/512.out
> @@ -0,0 +1,2 @@
> +QA output created by 512
> +Silence is golden
> diff --git a/tests/xfs/group b/tests/xfs/group
> index a7ad300..ed250d6 100644
> --- a/tests/xfs/group
> +++ b/tests/xfs/group
> @@ -509,3 +509,4 @@
>  509 auto ioctl
>  510 auto ioctl quick
>  511 auto quick quota
> +512 auto rename
> -- 
> 1.8.3.1
> 
> -- 
> kaixuxia
