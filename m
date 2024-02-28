Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DAE2134AA;
	Wed, 28 Feb 2024 01:28:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709083734; cv=none; b=ZKYZXxPxjtuLKHvB9sumjHRAY4sTKgP29h3Tj/G9B6nGLYl6IIWM22Vl6hh7iGGUzrSLPemtGzum+Q8eovDNlOcO/2cIxhnItGL6hRQZ6o1SYVUhJ4aDzp30dZQ8qNA7cAkoAzHkvFV0sxW5GtyI+1MXOO/nlah8I/0G2PAd0c8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709083734; c=relaxed/simple;
	bh=mJIyXgq7NJlUGy858hYY2U4as+zElxADenKfRL8W5ME=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UjPwfJk5x4/vUebNiEmwvXzXw748e5QZUDvpdqi4k9HaW9Czj2dNgIis+LALfViXD7kYpaNSaF+J/GE4kQZJnw5Oekuyc43qw/RmpBtFZw0ssNOr0TfpZswhxEU0PIaCffq0Bx3OIERBM3Dfcu4ND489zvNhBprHlH8QYle6h6Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EiDtgHBY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EiDtgHBY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09F05C433F1;
	Wed, 28 Feb 2024 01:28:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1709083734;
	bh=mJIyXgq7NJlUGy858hYY2U4as+zElxADenKfRL8W5ME=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=EiDtgHBYm3vdkre5OSyfrTI0tU/wdImVI8Z9bgWXGG4TPCPq0Pcf904LeDWbYwr/u
	 dUDenpPalSwxhSVWxoqr8jGT24UTWJ74A6g4NHEZebHGNGi9wgacOgHwtCsnjsur49
	 YaM3K5gDrotFpdm0oim4V66sT+k3isF0zRbTzvH1NZEBKaTFXsGJ+nc4JMiUAU+dw7
	 qmkCyJN7a0+lo4RMKetHkuweHq/fy+3XZ7SAnTCc9gdF266C5TC/cG5Uh+Aizg1q0+
	 fNtG1QkwgEakJoBwbGjI2avJmOmbWBizDdmlUT6jn8fo1x1yfEp4d7Ktl3FYw9VY/u
	 4Vjm36IIdcW1A==
Date: Tue, 27 Feb 2024 17:28:53 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Zorro Lang <zlang@redhat.com>
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 7/8] xfs/43[4-6]: make module reloading optional
Message-ID: <20240228012853.GV6188@frogsfrogsfrogs>
References: <170899915207.896550.7285890351450610430.stgit@frogsfrogsfrogs>
 <170899915319.896550.14222768162023866668.stgit@frogsfrogsfrogs>
 <20240227053136.47rc2ftu3eysmu4u@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240227053136.47rc2ftu3eysmu4u@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>

On Tue, Feb 27, 2024 at 01:31:36PM +0800, Zorro Lang wrote:
> On Mon, Feb 26, 2024 at 06:02:21PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > These three tests examine two things -- first, can xfs CoW staging
> > extent recovery handle corruptions in the refcount btree gracefully; and
> > second, can we avoid leaking incore inodes and dquots.
> > 
> > The only cheap way to check the second condition is to rmmod and
> > modprobe the XFS module, which triggers leak detection when rmmod tears
> > down the caches.  Currently, the entire test is _notrun if module
> > reloading doesn't work.
> > 
> > Unfortunately, these tests never run for the majority of XFS developers
> > because their testbeds either compile the xfs kernel driver into vmlinux
> > statically or the rootfs is xfs so the module cannot be reloaded.  The
> > author's testbed boots from NFS and does not have this limitation.
> > 
> > Because we've had repeated instances of CoW recovery regressions not
> > being caught by testing until for-next hits my machine, let's make the
> > module reloading optional in all three tests to improve coverage.
> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> >  common/module |   34 +++++++++++++++++++++++++++++-----
> >  tests/xfs/434 |    3 +--
> >  tests/xfs/435 |    3 +--
> >  tests/xfs/436 |    3 +--
> >  4 files changed, 32 insertions(+), 11 deletions(-)
> > 
> > 
> > diff --git a/common/module b/common/module
> > index 6efab71d34..f6814be34e 100644
> > --- a/common/module
> > +++ b/common/module
> > @@ -48,12 +48,15 @@ _require_loadable_module()
> >  	modprobe "${module}" || _notrun "${module} load failed"
> >  }
> >  
> > -# Check that the module for FSTYP can be loaded.
> > -_require_loadable_fs_module()
> > +# Test if the module for FSTYP can be unloaded and reloaded.
> > +#
> > +# If not, returns 1 if $FSTYP is not a loadable module; 2 if the module could
> > +# not be unloaded; or 3 if loading the module fails.
> > +_test_loadable_fs_module()
> >  {
> >  	local module="$1"
> >  
> > -	modinfo "${module}" > /dev/null 2>&1 || _notrun "${module}: must be a module."
> > +	modinfo "${module}" > /dev/null 2>&1 || return 1
> >  
> >  	# Unload test fs, try to reload module, remount
> >  	local had_testfs=""
> > @@ -68,8 +71,29 @@ _require_loadable_fs_module()
> >  	modprobe "${module}" || load_ok=0
> >  	test -n "${had_scratchfs}" && _scratch_mount 2> /dev/null
> >  	test -n "${had_testfs}" && _test_mount 2> /dev/null
> > -	test -z "${unload_ok}" || _notrun "Require module ${module} to be unloadable"
> > -	test -z "${load_ok}" || _notrun "${module} load failed"
> > +	test -z "${unload_ok}" || return 2
> > +	test -z "${load_ok}" || return 3
> > +	return 0
> > +}
> > +
> > +_require_loadable_fs_module()
> > +{
> > +	local module="$1"
> > +
> > +	_test_loadable_fs_module "${module}"
> > +	ret=$?
> > +	case "$ret" in
> > +	1)
> > +		_notrun "${module}: must be a module."
> > +		;;
> > +	2)
> > +		_notrun "${module}: module could not be unloaded"
> > +		;;
> > +	3)
> > +		_notrun "${module}: module reload failed"
> > +		;;
> > +	esac
> > +	return "${ret}"
> 
> I think nobody checks the return value of a _require_xxx helper. The
> _require helper generally notrun or keep running. So if ret=0, then
> return directly, other return values trigger different _notrun.

