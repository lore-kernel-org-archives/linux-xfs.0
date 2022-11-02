Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A64D1C433FE
	for <linux-xfs@archiver.kernel.org>; Wed,  2 Nov 2022 03:47:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230312AbiKBDrM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 1 Nov 2022 23:47:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230298AbiKBDrK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 1 Nov 2022 23:47:10 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4570A2716C
        for <linux-xfs@vger.kernel.org>; Tue,  1 Nov 2022 20:46:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667360768;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=1WhZ9J/XZ82vLg6ea9SKWs7FSqPoI4Z2U+CBd9LsgXM=;
        b=Rlk1WuqiauqDoxBZF5Wu6nxzmXH8bguxP5Fh+/G+8yMe/ZKe/9GsGd8fVBuj0s8mtk2VPd
        kl6zeEKWrRRAHiBEh6X5ESI9H1xM5vb+bo+G71CBgZLQ7+MJLdwoOxL+NOaP+7bX3h8Fa5
        a8sTg2QuERmTxi3/lsL1Igk7oCYU+Rw=
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-332-8qLRs-ZcMquyW1iIxpEnfA-1; Tue, 01 Nov 2022 23:46:05 -0400
X-MC-Unique: 8qLRs-ZcMquyW1iIxpEnfA-1
Received: by mail-pl1-f198.google.com with SMTP id a6-20020a170902ecc600b00186f035ed74so11175621plh.12
        for <linux-xfs@vger.kernel.org>; Tue, 01 Nov 2022 20:46:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1WhZ9J/XZ82vLg6ea9SKWs7FSqPoI4Z2U+CBd9LsgXM=;
        b=J/bd9tw3cmfrKHnC5ymqo/A0/QkyFjlXeQtnpQpg4PYWC8FAhDDbGjYBTqUFU+CNBh
         BPsiMQOylQPNkdDGsS7IZRshslcO+bbO73qPZ2A/fFxR3s6JgB8uR6awm2Pypxffre1G
         7uiBf02QbPQlLYHOwMmJzuelIXCNkXUPN1po9oPcn/tvqN4fAds7t71aEl3Ik9/1mKoe
         /Qo8YeFh84XortOSbdlJtVUVk/EaxkpbCTOqfaiWm/glnPaE4rkOp6eEJW26Dsg6Q/3G
         SKZI8ktNAO+O+qhGiczd5Q6Bx++4tBlZfrs+53JbJVUksiTqs4t/P4LnYRfnxY8q9Ho4
         Tenw==
X-Gm-Message-State: ACrzQf2JlJtmP71tyJP7dvG96upq/yZDDj3Cr/yuo1RUThOzr8MHAXOm
        lEaO1tsc63+sZZ1lb08NAmZ7JPEJrLI6jBcd4nEYFfVSd12Ojg8ST33xo3SPUT2Bmy2qvtAnrr9
        hi/5Jb7zNjM73w7uVU2HV
X-Received: by 2002:a63:5c5a:0:b0:46e:be05:a79a with SMTP id n26-20020a635c5a000000b0046ebe05a79amr20134247pgm.138.1667360764207;
        Tue, 01 Nov 2022 20:46:04 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM6rII9NaRtwvuul27Aj7enBgNSCXkrjFfcPy7N4OjXxPUN9lWTse3ablLFC4rD8xZt69N6Mpw==
X-Received: by 2002:a63:5c5a:0:b0:46e:be05:a79a with SMTP id n26-20020a635c5a000000b0046ebe05a79amr20134226pgm.138.1667360763622;
        Tue, 01 Nov 2022 20:46:03 -0700 (PDT)
Received: from zlang-mailbox ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id i7-20020a170902c94700b00186b7443082sm7068650pla.195.2022.11.01.20.46.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Nov 2022 20:46:02 -0700 (PDT)
Date:   Wed, 2 Nov 2022 11:45:58 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 1/1] xfs: test xfs_scrub phase 6 media error reporting
Message-ID: <20221102034558.v56yuo7dnlobjlqm@zlang-mailbox>
References: <166613311327.868072.4009665862280713748.stgit@magnolia>
 <166613311880.868072.17189668251232287066.stgit@magnolia>
 <20221101164345.uirkzgnakgikw2zm@zlang-mailbox>
 <Y2HBBuZahPXSdy34@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y2HBBuZahPXSdy34@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Nov 01, 2022 at 05:59:50PM -0700, Darrick J. Wong wrote:
