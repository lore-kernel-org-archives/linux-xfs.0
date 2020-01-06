Return-Path: <SRS0=XUqT=23=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D61EDC3F68F
	for <linux-xfs@archiver.kernel.org>; Mon,  6 Jan 2020 18:11:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ACDA62070E
	for <linux-xfs@archiver.kernel.org>; Mon,  6 Jan 2020 18:11:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Td6XfzUv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726701AbgAFSLC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 6 Jan 2020 13:11:02 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:59558 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726536AbgAFSLB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 6 Jan 2020 13:11:01 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 006Hn0LB029601;
        Mon, 6 Jan 2020 18:10:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=dQy0PAhaJqqLxMHnSVzfXIL0mKr9haVwTpiDeJVs0Gs=;
 b=Td6XfzUvJxIR1YQOGH3ViTlRdwjmDbxdW7uJuFEA9MoHjauO5QmS1B8380WVbCc8ZMh0
 +EhvAUxKB6nS+UNFF58JCjDcN5Rmh+98DDGGvgM5EI7GiYczdnN6Mq3kJ5Qy4HgdVzeh
 CQWZghAmedYtcB+bSb/DF2f0vPTZrePkKm+3sasI9jrhFjQOehnszkT3gsAkZpVhuMcq
 A90g1qCJoDnCfgebqtIjv19KDPzvmq0Co+AJ08Ky7YcgC2Zn/zmrelDlpzoW2Bv1CHv7
 zczrgufEJDb6W21zD/aTy3mDYBejevtMVnDc/2pwaYAVidUsH9pFVMbTmpdA7vQXbnbC 2w== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2xaj4trxbp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 06 Jan 2020 18:10:58 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 006Hn0dH136382;
        Mon, 6 Jan 2020 18:10:57 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 2xb4upbypw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 06 Jan 2020 18:10:57 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 006IAuDW012046;
        Mon, 6 Jan 2020 18:10:56 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 06 Jan 2020 10:10:56 -0800
Date:   Mon, 6 Jan 2020 10:10:54 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Eryu Guan <guaneryu@gmail.com>
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs: test xfs_scrub phase 6 media error reporting
Message-ID: <20200106181054.GA472665@magnolia>
References: <157604270553.578515.11375769780919670829.stgit@magnolia>
 <157604271809.578515.1806500868635425865.stgit@magnolia>
 <20200106075828.GD893866@desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200106075828.GD893866@desktop>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9492 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001060151
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9492 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001060151
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jan 06, 2020 at 03:58:30PM +0800, Eryu Guan wrote:
> On Tue, Dec 10, 2019 at 09:38:38PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Add new helpers to dmerror to provide for marking selected ranges
> > totally bad -- both reads and writes will fail.  Create a new test for
> > xfs_scrub to check that it reports media errors correctly.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> 
> I hit assert failure when testing on v5.5-rc3+ kernel, is that an
> expected result? Both test failed in the same way.

Oh, my.  That's a bogus assertion in xrep_calc_ag_resblks when
CONFIG_XFS_ONLINE_REPAIR=n.  That's definitely a kernel bug, though it's
not related to this test.  I'll start working on a fix, thank you for
reporting this!

