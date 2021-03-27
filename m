Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6597C433E0
	for <linux-xfs@archiver.kernel.org>; Sat, 27 Mar 2021 14:37:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AD37F619FC
	for <linux-xfs@archiver.kernel.org>; Sat, 27 Mar 2021 14:37:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230178AbhC0Oga (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 27 Mar 2021 10:36:30 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:26765 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230139AbhC0OgF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 27 Mar 2021 10:36:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616855764;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=fCHhhGB8/sunDx81zJB9Vzn5+WDjZMbECs/hCktc8SU=;
        b=K/CP1CyBngmPpRpRliyF+na3FstJfRxGHf/fNOGM/ZmMjZQ53Qh3NLzyP01UQHQRIG/0hE
        JObVXMS+wDTRjSAZlLrwwpXe65kcQrKJeX/hr96QhZqD514y9DpmDKdKIWIGtKZuuJTLUu
        A1WIAv164mvue1hHFfvmni27w8wcAu8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-416-LEavgu02M0KynHwokUwLaw-1; Sat, 27 Mar 2021 10:36:02 -0400
X-MC-Unique: LEavgu02M0KynHwokUwLaw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 76FDD802B40;
        Sat, 27 Mar 2021 14:36:01 +0000 (UTC)
Received: from bfoster (ovpn-112-117.rdu2.redhat.com [10.10.112.117])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 88E3760C5C;
        Sat, 27 Mar 2021 14:36:00 +0000 (UTC)
Date:   Sat, 27 Mar 2021 10:35:58 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     guaneryu@gmail.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org, guan@eryu.me
Subject: Re: [PATCH 3/3] xfs: test inobtcount upgrade
Message-ID: <YF9Czrd2sJFpjEDl@bfoster>
References: <161647324459.3431131.16341235245632737552.stgit@magnolia>
 <161647326120.3431131.9588272913557202987.stgit@magnolia>
 <YFn3hck7nYCwhfK3@bfoster>
 <20210323185403.GM22100@magnolia>
 <YFs3StgzVH6Y7XfJ@bfoster>
 <20210326023644.GN1670408@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210326023644.GN1670408@magnolia>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Mar 25, 2021 at 07:36:44PM -0700, Darrick J. Wong wrote:
> On Wed, Mar 24, 2021 at 08:57:46AM -0400, Brian Foster wrote:
> > On Tue, Mar 23, 2021 at 11:54:03AM -0700, Darrick J. Wong wrote:
> > > On Tue, Mar 23, 2021 at 10:13:25AM -0400, Brian Foster wrote:
> > > > On Mon, Mar 22, 2021 at 09:21:01PM -0700, Darrick J. Wong wrote:
> > > > > From: Darrick J. Wong <djwong@kernel.org>
> > > > > 
> > > > > Make sure we can actually upgrade filesystems to support inode btree
> > > > > counters.
> > > > > 
> > > > > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > > > > ---
> > > > >  common/xfs        |   20 ++++++
> > > > >  tests/xfs/764     |  190 +++++++++++++++++++++++++++++++++++++++++++++++++++++
> > > > >  tests/xfs/764.out |   27 ++++++++
> > > > >  tests/xfs/910     |   84 +++++++++++++++++++++++
> > > > >  tests/xfs/910.out |   12 +++
> > > > >  tests/xfs/group   |    2 +
> > > > >  6 files changed, 335 insertions(+)
> > > > >  create mode 100755 tests/xfs/764
> > > > >  create mode 100644 tests/xfs/764.out
> > > > >  create mode 100755 tests/xfs/910
> > > > >  create mode 100644 tests/xfs/910.out
> > > > > 
> > > > > 
> > > > > diff --git a/common/xfs b/common/xfs
> > > > > index 9cb373ba..a316f384 100644
> > > > > --- a/common/xfs
> > > > > +++ b/common/xfs
> > > > > @@ -1085,3 +1085,23 @@ _require_xfs_copy()
> > > > >  	[ "$USE_EXTERNAL" = yes ] && \
> > > > >  		_notrun "Cannot xfs_copy with external devices"
> > > > >  }
> > > > > +
> > > > > +_require_xfs_repair_upgrade()
> > > > > +{
> > > > > +	local type="$1"
> > > > > +
> > > > > +	$XFS_REPAIR_PROG -c "$type=narf" 2>&1 | \
> > > > 
> > > > narf?
> > > 
> > > Not A Real Flag?
> > > 
> > > I'm checking to see if repair knows about a feature upgrade by seeding
> > > it with a garbage value to see if the error that repair spits back is
> > > about the feature being unrecognised or about the value not making any
> > > sense.
> > > 
> > 
> > Ok.
> > 
> > > > > +		grep -q 'unknown option' && \
> > > > > +		_notrun "xfs_repair does not support upgrading fs with $type"
> > > > > +}
> > > > > +
> > > > > +_require_xfs_scratch_inobtcount()
> > > > > +{
> > > > > +	_require_scratch
> > > > > +
> > > > > +	_scratch_mkfs -m inobtcount=1 &> /dev/null || \
> > > > > +		_notrun "mkfs.xfs doesn't have inobtcount feature"
> > > > > +	_try_scratch_mount || \
> > > > > +		_notrun "inobtcount not supported by scratch filesystem type: $FSTYP"
> > > > > +	_scratch_unmount
> > > > > +}
> > > > > diff --git a/tests/xfs/764 b/tests/xfs/764
> > > > > new file mode 100755
> > > > > index 00000000..cf6784d2
> > > > > --- /dev/null
> > > > > +++ b/tests/xfs/764
> > > > > @@ -0,0 +1,190 @@
> > > > > +#! /bin/bash
> > > > > +# SPDX-License-Identifier: GPL-2.0-or-later
> > > > > +# Copyright (c) 2021 Oracle.  All Rights Reserved.
> > > > > +#
> > > > > +# FS QA Test No. 764
> > > > > +#
> > > > > +# Functional testing for xfs_admin -O, which is a new switch that enables us to
> > > > > +# add features to an existing filesystem.  In these test scenarios, we try to
> > > > > +# add the inode btree counter 'feature' to the filesystem, and make sure that
> > > > > +# NEEDSREPAIR (aka the thing that prevents us from mounting after an upgrade
> > > > > +# fails) is clear if the upgraded succeeds and set if it fails.
> > > > > +#
> > > > > +# The first scenario tests that we can't add inobtcount to the V4 format,
> > > > > +# which is now deprecated.
> > > > > +#
> > > > > +# The middle five scenarios ensure that xfs_admin -O works even when external
> > > > > +# log devices and realtime volumes are specified.  This part is purely an
> > > > > +# exerciser for the userspace tools; kernel support for those features is not
> > > > > +# required.
> > > > > +#
> > > > > +# The last scenario uses a xfs_repair debug knob to simulate failure during an
> > > > > +# inobtcount upgrade, then checks that mounts fail when the flag is enabled,
> > > > > +# that repair clears the flag, and mount works after repair.
> > ...
> > > > > +seq=`basename $0`
> > > > > +seqres=$RESULT_DIR/$seq
> > > > > +echo "QA output created by $seq"
> > > > > +
> > > > > +here=`pwd`
> > > > > +tmp=/tmp/$$
> > > > > +status=1    # failure is the default!
> > > > > +trap "_cleanup; exit \$status" 0 1 2 3 15
> > > > > +
> > > > > +_cleanup()
> > > > > +{
> > > > > +	cd /
> > > > > +	rm -f $tmp.* $fake_logfile $fake_rtfile
> > > > > +}
> > > > > +
> > > > > +# get standard environment, filters and checks
> > > > > +. ./common/rc
> > > > > +. ./common/filter
> > > > > +
> > > > > +# real QA test starts here
> > > > > +_supported_fs xfs
> > > > > +_require_test
> > > > > +_require_xfs_scratch_inobtcount
> > > > > +_require_command "$XFS_ADMIN_PROG" "xfs_admin"
> > > > > +_require_xfs_repair_upgrade inobtcount
> > > > > +
> > > > > +rm -f $seqres.full
> > > > > +
> > > > > +note() {
> > > > > +	echo "$@" | tee -a $seqres.full
> > > > > +}
> > > > > +
> > > > > +note "S1: Cannot add inobtcount to a V4 fs"
> > > > > +_scratch_mkfs -m crc=0 >> $seqres.full
> > > > > +_scratch_xfs_admin -O inobtcount=1 2>> $seqres.full
> > > > > +
> > > > > +# Middle five scenarios: Make sure upgrades work with various external device
> > > > > +# configurations.
> > > > > +note "S2: Check that setting with xfs_admin + logdev works"
> > > > > +fake_logfile=$TEST_DIR/scratch.log
> > > > > +rm -f $fake_logfile
> > > > > +truncate -s 500m $fake_logfile
> > > > > +
> > > > > +old_external=$USE_EXTERNAL
> > > > > +old_logdev=$SCRATCH_LOGDEV
> > > > > +USE_EXTERNAL=yes
> > > > > +SCRATCH_LOGDEV=$fake_logfile
> > > > > +
> > > > > +_scratch_mkfs -m crc=1,inobtcount=0 >> $seqres.full
> > > > > +_scratch_xfs_admin -O inobtcount=1 2>> $seqres.full
> > > > > +_scratch_xfs_db -c 'version' | grep -q NEEDSREPAIR && \
> > > > > +	echo "xfs_admin should have cleared needsrepair?"
> > > > > +_scratch_xfs_db -c 'version' | grep -q INOBTCNT || \
> > > > > +	echo "xfs_admin should have set inobtcount?"
> > > > > +
> > > > > +note "Check clean"
> > > > > +_scratch_xfs_repair -n &>> $seqres.full || echo "Check failed?"
> > > > > +
> > > > > +USE_EXTERNAL=$old_external
> > > > > +SCRATCH_LOGDEV=$old_logdev
> > > > > +
> > > > > +note "S3: Check that setting with xfs_admin + realtime works"
> > > > > +fake_rtfile=$TEST_DIR/scratch.rt
> > > > > +rm -f $fake_rtfile
> > > > > +truncate -s 500m $fake_rtfile
> > > > > +
> > > > > +old_external=$USE_EXTERNAL
> > > > > +old_rtdev=$SCRATCH_RTDEV
> > > > > +USE_EXTERNAL=yes
> > > > > +SCRATCH_RTDEV=$fake_rtfile
> > > > > +
> > > > > +_scratch_mkfs -m crc=1,inobtcount=0 >> $seqres.full
> > > > > +_scratch_xfs_admin -O inobtcount=1 2>> $seqres.full
> > > > > +_scratch_xfs_db -c 'version' | grep -q NEEDSREPAIR && \
> > > > > +	echo "xfs_admin should have cleared needsrepair?"
> > > > > +_scratch_xfs_db -c 'version' | grep -q INOBTCNT || \
> > > > > +	echo "xfs_admin should have set inobtcount?"
> > > > > +
> > > > > +note "Check clean"
> > > > > +_scratch_xfs_repair -n &>> $seqres.full || echo "Check failed?"
> > > > > +
> > > > > +USE_EXTERNAL=$old_external
> > > > > +SCRATCH_RTDEV=$old_rtdev
> > > > > +
> > > > > +note "S4: Check that setting with xfs_admin + realtime + logdev works"
> > > > > +old_external=$USE_EXTERNAL
> > > > > +old_logdev=$SCRATCH_LOGDEV
> > > > > +old_rtdev=$SCRATCH_RTDEV
> > > > > +USE_EXTERNAL=yes
> > > > > +SCRATCH_LOGDEV=$fake_logfile
> > > > > +SCRATCH_RTDEV=$fake_rtfile
> > > > > +
> > > > > +_scratch_mkfs -m crc=1,inobtcount=0 >> $seqres.full
> > > > > +_scratch_xfs_admin -O inobtcount=1 2>> $seqres.full
> > > > > +_scratch_xfs_db -c 'version' | grep -q NEEDSREPAIR && \
> > > > > +	echo "xfs_admin should have cleared needsrepair?"
> > > > > +_scratch_xfs_db -c 'version' | grep -q INOBTCNT || \
> > > > > +	echo "xfs_admin should have set inobtcount?"
> > > > > +
> > > > > +note "Check clean"
> > > > > +_scratch_xfs_repair -n &>> $seqres.full || echo "Check failed?"
> > > > > +
> > > > > +USE_EXTERNAL=$old_external
> > > > > +SCRATCH_LOGDEV=$old_logdev
> > > > > +SCRATCH_RTDEV=$old_rtdev
> > > > > +
> > > > > +note "S5: Check that setting with xfs_admin + nortdev + nologdev works"
> > > > > +old_external=$USE_EXTERNAL
> > > > > +old_logdev=$SCRATCH_LOGDEV
> > > > > +old_rtdev=$SCRATCH_RTDEV
> > > > > +USE_EXTERNAL=
> > > > > +SCRATCH_LOGDEV=
> > > > > +SCRATCH_RTDEV=
> > > > > +
> > > > > +_scratch_mkfs -m crc=1,inobtcount=0 >> $seqres.full
> > > > > +_scratch_xfs_admin -O inobtcount=1 2>> $seqres.full
> > > > > +_scratch_xfs_db -c 'version' | grep -q NEEDSREPAIR && \
> > > > > +	echo "xfs_admin should have cleared needsrepair?"
> > > > > +_scratch_xfs_db -c 'version' | grep -q INOBTCNT || \
> > > > > +	echo "xfs_admin should have set inobtcount?"
> > > > > +
> > > > > +note "Check clean"
> > > > > +_scratch_xfs_repair -n &>> $seqres.full || echo "Check failed?"
> > > > > +
> > > > > +USE_EXTERNAL=$old_external
> > > > > +SCRATCH_LOGDEV=$old_logdev
> > > > > +SCRATCH_RTDEV=$old_rtdev
> > > > > +
> > > > 
> > > > There's a lot of eye crossing copy-paste going on here. Do we really
> > > > need to always test these varying configurations?
> > > 
> > > Yes, because it just uncovered a bug in a rare xfs_admin use case.
> > > 
> > 
> > I don't see how that's relevant. I suspect if all tests did this kind of
> > dynamic configuration modification, we'd probably uncover odd bugs just
> > the same. Perhaps the same goes for anybody who might run with this
> > configuration in the first place.
> 
> I disagree.  I think that whenever we can make it easy to test small
> parts of rarely used functionality on rarely used configurations, we
> ought to.  I don't think I'd feel that way if I had a stronger sense
> that these exotic configurations were getting tested by the community
> on a regular basis.
> 

