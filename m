Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46CF2C43334
	for <linux-xfs@archiver.kernel.org>; Fri,  8 Jul 2022 00:49:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230314AbiGHAt2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 7 Jul 2022 20:49:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229458AbiGHAt1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 Jul 2022 20:49:27 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 785925C942
        for <linux-xfs@vger.kernel.org>; Thu,  7 Jul 2022 17:49:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657241365;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=uIrAzPk2aRvQo1adOcWasOkdM2HGS+w4GmNv8c5WOJI=;
        b=fdXFp/NQuK/BJb09Nz17Eua3eMoVe9HyKJkps6pSvVCnw98MEMOZuL5z1HFoYWeQSRci6E
        8AEKX3tnN1IOCkmAFeoIZ2kbrLIYg22tHhtj69Mk64mGvcR99LVdRryMtNx6No3XtM2YfV
        TzdHXtw4D6giYmP5Jq+jCNhfrYmsVkg=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-59-X_DHarBbOK2A-GEz8kulDw-1; Thu, 07 Jul 2022 20:49:23 -0400
X-MC-Unique: X_DHarBbOK2A-GEz8kulDw-1
Received: by mail-qk1-f198.google.com with SMTP id k190-20020a37bac7000000b006af6d953751so19564243qkf.13
        for <linux-xfs@vger.kernel.org>; Thu, 07 Jul 2022 17:49:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=uIrAzPk2aRvQo1adOcWasOkdM2HGS+w4GmNv8c5WOJI=;
        b=JcxE/Bvh1aOtY/LNPg8SyTq+CkngXGbUMiJpiv8jCxzM/yvEpQqXrzefffQ0tKIFNM
         aQzPeVEYqkpjzSbAooB8tsT35YQTW8RJSGR7TLI6QfJBtJ+eb+Br+f77TmvxqE9d7cDu
         6l85oKjnYHN3VRlxUXy35QEFaMC0co3+qtBS7jYuRmwY5gVpuNl4URHhESnbo4obM3+L
         qlRKniBysxhf+H6N0cFYkTth8u9a3PnFywWtP9eMU4Wdiocn4ob7a10icylpcKIYELiG
         gt9/SKATfEn2sipajiAJQHt2uY0/79gLDu3Ml4FexWJGgZz2KidA7EVKOFnKupyaIHEa
         dT7A==
X-Gm-Message-State: AJIora8bigXkm58N5pzY52ld8B/6/0+xlxXvrl7mFeU3iFmBF6aT6y8U
        oPuNsyQcMEpV3AsFooOFOWkFXjYh5HkqoZmhgI/2A0ruaT+t4BCPsmi5bk0IDMM0+W7PDZy0Gp8
        GfG0uKtyZIhsrBQmO40Zh
X-Received: by 2002:ac8:5813:0:b0:31b:1:4741 with SMTP id g19-20020ac85813000000b0031b00014741mr846005qtg.16.1657241363387;
        Thu, 07 Jul 2022 17:49:23 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1sSsjZ5fJG6aSTAyTmZGCKCvx9hNN6ihka+hG6ncwI7xhY7ApseMJea0IFlHLhQbwQln3HeuA==
X-Received: by 2002:ac8:5813:0:b0:31b:1:4741 with SMTP id g19-20020ac85813000000b0031b00014741mr845991qtg.16.1657241363015;
        Thu, 07 Jul 2022 17:49:23 -0700 (PDT)
Received: from zlang-mailbox ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id w18-20020a05620a445200b0069c72b41b59sm2149744qkp.2.2022.07.07.17.49.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jul 2022 17:49:22 -0700 (PDT)
Date:   Fri, 8 Jul 2022 08:49:16 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 1/2] xfs: make sure that we handle empty xattr leaf
 blocks ok
Message-ID: <20220708004916.tiidmzowad2wi3g4@zlang-mailbox>
References: <165705854325.2821854.10317059026052442189.stgit@magnolia>
 <165705854877.2821854.7070105861462675249.stgit@magnolia>
 <20220707120639.qoqsfcwtmdyl5duv@zlang-mailbox>
 <YsckVj+Yw4h1xeVp@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YsckVj+Yw4h1xeVp@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jul 07, 2022 at 11:22:14AM -0700, Darrick J. Wong wrote:
