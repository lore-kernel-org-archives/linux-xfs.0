Return-Path: <SRS0=/boU=7L=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9CF46C433DF
	for <linux-xfs@archiver.kernel.org>; Fri, 29 May 2020 07:55:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7C288206C3
	for <linux-xfs@archiver.kernel.org>; Fri, 29 May 2020 07:55:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="I3clvy4k"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726350AbgE2HzQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 29 May 2020 03:55:16 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:52413 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725865AbgE2HzP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 29 May 2020 03:55:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590738913;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=En9iqDDkuHc+j7IesCF6VH5ztuWH6X0PvMLsfV011cE=;
        b=I3clvy4k03uLbIzeHGvW62X1ibV/xX/qWaxj/Baluat3ALHuyjiDc/yMZX4qbf5hEw6xQh
        oDFCwTWB4Soo4YD9WhOFt3SRpeq7k8Gmba+wCXjltl9TWHZR4ROE2N9DO3LUz+Ack+kANx
        vS7602GLmzvK5mxbgZGwy960MwYSlK4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-487-pzMevHawPR-h3xeLTUd8lA-1; Fri, 29 May 2020 03:55:10 -0400
X-MC-Unique: pzMevHawPR-h3xeLTUd8lA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0115D8018A5;
        Fri, 29 May 2020 07:55:09 +0000 (UTC)
Received: from localhost (dhcp-12-102.nay.redhat.com [10.66.12.102])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6C76619723;
        Fri, 29 May 2020 07:55:08 +0000 (UTC)
Date:   Fri, 29 May 2020 16:06:40 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     Donald Douwsma <ddouwsma@redhat.com>
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org,
        "Darrick J . Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v2] xfstests: add test for xfs_repair progress reporting
Message-ID: <20200529080640.GH1938@dhcp-12-102.nay.redhat.com>
Mail-Followup-To: Donald Douwsma <ddouwsma@redhat.com>,
        linux-xfs@vger.kernel.org, fstests@vger.kernel.org,
        "Darrick J . Wong" <darrick.wong@oracle.com>
References: <20200519160125.GB17621@magnolia>
 <20200520035258.298516-1-ddouwsma@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200520035258.298516-1-ddouwsma@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, May 20, 2020 at 01:52:58PM +1000, Donald Douwsma wrote:
> xfs_repair's interval based progress has been broken for
> some time, create a test based on dmdelay to stretch out
> the time and use ag_stride to force parallelism.
> 
> Signed-off-by: Donald Douwsma <ddouwsma@redhat.com>
> ---
> Changes since v1:
> - Use _scratch_xfs_repair
> - Filter only repair output
> - Make the filter more tolerant of whitespace and plurals
> - Take golden output from 'xfs_repair: fix progress reporting'
> 
>  tests/xfs/516     | 76 +++++++++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/516.out | 15 ++++++++++
>  tests/xfs/group   |  1 +
>  3 files changed, 92 insertions(+)
>  create mode 100755 tests/xfs/516
>  create mode 100644 tests/xfs/516.out
> 
> diff --git a/tests/xfs/516 b/tests/xfs/516
> new file mode 100755
> index 00000000..1c0508ef
> --- /dev/null
> +++ b/tests/xfs/516
> @@ -0,0 +1,76 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2020 Red Hat, Inc.  All Rights Reserved.
> +#
> +# FS QA Test 516
> +#
> +# Test xfs_repair's progress reporting
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
> +	_dmsetup_remove delay-test > /dev/null 2>&1

How about use the helper, avoid using the 'delay-test' name at here?
_cleanup_delay > /dev/null 2>&1

