Return-Path: <SRS0=u4TP=4I=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D10AC3404C
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Feb 2020 04:21:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E91CE2465D
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Feb 2020 04:21:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fR0G/yuP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727938AbgBTEV2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 19 Feb 2020 23:21:28 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:20409 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727875AbgBTEV2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 Feb 2020 23:21:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582172487;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=BhgVAttufdZa4j2bpTzCBwjJrMorfRdj0GcIRI+8tPg=;
        b=fR0G/yuPoulsIpMIufRO4TySYajIzZaxH/WDKGIB7+UUHtleBcRLN2B8lgu9EAfIoDEpOP
        m+Jd0E9NoqAAbr8ih3BYagUkcFzU7dHgqF3hWc2wv+xi54WaYuepK0Td9656OBqKUiuUk0
        cXl3KK5fv2mz2j9WX1To+VpHhVoqYsg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-77-q_96cknJMmegqDN8Ivdmzw-1; Wed, 19 Feb 2020 23:21:23 -0500
X-MC-Unique: q_96cknJMmegqDN8Ivdmzw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B660D107ACC4;
        Thu, 20 Feb 2020 04:21:22 +0000 (UTC)
Received: from localhost (dhcp-12-102.nay.redhat.com [10.66.12.102])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 332E25DA60;
        Thu, 20 Feb 2020 04:21:21 +0000 (UTC)
Date:   Thu, 20 Feb 2020 12:31:44 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     xfs <linux-xfs@vger.kernel.org>, fstests <fstests@vger.kernel.org>
Subject: Re: [RFC PATCH] xfs: make sure our default quota warning limits and
 grace periods survive quotacheck
Message-ID: <20200220043144.GE14282@dhcp-12-102.nay.redhat.com>
Mail-Followup-To: "Darrick J. Wong" <darrick.wong@oracle.com>,
        xfs <linux-xfs@vger.kernel.org>, fstests <fstests@vger.kernel.org>
References: <20200219003423.GB9511@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200219003423.GB9511@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Feb 18, 2020 at 04:34:23PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Make sure that the default quota grace period and maximum warning limits
> set by the administrator survive quotacheck.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
> This is the testcase to go with 'xfs: preserve default grace interval
> during quotacheck', though Eric and I haven't figured out how we're
> going to land that one...
> ---
>  tests/xfs/913     |   69 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/913.out |   13 ++++++++++
>  tests/xfs/group   |    1 +
>  3 files changed, 83 insertions(+)
>  create mode 100755 tests/xfs/913
>  create mode 100644 tests/xfs/913.out
> 
> diff --git a/tests/xfs/913 b/tests/xfs/913

Hi,

Can "_require_xfs_quota_foreign" help this case to be a generic case?

> new file mode 100755
> index 00000000..94681b02
> --- /dev/null
> +++ b/tests/xfs/913
> @@ -0,0 +1,69 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0-or-later
> +# Copyright (c) 2020, Oracle and/or its affiliates.  All Rights Reserved.
> +#
> +# FS QA Test No. 913
> +#
> +# Make sure that the quota default grace period and maximum warning limits
> +# survive quotacheck.
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
> +. ./common/filter
> +. ./common/quota
> +
> +# real QA test starts here
> +_supported_fs xfs
> +_supported_os Linux
> +_require_quota
> +
> +rm -f $seqres.full
> +
> +# Format filesystem and set up quota limits
> +_scratch_mkfs > $seqres.full
> +_qmount_option "usrquota"
> +_scratch_mount >> $seqres.full
> +
> +$XFS_QUOTA_PROG -x -c 'timer -u 300m' $SCRATCH_MNT
> +$XFS_QUOTA_PROG -x -c 'state' $SCRATCH_MNT | grep 'grace time'
> +_scratch_unmount
> +
> +# Remount and check the limits
> +_scratch_mount >> $seqres.full
> +$XFS_QUOTA_PROG -x -c 'state' $SCRATCH_MNT | grep 'grace time'
> +_scratch_unmount
> +
> +# Run repair to force quota check
> +_scratch_xfs_repair >> $seqres.full 2>&1

I've sent a case looks like do similar test as this:
  [PATCH 1/2] generic: per-type quota timers set/get test

But it doesn't do fsck before cycle-mount. And ...[below]

> +
> +# Remount (this time to run quotacheck) and check the limits.  There's a bug
> +# in quotacheck where we would reset the ondisk default grace period to zero
> +# while the incore copy stays at whatever was read in prior to quotacheck.
> +# This will show up after the /next/ remount.
> +_scratch_mount >> $seqres.full
> +$XFS_QUOTA_PROG -x -c 'state' $SCRATCH_MNT | grep 'grace time'
> +_scratch_unmount
> +
> +# Remount and check the limits
> +_scratch_mount >> $seqres.full
> +$XFS_QUOTA_PROG -x -c 'state' $SCRATCH_MNT | grep 'grace time'
> +_scratch_unmount

It doesn't do twice cycle mount either. Do you think the fsck is necessary?
And do you think these two cases can be merged into one case?

Thanks,
Zorro

> +
> +# success, all done
> +status=0
> +exit
> diff --git a/tests/xfs/913.out b/tests/xfs/913.out
> new file mode 100644
> index 00000000..ee989388
> --- /dev/null
> +++ b/tests/xfs/913.out
> @@ -0,0 +1,13 @@
> +QA output created by 913
> +Blocks grace time: [0 days 05:00:00]
> +Inodes grace time: [0 days 05:00:00]
> +Realtime Blocks grace time: [0 days 05:00:00]
> +Blocks grace time: [0 days 05:00:00]
> +Inodes grace time: [0 days 05:00:00]
> +Realtime Blocks grace time: [0 days 05:00:00]
> +Blocks grace time: [0 days 05:00:00]
> +Inodes grace time: [0 days 05:00:00]
> +Realtime Blocks grace time: [0 days 05:00:00]
> +Blocks grace time: [0 days 05:00:00]
> +Inodes grace time: [0 days 05:00:00]
> +Realtime Blocks grace time: [0 days 05:00:00]
> diff --git a/tests/xfs/group b/tests/xfs/group
> index 056072fb..87b3c75d 100644
> --- a/tests/xfs/group
> +++ b/tests/xfs/group
> @@ -539,4 +539,5 @@
>  910 auto quick inobtcount
>  911 auto quick bigtime
>  912 auto quick label
> +913 auto quick quota
>  997 auto quick mount
> 

