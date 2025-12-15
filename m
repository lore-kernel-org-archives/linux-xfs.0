Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8ECBF2BD58C
	for <linux-xfs@vger.kernel.org>; Mon, 15 Dec 2025 15:43:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765813385; cv=none; b=Mu6D3R2uOt9TBeMm8GVwWpVeoyDFe5mWhMZYAzzCKxthsyJRZcyJKOD6CZWsOeQg9k5QgVWeVulg/aBY6IYSJEMXSKn04QpXREZEGE5doO4h2xi6dysHHXdnVE/c1jZfSmVmQpIj+3Cx+Dg4Ylu5B3PfrEqjuPtvDjUhyh6x/XU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765813385; c=relaxed/simple;
	bh=JRpz7Yn6Pa3Gw9HOa2S3wyYPn2jlxQy4a+wetX2L6qM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=j9BBjaEAeucJpyie7EqT/chGv7W0D809T6YttYn2nlkY9mjR5PL3aewbQdFcLqvSDM0dvEgir/Ax16+0TyhhEXOry528G5dlbuYxKOSvhUY/yl8v9TmZAcRmpp1+nz1IVe3UrmFUYbHVdVFwJO2h64KnR/Z6O5HfxkjFrgwPNdo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=M6a6uapd; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="M6a6uapd"
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-47774d3536dso36683595e9.0
        for <linux-xfs@vger.kernel.org>; Mon, 15 Dec 2025 07:43:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765813379; x=1766418179; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=zNNCPPxCO6unzQHp+pM2ueX0B+I3nveRfgTsZEr8cWg=;
        b=M6a6uapdyv1Tnlub5fNP9Qy9s23kPcqNSwKB7PXqVxZw3Ah/Z9f1Z8glxA5RdtSQZx
         HfcOTJmOmaVMnUq4FFQxD+/bUr+mlQGJVHjk18lGZ4NjvmLMI3G/wnKu/blIvY9atgDU
         Cpu06MO6qA1Y4GVUXed0SiWsSrNP2ab0Mhv8FlXeE8eOi9p7t5MtYLrAVhFO4aO7agAz
         mHlZ0Vmsl+ZvGfwkIyw3HpdXiaBLD25pRI41AirH12mQT3mAXVLxANz2GpsB0GclZ2Ea
         oIs2i1gIvpBBQZGKEo6y2wbU2sivneoLDogQA9qQZz2FQrPLW+su27LGRBfHn0kFgrRa
         5xyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765813379; x=1766418179;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zNNCPPxCO6unzQHp+pM2ueX0B+I3nveRfgTsZEr8cWg=;
        b=JrVhBtujKkLkHZd/W8GhrQrJw6kFIGr41QapDcOvCFZjeyJlmGZy+Xi+7kAccRv5IK
         HbnijKH6zG3TS8NX/CvRB+g/fYzJv4ojMRXS3VFPTXGM0ZZGeAfMe4YbUcfFkzznUL2Z
         ybyRm0su1Uh1h1pXdV5Y93xMMbwpZ9IfyhTE9dxtUX0/IZvMdCHwmTvNqbiMPYJ/+lyN
         8eHsmk1hvK/9YrqGn/cGWLc27O0NY4R0VFbFlAqD/Sb2zYEgVoY/4dGZYtCOO8fYmM6D
         CzHCARhNm4YeFKZ/rL47vAaFrOPzvzfFGtyOgf1CuXRH4p6gh3pzWBVNk67Y09k0JmJO
         ZeeQ==
X-Gm-Message-State: AOJu0YzHBBh330XhaYZRyTeVNimJs7nJnZ09dD9h1C9Q7iliwPpCeFXg
	9sL3UNhFiNlPXXEhWeFbtZ+3vWdhtsQw6JFmcRQfRP5S8qEezcygugnC