> +}
> +
> +# get standard environment, filters and checks
> +. ./common/rc
> +. ./common/filter
> +. ./common/dmdelay
> +. ./common/populate
> +
> +# remove previous $seqres.full before test
> +rm -f $seqres.full
> +
> +# real QA test starts here
> +
> +# Modify as appropriate.
> +_supported_fs xfs
> +_supported_os Linux
> +_require_scratch
> +_require_dm_target delay
> +
> +# Filter output specific to the formatters in xfs_repair/progress.c
> +# Ideally we'd like to see hits on anything that matches
> +# awk '/{FMT/' repair/progress.c
> +_filter_repair()
> +{
> +	sed -ne '
> +	s/[0-9]\+/#/g;
> +	s/^\s\+/ /g;
> +	s/\(second\|minute\)s/\1/g
> +	/#:#:#:/p
> +	'
> +}
> +
> +echo "Format and populate"
> +_scratch_populate_cached nofill > $seqres.full 2>&1
> +
> +echo "Introduce a dmdelay"
> +_init_delay
> +
> +# Introduce a read I/O delay
> +# The default in common/dmdelay is a bit too agressive
> +BLK_DEV_SIZE=`blockdev --getsz $SCRATCH_DEV`
> +DELAY_TABLE_RDELAY="0 $BLK_DEV_SIZE delay $SCRATCH_DEV 0 100 $SCRATCH_DEV 0 0"
> +_load_delay_table $DELAY_READ
> +
> +echo "Run repair"
> +SCRATCH_DEV=$DELAY_DEV _scratch_xfs_repair -o ag_stride=4 -t 1 2>&1 |
> +        tee -a $seqres.full > $seqres.xfs_repair.out
> +
> +cat $seqres.xfs_repair.out | _filter_repair | sort -u
> +
> +_cleanup_delay
> +
> +# success, all done
> +status=0
> +exit
> diff --git a/tests/xfs/516.out b/tests/xfs/516.out
> new file mode 100644
> index 00000000..85018b93
> --- /dev/null
> +++ b/tests/xfs/516.out
> @@ -0,0 +1,15 @@
> +QA output created by 516
> +Format and populate
> +Introduce a dmdelay
> +Run repair
> + - #:#:#: Phase #: #% done - estimated remaining time # minute, # second

I just tested on latest upstream xfsprogs-dev for-next branch, it failed as:
--- /root/git/xfstests-dev/tests/xfs/516.out    2020-05-29 15:31:06.602440261 +0800
+++ /root/git/xfstests-dev/results//xfs/516.out.bad     2020-05-29 15:40:13.401777675 +0800
@@ -3,6 +3,7 @@
 Introduce a dmdelay
 Run repair
  - #:#:#: Phase #: #% done - estimated remaining time # minute, # second
+ - #:#:#: Phase #: #% done - estimated remaining time # second
  - #:#:#: Phase #: elapsed time # second - processed # inodes per minute
  - #:#:#: check for inodes claiming duplicate blocks - # of # inodes done
  - #:#:#: process known inodes and inode discovery - # of # inodes done


> + - #:#:#: Phase #: elapsed time # second - processed # inodes per minute
> + - #:#:#: check for inodes claiming duplicate blocks - # of # inodes done
> + - #:#:#: process known inodes and inode discovery - # of # inodes done
> + - #:#:#: process newly discovered inodes - # of # allocation groups done
> + - #:#:#: rebuild AG headers and trees - # of # allocation groups done
> + - #:#:#: scanning agi unlinked lists - # of # allocation groups done
> + - #:#:#: scanning filesystem freespace - # of # allocation groups done
> + - #:#:#: setting up duplicate extent list - # of # allocation groups done
> + - #:#:#: verify and correct link counts - # of # allocation groups done
> + - #:#:#: zeroing log - # of # blocks done
> diff --git a/tests/xfs/group b/tests/xfs/group
> index 12eb55c9..aeeca23f 100644
> --- a/tests/xfs/group
> +++ b/tests/xfs/group
> @@ -513,3 +513,4 @@
>  513 auto mount
>  514 auto quick db
>  515 auto quick quota
> +516 repair

Is there a reason why this case shouldn't be in auto group?

Thanks,
Zorro

> -- 
> 2.18.4
> 

