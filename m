Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 320EEC433FE
	for <linux-xfs@archiver.kernel.org>; Tue, 12 Apr 2022 17:58:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241756AbiDLSAs (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 12 Apr 2022 14:00:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241440AbiDLSAr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 12 Apr 2022 14:00:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B17E5A159;
        Tue, 12 Apr 2022 10:58:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ED1EC619FA;
        Tue, 12 Apr 2022 17:58:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EBE2C385A1;
        Tue, 12 Apr 2022 17:58:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649786308;
        bh=9ZaiYEy9h5IP3FP8Cm243zQw+L6FPdDKV7h2oiPzSiA=;
        h=Date:From:To:Subject:References:In-Reply-To:From;
        b=I7F3ZE6NPuHhvZ9VeJDgrmQA2BY9y8ZoXK/JljZMaryeyqw0TJNrs/p8V5lnRnK8q
         GsCeupC/GWG5GZVF52e09yG5zNgYHUS0qGn/Nj0hjX1Xqe/Lo+cZnzq5nqh0G8JKzX
         sjMBNNmLk3OoN+GJ07c6eSFxUUyEUhCXOqUEaKIIc+TbZGaqQE1DURL3ngFqKldKK6
         oAdq5/66O4/NCll8QjZ7aLK0FWFguEYYrj2scOesOXdQe00WsUgauT7Z4XDI37Bpg2
         YCD3wqPEWfmPfaRYUCZGbQfDLlAleeO97faiEC7MdmMzF7eIQi9vx8uTKf35GgxkUJ
         fwT14mUEEjPdQ==
Date:   Tue, 12 Apr 2022 10:58:27 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 4/4] generic: test that renaming into a directory fails
 with EDQUOT
Message-ID: <20220412175827.GI16799@magnolia>
References: <164971767143.169983.12905331894414458027.stgit@magnolia>
 <164971769398.169983.1284630275364529313.stgit@magnolia>
 <20220412172930.fv2uofjqxgeo5tft@zlang-mailbox>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220412172930.fv2uofjqxgeo5tft@zlang-mailbox>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Apr 13, 2022 at 01:29:30AM +0800, Zorro Lang wrote:
> On Mon, Apr 11, 2022 at 03:54:54PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Add a regression test to make sure that unprivileged userspace renaming
> > within a directory fails with EDQUOT when the directory quota limits have
> > been exceeded.
> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> >  tests/generic/833     |   71 +++++++++++++++++++++++++++++++++++++++++++++++++
> >  tests/generic/833.out |    3 ++
> >  2 files changed, 74 insertions(+)
> >  create mode 100755 tests/generic/833
> >  create mode 100644 tests/generic/833.out
> > 
> > 
> > diff --git a/tests/generic/833 b/tests/generic/833
> > new file mode 100755
> > index 00000000..a1b3cbc0
> > --- /dev/null
> > +++ b/tests/generic/833
> > @@ -0,0 +1,71 @@
> > +#! /bin/bash
> > +# SPDX-License-Identifier: GPL-2.0
> > +# Copyright (c) 2022 Oracle.  All Rights Reserved.
> > +#
> > +# FS QA Test No. 833
> > +#
> > +# Ensure that unprivileged userspace hits EDQUOT while moving files into a
> > +# directory when the directory's quota limits have been exceeded.
> > +#
> > +# Regression test for commit:
> > +#
> > +# 41667260bc84 ("xfs: reserve quota for target dir expansion when renaming files")
> > +#
> > +. ./common/preamble
> > +_begin_fstest auto quick quota
> > +
> > +# Import common functions.
> > +. ./common/filter
> > +. ./common/quota
> > +
> > +# real QA test starts here
> > +
> > +# Modify as appropriate.
> > +_supported_fs generic
> > +_require_quota
> > +_require_user
> > +_require_scratch
> > +
> > +_scratch_mkfs > "$seqres.full" 2>&1
> > +_qmount_option usrquota
> > +_qmount
> > +
> > +blocksize=$(_get_block_size $SCRATCH_MNT)
> > +scratchdir=$SCRATCH_MNT/dir
> > +scratchfile=$SCRATCH_MNT/file
> > +stagedir=$SCRATCH_MNT/staging
> > +mkdir $scratchdir $stagedir
> > +touch $scratchfile
> > +
> > +# Create a 2-block directory for our 1-block quota limit
> > +total_size=$((blocksize * 2))
> > +dirents=$((total_size / 255))
> > +
> > +for ((i = 0; i < dirents; i++)); do
> > +	name=$(printf "x%0254d" $i)
> > +	ln $scratchfile $scratchdir/$name
> > +done
> > +
> > +# Set a low quota hardlimit for an unprivileged uid and chown the files to it
> > +echo "set up quota" >> $seqres.full
> > +setquota -u $qa_user 0 "$((blocksize / 1024))" 0 0 $SCRATCH_MNT
> > +chown $qa_user $scratchdir $scratchfile
> > +repquota -upn $SCRATCH_MNT >> $seqres.full
> > +
> > +# Fail at renaming into the directory as qa_user to ensure quota enforcement
> > +# works
> > +chmod a+rwx $stagedir
> > +echo "fail quota" >> $seqres.full
> > +for ((i = 0; i < dirents; i++)); do
> > +	name=$(printf "y%0254d" $i)
> > +	ln $scratchfile $stagedir/$name
> > +	su - "$qa_user" -c "mv $stagedir/$name $scratchdir/$name" 2>&1 | \
> 
> Same as [PATCH 3/4], do we need "--login"?
> Oh, I just found there's only one case generic/128 use this option too. Anyway I
> have no reason to object it, just speak out for review:)

<nod> I have the same response as the previous patch. ;)

--D

> Thanks,
> Zorro
> 
> > +		_filter_scratch | sed -e 's/y[0-9]*/yXXX/g'
> > +	test "${PIPESTATUS[0]}" -ne 0 && break
> > +done
> > +repquota -upn $SCRATCH_MNT >> $seqres.full
> > +
> > +# success, all done
> > +echo Silence is golden
> > +status=0
> > +exit
> > diff --git a/tests/generic/833.out b/tests/generic/833.out
> > new file mode 100644
> > index 00000000..d100fa07
> > --- /dev/null
> > +++ b/tests/generic/833.out
> > @@ -0,0 +1,3 @@
> > +QA output created by 833
> > +mv: cannot move 'SCRATCH_MNT/staging/yXXX' to 'SCRATCH_MNT/dir/yXXX': Disk quota exceeded
> > +Silence is golden
> > 
> 