I think it's reasonable for a test focused on various arguments/modes of
an application to do such things. If that's the intent here, that just
wasn't clear to me from the current construction of the tests. I.e., it
seems to me there's a mix of testing feature functionality, feature
compatibility and various params etc. that makes it difficult to
determine the purpose of the test (or more specifically, the difference
in purpose between the two). Perhaps further separation will make things
more clear.

> As it is, I manage to run things like realtime and external log configs
> about once every other week.  That includes triaging every regression I
> see to figure out if it's merely a flawed test or if it's a real bug in
> the kernel/userspace, coding up fixes, and slowly pushing them out.
> Despite this, every time I crack open those weird configs, I nearly
> always find /something/.
> 
> Aside from the occasional complaints from the FB kernel team about
> problems with realtime volumes, I rarely see anyone else proposing fixes
> for rt or even just complaining that it's broken.  I /never/ see people
> complaining about external logs clashing with fstests.  Compare this to
> the default configurations -- those should be well tested, but we
> regularly get complaints and patches and new tests.
> 
> So the conclusion I draw is that either the code in the dark corners of
> XFS is 98% perfect, or NOBODY'S TESTING THIS STUFF.
> 
> > ISTM individual tests are historically meant to be fairly focused. I.e.,
> > run some test or workload against the provided configuration. I know
> > some tests technically violate that when they target a specific feature
> > or something like a mount option, for example, but even some of those
> > instances can probably be removed over time as certain features become
> > more predominant than when the test was originally written (i.e., if we
> > have any tests that explicitly format to v5 or with any features that
> > have become enabled by default for a significant period of time).
> > 
> > > > My general expectation
> > > > for fstests has always been to primarily test the configuration
> > > > specified in the config file. ISTM this test could be legitimately
> > > > reduced to S1, S6 and S7. That might also mitigate the need for 'note'
> > > > markers in the golden output, fwiw.
> > > 
> > > I wouldn't be opposed to pushing S2-S5 to a separate test case to
> > > isolate the synthesized external volume tests, if Eryu wants them to be
> > > separate...?
> > > 
> > 
> > Why not leave this to runtime configuration vs more unnecessary test
> > code?
> 
> I will if you're volunteering time to help run fstests through realtime
> and external logs and report / fix whatever shakes out?  You don't have
> to do /all/ of it, just spread out the work a bit more.
> 