Ok.  It's fine to let it run off the end, then.

> >  }
> >  
> >  # Print the value of a filesystem module parameter
> > diff --git a/tests/xfs/434 b/tests/xfs/434
> > index 12d1a0c9da..ca80e12753 100755
> > --- a/tests/xfs/434
> > +++ b/tests/xfs/434
> > @@ -30,7 +30,6 @@ _begin_fstest auto quick clone fsr
> >  
> >  # real QA test starts here
> >  _supported_fs xfs
> > -_require_loadable_fs_module "xfs"
> >  _require_quota
> >  _require_scratch_reflink
> >  _require_cp_reflink
> > @@ -77,7 +76,7 @@ _scratch_unmount 2> /dev/null
> >  rm -f ${RESULT_DIR}/require_scratch
> >  
> >  echo "See if we leak"
> > -_reload_fs_module "xfs"
> > +_test_loadable_fs_module "xfs"
> >  
> >  # success, all done
> >  status=0
> > diff --git a/tests/xfs/435 b/tests/xfs/435
> > index 44135c7653..b52e9287df 100755
> > --- a/tests/xfs/435
> > +++ b/tests/xfs/435
> > @@ -24,7 +24,6 @@ _begin_fstest auto quick clone
> >  
> >  # real QA test starts here
> >  _supported_fs xfs
> > -_require_loadable_fs_module "xfs"
> >  _require_quota
> >  _require_scratch_reflink
> >  _require_cp_reflink
> > @@ -55,7 +54,7 @@ _scratch_unmount 2> /dev/null
> >  rm -f ${RESULT_DIR}/require_scratch
> >  
> >  echo "See if we leak"
> > -_reload_fs_module "xfs"
> > +_test_loadable_fs_module "xfs"
> 
> So we don't care about if the fs module reload success or not, just
> try it then keep running?

Welll... the "test" actually does everything that we wanted to do
(unmount, rmmod, modprobe, remount) so that's why I use it here.

--D

> Thanks,
> Zorro
> 
> >  
> >  # success, all done
> >  status=0
> > diff --git a/tests/xfs/436 b/tests/xfs/436
> > index d010362785..02bcd66900 100755
> > --- a/tests/xfs/436
> > +++ b/tests/xfs/436
> > @@ -27,7 +27,6 @@ _begin_fstest auto quick clone fsr
> >  
> >  # real QA test starts here
> >  _supported_fs xfs
> > -_require_loadable_fs_module "xfs"
> >  _require_scratch_reflink
> >  _require_cp_reflink
> >  _require_xfs_io_command falloc # fsr requires support for preallocation
> > @@ -72,7 +71,7 @@ _scratch_unmount 2> /dev/null
> >  rm -f ${RESULT_DIR}/require_scratch
> >  
> >  echo "See if we leak"
> > -_reload_fs_module "xfs"
> > +_test_loadable_fs_module "xfs"
> >  
> >  # success, all done
> >  status=0
> > 
> > 
> 
> 
