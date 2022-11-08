Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A10BEC433FE
	for <linux-xfs@archiver.kernel.org>; Tue,  8 Nov 2022 15:52:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234501AbiKHPwY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 8 Nov 2022 10:52:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234380AbiKHPwS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 8 Nov 2022 10:52:18 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BFCF5C74F;
        Tue,  8 Nov 2022 07:52:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F24E7B81BA8;
        Tue,  8 Nov 2022 15:52:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E705C433D7;
        Tue,  8 Nov 2022 15:52:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667922734;
        bh=iOAI5sGck4F5KC/s/NuLS54noS77rkRDj1IllKVff4s=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=p/Lf260U9pO4WsuIficqovLeU+3Rnb2+Jv0pufEhSbksyK6Phnel1BtvkSd76XQga
         vJmSdZD3cW1YqBtdu4DVFpcxjAOdnbeBfQ1T4shgRoIlnie6PQJS8hwTQpgWqrWglG
         9+OJ+EQ1R4Cu/CIiDZ643l77qsgjQMme5giopSVD6H/u37AUFYO2Atry1d7Si1g43I
         AqwtEX2j+x6CkPE2s2qQwzXwk8ZLKq6TExUTQd0Ka7MeqYUYjguba0ROxkm9O/5jhY
         afGncPaug2ebAxnO53/D2h6Tw3Dygx3+B4TT1GdsIJY93KaPVz7AZDVCMpeSmpB5JS
         jLVMUvAebwufQ==
Date:   Tue, 8 Nov 2022 07:52:14 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Zorro Lang <zlang@redhat.com>
Cc:     fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2] generic: shutdown might leave NULL files with nonzero
 di_size
Message-ID: <Y2p7LnPOFXy4kitY@magnolia>
References: <20221105152324.2233310-1-zlang@kernel.org>
 <Y2k1SzblcYRsSvzK@magnolia>
 <20221108060244.gixpw3v3cpwckkjq@zlang-mailbox>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221108060244.gixpw3v3cpwckkjq@zlang-mailbox>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Nov 08, 2022 at 02:02:44PM +0800, Zorro Lang wrote:
> On Mon, Nov 07, 2022 at 08:41:47AM -0800, Darrick J. Wong wrote:
> > On Sat, Nov 05, 2022 at 11:23:24PM +0800, Zorro Lang wrote:
> > > An old issue might cause on-disk inode sizes are logged prematurely
> > > via the free eofblocks path on file close. Then fs shutdown might
> > > leave NULL files but their di_size > 0.
> > > 
> > > Signed-off-by: Zorro Lang <zlang@kernel.org>
> > > ---
> > > 
> > > V2 replace "fiemap" with "stat" command, to check if a file has extents.
> > > That helps this case more common.
> > > 
> > > Thanks,
> > > Zorro
> > > 
> > >  tests/generic/999     | 42 ++++++++++++++++++++++++++++++++++++++++++
> > >  tests/generic/999.out |  5 +++++
> > >  2 files changed, 47 insertions(+)
> > >  create mode 100755 tests/generic/999
> > >  create mode 100644 tests/generic/999.out
> > > 
> > > diff --git a/tests/generic/999 b/tests/generic/999
> > > new file mode 100755
> > > index 00000000..8b4596e0
> > > --- /dev/null
> > > +++ b/tests/generic/999
> > 
> > Ugh sorry     ^^^^^^^ I didn't notice this part and wrote my previous
> > response thinking this was an xfs-only test...
> 
> Oh, my bad, I forgot to change the "_supported_fs xfs" to "generic".
> 
> > 
> > > @@ -0,0 +1,42 @@
> > > +#! /bin/bash
> > > +# SPDX-License-Identifier: GPL-2.0
> > > +# Copyright (c) 2022 Red Hat, Inc.  All Rights Reserved.
> > > +#
> > > +# FS QA Test No. 999
> > > +#
> > > +# Test an issue in the truncate codepath where on-disk inode sizes are logged
> > > +# prematurely via the free eofblocks path on file close.
> > > +#
> > > +. ./common/preamble
> > > +_begin_fstest auto quick shutdown
> > > +
> > > +# real QA test starts here
> > > +_supported_fs xfs
> > > +_require_scratch
> > > +_require_scratch_shutdown
> > > +_scratch_mkfs > $seqres.full 2>&1
> > > +_scratch_mount
> > > +
> > > +echo "Create many small files with one extent at least"
> > > +for ((i=0; i<10000; i++));do
> > > +	$XFS_IO_PROG -f -c "pwrite 0 4k" $SCRATCH_MNT/file.$i >/dev/null 2>&1
> > > +done
> > > +
> > > +echo "Shutdown the fs suddently"
> > > +_scratch_shutdown
> > > +
> > > +echo "Cycle mount"
> > > +_scratch_cycle_mount
> > > +
> > > +echo "Check file's (di_size > 0) extents"
> > > +for f in $(find $SCRATCH_MNT -type f -size +0);do
> > > +	# Check if the file has any extent
> > > +	if [ "$(stat -c "%b" $f)" = "0" ];then
> > > +		echo " - $f get no extents, but its di_size > 0"
> > > +		break
> > > +	fi
> > > +done
> > 
> > ...so whereas I was trying to suggest that you could use the GETFSXATTR
> > ioctl to return the extent count:
> > 
> > $XFS_IO_PROG -c stat $f | grep fsxattr.nextents | awk '{print $3}'
> > 
> > But that won't work outside of XFS.  To make this generic, I think you
> > have to do something like:
> > 
> > $FILEFRAG_PROG -v $f | wc -l
> 
> I'm wondering if we must check extent is 0, how about check allocated block = 0?
> I tried [ "$(stat -c "%b" $f)" = "0" ], it fails on old kernel without this bug
> fix, and test passed on new kernel. Does that make sense for you?

What if an LSM (e.g. selinux) attach enough security attrs to push the
xattr data into an external block?  I don't think that happens often for
XFS, but I think it will for ext3 with 128byte inodes.

--D

> Thanks,
> Zorro
> 
> > 
> > to see if there are any extents.
> > 
> > --D
> > 
> > > +
> > > +# success, all done
> > > +status=0
> > > +exit
> > > diff --git a/tests/generic/999.out b/tests/generic/999.out
> > > new file mode 100644
> > > index 00000000..50008783
> > > --- /dev/null
> > > +++ b/tests/generic/999.out
> > > @@ -0,0 +1,5 @@
> > > +QA output created by 999
> > > +Create many small files with one extent at least
> > > +Shutdown the fs suddently
> > > +Cycle mount
> > > +Check file's (di_size > 0) extents
> > > -- 
> > > 2.31.1
> > > 
> > 
> 