> 
> [  192.610313] xfs filesystem being mounted at /mnt/scratch supports timestamps until 2038 (0x7fffffff)
> [  193.149329] Buffer I/O error on dev dm-11, logical block 128, async page read
> [  193.150173] Buffer I/O error on dev dm-11, logical block 129, async page read
> [  193.151254] Buffer I/O error on dev dm-11, logical block 130, async page read
> [  193.152173] Buffer I/O error on dev dm-11, logical block 131, async page read
> [  193.152980] Buffer I/O error on dev dm-11, logical block 132, async page read
> [  193.153935] Buffer I/O error on dev dm-11, logical block 133, async page read
> [  193.154869] Buffer I/O error on dev dm-11, logical block 134, async page read
> [  193.155800] Buffer I/O error on dev dm-11, logical block 135, async page read
> [  193.249751] XFS: Assertion failed: !(sc->sm->sm_flags & XFS_SCRUB_IFLAG_REPAIR), file: fs/xfs/scrub/repair.h, line: 78
> [  193.255979] ------------[ cut here ]------------
> [  193.258406] kernel BUG at fs/xfs/xfs_message.c:110!
> [  193.260996] invalid opcode: 0000 [#1] SMP PTI
> [  193.263323] CPU: 0 PID: 5613 Comm: xfs_scrub Not tainted 5.5.0-rc3+ #44
> [  193.266717] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS ?-20190727_073836-buildvm-ppc64le-16.ppc.fedoraproject.org-3.fc31 04/01/2014
> [  193.273736] RIP: 0010:assfail+0x23/0x28 [xfs]
> [  193.276045] Code: 67 fc ff ff 0f 0b c3 0f 1f 44 00 00 41 89 c8 48 89 d1 48 89 f2 48 c7 c6 78 e9 8d c0 e8 82 f9 ff ff 80 3d 9a d7 08 00 00 74 02 <0f> 0b 0f 0b c3 48 8b 03 48 c7 c7 68 ee 8d c0 c6 05 0e 2b 0a 00 01
> [  193.284481] RSP: 0018:ffffac9540b7fbe0 EFLAGS: 00010202
> [  193.286297] RAX: 0000000000000000 RBX: ffffac9540b7fcc8 RCX: 0000000000000000
> [  193.288390] RDX: 00000000ffffffc0 RSI: 000000000000000a RDI: ffffffffc08d144a
> [  193.290235] RBP: ffffac9540b7fbf8 R08: 0000000000000000 R09: 0000000000000000
> [  193.292083] R10: 000000000000000a R11: f000000000000000 R12: 0000000000000000
> [  193.293589] R13: ffff90006701c000 R14: ffff900071746400 R15: ffff900071746558
> [  193.295068] FS:  00007f91892cc740(0000) GS:ffff900078c00000(0000) knlGS:0000000000000000
> [  193.296899] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  193.297977] CR2: 0000000001ef0078 CR3: 0000000236050002 CR4: 00000000003606f0
> [  193.299234] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [  193.300555] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> [  193.301805] Call Trace:
> [  193.302296]  xchk_setup_fs+0x35/0x40 [xfs]
> [  193.302937]  xfs_scrub_metadata+0x23d/0x480 [xfs]
> [  193.303658]  xfs_ioc_scrub_metadata+0x50/0xa0 [xfs]
> [  193.304417]  xfs_file_ioctl+0xb23/0xc60 [xfs]
> [  193.305075]  ? pagevec_lru_move_fn+0xbd/0xe0
> [  193.305719]  ? get_kernel_page+0x60/0x60
> [  193.306321]  ? __lru_cache_add+0x62/0x80
> [  193.306922]  ? __handle_mm_fault+0xc65/0x1930
> [  193.307553]  do_vfs_ioctl+0x448/0x6c0
> [  193.308042]  ? handle_mm_fault+0xc4/0x1f0
> [  193.308572]  ksys_ioctl+0x5e/0x90
> [  193.309006]  __x64_sys_ioctl+0x16/0x20
> [  193.309501]  do_syscall_64+0x5b/0x1d0
> [  193.309990]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> 
> > ---
> >  common/dmerror    |  107 +++++++++++++++++++++++++++++++++++++++++-
> >  tests/xfs/747     |  136 +++++++++++++++++++++++++++++++++++++++++++++++++++++
> >  tests/xfs/747.out |   12 +++++
> >  tests/xfs/748     |  102 ++++++++++++++++++++++++++++++++++++++++
> >  tests/xfs/748.out |    5 ++
> >  tests/xfs/group   |    2 +
> >  6 files changed, 363 insertions(+), 1 deletion(-)
> >  create mode 100755 tests/xfs/747
> >  create mode 100644 tests/xfs/747.out
> >  create mode 100755 tests/xfs/748
> >  create mode 100644 tests/xfs/748.out
> > 
> > 
> > diff --git a/common/dmerror b/common/dmerror
> > index ca1c7335..ee3051f1 100644
> > --- a/common/dmerror
> > +++ b/common/dmerror
> > @@ -62,7 +62,7 @@ _dmerror_load_error_table()
> >  	$DMSETUP_PROG suspend $suspend_opt error-test
> >  	[ $? -ne 0 ] && _fail  "dmsetup suspend failed"
> >  
> > -	$DMSETUP_PROG load error-test --table "$DMERROR_TABLE"
> > +	echo "$DMERROR_TABLE" | $DMSETUP_PROG load error-test
> >  	load_res=$?
> >  
> >  	$DMSETUP_PROG resume error-test
> > @@ -94,3 +94,108 @@ _dmerror_load_working_table()
> >  	[ $load_res -ne 0 ] && _fail "dmsetup failed to load error table"
> >  	[ $resume_res -ne 0 ] && _fail  "dmsetup resume failed"
> >  }
> > +
> > +# Given a list of (start, length) tuples on stdin, combine adjacent tuples into
> > +# larger ones and write the new list to stdout.
> > +__dmerror_combine_extents()
> > +{
> > +	awk 'BEGIN{start = 0; len = 0;}{
> 
> $AWK_PROG

Fixed all of these.

> 
> > +if (start + len == $1) {
> > +	len += $2;
> > +} else {
> > +	if (len > 0)
> > +		printf("%d %d\n", start, len);
> > +	start = $1;
> > +	len = $2;
> > +}
> > +} END {
> > +	if (len > 0)
> > +		printf("%d %d\n", start, len);
> > +}'
> > +}
> > +
> > +# Given a block device, the name of a preferred dm target, the name of an
> > +# implied dm target, and a list of (start, len) tuples on stdin, create a new
> > +# dm table which maps each of the tuples to the preferred target and all other
> > +# areas to the implied dm target.
> > +__dmerror_recreate_map()
> > +{
> > +	local device="$1"
> > +	local preferred_tgt="$2"
> > +	local implied_tgt="$3"
> > +	local size=$(blockdev --getsz "$device")
> > +
> > +	awk -v device="$device" -v size=$size -v implied_tgt="$implied_tgt" \
> 
> Same here.
> 
> > +		-v preferred_tgt="$preferred_tgt" 'BEGIN{implied_start = 0;}{
> > +	extent_start = $1;
> > +	extent_len = $2;
> > +
> > +	if (extent_start > size) {
> > +		extent_start = size;
> > +		extent_len = 0;
> > +	} else if (extent_start + extent_len > size) {
> > +		extent_len = size - extent_start;
> > +	}
> > +
> > +	if (implied_start < extent_start)
> > +		printf("%d %d %s %s %d\n", implied_start,
> > +				extent_start - implied_start, implied_tgt,
> > +				device, implied_start);
> > +	printf("%d %d %s %s %d\n", extent_start, extent_len, preferred_tgt,
> > +			device, extent_start);
> > +	implied_start = extent_start + extent_len;
> > +}END{
> > +	if (implied_start < size)
> > +		printf("%d %d %s %s %d\n", implied_start, size - implied_start,
> > +				implied_tgt, device, implied_start);
> > +}'
> > +}
> > +
> > +# Update the dm error table so that the range (start, len) maps to the
> > +# preferred dm target, overriding anything that maps to the implied dm target.
> > +# This assumes that the only desired targets for this dm device are the
> > +# preferred and and implied targets.  The optional fifth argument can be used
> > +# to change the underlying device.
> > +__dmerror_change()
> > +{
> > +	local start="$1"
> > +	local len="$2"
> > +	local preferred_tgt="$3"
> > +	local implied_tgt="$4"
> > +	local dm_backing_dev="$5"
> > +	test -z "$dm_backing_dev" && dm_backing_dev="$SCRATCH_DEV"
> > +
> > +	DMERROR_TABLE="$( (echo "$DMERROR_TABLE"; echo "$start $len $preferred_tgt") | \
> > +		awk -v type="$preferred_tgt" '{if ($3 == type) print $0;}' | \
> 
> Same here.
> 
> > +		sort -g | \
> > +		__dmerror_combine_extents | \
> > +		__dmerror_recreate_map "$dm_backing_dev" "$preferred_tgt" \
> > +				"$implied_tgt" )"
> > +}
> > +
> > +# Reset the dm error table to everything ok.  The dm device itself must be
> > +# remapped by calling _dmerror_load_error_table.
> > +_dmerror_reset_table()
> > +{
> > +	DMERROR_TABLE="$DMLINEAR_TABLE"
> > +}
> > +
> > +# Update the dm error table so that IOs to the given range will return EIO.
> > +# The dm device itself must be remapped by calling _dmerror_load_error_table.
> > +_dmerror_mark_range_bad()
> > +{
> > +	local start="$1"
> > +	local len="$2"
> > +
> > +	__dmerror_change "$start" "$len" error linear
> > +}
> > +
> > +# Update the dm error table so that IOs to the given range will succeed.
> > +# The dm device itself must be remapped by calling _dmerror_load_error_table.
> > +_dmerror_mark_range_good()
> > +{
> > +	local start="$1"
> > +	local len="$2"
> > +
> > +	__dmerror_change "$start" "$len" linear error
> > +}
> > diff --git a/tests/xfs/747 b/tests/xfs/747
> > new file mode 100755
> > index 00000000..f5894411
> > --- /dev/null
> > +++ b/tests/xfs/747
> > @@ -0,0 +1,136 @@
> > +#! /bin/bash
> > +# SPDX-License-Identifier: GPL-2.0-or-newer
> > +# Copyright (c) 2019, Oracle and/or its affiliates.  All Rights Reserved.
> > +#
> > +# FS QA Test No. 747
> > +#
> > +# Check xfs_scrub's media scan can actually return diagnostic information for
> > +# media errors in file data extents.
> > +
> > +seq=`basename $0`
> > +seqres=$RESULT_DIR/$seq
> > +echo "QA output created by $seq"
> > +
> > +here=`pwd`
> > +tmp=/tmp/$$
> > +status=1    # failure is the default!
> > +trap "_cleanup; exit \$status" 0 1 2 3 15
> > +
> > +_cleanup()
> > +{
> > +	cd /
> > +	rm -f $tmp.error
> 
> 	rm -f $tmp.*
> 
> would be find. Otherwise files like $tmp.mkfs are still there.

Fixed this too.

> > +	_dmerror_cleanup
> > +}
> > +
> > +# get standard environment, filters and checks
> > +. ./common/rc
> > +. ./common/fuzzy
> > +. ./common/filter
> > +. ./common/dmerror
> > +
> > +# real QA test starts here
> > +_supported_fs xfs
> > +_supported_os Linux
> > +_require_dm_target error
> > +_require_scratch_xfs_crc
> > +_require_scrub
> > +
> > +rm -f $seqres.full
> > +
> > +filter_scrub_errors() {
> > +	_filter_scratch | sed -e "s/offset $((blksz * 2)) /offset 2FSB /g" \
> > +		-e "s/length $blksz.*/length 1FSB./g"
> > +}
> > +
> > +_scratch_mkfs > $tmp.mkfs
> > +_dmerror_init
> > +_dmerror_mount >> $seqres.full 2>&1
> > +
> > +_supports_xfs_scrub $SCRATCH_MNT $SCRATCH_DEV || _notrun "Scrub not supported"
> > +
> > +victim=$SCRATCH_MNT/a
> > +$XFS_IO_PROG -f -c "pwrite -S 0x58 0 1m" -c "fsync" $victim >> $seqres.full
> > +bmap_str="$($XFS_IO_PROG -c "bmap -elpv" $victim | grep "^[[:space:]]*0:")"
> > +echo "$bmap_str" >> $seqres.full
> > +
> > +phys="$(echo "$bmap_str" | awk '{print $3}')"
> > +len="$(echo "$bmap_str" | awk '{print $6}')"
> > +blksz=$(_get_file_block_size $SCRATCH_MNT)
> > +sectors_per_block=$((blksz / 512))
> > +
> > +# Did we get at least 4 fs blocks worth of extent?
> > +min_len_sectors=$(( 4 * sectors_per_block ))
> > +test "$len" -lt $min_len_sectors && \
> > +	_fail "could not format a long enough extent on an empty fs??"
> > +
> > +phys_start=$(echo "$phys" | sed -e 's/\.\..*//g')
> > +
> > +
> > +echo ":$phys:$len:$blksz:$phys_start" >> $seqres.full
> > +echo "victim file:" >> $seqres.full
> > +od -tx1 -Ad -c $victim >> $seqres.full
> > +
> > +# Reset the dmerror table so that all IO will pass through.
> > +_dmerror_reset_table
> > +
> > +cat >> $seqres.full << ENDL
> > +dmerror before:
> > +$DMERROR_TABLE
> > +<end table>
> > +ENDL
> > +
> > +# Now mark /only/ the middle of the extent bad.
> > +_dmerror_mark_range_bad $(( phys_start + (2 * sectors_per_block) + 1 )) 1
> > +
> > +cat >> $seqres.full << ENDL
> > +dmerror after marking bad:
> > +$DMERROR_TABLE
> > +<end table>
> > +ENDL
> > +
> > +_dmerror_load_error_table
> > +
> > +# See if the media scan picks it up.
> > +echo "Scrub for injected media error (single threaded)"
> > +
> > +# Once in single-threaded mode
> > +_scratch_scrub -b -x >> $seqres.full 2> $tmp.error
> > +cat $tmp.error | filter_scrub_errors
> > +
> > +# Once in parallel mode
> > +echo "Scrub for injected media error (multi threaded)"
> > +_scratch_scrub -x >> $seqres.full 2> $tmp.error
> > +cat $tmp.error | filter_scrub_errors
> > +
> > +# Remount to flush the page cache and reread to see the IO error
> > +_dmerror_unmount
> > +_dmerror_mount
> > +echo "victim file:" >> $seqres.full
> > +od -tx1 -Ad -c $victim >> $seqres.full 2> $tmp.error
> > +cat $tmp.error | _filter_scratch
> > +
> > +# Scrub again to re-confirm the media error across a remount
> > +echo "Scrub for injected media error (after remount)"
> > +_scratch_scrub -x >> $seqres.full 2> $tmp.error
> > +cat $tmp.error | filter_scrub_errors
> > +
> > +# Now mark the bad range good.
> > +_dmerror_mark_range_good $(( phys_start + (2 * sectors_per_block) + 1 )) 1
> > +_dmerror_load_error_table
> > +
> > +cat >> $seqres.full << ENDL
> > +dmerror after marking good:
> > +$DMERROR_TABLE
> > +<end table>
> > +ENDL
> > +
> > +echo "Scrub after removing injected media error"
> > +
> > +# Scrub one last time to make sure the error's gone.
> > +_scratch_scrub -x >> $seqres.full 2> $tmp.error
> > +cat $tmp.error | filter_scrub_errors
> > +
> > +# success, all done
> > +status=0
> > +exit
> > diff --git a/tests/xfs/747.out b/tests/xfs/747.out
> > new file mode 100644
> > index 00000000..f85f1753
> > --- /dev/null
> > +++ b/tests/xfs/747.out
> > @@ -0,0 +1,12 @@
> > +QA output created by 747
> > +Scrub for injected media error (single threaded)
> > +Unfixable Error: SCRATCH_MNT/a: media error at data offset 2FSB length 1FSB.
> > +SCRATCH_MNT: unfixable errors found: 1
> > +Scrub for injected media error (multi threaded)
> > +Unfixable Error: SCRATCH_MNT/a: media error at data offset 2FSB length 1FSB.
> > +SCRATCH_MNT: unfixable errors found: 1
> > +od: SCRATCH_MNT/a: read error: Input/output error
> > +Scrub for injected media error (after remount)
> > +Unfixable Error: SCRATCH_MNT/a: media error at data offset 2FSB length 1FSB.
> > +SCRATCH_MNT: unfixable errors found: 1
> > +Scrub after removing injected media error
> > diff --git a/tests/xfs/748 b/tests/xfs/748
> > new file mode 100755
> > index 00000000..130cc6f2
> > --- /dev/null
> > +++ b/tests/xfs/748
> > @@ -0,0 +1,102 @@
> > +#! /bin/bash
> > +# SPDX-License-Identifier: GPL-2.0-or-newer
> > +# Copyright (c) 2019, Oracle and/or its affiliates.  All Rights Reserved.
> > +#
> > +# FS QA Test No. 748
> > +#
> > +# Check xfs_scrub's media scan can actually return diagnostic information for
> > +# media errors in filesystem metadata.
> > +
> > +seq=`basename $0`
> > +seqres=$RESULT_DIR/$seq
> > +echo "QA output created by $seq"
> > +
> > +here=`pwd`
> > +tmp=/tmp/$$
> > +status=1    # failure is the default!
> > +trap "_cleanup; exit \$status" 0 1 2 3 15
> > +
> > +_cleanup()
> > +{
> > +	cd /
> > +	rm -f $tmp.error $tmp.fsmap
> 
> rm -f $tmp.*
> 
> > +	_dmerror_cleanup
> > +}
> > +
> > +# get standard environment, filters and checks
> > +. ./common/rc
> > +. ./common/fuzzy
> > +. ./common/filter
> > +. ./common/dmerror
> > +
> > +# real QA test starts here
> > +_supported_fs xfs
> > +_supported_os Linux
> > +_require_dm_target error
> > +_require_xfs_scratch_rmapbt
> 
> Add a comment on why rmapbt is needed?

