Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00F24C433EF
	for <linux-xfs@archiver.kernel.org>; Thu,  2 Jun 2022 19:06:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231178AbiFBTGs (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 2 Jun 2022 15:06:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238376AbiFBTGq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 2 Jun 2022 15:06:46 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 64F0CC33
        for <linux-xfs@vger.kernel.org>; Thu,  2 Jun 2022 12:06:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654196803;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=M9YRGWZLi2R8jGZbgQgcbzRk8YJ/VNSrK66lF7ah65o=;
        b=dr3QiQ7w+hH5dLRBR4B/X0v7dmrSEiunT1+JSkYHORM6RgE96NfOUp7CjygvWyZlWQ6XTg
        ccb2L5qXF8JiSeZBs6HtOrCuMMD+Oj9isHrn7/6+4CXbr/UA34FDn1hrVCgtbiu+Yx9+oP
        FiN9Ac1e43rl7XR+rOIdVs9xfsqYef0=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-314-y6MYibtEOSKoJiH0oSRKuQ-1; Thu, 02 Jun 2022 15:06:41 -0400
X-MC-Unique: y6MYibtEOSKoJiH0oSRKuQ-1
Received: by mail-qv1-f70.google.com with SMTP id da12-20020a05621408cc00b0046448be0e98so3980425qvb.9
        for <linux-xfs@vger.kernel.org>; Thu, 02 Jun 2022 12:06:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=M9YRGWZLi2R8jGZbgQgcbzRk8YJ/VNSrK66lF7ah65o=;
        b=FTKHr8O8AVppntGvu9tt93Go4fMm7DsHLHChspv9ESqKPx0uBcCMiS61nHEDZlOyxB
         StxNiUl5dWND7M0N1rLLM7IyUeIwsnzYtT/hsIuIYG6EDcTxbMdKQlR6kru6LY7uBPWp
         mbT52EdESPQJH8XVq/79gxG+VV/8OXQJ7k8fAEipoYVI7+jNT41TJlwQBXw8iIj2GMz0
         Sjfd+9zKuhZNwiI7pD068eOLw9YOhQD5TGyg9Xbu4/fn6qZFuqCfYe1zbvdv44R59qus
         OLIwaUKnUr6azLWCcfjahRNb8B2dAzp7iZJ4sYXaXmhjXNG/ikafxqdPvYWyqfGcEdv8
         6ZYg==
X-Gm-Message-State: AOAM530A7KBwyhWR0F30n2MA/th1l/IRFjrEJC1Z7dar/DQDe/sKu3gC
        +RGKUwuDxzCGB2Qx6qaDPqdOkvph6nbJSOto83AMR9HTX7eoOGrj9yi1Ktfhtcz8uWLOI2DA5+O
        sptwkvZwiyzAbiMdOclGF
X-Received: by 2002:ac8:5b51:0:b0:2f9:46b0:ffa3 with SMTP id n17-20020ac85b51000000b002f946b0ffa3mr4886833qtw.116.1654196801369;
        Thu, 02 Jun 2022 12:06:41 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzAAX4wh4aOaTz9xaDHUnmw8KAGW/yEv7I4E6/s3E83kDgYumAruU8vJOhaiR98Z1XPTSTz1g==
X-Received: by 2002:ac8:5b51:0:b0:2f9:46b0:ffa3 with SMTP id n17-20020ac85b51000000b002f946b0ffa3mr4886807qtw.116.1654196801032;
        Thu, 02 Jun 2022 12:06:41 -0700 (PDT)
Received: from zlang-mailbox ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id 84-20020a370b57000000b006a64e82fb36sm3670715qkl.113.2022.06.02.12.06.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Jun 2022 12:06:40 -0700 (PDT)
Date:   Fri, 3 Jun 2022 03:06:35 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: corrupted xattr should not block removexattr
Message-ID: <20220602190635.yvxqu6ubquragt7x@zlang-mailbox>
References: <20220528094715.309876-1-zlang@kernel.org>
 <Ypjm1WbL/Mu7hBUQ@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Ypjm1WbL/Mu7hBUQ@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jun 02, 2022 at 09:35:33AM -0700, Darrick J. Wong wrote:
> On Sat, May 28, 2022 at 05:47:15PM +0800, Zorro Lang wrote:
> > After we corrupted an attr leaf block (under node block), getxattr
> > might hit EFSCORRUPTED in xfs_attr_node_get when it does
> > xfs_attr_node_hasname. A known bug cause xfs_attr_node_get won't do
> > xfs_buf_trans release job, then a subsequent removexattr will hang.
> > 
> > This case covers a1de97fe296c ("xfs: Fix the free logic of state in
> > xfs_attr_node_hasname")
> > 
> > Signed-off-by: Zorro Lang <zlang@kernel.org>
> > ---
> > 
> > Hi,
> > 
> > It's been long time past, since Yang Xu tried to cover a regression bug
> > by changing xfs/126 (be Nacked):
> > https://lore.kernel.org/fstests/1642407736-3898-1-git-send-email-xuyang2018.jy@fujitsu.com/
> > 
> > As we (Red Hat) need to cover this regression issue too, and have waited so
> > long time. I think no one is doing this job now, so I'm trying to write a new one
> > case to cover it. If Yang has completed his test case but forgot to send out,
> > feel free to tell me :)
> > 
> > Thanks,
> > Zorro
> > 
> >  tests/xfs/999     | 80 +++++++++++++++++++++++++++++++++++++++++++++++
> >  tests/xfs/999.out |  2 ++
> >  2 files changed, 82 insertions(+)
> >  create mode 100755 tests/xfs/999
> >  create mode 100644 tests/xfs/999.out
> > 
> > diff --git a/tests/xfs/999 b/tests/xfs/999
> > new file mode 100755
> > index 00000000..65d99883
> > --- /dev/null
> > +++ b/tests/xfs/999
> > @@ -0,0 +1,80 @@
> > +#! /bin/bash
> > +# SPDX-License-Identifier: GPL-2.0
> > +# Copyright (c) 2022 Red Hat, Inc.  All Rights Reserved.
> > +#
> > +# FS QA Test No. 999
> > +#
> > +# This's a regression test for:
> > +#   a1de97fe296c ("xfs: Fix the free logic of state in xfs_attr_node_hasname")
> > +#
> > +# After we corrupted an attr leaf block (under node block), getxattr might hit
> > +# EFSCORRUPTED in xfs_attr_node_get when it does xfs_attr_node_hasname. A bug
> > +# cause xfs_attr_node_get won't do xfs_buf_trans release job, then a subsequent
> > +# removexattr will hang.
> > +#
> > +. ./common/preamble
> > +_begin_fstest auto quick attr
> > +
> > +# Import common functions.
> > +. ./common/filter
> > +. ./common/attr
> > +. ./common/populate
> > +
> > +# real QA test starts here
> > +_supported_fs xfs
> > +_fixed_by_kernel_commit a1de97fe296c \
> > +       "xfs: Fix the free logic of state in xfs_attr_node_hasname"
> > +
> > +_require_scratch_nocheck
> > +# Only test with v5 xfs on-disk format
> > +_require_scratch_xfs_crc
> > +_require_attrs
> > +_require_populate_commands
> > +_require_xfs_db_blocktrash_z_command
> > +
> > +_scratch_mkfs_xfs | _filter_mkfs >$seqres.full 2>$tmp.mkfs
> > +source $tmp.mkfs
> > +_scratch_mount
> > +
> > +# This case will use 10 bytes xattr namelen and 11+ bytes valuelen, so:
> > +#   sizeof(xfs_attr_leaf_name_local) = 2 + 1 + 10 + 11 = 24,
> > +#   sizeof(xfs_attr_leaf_entry) = 8
> > +# So count in the header, if I create more than $((dbsize / 32)) xattr entries,
> > +# it will out of a leaf block (not much), then get one node block and two or
> > +# more leaf blocks, that's the testing need.
> 
> I think this last sentence could be clearer:
> 
> "Create more than $((dbsize / 32)) xattr entries to force the creation
> of a node block, which we need for this test."

Hi Darrick,

Thanks for your reviewing! Sure, I'll remove redundant comments.

> 
> > +nr_xattr="$((dbsize / 32))"
> > +localfile="${SCRATCH_MNT}/attrfile"
> > +touch $localfile
> > +for ((i=0; i<nr_xattr; i++));do
> > +	$SETFATTR_PROG -n user.x$(printf "%.09d" "$i") -v "aaaaaaaaaaaaaaaa" $localfile
> > +done
> > +inumber="$(stat -c '%i' $localfile)"
> 
> Though I also wonder, could you just steal this line:
> 
> __populate_create_attr "${SCRATCH_MNT}/ATTR.FMT_NODE" "$((8 * blksz / 40))"
> 
> from _scratch_xfs_populate?

Oh, I don't know there's a helper like that. But I'm wondering is it recommended
using a function begin with "__" directly?

BTW, may I ask why you prefer the number "40"? You use this number in some cases
likes x/124, x/125, x/126. Likes nr=((blksz / 40)) or nr = ((8 * blksz / 40)).


I tried to calculate, but didn't find anything match 40 bytes perfectly.
You used 9 bytes xattr name and 16 bytes xattr value, so the size of attr
leaf_name_local and leaf_entry is 28+8=36. So I think in order to make
attr entries out of a block, better to make the blksz divided by a
number <= 36. Why 40? I know I might miss something, so really hope to get
the details from you :)

