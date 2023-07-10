Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6119DEB64DA
	for <linux-xfs@archiver.kernel.org>; Mon, 10 Jul 2023 20:04:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229756AbjGJUE6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 10 Jul 2023 16:04:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232012AbjGJUEq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 10 Jul 2023 16:04:46 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95E92194
        for <linux-xfs@vger.kernel.org>; Mon, 10 Jul 2023 13:04:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1689019441;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=IC0MePOZgy+fQFBbiywuG6toGimb9yzobwL6waCGFFY=;
        b=eDPrr4c59QpUYq6qHV6mqzzXkKCZvGxnsEcOiWTyEce5cES2gb1+BmshIliNK6ZLW7qdEe
        J5sHNqhhYnf3EwIxnEef6QNy28HO8xLuJHT9dCRhVnWzCeoE8muIo+9yUvxwXxp6lGtE2+
        iTtjrlollsa1HcD7zN75y00TtZNZEYw=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-326-lzDe3IIJPni7rCluiubX9w-1; Mon, 10 Jul 2023 16:03:59 -0400
X-MC-Unique: lzDe3IIJPni7rCluiubX9w-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 49DF31044589;
        Mon, 10 Jul 2023 20:03:59 +0000 (UTC)
Received: from redhat.com (unknown [10.22.16.18])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 15FA0F66A4;
        Mon, 10 Jul 2023 20:03:59 +0000 (UTC)
Date:   Mon, 10 Jul 2023 15:03:57 -0500
From:   Bill O'Donnell <billodo@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] misc: remove bogus fstest
Message-ID: <ZKxkLUSFTVNokP4+@redhat.com>
References: <20230709223750.GC11456@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230709223750.GC11456@frogsfrogsfrogs>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Jul 09, 2023 at 03:37:50PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Remove this test, not sure why it was committed...
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>

Reviewed-by: Bill O'Donnell <bodonnel@redhat.com>


> ---
>  tests/xfs/999     |   66 -----------------------------------------------------
>  tests/xfs/999.out |   15 ------------
>  2 files changed, 81 deletions(-)
>  delete mode 100755 tests/xfs/999
>  delete mode 100644 tests/xfs/999.out
> 
> diff --git a/tests/xfs/999 b/tests/xfs/999
> deleted file mode 100755
> index 9e799f66e72..00000000000
> --- a/tests/xfs/999
> +++ /dev/null
> @@ -1,66 +0,0 @@
> -#! /bin/bash
> -# SPDX-License-Identifier: GPL-2.0
> -# Copyright (c) 2020 Red Hat, Inc.  All Rights Reserved.
> -#
> -# FS QA Test 521
> -#
> -# Test xfs_repair's progress reporting
> -#
> -. ./common/preamble
> -_begin_fstest auto repair
> -
> -# Override the default cleanup function.
> -_cleanup()
> -{
> -	cd /
> -	rm -f $tmp.*
> -	_cleanup_delay > /dev/null 2>&1
> -}
> -
> -# Import common functions.
> -. ./common/filter
> -. ./common/dmdelay
> -. ./common/populate
> -
> -# real QA test starts here
> -
> -# Modify as appropriate.
> -_supported_fs xfs
> -_require_scratch
> -_require_dm_target delay
> -
> -# Filter output specific to the formatters in xfs_repair/progress.c
> -# Ideally we'd like to see hits on anything that matches
> -# awk '/{FMT/' xfsprogs-dev/repair/progress.c
> -filter_repair()
> -{
> -	sed -nre '
> -	s/[0-9]+/#/g;
> -	s/^\s+/ /g;
> -	s/(# (week|day|hour|minute|second)s?(, )?)+/{progres}/g;
> -	/#:#:#:/p
> -	'
> -}
> -
> -echo "Format and populate"
> -_scratch_populate_cached nofill > $seqres.full 2>&1
> -
> -echo "Introduce a dmdelay"
> -_init_delay
> -DELAY_MS=38
> -
> -# Introduce a read I/O delay
> -# The default in common/dmdelay is a bit too agressive
> -BLK_DEV_SIZE=`blockdev --getsz $SCRATCH_DEV`
> -DELAY_TABLE_RDELAY="0 $BLK_DEV_SIZE delay $SCRATCH_DEV 0 $DELAY_MS"
> -_load_delay_table $DELAY_READ
> -
> -echo "Run repair"
> -SCRATCH_DEV=$DELAY_DEV _scratch_xfs_repair -o ag_stride=4 -t 1 2>&1 |
> -        tee -a $seqres.full > $tmp.repair
> -
> -cat $tmp.repair | filter_repair | sort -u
> -
> -# success, all done
> -status=0
> -exit
> diff --git a/tests/xfs/999.out b/tests/xfs/999.out
> deleted file mode 100644
> index e27534d8de6..00000000000
> --- a/tests/xfs/999.out
> +++ /dev/null
> @@ -1,15 +0,0 @@
> -QA output created by 999
> -Format and populate
> -Introduce a dmdelay
> -Run repair
> - - #:#:#: Phase #: #% done - estimated remaining time {progres}
> - - #:#:#: Phase #: elapsed time {progres} - processed # inodes per minute
> - - #:#:#: check for inodes claiming duplicate blocks - # of # inodes done
> - - #:#:#: process known inodes and inode discovery - # of # inodes done
> - - #:#:#: process newly discovered inodes - # of # allocation groups done
> - - #:#:#: rebuild AG headers and trees - # of # allocation groups done
> - - #:#:#: scanning agi unlinked lists - # of # allocation groups done
> - - #:#:#: scanning filesystem freespace - # of # allocation groups done
> - - #:#:#: setting up duplicate extent list - # of # allocation groups done
> - - #:#:#: verify and correct link counts - # of # allocation groups done
> - - #:#:#: zeroing log - # of # blocks done
> 