"rmapbt is required to enable reporting of what metadata was lost."

--D

> Thanks,
> Eryu
> 
> > +_require_scrub
> > +
> > +rm -f $seqres.full
> > +
> > +filter_scrub_errors() {
> > +	_filter_scratch | sed -e "s/disk offset [0-9]*: /disk offset NNN: /g" \
> > +		-e "/errors found:/d" -e 's/phase6.c line [0-9]*/!/g' \
> > +		-e "/corruptions found:/d" | uniq
> > +}
> > +
> > +_scratch_mkfs > $tmp.mkfs
> > +_dmerror_init
> > +_dmerror_mount >> $seqres.full 2>&1
> > +
> > +_supports_xfs_scrub $SCRATCH_MNT $SCRATCH_DEV || _notrun "Scrub not supported"
> > +
> > +# Create a bunch of metadata so that we can mark them bad in the next step.
> > +victim=$SCRATCH_MNT/a
> > +$FSSTRESS_PROG -z -n 200 -p 10 \
> > +	       -f creat=10 \
> > +	       -f resvsp=1 \
> > +	       -f truncate=1 \
> > +	       -f punch=1 \
> > +	       -f chown=5 \
> > +	       -f mkdir=5 \
> > +	       -f mknod=1 \
> > +	       -d $victim >> $seqres.full 2>&1
> > +
> > +# Mark all the metadata bad
> > +_dmerror_reset_table
> > +$XFS_IO_PROG -c "fsmap -n100 -vvv" $victim | grep inodes > $tmp.fsmap
> > +while read a b c crap; do
> > +	phys="$(echo $c | sed -e 's/^.\([0-9]*\)\.\.\([0-9]*\).*$/\1:\2/g')"
> > +	target_begin="$(echo "$phys" | cut -d ':' -f 1)"
> > +	target_end="$(echo "$phys" | cut -d ':' -f 2)"
> > +
> > +	_dmerror_mark_range_bad $target_begin $((target_end - target_begin))
> > +done < $tmp.fsmap
> > +cat $tmp.fsmap >> $seqres.full
> > +
> > +cat >> $seqres.full << ENDL
> > +dmerror after marking bad:
> > +$DMERROR_TABLE
> > +<end table>
> > +ENDL
> > +
> > +_dmerror_load_error_table
> > +
> > +# See if the media scan picks it up.
> > +echo "Scrub for injected media error"
> > +
> > +XFS_SCRUB_PHASE=6 _scratch_scrub -x >> $seqres.full 2> $tmp.error
> > +cat $tmp.error | filter_scrub_errors
> > +
> > +# Make the disk work again
> > +_dmerror_load_working_table
> > +
> > +echo "Scrub after removing injected media error"
> > +
> > +# Scrub one last time to make sure the error's gone.
> > +XFS_SCRUB_PHASE=6 _scratch_scrub -x >> $seqres.full 2> $tmp.error
> > +cat $tmp.error | filter_scrub_errors
> > +
> > +# success, all done
> > +status=0
> > +exit
> > diff --git a/tests/xfs/748.out b/tests/xfs/748.out
> > new file mode 100644
> > index 00000000..49dc2d7a
> > --- /dev/null
> > +++ b/tests/xfs/748.out
> > @@ -0,0 +1,5 @@
> > +QA output created by 748
> > +Scrub for injected media error
> > +Corruption: disk offset NNN: media error in inodes. (!)
> > +SCRATCH_MNT: Unmount and run xfs_repair.
> > +Scrub after removing injected media error
> > diff --git a/tests/xfs/group b/tests/xfs/group
> > index 18a593d9..3a58864b 100644
> > --- a/tests/xfs/group
> > +++ b/tests/xfs/group
> > @@ -509,3 +509,5 @@
> >  510 auto ioctl quick
> >  511 auto quick quota
> >  741 auto quick rw
> > +747 auto quick scrub
> > +748 auto quick scrub
> > 
