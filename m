Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1FEF7C433DB
	for <linux-xfs@archiver.kernel.org>; Wed,  3 Feb 2021 15:46:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BDE6B64F91
	for <linux-xfs@archiver.kernel.org>; Wed,  3 Feb 2021 15:46:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233837AbhBCPqu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 3 Feb 2021 10:46:50 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:52273 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234491AbhBCPpm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 3 Feb 2021 10:45:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612367052;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ugg+CWM5SkNKzVb2MG10+l6bncTiK6LEIm5bJrWNBnM=;
        b=VL9N9tjs8knOq4HlOLo8d2qOA60lVgaeo/QIwSMoiepyQIJLqGLoTwGRUaUuU2bkepDGFW
        ION3vMW7lfFn43ZCQ1fZSCTkCOrdPJF/ZCS2caBa/7VH2gXVQudEO+ahgArgjGBSMscpS7
        MaKWS8RqolDWv2zca18ShUv/T0ZV+I0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-494-ksRcdiFDM6CJ24HFd2xX7Q-1; Wed, 03 Feb 2021 10:44:10 -0500
X-MC-Unique: ksRcdiFDM6CJ24HFd2xX7Q-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1AD155127;
        Wed,  3 Feb 2021 15:44:09 +0000 (UTC)
Received: from localhost (unknown [10.66.61.36])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8DC6A7046A;
        Wed,  3 Feb 2021 15:44:08 +0000 (UTC)
Date:   Thu, 4 Feb 2021 00:01:16 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     xfs <linux-xfs@vger.kernel.org>, fstests <fstests@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH] xfs: test delalloc quota leak when chprojid fails
Message-ID: <20210203160115.GE14354@localhost.localdomain>
Mail-Followup-To: "Darrick J. Wong" <djwong@kernel.org>,
        xfs <linux-xfs@vger.kernel.org>, fstests <fstests@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        Brian Foster <bfoster@redhat.com>
References: <20210202194101.GQ7193@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210202194101.GQ7193@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Feb 02, 2021 at 11:41:01AM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> This is a regression test for a bug in the XFS implementation of
> FSSETXATTR.  When we try to change a file's project id, the quota
> reservation code will update the incore quota reservations for delayed
> allocation blocks.  Unfortunately, it does this before we finish
> validating all the FSSETXATTR parameters, which means that if we decide
> to bail out, we also fail to undo the incore changes.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---

Looks like this patch comes from djwong-devel :) It can't be merged into
xfstests-dev mainline directly.

  Applying: xfs: test delalloc quota leak when chprojid fails
  error: patch failed: src/Makefile:29
  error: src/Makefile: patch does not apply
  error: patch failed: tests/xfs/group:544
  error: tests/xfs/group: patch does not apply

Anyway, I think Eryu can solve it. I just have another question below.

>  .gitignore          |    1 +
>  src/Makefile        |    3 +-
>  src/chprojid_fail.c |   86 +++++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/765       |   63 +++++++++++++++++++++++++++++++++++++
>  tests/xfs/765.out   |    3 ++
>  tests/xfs/group     |    1 +
>  6 files changed, 156 insertions(+), 1 deletion(-)
>  create mode 100644 src/chprojid_fail.c
>  create mode 100755 tests/xfs/765
>  create mode 100644 tests/xfs/765.out
> 

[snip]

> +# FS QA Test No. 765
> +#
> +# Regression test for failing to undo delalloc quota reservations when changing
> +# project id but we fail some other part of FSSETXATTR validation.  If we fail
> +# the test, we trip debugging assertions in dmesg.
> +#
> +# The appropriate XFS patch is:
> +# xfs: fix chown leaking delalloc quota blocks when fssetxattr fails
> +
> +seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
> +echo "QA output created by $seq"
> +
> +here=`pwd`
> +tmp=/tmp/$$
> +status=1    # failure is the default!
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
> +. ./common/quota
> +
> +# real QA test starts here
> +_supported_fs xfs
> +_require_xfs_debug

Why CONFIG_XFS_DEBUG=y is necessary for this case? Maybe I miss something, but
I didn't see any debug injection in this case. If a kernel is only built with
CONFIG_XFS_WARN=y, I still can reproduce this bug [1].

Even if the XFS_WARN and XFS_DEUBG are all unset, I think this case can be run
without any failures. So why not just let it run? We could recommand using
debug xfs kernel, but general kernel don't need to skip this test.

Thanks,
Zorro

[1]
# ./check xfs/765
FSTYP         -- xfs (non-debug)
PLATFORM      -- Linux/x86_64 hp-dl380pg8-01 4.18.0 #1 SMP Sat Jan 23 14:15:14 EST 2021
MKFS_OPTIONS  -- -f -m reflink=1,rmapbt=1 /dev/mapper/xfscratch
MOUNT_OPTIONS -- -o context=system_u:object_r:root_t:s0 /dev/mapper/xfscratch /mnt/scratch

xfs/765 _check_dmesg: something found in dmesg (see /home/xfstests-dev/results//xfs/765.dmesg)

Ran: xfs/765
Failures: xfs/765
Failed 1 of 1 tests

[root@hp-dl380pg8-01 xfstests-dev]# less /home/xfstests-dev/results//xfs/765.dmesg
[30020.559403] run fstests xfs/765 at 2021-02-03 10:36:02
...
[30028.411797] XFS: Assertion failed: dqp->q_res_bcount >= be64_to_cpu(dqp->q_core.d_bcount), file: fs/xfs/xfs_trans_dquot.c, line: 471

> +_require_command "$FILEFRAG_PROG" filefrag
> +_require_test_program "chprojid_fail"
> +_require_quota
> +_require_scratch
> +
> +rm -f $seqres.full
> +
> +echo "Format filesystem" | tee -a $seqres.full
> +_scratch_mkfs > $seqres.full
> +_qmount_option 'prjquota'
> +_qmount
> +_require_prjquota $SCRATCH_DEV
> +
> +echo "Run test program"
> +$XFS_QUOTA_PROG -f -x -c 'report -ap' $SCRATCH_MNT >> $seqres.full
> +$here/src/chprojid_fail $SCRATCH_MNT/blah >> $seqres.full
> +res=$?
> +if [ $res -ne 0 ]; then
> +	echo "chprojid_fail returned $res, expected 0"
> +fi
> +$XFS_QUOTA_PROG -f -x -c 'report -ap' $SCRATCH_MNT >> $seqres.full
> +$FILEFRAG_PROG -v $SCRATCH_MNT/blah >> $seqres.full
> +$FILEFRAG_PROG -v $SCRATCH_MNT/blah 2>&1 | grep -q delalloc || \
> +	echo "file didn't get delalloc extents?"
> +
> +# success, all done
> +status=0
> +exit
> diff --git a/tests/xfs/765.out b/tests/xfs/765.out
> new file mode 100644
> index 00000000..f44ba43e
> --- /dev/null
> +++ b/tests/xfs/765.out
> @@ -0,0 +1,3 @@
> +QA output created by 765
> +Format filesystem
> +Run test program
> diff --git a/tests/xfs/group b/tests/xfs/group
> index f406a9b9..fb78b0d7 100644
> --- a/tests/xfs/group
> +++ b/tests/xfs/group
> @@ -544,6 +544,7 @@
>  762 auto quick rw scrub realtime
>  763 auto quick rw realtime
>  764 auto quick repair
> +765 auto quick quota
>  908 auto quick bigtime
>  909 auto quick bigtime quota
>  910 auto quick inobtcount
> 

