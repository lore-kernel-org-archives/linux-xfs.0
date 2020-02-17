Return-Path: <SRS0=xOwi=4F=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2CF4EC34022
	for <linux-xfs@archiver.kernel.org>; Mon, 17 Feb 2020 18:06:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0A8C1207FD
	for <linux-xfs@archiver.kernel.org>; Mon, 17 Feb 2020 18:06:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="byMOABP8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728605AbgBQSG1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 17 Feb 2020 13:06:27 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:35033 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726707AbgBQSG1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 17 Feb 2020 13:06:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581962785;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=+RM+DH0ErVj/CBf+LH+Vn1Q/4RW34TjpSYC3jJHH6uc=;
        b=byMOABP8ow474/e7vwR7Ituf+Kq4wgHExe+YIM6eW9CXlApYDeZINUUwgYrI2yaGA+pIkY
        u+R/xZgB3D5I4aBH23DqoXDxdTNhL4DAAJrzdnxGc9eMoQ5uPfYVCGDt5Wl6TjG94zkSaM
        BKCBmbp//VhgxzSKnJTFE4qXvFEkvUE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-89-a92lH5D_OISSINlMMe8Dxg-1; Mon, 17 Feb 2020 13:06:21 -0500
X-MC-Unique: a92lH5D_OISSINlMMe8Dxg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1CFBD1083E80;
        Mon, 17 Feb 2020 18:06:20 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 895DB8579D;
        Mon, 17 Feb 2020 18:06:19 +0000 (UTC)
Date:   Mon, 17 Feb 2020 13:06:17 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     guaneryu@gmail.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs: test setting labels with xfs_admin
Message-ID: <20200217180617.GD6633@bfoster>
References: <157915149017.2375135.14166864164575311878.stgit@magnolia>
 <157915150275.2375135.12157351351400702116.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <157915150275.2375135.12157351351400702116.stgit@magnolia>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jan 15, 2020 at 09:11:42PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Test setting filesystem labels with xfs_admin.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  tests/xfs/912     |  103 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/912.out |   43 ++++++++++++++++++++++
>  tests/xfs/group   |    1 +
>  3 files changed, 147 insertions(+)
>  create mode 100755 tests/xfs/912
>  create mode 100644 tests/xfs/912.out
> 
> 
> diff --git a/tests/xfs/912 b/tests/xfs/912
> new file mode 100755
> index 00000000..1eef36cd
> --- /dev/null
> +++ b/tests/xfs/912
> @@ -0,0 +1,103 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0-or-later
> +# Copyright (c) 2020, Oracle and/or its affiliates.  All Rights Reserved.
> +#
> +# FS QA Test No. 912
> +#
> +# Check that xfs_admin can set and clear filesystem labels offline and online.
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
> +}
> +
> +# get standard environment, filters and checks
> +. ./common/rc
> +
> +# real QA test starts here
> +_supported_fs xfs
> +_supported_os Linux
> +_require_scratch
> +_require_xfs_db_command label
> +_require_xfs_io_command label
> +grep -q "xfs_io" "$(which xfs_admin)" || \
> +	_notrun "xfs_admin does not support online label setting of any kind"

So we assume xfs_admin functionality by looking at the script..? This
seems like it should have its own _require_* helper or some such with a
more explicit implementation. (This also ignores the XFS_ADMIN_PROG env
var added by the previous patch as well, fwiw).

> +
> +rm -f $seqres.full
> +
> +echo
> +echo "Format with label"
> +_scratch_mkfs -L "label0" > $seqres.full
> +
> +echo "Read label offline"
> +_scratch_xfs_admin -l
> +
> +echo "Read label online"
> +_scratch_mount
> +_scratch_xfs_admin -l
> +
> +echo
> +echo "Set label offline"
> +_scratch_unmount
> +_scratch_xfs_admin -L "label1"
> +
> +echo "Read label offline"
> +_scratch_xfs_admin -l
> +
> +echo "Read label online"
> +_scratch_mount
> +_scratch_xfs_admin -l
...
> +echo
> +echo "Set label offline"
> +_scratch_xfs_admin -L "label3"
> +
> +echo "Read label offline"
> +_scratch_xfs_admin -l
> +

Any reason for the duplicate "set label offline" test? Otherwise LGTM.

Brian

> +echo
> +echo "Clear label offline"
> +_scratch_xfs_admin -L "--"
> +
> +echo "Read label offline"
> +_scratch_xfs_admin -l
> +
> +echo "Read label online"
> +_scratch_mount
> +_scratch_xfs_admin -l
> +
> +# success, all done
> +status=0
> +exit
> diff --git a/tests/xfs/912.out b/tests/xfs/912.out
> new file mode 100644
> index 00000000..186d827f
> --- /dev/null
> +++ b/tests/xfs/912.out
> @@ -0,0 +1,43 @@
> +QA output created by 912
> +
> +Format with label
> +Read label offline
> +label = "label0"
> +Read label online
> +label = "label0"
> +
> +Set label offline
> +writing all SBs
> +new label = "label1"
> +Read label offline
> +label = "label1"
> +Read label online
> +label = "label1"
> +
> +Set label online
> +label = "label2"
> +Read label online
> +label = "label2"
> +Read label offline
> +label = "label2"
> +
> +Clear label online
> +label = ""
> +Read label online
> +label = ""
> +Read label offline
> +label = ""
> +
> +Set label offline
> +writing all SBs
> +new label = "label3"
> +Read label offline
> +label = "label3"
> +
> +Clear label offline
> +writing all SBs
> +new label = ""
> +Read label offline
> +label = ""
> +Read label online
> +label = ""
> diff --git a/tests/xfs/group b/tests/xfs/group
> index a6c9ef08..cc1d122a 100644
> --- a/tests/xfs/group
> +++ b/tests/xfs/group
> @@ -511,3 +511,4 @@
>  511 auto quick quota
>  747 auto quick scrub
>  748 auto quick scrub
> +912 auto quick label
> 