> 
> > +_scratch_unmount
> > +
> > +# Expect the ablock 0 is a node block, later ablocks(>=1) are leaf blocks, then corrupt
> > +# the last leaf block. (Don't corrupt node block, or can't reproduce the bug)
> > +magic=$(_scratch_xfs_get_metadata_field "hdr.info.hdr.magic" "inode $inumber" "ablock 0")
> > +level=$(_scratch_xfs_get_metadata_field "hdr.level" "inode $inumber" "ablock 0")
> > +count=$(_scratch_xfs_get_metadata_field "hdr.count" "inode $inumber" "ablock 0")
> > +if [ "$magic" = "0x3ebe" -a "$level" = "1" ];then
> > +	# Corrupt the last leaf block
> > +	_scratch_xfs_db -x -c "inode ${inumber}" -c "ablock $count" -c "stack" \
> > +		-c "blocktrash -x 32 -y $((dbsize*8)) -3 -z" >> $seqres.full
> > +else
> > +	_fail "The ablock 0 isn't a root node block, maybe case issue"
> 
> Might want to capture the magic and level here so that we can diagnose
> test setup failures.

Sure

> 
> > +fi
> > +
> > +# This's the real testing, expect removexattr won't hang or panic.
> > +if _try_scratch_mount >> $seqres.full 2>&1; then
> > +	for ((i=0; i<nr_xattr; i++));do
> > +		$GETFATTR_PROG -n user.x$(printf "%.09d" "$i") $localfile >/dev/null 2>&1
> > +		$SETFATTR_PROG -x user.x$(printf "%.09d" "$i") $localfile 2>/dev/null
> > +	done
> > +else
> > +	_notrun "XFS refused to mount with this xattr corrutpion, test skipped"
> 
> When does mount fail?  Or is this a precaution?

Oh, it doesn't fail currently. But I can't be sure it always mount succeed,
especially I corrupt this fs manually. So add this judgement :)

Thanks,
Zorro

> 
> --D
> 
> > +fi
> > +
> > +echo "Silence is golden"
> > +# success, all done
> > +status=0
> > +exit
> > diff --git a/tests/xfs/999.out b/tests/xfs/999.out
> > new file mode 100644
> > index 00000000..3b276ca8
> > --- /dev/null
> > +++ b/tests/xfs/999.out
> > @@ -0,0 +1,2 @@
> > +QA output created by 999
> > +Silence is golden
> > -- 
> > 2.31.1
> > 
> 