> On Thu, Jul 07, 2022 at 08:06:39PM +0800, Zorro Lang wrote:
> > On Tue, Jul 05, 2022 at 03:02:28PM -0700, Darrick J. Wong wrote:
> > > From: Darrick J. Wong <djwong@kernel.org>
> > > 
> > > Make sure that the kernel can handle empty xattr leaf blocks properly,
> > > since we've screwed this up enough times.
> > > 
> > > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > > ---
> > >  tests/xfs/845 |  131 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
> > >  1 file changed, 131 insertions(+)
> > >  create mode 100755 tests/xfs/845
> > > 
> > > 
> > > diff --git a/tests/xfs/845 b/tests/xfs/845
> > > new file mode 100755
> > > index 00000000..4a846e57
> > > --- /dev/null
> > > +++ b/tests/xfs/845
> > > @@ -0,0 +1,131 @@
> > > +#! /bin/bash
> > > +# SPDX-License-Identifier: GPL-2.0
> > > +# Copyright (c) 2022 Oracle.  All Rights Reserved.
> > > +#
> > > +# FS QA Test 845
> > > +#
> > > +# Make sure that XFS can handle empty leaf xattr blocks correctly.  These
> > > +# blocks can appear in files as a result of system crashes in the middle of
> > > +# xattr operations, which means that we /must/ handle them gracefully.
> > > +# Check that read and write verifiers won't trip, that the get/list/setxattr
> > > +# operations don't stumble over them, and that xfs_repair will offer to remove
> > > +# the entire xattr fork if the root xattr leaf block is empty.
> > > +#
> > > +# Regression test for kernel commit:
> > > +#
> > > +# af866926d865 ("xfs: empty xattr leaf header blocks are not corruption")
> > > +#
> > > +. ./common/preamble
> > > +_begin_fstest auto quick attr
> > > +
> > > +# Override the default cleanup function.
> > > +# _cleanup()
> > > +# {
> > > +# 	cd /
> > > +# 	rm -r -f $tmp.*
> > > +# }
> > 
> > Remove this part directly?
> 
> Ok.
> 
> > > +
> > > +# Import common functions.
> > > +. ./common/filter
> > > +. ./common/attr
> > > +
> > > +# real QA test starts here
> > > +
> > > +# Modify as appropriate.
> >       ^^
> >       This comment is useless
> 
> Oops, will delete.
> 
> > > +_supported_fs xfs
> > > +_require_scratch
> > > +_fixed_by_kernel_commit af866926d865 "xfs: empty xattr leaf header blocks are not corruption"
> > > +
> > > +_scratch_mkfs_xfs | _filter_mkfs >$seqres.full 2>$tmp.mkfs
> > > +cat $tmp.mkfs >> $seqres.full
> > > +source $tmp.mkfs
> > > +_scratch_mount
> > > +
> > > +$XFS_IO_PROG -f -c 'pwrite -S 0x58 0 64k' $SCRATCH_MNT/largefile >> $seqres.full
> > > +$XFS_IO_PROG -f -c "pwrite -S 0x58 0 $isize" $SCRATCH_MNT/smallfile >> $seqres.full
> > > +
> > > +smallfile_md5=$(md5sum < $SCRATCH_MNT/smallfile)
> > > +largefile_md5=$(md5sum < $SCRATCH_MNT/largefile)
> > 
> > Hmm... is the tail '-' (printed by md5sum) as you wish? How about use the
> > _md5_checksum() in common/rc ? (Same as below small_md5 and large_md5 part)
> 
> Ooh, nice suggestion.  I"ll convert the test.
> 
> > > +
> > > +# Try to force the creation of a single leaf block in each of three files.
> > > +# The first one gets a local attr, the second a remote attr, and the third
> > > +# is left for scrub and repair to find.
> > > +touch $SCRATCH_MNT/e0
> > > +touch $SCRATCH_MNT/e1
> > > +touch $SCRATCH_MNT/e2
> > > +
> > > +$ATTR_PROG -s x $SCRATCH_MNT/e0 < $SCRATCH_MNT/smallfile >> $seqres.full
> > > +$ATTR_PROG -s x $SCRATCH_MNT/e1 < $SCRATCH_MNT/smallfile >> $seqres.full
> > > +$ATTR_PROG -s x $SCRATCH_MNT/e2 < $SCRATCH_MNT/smallfile >> $seqres.full
> > > +
> > > +e0_ino=$(stat -c '%i' $SCRATCH_MNT/e0)
> > > +e1_ino=$(stat -c '%i' $SCRATCH_MNT/e1)
> > > +e2_ino=$(stat -c '%i' $SCRATCH_MNT/e2)
> > > +
> > > +_scratch_unmount
> > > +
> > > +# We used to think that it wasn't possible for empty xattr leaf blocks to
> > > +# exist, but it turns out that setting a large xattr on a file that has no
> > > +# xattrs can race with a log flush and crash, which results in an empty
> > > +# leaf block being logged and recovered.  This is rather hard to trip, so we
> > > +# use xfs_db to turn a regular leaf block into an empty one.
> > > +make_empty_leaf() {
> > > +	local inum="$1"
> > > +
> > > +	echo "editing inode $inum" >> $seqres.full
> > > +
> > > +	magic=$(_scratch_xfs_get_metadata_field hdr.info.magic "inode $inum" "ablock 0")
> > > +	if [ "$magic" = "0xfbee" ]; then
> > > +		_notrun "V4 filesystems deprecated"
> > 
> > Can _require_scratch_xfs_crc (at beginning) help that? Or is there a way to
> > get a v4 leaf block when crc isn't enabled?
> 
> Nope, that was an oversight on my part.  I'll add
> _require_scratch_xfs_crc to the start of the test.
> 
> > > +		return 1
> > 
> > I think _notrun will exit directly, this "return 1" never be run.
> 
> Yep.
> 
> > > +	fi
> > > +
> > > +	magic=$(_scratch_xfs_get_metadata_field hdr.info.hdr.magic "inode $inum" "ablock 0")
> > > +	if [ "$magic" != "0x3bee" ]; then
> > > +		echo "inode $inum ablock 0 is not a leaf block?"
> > > +		_scratch_xfs_db -x -c "inode $inum" -c "ablock 0" -c print >> $seqres.full
> > > +		return 1
> > > +	fi
> > > +
> > > +	base=$(_scratch_xfs_get_metadata_field "hdr.freemap[0].base" "inode $inum" "ablock 0")
> > > +
> > > +	_scratch_xfs_db -x -c "inode $inum" -c "ablock 0" \
> > > +		-c "write -d hdr.count 0" \
> > > +		-c "write -d hdr.usedbytes 0" \
> > > +		-c "write -d hdr.firstused $dbsize" \
> > > +		-c "write -d hdr.freemap[0].size $((dbsize - base))" \
> > 
> > Nice trick:) Do we expect there's not corruption (can be found by xfs_repair)
> > at here?
> 
> Right.  We're setting up the empty leaf block 0 to check that the kernel
> and fsck tools do /not/ flag this as corruption.
> 
> > Or xfs_repair should blame the empty leaf block?
> 
> ...though repair run in not-dryrun mode will free the empty leaf block 0
> if it finds one.
> 
> > > +		-c print >> $seqres.full
> > > +}
> > > +
> > > +make_empty_leaf $e0_ino || exit
> > 
> > How about call _fail() directly in make_empty_leaf, if [ "$magic" != "0x3bee" ]
> 
> _require_scratch_xfs_crc should take care of that.

