Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39078 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752130AbdIZKBD (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 26 Sep 2017 06:01:03 -0400
Date: Tue, 26 Sep 2017 18:01:00 +0800
From: Eryu Guan <eguan@redhat.com>
Subject: Re: [PATCH v2 1/3] xfs/realtime: Add require_no_realtime function
Message-ID: <20170926100100.GJ8034@eguan.usersys.redhat.com>
References: <20170925195625.756877-1-rwareing@fb.com>
 <20170925213845.GC5020@magnolia>
 <EF76A1C7-91D1-488E-A81F-E628F0965B1B@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <EF76A1C7-91D1-488E-A81F-E628F0965B1B@fb.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Richard Wareing <rwareing@fb.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, fstests@vger.kernel.org, linux-xfs@vger.kernel.org

On Mon, Sep 25, 2017 at 07:25:27PM -0700, Richard Wareing wrote:
> Darrick J. Wong <darrick.wong@oracle.com> wrote:
> 
> > On Mon, Sep 25, 2017 at 12:56:23PM -0700, Richard Wareing wrote:
> > > Some tests do not play well with realtime devices, in an effort to
> > > produce a stable set of test which exercise the realtime code paths
> > > we introduce a _require_no_realtime function to allow tests to opt
> > > out of realtime subvolume test runs.
> > > 
> > > Signed-off-by: Richard Wareing <rwareing@fb.com>
> > > ---
> > > Changes since v1:
> > > * None
> > > 
> > >  common/rc                      | 8 ++++++++
> > >  tests/generic/409              | 1 +
> > >  tests/generic/410              | 1 +
> > 
> > Why don't shared subtree tests work w/ rt?
> > 
> 
> 409, 410 decide to mount without the -o rtdev, option.  The fix
> here could be trivial, or more involved I'm not really sure.
> 
> 
> 
> > > tests/generic/411              | 1 +
> > 
> > Some sort of mount regression?
> > 
> 
> Same as 409/410.

It seems generic/409-411 are not hard to fix, just make _get_mount honor
$SCRATCH_OPTIONS (need to make 'type' in _scratch_options local,
otherwise 'type' in the test would be overwritten). But these three
tests are testing vfs level mount semantics, realtime or not should not
make any difference, seems not worth the effort to me.

> 
> > > tests/xfs/077                  | 1 +
> 
> Uses xfs_copy which does not have realtime support.
> 
> > >  tests/xfs/189                  | 1 +
> 
> Bails with "noattr2 mount option not supported on /dev/loop32".
> Possibly a trivial fix?

This test already _notrun with above message gracefully when testing
with rtdev set, I don't think it needs an extra no_realtime rule.

> 
> > >  tests/xfs/191-input-validation | 1 +
> 
> Fails with:
>  QA output created by 191-input-validation
>  silence is golden
> +pass -b size=512 -l sectsize=1024 /dev/loop32
> +fail -d size=4294967296 /dev/loop32
> +fail -d agsize=1g /dev/loop32
> +fail -l size=419430400 -d size=4294967296 /dev/loop32
> +pass -n ftype=0 /dev/loop32
> 
> This test makes my eyes bleed, hoping somebody with more context on
> this test can point me in the right direction here.

This test passes for me with rtdev set, I'm using latest for-next branch
of upstream xfsprogs repo. (Maybe because you're using a too small
SCRATCH_DEV?)

> 
> 
> > >  tests/xfs/202                  | 1 +
> 
> Upon further inspection, this fails because it assumes your
> scratch device is >1GB.  Though it should probably throw a nice
> error indicating your scratch device isn't large enough.

Tested with 10G SCRATCH_DEV with rtdev set, and test passed, so the
failure has nothing to do with realtime. I agreed it should _notrun if
SCRATCH_DEV doesn't have enough space, perhaps do a

_scratch_mkfs_sized $((1024 * 1024 * 1024))

first, which would _notrun gracefully if SCRATCH_DEV is smaller than 1G.

But I'd recommend testing with larger devices, 15G should be good
enough.

> 
> > >  tests/xfs/284                  | 1 +
> 
> Uses xfs_copy which does not support realtime.
> 
> > 
> > This test checks that xfsprogs don't run on a mounted fs.  Why would
> > that be excluded from rt testing?
> > 
> > Since there's only 8 tests on your list, I'm curious why each of them
> > gets disabled for rt filesystems?
> > 
> 
> Aside from the tests using xfs_copy, I can probably add RT support

For the xfs_copy tests, a comment saying why we need
_require_no_realtime would be good.

> to most of these tests, but I figured the first step was to first
> get to a  stable set of working tests for realtime.
> 
> Richard
> 
> 
> 
> > --D
> > 
> > > 9 files changed, 16 insertions(+)
> > > 
> > > diff --git a/common/rc b/common/rc
> > > index 53bbb11..a0081f1 100644
> > > --- a/common/rc
> > > +++ b/common/rc
> > > @@ -1835,6 +1835,14 @@ _require_realtime()
> > >  	_notrun "Realtime device required, skipped this test"
> > >  }
> > > 
> > > +# This test requires that a realtime subvolume is not in use
> > > +#
> > > +_require_no_realtime()
> > > +{
> > > +    [ -n "$SCRATCH_RTDEV" ] && \
> > > +	_notrun "Test not compatible with realtime subvolumes, skipped
> > > this test"

We should check if $USE_EXTERNAL is 'yes' too, SCRATCH_RTDEV alone won't
enable realtime testings.

	[ "$USE_EXTERNAL" = yes ] && [ -n "$SCRATCH_RTDEV" ] && \ ...

Thanks,
Eryu
