Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3A9B3E558C;
	Mon,  9 Mar 2026 18:03:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773079390; cv=none; b=jxr6MLm8kEeQhmtAwiwYAHUtEweMSEa2hcjTBW8Wkc7+IyfRDJPgBqZ8Y8EgMsZOUvh6B8PwS+qZbIAaeEyBWqhFd5Pkp9pZFUgkoXiS5V/Kne30cXvBE2B3HV2e8+iQrA8KMO8fGhSm3kyGwPgVy7BI2sG2oWoQrE+8jGjXC0g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773079390; c=relaxed/simple;
	bh=0FfRCf4Ed0R4kQ4TPJho5itvmIRD9sr30fXDJDZjn2c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lVtT4d3nzeMWud6R5fA8CGrjC6dav/S+KE3jfdiwk0JE23ZffisN6+YUslvbdpZrkcv3z4On+58CaPpldp4Z3dA0cm8c36e8WWbKO+GGeIz9FnHdU+FqYkOTivH4dDdr1PZDevtw5yXI+mqExU2pb6Jt8kQ5Go7RYaL5CzC3jvA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gY56th23; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gY56th23"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89628C4CEF7;
	Mon,  9 Mar 2026 18:03:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773079389;
	bh=0FfRCf4Ed0R4kQ4TPJho5itvmIRD9sr30fXDJDZjn2c=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=gY56th237tyzGR1QcThymtNskNFXgV0WWYSiaY+k5qITt7y2Z0HUsYjaaHF7QzO0E
	 15tsHk+pUr5kx0KF5BRQyKhDezKCCaPjeonHsRMLelXaAHZutyBlr1Y2l0KIyY9ixR
	 33Mjgml1aWViA5rgsyxDKSFSRTB/XXldbLfygBF/SlcbgqZPzu8Gnh8Dy+df4q9/N7
	 vg8dBJVfhqKWA+RzVREOlFqCLo8qlZfeYFWCH88t05XTNQAEhSn6Abn5hjqPKx8bvO
	 xXzi7MOwVkBm8ZuPkFJXv3Po2kRTR5qMrDG293KaimKEqOLkqpDZg4w89RPFesXVZd
	 rHbv9lY8pedKQ==
Date: Mon, 9 Mar 2026 11:03:09 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Zorro Lang <zlang@redhat.com>
Cc: hch@lst.de, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 01/13] xfs: test health monitoring code
Message-ID: <20260309180309.GA6069@frogsfrogsfrogs>
References: <177249785709.483507.8373602184765043420.stgit@frogsfrogsfrogs>
 <177249785787.483507.3326797286262755687.stgit@frogsfrogsfrogs>
 <20260309172114.4pi7d4y4n2pprfzm@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260309172114.4pi7d4y4n2pprfzm@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>

On Tue, Mar 10, 2026 at 01:21:14AM +0800, Zorro Lang wrote:
> On Mon, Mar 02, 2026 at 04:41:07PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Add some functionality tests for the new health monitoring code.
> > 
> > Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
> > ---
> >  doc/group-names.txt |    1 +
> >  tests/xfs/1885      |   53 +++++++++++++++++++++++++++++++++++++++++++++++++++
> >  tests/xfs/1885.out  |    5 +++++
> >  3 files changed, 59 insertions(+)
> >  create mode 100755 tests/xfs/1885
> >  create mode 100644 tests/xfs/1885.out
> > 
> > 
> > diff --git a/doc/group-names.txt b/doc/group-names.txt
> > index 10b49e50517797..158f84d36d3154 100644
> > --- a/doc/group-names.txt
> > +++ b/doc/group-names.txt
> > @@ -117,6 +117,7 @@ samefs			overlayfs when all layers are on the same fs
> >  scrub			filesystem metadata scrubbers
> >  seed			btrfs seeded filesystems
> >  seek			llseek functionality
> > +selfhealing		self healing filesystem code
> >  selftest		tests with fixed results, used to validate testing setup
> >  send			btrfs send/receive
> >  shrinkfs		decreasing the size of a filesystem
> > diff --git a/tests/xfs/1885 b/tests/xfs/1885
> > new file mode 100755
> > index 00000000000000..1d75ef19c7c9d9
> > --- /dev/null
> > +++ b/tests/xfs/1885
> > @@ -0,0 +1,53 @@
> > +#! /bin/bash
> > +# SPDX-License-Identifier: GPL-2.0
> > +# Copyright (c) 2024-2026 Oracle.  All Rights Reserved.
> > +#
> > +# FS QA Test 1885
> > +#
> > +# Make sure that healthmon handles module refcount correctly.
> > +#
> > +. ./common/preamble
> > +_begin_fstest auto selfhealing
> 
> I found this test is quick enough, how about add it into "quick" group.

