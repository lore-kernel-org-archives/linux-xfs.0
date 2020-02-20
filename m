Return-Path: <SRS0=u4TP=4I=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C22C2C34031
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Feb 2020 04:40:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9709224656
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Feb 2020 04:40:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fI3x0pjD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727576AbgBTEkf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 19 Feb 2020 23:40:35 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:58293 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727469AbgBTEkf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 Feb 2020 23:40:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582173634;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=jfmLCJilxONRsC3YXQnzikRMggRyDvv0QESgjaBG6YU=;
        b=fI3x0pjD7lf3VF/v2pGvPzqVK0/RJVF/UESaZ0aocjpnFMECJk4jZ7XkjPOXqh2W6dHuXu
        ZIrCrBnS42NtVOwrxeiGr88p596GTVOPaxCGR1+rhqNCjNqvLXuNbhAnElehrjlPQmXT+c
        Y+vYoHWZmLhEEWcBD3z0Uj+Ww0rsD7U=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-318-nFLLulYhMZm9k3yJ9-CSaQ-1; Wed, 19 Feb 2020 23:40:32 -0500
X-MC-Unique: nFLLulYhMZm9k3yJ9-CSaQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8D73E800D53;
        Thu, 20 Feb 2020 04:40:31 +0000 (UTC)
Received: from localhost (dhcp-12-102.nay.redhat.com [10.66.12.102])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 044F019C58;
        Thu, 20 Feb 2020 04:40:28 +0000 (UTC)
Date:   Thu, 20 Feb 2020 12:50:50 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     Eric Sandeen <sandeen@redhat.com>
Cc:     fstests <fstests@vger.kernel.org>,
        linux-xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: test that default grace periods init on first mount
Message-ID: <20200220045050.GF14282@dhcp-12-102.nay.redhat.com>
Mail-Followup-To: Eric Sandeen <sandeen@redhat.com>,
        fstests <fstests@vger.kernel.org>,
        linux-xfs <linux-xfs@vger.kernel.org>
References: <7c6b4646-d7c5-cc03-9c90-c17daa22071d@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7c6b4646-d7c5-cc03-9c90-c17daa22071d@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Feb 19, 2020 at 09:26:29PM -0600, Eric Sandeen wrote:
> There's currently a bug in how default grace periods get set up
> before the very first quotacheck runs; we try to read the quota
> inodes before they are populated, and so the grace periods remain
> empty.  The /next/ mount fills them in.  This is a regression test
> for that bug.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> diff --git a/tests/xfs/995 b/tests/xfs/995
> new file mode 100755
> index 00000000..477855b8
> --- /dev/null
> +++ b/tests/xfs/995
> @@ -0,0 +1,50 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2020 Red Hat, Inc.  All Rights Reserved.
> +#
> +# FS QA Test 995
> +#
> +# Regression test xfs flaw which did not report proper quota default
> +# grace periods until the 2nd mount of a new filesystem with quota.
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
> +. ./common/quota
> +
> +# remove previous $seqres.full before test
> +rm -f $seqres.full
> +
> +# real QA test starts here
> +_supported_fs generic
> +_supported_os Linux
> +_require_scratch
> +_require_quota

If this's xfs specified case, I think "_require_xfs_quota" might be better then
_require_quota, at least it checks "XFS_QUOTA_PROG" and some xfs specified
things.

BTW, do you think "_require_xfs_quota_foreign" can help this case to be a
generic case?

> +
> +_scratch_mkfs >$seqres.full 2>&1
> +_qmount_option "usrquota"
> +_qmount
> +
> +xfs_quota -x -c "state -u" $SCRATCH_MNT | grep "grace time"

I think $XFS_QUOTA_PROG would be better than using xfs_quota directly.

> +_scratch_unmount
> +_qmount
> +xfs_quota -x -c "state -u" $SCRATCH_MNT | grep "grace time"
> +
> +# success, all done
> +status=0
> +exit
> diff --git a/tests/xfs/995.out b/tests/xfs/995.out
> new file mode 100644
> index 00000000..d10017d1
> --- /dev/null
> +++ b/tests/xfs/995.out
> @@ -0,0 +1,7 @@
> +QA output created by 995
> +Blocks grace time: [7 days]
> +Inodes grace time: [7 days]
> +Realtime Blocks grace time: [7 days]
> +Blocks grace time: [7 days]
> +Inodes grace time: [7 days]
> +Realtime Blocks grace time: [7 days]

Hmm... but if the bug is on the default grace time itself, and different
filesystems have different default timers, then I think a xfs specified case
would be better. I don't have a better idea to make it a generic case.

The case from me:
  [PATCH 1/2] generic: per-type quota timers set/get test
Although it trys to test default quota time too, but I think it can't verify
this bug properly, especially if the default time isn't correctly at beginning.
Feel free to correct me, if you have a better idea:)

Thanks,
Zorro

> diff --git a/tests/xfs/group b/tests/xfs/group
> index 0cbd0647..235a2715 100644
> --- a/tests/xfs/group
> +++ b/tests/xfs/group
> @@ -511,3 +511,4 @@
>  511 auto quick quota
>  512 auto quick acl attr
>  513 auto mount
> +995 auto quota quick
> 

