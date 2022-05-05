Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D750C433FE
	for <linux-xfs@archiver.kernel.org>; Thu,  5 May 2022 18:46:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383915AbiEESuB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 5 May 2022 14:50:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1384872AbiEEStf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 5 May 2022 14:49:35 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2B625F25F;
        Thu,  5 May 2022 11:43:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 94B45B82C69;
        Thu,  5 May 2022 18:43:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C75AC385A8;
        Thu,  5 May 2022 18:43:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651776225;
        bh=6W1eXQOdlVJV8X0yFS+MoQWFAi5AHCOkA0HvXnqAKuY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=unL1ExwTqgEZ8XG9TpUNxmZiXrl/ElIi1XSrIqVTA4sXFav4Nld6Zx7nlVAiYSOAx
         v49lUbB9s7z2nGI/ub6e2uUrqseUI3OZSHGthU7aDqyhSi8Zl0o+InHvXPhwk8Ah//
         HVxV/A8AQel07XtoJtwXJ8fyoK0zqI5Y9URzJHgyleeI0X8Ya++TJHvRKlrDjJZkXC
         8cpn7QY0CsP7Jsi9xOgS9zHhLEeyTb+9JaJgiwmd5WIDDcn0ZZtMlFGPhYJU8NZDI+
         pG1YOOGWCpqSonow87SK8fUkSh/Oc1ESTKzenMRGAfX+LYUj7uA1Ejxii8umNbmZqW
         Q3OCrNdSCgmpg==
Date:   Thu, 5 May 2022 11:43:44 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Zorro Lang <zlang@kernel.org>
Cc:     fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] generic: soft quota limits testing within grace time
Message-ID: <20220505184344.GL27195@magnolia>
References: <20220505182555.370074-1-zlang@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220505182555.370074-1-zlang@kernel.org>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, May 06, 2022 at 02:25:55AM +0800, Zorro Lang wrote:
> After soft limits are exceeded, within the grace time, fs quota should
> allow more space allocation before exceeding hard limits, even if
> allocating many small files.
> 
> This case can cover bc37e4fb5cac (xfs: revert "xfs: actually bump
> warning counts when we send warnings"). And will help to expose later
> behavior changes on this side.

Isn't this already covered by generic/230?

--D

> Signed-off-by: Zorro Lang <zlang@redhat.com>
> ---
>  tests/generic/690     | 125 ++++++++++++++++++++++++++++++++++++++++++
>  tests/generic/690.out |   2 +
>  2 files changed, 127 insertions(+)
>  create mode 100755 tests/generic/690
>  create mode 100644 tests/generic/690.out
> 
> diff --git a/tests/generic/690 b/tests/generic/690
> new file mode 100755
> index 00000000..b1d055dc
> --- /dev/null
> +++ b/tests/generic/690
> @@ -0,0 +1,125 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2022 Red Hat Inc.  All Rights Reserved.
> +#
> +# FS QA Test 690
> +#
> +# Make sure filesystem quota works well, after soft limits are exceeded. The
> +# fs quota should allow more space allocation before exceeding hard limits
> +# and with in grace time.
> +#
> +# But different with other similar testing, this case trys to write many small
> +# files, to cover bc37e4fb5cac (xfs: revert "xfs: actually bump warning counts
> +# when we send warnings"). If there's a behavior change in one day, this case
> +# might help to detect that too.
> +#
> +. ./common/preamble
> +_begin_fstest auto quota
> +
> +# Override the default cleanup function.
> +_cleanup()
> +{
> +	restore_project
> +	cd /
> +	rm -r -f $tmp.*
> +}
> +
> +# Import common functions.
> +. ./common/quota
> +
> +# real QA test starts here
> +_supported_fs generic
> +_require_scratch
> +_require_quota
> +_require_user
> +_require_group
> +
> +create_project()
> +{
> +	rm -rf $SCRATCH_MNT/t
> +	mkdir $SCRATCH_MNT/t
> +	$XFS_IO_PROG -r -c "chproj 100" -c "chattr +P" $SCRATCH_MNT/t
> +	chmod ugo+rwx $SCRATCH_MNT/t/
> +
> +	rm -f $tmp.projects $tmp.projid
> +	if [ -f /etc/projects ];then
> +		cat /etc/projects > $tmp.projects
> +	fi
> +	if [ -f /etc/projid ];then
> +		cat /etc/projid > $tmp.projid
> +	fi
> +
> +	cat >/etc/projects <<EOF
> +100:$SCRATCH_MNT/t
> +EOF
> +	cat >/etc/projid <<EOF
> +$qa_user:100
> +EOF
> +	PROJECT_CHANGED=1
> +}
> +
> +restore_project()
> +{
> +	if [ "$PROJECT_CHANGED" = "1" ];then
> +		rm -f /etc/projects /etc/projid
> +		if [ -f $tmp.projects ];then
> +			cat $tmp.projects > /etc/projects
> +		fi
> +		if [ -f $tmp.projid ];then
> +			cat $tmp.projid > /etc/projid
> +		fi
> +	fi
> +}
> +
> +# Make sure the kernel supports project quota
> +_scratch_mkfs >$seqres.full 2>&1
> +_scratch_enable_pquota
> +_qmount_option "prjquota"
> +_qmount
> +_require_prjquota $SCRATCH_DEV
> +
> +exercise()
> +{
> +	local type=$1
> +	local file=$SCRATCH_MNT/testfile
> +
> +	echo "= Test type=$type quota =" >>$seqres.full
> +	_scratch_unmount
> +	_scratch_mkfs >>$seqres.full 2>&1
> +	if [ "$1" = "P" ];then
> +		_scratch_enable_pquota
> +	fi
> +	_qmount
> +	if [ "$1" = "P" ];then
> +		create_project
> +		file=$SCRATCH_MNT/t/testfile
> +	fi
> +
> +	setquota -${type} $qa_user 1M 500M 0 0 $SCRATCH_MNT
> +	setquota -${type} -t 86400 86400 $SCRATCH_MNT
> +	repquota -v -${type} $SCRATCH_MNT | grep -v "^root" >>$seqres.full 2>&1
> +	# Exceed the soft quota limit a bit at first
> +	su $qa_user -c "$XFS_IO_PROG -f -t -c 'pwrite 0 2m' -c fsync ${file}.0" >>$seqres.full 2>&1
> +	# Write more data more times under soft quota limit exhausted condition,
> +	# but not reach hard limit. To make sure the it won't trigger EDQUOT.
> +	for ((i=1; i<=100; i++));do
> +		su "$qa_user" -c "$XFS_IO_PROG -f -c 'pwrite 0 1m' -c fsync ${file}.$i" >>$seqres.full 2>&1
> +		if [ $? -ne 0 ];then
> +			log "Unexpected error (type=$type)!"
> +			break
> +		fi
> +	done
> +	repquota -v -${type} $SCRATCH_MNT | grep -v "^root" >>$seqres.full 2>&1
> +}
> +
> +_qmount_option "usrquota"
> +exercise u
> +_qmount_option "grpquota"
> +exercise g
> +_qmount_option "prjquota"
> +exercise P
> +
> +echo "Silence is golden"
> +# success, all done
> +status=0
> +exit
> diff --git a/tests/generic/690.out b/tests/generic/690.out
> new file mode 100644
> index 00000000..6f3723e3
> --- /dev/null
> +++ b/tests/generic/690.out
> @@ -0,0 +1,2 @@
> +QA output created by 690
> +Silence is golden
> -- 
> 2.31.1
> 