OK.

> > +
> > +. ./common/filter
> > +. ./common/module
> 
> Which helper is this "module" file being included for?

I think at one point I would rmmod/modprobe the module to force the
refcount leak issue, but discovered there's a sysfs knob for that...

> > +
> > +refcount_file="/sys/module/xfs/refcnt"
> > +test -e "$refcount_file" || _notrun "cannot find xfs module refcount"
> 
> Or did you intend to add this part as a helper into common/module?

...so this probably should get refactored into a new helper.

> > +
> > +_require_test
> > +_require_xfs_io_command healthmon
> > +
> > +# Capture mod refcount without the test fs mounted
> > +_test_unmount
> > +init_refcount="$(cat "$refcount_file")"
> > +
> > +# Capture mod refcount with the test fs mounted
> > +_test_mount
> > +nomon_mount_refcount="$(cat "$refcount_file")"
> > +
> > +# Capture mod refcount with test fs mounted and the healthmon fd open.
> > +# Pause the xfs_io process so that it doesn't actually respond to events.
> > +$XFS_IO_PROG -c 'healthmon -c -v' $TEST_DIR >> $seqres.full &
> > +sleep 0.5
> > +kill -STOP %1
> > +mon_mount_refcount="$(cat "$refcount_file")"
> > +
> > +# Capture mod refcount with only the healthmon fd open.
> > +_test_unmount
> > +mon_nomount_refcount="$(cat "$refcount_file")"
> > +
> > +# Capture mod refcount after continuing healthmon (which should exit due to the
> > +# unmount) and killing it.
> > +kill -CONT %1
> > +kill %1
> > +wait
> 
> We typically ensure that background processes are handled within the _cleanup function.

oops, will clean that up.

$XFS_IO_PROG -c 'healthmon -c -v' $TEST_DIR >> $seqres.full &
healer_pid=$!
...
kill $healer_pid

etc.  Thanks for pointing that out.

--D

> > +nomon_nomount_refcount="$(cat "$refcount_file")"
> > +
> > +_within_tolerance "mount refcount" "$nomon_mount_refcount" "$((init_refcount + 1))" 0 -v
> > +_within_tolerance "mount + healthmon refcount" "$mon_mount_refcount" "$((init_refcount + 2))" 0 -v
> > +_within_tolerance "healthmon refcount" "$mon_nomount_refcount" "$((init_refcount + 1))" 0 -v
> > +_within_tolerance "end refcount" "$nomon_nomount_refcount" "$init_refcount" 0 -v
> > +
> > +status=0
> > +exit
> 
> _exit 0
> 
> > diff --git a/tests/xfs/1885.out b/tests/xfs/1885.out
> > new file mode 100644
> > index 00000000000000..f152cef0525609
> > --- /dev/null
> > +++ b/tests/xfs/1885.out
> > @@ -0,0 +1,5 @@
> > +QA output created by 1885
> > +mount refcount is in range
> > +mount + healthmon refcount is in range
> > +healthmon refcount is in range
> > +end refcount is in range
> > 
> 
