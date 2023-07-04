Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47992EB64D9
	for <linux-xfs@archiver.kernel.org>; Tue,  4 Jul 2023 15:52:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231483AbjGDPwL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 4 Jul 2023 11:52:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231417AbjGDPwK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 4 Jul 2023 11:52:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E87F6B2;
        Tue,  4 Jul 2023 08:52:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7EBD66124D;
        Tue,  4 Jul 2023 15:52:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D415CC433C7;
        Tue,  4 Jul 2023 15:52:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1688485927;
        bh=coDj5gZ453d+E9AncYL4hjykw36kfCVGmuQAdS18LO8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=FuTybsZCfZr0H8Iep+TsxWxMZFZk1dOLPxuaaT4sput9JmWdjQHCyq7GBtNOHBGiL
         fDXwuokSyFCHrmMSfeNw8tTbXZ77DB/ExVAqUSMrlZs9c+ZP1mmcKKAA8DVk/gPpWv
         WiG3aJdS4moew6Z1Ql/ivHZGBdGhSyNzPZziucoWXoFOHSzIK/WEtcd5mt39kfxaTr
         5hodS1hhX8/kJ1e63FwmtdFGMSf1uwGa0pKM4QcNDouwqG8S+en8BG9zNbp8xRu3dd
         D8eouFrPenVu0/3i0f7TK1GEokL7PC6Qrh5Tb6ojOyLWkrRI8re3LYCGViLpr2fhNl
         b36IyVtfH3dmg==
Date:   Tue, 4 Jul 2023 08:52:07 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Andrey Albershteyn <aalbersh@redhat.com>
Cc:     zlang@redhat.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org, guan@eryu.me
Subject: Re: [PATCH 5/5] xfs: test growfs of the realtime device
Message-ID: <20230704155207.GN11441@frogsfrogsfrogs>
References: <168840381298.1317961.1436890061506567407.stgit@frogsfrogsfrogs>
 <168840384128.1317961.1554188648447496379.stgit@frogsfrogsfrogs>
 <20230704140357.tg2yxfknkzniotve@aalbersh.remote.csb>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230704140357.tg2yxfknkzniotve@aalbersh.remote.csb>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jul 04, 2023 at 04:03:57PM +0200, Andrey Albershteyn wrote:
> On 2023-07-03 10:04:01, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Create a new test to make sure that growfs on the realtime device works
> > without corrupting anything.
> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> >  tests/xfs/934     |   79 +++++++++++++++++++++++++++++++++++++++++++++++++++++
> >  tests/xfs/934.out |   19 +++++++++++++
> >  2 files changed, 98 insertions(+)
> >  create mode 100755 tests/xfs/934
> >  create mode 100644 tests/xfs/934.out
> > 
> > 
> > diff --git a/tests/xfs/934 b/tests/xfs/934
> > new file mode 100755
> > index 0000000000..f2db4050a7
> > --- /dev/null
> > +++ b/tests/xfs/934
> > @@ -0,0 +1,79 @@
> > +#! /bin/bash
> > +# SPDX-License-Identifier: GPL-2.0
> > +# Copyright (c) 2000-2002 Silicon Graphics, Inc.  All Rights Reserved.
> 
> Oracle?

Eh, this is really just a tweak of xfs/041 so I retained the old
copyright.

> > +#
> > +# FS QA Test No. 934
> > +#
> > +# growfs QA tests - repeatedly fill/grow the rt volume of the filesystem check
> > +# the filesystem contents after each operation.  This is the rt equivalent of
> > +# xfs/041.
> > +#
> > +. ./common/preamble
> > +_begin_fstest growfs ioctl auto
> > +
> > +# Override the default cleanup function.
> > +_cleanup()
> > +{
> > +	cd /
> > +	_scratch_unmount
> > +	rm -f $tmp.*
> > +}
> > +
> > +# Import common functions.
> > +. ./common/filter
> > +
> > +# real QA test starts here
> > +_supported_fs xfs
> > +
> > +_require_scratch
> > +_require_realtime
> > +_require_no_large_scratch_dev
> > +_scratch_unmount 2>/dev/null
> > +
> > +_fill()
> > +{
> > +    if [ $# -ne 1 ]; then echo "Usage: _fill \"path\"" 1>&2 ; exit 1; fi
> 
> Is this needed for something?

...and all the other weird bits are copied verbatim.

Thanks for reviewing!

--D

> > +    _do "Fill filesystem" \
> > +	"$here/src/fill2fs --verbose --dir=$1 --seed=0 --filesize=65536 --stddev=32768 --list=- >>$tmp.manifest"
> > +}
> > +
> > +_do_die_on_error=message_only
> > +rtsize=32
> > +echo -n "Make $rtsize megabyte rt filesystem on SCRATCH_DEV and mount... "
> > +_scratch_mkfs_xfs -rsize=${rtsize}m | _filter_mkfs 2> "$tmp.mkfs" >> $seqres.full
> > +test "${PIPESTATUS[0]}" -eq 0 || _fail "mkfs failed"
> > +
> > +. $tmp.mkfs
> > +onemeginblocks=`expr 1048576 / $dbsize`
> > +_scratch_mount
> > +
> > +# We're growing the realtime device, so force new file creation there
> > +_xfs_force_bdev realtime $SCRATCH_MNT
> > +
> > +echo "done"
> > +
> > +# full allocation group -> partial; partial -> expand partial + new partial;
> > +# partial -> expand partial; partial -> full
> > +# cycle through 33m -> 67m -> 75m -> 96m
> > +for size in 33 67 75 96
> > +do
> > +    grow_size=`expr $size \* $onemeginblocks`
> > +    _fill $SCRATCH_MNT/fill_$size
> > +    _do "Grow filesystem to ${size}m" "xfs_growfs -R $grow_size $SCRATCH_MNT"
> > +    echo -n "Flush filesystem... "
> > +    _do "_scratch_unmount"
> > +    _do "_try_scratch_mount"
> > +    echo "done"
> > +    echo -n "Check files... "
> > +    if ! _do "$here/src/fill2fs_check $tmp.manifest"; then
> > +      echo "fail (see $seqres.full)"
> 
> I think "fail" is already printed by _do
> 
> These are nitpicks, anyway looks good to me:
> Reviewed-by: Andrey Albershteyn <aalbersh@redhat.com>
> 
> -- 
> - Andrey
> 
