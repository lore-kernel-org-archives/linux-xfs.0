Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0BB7CC2BB41
	for <linux-xfs@archiver.kernel.org>; Tue, 16 Aug 2022 06:46:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230369AbiHPGqs (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 16 Aug 2022 02:46:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230292AbiHPGqX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 16 Aug 2022 02:46:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 080322ED70;
        Mon, 15 Aug 2022 18:47:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A0CE26068B;
        Tue, 16 Aug 2022 01:47:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08870C433C1;
        Tue, 16 Aug 2022 01:47:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660614452;
        bh=UasLdHY4c8QlD9e4a8HTUpXAtzd2OS98yy6i0gbvKI4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=kAf5MAU5YwEoybxxzu3BGLUU7IbujU9waEM9+LcLMr0bbwm7vtxsp5wmnLOFje+aG
         6F2sdX04V205VAA4LNCY5OU8AY8gWSCHVQE4Va6/fk5d7HWoQP1iSPLm+PoF2xMCBW
         XMGF7wCqvkb8jCGnsmM0PCCDXzBdRA9LVnXjByiDwNFHg58m7s7sY0wJTe33NvYWzN
         ACXXnlhsqnFSJJgu65Lyvz6L1h8IC52JSLjPdytCvT6KeYH2UFal8SGLq5Sf7/zE5T
         7gMTR1csyg4zD7KkiFJNAhEyGHrMZTZzLp3JjtXjI5TZL4qchsOCghpq1WcnaeN3a9
         y44NZ9jKDAIIQ==
Date:   Mon, 15 Aug 2022 18:47:31 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Zorro Lang <zlang@redhat.com>
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 2/3] common: disable infinite IO error retry for EIO
 shutdown tests
Message-ID: <Yvr3M8V9Tg9LQE6E@magnolia>
References: <165950054404.199222.5615656337332007333.stgit@magnolia>
 <165950055523.199222.9175019533516343488.stgit@magnolia>
 <20220815094246.iqrbfdkwzvrjbjb3@zlang-mailbox>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220815094246.iqrbfdkwzvrjbjb3@zlang-mailbox>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Aug 15, 2022 at 05:42:46PM +0800, Zorro Lang wrote:
> On Tue, Aug 02, 2022 at 09:22:35PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > This patch fixes a rather hard to hit livelock in the tests that test
> > how xfs handles shutdown behavior when the device suddenly dies and
> > starts returing EIO all the time.  The livelock happens if the AIL is
> > stuck retrying failed metadata updates forever, the log itself is not
> > being written, and there is no more log grant space, which prevents the
> > frontend from shutting down the log due to EIO errors during
> > transactions.
> > 
> > While most users probably want the default retry-forever behavior
> > because EIO can be transient, the circumstances are different here.  The
> > tests are designed to flip the device back to working status only after
> > the unmount succeeds, so we know there's no point in the filesystem
> > retrying writes until after the unmount.
> > 
> > This fixes some of the periodic hangs in generic/019 and generic/475.
> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> >  common/dmerror           |    4 ++++
> >  common/fail_make_request |    1 +
> >  common/rc                |   31 +++++++++++++++++++++++++++----
> >  common/xfs               |   29 +++++++++++++++++++++++++++++
> >  4 files changed, 61 insertions(+), 4 deletions(-)
> > 
> > 
> > diff --git a/common/dmerror b/common/dmerror
> > index 0934d220..54122b12 100644
> > --- a/common/dmerror
> > +++ b/common/dmerror
> > @@ -138,6 +138,10 @@ _dmerror_load_error_table()
> >  		suspend_opt="$*"
> >  	fi
> >  
> > +	# If the full environment is set up, configure ourselves for shutdown
> > +	type _prepare_for_eio_shutdown &>/dev/null && \
> 
> I'm wondering why we need to check if _prepare_for_eio_shutdown() is defined
> at here? This patch define this function, so if we merge this patch, this
> function is exist, right?

This mess exists because of src/dmerror, which sources common/dmerror
but does *not* source common/rc.  src/dmerror, in turn, is a helper
script that is called as a subprocess of src/fsync-err.c, which (as a C
program) doesn't inherit any of the shell data contained within its
caller (e.g. generic/441).

I probably should have documented that better, but TBH I'm not fully
convinced that I understand all this nested re-entry stuff that some of
the dmerror tests invoke.

> > +		_prepare_for_eio_shutdown $DMERROR_DEV
> 
> Hmm... what about someone load error table, but not for testing fs shutdown?

Even the tests that use dmerror but aren't looking for an fs shutdown
could trigger one anyway, because (a) timestamp updates, or (b) inodegc
running in the background.  Either way, an EIO shutdown is possible, so
we should turn off infinite retries to avoid hanging fstests.

--D

