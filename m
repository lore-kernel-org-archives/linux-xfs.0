Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40962 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751129AbdIELWh (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 5 Sep 2017 07:22:37 -0400
Date: Tue, 5 Sep 2017 19:22:34 +0800
From: Eryu Guan <eguan@redhat.com>
Subject: Re: [PATCH v2 13/14] fstests: add support for working with
 dm-log-writes target
Message-ID: <20170905112234.GE8034@eguan.usersys.redhat.com>
References: <1504104706-11965-1-git-send-email-amir73il@gmail.com>
 <1504104706-11965-14-git-send-email-amir73il@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1504104706-11965-14-git-send-email-amir73il@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Amir Goldstein <amir73il@gmail.com>
Cc: Josef Bacik <jbacik@fb.com>, "Darrick J . Wong" <darrick.wong@oracle.com>, Christoph Hellwig <hch@lst.de>, fstests@vger.kernel.org, linux-xfs@vger.kernel.org

On Wed, Aug 30, 2017 at 05:51:45PM +0300, Amir Goldstein wrote:
> Cherry-picked the relevant common bits from commit 70d41e17164b
> in Josef Bacik's fstests tree (https://github.com/josefbacik/fstests).
> Quoting from Josef's commit message:
> 
>   This patch adds the supporting code for using the dm-log-writes
>   target.  The dmlogwrites code is similar to the dmflakey code, it just
>   gives us functions to build and tear down a dm-log-writes target.  We
>   add a new LOGWRITES_DEV variable to take in the device we will use as
>   the log and add checks for that.
> 
> [Amir:]
> - Removed unneeded _test_falloc_support
> - Moved _require_log_writes to dmlogwrites
> - Document _require_log_writes
> 
> Cc: Josef Bacik <jbacik@fb.com>
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> ---
>  README                       |  2 ++
>  common/dmlogwrites           | 84 ++++++++++++++++++++++++++++++++++++++++++++
>  doc/requirement-checking.txt | 20 +++++++++++
>  3 files changed, 106 insertions(+)
>  create mode 100644 common/dmlogwrites
> 
> diff --git a/README b/README
> index 9456fa7..4963d28 100644
> --- a/README
> +++ b/README
> @@ -91,6 +91,8 @@ Preparing system for tests:
>               - set TEST_XFS_SCRUB=1 to have _check_xfs_filesystem run
>                 xfs_scrub -vd to scrub the filesystem metadata online before
>                 unmounting to run the offline check.
> +             - setenv LOGWRITES_DEV to a block device to use for power fail
> +               testing.
>  
>          - or add a case to the switch in common/config assigning
>            these variables based on the hostname of your test
> diff --git a/common/dmlogwrites b/common/dmlogwrites
> new file mode 100644
> index 0000000..a36724d
> --- /dev/null
> +++ b/common/dmlogwrites
> @@ -0,0 +1,84 @@
> +##/bin/bash
> +#
> +# Copyright (c) 2015 Facebook, Inc.  All Rights Reserved.
> +#
> +# This program is free software; you can redistribute it and/or
> +# modify it under the terms of the GNU General Public License as
> +# published by the Free Software Foundation.
> +#
> +# This program is distributed in the hope that it would be useful,
> +# but WITHOUT ANY WARRANTY; without even the implied warranty of
> +# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> +# GNU General Public License for more details.
> +#
> +# You should have received a copy of the GNU General Public License
> +# along with this program; if not, write the Free Software Foundation,
> +# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
> +#
> +#
> +# common functions for setting up and tearing down a dm log-writes device

I think we need to _notrun if testing with dax mount option? Like all
other dm target tests do.

> +
> +_require_log_writes()
> +{
> +	_require_dm_target log-writes
> +	_require_test_program "log-writes/replay-log"

As you mentioned before, need to check the existence of LOGWRITES_DEV
first. And is the size of LOGWRITES_DEV required to be => SCRATCH_DEV?
I guess so.

> +}
> +
> +_init_log_writes()

Seems the function names are not unified in this file, some are in
vert.-noun. format, some are in noun.-verb. format. Better to use the
same format across the file, either all prefixed with "_log_writes"
(except _require_log_writes) or suffixed with it.

> +{
> +	local BLK_DEV_SIZE=`blockdev --getsz $SCRATCH_DEV`
> +	LOGWRITES_NAME=logwrites-test

Not a big deal, but LOGWRITES_DEVNAME seems better to me.

> +	LOGWRITES_DMDEV=/dev/mapper/$LOGWRITES_NAME
> +	LOGWRITES_TABLE="0 $BLK_DEV_SIZE log-writes $SCRATCH_DEV $LOGWRITES_DEV"
> +	$DMSETUP_PROG create $LOGWRITES_NAME --table "$LOGWRITES_TABLE" || \
> +		_fatal "failed to create log-writes device"

I think s/_fatal/_fail/g should be OK in this file.

> +	$DMSETUP_PROG mknodes > /dev/null 2>&1
> +}
> +
> +_log_writes_mark()
> +{
> +	[ $# -ne 1 ] && _fatal "_log_writes_mark takes one argument"
> +	$DMSETUP_PROG message $LOGWRITES_NAME 0 mark $1
> +}
> +
> +_log_writes_mkfs()
> +{
> +	_scratch_options mkfs
> +	_mkfs_dev $SCRATCH_OPTIONS $LOGWRITES_DMDEV
> +	_log_writes_mark mkfs
> +}
> +
> +_mount_log_writes()
> +{
> +	mount -t $FSTYP $MOUNT_OPTIONS $* $LOGWRITES_DMDEV $SCRATCH_MNT

$MOUNT_PROG, and I think we can follow _dmerror_mount() for this mount
function.

> +}
> +
> +_unmount_log_writes()
> +{
> +	$UMOUNT_PROG $SCRATCH_MNT
> +}
> +
> +# _replay_log <mark>

_replay_log looks like replaying filesystem log/journal, prefixed with
_log_writes? So I guess we're going the "_log_writes_<verb>" way :)

> +#
> +# This replays the log contained on $INTEGRITY_DEV onto $SCRATCH_DEV upto the
                                       ^^^^^^^^^^^^^^ LOGWRITES_DEV
> +# mark passed in.
> +_replay_log()
> +{
> +	_mark=$1
> +
> +	$here/src/log-writes/replay-log --log $LOGWRITES_DEV --replay $SCRATCH_DEV \
> +		--end-mark $_mark > /dev/null 2>&1

Dump output to $seqres.full for debug purpose?

Thanks,
Eryu

> +	[ $? -ne 0 ] && _fatal "replay failed"
> +}
> +
> +_log_writes_remove()
> +{
> +	$DMSETUP_PROG remove $LOGWRITES_NAME > /dev/null 2>&1
> +	$DMSETUP_PROG mknodes > /dev/null 2>&1
> +}
> +
> +_cleanup_log_writes()
> +{
> +	$UMOUNT_PROG $SCRATCH_MNT > /dev/null 2>&1
> +	_log_writes_remove
> +}
> diff --git a/doc/requirement-checking.txt b/doc/requirement-checking.txt
> index 95d10e6..4e01b1f 100644
> --- a/doc/requirement-checking.txt
> +++ b/doc/requirement-checking.txt
> @@ -21,6 +21,10 @@ they have.  This is done with _require_<xxx> macros, which may take parameters.
>  
>  	_require_statx
>  
> + (4) Device mapper requirement.
> +
> +	_require_dm_target
> +	_require_log_writes
>  
>  ====================
>  GENERAL REQUIREMENTS
> @@ -102,3 +106,19 @@ _require_statx
>  
>       The test requires the use of the statx() system call and will be skipped
>       if it isn't available in the kernel.
> +
> +
> +==========================
> +DEVICE MAPPER REQUIREMENTS
> +==========================
> +
> +_require_dm_target <name>
> +
> +     The test requires the use of the device mapper target and will be skipped
> +     if it isn't available in the kernel.
> +
> +_require_log_writes
> +
> +     The test requires the use of the device mapper target log-writes.
> +     The test also requires the test program log-writes/replay-log is built
> +     and will be skipped if either isn't available.
> -- 
> 2.7.4
> 
