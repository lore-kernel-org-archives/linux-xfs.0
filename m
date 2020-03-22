Return-Path: <SRS0=sv4t=5H=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 712C9C54FCF
	for <linux-xfs@archiver.kernel.org>; Sun, 22 Mar 2020 15:18:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 48B802073C
	for <linux-xfs@archiver.kernel.org>; Sun, 22 Mar 2020 15:18:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PIoh++VZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726623AbgCVPSP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 22 Mar 2020 11:18:15 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:32892 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726583AbgCVPSP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 22 Mar 2020 11:18:15 -0400
Received: by mail-pf1-f193.google.com with SMTP id j1so3465720pfe.0;
        Sun, 22 Mar 2020 08:18:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=j4/13bQ9x6psXaB/Ov5YGPNFBCOPsabwEAmrmuZB7eo=;
        b=PIoh++VZLHlMeKjWkbSW2CuHqA0gpv9lF3hBoBTaHO3xgViVxbH/CIH+66ZpGoKiTW
         LCrVRRdZYyjBi5snjc7oJ/WKq6NMSeL/0VEE5rsP/mD2ABhYXGIGlmq04cWybWeK8efw
         fSIzdLw7cN0Xv/nHf4vijfd2bb7uMcIJqLCWi6iLufmZi9dnaq1u4CPLgjSAOQTr1Zs+
         ktSb8XYAWnG8ZWwZIciWvKMw1SvuomjTuUpL4q6C7DX07EuNZ5jLDHoRJOUsZQFjslPD
         CvXFQ1HUUtylDSJXkZN21ttAtiFRTQ8Kvf3ucQOzcR1Bt3QqGqBDqnGd1qJWSY+D5B+0
         NgEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=j4/13bQ9x6psXaB/Ov5YGPNFBCOPsabwEAmrmuZB7eo=;
        b=QWPJyl1Tz6dZ3C4VZ0xVJ4gcpvZiqfH4o0vthje0xhfNunLCje7PfhYQgp8k7boq3/
         kiseY3e5wEaWMq7NkLsgcyO9r/f/eZa2UQqOowGsnhELWLzu0jTw1cdJ/5iVeYVTCmne
         +IPz9+W+uQ9u416J+8qvZVvtRt+YikaGkWlFWspPqA4HgH3gnPdEqhKDdfHxZGGv08sB
         3OfbiQcQtxV++RGMR9K6Ybi9zy3ZM2sUL8sDehs4r1MS8hezlsfJsPXVxAqIkYncC0a8
         coImng5Gp18BXFrbEkyBcjJdaJUr6EGyruXD+6hLa06t49ogOU8WedA1xxOP06Xtr9ZR
         bGJQ==
X-Gm-Message-State: ANhLgQ3vZPeB+Do75+Jh6vxTX8ohfwgurYx+oHjg7m79TiecGb/jb8uV
        gc9HvyOJsUxVOTRW0YOnP9A=
X-Google-Smtp-Source: ADFU+vvsHZtXz/MLmAZwSoEjJlg7uibnFXk+MQbSDthiUMviKRg0iIlyUR2jf7l2z6f+GtbYghxHcA==
X-Received: by 2002:a63:774c:: with SMTP id s73mr349180pgc.47.1584890293402;
        Sun, 22 Mar 2020 08:18:13 -0700 (PDT)
Received: from localhost ([178.128.102.47])
        by smtp.gmail.com with ESMTPSA id r29sm9762297pgm.17.2020.03.22.08.18.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 22 Mar 2020 08:18:12 -0700 (PDT)
Date:   Sun, 22 Mar 2020 23:18:27 +0800
From:   Eryu Guan <guaneryu@gmail.com>
To:     Zorro Lang <zlang@redhat.com>
Cc:     fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2] generic: per-type quota timers set/get test
Message-ID: <20200322151817.GF3128153@desktop>
References: <20200315133310.6455-1-zlang@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200315133310.6455-1-zlang@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Mar 15, 2020 at 09:33:10PM +0800, Zorro Lang wrote:
> Set different grace time, make sure each of quota (user, group and
> project) timers can be set (by setquota) and get (by repquota)
> correctly.
> 
> Signed-off-by: Zorro Lang <zlang@redhat.com>
> ---
> 
> V2 did below changes:
> 1) Filter default quota timer.
> 2) Try to merge the case from Darrick:
> https://marc.info/?l=fstests&m=158207247224104&w=2
> 
> Please review, feel free to tell me if anything wrong.
> 
> Thanks,
> Zorro
> 
>  tests/generic/594     | 104 ++++++++++++++++++++++++++++++++++++++++++
>  tests/generic/594.out |  50 ++++++++++++++++++++
>  tests/generic/group   |   1 +
>  3 files changed, 155 insertions(+)
>  create mode 100755 tests/generic/594
>  create mode 100644 tests/generic/594.out
> 
> diff --git a/tests/generic/594 b/tests/generic/594
> new file mode 100755
> index 00000000..fb71a57b
> --- /dev/null
> +++ b/tests/generic/594
> @@ -0,0 +1,104 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2020 Red Hat, Inc.  All Rights Reserved.
> +#
> +# FS QA Test No. 594
> +#
> +# Test per-type(user, group and project) filesystem quota timers, make sure
> +# each of grace time can be set/get properly.
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
> +
> +_scratch_mkfs >$seqres.full 2>&1
> +_scratch_enable_pquota
> +_qmount_option "usrquota,grpquota,prjquota"
> +_qmount

_qmount fails with 512 block size xfs, dmesg says:

[ 5946.077204] XFS (dm-5): Super block does not support project and group quota together

Seems we need to filter this case out?

Thanks,
Eryu

