Return-Path: <SRS0=dkq6=2N=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24F46C2D0D3
	for <linux-xfs@archiver.kernel.org>; Mon, 23 Dec 2019 05:12:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EFF0C206D3
	for <linux-xfs@archiver.kernel.org>; Mon, 23 Dec 2019 05:12:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cqOvMvoa"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725822AbfLWFMi (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 23 Dec 2019 00:12:38 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:51020 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725283AbfLWFMi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 23 Dec 2019 00:12:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1577077957;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Tu+L/bX41eXdE9A7LS1wNU6m422wpVLpuU+ZKOq5hxo=;
        b=cqOvMvoaW53JrZfnB+VYvzdjpZn4z05JHLisSG3rLp3gnGRVCsEFzYyNrDKU75txDNcCnC
        N/yzmhy2guiaBO4BNILG9ZH68y1yEVzDOMgHAsWQldzTPWQ1UbGYqD6vhNg5UOEy32zjJr
        y/6W472Nv8o1W4pDaZ/IPyAmrl6hsCM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-409-tqn0yxCZNHWr2fsb-VOdng-1; Mon, 23 Dec 2019 00:12:32 -0500
X-MC-Unique: tqn0yxCZNHWr2fsb-VOdng-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AEE1A477;
        Mon, 23 Dec 2019 05:12:31 +0000 (UTC)
Received: from localhost (dhcp-12-102.nay.redhat.com [10.66.12.102])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2D39F67E4C;
        Mon, 23 Dec 2019 05:12:30 +0000 (UTC)
Date:   Mon, 23 Dec 2019 13:21:06 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     fstests <fstests@vger.kernel.org>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH V2] fstests: verify that xfs_growfs can operate on
 mounted device node
Message-ID: <20191223052106.GG14328@dhcp-12-102.nay.redhat.com>
Mail-Followup-To: fstests <fstests@vger.kernel.org>,
        linux-xfs <linux-xfs@vger.kernel.org>
References: <4cdefab7-02f0-7703-a3d2-8c2b3ce655b7@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4cdefab7-02f0-7703-a3d2-8c2b3ce655b7@sandeen.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Dec 17, 2019 at 04:34:07PM -0600, Eric Sandeen wrote:
> From: Eric Sandeen <sandeen@redhat.com>
> 
> The ability to use a mounted device node as the primary argument
> to xfs_growfs was added back in with:
>   7e8275f8 xfs_growfs: allow mounted device node as argument
> because it was an undocumented behavior that some userspace depended on.
> This test exercises that functionality.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---

Looks good to me, and this case fails on old xfsprogs as expected, and test
passed after merge "7e8275f8 xfs_growfs: allow mounted device node as argument".

Reviewed-by: Zorro Lang <zlang@redhat.com>