X-Gm-Gg: AY/fxX530/a1Rfn0aeOi3IT6s30trZz18tJCeta6LaSAwdLgjt90QFZz2705WW7P1h2
	e+jSAXoNgHl05qtZjl9boHvOQ9lhEPCZl9TqdZBbALbne0NHXlUKOFZv9Qkd0FxafVMo92mno6/
	assNuT6eVa+hmdKFdZ/kbGArWDJxaQjp0asubPRRhLlJJB6V95+RMMp6N2XUusyFLoKSItnHvim
	J1ccUpnvQa1hR9s/YCxqQFnhQug/A8H5/iOdsVFAA/ZI5sW9YoDlph9/R5gee/+veuMTwYWQmgO
	lFhr/zkeA+AwncF/W9K8cwUXi0bhY78jBkRrgRqtDz8W3Jrzg2NfG9Btnt4Lkho6Cd6Y8Rukioz
	Rb7OJ4hAQ093gN+273JpOeHOhYTOCI4HJmA00HZlIKRDhSyKLKjgm4beWWH62UvsHHtMlGVl4WW
	xH3D0a7nojlN5XaRbYK2+nw1lgMg==
X-Google-Smtp-Source: AGHT+IFtUsZEuL7rqMOme055xdHupsGjodoqaXYXuVL8UpVpz4Kw9jTtQzwUlKkRdT1r/VQ+lJmLMg==
X-Received: by 2002:a05:600c:6208:b0:46f:a2ba:581f with SMTP id 5b1f17b1804b1-47a8f2c9fa3mr122722865e9.16.1765813378920;
        Mon, 15 Dec 2025 07:42:58 -0800 (PST)
Received: from framework13 ([78.213.157.103])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47a8f3240fasm197588435e9.0.2025.12.15.07.42.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Dec 2025 07:42:58 -0800 (PST)
Date: Mon, 15 Dec 2025 16:42:55 +0100
From: Luca Di Maio <luca.dimaio1@gmail.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2] xfs: test reproducible builds
Message-ID: <uylosoggc4e7r53thd7x4ixcatstsv5m4qjpg77uevgbrf7mon@tfpyythz7iis>
References: <20251212081519.627879-1-luca.dimaio1@gmail.com>
 <20251212202000.GG7725@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251212202000.GG7725@frogsfrogsfrogs>

