Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E8B4C00140
	for <linux-xfs@archiver.kernel.org>; Sun, 31 Jul 2022 18:10:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229577AbiGaSKe (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 31 Jul 2022 14:10:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229558AbiGaSKd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 31 Jul 2022 14:10:33 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C8F1A6254
        for <linux-xfs@vger.kernel.org>; Sun, 31 Jul 2022 11:10:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1659291029;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=NyhoWmyfUIrWsn/jEgtY6Z6jJOjZBSDL5FHxjuzYBZc=;
        b=BjGtMTFEaXVICB79He2C9Dc11Wn/wgRpbfiH2s7CMS3iSL2DxFToJlt0PLitvpt6rQ67Dg
        P9rQFo4GkreM6T0u5eDQTfw6AJO8CwBxPMggreyLcYruR8hZ7a6eHeEPdsTzGtEvPPoFAq
        x956D0YeKvff49h3OdVmI7tan2vrDUc=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-283-zmTqk8LWO0qtgWdOgKit9A-1; Sun, 31 Jul 2022 14:10:20 -0400
X-MC-Unique: zmTqk8LWO0qtgWdOgKit9A-1
Received: by mail-qk1-f197.google.com with SMTP id x22-20020a05620a259600b006b552a69231so7702451qko.18
        for <linux-xfs@vger.kernel.org>; Sun, 31 Jul 2022 11:10:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=NyhoWmyfUIrWsn/jEgtY6Z6jJOjZBSDL5FHxjuzYBZc=;
        b=tcqbacjoeCZULuSCYgQ35aS05uZmotW7Xop3UsIVcTNI44WLJqBtgDAYqnoyiHLrpo
         aFthZtkO//pfXJy9pL3whIpfK0qFSEahMRf+amYZIqrRhD14TjLoOAHhus+QCaJTc6RZ
         4QV++jHyVtPrdnwe4IrC30QhXDQ61lpPYx9LHBknqDOaL0W3UmyPcM0Dn9pe9B2N8G09
         K5IJJzkkYVjg3KrVnkhsS76X0MWsWIcXqWz3ZWmYf1W3aMXp0bde0E2qZhkKCuFp1NrU
         qHU0Za7dKCuYlTfMgakUnoAXk5SlOBUpi+CeyOiCJjM7PyFuEHzCkA+INx3p2BumuFNC
         E+4A==
X-Gm-Message-State: AJIora/VEPyKZhzAhCbbR9omAzVRNktCg+oAQq8YZw/jQcKmbFXpDlfw
        qQnvJkk+xqq1yxGxVIHOahEYl8bYpogQjoP4Ur4bvGZVdY5L0nWi6uLo/7o74h5JPcRi0E2xOrx
        5lcNCTE/IcstYNc8+qgdS
X-Received: by 2002:ac8:5942:0:b0:31f:39f6:aba7 with SMTP id 2-20020ac85942000000b0031f39f6aba7mr11004212qtz.295.1659291019758;
        Sun, 31 Jul 2022 11:10:19 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1u9DPlIp7E5mO3KTh9kQX6+MpjEwmzmwMt053w/Ja8VSiij3GUnEi6DOHeD+3CfxYykKRAYiA==
X-Received: by 2002:ac8:5942:0:b0:31f:39f6:aba7 with SMTP id 2-20020ac85942000000b0031f39f6aba7mr11004183qtz.295.1659291019374;
        Sun, 31 Jul 2022 11:10:19 -0700 (PDT)
Received: from zlang-mailbox ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id c4-20020ac853c4000000b0031ef0081d77sm5771922qtq.79.2022.07.31.11.10.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 31 Jul 2022 11:10:18 -0700 (PDT)
Date:   Mon, 1 Aug 2022 02:10:12 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, tytso@mit.edu,
        leah.rumancik@gmail.com
Subject: Re: [PATCH 2/2] dmerror: support external log and realtime devices
Message-ID: <20220731181012.ucxcsrbxwpdub2g7@zlang-mailbox>
References: <165886491119.1585061.14285332087646848837.stgit@magnolia>
 <165886492259.1585061.11384715139979799178.stgit@magnolia>
 <20220730101834.6nscxoc2u3wfy7nq@zlang-mailbox>
 <YuayU5+5XfgUTnIV@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YuayU5+5XfgUTnIV@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Jul 31, 2022 at 09:48:19AM -0700, Darrick J. Wong wrote:
> On Sat, Jul 30, 2022 at 06:18:34PM +0800, Zorro Lang wrote:
> > On Tue, Jul 26, 2022 at 12:48:42PM -0700, Darrick J. Wong wrote:
> > > From: Darrick J. Wong <djwong@kernel.org>
> > > 
> > > Upgrade the dmerror code to coordinate making external scratch log and
> > > scratch realtime devices error out along with the scratch device.  Note
> > > that unlike SCRATCH_DEV, we save the old rt/log devices in a separate
> > > variable and overwrite SCRATCH_{RT,LOG}DEV so that all the helper
> > > functions continue to work properly.
> > > 
> > > This is very similar to what we did for dm-flakey a while back.
> > > 
> > > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > > ---
> > 
> > Hi Darrick,
> > 
> > I'll merge the patch 1/2 this week, but this 2/2 looks like bring in new
> > failures on ext4 with local.config as [0], for example[1], which is passed[2]
> > without this patch. It's fine on Btrfs and xfs for me.
> > 
> > Thanks,
> > Zorro
> > 
> > [0]
> > export TEST_DEV=/dev/sda5
> > export TEST_DIR=/mnt/test
> > export SCRATCH_DEV=/dev/sda3
> > export SCRATCH_MNT=/mnt/scratch
> > export USE_EXTERNAL=yes
> > export SCRATCH_LOGDEV=/dev/loop0
> > 
> > [1]
> > generic/338 4s ... - output mismatch (see /root/git/xfstests/results//logdev/generic/338.out.bad)
> >     --- tests/generic/338.out   2022-04-29 23:07:23.330499055 +0800
> >     +++ /root/git/xfstests/results//logdev/generic/338.out.bad  2022-07-30 18:01:41.900765965 +0800
> >     @@ -1,2 +1,4 @@
> >      QA output created by 338   
> >      Silence is golden
> >     +mount: /mnt/scratch: wrong fs type, bad option, bad superblock on /dev/mapper/error-test, missing codepage or helper program, or other error.
> >     +       dmesg(1) may have more information after failed mount system call.
> 
> Hmm, any chance you could post the dmesg that goes with this?

Sure, [1] is the dmesg with this patch. [2] is the dmesg without this patch.

Thanks,
Zorro

[1]
# ./check -s logdev generic/338
SECTION       -- logdev
FSTYP         -- ext4
PLATFORM      -- Linux/x86_64 hp-dl380pg8-01 5.19.0-0.rc2.21.fc37.x86_64+debug #1 SMP PREEMPT_DYNAMIC Mon Jun 13 14:55:18 UTC 2022
MKFS_OPTIONS  -- /dev/sda3
MOUNT_OPTIONS -- -o acl,user_xattr -o context=system_u:object_r:root_t:s0 /dev/sda3 /mnt/scratch

generic/338 5s ... - output mismatch (see /root/git/xfstests/results//logdev/generic/338.out.bad)
    --- tests/generic/338.out   2022-04-29 23:07:23.330499055 +0800
    +++ /root/git/xfstests/results//logdev/generic/338.out.bad  2022-08-01 02:00:17.284965956 +0800
    @@ -1,2 +1,4 @@
     QA output created by 338
     Silence is golden
    +mount: /mnt/scratch: wrong fs type, bad option, bad superblock on /dev/mapper/error-test, missing codepage or helper program, or other error.
    +       dmesg(1) may have more information after failed mount system call.
    ...
    (Run 'diff -u /root/git/xfstests/tests/generic/338.out /root/git/xfstests/results//logdev/generic/338.out.bad'  to see the entire diff)
Ran: generic/338
Failures: generic/338
Failed 1 of 1 tests

# dmesg
[1382503.819432] run fstests generic/338 at 2022-08-01 02:00:13
[1382504.957989] EXT4-fs (dm-6): failed to open journal device unknown-block(7,0) -16
[1382504.987712] Buffer I/O error on dev dm-7, logical block 262128, async page read
[1382505.009371] Buffer I/O error on dev dm-6, logical block 13106160, async page read
[1382506.576023] 338 (277855): drop_caches: 3
[1382507.440513] EXT4-fs (sda5): unmounting filesystem.

[2]
# ./check -s logdev generic/338
SECTION       -- logdev
FSTYP         -- ext4
PLATFORM      -- Linux/x86_64 hp-dl380pg8-01 5.19.0-0.rc2.21.fc37.x86_64+debug #1 SMP PREEMPT_DYNAMIC Mon Jun 13 14:55:18 UTC 2022
MKFS_OPTIONS  -- /dev/sda3
MOUNT_OPTIONS -- -o acl,user_xattr -o context=system_u:object_r:root_t:s0 /dev/sda3 /mnt/scratch

generic/338 5s ...  3s
Ran: generic/338
Passed all 1 tests

# dmesg
[1382877.411459] run fstests generic/338 at 2022-08-01 02:06:27
[1382878.778539] EXT4-fs (dm-6): mounted filesystem with ordered data mode. Quota mode: none.
[1382878.803639] Buffer I/O error on dev dm-6, logical block 13106160, async page read
[1382878.951444] 338 (279660): drop_caches: 3
[1382879.421933] EXT4-fs warning (device dm-6): htree_dirblock_to_tree:1044: inode #2: lblock 0: comm ls: error -5 reading directory block
[1382879.422007] EXT4-fs error (device dm-6): ext4_get_inode_loc:4587: inode #2: block 1064: comm ls: unable to read itable block
[1382879.422026] EXT4-fs error (device dm-6) in ext4_reserve_inode_write:5756: IO failure
[1382879.422031] EXT4-fs error (device dm-6): ext4_dirty_inode:5952: inode #2: comm ls: mark_inode_dirty error
[1382879.750038] EXT4-fs error (device dm-6): __ext4_find_entry:1635: inode #2: comm xfs_io: reading directory lblock 0
[1382880.180381] Buffer I/O error on dev dm-6, logical block 0, lost async page write
[1382880.180961] EXT4-fs (dm-6): unmounting filesystem.
[1382880.181541] Aborting journal on device loop0.
[1382880.182777] EXT4-fs error (device dm-6): ext4_put_super:1229: comm umount: Couldn't clean up the journal
[1382880.182798] EXT4-fs (dm-6): previous I/O error to superblock detected
[1382880.182817] Buffer I/O error on dev dm-6, logical block 0, lost sync page write
[1382880.182860] EXT4-fs (dm-6): I/O error while writing superblock
[1382880.182867] EXT4-fs (dm-6): Remounting filesystem read-only
[1382880.742572] EXT4-fs (sda5): unmounting filesystem.

> 
> --D
> 
> >     ...
> >     (Run 'diff -u /root/git/xfstests/tests/generic/338.out /root/git/xfstests/results//logdev/generic/338.out.bad'  to see the entire diff)
> > generic/441 5s ... - output mismatch (see /root/git/xfstests/results//logdev/generic/441.out.bad)
> >     --- tests/generic/441.out   2022-04-29 23:07:23.406499916 +0800
> >     +++ /root/git/xfstests/results//logdev/generic/441.out.bad  2022-07-30 18:01:46.829822438 +0800
> >     @@ -1,3 +1,6 @@
> >      QA output created by 441   
> >      Format and mount
> >     -Test passed!
> >     +mount: /mnt/scratch: wrong fs type, bad option, bad superblock on /dev/mapper/error-test, missing codepage or helper program, or other error.
> >     +       dmesg(1) may have more information after failed mount system call.
> >     +Success on second fsync on fd[0]!
> >     +umount: /mnt/scratch: not mounted.
> >     ...
> >     (Run 'diff -u /root/git/xfstests/tests/generic/441.out /root/git/xfstests/results//logdev/generic/441.out.bad'  to see the entire diff)
> > 
> > [2]
> > generic/338 4s ...  5s
> > generic/441 5s ...  5s
> > generic/442 3s ...  3s
> > 
> > 
> > >  common/dmerror    |  159 +++++++++++++++++++++++++++++++++++++++++++++++++++--
> > >  tests/generic/441 |    2 -
> > >  tests/generic/487 |    2 -
> > >  3 files changed, 156 insertions(+), 7 deletions(-)
> > > 
> > > 
> > > diff --git a/common/dmerror b/common/dmerror
> > > index 01a4c8b5..85ef9a16 100644
> > > --- a/common/dmerror
> > > +++ b/common/dmerror
> > > @@ -4,25 +4,88 @@
> > >  #
> > >  # common functions for setting up and tearing down a dmerror device
> > >  
> > > +_dmerror_setup_vars()
> > > +{
> > > +	local backing_dev="$1"
> > > +	local tag="$2"
> > > +	local target="$3"
> > > +
> > > +	test -z "$target" && target=error
> > > +	local blk_dev_size=$(blockdev --getsz "$backing_dev")
> > > +
> > > +	eval export "DMLINEAR_${tag}TABLE=\"0 $blk_dev_size linear $backing_dev 0\""
> > > +	eval export "DMERROR_${tag}TABLE=\"0 $blk_dev_size $target $backing_dev 0\""
> > > +}
> > > +
> > >  _dmerror_setup()
> > >  {
> > > -	local dm_backing_dev=$SCRATCH_DEV
> > > +	local rt_target=
> > > +	local linear_target=
> > >  
> > > -	local blk_dev_size=`blockdev --getsz $dm_backing_dev`
> > > +	for arg in "$@"; do
> > > +		case "${arg}" in
> > > +		no_rt)		rt_target=linear;;
> > > +		no_log)		log_target=linear;;
> > > +		*)		echo "${arg}: Unknown _dmerror_setup arg.";;
> > > +		esac
> > > +	done
> > >  
> > > +	# Scratch device
> > >  	export DMERROR_DEV='/dev/mapper/error-test'
> > > +	_dmerror_setup_vars $SCRATCH_DEV
> > >  
> > > -	export DMLINEAR_TABLE="0 $blk_dev_size linear $dm_backing_dev 0"
> > > +	# Realtime device.  We reassign SCRATCH_RTDEV so that all the scratch
> > > +	# helpers continue to work unmodified.
> > > +	if [ -n "$SCRATCH_RTDEV" ]; then
> > > +		if [ -z "$NON_ERROR_RTDEV" ]; then
> > > +			# Set up the device switch
> > > +			local dm_backing_dev=$SCRATCH_RTDEV
> > > +			export NON_ERROR_RTDEV="$SCRATCH_RTDEV"
> > > +			SCRATCH_RTDEV='/dev/mapper/error-rttest'
> > > +		else
> > > +			# Already set up; recreate tables
> > > +			local dm_backing_dev="$NON_ERROR_RTDEV"
> > > +		fi
> > >  
> > > -	export DMERROR_TABLE="0 $blk_dev_size error $dm_backing_dev 0"
> > > +		_dmerror_setup_vars $dm_backing_dev RT $rt_target
> > > +	fi
> > > +
> > > +	# External log device.  We reassign SCRATCH_LOGDEV so that all the
> > > +	# scratch helpers continue to work unmodified.
> > > +	if [ -n "$SCRATCH_LOGDEV" ]; then
> > > +		if [ -z "$NON_ERROR_LOGDEV" ]; then
> > > +			# Set up the device switch
> > > +			local dm_backing_dev=$SCRATCH_LOGDEV
> > > +			export NON_ERROR_LOGDEV="$SCRATCH_LOGDEV"
> > > +			SCRATCH_LOGDEV='/dev/mapper/error-logtest'
> > > +		else
> > > +			# Already set up; recreate tables
> > > +			local dm_backing_dev="$NON_ERROR_LOGDEV"
> > > +		fi
> > > +
> > > +		_dmerror_setup_vars $dm_backing_dev LOG $log_target
> > > +	fi
> > >  }
> > >  
> > >  _dmerror_init()
> > >  {
> > > -	_dmerror_setup
> > > +	_dmerror_setup "$@"
> > > +
> > >  	_dmsetup_remove error-test
> > >  	_dmsetup_create error-test --table "$DMLINEAR_TABLE" || \
> > >  		_fatal "failed to create dm linear device"
> > > +
> > > +	if [ -n "$NON_ERROR_RTDEV" ]; then
> > > +		_dmsetup_remove error-rttest
> > > +		_dmsetup_create error-rttest --table "$DMLINEAR_RTTABLE" || \
> > > +			_fatal "failed to create dm linear rt device"
> > > +	fi
> > > +
> > > +	if [ -n "$NON_ERROR_LOGDEV" ]; then
> > > +		_dmsetup_remove error-logtest
> > > +		_dmsetup_create error-logtest --table "$DMLINEAR_LOGTABLE" || \
> > > +			_fatal "failed to create dm linear log device"
> > > +	fi
> > >  }
> > >  
> > >  _dmerror_mount()
> > > @@ -39,11 +102,27 @@ _dmerror_unmount()
> > >  
> > >  _dmerror_cleanup()
> > >  {
> > > +	test -n "$NON_ERROR_LOGDEV" && $DMSETUP_PROG resume error-logtest &>/dev/null
> > > +	test -n "$NON_ERROR_RTDEV" && $DMSETUP_PROG resume error-rttest &>/dev/null
> > >  	$DMSETUP_PROG resume error-test > /dev/null 2>&1
> > > +
> > >  	$UMOUNT_PROG $SCRATCH_MNT > /dev/null 2>&1
> > > +
> > > +	test -n "$NON_ERROR_LOGDEV" && _dmsetup_remove error-logtest
> > > +	test -n "$NON_ERROR_RTDEV" && _dmsetup_remove error-rttest
> > >  	_dmsetup_remove error-test
> > >  
> > >  	unset DMERROR_DEV DMLINEAR_TABLE DMERROR_TABLE
> > > +
> > > +	if [ -n "$NON_ERROR_LOGDEV" ]; then
> > > +		SCRATCH_LOGDEV="$NON_ERROR_LOGDEV"
> > > +		unset NON_ERROR_LOGDEV DMLINEAR_LOGTABLE DMERROR_LOGTABLE
> > > +	fi
> > > +
> > > +	if [ -n "$NON_ERROR_RTDEV" ]; then
> > > +		SCRATCH_RTDEV="$NON_ERROR_RTDEV"
> > > +		unset NON_ERROR_RTDEV DMLINEAR_RTTABLE DMERROR_RTTABLE
> > > +	fi
> > >  }
> > >  
> > >  _dmerror_load_error_table()
> > > @@ -59,12 +138,47 @@ _dmerror_load_error_table()
> > >  		suspend_opt="$*"
> > >  	fi
> > >  
> > > +	# Suspend the scratch device before the log and realtime devices so
> > > +	# that the kernel can freeze and flush the filesystem if the caller
> > > +	# wanted a freeze.
> > >  	$DMSETUP_PROG suspend $suspend_opt error-test
> > >  	[ $? -ne 0 ] && _fail  "dmsetup suspend failed"
> > >  
> > > +	if [ -n "$NON_ERROR_RTDEV" ]; then
> > > +		$DMSETUP_PROG suspend $suspend_opt error-rttest
> > > +		[ $? -ne 0 ] && _fail "failed to suspend error-rttest"
> > > +	fi
> > > +
> > > +	if [ -n "$NON_ERROR_LOGDEV" ]; then
> > > +		$DMSETUP_PROG suspend $suspend_opt error-logtest
> > > +		[ $? -ne 0 ] && _fail "failed to suspend error-logtest"
> > > +	fi
> > > +
> > > +	# Load new table
> > >  	$DMSETUP_PROG load error-test --table "$DMERROR_TABLE"
> > >  	load_res=$?
> > >  
> > > +	if [ -n "$NON_ERROR_RTDEV" ]; then
> > > +		$DMSETUP_PROG load error-rttest --table "$DMERROR_RTTABLE"
> > > +		[ $? -ne 0 ] && _fail "failed to load error table into error-rttest"
> > > +	fi
> > > +
> > > +	if [ -n "$NON_ERROR_LOGDEV" ]; then
> > > +		$DMSETUP_PROG load error-logtest --table "$DMERROR_LOGTABLE"
> > > +		[ $? -ne 0 ] && _fail "failed to load error table into error-logtest"
> > > +	fi
> > > +
> > > +	# Resume devices in the opposite order that we suspended them.
> > > +	if [ -n "$NON_ERROR_LOGDEV" ]; then
> > > +		$DMSETUP_PROG resume error-logtest
> > > +		[ $? -ne 0 ] && _fail  "failed to resume error-logtest"
> > > +	fi
> > > +
> > > +	if [ -n "$NON_ERROR_RTDEV" ]; then
> > > +		$DMSETUP_PROG resume error-rttest
> > > +		[ $? -ne 0 ] && _fail  "failed to resume error-rttest"
> > > +	fi
> > > +
> > >  	$DMSETUP_PROG resume error-test
> > >  	resume_res=$?
> > >  
> > > @@ -85,12 +199,47 @@ _dmerror_load_working_table()
> > >  		suspend_opt="$*"
> > >  	fi
> > >  
> > > +	# Suspend the scratch device before the log and realtime devices so
> > > +	# that the kernel can freeze and flush the filesystem if the caller
> > > +	# wanted a freeze.
> > >  	$DMSETUP_PROG suspend $suspend_opt error-test
> > >  	[ $? -ne 0 ] && _fail  "dmsetup suspend failed"
> > >  
> > > +	if [ -n "$NON_ERROR_RTDEV" ]; then
> > > +		$DMSETUP_PROG suspend $suspend_opt error-rttest
> > > +		[ $? -ne 0 ] && _fail "failed to suspend error-rttest"
> > > +	fi
> > > +
> > > +	if [ -n "$NON_ERROR_LOGDEV" ]; then
> > > +		$DMSETUP_PROG suspend $suspend_opt error-logtest
> > > +		[ $? -ne 0 ] && _fail "failed to suspend error-logtest"
> > > +	fi
> > > +
> > > +	# Load new table
> > >  	$DMSETUP_PROG load error-test --table "$DMLINEAR_TABLE"
> > >  	load_res=$?
> > >  
> > > +	if [ -n "$NON_ERROR_RTDEV" ]; then
> > > +		$DMSETUP_PROG load error-rttest --table "$DMLINEAR_RTTABLE"
> > > +		[ $? -ne 0 ] && _fail "failed to load working table into error-rttest"
> > > +	fi
> > > +
> > > +	if [ -n "$NON_ERROR_LOGDEV" ]; then
> > > +		$DMSETUP_PROG load error-logtest --table "$DMLINEAR_LOGTABLE"
> > > +		[ $? -ne 0 ] && _fail "failed to load working table into error-logtest"
> > > +	fi
> > > +
> > > +	# Resume devices in the opposite order that we suspended them.
> > > +	if [ -n "$NON_ERROR_LOGDEV" ]; then
> > > +		$DMSETUP_PROG resume error-logtest
> > > +		[ $? -ne 0 ] && _fail  "failed to resume error-logtest"
> > > +	fi
> > > +
> > > +	if [ -n "$NON_ERROR_RTDEV" ]; then
> > > +		$DMSETUP_PROG resume error-rttest
> > > +		[ $? -ne 0 ] && _fail  "failed to resume error-rttest"
> > > +	fi
> > > +
> > >  	$DMSETUP_PROG resume error-test
> > >  	resume_res=$?
> > >  
> > > diff --git a/tests/generic/441 b/tests/generic/441
> > > index 0ec751da..85f29a3a 100755
> > > --- a/tests/generic/441
> > > +++ b/tests/generic/441
> > > @@ -52,7 +52,7 @@ unset SCRATCH_RTDEV
> > >  
> > >  echo "Format and mount"
> > >  _scratch_mkfs > $seqres.full 2>&1
> > > -_dmerror_init
> > > +_dmerror_init no_log
> > >  _dmerror_mount
> > >  
> > >  _require_fs_space $SCRATCH_MNT 65536
> > > diff --git a/tests/generic/487 b/tests/generic/487
> > > index fda8828d..3c9b2233 100755
> > > --- a/tests/generic/487
> > > +++ b/tests/generic/487
> > > @@ -45,7 +45,7 @@ unset SCRATCH_RTDEV
> > >  
> > >  echo "Format and mount"
> > >  _scratch_mkfs > $seqres.full 2>&1
> > > -_dmerror_init
> > > +_dmerror_init no_log
> > >  _dmerror_mount
> > >  
> > >  datalen=65536
> > > 
> > 
> 