> 
> V2: Address Eryu's review concerns
> 
> diff --git a/tests/xfs/999 b/tests/xfs/999
> new file mode 100755
> index 00000000..186a29eb
> --- /dev/null
> +++ b/tests/xfs/999
> @@ -0,0 +1,101 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2019 Red Hat, Inc.  All Rights Reserved.
> +#
> +# FS QA Test 999
> +#
> +# Test to ensure xfs_growfs command accepts device nodes if & only
> +# if they are mounted.
> +# This functionality, though undocumented, worked until xfsprogs v4.12
> +# It was added back and documented after xfsprogs v5.2 via
> +#   7e8275f8 xfs_growfs: allow mounted device node as argument
> +#
> +# Based on xfs/289
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
> +loopfile=$TEST_DIR/fsfile
> +mntdir=$TEST_DIR/mntdir
> +loop_symlink=$TEST_DIR/loop_symlink.$$
> +
> +_cleanup()
> +{
> +    $UMOUNT_PROG $mntdir
> +    [ -n "$loop_dev" ] && _destroy_loop_device $loop_dev
> +    rmdir $mntdir
> +    rm -f $loop_symlink
> +    rm -f $loopfile
> +}
> +
> +# get standard environment, filters and checks
> +. ./common/rc
> +. ./common/filter
> +
> +# remove previous $seqres.full before test
> +rm -f $seqres.full
> +
> +# real QA test starts here
> +
> +# Modify as appropriate.
> +_supported_fs xfs
> +_supported_os Linux
> +_require_test
> +_require_loop
> +
> +mkdir -p $mntdir || _fail "!!! failed to create temp mount dir"
> +
> +echo "=== mkfs.xfs ==="
> +$MKFS_XFS_PROG -d file,name=$loopfile,size=16m -f >/dev/null 2>&1
> +
> +echo "=== truncate ==="
> +$XFS_IO_PROG -fc "truncate 256m" $loopfile
> +
> +echo "=== create loop device ==="
> +loop_dev=$(_create_loop_device $loopfile)
> +
> +echo "=== create loop device symlink ==="
> +ln -s $loop_dev $loop_symlink
> +
> +echo "loop device is $loop_dev" >> $seqres.full
> +
> +# These unmounted operations should fail
> +
> +echo "=== xfs_growfs - unmounted device, command should be rejected ==="
> +$XFS_GROWFS_PROG $loop_dev 2>&1 | sed -e s:$loop_dev:LOOPDEV:
> +
> +echo "=== xfs_growfs - check symlinked dev, unmounted ==="
> +$XFS_GROWFS_PROG $loop_symlink 2>&1 | sed -e s:$loop_symlink:LOOPSYMLINK:
> +
> +# These mounted operations should pass
> +
> +echo "=== mount ==="
> +$MOUNT_PROG $loop_dev $mntdir || _fail "!!! failed to loopback mount"
> +
> +echo "=== xfs_growfs - check device node ==="
> +$XFS_GROWFS_PROG -D 8192 $loop_dev > /dev/null
> +
> +echo "=== xfs_growfs - check device symlink ==="
> +$XFS_GROWFS_PROG -D 12288 $loop_symlink > /dev/null
> +
> +echo "=== unmount ==="
> +$UMOUNT_PROG $mntdir || _fail "!!! failed to unmount"
> +
> +echo "=== mount device symlink ==="
> +$MOUNT_PROG $loop_symlink $mntdir || _fail "!!! failed to loopback mount"
> +
> +echo "=== xfs_growfs - check device symlink ==="
> +$XFS_GROWFS_PROG -D 16384 $loop_symlink > /dev/null
> +
> +echo "=== xfs_growfs - check device node ==="
> +$XFS_GROWFS_PROG -D 20480 $loop_dev > /dev/null
> +
> +# success, all done
> +status=0
> +exit
> diff --git a/tests/xfs/999.out b/tests/xfs/999.out
> new file mode 100644
> index 00000000..ababb892
> --- /dev/null
> +++ b/tests/xfs/999.out
> @@ -0,0 +1,16 @@
> +QA output created by 999
> +=== mkfs.xfs ===
> +=== truncate ===
> +=== create loop device ===
> +=== create loop device symlink ===
> +=== xfs_growfs - unmounted device, command should be rejected ===
> +xfs_growfs: LOOPDEV is not a mounted XFS filesystem
> +=== xfs_growfs - check symlinked dev, unmounted ===
> +xfs_growfs: LOOPSYMLINK is not a mounted XFS filesystem
> +=== mount ===
> +=== xfs_growfs - check device node ===
> +=== xfs_growfs - check device symlink ===
> +=== unmount ===
> +=== mount device symlink ===
> +=== xfs_growfs - check device symlink ===
> +=== xfs_growfs - check device node ===
> diff --git a/tests/xfs/group b/tests/xfs/group
> index 4373d082..ff251002 100644
> --- a/tests/xfs/group
> +++ b/tests/xfs/group
> @@ -508,3 +508,4 @@
>  509 auto ioctl
>  510 auto ioctl quick
>  511 auto quick quota
> +999 quick auto growfs
> 