> On Wed, Nov 02, 2022 at 12:43:45AM +0800, Zorro Lang wrote:
> > On Tue, Oct 18, 2022 at 03:45:18PM -0700, Darrick J. Wong wrote:
> > > From: Darrick J. Wong <djwong@kernel.org>
> > > 
> > > Add new helpers to dmerror to provide for marking selected ranges
> > > totally bad -- both reads and writes will fail.  Create a new test for
> > > xfs_scrub to check that it reports media errors in data files correctly.
> > > 
> > > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > > ---
> > >  common/dmerror    |  136 +++++++++++++++++++++++++++++++++++++++++++++--
> > >  common/xfs        |    9 +++
> > >  tests/xfs/747     |  155 +++++++++++++++++++++++++++++++++++++++++++++++++++++
> > >  tests/xfs/747.out |   12 ++++
> > >  4 files changed, 309 insertions(+), 3 deletions(-)
> > >  create mode 100755 tests/xfs/747
> > >  create mode 100644 tests/xfs/747.out
> > > 
> > > 
> > > diff --git a/common/dmerror b/common/dmerror
> > > index 54122b12ea..58ab461e0e 100644
> > > --- a/common/dmerror
> > > +++ b/common/dmerror
> > > @@ -159,16 +159,16 @@ _dmerror_load_error_table()
> > >  	fi
> > >  
> > >  	# Load new table
> > > -	$DMSETUP_PROG load error-test --table "$DMERROR_TABLE"
> > > +	echo "$DMERROR_TABLE" | $DMSETUP_PROG load error-test
> > >  	load_res=$?
> > >  
> > >  	if [ -n "$NON_ERROR_RTDEV" ]; then
> > > -		$DMSETUP_PROG load error-rttest --table "$DMERROR_RTTABLE"
> > > +		echo "$DMERROR_RTTABLE" | $DMSETUP_PROG load error-rttest
> > >  		[ $? -ne 0 ] && _fail "failed to load error table into error-rttest"
> > >  	fi
> > >  
> > >  	if [ -n "$NON_ERROR_LOGDEV" ]; then
> > > -		$DMSETUP_PROG load error-logtest --table "$DMERROR_LOGTABLE"
> > > +		echo "$DMERROR_LOGTABLE" | $DMSETUP_PROG load error-logtest
> > 
> > Hi,
> > 
> > Is there any reason about why we need to replace "dmsetup --table $table" with
> > "echo $table | dmsetup"?
> 
> Once we poke enough dmerror holes into the mapping, $table becomes a
> multiline string, and I feel that pipes are better suited to that usage
> than stuffing a huge string into argv[].

Oh, make sense.

> 
> That said, I don't have any plans to create multigigabyte table
> definitions, so it's no big deal to switch them back.

If we haven't hit any real problems, how about do this change in a seperated
patch when we need it, and at that time you might like to change other
common/dmxxxx (e.g. dmflakey, dmthin ...) with this dmerror together?