On Fri, Dec 12, 2025 at 12:20:00PM -0800, Darrick J. Wong wrote:
> On Fri, Dec 12, 2025 at 09:15:19AM +0100, Luca Di Maio wrote:
> > With the addition of the `-p` populate option, SOURCE_DATE_EPOCH and
> > DETERMINISTIC_SEED support, it is possible to create fully reproducible
> > pre-populated filesystems. We should test them here.
> > 
> > Signed-off-by: Luca Di Maio <luca.dimaio1@gmail.com>
> > ---
> >  tests/xfs/841     | 171 ++++++++++++++++++++++++++++++++++++++++++++++
> >  tests/xfs/841.out |   3 +
> >  2 files changed, 174 insertions(+)
> >  create mode 100755 tests/xfs/841
> >  create mode 100644 tests/xfs/841.out
> > 
> > diff --git a/tests/xfs/841 b/tests/xfs/841
> > new file mode 100755
> > index 00000000..e77533c3
> > --- /dev/null
> > +++ b/tests/xfs/841
> > @@ -0,0 +1,171 @@
> > +#! /bin/bash
> > +# SPDX-License-Identifier: GPL-2.0
> > +# Copyright (c) 2025 Chainguard, Inc. All Rights Reserved.
> > +#
> > +# FS QA Test No. 841
> > +#
> > +# Test that XFS filesystems created with reproducibility options produce
> > +# identical images across multiple runs. This verifies that the combination
> > +# of SOURCE_DATE_EPOCH, DETERMINISTIC_SEED, and -m uuid= options result in
> > +# bit-for-bit reproducible filesystem images.
> > +
> > +. ./common/preamble
> > +_begin_fstest auto quick mkfs
> > +
> > +# Image file settings
> > +IMG_SIZE="512M"
> > +IMG_FILE="$TEST_DIR/xfs_reproducible_test.img"
> > +PROTO_DIR="$TEST_DIR/proto"
> > +
> > +# Fixed values for reproducibility
> > +FIXED_UUID="12345678-1234-1234-1234-123456789abc"
> > +FIXED_EPOCH="1234567890"
> > +
> > +# Check if mkfs.xfs supports required options
> > +_check_mkfs_xfs_options()
> > +{
> > +	local check_img="$TEST_DIR/mkfs_check.img"
> > +	truncate -s 64M "$check_img" || return 1
> > +
> > +	# Check -m uuid support
> > +	$MKFS_XFS_PROG -m uuid=00000000-0000-0000-0000-000000000000 \
> > +		-N "$check_img" &> /dev/null
> > +	local uuid_support=$?
> > +
> > +	# Check -p support (protofile/directory population)
> > +	$MKFS_XFS_PROG 2>&1 | grep populate &> /dev/null
> > +	local proto_support=$?
> 
> I forget, didn't mkfs.xfs -p appear before adding SOURCE_DATE_EPOCH /
> DETERMINISTIC_SEED?  There's nothing in the --help screen, but I think
> you could detect it with
> 
> 	grep -q SOURCE_DATE_EPOCH $MKFS_XFS_PROG || \
> 		_notrun "mkfs.xfs does not support SOURCE_DATE_EPOCH"
>

Ack

> > +
> > +	rm -f "$check_img"
> > +
> > +	if [ $uuid_support -ne 0 ]; then
> > +		_notrun "mkfs.xfs does not support -m uuid= option"
> > +	fi
> > +	if [ $proto_support -ne 0 ]; then
> > +		_notrun "mkfs.xfs does not support -p option for directory population"
> > +	fi
> > +}
> > +
> > +# Create a prototype directory with all file types supported by mkfs.xfs -p
> > +_create_proto_dir()
> > +{
> > +	rm -rf "$PROTO_DIR"
> > +	mkdir -p "$PROTO_DIR/subdir/nested"
> 
> If you really want to go wild you could (in addition to the code below)
> run fsstress for a thousand or so fs ops to populate $PROTO_DIR with
> xattrs and whatnot, which would make the inputs less predictable. ;)
> 
> (Just something to think about; the code below is quite all right for a
> functional test.)
>

TIL about fsstress, will switch to it, thanks for pointing it out

