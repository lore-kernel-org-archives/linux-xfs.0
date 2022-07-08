Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A977C433EF
	for <linux-xfs@archiver.kernel.org>; Fri,  8 Jul 2022 17:27:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238637AbiGHR1c (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 8 Jul 2022 13:27:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238301AbiGHR1b (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 8 Jul 2022 13:27:31 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2E9C753D06
        for <linux-xfs@vger.kernel.org>; Fri,  8 Jul 2022 10:27:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657301249;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=BxBDHxqUPoIYynkFt0Mdizuma9Y+S7/pc8Gyz9bPL74=;
        b=HhfvtSfd2igrcdnIb4to3XwfCYzpOP54teagUGAYYfsf17LO+WpCuW+aPKygaq8iCmrjKG
        tZEbFZHlwP2SO4fO+kglarMYrRqLvihJ/AT7Ydxn4jhfTO+g2EYqp8+AtyQ1MO2G4N2RV7
        C6BpIWQHzQwQlTkvGICmmHDrhsTIE5Y=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-161-joEB9HNiMJa0jAvpIawEmw-1; Fri, 08 Jul 2022 13:27:28 -0400
X-MC-Unique: joEB9HNiMJa0jAvpIawEmw-1
Received: by mail-qk1-f198.google.com with SMTP id s9-20020a05620a254900b006b54dd4d6deso5960242qko.3
        for <linux-xfs@vger.kernel.org>; Fri, 08 Jul 2022 10:27:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=BxBDHxqUPoIYynkFt0Mdizuma9Y+S7/pc8Gyz9bPL74=;
        b=puQ92E5F11UUcKJp+PEM+n7f0BQMLV/CvmnRP25s7lMyMDCxp3JAdzIGuhOn0YfbGL
         mFLjU+1efJd+sHnM3BZThmR19qOMXCVBfhmDExZ4JHBwZrSV+WKMxAzajnoBzMQe3gYV
         lmDU69/vAWvAfLlH+8fPYUwCuZST1M1mF/SuL8LwUf7QFFTCuvvzJSm05uF0gWYn1gf3
         QkTbRo9LFvrhZCK8VjrFvYCOl74uCyAFk1XLszvzOhN09UWTB2RTTBqu+/GAvCq/SiSp
         MTB+GUDolNlv5dwuyYbEycaPLr3Qb6pvrs46Yx8Y3IVpT+NpCg4rMj/15+XkzbVfJ31P
         5lZA==
X-Gm-Message-State: AJIora/HmZhUveDRP0MlNZlkuEewF91mdbLhJHs7JKj5o6+2gi1UBYbN
        zCMgdor3YTP9O0dHGaL8+PlsnWPWft/qaFBmjk8uQt27CbtDgmA5Bydc0oz9WpqAHiOmtDp367U
        RrQefLdIjQmmRVipLExdD
X-Received: by 2002:a05:6214:27e7:b0:472:f1de:a4f6 with SMTP id jt7-20020a05621427e700b00472f1dea4f6mr3486979qvb.28.1657301247424;
        Fri, 08 Jul 2022 10:27:27 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1tNqVuftsvl5UywMo/8jrzMY8oJaelFrEOMwHJwDkZmtCFR0hVcQ7I8E6nhUNt/fzAI5qDYVg==
X-Received: by 2002:a05:6214:27e7:b0:472:f1de:a4f6 with SMTP id jt7-20020a05621427e700b00472f1dea4f6mr3486946qvb.28.1657301246917;
        Fri, 08 Jul 2022 10:27:26 -0700 (PDT)
Received: from zlang-mailbox ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id l7-20020a05620a28c700b006b47dc92e15sm12242337qkp.36.2022.07.08.10.27.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Jul 2022 10:27:26 -0700 (PDT)
Date:   Sat, 9 Jul 2022 01:27:20 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 1/2] xfs: make sure that we handle empty xattr leaf
 blocks ok
Message-ID: <20220708172720.izchyylj4q26whly@zlang-mailbox>
References: <165705854325.2821854.10317059026052442189.stgit@magnolia>
 <165705854877.2821854.7070105861462675249.stgit@magnolia>
 <YshjDMa4kXfrqY/Y@magnolia>
 <20220708170827.fszm4exxxu2zhszl@zlang-mailbox>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220708170827.fszm4exxxu2zhszl@zlang-mailbox>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Jul 09, 2022 at 01:08:27AM +0800, Zorro Lang wrote:
> On Fri, Jul 08, 2022 at 10:02:04AM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Make sure that the kernel can handle empty xattr leaf blocks properly,
> > since we've screwed this up enough times.
> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> 
> This version looks good to me, thanks for this new case!
> 
> Reviewed-by: Zorro Lang <zlang@redhat.com>

Errr.. I just noticed that there's not .out file in this patch, and it's not
simple "Silence is golden" I think.

Thanks,
Zorro

> 
> > v1.1: adopt maintainer's refactoring suggestions, skip v4 filesystems
> > from the start, and check that we really get an attr leaf block.
> > 
> > v1.2: eliminate dead code
> > ---
> >  tests/xfs/845 |  117 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
> >  1 file changed, 117 insertions(+)
> >  create mode 100755 tests/xfs/845
> > 
> > diff --git a/tests/xfs/845 b/tests/xfs/845
> > new file mode 100755
> > index 00000000..c142fba1
> > --- /dev/null
> > +++ b/tests/xfs/845
> > @@ -0,0 +1,117 @@
> > +#! /bin/bash
> > +# SPDX-License-Identifier: GPL-2.0
> > +# Copyright (c) 2022 Oracle.  All Rights Reserved.
> > +#
> > +# FS QA Test 845
> > +#
> > +# Make sure that XFS can handle empty leaf xattr blocks correctly.  These
> > +# blocks can appear in files as a result of system crashes in the middle of
> > +# xattr operations, which means that we /must/ handle them gracefully.
> > +# Check that read and write verifiers won't trip, that the get/list/setxattr
> > +# operations don't stumble over them, and that xfs_repair will offer to remove
> > +# the entire xattr fork if the root xattr leaf block is empty.
> > +#
> > +# Regression test for kernel commit:
> > +#
> > +# af866926d865 ("xfs: empty xattr leaf header blocks are not corruption")
> > +#
> > +. ./common/preamble
> > +_begin_fstest auto quick attr
> > +
> > +# Import common functions.
> > +. ./common/filter
> > +. ./common/attr
> > +
> > +# real QA test starts here
> > +
> > +_supported_fs xfs
> > +_require_scratch
> > +_require_scratch_xfs_crc # V4 is deprecated
> > +_fixed_by_kernel_commit af866926d865 "xfs: empty xattr leaf header blocks are not corruption"
> > +
> > +_scratch_mkfs_xfs | _filter_mkfs >$seqres.full 2>$tmp.mkfs
> > +cat $tmp.mkfs >> $seqres.full
> > +source $tmp.mkfs
> > +_scratch_mount
> > +
> > +$XFS_IO_PROG -f -c 'pwrite -S 0x58 0 64k' $SCRATCH_MNT/largefile >> $seqres.full
> > +$XFS_IO_PROG -f -c "pwrite -S 0x58 0 $isize" $SCRATCH_MNT/smallfile >> $seqres.full
> > +
> > +smallfile_md5=$(_md5_checksum $SCRATCH_MNT/smallfile)
> > +largefile_md5=$(_md5_checksum $SCRATCH_MNT/largefile)
> > +
> > +# Try to force the creation of a single leaf block in each of three files.
> > +# The first one gets a local attr, the second a remote attr, and the third
> > +# is left for scrub and repair to find.
> > +touch $SCRATCH_MNT/e0
> > +touch $SCRATCH_MNT/e1
> > +touch $SCRATCH_MNT/e2
> > +
> > +$ATTR_PROG -s x $SCRATCH_MNT/e0 < $SCRATCH_MNT/smallfile >> $seqres.full
> > +$ATTR_PROG -s x $SCRATCH_MNT/e1 < $SCRATCH_MNT/smallfile >> $seqres.full
> > +$ATTR_PROG -s x $SCRATCH_MNT/e2 < $SCRATCH_MNT/smallfile >> $seqres.full
> > +
> > +e0_ino=$(stat -c '%i' $SCRATCH_MNT/e0)
> > +e1_ino=$(stat -c '%i' $SCRATCH_MNT/e1)
> > +e2_ino=$(stat -c '%i' $SCRATCH_MNT/e2)
> > +
> > +_scratch_unmount
> > +
> > +# We used to think that it wasn't possible for empty xattr leaf blocks to
> > +# exist, but it turns out that setting a large xattr on a file that has no
> > +# xattrs can race with a log flush and crash, which results in an empty
> > +# leaf block being logged and recovered.  This is rather hard to trip, so we
> > +# use xfs_db to turn a regular leaf block into an empty one.
> > +make_empty_leaf() {
> > +	local inum="$1"
> > +
> > +	echo "editing inode $inum" >> $seqres.full
> > +
> > +	magic=$(_scratch_xfs_get_metadata_field hdr.info.hdr.magic "inode $inum" "ablock 0")
> > +	if [ "$magic" != "0x3bee" ]; then
> > +		_scratch_xfs_db -x -c "inode $inum" -c "ablock 0" -c print >> $seqres.full
> > +		_fail "inode $inum ablock 0 is not a leaf block?"
> > +	fi
> > +
> > +	base=$(_scratch_xfs_get_metadata_field "hdr.freemap[0].base" "inode $inum" "ablock 0")
> > +
> > +	_scratch_xfs_db -x -c "inode $inum" -c "ablock 0" \
> > +		-c "write -d hdr.count 0" \
> > +		-c "write -d hdr.usedbytes 0" \
> > +		-c "write -d hdr.firstused $dbsize" \
> > +		-c "write -d hdr.freemap[0].size $((dbsize - base))" \
> > +		-c print >> $seqres.full
> > +}
> > +
> > +make_empty_leaf $e0_ino
> > +make_empty_leaf $e1_ino
> > +make_empty_leaf $e2_ino
> > +
> > +_scratch_mount
> > +
> > +# Check that listxattr/getxattr/removexattr do nothing.
> > +$ATTR_PROG -l $SCRATCH_MNT/e0 2>&1 | _filter_scratch
> > +$ATTR_PROG -g x $SCRATCH_MNT/e0 2>&1 | _filter_scratch
> > +$ATTR_PROG -r x $SCRATCH_MNT/e0 2>&1 | _filter_scratch
> > +
> > +# Add a small attr to e0
> > +$ATTR_PROG -s x $SCRATCH_MNT/e0 < $SCRATCH_MNT/smallfile > /dev/null
> > +$ATTR_PROG -l $SCRATCH_MNT/e0 2>&1 | sed -e 's/\([0-9]*\) byte/XXX byte/g' | _filter_scratch
> > +small_md5="$($GETFATTR_PROG -n user.x --absolute-names --only-values $SCRATCH_MNT/e0 | _md5_checksum)"
> > +test "$small_md5" = "$smallfile_md5" || \
> > +	echo "smallfile $smallfile_md5 does not match small attr $small_md5"
> > +
> > +# Add a large attr to e1
> > +$ATTR_PROG -s x $SCRATCH_MNT/e1 < $SCRATCH_MNT/largefile > /dev/null
> > +$ATTR_PROG -l $SCRATCH_MNT/e1 2>&1 | _filter_scratch
> > +large_md5="$($GETFATTR_PROG -n user.x --absolute-names --only-values $SCRATCH_MNT/e1 | _md5_checksum)"
> > +test "$large_md5" = "$largefile_md5" || \
> > +	echo "largefile $largefile_md5 does not match large attr $large_md5"
> > +
> > +
> > +# Leave e2 to try to trip the repair tools, since xfs_repair used to flag
> > +# empty leaf blocks incorrectly too.
> > +
> > +# success, all done
> > +status=0
> > +exit
> > 