> +_require_prjquota $SCRATCH_DEV
> +
> +MIN=60
> +
> +# get default time at first
> +def_time=`repquota -u $SCRATCH_MNT | \
> +		sed -n -e "/^Block/s/.* time: \(.*\); .* time: \(.*\)/\1 \2/p"`
> +echo "Default block and inode grace timers are: $def_time" >> $seqres.full
> +
> +filter_repquota()
> +{
> +	local blocktime=$1
> +	local inodetime=$2
> +
> +	_filter_scratch | sed -e "s,$blocktime,DEF_TIME,g" \
> +			      -e "s,$inodetime,DEF_TIME,g"
> +}
> +
> +echo "1. set project quota timer"
> +setquota -t -P $((10 * MIN)) $((20 * MIN)) $SCRATCH_MNT
> +repquota -ugP $SCRATCH_MNT | grep "Report\|^Block" | filter_repquota $def_time
> +echo
> +
> +echo "2. set group quota timer"
> +setquota -t -g $((30 * MIN)) $((40 * MIN)) $SCRATCH_MNT
> +repquota -ugP $SCRATCH_MNT | grep "Report\|^Block" | filter_repquota $def_time
> +echo
> +
> +echo "3. set user quota timer"
> +setquota -t -u $((50 * MIN)) $((60 * MIN)) $SCRATCH_MNT
> +repquota -ugP $SCRATCH_MNT | grep "Report\|^Block" | filter_repquota $def_time
> +echo
> +
> +# cycle mount, make sure the quota timers are still right
> +echo "4. cycle mount test-1"
> +_qmount
> +repquota -ugP $SCRATCH_MNT | grep "Report\|^Block" | filter_repquota $def_time
> +echo
> +
> +# Run repair to force quota check
> +echo "5. fsck to force quota check"
> +_scratch_unmount
> +_repair_scratch_fs >> $seqres.full 2>&1
> +echo
> +
> +# Remount (this time to run quotacheck) and check the limits.  There's a bug
> +# in quotacheck where we would reset the ondisk default grace period to zero
> +# while the incore copy stays at whatever was read in prior to quotacheck.
> +# This will show up after the /next/ remount.
> +echo "6. cycle mount test-2"
> +_qmount
> +repquota -ugP $SCRATCH_MNT | grep "Report\|^Block" | filter_repquota $def_time
> +echo
> +
> +# Remount and check the limits
> +echo "7. cycle mount test-3"
> +_qmount
> +repquota -ugP $SCRATCH_MNT | grep "Report\|^Block" | filter_repquota $def_time
> +
> +# success, all done
> +status=0
> +exit
> diff --git a/tests/generic/594.out b/tests/generic/594.out
> new file mode 100644
> index 00000000..f25e0fac
> --- /dev/null
> +++ b/tests/generic/594.out
> @@ -0,0 +1,50 @@
> +QA output created by 594
> +1. set project quota timer
> +*** Report for user quotas on device SCRATCH_DEV
> +Block grace time: DEF_TIME; Inode grace time: DEF_TIME
> +*** Report for group quotas on device SCRATCH_DEV
> +Block grace time: DEF_TIME; Inode grace time: DEF_TIME
> +*** Report for project quotas on device SCRATCH_DEV
> +Block grace time: 00:10; Inode grace time: 00:20
> +
> +2. set group quota timer
> +*** Report for user quotas on device SCRATCH_DEV
> +Block grace time: DEF_TIME; Inode grace time: DEF_TIME
> +*** Report for group quotas on device SCRATCH_DEV
> +Block grace time: 00:30; Inode grace time: 00:40
> +*** Report for project quotas on device SCRATCH_DEV
> +Block grace time: 00:10; Inode grace time: 00:20
> +
> +3. set user quota timer
> +*** Report for user quotas on device SCRATCH_DEV
> +Block grace time: 00:50; Inode grace time: 01:00
> +*** Report for group quotas on device SCRATCH_DEV
> +Block grace time: 00:30; Inode grace time: 00:40
> +*** Report for project quotas on device SCRATCH_DEV
> +Block grace time: 00:10; Inode grace time: 00:20
> +
> +4. cycle mount test-1
> +*** Report for user quotas on device SCRATCH_DEV
> +Block grace time: 00:50; Inode grace time: 01:00
> +*** Report for group quotas on device SCRATCH_DEV
> +Block grace time: 00:30; Inode grace time: 00:40
> +*** Report for project quotas on device SCRATCH_DEV
> +Block grace time: 00:10; Inode grace time: 00:20
> +
> +5. fsck to force quota check
> +
> +6. cycle mount test-2
> +*** Report for user quotas on device SCRATCH_DEV
> +Block grace time: 00:50; Inode grace time: 01:00
> +*** Report for group quotas on device SCRATCH_DEV
> +Block grace time: 00:30; Inode grace time: 00:40
> +*** Report for project quotas on device SCRATCH_DEV
> +Block grace time: 00:10; Inode grace time: 00:20
> +
> +7. cycle mount test-3
> +*** Report for user quotas on device SCRATCH_DEV
> +Block grace time: 00:50; Inode grace time: 01:00
> +*** Report for group quotas on device SCRATCH_DEV
> +Block grace time: 00:30; Inode grace time: 00:40
> +*** Report for project quotas on device SCRATCH_DEV
> +Block grace time: 00:10; Inode grace time: 00:20
> diff --git a/tests/generic/group b/tests/generic/group
> index dc95b77b..a83f95cb 100644
> --- a/tests/generic/group
> +++ b/tests/generic/group
> @@ -595,3 +595,4 @@
>  591 auto quick rw pipe splice
>  592 auto quick encrypt
>  593 auto quick encrypt
> +594 auto quick quota
> -- 
> 2.20.1
> 