Hmm... I think _require_scratch_xfs_crc will help this:

  magic=$(_scratch_xfs_get_metadata_field hdr.info.magic "inode $inum" "ablock 0")
  if [ "$magic" = "0xfbee" ]; then

but can't help this part:

 magic=$(_scratch_xfs_get_metadata_field hdr.info.hdr.magic "inode $inum" "ablock 0")
 if [ "$magic" != "0x3bee" ]; then

due to ablock 0 might be 0x3ebe (XFS_DA3_NODE_MAGIC) besides 0x3bee, although
it looks nearly not impossible in this test, as you only create one attr equal
to inode size :) So if we make sure it never be a node block, it's fine to
remove this judgement, or you can keep it for sure.

Thanks,
Zorro

> 
> > > +make_empty_leaf $e1_ino
> > > +make_empty_leaf $e2_ino
> > > +
> > > +_scratch_mount
> > > +
> > > +# Check that listxattr/getxattr/removexattr do nothing.
> > > +$ATTR_PROG -l $SCRATCH_MNT/e0 2>&1 | _filter_scratch
> > > +$ATTR_PROG -g x $SCRATCH_MNT/e0 2>&1 | _filter_scratch
> > > +$ATTR_PROG -r x $SCRATCH_MNT/e0 2>&1 | _filter_scratch
> > > +
> > > +# Add a small attr to e0
> > > +$ATTR_PROG -s x $SCRATCH_MNT/e0 < $SCRATCH_MNT/smallfile > /dev/null
> > > +$ATTR_PROG -l $SCRATCH_MNT/e0 2>&1 | sed -e 's/\([0-9]*\) byte/XXX byte/g' | _filter_scratch
> > > +small_md5="$($GETFATTR_PROG -n user.x --absolute-names --only-values $SCRATCH_MNT/e0 | md5sum)"
> > > +test "$small_md5" = "$smallfile_md5" || \
> > > +	echo "smallfile $smallfile_md5 does not match small attr $small_md5"
> > > +
> > > +# Add a large attr to e1
> > > +$ATTR_PROG -s x $SCRATCH_MNT/e1 < $SCRATCH_MNT/largefile > /dev/null
> > > +$ATTR_PROG -l $SCRATCH_MNT/e1 2>&1 | _filter_scratch
> > > +large_md5="$($GETFATTR_PROG -n user.x --absolute-names --only-values $SCRATCH_MNT/e1 | md5sum)"
> > > +test "$large_md5" = "$largefile_md5" || \
> > > +	echo "largefile $largefile_md5 does not match large attr $large_md5"
> > > +
> > > +
> > > +# Leave e2 to try to trip the repair tools, since xfs_repair used to flag
> > > +# empty leaf blocks incorrectly too.
> > 
> > So we expect there's not corruption at here, and the empty leaf block can
> > be used properly?
> 
> Correct.
> 
> --D
> 
> > Thanks,
> > Zorro
> > 
> > > +
> > > +# success, all done
> > > +status=0
> > > +exit
> > > 
> > 
> 

