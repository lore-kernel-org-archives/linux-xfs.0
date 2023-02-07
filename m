Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A23EC636D6
	for <linux-xfs@archiver.kernel.org>; Tue,  7 Feb 2023 16:58:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231395AbjBGQ6O (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 7 Feb 2023 11:58:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232136AbjBGQ6L (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 7 Feb 2023 11:58:11 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF78A3B665;
        Tue,  7 Feb 2023 08:58:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4D30060F1F;
        Tue,  7 Feb 2023 16:58:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F3F0C433EF;
        Tue,  7 Feb 2023 16:58:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675789087;
        bh=vRzExfYPH+OjbX2ZO/O1+JH0c7eZ6Uk3mkZrNx05Vn0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=N5LbOE25dB+2bLvGm2u/QqibkC37jVk1NpYp1ZsYEhpwTTXkfrT/p6s93ID7srtC0
         CqHRryo2UE4/NsS9AVjRHvFfDsKxaOccDaH54W/T616Mey0SQn8m/sdIbySrDz7tCn
         z0PCfpKjMEI1ZH5+3waAlK21s4+dr6bJ9cDnKlImMIvX911b9uJn/S/FpSxkdcpyp8
         XbkGMRLRYm9OD6KyFex9HAPDwx4/gZ/oHY779fyYAo7R8MEtpQ2flUeI4gx22diGKI
         qoBMTr2YeKxe1fgZ9GXbHDzQ2TB3Oejzumk20CqbaXtiuHhEelGb/lTRRExuzg1fsp
         MahK1TyCH1qAA==
Date:   Tue, 7 Feb 2023 08:58:07 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Zorro Lang <zlang@redhat.com>
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 2/5] xfs: race fsstress with online scrubbers for AG and
 fs metadata
Message-ID: <Y+KDHwbR6IJiHZt6@magnolia>
References: <167243874614.722028.11987534226186856347.stgit@magnolia>
 <167243874639.722028.9759938995780056273.stgit@magnolia>
 <20230205130412.ksbvasc5ih4tr4a2@zlang-mailbox>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230205130412.ksbvasc5ih4tr4a2@zlang-mailbox>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Feb 05, 2023 at 09:04:12PM +0800, Zorro Lang wrote:
> On Fri, Dec 30, 2022 at 02:19:06PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > For each XFS_SCRUB_TYPE_* that looks at AG or filesystem metadata,
> > create a test that runs that scrubber in the foreground and fsstress in
> > the background.
> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> >  common/quota        |   64 +++++++++++++++++++++++++++++++++++++++++++++++++++
> >  doc/group-names.txt |    1 +
> 
> [snip]
> 
> > diff --git a/doc/group-names.txt b/doc/group-names.txt
> > index ac219e05b3..771ce937ae 100644
> > --- a/doc/group-names.txt
> > +++ b/doc/group-names.txt
> > @@ -35,6 +35,7 @@ dangerous_fuzzers	fuzzers that can crash your computer
> >  dangerous_norepair	fuzzers to evaluate kernel metadata verifiers
> >  dangerous_online_repair	fuzzers to evaluate xfs_scrub online repair
> >  dangerous_fsstress_repair	race fsstress and xfs_scrub online repair
> > +dangerous_fsstress_scrub	race fsstress and xfs_scrub checking
> 
> We've added this group name, so this patch will hit conflict. But I think I
> can use `git am --3way ...` to apply this patch forcibly :)

Or I'll just repost this patch, since I already/always rebase everything.

--D