Heh, I barely have enough time for meaningful development work as it is.
I generally don't use or test realtime. Any time I've played with it in
the past it's been pretty much broken.

I do occasionally take a similar approach for logging and/or shutdown
functionality because the tests that tend to trigger problems in such
code don't do so on-demand. So inevitably things break over time, QE
finds a problem in one of the associated stress tests that usually takes
a while to reproduce, and then one or more of those related tests end up
reproducing multiple similar problems. I'll usually try to use that as
an opportunity to run those tests in the background for a couple weeks
or so and try to work through any issues that might have creeped in
since the last go around. I don't mind trying to incorporate more
external log testing in those sequences if that would be of help.

Brian

> > I'll defer to Eryu regardless, but this just stands out as inconsistent
> > with the usage model IMO. I suppose to split it out into a separate test
> > might be better than not, but I'm not sure that new test should be part
> > of the auto regression group at least (maybe an external log group or
> > some such for targeted log testing?).
> >
> > > > > +# Run our test with the test runner's config last so that the post-test check
> > > > > +# won't trip over our artificial log/rt devices
> > > > > +note "S6: Check that setting with xfs_admin testrunner config works"
> > > > > +_scratch_mkfs -m crc=1,inobtcount=0 >> $seqres.full
> > > > > +_scratch_xfs_admin -O inobtcount=1 2>> $seqres.full
> > > > > +_scratch_xfs_db -c 'version' | grep -q NEEDSREPAIR && \
> > > > > +	echo "xfs_admin should have cleared needsrepair?"
> > > > > +_scratch_xfs_db -c 'version' | grep -q INOBTCNT || \
> > > > > +	echo "xfs_admin should have set inobtcount?"
> > > > > +
> > > > 
> > > > Perhaps the above xfs_db commands could be wrapped in a helper that
> > > > filters on the expected version values..? I.e., even something really
> > > > simple that executed the grep and manually constructed a string would
> > > > improve readability:
> > > > 
> > > > _filter_version()
> > > > {
> > > > 	str="version "
> > > > 	_scratch_xfs_db -c "version" | grep -q $1 &&
> > > > 		str="$str $1"
> > > > 	echo $str
> > > > }
> > > > 
> > > > _scratch_mkfs ...
> > > > _scratch_xfs_admin ...
> > > > _filter_version NEEDSREPAIR
> > > > _filter_version INOBTCNT
> > > > 
> > > > Then the test dumps the filter output directly to the golden output such
> > > > that there's no need for '&& echo "didn't expect this"' logic on every
> > > > test.
> > > 
> > > Hm, yes, that makes sense.
> > > 
> > > > > +note "Check clean"
> > > > > +_scratch_xfs_repair -n &>> $seqres.full || echo "Check failed?"
> > > > > +
> > > > > +note "S7: Simulate failure during upgrade process"
> > > > > +_scratch_mkfs -m crc=1,inobtcount=0 >> $seqres.full
> > > > > +XFS_REPAIR_FAIL_AFTER_PHASE=2 _scratch_xfs_repair -c inobtcount=1 2>> $seqres.full
> > > > > +test $? -eq 137 || echo "repair should have been killed??"
> > > > > +_scratch_xfs_db -c 'version' | grep -q NEEDSREPAIR || \
> > > > > +	echo "needsrepair should have been set on fs"
> > > > > +_scratch_xfs_db -c 'version' | grep -q INOBTCNT || \
> > > > > +	echo "inobtcount should have been set on fs"
> > > > > +_try_scratch_mount &> $tmp.mount
> > > > > +res=$?
> > > > > +_filter_scratch < $tmp.mount
> > > > > +if [ $res -eq 0 ]; then
> > > > > +	echo "needsrepair should have prevented mount"
> > > > > +	_scratch_unmount
> > > > > +fi
> > > > > +_scratch_xfs_repair 2>> $seqres.full
> > > > > +_scratch_xfs_db -c 'version' | grep -q NEEDSREPAIR && \
> > > > > +	echo "xfs_repair should have cleared needsrepair?"
> > > > > +_scratch_xfs_db -c 'version' | grep -q INOBTCNT || \
> > > > > +	echo "xfs_admin should have set inobtcount?"
> > > > > +_scratch_mount
> > > > > +
> > > > > +# success, all done
> > > > > +status=0
> > > > > +exit
> > > > > diff --git a/tests/xfs/764.out b/tests/xfs/764.out
> > > > > new file mode 100644
> > > > > index 00000000..067639c9
> > > > > --- /dev/null
> > > > > +++ b/tests/xfs/764.out
> > > > > @@ -0,0 +1,27 @@
> > > > > +QA output created by 764
> > > > > +S1: Cannot add inobtcount to a V4 fs
> > > > > +Running xfs_repair to upgrade filesystem.
> > > > > +Inode btree count feature only supported on V5 filesystems.
> > > > > +S2: Check that setting with xfs_admin + logdev works
> > > > > +Running xfs_repair to upgrade filesystem.
> > > > > +Adding inode btree counts to filesystem.
> > > > > +Check clean
> > > > > +S3: Check that setting with xfs_admin + realtime works
> > > > > +Running xfs_repair to upgrade filesystem.
> > > > > +Adding inode btree counts to filesystem.
> > > > > +Check clean
> > > > > +S4: Check that setting with xfs_admin + realtime + logdev works
> > > > > +Running xfs_repair to upgrade filesystem.
> > > > > +Adding inode btree counts to filesystem.
> > > > > +Check clean
> > > > > +S5: Check that setting with xfs_admin + nortdev + nologdev works
> > > > > +Running xfs_repair to upgrade filesystem.
> > > > > +Adding inode btree counts to filesystem.
> > > > > +Check clean
> > > > > +S6: Check that setting with xfs_admin testrunner config works
> > > > > +Running xfs_repair to upgrade filesystem.
> > > > > +Adding inode btree counts to filesystem.
> > > > > +Check clean
> > > > > +S7: Simulate failure during upgrade process
> > > > > +Adding inode btree counts to filesystem.
> > > > > +mount: SCRATCH_MNT: mount(2) system call failed: Structure needs cleaning.
> > > > > diff --git a/tests/xfs/910 b/tests/xfs/910
> > > > > new file mode 100755
> > > > > index 00000000..4bf79db2
> > > > > --- /dev/null
> > > > > +++ b/tests/xfs/910
> > > > > @@ -0,0 +1,84 @@
> > > > > +#! /bin/bash
> > > > > +# SPDX-License-Identifier: GPL-2.0-or-later
> > > > > +# Copyright (c) 2021 Oracle.  All Rights Reserved.
> > > > > +#
> > > > > +# FS QA Test No. 910
> > > > > +#
> > > > > +# Check that we can upgrade a filesystem to support inobtcount and that
> > > > > +# everything works properly after the upgrade.
> > > > > +
> > > > > +seq=`basename $0`
> > > > > +seqres=$RESULT_DIR/$seq
> > > > > +echo "QA output created by $seq"
> > > > > +
> > > > > +here=`pwd`
> > > > > +tmp=/tmp/$$
> > > > > +status=1    # failure is the default!
> > > > > +trap "_cleanup; exit \$status" 0 1 2 3 15
> > > > > +
> > > > > +_cleanup()
> > > > > +{
> > > > > +	cd /
> > > > > +	rm -f $tmp.*
> > > > > +}
> > > > > +
> > > > > +# get standard environment, filters and checks
> > > > > +. ./common/rc
> > > > > +. ./common/filter
> > > > > +
> > > > > +# real QA test starts here
> > > > > +_supported_fs xfs
> > > > > +_require_xfs_scratch_inobtcount
> > > > > +_require_command "$XFS_ADMIN_PROG" "xfs_admin"
> > > > > +_require_xfs_repair_upgrade inobtcount
> > > > > +
> > > > > +rm -f $seqres.full
> > > > > +
> > > > > +# Make sure we can't format a filesystem with inobtcount and not finobt.
> > > > > +_scratch_mkfs -m crc=1,inobtcount=1,finobt=0 &> $seqres.full && \
> > > > > +	echo "Should not be able to format with inobtcount but not finobt."
> > > > > +
> > > > > +# Make sure we can't upgrade a V4 filesystem
> > > > > +_scratch_mkfs -m crc=0,inobtcount=0,finobt=0 >> $seqres.full
> > > > > +_scratch_xfs_admin -O inobtcount=1 2>> $seqres.full
> > > > > +_scratch_xfs_db -c 'version' | grep -q INOBTCNT && \
> > > > > +	echo "Should not be able to upgrade to inobtcount without V5."
> > > > > +
> > > > > +# Make sure we can't upgrade a filesystem to inobtcount without finobt.
> > > > > +_scratch_mkfs -m crc=1,inobtcount=0,finobt=0 >> $seqres.full
> > > > > +_scratch_xfs_admin -O inobtcount=1 2>> $seqres.full
> > > > > +_scratch_xfs_db -c 'version' | grep -q INOBTCNT && \
> > > > > +	echo "Should not be able to upgrade to inobtcount without finobt."
> > > > > +
> > > > > +# Format V5 filesystem without inode btree counter support and populate it
> > > > > +_scratch_mkfs -m crc=1,inobtcount=0 >> $seqres.full
> > > > > +_scratch_xfs_db -c 'version' -c 'sb 0' -c 'p' >> $seqres.full
> > > > > +_scratch_mount >> $seqres.full
> > > > > +
> > > > > +echo moo > $SCRATCH_MNT/urk
> > > > > +
> > > > > +_scratch_unmount
> > > > > +_check_scratch_fs
> > > > > +
> > > > > +# Now upgrade to inobtcount support
> > > > > +_scratch_xfs_admin -O inobtcount=1 2>> $seqres.full
> > > > > +_scratch_xfs_db -c 'version' | grep -q INOBTCNT || \
> > > > > +	echo "Cannot detect new feature?"
> > > > > +_check_scratch_fs
> > > > > +_scratch_xfs_db -c 'version' -c 'sb 0' -c 'p' -c 'agi 0' -c 'p' >> $seqres.full
> > > > > +
> > > > 
> > > > Isn't this essentially the same core feature upgrade test as 764 with
> > > > some minor additional logic (i.e., create a file, check counters)? From
> > > > the group update below it seems like maybe 764 is intended to be a
> > > > generic repair test while this is intended to target inobtcount, but
> > > > there seems to be quite a lot of overlap here...
> > > 
> > > No, they're not the same test.  As the description for xfs/764 points
> > > out, that test is functional testing for the -O switch to xfs_admin.
> > > It ensures that we covered basic functionality and that the argument
> > > passing logic in that shell script works well enough that there's an
> > > observable change in state.
> > > 
> > 
> > Hm, Ok. Perhaps I'm a little confused by the fact that they rely on the
> > same feature, but I'm still wondering whether a generic "test the -O
> > switch" test is necessary if it basically takes the same actions as
> > the feature oriented test. Logically it sort of makes sense, it just
> > seems like a bit of overkill to have multiple tests running the same
> > functional commands to check some slightly different things given the
> > time it takes for a full regression test run lately.
> > 
> > (BTW, separate patches for separate tests please. I completely missed
> > this was even part of the patch in my first pass through it.)
> 
> All right, I've split these into separate patches -- the first patch has
> one test to check that all the xfs_admin switches (before -O) relevant
> to V5 filesystems actually work properly, and a second test for the
> synthesized realtime/log volumes; and the second patch contains a single
> test to test inobtcount upgrades.
> 
> --D
> 
> > Brian
> > 
> > > xfs/910 by contrast tests upgrading a filesystem to inobtcount and
> > > checking that the kernel will recognise an upgraded filesystem and that
> > > it actually writes inode btree counts to the AGI.
> > > 
> > > In other words, the first test is purely a test of userspace tooling
> > > that ensures that xfs_admin can handle different kinds of filesystems,
> > > and the second test make sure that an inobtcount upgrade actually works.
> > > 
> > > --D
> > > 
> > > > 
> > > > Brian
> > > > 
> > > > > +# Make sure we have nonzero counters
> > > > > +_scratch_xfs_db -c 'agi 0' -c 'print ino_blocks fino_blocks' | \
> > > > > +	sed -e 's/= [1-9]*/= NONZERO/g'
> > > > > +
> > > > > +# Mount again, look at our files
> > > > > +_scratch_mount >> $seqres.full
> > > > > +cat $SCRATCH_MNT/urk
> > > > > +
> > > > > +# Make sure we can't re-add inobtcount
> > > > > +_scratch_unmount
> > > > > +_scratch_xfs_admin -O inobtcount=1 2>> $seqres.full
> > > > > +_scratch_mount >> $seqres.full
> > > > > +
> > > > > +status=0
> > > > > +exit
> > > > > diff --git a/tests/xfs/910.out b/tests/xfs/910.out
> > > > > new file mode 100644
> > > > > index 00000000..c3cfbb80
> > > > > --- /dev/null
> > > > > +++ b/tests/xfs/910.out
> > > > > @@ -0,0 +1,12 @@
> > > > > +QA output created by 910
> > > > > +Running xfs_repair to upgrade filesystem.
> > > > > +Inode btree count feature only supported on V5 filesystems.
> > > > > +Running xfs_repair to upgrade filesystem.
> > > > > +Inode btree count feature requires free inode btree.
> > > > > +Running xfs_repair to upgrade filesystem.
> > > > > +Adding inode btree counts to filesystem.
> > > > > +ino_blocks = NONZERO
> > > > > +fino_blocks = NONZERO
> > > > > +moo
> > > > > +Running xfs_repair to upgrade filesystem.
> > > > > +Filesystem already has inode btree counts.
> > > > > diff --git a/tests/xfs/group b/tests/xfs/group
> > > > > index 6aa7883e..28176409 100644
> > > > > --- a/tests/xfs/group
> > > > > +++ b/tests/xfs/group
> > > > > @@ -517,7 +517,9 @@
> > > > >  538 auto stress
> > > > >  759 auto quick rw realtime
> > > > >  760 auto quick rw realtime collapse insert unshare zero prealloc
> > > > > +764 auto quick repair
> > > > >  768 auto quick repair
> > > > >  770 auto repair
> > > > > +910 auto quick inobtcount
> > > > >  917 auto quick db
> > > > >  918 auto quick db
> > > > > 
> > > > 
> > > 
> > 
> 