> > +
> > +	# Regular files with different content
> > +	echo "test file content" > "$PROTO_DIR/regular.txt"
> > +	dd if=/dev/zero of="$PROTO_DIR/zeros" bs=1k count=4 2> /dev/null
> > +	echo "file in subdir" > "$PROTO_DIR/subdir/nested.txt"
> > +	echo "deeply nested" > "$PROTO_DIR/subdir/nested/deep.txt"
> > +
> > +	# Empty file
> > +	touch "$PROTO_DIR/empty"
> > +
> > +	# Symbolic links (file and directory)
> > +	ln -s regular.txt "$PROTO_DIR/symlink"
> > +	ln -s subdir "$PROTO_DIR/dirlink"
> > +
> > +	# Hardlink
> > +	ln "$PROTO_DIR/regular.txt" "$PROTO_DIR/hardlink"
> > +
> > +	# FIFO (named pipe)
> > +	mkfifo "$PROTO_DIR/fifo"
> > +
> > +	# Unix socket
> > +	$here/src/af_unix "$PROTO_DIR/socket" 2> /dev/null || true
> > +
> > +	# Block device (requires root)
> > +	mknod "$PROTO_DIR/blockdev" b 1 0 2> /dev/null || true
> > +
> > +	# Character device (requires root)
> > +	mknod "$PROTO_DIR/chardev" c 1 3 2> /dev/null || true
> > +
> > +	# File with extended attributes
> > +	echo "file with xattrs" > "$PROTO_DIR/xattrfile"
> > +	setfattr -n user.testattr -v "testvalue" "$PROTO_DIR/xattrfile" 2> /dev/null || true
> > +}
> > +
> > +_require_test
> > +_check_mkfs_xfs_options
> > +
> > +# Create XFS filesystem with full reproducibility options
> > +# Uses -p to populate from directory during mkfs (no mount needed)
> > +_mkfs_xfs_reproducible()
> > +{
> > +	local img=$1
> > +
> > +	# Create fresh image file
> > +	rm -f "$img"
> > +	truncate -s $IMG_SIZE "$img" || return 1
> > +
> > +	# Set environment variables for reproducibility:
> > +	# - SOURCE_DATE_EPOCH: fixes all inode timestamps to this value
> > +	# - DETERMINISTIC_SEED: uses fixed seed (0x53454544) instead of
> > +	#   getrandom()
> > +	#
> > +	# mkfs.xfs options:
> > +	# - -m uuid=: fixed filesystem UUID
> > +	# - -p dir: populate filesystem from directory during creation
> > +	SOURCE_DATE_EPOCH=$FIXED_EPOCH \
> > +	DETERMINISTIC_SEED=1 \
> > +	$MKFS_XFS_PROG \
> > +		-f \
> > +		-m uuid=$FIXED_UUID \
> > +		-p "$PROTO_DIR" \
> > +		"$img" >> $seqres.full 2>&1
> > +
> > +	return $?
> > +}
> > +
> > +# Compute hash of the image file
> > +_hash_image()
> > +{
> > +	sha256sum "$1" | awk '{print $1}'
> > +}
> > +
> > +# Run a single reproducibility test iteration
> > +_run_iteration()
> > +{
> > +	local iteration=$1
> > +
> > +	echo "Iteration $iteration: Creating filesystem with -p $PROTO_DIR" >> $seqres.full
> > +	if ! _mkfs_xfs_reproducible "$IMG_FILE"; then
> > +		echo "mkfs.xfs failed" >> $seqres.full
> > +		return 1
> > +	fi
> > +
> > +	local hash=$(_hash_image "$IMG_FILE")
> > +	echo "Iteration $iteration: Hash = $hash" >> $seqres.full
> > +
> > +	echo $hash
> > +}
> > +
> > +# Create the prototype directory with various file types
> > +_create_proto_dir
> > +
> > +echo "Test: XFS reproducible filesystem image creation"
> > +
> > +# Run three iterations
> > +hash1=$(_run_iteration 1)
> > +[ -z "$hash1" ] && _fail "Iteration 1 failed"
> > +
> > +hash2=$(_run_iteration 2)
> > +[ -z "$hash2" ] && _fail "Iteration 2 failed"
> > +
> > +hash3=$(_run_iteration 3)
> > +[ -z "$hash3" ] && _fail "Iteration 3 failed"
> > +
> > +# Verify all hashes match
> > +if [ "$hash1" = "$hash2" ] && [ "$hash2" = "$hash3" ]; then
> > +	echo "All filesystem images are identical."
> > +else
> > +	echo "ERROR: Filesystem images differ!"
> > +	echo "Hash 1: $hash1"
> > +	echo "Hash 2: $hash2"
> > +	echo "Hash 3: $hash3"
> > +	_fail "Reproducibility test failed - images are not identical"
> 
> As a general note, printing "ERROR: Filesystem images differ!" (or any
> string that's not in the 841.out file) is enough to fail the test, so
> there's no need to call _fail.

Ack

> Other that those comments, this looks good.  Thanks for launching us
> into the reproducible fs image era!
> 
> --D
> 

Thanks for the kind words.
It's an honor to contribute.

L.

> > +fi
> > +
> > +# success, all done
> > +status=0
> > +exit
> > diff --git a/tests/xfs/841.out b/tests/xfs/841.out
> > new file mode 100644
> > index 00000000..3bdfbfda
> > --- /dev/null
> > +++ b/tests/xfs/841.out
> > @@ -0,0 +1,3 @@
> > +QA output created by 841
> > +Test: XFS reproducible filesystem image creation
> > +All filesystem images are identical.
> > -- 
> > 2.52.0
> > 
> > 