> 
> > >  		[ $? -ne 0 ] && _fail "failed to load error table into error-logtest"
> > >  	fi
> > >  
> > > @@ -250,3 +250,133 @@ _dmerror_load_working_table()
> > >  	[ $load_res -ne 0 ] && _fail "dmsetup failed to load error table"
> > >  	[ $resume_res -ne 0 ] && _fail  "dmsetup resume failed"
> > >  }
> > > +
> > > +# Given a list of (start, length) tuples on stdin, combine adjacent tuples into
> > > +# larger ones and write the new list to stdout.
> > > +__dmerror_combine_extents()
> > > +{
> > > +	awk 'BEGIN{start = 0; len = 0;}{
> > > +if (start + len == $1) {
> > > +	len += $2;
> > > +} else {
> > > +	if (len > 0)
> > > +		printf("%d %d\n", start, len);
> > > +	start = $1;
> > > +	len = $2;
> > > +}
> > > +} END {
> > > +	if (len > 0)
> > > +		printf("%d %d\n", start, len);
> > > +}'
> > > +}
> > > +
> > > +# Given a block device, the name of a preferred dm target, the name of an
> > > +# implied dm target, and a list of (start, len) tuples on stdin, create a new
> > > +# dm table which maps each of the tuples to the preferred target and all other
> > > +# areas to the implied dm target.
> > > +__dmerror_recreate_map()
> > > +{
> > > +	local device="$1"
> > > +	local preferred_tgt="$2"
> > > +	local implied_tgt="$3"
> > > +	local size=$(blockdev --getsz "$device")
> > > +
> > > +	awk -v device="$device" -v size=$size -v implied_tgt="$implied_tgt" \
> > > +		-v preferred_tgt="$preferred_tgt" 'BEGIN{implied_start = 0;}{
> > > +	extent_start = $1;
> > > +	extent_len = $2;
> > > +
> > > +	if (extent_start > size) {
> > > +		extent_start = size;
> > > +		extent_len = 0;
> > > +	} else if (extent_start + extent_len > size) {
> > > +		extent_len = size - extent_start;
> > > +	}
> > > +
> > > +	if (implied_start < extent_start)
> > > +		printf("%d %d %s %s %d\n", implied_start,
> > > +				extent_start - implied_start, implied_tgt,
> > > +				device, implied_start);
> > > +	printf("%d %d %s %s %d\n", extent_start, extent_len, preferred_tgt,
> > > +			device, extent_start);
> > > +	implied_start = extent_start + extent_len;
> > > +}END{
> > > +	if (implied_start < size)
> > > +		printf("%d %d %s %s %d\n", implied_start, size - implied_start,
> > > +				implied_tgt, device, implied_start);
> > > +}'
> > 
> > Above indentation (of awk code mix with bash function) is a little confused ...
> 
> I'm not sure how to make it any prettier -- embedding code from one
> language into a function written in a different but similar language is
> always going to be fugly.
> 
> Predefining the awk program text as a global string would avoid that but
> pollute the global namespace.
> 
> I could indent the entire awk program so the indent might be less weird:
> 
> __dmerror_recreate_map()
> {
> 	local device="$1"
> 	local preferred_tgt="$2"
> 	local implied_tgt="$3"
> 	local size=$(blockdev --getsz "$device")
> 
> 	awk -v device="$device" -v size=$size -v implied_tgt="$implied_tgt" \
> 		-v preferred_tgt="$preferred_tgt" '
> 	BEGIN {
> 		implied_start = 0;
> 	}
> 	{
> 		extent_start = $1;
> 		extent_len = $2;
> 
> 		if (extent_start > size) {
> 			extent_start = size;
> 			extent_len = 0;
> 		} else if (extent_start + extent_len > size) {
> 			extent_len = size - extent_start;
> 		}
> 
> 		if (implied_start < extent_start)
> 			printf("%d %d %s %s %d\n", implied_start,
> 					extent_start - implied_start,
> 					implied_tgt, device, implied_start);
> 		printf("%d %d %s %s %d\n", extent_start, extent_len,
> 				preferred_tgt, device, extent_start);
> 		implied_start = extent_start + extent_len;
> 	}
> 	END {
> 		if (implied_start < size)
> 			printf("%d %d %s %s %d\n", implied_start,
> 					size - implied_start, implied_tgt,
> 					device, implied_start);
> 	}'
> }
> 
> but now the awk code has the same level of indenting as the bash code.

Yeah, it's hard to say how to deal with the format of long embedded code, but
this one looks better to me, and I think we can add two comment lines to mark
the 'start and end' of the embedded awk program. I think we can change this
function and __dmerror_combine_extents() like that.

