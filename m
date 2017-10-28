Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:56072 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750788AbdJ1FrS (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sat, 28 Oct 2017 01:47:18 -0400
Date: Sat, 28 Oct 2017 13:47:15 +0800
From: Eryu Guan <eguan@redhat.com>
Subject: Re: [PATCH v2 5/6] misc: add module reloading helpers
Message-ID: <20171028054715.GA3235@eguan.usersys.redhat.com>
References: <150899709935.18389.17266737014565285073.stgit@magnolia>
 <150899712429.18389.5159489339127196469.stgit@magnolia>
 <20171027003817.GC5486@magnolia>
 <20171027044112.GT3235@eguan.usersys.redhat.com>
 <20171027181859.GO5483@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171027181859.GO5483@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

On Fri, Oct 27, 2017 at 11:18:59AM -0700, Darrick J. Wong wrote:
> On Fri, Oct 27, 2017 at 12:41:12PM +0800, Eryu Guan wrote:
> > On Thu, Oct 26, 2017 at 05:38:17PM -0700, Darrick J. Wong wrote:
> > > Add some helper functions to require that we can reload a given module,
> > > and add a helper to actually do that.  Refactor the existing users to
> > > use the generics.
> > > 
> > > We need to hoist completely the behaviors of the old btrfs module helper
> > > because we need to confirm before starting the test that we actually can
> > > remove the module.
> > > 
> > > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > > ---
> > >  common/btrfs    |   12 --------
> > >  common/module   |   83 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
> > >  common/overlay  |    1 +
> > >  common/rc       |   11 -------
> > >  tests/btrfs/124 |    9 +++---
> > >  tests/btrfs/125 |    9 +++---
> > >  6 files changed, 92 insertions(+), 33 deletions(-)
> > >  create mode 100644 common/module
> > > 
> > > diff --git a/common/btrfs b/common/btrfs
> > > index fd762ef..c09206c 100644
> > > --- a/common/btrfs
> > > +++ b/common/btrfs
> > > @@ -349,18 +349,6 @@ _btrfs_qgroup_units()
> > >  	$BTRFS_UTIL_PROG qgroup show --help 2>&1 | grep -q -- --raw && echo "--raw"
> > >  }
> > >  
> > > -_require_btrfs_loadable()
> > > -{
> > > -	modprobe -r btrfs || _notrun "btrfs unloadable"
> > > -	modprobe btrfs || _notrun "Can't load btrfs"
> > > -}
> > > -
> > > -_reload_btrfs_ko()
> > > -{
> > > -	modprobe -r btrfs || _fail "btrfs unload failed"
> > > -	modprobe btrfs || _fail "btrfs load failed"
> > > -}
> > > -
> > >  _btrfs_compression_algos()
> > >  {
> > >  	echo zlib
> > > diff --git a/common/module b/common/module
> > > new file mode 100644
> > > index 0000000..59cbd8a
> > > --- /dev/null
> > > +++ b/common/module
> > > @@ -0,0 +1,83 @@
> > > +##/bin/bash
> > > +
> > > +# Routines for messing around with loadable kernel modules
> > > +#
> > > +#-----------------------------------------------------------------------
> > > +#  Copyright (c) 2017 Oracle.  All Rights Reserved.
> > > +#  This program is free software; you can redistribute it and/or modify
> > > +#  it under the terms of the GNU General Public License as published by
> > > +#  the Free Software Foundation; either version 2 of the License, or
> > > +#  (at your option) any later version.
> > > +#
> > > +#  This program is distributed in the hope that it will be useful,
> > > +#  but WITHOUT ANY WARRANTY; without even the implied warranty of
> > > +#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > > +#  GNU General Public License for more details.
> > > +#
> > > +#  You should have received a copy of the GNU General Public License
> > > +#  along with this program; if not, write to the Free Software
> > > +#  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307
> > > +#  USA
> > > +#-----------------------------------------------------------------------
> > > +
> > > +# Return the module name for this fs.
> > > +_module_for_fs()
> > > +{
> > > +	echo "$FSTYP"
> > > +}
> > > +
> > > +# Reload a particular module.  This module MUST NOT be the module that
> > > +# underlies the filesystem.
> > > +_reload_module()
> > > +{
> > > +	module="$1"
> > > +
> > > +	modprobe -r "${module}" || _fail "${module} unload failed"
> > > +	modprobe "${module}" || _fail "${module} load failed"
> > > +}
> > > +
> > > +# Reload the filesystem module.
> > > +_reload_fs_module()
> > > +{
> > > +	module="$1"
> > > +
> > > +	# Unload test fs, try to reload module, remount
> > > +	had_testfs=""
> > > +	had_scratchfs=""
> > > +	_check_mounted_on TEST_DEV $TEST_DEV TEST_DIR $TEST_DIR && had_testfs="true"
> > > +	_check_mounted_on SCRATCH_DEV $SCRATCH_DEV SCRATCH_MNT $SCRATCH_MNT && had_scratchfs="true"
> > > +	test -n "$had_testfs" && _test_unmount
> > > +	test -n "$had_scratchfs" && _scratch_unmount
> > > +	_reload_module "$module"
> > > +	test -n "$had_scratchfs" && _scratch_mount 2> /dev/null
> > > +	test -n "$had_testfs" && _test_mount 2> /dev/null
> > > +}
> > > +
> > > +# Check that we have a module that can be loaded.  This module MUST NOT
> > > +# be the module that underlies the filesystem.
> > > +_require_loadable_module()
> > > +{
> > > +	module="$1"
> > > +
> > > +	modinfo "$module" > /dev/null 2>&1 || _notrun "${module}: must be a module."
> > > +	_reload_module "$module"
> > > +}
> > > +
> > > +# Check that the module for FSTYP can be loaded.
> > > +_require_loadable_fs_module()
> > > +{
> > > +	module="$1"
> > > +
> > > +	modinfo "$module" > /dev/null 2>&1 || _notrun "${module}: must be a module."
> > > +	_reload_fs_module "$module"
> > 
> > _reload_module() or _reload_fs_module() fails the test directly if the
> > module is still in use. IMHO we should _notrun in this case.
> 
> Ok, will fix.
> 
> > Currently xfs/70[345] still fail if rootfs is xfs.
> 
> I don't consider it a good idea to store xfsprogs/xfstests on a $FSTYP
> filesystem because you're depending on the reliability of the same
> filesystem whose reliability you're trying to prove.
> 
> That said, I suppose that pretty much requires nfsroot or a giant initramfs...

So I have two test vms, one with ext4 rootfs to test xfs, one with xfs
rootfs to test ext4, I didn't use btrfs root because RHEL dropped btrfs
support :)

BTW, I took patch 1, 4 and 7 for this week's update, the other patches
probably will go in next week. Thanks a lot for all the updates!

Eryu
