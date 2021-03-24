Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8D92C433C1
	for <linux-xfs@archiver.kernel.org>; Wed, 24 Mar 2021 12:58:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A4D9561A0B
	for <linux-xfs@archiver.kernel.org>; Wed, 24 Mar 2021 12:58:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234669AbhCXM6E (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 24 Mar 2021 08:58:04 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:48188 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234343AbhCXM5y (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 24 Mar 2021 08:57:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616590672;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=C9KpXD5ex3kEvrLgVXeuh+s0ObmxKcdQXr8oYSx5pqY=;
        b=ao7K/BCIvUPxRwTG5W7phojxtPUJIjJ8SqdXNGHKW+KxTBZmYvYW6CUhEA7XUh+1ykfk7J
        y6cTHYAVKdK9xTusWv2bkhjoqfQNVc5NA82eauj0441viL9ZM8GXQ6O+83pJ7nxCcPY+Fl
        MH8G8ujeaQ4WlKyEyYtUSBjwhQZM25A=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-96-S4y-NMbuNO-WJtSMnctRbg-1; Wed, 24 Mar 2021 08:57:50 -0400
X-MC-Unique: S4y-NMbuNO-WJtSMnctRbg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0875F108BD06;
        Wed, 24 Mar 2021 12:57:49 +0000 (UTC)
Received: from bfoster (ovpn-113-24.rdu2.redhat.com [10.10.113.24])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id F0B8D1972B;
        Wed, 24 Mar 2021 12:57:47 +0000 (UTC)
Date:   Wed, 24 Mar 2021 08:57:46 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     guaneryu@gmail.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org, guan@eryu.me
Subject: Re: [PATCH 3/3] xfs: test inobtcount upgrade
Message-ID: <YFs3StgzVH6Y7XfJ@bfoster>
References: <161647324459.3431131.16341235245632737552.stgit@magnolia>
 <161647326120.3431131.9588272913557202987.stgit@magnolia>
 <YFn3hck7nYCwhfK3@bfoster>
 <20210323185403.GM22100@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210323185403.GM22100@magnolia>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Mar 23, 2021 at 11:54:03AM -0700, Darrick J. Wong wrote:
> On Tue, Mar 23, 2021 at 10:13:25AM -0400, Brian Foster wrote:
> > On Mon, Mar 22, 2021 at 09:21:01PM -0700, Darrick J. Wong wrote:
> > > From: Darrick J. Wong <djwong@kernel.org>
> > > 
> > > Make sure we can actually upgrade filesystems to support inode btree
> > > counters.
> > > 
> > > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > > ---
> > >  common/xfs        |   20 ++++++
> > >  tests/xfs/764     |  190 +++++++++++++++++++++++++++++++++++++++++++++++++++++
> > >  tests/xfs/764.out |   27 ++++++++
> > >  tests/xfs/910     |   84 +++++++++++++++++++++++
> > >  tests/xfs/910.out |   12 +++
> > >  tests/xfs/group   |    2 +
> > >  6 files changed, 335 insertions(+)
> > >  create mode 100755 tests/xfs/764
> > >  create mode 100644 tests/xfs/764.out
> > >  create mode 100755 tests/xfs/910
> > >  create mode 100644 tests/xfs/910.out
> > > 
> > > 
> > > diff --git a/common/xfs b/common/xfs
> > > index 9cb373ba..a316f384 100644
> > > --- a/common/xfs
> > > +++ b/common/xfs
> > > @@ -1085,3 +1085,23 @@ _require_xfs_copy()
> > >  	[ "$USE_EXTERNAL" = yes ] && \
> > >  		_notrun "Cannot xfs_copy with external devices"
> > >  }
> > > +
> > > +_require_xfs_repair_upgrade()
> > > +{
> > > +	local type="$1"
> > > +
> > > +	$XFS_REPAIR_PROG -c "$type=narf" 2>&1 | \
> > 
> > narf?
> 
> Not A Real Flag?
> 
> I'm checking to see if repair knows about a feature upgrade by seeding
> it with a garbage value to see if the error that repair spits back is
> about the feature being unrecognised or about the value not making any
> sense.
> 

Ok.

> > > +		grep -q 'unknown option' && \
> > > +		_notrun "xfs_repair does not support upgrading fs with $type"
> > > +}
> > > +
> > > +_require_xfs_scratch_inobtcount()
> > > +{
> > > +	_require_scratch
> > > +
> > > +	_scratch_mkfs -m inobtcount=1 &> /dev/null || \
> > > +		_notrun "mkfs.xfs doesn't have inobtcount feature"
> > > +	_try_scratch_mount || \
> > > +		_notrun "inobtcount not supported by scratch filesystem type: $FSTYP"
> > > +	_scratch_unmount
> > > +}
> > > diff --git a/tests/xfs/764 b/tests/xfs/764
> > > new file mode 100755
> > > index 00000000..cf6784d2
> > > --- /dev/null
> > > +++ b/tests/xfs/764
> > > @@ -0,0 +1,190 @@
> > > +#! /bin/bash
> > > +# SPDX-License-Identifier: GPL-2.0-or-later
> > > +# Copyright (c) 2021 Oracle.  All Rights Reserved.
> > > +#
> > > +# FS QA Test No. 764
> > > +#
> > > +# Functional testing for xfs_admin -O, which is a new switch that enables us to
> > > +# add features to an existing filesystem.  In these test scenarios, we try to
> > > +# add the inode btree counter 'feature' to the filesystem, and make sure that
> > > +# NEEDSREPAIR (aka the thing that prevents us from mounting after an upgrade
> > > +# fails) is clear if the upgraded succeeds and set if it fails.
> > > +#
> > > +# The first scenario tests that we can't add inobtcount to the V4 format,
> > > +# which is now deprecated.
> > > +#
> > > +# The middle five scenarios ensure that xfs_admin -O works even when external
> > > +# log devices and realtime volumes are specified.  This part is purely an
> > > +# exerciser for the userspace tools; kernel support for those features is not
> > > +# required.
> > > +#
> > > +# The last scenario uses a xfs_repair debug knob to simulate failure during an
> > > +# inobtcount upgrade, then checks that mounts fail when the flag is enabled,
> > > +# that repair clears the flag, and mount works after repair.
...
> > > +seq=`basename $0`
> > > +seqres=$RESULT_DIR/$seq
> > > +echo "QA output created by $seq"
> > > +
> > > +here=`pwd`
> > > +tmp=/tmp/$$
> > > +status=1    # failure is the default!
> > > +trap "_cleanup; exit \$status" 0 1 2 3 15
> > > +
> > > +_cleanup()
> > > +{
> > > +	cd /
> > > +	rm -f $tmp.* $fake_logfile $fake_rtfile
> > > +}
> > > +
> > > +# get standard environment, filters and checks
> > > +. ./common/rc
> > > +. ./common/filter
> > > +
> > > +# real QA test starts here
> > > +_supported_fs xfs
> > > +_require_test
> > > +_require_xfs_scratch_inobtcount
> > > +_require_command "$XFS_ADMIN_PROG" "xfs_admin"
> > > +_require_xfs_repair_upgrade inobtcount
> > > +
> > > +rm -f $seqres.full
> > > +
> > > +note() {
> > > +	echo "$@" | tee -a $seqres.full
> > > +}
> > > +
> > > +note "S1: Cannot add inobtcount to a V4 fs"
> > > +_scratch_mkfs -m crc=0 >> $seqres.full
> > > +_scratch_xfs_admin -O inobtcount=1 2>> $seqres.full
> > > +
> > > +# Middle five scenarios: Make sure upgrades work with various external device
> > > +# configurations.
> > > +note "S2: Check that setting with xfs_admin + logdev works"
> > > +fake_logfile=$TEST_DIR/scratch.log
> > > +rm -f $fake_logfile
> > > +truncate -s 500m $fake_logfile
> > > +
> > > +old_external=$USE_EXTERNAL
> > > +old_logdev=$SCRATCH_LOGDEV
> > > +USE_EXTERNAL=yes
> > > +SCRATCH_LOGDEV=$fake_logfile
> > > +
> > > +_scratch_mkfs -m crc=1,inobtcount=0 >> $seqres.full
> > > +_scratch_xfs_admin -O inobtcount=1 2>> $seqres.full
> > > +_scratch_xfs_db -c 'version' | grep -q NEEDSREPAIR && \
> > > +	echo "xfs_admin should have cleared needsrepair?"
> > > +_scratch_xfs_db -c 'version' | grep -q INOBTCNT || \
> > > +	echo "xfs_admin should have set inobtcount?"
> > > +
> > > +note "Check clean"
> > > +_scratch_xfs_repair -n &>> $seqres.full || echo "Check failed?"
> > > +
> > > +USE_EXTERNAL=$old_external
> > > +SCRATCH_LOGDEV=$old_logdev
> > > +
> > > +note "S3: Check that setting with xfs_admin + realtime works"
> > > +fake_rtfile=$TEST_DIR/scratch.rt
> > > +rm -f $fake_rtfile
> > > +truncate -s 500m $fake_rtfile
> > > +
> > > +old_external=$USE_EXTERNAL
> > > +old_rtdev=$SCRATCH_RTDEV
> > > +USE_EXTERNAL=yes
> > > +SCRATCH_RTDEV=$fake_rtfile
> > > +
> > > +_scratch_mkfs -m crc=1,inobtcount=0 >> $seqres.full
> > > +_scratch_xfs_admin -O inobtcount=1 2>> $seqres.full
> > > +_scratch_xfs_db -c 'version' | grep -q NEEDSREPAIR && \
> > > +	echo "xfs_admin should have cleared needsrepair?"
> > > +_scratch_xfs_db -c 'version' | grep -q INOBTCNT || \
> > > +	echo "xfs_admin should have set inobtcount?"
> > > +
> > > +note "Check clean"
> > > +_scratch_xfs_repair -n &>> $seqres.full || echo "Check failed?"
> > > +
> > > +USE_EXTERNAL=$old_external
> > > +SCRATCH_RTDEV=$old_rtdev
> > > +
> > > +note "S4: Check that setting with xfs_admin + realtime + logdev works"
> > > +old_external=$USE_EXTERNAL
> > > +old_logdev=$SCRATCH_LOGDEV
> > > +old_rtdev=$SCRATCH_RTDEV
> > > +USE_EXTERNAL=yes
> > > +SCRATCH_LOGDEV=$fake_logfile
> > > +SCRATCH_RTDEV=$fake_rtfile
> > > +
> > > +_scratch_mkfs -m crc=1,inobtcount=0 >> $seqres.full
> > > +_scratch_xfs_admin -O inobtcount=1 2>> $seqres.full
> > > +_scratch_xfs_db -c 'version' | grep -q NEEDSREPAIR && \
> > > +	echo "xfs_admin should have cleared needsrepair?"
> > > +_scratch_xfs_db -c 'version' | grep -q INOBTCNT || \
> > > +	echo "xfs_admin should have set inobtcount?"
> > > +
> > > +note "Check clean"
> > > +_scratch_xfs_repair -n &>> $seqres.full || echo "Check failed?"
> > > +
> > > +USE_EXTERNAL=$old_external
> > > +SCRATCH_LOGDEV=$old_logdev
> > > +SCRATCH_RTDEV=$old_rtdev
> > > +
> > > +note "S5: Check that setting with xfs_admin + nortdev + nologdev works"
> > > +old_external=$USE_EXTERNAL
> > > +old_logdev=$SCRATCH_LOGDEV
> > > +old_rtdev=$SCRATCH_RTDEV
> > > +USE_EXTERNAL=
> > > +SCRATCH_LOGDEV=
> > > +SCRATCH_RTDEV=
> > > +
> > > +_scratch_mkfs -m crc=1,inobtcount=0 >> $seqres.full
> > > +_scratch_xfs_admin -O inobtcount=1 2>> $seqres.full
> > > +_scratch_xfs_db -c 'version' | grep -q NEEDSREPAIR && \
> > > +	echo "xfs_admin should have cleared needsrepair?"
> > > +_scratch_xfs_db -c 'version' | grep -q INOBTCNT || \
> > > +	echo "xfs_admin should have set inobtcount?"
> > > +
> > > +note "Check clean"
> > > +_scratch_xfs_repair -n &>> $seqres.full || echo "Check failed?"
> > > +
> > > +USE_EXTERNAL=$old_external
> > > +SCRATCH_LOGDEV=$old_logdev
> > > +SCRATCH_RTDEV=$old_rtdev
> > > +
> > 
> > There's a lot of eye crossing copy-paste going on here. Do we really
> > need to always test these varying configurations?
> 
> Yes, because it just uncovered a bug in a rare xfs_admin use case.
> 

I don't see how that's relevant. I suspect if all tests did this kind of
dynamic configuration modification, we'd probably uncover odd bugs just
the same. Perhaps the same goes for anybody who might run with this
configuration in the first place.

ISTM individual tests are historically meant to be fairly focused. I.e.,
run some test or workload against the provided configuration. I know
some tests technically violate that when they target a specific feature
or something like a mount option, for example, but even some of those
instances can probably be removed over time as certain features become
more predominant than when the test was originally written (i.e., if we
have any tests that explicitly format to v5 or with any features that
have become enabled by default for a significant period of time).

> > My general expectation
> > for fstests has always been to primarily test the configuration
> > specified in the config file. ISTM this test could be legitimately
> > reduced to S1, S6 and S7. That might also mitigate the need for 'note'
> > markers in the golden output, fwiw.
> 
> I wouldn't be opposed to pushing S2-S5 to a separate test case to
> isolate the synthesized external volume tests, if Eryu wants them to be
> separate...?
> 

Why not leave this to runtime configuration vs more unnecessary test
code?

I'll defer to Eryu regardless, but this just stands out as inconsistent
with the usage model IMO. I suppose to split it out into a separate test
might be better than not, but I'm not sure that new test should be part
of the auto regression group at least (maybe an external log group or
some such for targeted log testing?).

> > > +# Run our test with the test runner's config last so that the post-test check
> > > +# won't trip over our artificial log/rt devices
> > > +note "S6: Check that setting with xfs_admin testrunner config works"
> > > +_scratch_mkfs -m crc=1,inobtcount=0 >> $seqres.full
> > > +_scratch_xfs_admin -O inobtcount=1 2>> $seqres.full
> > > +_scratch_xfs_db -c 'version' | grep -q NEEDSREPAIR && \
> > > +	echo "xfs_admin should have cleared needsrepair?"
> > > +_scratch_xfs_db -c 'version' | grep -q INOBTCNT || \
> > > +	echo "xfs_admin should have set inobtcount?"
> > > +
> > 
> > Perhaps the above xfs_db commands could be wrapped in a helper that
> > filters on the expected version values..? I.e., even something really
> > simple that executed the grep and manually constructed a string would
> > improve readability:
> > 
> > _filter_version()
> > {
> > 	str="version "
> > 	_scratch_xfs_db -c "version" | grep -q $1 &&
> > 		str="$str $1"
> > 	echo $str
> > }
> > 
> > _scratch_mkfs ...
> > _scratch_xfs_admin ...
> > _filter_version NEEDSREPAIR
> > _filter_version INOBTCNT
> > 
> > Then the test dumps the filter output directly to the golden output such
> > that there's no need for '&& echo "didn't expect this"' logic on every
> > test.
> 
> Hm, yes, that makes sense.
> 
> > > +note "Check clean"
> > > +_scratch_xfs_repair -n &>> $seqres.full || echo "Check failed?"
> > > +
> > > +note "S7: Simulate failure during upgrade process"
> > > +_scratch_mkfs -m crc=1,inobtcount=0 >> $seqres.full
> > > +XFS_REPAIR_FAIL_AFTER_PHASE=2 _scratch_xfs_repair -c inobtcount=1 2>> $seqres.full
> > > +test $? -eq 137 || echo "repair should have been killed??"
> > > +_scratch_xfs_db -c 'version' | grep -q NEEDSREPAIR || \
> > > +	echo "needsrepair should have been set on fs"
> > > +_scratch_xfs_db -c 'version' | grep -q INOBTCNT || \
> > > +	echo "inobtcount should have been set on fs"
> > > +_try_scratch_mount &> $tmp.mount
> > > +res=$?
> > > +_filter_scratch < $tmp.mount
> > > +if [ $res -eq 0 ]; then
> > > +	echo "needsrepair should have prevented mount"
> > > +	_scratch_unmount
> > > +fi
> > > +_scratch_xfs_repair 2>> $seqres.full
> > > +_scratch_xfs_db -c 'version' | grep -q NEEDSREPAIR && \
> > > +	echo "xfs_repair should have cleared needsrepair?"
> > > +_scratch_xfs_db -c 'version' | grep -q INOBTCNT || \
> > > +	echo "xfs_admin should have set inobtcount?"
> > > +_scratch_mount
> > > +
> > > +# success, all done
> > > +status=0
> > > +exit
> > > diff --git a/tests/xfs/764.out b/tests/xfs/764.out
> > > new file mode 100644
> > > index 00000000..067639c9
> > > --- /dev/null
> > > +++ b/tests/xfs/764.out
> > > @@ -0,0 +1,27 @@
> > > +QA output created by 764
> > > +S1: Cannot add inobtcount to a V4 fs
> > > +Running xfs_repair to upgrade filesystem.
> > > +Inode btree count feature only supported on V5 filesystems.
> > > +S2: Check that setting with xfs_admin + logdev works
> > > +Running xfs_repair to upgrade filesystem.
> > > +Adding inode btree counts to filesystem.
> > > +Check clean
> > > +S3: Check that setting with xfs_admin + realtime works
> > > +Running xfs_repair to upgrade filesystem.
> > > +Adding inode btree counts to filesystem.
> > > +Check clean
> > > +S4: Check that setting with xfs_admin + realtime + logdev works
> > > +Running xfs_repair to upgrade filesystem.
> > > +Adding inode btree counts to filesystem.
> > > +Check clean
> > > +S5: Check that setting with xfs_admin + nortdev + nologdev works
> > > +Running xfs_repair to upgrade filesystem.
> > > +Adding inode btree counts to filesystem.
> > > +Check clean
> > > +S6: Check that setting with xfs_admin testrunner config works
> > > +Running xfs_repair to upgrade filesystem.
> > > +Adding inode btree counts to filesystem.
> > > +Check clean
> > > +S7: Simulate failure during upgrade process
> > > +Adding inode btree counts to filesystem.
> > > +mount: SCRATCH_MNT: mount(2) system call failed: Structure needs cleaning.
> > > diff --git a/tests/xfs/910 b/tests/xfs/910
> > > new file mode 100755
> > > index 00000000..4bf79db2
> > > --- /dev/null
> > > +++ b/tests/xfs/910
> > > @@ -0,0 +1,84 @@
> > > +#! /bin/bash
> > > +# SPDX-License-Identifier: GPL-2.0-or-later
> > > +# Copyright (c) 2021 Oracle.  All Rights Reserved.
> > > +#
> > > +# FS QA Test No. 910
> > > +#
> > > +# Check that we can upgrade a filesystem to support inobtcount and that
> > > +# everything works properly after the upgrade.
> > > +
> > > +seq=`basename $0`
> > > +seqres=$RESULT_DIR/$seq
> > > +echo "QA output created by $seq"
> > > +
> > > +here=`pwd`
> > > +tmp=/tmp/$$
> > > +status=1    # failure is the default!
> > > +trap "_cleanup; exit \$status" 0 1 2 3 15
> > > +
> > > +_cleanup()
> > > +{
> > > +	cd /
> > > +	rm -f $tmp.*
> > > +}
> > > +
> > > +# get standard environment, filters and checks
> > > +. ./common/rc
> > > +. ./common/filter
> > > +
> > > +# real QA test starts here
> > > +_supported_fs xfs
> > > +_require_xfs_scratch_inobtcount
> > > +_require_command "$XFS_ADMIN_PROG" "xfs_admin"
> > > +_require_xfs_repair_upgrade inobtcount
> > > +
> > > +rm -f $seqres.full
> > > +
> > > +# Make sure we can't format a filesystem with inobtcount and not finobt.
> > > +_scratch_mkfs -m crc=1,inobtcount=1,finobt=0 &> $seqres.full && \
> > > +	echo "Should not be able to format with inobtcount but not finobt."
> > > +
> > > +# Make sure we can't upgrade a V4 filesystem
> > > +_scratch_mkfs -m crc=0,inobtcount=0,finobt=0 >> $seqres.full
> > > +_scratch_xfs_admin -O inobtcount=1 2>> $seqres.full
> > > +_scratch_xfs_db -c 'version' | grep -q INOBTCNT && \
> > > +	echo "Should not be able to upgrade to inobtcount without V5."
> > > +
> > > +# Make sure we can't upgrade a filesystem to inobtcount without finobt.
> > > +_scratch_mkfs -m crc=1,inobtcount=0,finobt=0 >> $seqres.full
> > > +_scratch_xfs_admin -O inobtcount=1 2>> $seqres.full
> > > +_scratch_xfs_db -c 'version' | grep -q INOBTCNT && \
> > > +	echo "Should not be able to upgrade to inobtcount without finobt."
> > > +
> > > +# Format V5 filesystem without inode btree counter support and populate it
> > > +_scratch_mkfs -m crc=1,inobtcount=0 >> $seqres.full
> > > +_scratch_xfs_db -c 'version' -c 'sb 0' -c 'p' >> $seqres.full
> > > +_scratch_mount >> $seqres.full
> > > +
> > > +echo moo > $SCRATCH_MNT/urk
> > > +
> > > +_scratch_unmount
> > > +_check_scratch_fs
> > > +
> > > +# Now upgrade to inobtcount support
> > > +_scratch_xfs_admin -O inobtcount=1 2>> $seqres.full
> > > +_scratch_xfs_db -c 'version' | grep -q INOBTCNT || \
> > > +	echo "Cannot detect new feature?"
> > > +_check_scratch_fs
> > > +_scratch_xfs_db -c 'version' -c 'sb 0' -c 'p' -c 'agi 0' -c 'p' >> $seqres.full
> > > +
> > 
> > Isn't this essentially the same core feature upgrade test as 764 with
> > some minor additional logic (i.e., create a file, check counters)? From
> > the group update below it seems like maybe 764 is intended to be a
> > generic repair test while this is intended to target inobtcount, but
> > there seems to be quite a lot of overlap here...
> 
> No, they're not the same test.  As the description for xfs/764 points
> out, that test is functional testing for the -O switch to xfs_admin.
> It ensures that we covered basic functionality and that the argument
> passing logic in that shell script works well enough that there's an
> observable change in state.
> 

Hm, Ok. Perhaps I'm a little confused by the fact that they rely on the
same feature, but I'm still wondering whether a generic "test the -O
switch" test is necessary if it basically takes the same actions as
the feature oriented test. Logically it sort of makes sense, it just
seems like a bit of overkill to have multiple tests running the same
functional commands to check some slightly different things given the
time it takes for a full regression test run lately.

(BTW, separate patches for separate tests please. I completely missed
this was even part of the patch in my first pass through it.)

Brian

> xfs/910 by contrast tests upgrading a filesystem to inobtcount and
> checking that the kernel will recognise an upgraded filesystem and that
> it actually writes inode btree counts to the AGI.
> 
> In other words, the first test is purely a test of userspace tooling
> that ensures that xfs_admin can handle different kinds of filesystems,
> and the second test make sure that an inobtcount upgrade actually works.
> 
> --D
> 
> > 
> > Brian
> > 
> > > +# Make sure we have nonzero counters
> > > +_scratch_xfs_db -c 'agi 0' -c 'print ino_blocks fino_blocks' | \
> > > +	sed -e 's/= [1-9]*/= NONZERO/g'
> > > +
> > > +# Mount again, look at our files
> > > +_scratch_mount >> $seqres.full
> > > +cat $SCRATCH_MNT/urk
> > > +
> > > +# Make sure we can't re-add inobtcount
> > > +_scratch_unmount
> > > +_scratch_xfs_admin -O inobtcount=1 2>> $seqres.full
> > > +_scratch_mount >> $seqres.full
> > > +
> > > +status=0
> > > +exit
> > > diff --git a/tests/xfs/910.out b/tests/xfs/910.out
> > > new file mode 100644
> > > index 00000000..c3cfbb80
> > > --- /dev/null
> > > +++ b/tests/xfs/910.out
> > > @@ -0,0 +1,12 @@
> > > +QA output created by 910
> > > +Running xfs_repair to upgrade filesystem.
> > > +Inode btree count feature only supported on V5 filesystems.
> > > +Running xfs_repair to upgrade filesystem.
> > > +Inode btree count feature requires free inode btree.
> > > +Running xfs_repair to upgrade filesystem.
> > > +Adding inode btree counts to filesystem.
> > > +ino_blocks = NONZERO
> > > +fino_blocks = NONZERO
> > > +moo
> > > +Running xfs_repair to upgrade filesystem.
> > > +Filesystem already has inode btree counts.
> > > diff --git a/tests/xfs/group b/tests/xfs/group
> > > index 6aa7883e..28176409 100644
> > > --- a/tests/xfs/group
> > > +++ b/tests/xfs/group
> > > @@ -517,7 +517,9 @@
> > >  538 auto stress
> > >  759 auto quick rw realtime
> > >  760 auto quick rw realtime collapse insert unshare zero prealloc
> > > +764 auto quick repair
> > >  768 auto quick repair
> > >  770 auto repair
> > > +910 auto quick inobtcount
> > >  917 auto quick db
> > >  918 auto quick db
> > > 
> > 
> 

