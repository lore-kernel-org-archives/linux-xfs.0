Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E3B01EB3D;
	Sun,  2 Mar 2025 13:15:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740921349; cv=none; b=G/9aITFdF4WX+c+btmNkJX+HVPT1d4w5NjKcJOvgvvkJJcnYu7rtcumCoOdjJnyRc/TdzriO8mbsjWdYiCyrOOqdOKp6SeReXBsDtS12GAQUSo4z/fC8/gjp+NJ0gme1HeV3zugq4VGz678LN4q2i23RdUk4KIFNX76h1jNClMA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740921349; c=relaxed/simple;
	bh=cIx/7ecz9ni1mTYA20B5p8ZtiDd9kpfnldf8pVCPZG4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OP02lmJVshAy+vJlgUDwdqUGdAaLCt4oE27Z23td48ORCXmKnoJ9XXBFDwNx+deoHn7EZ/oMM3PZYlCgWoWOpQDeDrO8MJ/eATgg0fZ22pe3aXK0qniQGq9F4jBPZKTyi13rlT3YdBDNshbApge2Rkiu0o6DeIRMVxpP681orhM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UlrxogiK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UlrxogiK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DCE7C4CED6;
	Sun,  2 Mar 2025 13:15:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1740921348;
	bh=cIx/7ecz9ni1mTYA20B5p8ZtiDd9kpfnldf8pVCPZG4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=UlrxogiKoGhdWybXgNp+cVP3L8l5wVF+yNw9Ar3xioyVuuvrsQuzKQZZ0maYZz85t
	 gmn8LD3Td1hYBDXp1/E3d4aZ63Eqn8obSz5LDxHS9kzNkZopG41bec5ntY1mLAhyFr
	 fiSeiNmYl3/FddN+wRUt7M2hlNKAQb7sJgfyHuBNvBnGqfVWgmp77wqTLw1NtwtcEi
	 stHJeRsIIYnL+76IURoL5/bBobdVAj4WYL6c3WGRvDHVmCyRXOMg69+Z7cW9AFe82u
	 R6lVxbTSef7+74TBNXXQXt8rvNKN7tO+ak6Sge3PV/IhGmYm5xe8ZlW4+i89rfWFWE
	 mspGQ+l2epdmQ==
Date: Sun, 2 Mar 2025 21:15:44 +0800
From: Zorro Lang <zlang@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: zlang@redhat.com, hch@lst.de, fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/1] fstests: test mkfs.xfs protofiles with xattr support
Message-ID: <20250302131544.5om3lil64kw5nnyo@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <173706975660.1928701.8344148155038133836.stgit@frogsfrogsfrogs>
 <173706975673.1928701.14882814105946770615.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173706975673.1928701.14882814105946770615.stgit@frogsfrogsfrogs>

On Thu, Jan 16, 2025 at 03:35:04PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Make sure we can do protofiles with xattr support.
> 
> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
> ---

This test always fails on my side, as below (diff output):

   ...
   Attribute "rootdata" has a 5 byte value for SCRATCH_MNT/directory/test
   Attribute "bigdata" has a 37960 byte value for SCRATCH_MNT/directory/test
   Attribute "acldata" has a 5 byte value for SCRATCH_MNT/directory/test
  +Attribute "selinux" has a 28 byte value for SCRATCH_MNT/directory/test
   *** unmount FS
   *** done
   *** unmount

Looks like the $SELINUX_MOUNT_OPTIONS doesn't help the mkfs protofile
with xattrs.

Thanks,
Zorro


