Return-Path: <SRS0=P3J0=4X=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9CA5AC10F26
	for <linux-xfs@archiver.kernel.org>; Fri,  6 Mar 2020 09:56:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6CA792072A
	for <linux-xfs@archiver.kernel.org>; Fri,  6 Mar 2020 09:56:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HnLtAqwQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726069AbgCFJ4L (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 6 Mar 2020 04:56:11 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:37397 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726047AbgCFJ4L (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 6 Mar 2020 04:56:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583488569;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ZbwJhAgLRUc8GSXAQPoaGP8wZJ0MIWju61QfaOGnqOU=;
        b=HnLtAqwQpxRETSGfIO/shsSlGlSia1o2MYrwjxIxeUNOBF5LH7dR0+uk2zt4KxJGVRZP8I
        anB/FdEuajMhcG3juWLRcnukHdmDr06Fi040mTpOpNSi0jLca+s00644KKKztKbvw5uHDu
        Oe60te3AwIJ8JNJXJxE/NPhpMmW/jqI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-184-V7ME8WPiPTiz_L_mijZEsA-1; Fri, 06 Mar 2020 04:56:07 -0500
X-MC-Unique: V7ME8WPiPTiz_L_mijZEsA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F028E18C8C00;
        Fri,  6 Mar 2020 09:56:06 +0000 (UTC)
Received: from localhost (dhcp-12-102.nay.redhat.com [10.66.12.102])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6BBFB5C54A;
        Fri,  6 Mar 2020 09:56:06 +0000 (UTC)
Date:   Fri, 6 Mar 2020 18:06:55 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     fstests@vger.kernel.org
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/3] xfs: make sure xfs_db/xfs_quota commands are
 documented
Message-ID: <20200306100655.GZ14282@dhcp-12-102.nay.redhat.com>
Mail-Followup-To: fstests@vger.kernel.org, linux-xfs@vger.kernel.org
References: <158328998787.2374922.4223951558305234252.stgit@magnolia>
 <158329000698.2374922.9344618703224232004.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <158329000698.2374922.9344618703224232004.stgit@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Mar 03, 2020 at 06:46:47PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Make sure all the xfs_db/xfs_quota commands are documented.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---

The test cases make sense, and looks good to me, although it fails
on most of xfsprogs versions currently. I think someone is fixing
these missed docs, right :)

One thing I noticed that:
  $CAT "$MANPAGE" | egrep -q "^\.B.*$COMMAND"

The "^\.B.*$COMMAND" can match ".B report", but can't match something
likes:
"
.B
limit
"

If we don't recommend this format, we'd be better to change and avoid it in
manual pages.

Reviewd-by: Zorro Lang <zlang@redhat.com>

Thanks,
Zorro

>  tests/xfs/754     |   57 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/754.out |    2 ++
>  tests/xfs/755     |   53 +++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/755.out |    2 ++
>  tests/xfs/group   |    2 ++
>  5 files changed, 116 insertions(+)
>  create mode 100755 tests/xfs/754
>  create mode 100644 tests/xfs/754.out
>  create mode 100755 tests/xfs/755
>  create mode 100644 tests/xfs/755.out
> 
> 
> diff --git a/tests/xfs/754 b/tests/xfs/754
> new file mode 100755
> index 00000000..ba0885be
> --- /dev/null
> +++ b/tests/xfs/754
> @@ -0,0 +1,57 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0-or-newer
> +# Copyright (c) 2020, Oracle and/or its affiliates.  All Rights Reserved.
> +#
> +# FS QA Test No. 754
> +#
> +# Ensure all xfs_db commands are documented.
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
> +	rm -f $tmp.* $file
> +}
> +
> +# get standard environment, filters and checks
> +. ./common/rc
> +
> +# real QA test starts here
> +_supported_fs xfs
> +_supported_os Linux
> +_require_command "$XFS_DB_PROG" "xfs_db"
> +_require_command "$MAN_PROG" man
> +_require_test
> +
> +echo "Silence is golden"
> +
> +MANPAGE=$($MAN_PROG --path xfs_db)
> +
> +case "$MANPAGE" in
> +*.gz|*.z\|*.Z)	CAT=zcat;;
> +*.bz2)		CAT=bzcat;;
> +*.xz)		CAT=xzcat;;
> +*)		CAT=cat;;
> +esac
> +_require_command `which $CAT` $CAT
> +
> +file=$TEST_DIR/xx.$seq
> +truncate -s 128m $file
> +$MKFS_XFS_PROG $file >> /dev/null
> +
> +for COMMAND in `$XFS_DB_PROG -x -c help $file | awk '{print $1}' | grep -v "^Use"`; do
> +  $CAT "$MANPAGE" | egrep -q "^\.B.*$COMMAND" || \
> +	echo "$COMMAND not documented in the xfs_db manpage"
> +done
> +
> +# success, all done
> +status=0
> +exit
> diff --git a/tests/xfs/754.out b/tests/xfs/754.out
> new file mode 100644
> index 00000000..9e7cda82
> --- /dev/null
> +++ b/tests/xfs/754.out
> @@ -0,0 +1,2 @@
> +QA output created by 754
> +Silence is golden
> diff --git a/tests/xfs/755 b/tests/xfs/755
> new file mode 100755
> index 00000000..0e5d85ab
> --- /dev/null
> +++ b/tests/xfs/755
> @@ -0,0 +1,53 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0-or-newer
> +# Copyright (c) 2020, Oracle and/or its affiliates.  All Rights Reserved.
> +#
> +# FS QA Test No. 755
> +#
> +# Ensure all xfs_quota commands are documented.
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
> +	rm -f $tmp.* $file
> +}
> +
> +# get standard environment, filters and checks
> +. ./common/rc
> +
> +# real QA test starts here
> +_supported_fs xfs
> +_supported_os Linux
> +_require_command "$XFS_QUOTA_PROG" "xfs_quota"
> +_require_command "$MAN_PROG" man
> +_require_test
> +
> +echo "Silence is golden"
> +
> +MANPAGE=$($MAN_PROG --path xfs_quota)
> +
> +case "$MANPAGE" in
> +*.gz|*.z\|*.Z)	CAT=zcat;;
> +*.bz2)		CAT=bzcat;;
> +*.xz)		CAT=xzcat;;
> +*)		CAT=cat;;
> +esac
> +_require_command `which $CAT` $CAT
> +
> +for COMMAND in `$XFS_QUOTA_PROG -x -c help $file | awk '{print $1}' | grep -v "^Use"`; do
> +  $CAT "$MANPAGE" | egrep -q "^\.B.*$COMMAND" || \
> +	echo "$COMMAND not documented in the xfs_quota manpage"
> +done
> +
> +# success, all done
> +status=0
> +exit
> diff --git a/tests/xfs/755.out b/tests/xfs/755.out
> new file mode 100644
> index 00000000..7c9ea51c
> --- /dev/null
> +++ b/tests/xfs/755.out
> @@ -0,0 +1,2 @@
> +QA output created by 755
> +Silence is golden
> diff --git a/tests/xfs/group b/tests/xfs/group
> index 522d4bc4..aadbb971 100644
> --- a/tests/xfs/group
> +++ b/tests/xfs/group
> @@ -511,3 +511,5 @@
>  511 auto quick quota
>  512 auto quick acl attr
>  513 auto mount
> +754 auto quick db
> +755 auto quick quota
> 