> 
> I could put a comment at the end noting that we're switching from awk
> back to bash, or I could define the awk program as a local string, but I
> don't think that's going to clear things up that much...
> 
> __dmerror_recreate_map()
> {
> 	local device="$1"
> 	local preferred_tgt="$2"
> 	local implied_tgt="$3"
> 	local size=$(blockdev --getsz "$device")
> 
> 	local awk_program='
> 	BEGIN {
> 		implied_start = 0;
> 	}
> 	{
> 		extent_start = $1;
> 		extent_len = $2;
> 
> 		if (extent_start > size) {
> 			extent_start = size;
> 			extent_len = 0;
> 		} else if (extent_start + extent_len > size) {
> 			extent_len = size - extent_start;
> 		}
> 
> 		if (implied_start < extent_start)
> 			printf("%d %d %s %s %d\n", implied_start,
> 					extent_start - implied_start,
> 					implied_tgt, device, implied_start);
> 		printf("%d %d %s %s %d\n", extent_start, extent_len,
> 				preferred_tgt, device, extent_start);
> 		implied_start = extent_start + extent_len;
> 	}
> 	END {
> 		if (implied_start < size)
> 			printf("%d %d %s %s %d\n", implied_start,
> 					size - implied_start, implied_tgt,
> 					device, implied_start);
> 	}'
> 
> 	awk -v device="$device" -v size=$size -v implied_tgt="$implied_tgt" \
> 		-v preferred_tgt="$preferred_tgt" "$awk_program"
> }
> 
> Hm?
> 
> > > +}
> > > +
> > > +# Update the dm error table so that the range (start, len) maps to the
> > > +# preferred dm target, overriding anything that maps to the implied dm target.
> > > +# This assumes that the only desired targets for this dm device are the
> > > +# preferred and and implied targets.  The fifth argument is the scratch device
> > > +# that we want to change the table for.
> > > +__dmerror_change()
> > > +{
> > > +	local start="$1"
> > > +	local len="$2"
> > > +	local preferred_tgt="$3"
> > > +	local implied_tgt="$4"
> > > +	local whichdev="$5"
> > 
> > local old_table ?
> > local new_table ?
> 
> Oops.  Fixed.
> 
> > > +
> > > +	case "$whichdev" in
> > > +	"SCRATCH_DEV"|"")	whichdev="$SCRATCH_DEV";;
> > > +	"SCRATCH_LOGDEV"|"LOG")	whichdev="$NON_ERROR_LOGDEV";;
> > > +	"SCRATCH_RTDEV"|"RT")	whichdev="$NON_ERROR_RTDEV";;
> > > +	esac
> > > +
> > > +	case "$whichdev" in
> > > +	"$SCRATCH_DEV")		old_table="$DMERROR_TABLE";;
> > > +	"$NON_ERROR_LOGDEV")	old_table="$DMERROR_LOGTABLE";;
> > > +	"$NON_ERROR_RTDEV")	old_table="$DMERROR_RTTABLE";;
> > > +	*)
> > > +		echo "$whichdev: Unknown dmerror device."
> > > +		return
> > > +		;;
> > > +	esac
> > > +
> > > +	new_table="$( (echo "$old_table"; echo "$start $len $preferred_tgt") | \
> > > +		awk -v type="$preferred_tgt" '{if ($3 == type) print $0;}' | \
> > > +		sort -g | \
> > > +		__dmerror_combine_extents | \
> > > +		__dmerror_recreate_map "$whichdev" "$preferred_tgt" \
> > > +				"$implied_tgt" )"
> > > +
> > > +	case "$whichdev" in
> > > +	"$SCRATCH_DEV")		DMERROR_TABLE="$new_table";;
> > > +	"$NON_ERROR_LOGDEV")	DMERROR_LOGTABLE="$new_table";;
> > > +	"$NON_ERROR_RTDEV")	DMERROR_RTTABLE="$new_table";;
> > > +	esac
> > > +}
> > > +
> > > +# Reset the dm error table to everything ok.  The dm device itself must be
> > > +# remapped by calling _dmerror_load_error_table.
> > > +_dmerror_reset_table()
> > > +{
> > > +	DMERROR_TABLE="$DMLINEAR_TABLE"
> > > +	DMERROR_LOGTABLE="$DMLINEAR_LOGTABLE"
> > > +	DMERROR_RTTABLE="$DMLINEAR_RTTABLE"
> > > +}
> > > +
> > > +# Update the dm error table so that IOs to the given range will return EIO.
> > > +# The dm device itself must be remapped by calling _dmerror_load_error_table.
> > > +_dmerror_mark_range_bad()
> > > +{
> > > +	local start="$1"
> > > +	local len="$2"
> > > +	local dev="$3"
> > > +
> > > +	__dmerror_change "$start" "$len" error linear "$dev"
> > > +}
> > > +
> > > +# Update the dm error table so that IOs to the given range will succeed.
> > > +# The dm device itself must be remapped by calling _dmerror_load_error_table.
> > > +_dmerror_mark_range_good()
> > > +{
> > > +	local start="$1"
> > > +	local len="$2"
> > > +	local dev="$3"
> > > +
> > > +	__dmerror_change "$start" "$len" linear error "$dev"
> > > +}
> > > diff --git a/common/xfs b/common/xfs
> > > index e1c15d3d04..2cd8254937 100644
> > > --- a/common/xfs
> > > +++ b/common/xfs
> > > @@ -194,6 +194,15 @@ _xfs_get_file_block_size()
> > >  	$XFS_INFO_PROG "$path" | grep realtime | sed -e 's/^.*extsz=\([0-9]*\).*$/\1/g'
> > >  }
> > >  
> > > +# Decide if this path is a file on the realtime device
> > > +_xfs_is_realtime_file()
> > > +{
> > > +	if [ "$USE_EXTERNAL" != "yes" ] || [ -z "$SCRATCH_RTDEV" ]; then
> > > +		return 1
> > > +	fi
> > > +	$XFS_IO_PROG -c 'stat -v' "$1" | grep -q -w realtime
> > > +}
> > > +
> > >  # Set or clear the realtime status of every supplied path.  The first argument
> > >  # is either 'data' or 'realtime'.  All other arguments should be paths to
> > >  # existing directories or empty regular files.
> > > diff --git a/tests/xfs/747 b/tests/xfs/747
> > 
> > I tried this case, and got below error, looks like the od error output need a filter?
> > 
> > # ./check -s simpledev -s logdev xfs/747
> > SECTION       -- simpledev
> > FSTYP         -- xfs (debug)
> > PLATFORM      -- Linux/x86_64 hp-dl380pg8-01 6.1.0-rc3 #5 SMP PREEMPT_DYNAMIC Tue Nov  1 01:08:52 CST 2022
> > MKFS_OPTIONS  -- -f /dev/sda3
> > MOUNT_OPTIONS -- -o context=system_u:object_r:root_t:s0 /dev/sda3 /mnt/scratch
> > 
> > xfs/747       - output mismatch (see /root/git/xfstests/results//simpledev/xfs/747.out.bad)
> >     --- tests/xfs/747.out       2022-11-01 14:48:56.990683131 +0800
> >     +++ /root/git/xfstests/results//simpledev/xfs/747.out.bad   2022-11-01 19:38:34.825632961 +0800
> >     @@ -5,7 +5,7 @@
> >      Scrub for injected media error (multi threaded)
> >      Unfixable Error: SCRATCH_MNT/a: media error at data offset 2FSB length 1FSB.
> >      SCRATCH_MNT: unfixable errors found: 1
> >     -od: SCRATCH_MNT/a: read error: Input/output error
> >     +od: SCRATCH_MNT/a: Input/output error
> 
> Err, what operating system is this?

# lsb_release -a
LSB Version:    :core-4.1-amd64:core-4.1-noarch
Distributor ID: Fedora
Description:    Fedora release 38 (Rawhide)
Release:        38
Codename:       Rawhide
# uname -r
6.1.0-rc3
# rpm -qf `type -P od`
coreutils-9.1-8.fc38.x86_64
 uname -r
6.1.0-rc3

> 
> --D
> 
> > 
> > > new file mode 100755
> > > index 0000000000..8952c24ee6
> > > --- /dev/null
> > > +++ b/tests/xfs/747
> > > @@ -0,0 +1,155 @@
> > > +#! /bin/bash
> > > +# SPDX-License-Identifier: GPL-2.0-or-later
> > > +# Copyright (c) 2022 Oracle.  All Rights Reserved.
> > > +#
> > > +# FS QA Test No. 747
> > > +#
> > > +# Check xfs_scrub's media scan can actually return diagnostic information for
> > > +# media errors in file data extents.
> > > +
> > > +. ./common/preamble
> > > +_begin_fstest auto quick scrub
> > 
> >   eio ?

Thanks,
Zorro

> > 
> > Thanks,
> > Zorro
> > 
> > > +
> > > +# Override the default cleanup function.
> > > +_cleanup()
> > > +{
> > > +	cd /
> > > +	rm -f $tmp.*
> > > +	_dmerror_cleanup
> > > +}
> > > +
> > > +# Import common functions.
> > > +. ./common/fuzzy
> > > +. ./common/filter
> > > +. ./common/dmerror
> > > +
> > > +# real QA test starts here
> > > +_supported_fs xfs
> > > +_require_dm_target error
> > > +_require_scratch
> > > +_require_scratch_xfs_crc
> > > +_require_scrub
> > > +
> > > +filter_scrub_errors() {
> > > +	_filter_scratch | sed \
> > > +		-e "s/offset $((fs_blksz * 2)) /offset 2FSB /g" \
> > > +		-e "s/length $fs_blksz.*/length 1FSB./g"
> > > +}
> > > +
> > > +_scratch_mkfs >> $seqres.full
> > > +_dmerror_init
> > > +_dmerror_mount >> $seqres.full 2>&1
> > > +
> > > +_supports_xfs_scrub $SCRATCH_MNT $SCRATCH_DEV || _notrun "Scrub not supported"
> > > +
> > > +# Write a file with 4 file blocks worth of data
> > > +victim=$SCRATCH_MNT/a
> > > +file_blksz=$(_get_file_block_size $SCRATCH_MNT)
> > > +$XFS_IO_PROG -f -c "pwrite -S 0x58 0 $((4 * file_blksz))" -c "fsync" $victim >> $seqres.full
> > > +unset errordev
> > > +_xfs_is_realtime_file $victim && errordev="RT"
> > > +bmap_str="$($XFS_IO_PROG -c "bmap -elpv" $victim | grep "^[[:space:]]*0:")"
> > > +echo "$errordev:$bmap_str" >> $seqres.full
> > > +
> > > +phys="$(echo "$bmap_str" | $AWK_PROG '{print $3}')"
> > > +if [ "$errordev" = "RT" ]; then
> > > +	len="$(echo "$bmap_str" | $AWK_PROG '{print $4}')"
> > > +else
> > > +	len="$(echo "$bmap_str" | $AWK_PROG '{print $6}')"
> > > +fi
> > > +fs_blksz=$(_get_block_size $SCRATCH_MNT)
> > > +echo "file_blksz:$file_blksz:fs_blksz:$fs_blksz" >> $seqres.full
> > > +kernel_sectors_per_fs_block=$((fs_blksz / 512))
> > > +
> > > +# Did we get at least 4 fs blocks worth of extent?
> > > +min_len_sectors=$(( 4 * kernel_sectors_per_fs_block ))
> > > +test "$len" -lt $min_len_sectors && \
> > > +	_fail "could not format a long enough extent on an empty fs??"
> > > +
> > > +phys_start=$(echo "$phys" | sed -e 's/\.\..*//g')
> > > +
> > > +echo "$errordev:$phys:$len:$fs_blksz:$phys_start" >> $seqres.full
> > > +echo "victim file:" >> $seqres.full
> > > +od -tx1 -Ad -c $victim >> $seqres.full
> > > +
> > > +# Set the dmerror table so that all IO will pass through.
> > > +_dmerror_reset_table
> > > +
> > > +cat >> $seqres.full << ENDL
> > > +dmerror before:
> > > +$DMERROR_TABLE
> > > +$DMERROR_RTTABLE
> > > +<end table>
> > > +ENDL
> > > +
> > > +# All sector numbers that we feed to the kernel must be in units of 512b, but
> > > +# they also must be aligned to the device's logical block size.
> > > +logical_block_size=$(_min_dio_alignment $SCRATCH_DEV)
> > > +kernel_sectors_per_device_lba=$((logical_block_size / 512))
> > > +
> > > +# Mark as bad one of the device LBAs in the middle of the extent.  Target the
> > > +# second LBA of the third block of the four-block file extent that we allocated
> > > +# earlier, but without overflowing into the fourth file block.
> > > +bad_sector=$(( phys_start + (2 * kernel_sectors_per_fs_block) ))
> > > +bad_len=$kernel_sectors_per_device_lba
> > > +if (( kernel_sectors_per_device_lba < kernel_sectors_per_fs_block )); then
> > > +	bad_sector=$((bad_sector + kernel_sectors_per_device_lba))
> > > +fi
> > > +if (( (bad_sector % kernel_sectors_per_device_lba) != 0)); then
> > > +	echo "bad_sector $bad_sector not congruent with device logical block size $logical_block_size"
> > > +fi
> > > +_dmerror_mark_range_bad $bad_sector $bad_len $errordev
> > > +
> > > +cat >> $seqres.full << ENDL
> > > +dmerror after marking bad:
> > > +$DMERROR_TABLE
> > > +$DMERROR_RTTABLE
> > > +<end table>
> > > +ENDL
> > > +
> > > +_dmerror_load_error_table
> > > +
> > > +# See if the media scan picks it up.
> > > +echo "Scrub for injected media error (single threaded)"
> > > +
> > > +# Once in single-threaded mode
> > > +_scratch_scrub -b -x >> $seqres.full 2> $tmp.error
> > > +cat $tmp.error | filter_scrub_errors
> > > +
> > > +# Once in parallel mode
> > > +echo "Scrub for injected media error (multi threaded)"
> > > +_scratch_scrub -x >> $seqres.full 2> $tmp.error
> > > +cat $tmp.error | filter_scrub_errors
> > > +
> > > +# Remount to flush the page cache and reread to see the IO error
> > > +_dmerror_unmount
> > > +_dmerror_mount
> > > +echo "victim file:" >> $seqres.full
> > > +od -tx1 -Ad -c $victim >> $seqres.full 2> $tmp.error
> > > +cat $tmp.error | _filter_scratch
> > > +
> > > +# Scrub again to re-confirm the media error across a remount
> > > +echo "Scrub for injected media error (after remount)"
> > > +_scratch_scrub -x >> $seqres.full 2> $tmp.error
> > > +cat $tmp.error | filter_scrub_errors
> > > +
> > > +# Now mark the bad range good so that a retest shows no media failure.
> > > +_dmerror_mark_range_good $bad_sector $bad_len $errordev
> > > +_dmerror_load_error_table
> > > +
> > > +cat >> $seqres.full << ENDL
> > > +dmerror after marking good:
> > > +$DMERROR_TABLE
> > > +$DMERROR_RTTABLE
> > > +<end table>
> > > +ENDL
> > > +
> > > +echo "Scrub after removing injected media error"
> > > +
> > > +# Scrub one last time to make sure the error's gone.
> > > +_scratch_scrub -x >> $seqres.full 2> $tmp.error
> > > +cat $tmp.error | filter_scrub_errors
> > > +
> > > +# success, all done
> > > +status=0
> > > +exit
> > > diff --git a/tests/xfs/747.out b/tests/xfs/747.out
> > > new file mode 100644
> > > index 0000000000..f85f1753a6
> > > --- /dev/null
> > > +++ b/tests/xfs/747.out
> > > @@ -0,0 +1,12 @@
> > > +QA output created by 747
> > > +Scrub for injected media error (single threaded)
> > > +Unfixable Error: SCRATCH_MNT/a: media error at data offset 2FSB length 1FSB.
> > > +SCRATCH_MNT: unfixable errors found: 1
> > > +Scrub for injected media error (multi threaded)
> > > +Unfixable Error: SCRATCH_MNT/a: media error at data offset 2FSB length 1FSB.
> > > +SCRATCH_MNT: unfixable errors found: 1
> > > +od: SCRATCH_MNT/a: read error: Input/output error
> > > +Scrub for injected media error (after remount)
> > > +Unfixable Error: SCRATCH_MNT/a: media error at data offset 2FSB length 1FSB.
> > > +SCRATCH_MNT: unfixable errors found: 1
> > > +Scrub after removing injected media error
> > > 
> > 
> 