>  tests/xfs/1937     |  144 ++++++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/1937.out |  102 +++++++++++++++++++++++++++++++++++++
>  2 files changed, 246 insertions(+)
>  create mode 100755 tests/xfs/1937
>  create mode 100644 tests/xfs/1937.out
> 
> 
> diff --git a/tests/xfs/1937 b/tests/xfs/1937
> new file mode 100755
> index 00000000000000..aa4143a75ef643
> --- /dev/null
> +++ b/tests/xfs/1937
> @@ -0,0 +1,144 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2024-2025 Oracle.  All Rights Reserved.
> +# Copyright (c) 2000-2004 Silicon Graphics, Inc.  All Rights Reserved.
> +#
> +# FS QA Test No. 1937
> +#
> +# mkfs protofile with xattrs test
> +#
> +. ./common/preamble
> +_begin_fstest mkfs auto quick
> +
> +seqfull="$seqres.full"
> +rm -f $seqfull
> +
> +. ./common/filter
> +
> +_cleanup()
> +{
> +	echo "*** unmount"
> +	_scratch_unmount 2>/dev/null
> +	rm -f $tmp.*
> +	rm -f $TEST_DIR/$seq.file
> +}
> +
> +_full()
> +{
> +	echo ""            >>$seqfull
> +	echo "*** $* ***"  >>$seqfull
> +	echo ""            >>$seqfull
> +}
> +
> +_filter_stat()
> +{
> +	sed '
> +		/^Access:/d;
> +		/^Modify:/d;
> +		/^Change:/d;
> +		s/Device: *[0-9][0-9]*,[0-9][0-9]*/Device: <DEVICE>/;
> +		s/Inode: *[0-9][0-9]*/Inode: <INODE>/;
> +		s/Size: *[0-9][0-9]* *Filetype: Dir/Size: <DSIZE> Filetype: Dir/;
> +	' | tr -s ' '
> +}
> +
> +_require_command $ATTR_PROG "attr"
> +_require_scratch
> +
> +# mkfs cannot create a filesystem with protofiles if realtime is enabled, so
> +# don't run this test if the rtinherit is anywhere in the mkfs options.
> +echo "$MKFS_OPTIONS" | grep -q "rtinherit" && \
> +	_notrun "Cannot mkfs with a protofile and -d rtinherit."
> +
> +protofile=$tmp.proto
> +tempfile=$TEST_DIR/$seq.file
> +
> +$XFS_IO_PROG -f -c 'pwrite 64k 28k' -c 'pwrite 1280k 37960' $tempfile >> $seqres.full
> +$here/src/devzero -b 2048 -n 2 -c -v 44 $tempfile.2 
> +
> +$ATTR_PROG -R -s rootdata -V 0test $tempfile &>> $seqres.full
> +$ATTR_PROG -S -s acldata -V 1test $tempfile &>> $seqres.full
> +$ATTR_PROG -s userdata -V 2test $tempfile &>> $seqres.full
> +perl -e 'print "x" x 37960;' | $ATTR_PROG -s bigdata $tempfile &>> $seqres.full
> +
> +cat >$protofile <<EOF
> +DUMMY1
> +0 0
> +: root directory
> +d--777 3 1
> +: a directory
> +directory d--755 3 1 
> +test ---755 3 1 $tempfile
> +file_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx_0 ---755 3 1 $tempfile
> +file_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx_1 ---755 3 1 $tempfile
> +file_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx_2 ---755 3 1 $tempfile
> +file_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx_3 ---755 3 1 $tempfile
> +file_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx_4 ---755 3 1 $tempfile
> +$
> +: back in the root
> +setuid -u-666 0 0 $tempfile
> +setgid --g666 0 0 $tempfile
> +setugid -ug666 0 0 $tempfile
> +directory_setgid d-g755 3 2
> +file_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx_5 ---755 3 1 $tempfile
> +$
> +: back in the root
> +block_device b--012 3 1 161 162 
> +char_device c--345 3 1 177 178
> +pipe p--670 0 0
> +symlink l--123 0 0 bigfile
> +: a file we actually read
> +bigfile ---666 3 0 $tempfile.2
> +: done
> +$
> +EOF
> +
> +if [ $? -ne 0 ]
> +then
> +	_fail "failed to create test protofile"
> +fi
> +
> +_verify_fs()
> +{
> +	echo "*** create FS version $1"
> +	VERSION="-n version=$1"
> +
> +	_scratch_unmount >/dev/null 2>&1
> +
> +	_full "mkfs"
> +	_scratch_mkfs_xfs $VERSION -p $protofile >>$seqfull 2>&1
> +
> +	echo "*** check FS"
> +	_check_scratch_fs
> +
> +	echo "*** mount FS"
> +	_full " mount"
> +	_try_scratch_mount >>$seqfull 2>&1 \
> +		|| _fail "mount failed"
> +
> +	$ATTR_PROG -l $SCRATCH_MNT/directory/test | \
> +		grep -q 'Attribute.*has a ' || \
> +		_notrun "mkfs.xfs protofile does not support xattrs"
> +
> +	echo "*** verify FS"
> +	(cd $SCRATCH_MNT ; find . | LC_COLLATE=POSIX sort \
> +		| grep -v ".use_space" \
> +		| xargs $here/src/lstat64 | _filter_stat)
> +	diff -q $SCRATCH_MNT/bigfile $tempfile.2 \
> +		|| _fail "bigfile corrupted"
> +	diff -q $SCRATCH_MNT/symlink $tempfile.2 \
> +		|| _fail "symlink broken"
> +
> +	$ATTR_PROG -l $SCRATCH_MNT/directory/test | _filter_scratch
> +
> +	echo "*** unmount FS"
> +	_full "umount"
> +	_scratch_unmount >>$seqfull 2>&1 \
> +		|| _fail "umount failed"
> +}
> +
> +_verify_fs 2
> +
> +echo "*** done"
> +status=0
> +exit
> diff --git a/tests/xfs/1937.out b/tests/xfs/1937.out
> new file mode 100644
> index 00000000000000..050c8318b1abca
> --- /dev/null
> +++ b/tests/xfs/1937.out
> @@ -0,0 +1,102 @@
> +QA output created by 1937
> +Wrote 2048.00Kb (value 0x2c)
> +*** create FS version 2
> +*** check FS
> +*** mount FS
> +*** verify FS
> + File: "."
> + Size: <DSIZE> Filetype: Directory
> + Mode: (0777/drwxrwxrwx) Uid: (3) Gid: (1)
> +Device: <DEVICE> Inode: <INODE> Links: 4 
> +
> + File: "./bigfile"
> + Size: 2097152 Filetype: Regular File
> + Mode: (0666/-rw-rw-rw-) Uid: (3) Gid: (0)
> +Device: <DEVICE> Inode: <INODE> Links: 1 
> +
> + File: "./block_device"
> + Size: 0 Filetype: Block Device
> + Mode: (0012/b-----x-w-) Uid: (3) Gid: (1)
> +Device: <DEVICE> Inode: <INODE> Links: 1 Device type: 161,162
> +
> + File: "./char_device"
> + Size: 0 Filetype: Character Device
> + Mode: (0345/c-wxr--r-x) Uid: (3) Gid: (1)
> +Device: <DEVICE> Inode: <INODE> Links: 1 Device type: 177,178
> +
> + File: "./directory"
> + Size: <DSIZE> Filetype: Directory
> + Mode: (0755/drwxr-xr-x) Uid: (3) Gid: (1)
> +Device: <DEVICE> Inode: <INODE> Links: 2 
> +
> + File: "./directory/file_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx_0"
> + Size: 1348680 Filetype: Regular File
> + Mode: (0755/-rwxr-xr-x) Uid: (3) Gid: (1)
> +Device: <DEVICE> Inode: <INODE> Links: 1 
> +
> + File: "./directory/file_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx_1"
> + Size: 1348680 Filetype: Regular File
> + Mode: (0755/-rwxr-xr-x) Uid: (3) Gid: (1)
> +Device: <DEVICE> Inode: <INODE> Links: 1 
> +
> + File: "./directory/file_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx_2"
> + Size: 1348680 Filetype: Regular File
> + Mode: (0755/-rwxr-xr-x) Uid: (3) Gid: (1)
> +Device: <DEVICE> Inode: <INODE> Links: 1 
> +
> + File: "./directory/file_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx_3"
> + Size: 1348680 Filetype: Regular File
> + Mode: (0755/-rwxr-xr-x) Uid: (3) Gid: (1)
> +Device: <DEVICE> Inode: <INODE> Links: 1 
> +
> + File: "./directory/file_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx_4"
> + Size: 1348680 Filetype: Regular File
> + Mode: (0755/-rwxr-xr-x) Uid: (3) Gid: (1)
> +Device: <DEVICE> Inode: <INODE> Links: 1 
> +
> + File: "./directory/test"
> + Size: 1348680 Filetype: Regular File
> + Mode: (0755/-rwxr-xr-x) Uid: (3) Gid: (1)
> +Device: <DEVICE> Inode: <INODE> Links: 1 
> +
> + File: "./directory_setgid"
> + Size: <DSIZE> Filetype: Directory
> + Mode: (2755/drwxr-sr-x) Uid: (3) Gid: (2)
> +Device: <DEVICE> Inode: <INODE> Links: 2 
> +
> + File: "./directory_setgid/file_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx_5"
> + Size: 1348680 Filetype: Regular File
> + Mode: (0755/-rwxr-xr-x) Uid: (3) Gid: (1)
> +Device: <DEVICE> Inode: <INODE> Links: 1 
> +
> + File: "./pipe"
> + Size: 0 Filetype: Fifo File
> + Mode: (0670/frw-rwx---) Uid: (0) Gid: (0)
> +Device: <DEVICE> Inode: <INODE> Links: 1 
> +
> + File: "./setgid"
> + Size: 1348680 Filetype: Regular File
> + Mode: (2666/-rw-rwsrw-) Uid: (0) Gid: (0)
> +Device: <DEVICE> Inode: <INODE> Links: 1 
> +
> + File: "./setugid"
> + Size: 1348680 Filetype: Regular File
> + Mode: (6666/-rwsrwsrw-) Uid: (0) Gid: (0)
> +Device: <DEVICE> Inode: <INODE> Links: 1 
> +
> + File: "./setuid"
> + Size: 1348680 Filetype: Regular File
> + Mode: (4666/-rwsrw-rw-) Uid: (0) Gid: (0)
> +Device: <DEVICE> Inode: <INODE> Links: 1 
> +
> + File: "./symlink"
> + Size: 7 Filetype: Symbolic Link
> + Mode: (0123/l--x-w--wx) Uid: (0) Gid: (0)
> +Device: <DEVICE> Inode: <INODE> Links: 1 
> +Attribute "userdata" has a 5 byte value for SCRATCH_MNT/directory/test
> +Attribute "rootdata" has a 5 byte value for SCRATCH_MNT/directory/test
> +Attribute "bigdata" has a 37960 byte value for SCRATCH_MNT/directory/test
> +Attribute "acldata" has a 5 byte value for SCRATCH_MNT/directory/test
> +*** unmount FS
> +*** done
> +*** unmount
> 