> Thanks,
> Zorro
> 
> >  dangerous_repair	fuzzers to evaluate xfs_repair offline repair
> >  dangerous_scrub		fuzzers to evaluate xfs_scrub checking
> >  data			data loss checkers
> > diff --git a/tests/xfs/782 b/tests/xfs/782
> > new file mode 100755
> > index 0000000000..4801eda4bd
> > --- /dev/null
> > +++ b/tests/xfs/782
> > @@ -0,0 +1,37 @@
> > +#! /bin/bash
> > +# SPDX-License-Identifier: GPL-2.0
> > +# Copyright (c) 2022 Oracle. Inc.  All Rights Reserved.
> > +#
> > +# FS QA Test No. 782
> > +#
> > +# Race fsstress and superblock scrub for a while to see if we crash or livelock.
> > +#
> > +. ./common/preamble
> > +_begin_fstest scrub dangerous_fsstress_scrub
> > +
> > +_cleanup() {
> > +	_scratch_xfs_stress_scrub_cleanup &> /dev/null
> > +	cd /
> > +	rm -r -f $tmp.*
> > +}
> > +_register_cleanup "_cleanup" BUS
> > +
> > +# Import common functions.
> > +. ./common/filter
> > +. ./common/fuzzy
> > +. ./common/inject
> > +. ./common/xfs
> > +
> > +# real QA test starts here
> > +_supported_fs xfs
> > +_require_scratch
> > +_require_xfs_stress_scrub
> > +
> > +_scratch_mkfs > "$seqres.full" 2>&1
> > +_scratch_mount
> > +_scratch_xfs_stress_scrub -s "scrub sb %agno%"
> > +
> > +# success, all done
> > +echo Silence is golden
> > +status=0
> > +exit
> > diff --git a/tests/xfs/782.out b/tests/xfs/782.out
> > new file mode 100644
> > index 0000000000..6e378f0e53
> > --- /dev/null
> > +++ b/tests/xfs/782.out
> > @@ -0,0 +1,2 @@
> > +QA output created by 782
> > +Silence is golden
> > diff --git a/tests/xfs/783 b/tests/xfs/783
> > new file mode 100755
> > index 0000000000..379a9369e5
> > --- /dev/null
> > +++ b/tests/xfs/783
> > @@ -0,0 +1,37 @@
> > +#! /bin/bash
> > +# SPDX-License-Identifier: GPL-2.0
> > +# Copyright (c) 2022 Oracle. Inc.  All Rights Reserved.
> > +#
> > +# FS QA Test No. 783
> > +#
> > +# Race fsstress and AGF scrub for a while to see if we crash or livelock.
> > +#
> > +. ./common/preamble
> > +_begin_fstest scrub dangerous_fsstress_scrub
> > +
> > +_cleanup() {
> > +	_scratch_xfs_stress_scrub_cleanup &> /dev/null
> > +	cd /
> > +	rm -r -f $tmp.*
> > +}
> > +_register_cleanup "_cleanup" BUS
> > +
> > +# Import common functions.
> > +. ./common/filter
> > +. ./common/fuzzy
> > +. ./common/inject
> > +. ./common/xfs
> > +
> > +# real QA test starts here
> > +_supported_fs xfs
> > +_require_scratch
> > +_require_xfs_stress_scrub
> > +
> > +_scratch_mkfs > "$seqres.full" 2>&1
> > +_scratch_mount
> > +_scratch_xfs_stress_scrub -s "scrub agf %agno%"
> > +
> > +# success, all done
> > +echo Silence is golden
> > +status=0
> > +exit
> > diff --git a/tests/xfs/783.out b/tests/xfs/783.out
> > new file mode 100644
> > index 0000000000..2522395956
> > --- /dev/null
> > +++ b/tests/xfs/783.out
> > @@ -0,0 +1,2 @@
> > +QA output created by 783
> > +Silence is golden
> > diff --git a/tests/xfs/784 b/tests/xfs/784
> > new file mode 100755
> > index 0000000000..2b89361c36
> > --- /dev/null
> > +++ b/tests/xfs/784
> > @@ -0,0 +1,37 @@
> > +#! /bin/bash
> > +# SPDX-License-Identifier: GPL-2.0
> > +# Copyright (c) 2022 Oracle. Inc.  All Rights Reserved.
> > +#
> > +# FS QA Test No. 784
> > +#
> > +# Race fsstress and AGFL scrub for a while to see if we crash or livelock.
> > +#
> > +. ./common/preamble
> > +_begin_fstest scrub dangerous_fsstress_scrub
> > +
> > +_cleanup() {
> > +	_scratch_xfs_stress_scrub_cleanup &> /dev/null
> > +	cd /
> > +	rm -r -f $tmp.*
> > +}
> > +_register_cleanup "_cleanup" BUS
> > +
> > +# Import common functions.
> > +. ./common/filter
> > +. ./common/fuzzy
> > +. ./common/inject
> > +. ./common/xfs
> > +
> > +# real QA test starts here
> > +_supported_fs xfs
> > +_require_scratch
> > +_require_xfs_stress_scrub
> > +
> > +_scratch_mkfs > "$seqres.full" 2>&1
> > +_scratch_mount
> > +_scratch_xfs_stress_scrub -s "scrub agfl %agno%"
> > +
> > +# success, all done
> > +echo Silence is golden
> > +status=0
> > +exit
> > diff --git a/tests/xfs/784.out b/tests/xfs/784.out
> > new file mode 100644
> > index 0000000000..48d9b24dd0
> > --- /dev/null
> > +++ b/tests/xfs/784.out
> > @@ -0,0 +1,2 @@
> > +QA output created by 784
> > +Silence is golden
> > diff --git a/tests/xfs/785 b/tests/xfs/785
> > new file mode 100755
> > index 0000000000..34a13b058d
> > --- /dev/null
> > +++ b/tests/xfs/785
> > @@ -0,0 +1,37 @@
> > +#! /bin/bash
> > +# SPDX-License-Identifier: GPL-2.0
> > +# Copyright (c) 2022 Oracle. Inc.  All Rights Reserved.
> > +#
> > +# FS QA Test No. 785
> > +#
> > +# Race fsstress and AGI scrub for a while to see if we crash or livelock.
> > +#
> > +. ./common/preamble
> > +_begin_fstest scrub dangerous_fsstress_scrub
> > +
> > +_cleanup() {
> > +	_scratch_xfs_stress_scrub_cleanup &> /dev/null
> > +	cd /
> > +	rm -r -f $tmp.*
> > +}
> > +_register_cleanup "_cleanup" BUS
> > +
> > +# Import common functions.
> > +. ./common/filter
> > +. ./common/fuzzy
> > +. ./common/inject
> > +. ./common/xfs
> > +
> > +# real QA test starts here
> > +_supported_fs xfs
> > +_require_scratch
> > +_require_xfs_stress_scrub
> > +
> > +_scratch_mkfs > "$seqres.full" 2>&1
> > +_scratch_mount
> > +_scratch_xfs_stress_scrub -s "scrub agi %agno%"
> > +
> > +# success, all done
> > +echo Silence is golden
> > +status=0
> > +exit
> > diff --git a/tests/xfs/785.out b/tests/xfs/785.out
> > new file mode 100644
> > index 0000000000..6ecb0c61b3
> > --- /dev/null
> > +++ b/tests/xfs/785.out
> > @@ -0,0 +1,2 @@
> > +QA output created by 785
> > +Silence is golden
> > diff --git a/tests/xfs/786 b/tests/xfs/786
> > new file mode 100755
> > index 0000000000..157200ea8c
> > --- /dev/null
> > +++ b/tests/xfs/786
> > @@ -0,0 +1,38 @@
> > +#! /bin/bash
> > +# SPDX-License-Identifier: GPL-2.0
> > +# Copyright (c) 2022 Oracle. Inc.  All Rights Reserved.
> > +#
> > +# FS QA Test No. 786
> > +#
> > +# Race fsstress and freespace by block btree scrub for a while to see if we
> > +# crash or livelock.
> > +#
> > +. ./common/preamble
> > +_begin_fstest scrub dangerous_fsstress_scrub
> > +
> > +_cleanup() {
> > +	_scratch_xfs_stress_scrub_cleanup &> /dev/null
> > +	cd /
> > +	rm -r -f $tmp.*
> > +}
> > +_register_cleanup "_cleanup" BUS
> > +
> > +# Import common functions.
> > +. ./common/filter
> > +. ./common/fuzzy
> > +. ./common/inject
> > +. ./common/xfs
> > +
> > +# real QA test starts here
> > +_supported_fs xfs
> > +_require_scratch
> > +_require_xfs_stress_scrub
> > +
> > +_scratch_mkfs > "$seqres.full" 2>&1
> > +_scratch_mount
> > +_scratch_xfs_stress_scrub -s "scrub bnobt %agno%"
> > +
> > +# success, all done
> > +echo Silence is golden
> > +status=0
> > +exit
> > diff --git a/tests/xfs/786.out b/tests/xfs/786.out
> > new file mode 100644
> > index 0000000000..ccb9167df9
> > --- /dev/null
> > +++ b/tests/xfs/786.out
> > @@ -0,0 +1,2 @@
> > +QA output created by 786
> > +Silence is golden
> > diff --git a/tests/xfs/787 b/tests/xfs/787
> > new file mode 100755
> > index 0000000000..91eaf5a7af
> > --- /dev/null
> > +++ b/tests/xfs/787
> > @@ -0,0 +1,38 @@
> > +#! /bin/bash
> > +# SPDX-License-Identifier: GPL-2.0
> > +# Copyright (c) 2022 Oracle. Inc.  All Rights Reserved.
> > +#
> > +# FS QA Test No. 787
> > +#
> > +# Race fsstress and free space by length btree scrub for a while to see if we
> > +# crash or livelock.
> > +#
> > +. ./common/preamble
> > +_begin_fstest scrub dangerous_fsstress_scrub
> > +
> > +_cleanup() {
> > +	_scratch_xfs_stress_scrub_cleanup &> /dev/null
> > +	cd /
> > +	rm -r -f $tmp.*
> > +}
> > +_register_cleanup "_cleanup" BUS
> > +
> > +# Import common functions.
> > +. ./common/filter
> > +. ./common/fuzzy
> > +. ./common/inject
> > +. ./common/xfs
> > +
> > +# real QA test starts here
> > +_supported_fs xfs
> > +_require_scratch
> > +_require_xfs_stress_scrub
> > +
> > +_scratch_mkfs > "$seqres.full" 2>&1
> > +_scratch_mount
> > +_scratch_xfs_stress_scrub -s "scrub cntbt %agno%"
> > +
> > +# success, all done
> > +echo Silence is golden
> > +status=0
> > +exit
> > diff --git a/tests/xfs/787.out b/tests/xfs/787.out
> > new file mode 100644
> > index 0000000000..fa7f038120
> > --- /dev/null
> > +++ b/tests/xfs/787.out
> > @@ -0,0 +1,2 @@
> > +QA output created by 787
> > +Silence is golden
> > diff --git a/tests/xfs/788 b/tests/xfs/788
> > new file mode 100755
> > index 0000000000..f1369e5309
> > --- /dev/null
> > +++ b/tests/xfs/788
> > @@ -0,0 +1,38 @@
> > +#! /bin/bash
> > +# SPDX-License-Identifier: GPL-2.0
> > +# Copyright (c) 2022 Oracle. Inc.  All Rights Reserved.
> > +#
> > +# FS QA Test No. 788
> > +#
> > +# Race fsstress and inode btree scrub for a while to see if we crash or
> > +# livelock.
> > +#
> > +. ./common/preamble
> > +_begin_fstest scrub dangerous_fsstress_scrub
> > +
> > +_cleanup() {
> > +	_scratch_xfs_stress_scrub_cleanup &> /dev/null
> > +	cd /
> > +	rm -r -f $tmp.*
> > +}
> > +_register_cleanup "_cleanup" BUS
> > +
> > +# Import common functions.
> > +. ./common/filter
> > +. ./common/fuzzy
> > +. ./common/inject
> > +. ./common/xfs
> > +
> > +# real QA test starts here
> > +_supported_fs xfs
> > +_require_scratch
> > +_require_xfs_stress_scrub
> > +
> > +_scratch_mkfs > "$seqres.full" 2>&1
> > +_scratch_mount
> > +_scratch_xfs_stress_scrub -x 'dir' -s "scrub inobt %agno%"
> > +
> > +# success, all done
> > +echo Silence is golden
> > +status=0
> > +exit
> > diff --git a/tests/xfs/788.out b/tests/xfs/788.out
> > new file mode 100644
> > index 0000000000..5ddd661113
> > --- /dev/null
> > +++ b/tests/xfs/788.out
> > @@ -0,0 +1,2 @@
> > +QA output created by 788
> > +Silence is golden
> > diff --git a/tests/xfs/789 b/tests/xfs/789
> > new file mode 100755
> > index 0000000000..550ff2c690
> > --- /dev/null
> > +++ b/tests/xfs/789
> > @@ -0,0 +1,39 @@
> > +#! /bin/bash
> > +# SPDX-License-Identifier: GPL-2.0
> > +# Copyright (c) 2022 Oracle. Inc.  All Rights Reserved.
> > +#
> > +# FS QA Test No. 789
> > +#
> > +# Race fsstress and free inode btree scrub for a while to see if we crash or
> > +# livelock.
> > +#
> > +. ./common/preamble
> > +_begin_fstest scrub dangerous_fsstress_scrub
> > +
> > +_cleanup() {
> > +	_scratch_xfs_stress_scrub_cleanup &> /dev/null
> > +	cd /
> > +	rm -r -f $tmp.*
> > +}
> > +_register_cleanup "_cleanup" BUS
> > +
> > +# Import common functions.
> > +. ./common/filter
> > +. ./common/fuzzy
> > +. ./common/inject
> > +. ./common/xfs
> > +
> > +# real QA test starts here
> > +_supported_fs xfs
> > +_require_scratch
> > +_require_xfs_stress_scrub
> > +
> > +_scratch_mkfs > "$seqres.full" 2>&1
> > +_scratch_mount
> > +_require_xfs_has_feature "$SCRATCH_MNT" finobt
> > +_scratch_xfs_stress_scrub -x 'dir' -s "scrub finobt %agno%"
> > +
> > +# success, all done
> > +echo Silence is golden
> > +status=0
> > +exit
> > diff --git a/tests/xfs/789.out b/tests/xfs/789.out
> > new file mode 100644
> > index 0000000000..da88fc99cb
> > --- /dev/null
> > +++ b/tests/xfs/789.out
> > @@ -0,0 +1,2 @@
> > +QA output created by 789
> > +Silence is golden
> > diff --git a/tests/xfs/790 b/tests/xfs/790
> > new file mode 100755
> > index 0000000000..c4e5779ef7
> > --- /dev/null
> > +++ b/tests/xfs/790
> > @@ -0,0 +1,39 @@
> > +#! /bin/bash
> > +# SPDX-License-Identifier: GPL-2.0
> > +# Copyright (c) 2022 Oracle. Inc.  All Rights Reserved.
> > +#
> > +# FS QA Test No. 790
> > +#
> > +# Race fsstress and reverse mapping btree scrub for a while to see if we crash
> > +# or livelock.
> > +#
> > +. ./common/preamble
> > +_begin_fstest scrub dangerous_fsstress_scrub
> > +
> > +_cleanup() {
> > +	_scratch_xfs_stress_scrub_cleanup &> /dev/null
> > +	cd /
> > +	rm -r -f $tmp.*
> > +}
> > +_register_cleanup "_cleanup" BUS
> > +
> > +# Import common functions.
> > +. ./common/filter
> > +. ./common/fuzzy
> > +. ./common/inject
> > +. ./common/xfs
> > +
> > +# real QA test starts here
> > +_supported_fs xfs
> > +_require_scratch
> > +_require_xfs_stress_scrub
> > +
> > +_scratch_mkfs > "$seqres.full" 2>&1
> > +_scratch_mount
> > +_require_xfs_has_feature "$SCRATCH_MNT" rmapbt
> > +_scratch_xfs_stress_scrub -s "scrub rmapbt %agno%"
> > +
> > +# success, all done
> > +echo Silence is golden
> > +status=0
> > +exit
> > diff --git a/tests/xfs/790.out b/tests/xfs/790.out
> > new file mode 100644
> > index 0000000000..7102c590f0
> > --- /dev/null
> > +++ b/tests/xfs/790.out
> > @@ -0,0 +1,2 @@
> > +QA output created by 790
> > +Silence is golden
> > diff --git a/tests/xfs/791 b/tests/xfs/791
> > new file mode 100755
> > index 0000000000..6939d910c9
> > --- /dev/null
> > +++ b/tests/xfs/791
> > @@ -0,0 +1,40 @@
> > +#! /bin/bash
> > +# SPDX-License-Identifier: GPL-2.0
> > +# Copyright (c) 2022 Oracle. Inc.  All Rights Reserved.
> > +#
> > +# FS QA Test No. 791
> > +#
> > +# Race fsstress and reference count btree scrub for a while to see if we crash
> > +# or livelock.
> > +#
> > +. ./common/preamble
> > +_begin_fstest scrub dangerous_fsstress_scrub
> > +
> > +_cleanup() {
> > +	_scratch_xfs_stress_scrub_cleanup &> /dev/null
> > +	cd /
> > +	rm -r -f $tmp.*
> > +}
> > +_register_cleanup "_cleanup" BUS
> > +
> > +# Import common functions.
> > +. ./common/filter
> > +. ./common/fuzzy
> > +. ./common/inject
> > +. ./common/xfs
> > +. ./common/reflink
> > +
> > +# real QA test starts here
> > +_supported_fs xfs
> > +_require_scratch
> > +_require_xfs_stress_scrub
> > +
> > +_scratch_mkfs > "$seqres.full" 2>&1
> > +_scratch_mount
> > +_require_xfs_has_feature "$SCRATCH_MNT" reflink
> > +_scratch_xfs_stress_scrub -s "scrub refcountbt %agno%"
> > +
> > +# success, all done
> > +echo Silence is golden
> > +status=0
> > +exit
> > diff --git a/tests/xfs/791.out b/tests/xfs/791.out
> > new file mode 100644
> > index 0000000000..758905371d
> > --- /dev/null
> > +++ b/tests/xfs/791.out
> > @@ -0,0 +1,2 @@
> > +QA output created by 791
> > +Silence is golden
> > diff --git a/tests/xfs/798 b/tests/xfs/798
> > new file mode 100755
> > index 0000000000..c5bdfad50a
> > --- /dev/null
> > +++ b/tests/xfs/798
> > @@ -0,0 +1,44 @@
> > +#! /bin/bash
> > +# SPDX-License-Identifier: GPL-2.0-or-later
> > +# Copyright (c) 2022 Oracle.  All Rights Reserved.
> > +#
> > +# FS QA Test No. 798
> > +#
> > +# Race fsstress and fscounter scrub on the realtime device for a while to see
> > +# if we crash or livelock.
> > +#
> > +. ./common/preamble
> > +_begin_fstest scrub dangerous_fsstress_scrub
> > +
> > +_cleanup() {
> > +	_scratch_xfs_stress_scrub_cleanup &> /dev/null
> > +	cd /
> > +	rm -r -f $tmp.*
> > +}
> > +_register_cleanup "_cleanup" BUS
> > +
> > +# Import common functions.
> > +. ./common/filter
> > +. ./common/fuzzy
> > +. ./common/inject
> > +. ./common/xfs
> > +
> > +# real QA test starts here
> > +_supported_fs xfs
> > +_require_realtime
> > +_require_scratch
> > +_require_xfs_stress_scrub
> > +
> > +_scratch_mkfs > "$seqres.full" 2>&1
> > +_scratch_mount
> > +_require_xfs_has_feature "$SCRATCH_MNT" realtime
> > +
> > +# Force all files to be allocated on the realtime device
> > +_xfs_force_bdev realtime $SCRATCH_MNT
> > +
> > +_scratch_xfs_stress_scrub -s 'scrub fscounters'
> > +
> > +# success, all done
> > +echo Silence is golden
> > +status=0
> > +exit
> > diff --git a/tests/xfs/798.out b/tests/xfs/798.out
> > new file mode 100644
> > index 0000000000..216d6e93f4
> > --- /dev/null
> > +++ b/tests/xfs/798.out
> > @@ -0,0 +1,2 @@
> > +QA output created by 798
> > +Silence is golden
> > diff --git a/tests/xfs/800 b/tests/xfs/800
> > new file mode 100755
> > index 0000000000..cbcfb5f5a6
> > --- /dev/null
> > +++ b/tests/xfs/800
> > @@ -0,0 +1,40 @@
> > +#! /bin/bash
> > +# SPDX-License-Identifier: GPL-2.0
> > +# Copyright (c) 2022 Oracle. Inc.  All Rights Reserved.
> > +#
> > +# FS QA Test No. 800
> > +#
> > +# Race fsstress and realtime bitmap scrub for a while to see if we crash or
> > +# livelock.
> > +#
> > +. ./common/preamble
> > +_begin_fstest scrub dangerous_fsstress_scrub
> > +
> > +_cleanup() {
> > +	_scratch_xfs_stress_scrub_cleanup &> /dev/null
> > +	cd /
> > +	rm -r -f $tmp.*
> > +}
> > +_register_cleanup "_cleanup" BUS
> > +
> > +# Import common functions.
> > +. ./common/filter
> > +. ./common/fuzzy
> > +. ./common/inject
> > +. ./common/xfs
> > +
> > +# real QA test starts here
> > +_supported_fs xfs
> > +_require_realtime
> > +_require_scratch
> > +_require_xfs_stress_scrub
> > +
> > +_scratch_mkfs > "$seqres.full" 2>&1
> > +_scratch_mount
> > +_require_xfs_has_feature "$SCRATCH_MNT" realtime
> > +_scratch_xfs_stress_scrub -s "scrub rtbitmap"
> > +
> > +# success, all done
> > +echo Silence is golden
> > +status=0
> > +exit
> > diff --git a/tests/xfs/800.out b/tests/xfs/800.out
> > new file mode 100644
> > index 0000000000..bdfaa2cecd
> > --- /dev/null
> > +++ b/tests/xfs/800.out
> > @@ -0,0 +1,2 @@
> > +QA output created by 800
> > +Silence is golden
> > diff --git a/tests/xfs/801 b/tests/xfs/801
> > new file mode 100755
> > index 0000000000..a51fab523b
> > --- /dev/null
> > +++ b/tests/xfs/801
> > @@ -0,0 +1,47 @@
> > +#! /bin/bash
> > +# SPDX-License-Identifier: GPL-2.0
> > +# Copyright (c) 2022 Oracle. Inc.  All Rights Reserved.
> > +#
> > +# FS QA Test No. 801
> > +#
> > +# Race fsstress and realtime summary scrub for a while to see if we crash or
> > +# livelock.
> > +#
> > +. ./common/preamble
> > +_begin_fstest scrub dangerous_fsstress_scrub
> > +
> > +_cleanup() {
> > +	_scratch_xfs_stress_scrub_cleanup &> /dev/null
> > +	cd /
> > +	rm -r -f $tmp.*
> > +}
> > +_register_cleanup "_cleanup" BUS
> > +
> > +# Import common functions.
> > +. ./common/filter
> > +. ./common/fuzzy
> > +. ./common/inject
> > +. ./common/xfs
> > +
> > +# real QA test starts here
> > +_supported_fs xfs
> > +_require_realtime
> > +_require_scratch
> > +_require_xfs_stress_scrub
> > +
> > +_scratch_mkfs > "$seqres.full" 2>&1
> > +_scratch_mount
> > +_require_xfs_has_feature "$SCRATCH_MNT" realtime
> > +
> > +# XXX the realtime summary scrubber isn't currently implemented upstream.
> > +# Don't bother trying to test it on those kernels
> > +$XFS_IO_PROG -c 'scrub rtsummary' -c 'scrub rtsummary' "$SCRATCH_MNT" 2>&1 | \
> > +	grep -q 'Scan was not complete' && \
> > +	_notrun "rtsummary scrub is incomplete"
> > +
> > +_scratch_xfs_stress_scrub -s "scrub rtsummary"
> > +
> > +# success, all done
> > +echo Silence is golden
> > +status=0
> > +exit
> > diff --git a/tests/xfs/801.out b/tests/xfs/801.out
> > new file mode 100644
> > index 0000000000..39481b38e2
> > --- /dev/null
> > +++ b/tests/xfs/801.out
> > @@ -0,0 +1,2 @@
> > +QA output created by 801
> > +Silence is golden
> > diff --git a/tests/xfs/802 b/tests/xfs/802
> > new file mode 100755
> > index 0000000000..1f3b83882e
> > --- /dev/null
> > +++ b/tests/xfs/802
> > @@ -0,0 +1,40 @@
> > +#! /bin/bash
> > +# SPDX-License-Identifier: GPL-2.0
> > +# Copyright (c) 2022 Oracle. Inc.  All Rights Reserved.
> > +#
> > +# FS QA Test No. 802
> > +#
> > +# Race fsstress and user quota scrub for a while to see if we crash or
> > +# livelock.
> > +#
> > +. ./common/preamble
> > +_begin_fstest scrub dangerous_fsstress_scrub
> > +
> > +_cleanup() {
> > +	_scratch_xfs_stress_scrub_cleanup &> /dev/null
> > +	cd /
> > +	rm -r -f $tmp.*
> > +}
> > +_register_cleanup "_cleanup" BUS
> > +
> > +# Import common functions.
> > +. ./common/filter
> > +. ./common/fuzzy
> > +. ./common/inject
> > +. ./common/xfs
> > +. ./common/quota
> > +
> > +# real QA test starts here
> > +_supported_fs xfs
> > +_require_scratch
> > +_require_xfs_stress_scrub
> > +
> > +_scratch_mkfs > "$seqres.full" 2>&1
> > +_scratch_mount
> > +_require_xfs_quota_acct_enabled "$SCRATCH_DEV" usrquota
> > +_scratch_xfs_stress_scrub -s "scrub usrquota"
> > +
> > +# success, all done
> > +echo Silence is golden
> > +status=0
> > +exit
> > diff --git a/tests/xfs/802.out b/tests/xfs/802.out
> > new file mode 100644
> > index 0000000000..a69c05391f
> > --- /dev/null
> > +++ b/tests/xfs/802.out
> > @@ -0,0 +1,2 @@
> > +QA output created by 802
> > +Silence is golden
> > diff --git a/tests/xfs/803 b/tests/xfs/803
> > new file mode 100755
> > index 0000000000..b2bb85672d
> > --- /dev/null
> > +++ b/tests/xfs/803
> > @@ -0,0 +1,40 @@
> > +#! /bin/bash
> > +# SPDX-License-Identifier: GPL-2.0
> > +# Copyright (c) 2022 Oracle. Inc.  All Rights Reserved.
> > +#
> > +# FS QA Test No. 803
> > +#
> > +# Race fsstress and group quota scrub for a while to see if we crash or
> > +# livelock.
> > +#
> > +. ./common/preamble
> > +_begin_fstest scrub dangerous_fsstress_scrub
> > +
> > +_cleanup() {
> > +	_scratch_xfs_stress_scrub_cleanup &> /dev/null
> > +	cd /
> > +	rm -r -f $tmp.*
> > +}
> > +_register_cleanup "_cleanup" BUS
> > +
> > +# Import common functions.
> > +. ./common/filter
> > +. ./common/fuzzy
> > +. ./common/inject
> > +. ./common/xfs
> > +. ./common/quota
> > +
> > +# real QA test starts here
> > +_supported_fs xfs
> > +_require_scratch
> > +_require_xfs_stress_scrub
> > +
> > +_scratch_mkfs > "$seqres.full" 2>&1
> > +_scratch_mount
> > +_require_xfs_quota_acct_enabled "$SCRATCH_DEV" grpquota
> > +_scratch_xfs_stress_scrub -s "scrub grpquota"
> > +
> > +# success, all done
> > +echo Silence is golden
> > +status=0
> > +exit
> > diff --git a/tests/xfs/803.out b/tests/xfs/803.out
> > new file mode 100644
> > index 0000000000..38ba741d0f
> > --- /dev/null
> > +++ b/tests/xfs/803.out
> > @@ -0,0 +1,2 @@
> > +QA output created by 803
> > +Silence is golden
> > diff --git a/tests/xfs/804 b/tests/xfs/804
> > new file mode 100755
> > index 0000000000..129724eb11
> > --- /dev/null
> > +++ b/tests/xfs/804
> > @@ -0,0 +1,40 @@
> > +#! /bin/bash
> > +# SPDX-License-Identifier: GPL-2.0
> > +# Copyright (c) 2022 Oracle. Inc.  All Rights Reserved.
> > +#
> > +# FS QA Test No. 804
> > +#
> > +# Race fsstress and project quota scrub for a while to see if we crash or
> > +# livelock.
> > +#
> > +. ./common/preamble
> > +_begin_fstest scrub dangerous_fsstress_scrub
> > +
> > +_cleanup() {
> > +	_scratch_xfs_stress_scrub_cleanup &> /dev/null
> > +	cd /
> > +	rm -r -f $tmp.*
> > +}
> > +_register_cleanup "_cleanup" BUS
> > +
> > +# Import common functions.
> > +. ./common/filter
> > +. ./common/fuzzy
> > +. ./common/inject
> > +. ./common/xfs
> > +. ./common/quota
> > +
> > +# real QA test starts here
> > +_supported_fs xfs
> > +_require_scratch
> > +_require_xfs_stress_scrub
> > +
> > +_scratch_mkfs > "$seqres.full" 2>&1
> > +_scratch_mount
> > +_require_xfs_quota_acct_enabled "$SCRATCH_DEV" prjquota
> > +_scratch_xfs_stress_scrub -s "scrub prjquota"
> > +
> > +# success, all done
> > +echo Silence is golden
> > +status=0
> > +exit
> > diff --git a/tests/xfs/804.out b/tests/xfs/804.out
> > new file mode 100644
> > index 0000000000..5e0cb437e7
> > --- /dev/null
> > +++ b/tests/xfs/804.out
> > @@ -0,0 +1,2 @@
> > +QA output created by 804
> > +Silence is golden
> > diff --git a/tests/xfs/805 b/tests/xfs/805
> > new file mode 100755
> > index 0000000000..aca9b9cdf4
> > --- /dev/null
> > +++ b/tests/xfs/805
> > @@ -0,0 +1,38 @@
> > +#! /bin/bash
> > +# SPDX-License-Identifier: GPL-2.0
> > +# Copyright (c) 2022 Oracle. Inc.  All Rights Reserved.
> > +#
> > +# FS QA Test No. 805
> > +#
> > +# Race fsstress and summary counters scrub for a while to see if we crash or
> > +# livelock.
> > +#
> > +. ./common/preamble
> > +_begin_fstest scrub dangerous_fsstress_scrub
> > +
> > +_cleanup() {
> > +	_scratch_xfs_stress_scrub_cleanup &> /dev/null
> > +	cd /
> > +	rm -r -f $tmp.*
> > +}
> > +_register_cleanup "_cleanup" BUS
> > +
> > +# Import common functions.
> > +. ./common/filter
> > +. ./common/fuzzy
> > +. ./common/inject
> > +. ./common/xfs
> > +
> > +# real QA test starts here
> > +_supported_fs xfs
> > +_require_scratch
> > +_require_xfs_stress_scrub
> > +
> > +_scratch_mkfs > "$seqres.full" 2>&1
> > +_scratch_mount
> > +_scratch_xfs_stress_scrub -s "scrub fscounters"
> > +
> > +# success, all done
> > +echo Silence is golden
> > +status=0
> > +exit
> > diff --git a/tests/xfs/805.out b/tests/xfs/805.out
> > new file mode 100644
> > index 0000000000..ac324c5874
> > --- /dev/null
> > +++ b/tests/xfs/805.out
> > @@ -0,0 +1,2 @@
> > +QA output created by 805
> > +Silence is golden
> > 
> 