> > +
> >  	# Suspend the scratch device before the log and realtime devices so
> >  	# that the kernel can freeze and flush the filesystem if the caller
> >  	# wanted a freeze.
> > diff --git a/common/fail_make_request b/common/fail_make_request
> > index 9f8ea500..b5370ba6 100644
> > --- a/common/fail_make_request
> > +++ b/common/fail_make_request
> > @@ -44,6 +44,7 @@ _start_fail_scratch_dev()
> >  {
> >      echo "Force SCRATCH_DEV device failure"
> >  
> > +    _prepare_for_eio_shutdown $SCRATCH_DEV
> >      _bdev_fail_make_request $SCRATCH_DEV 1
> >      [ "$USE_EXTERNAL" = yes -a ! -z "$SCRATCH_LOGDEV" ] && \
> >          _bdev_fail_make_request $SCRATCH_LOGDEV 1
> > diff --git a/common/rc b/common/rc
> > index 63bafb4b..119cc477 100644
> > --- a/common/rc
> > +++ b/common/rc
> > @@ -4205,6 +4205,20 @@ _check_dmesg()
> >  	fi
> >  }
> >  
> > +# Make whatever configuration changes we need ahead of testing fs shutdowns due
> > +# to unexpected IO errors while updating metadata.  The sole parameter should
> > +# be the fs device, e.g.  $SCRATCH_DEV.
> > +_prepare_for_eio_shutdown()
> > +{
> > +	local dev="$1"
> > +
> > +	case "$FSTYP" in
> > +	"xfs")
> > +		_xfs_prepare_for_eio_shutdown "$dev"
> > +		;;
> > +	esac
> > +}
> > +
> >  # capture the kmemleak report
> >  _capture_kmemleak()
> >  {
> > @@ -4467,7 +4481,7 @@ run_fsx()
> >  #
> >  # Usage example:
> >  #   _require_fs_sysfs error/fail_at_unmount
> > -_require_fs_sysfs()
> > +_has_fs_sysfs()
> >  {
> >  	local attr=$1
> >  	local dname
> > @@ -4483,9 +4497,18 @@ _require_fs_sysfs()
> >  		_fail "Usage: _require_fs_sysfs <sysfs_attr_path>"
> >  	fi
> >  
> > -	if [ ! -e /sys/fs/${FSTYP}/${dname}/${attr} ];then
> > -		_notrun "This test requires /sys/fs/${FSTYP}/${dname}/${attr}"
> > -	fi
> > +	test -e /sys/fs/${FSTYP}/${dname}/${attr}
> > +}
> > +
> > +# Require the existence of a sysfs entry at /sys/fs/$FSTYP/DEV/$ATTR
> > +_require_fs_sysfs()
> > +{
> > +	_has_fs_sysfs "$@" && return
> > +
> > +	local attr=$1
> > +	local dname=$(_short_dev $TEST_DEV)
> > +
> > +	_notrun "This test requires /sys/fs/${FSTYP}/${dname}/${attr}"
> >  }
> >  
> >  _require_statx()
> > diff --git a/common/xfs b/common/xfs
> > index 92c281c6..65234c8b 100644
> > --- a/common/xfs
> > +++ b/common/xfs
> > @@ -823,6 +823,35 @@ _scratch_xfs_unmount_dirty()
> >  	_scratch_unmount
> >  }
> >  
> > +# Prepare a mounted filesystem for an IO error shutdown test by disabling retry
> > +# for metadata writes.  This prevents a (rare) log livelock when:
> > +#
> > +# - The log has given out all available grant space, preventing any new
> > +#   writers from tripping over IO errors (and shutting down the fs/log),
> > +# - All log buffers were written to disk, and
> > +# - The log tail is pinned because the AIL keeps hitting EIO trying to write
> > +#   committed changes back into the filesystem.
> > +#
> > +# Real users might want the default behavior of the AIL retrying writes forever
> > +# but for testing purposes we don't want to wait.
> > +#
> > +# The sole parameter should be the filesystem data device, e.g. $SCRATCH_DEV.
> > +_xfs_prepare_for_eio_shutdown()
> > +{
> > +	local dev="$1"
> > +	local ctlfile="error/fail_at_unmount"
> > +
> > +	# Don't retry any writes during the (presumably) post-shutdown unmount
> > +	_has_fs_sysfs "$ctlfile" && _set_fs_sysfs_attr $dev "$ctlfile" 1
> > +
> > +	# Disable retry of metadata writes that fail with EIO
> > +	for ctl in max_retries retry_timeout_seconds; do
> > +		ctlfile="error/metadata/EIO/$ctl"
> > +
> > +		_has_fs_sysfs "$ctlfile" && _set_fs_sysfs_attr $dev "$ctlfile" 0
> > +	done
> > +}
> > +
> >  # Skip if we are running an older binary without the stricter input checks.
> >  # Make multiple checks to be sure that there is no regression on the one
> >  # selected feature check, which would skew the result.
> > 
> 
