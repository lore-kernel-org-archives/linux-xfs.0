Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:47558 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728839AbeJ0IMX (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sat, 27 Oct 2018 04:12:23 -0400
Subject: Re: [PATCH 0/5] v4 Try to squash metadump data leaks
From: Eric Sandeen <sandeen@sandeen.net>
References: <20181026201943.24131-1-stefanrin@gmail.com>
 <3e653734-6470-3160-58e8-5bdf866dbd87@sandeen.net>
Message-ID: <5228ed5f-b238-1596-a829-6bf482da7e2b@sandeen.net>
Date: Fri, 26 Oct 2018 18:33:21 -0500
MIME-Version: 1.0
In-Reply-To: <3e653734-6470-3160-58e8-5bdf866dbd87@sandeen.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Stefan Ring <stefanrin@gmail.com>, linux-xfs@vger.kernel.org

Also, here's an old script I had lying around to test metadump.  It's hacky, sorry.

Things to watch out for... it looks for an "fsstress" binary from xfstests, so adjust that path.
It freezes and unfreezes the test filesystem, if your mount fails it'll freeze
the fs you're on.  ;)  There may be other rough spots.

It also runs the xfs_metadump/xfs_db in your path; you could change that to a
local ./xfs_metadump to run db/xfs_db from a git tree instead for testing
w/o make install.

Right now this is detecting some corruption induced by metadump/mdrestore
with your full patchset in place, FWIW.

Sorry I didn't send this sooner, kinda forgot I had it.  really should turn it into an xfstest.

-----

#!/bin/bash

function _fail () {
	echo $1
	exit 1
}

FSSTRESS=/root/xfstests-dev/ltp/fsstress

mkdir -p mnt
umount mnt &>/dev/null

# Will fill fsfile.img with "cd cd cd"
echo "Patterning 256M image file"
xfs_io -F -f -c "pwrite 0 256m" fsfile.img &>/dev/null
# Make & label the filesystem, and mount it.
echo "mkfs & label the image, and mount it"
mkfs.xfs -b size=2048 -m crc=0 -L "fslabel" fsfile.img
mount -o loop fsfile.img mnt

cd mnt

# Attempt to make files of "every" format for data, dirs, attrs etc.

# ====== File Data ======

echo "Creating file types ..."
# Regular files
# - FMT_EXTENTS
touch S_IFREG.FMT_EXTENTS
xfs_io -c "pwrite 0 4k" S_IFREG.FMT_EXTENTS &>/dev/null
# - FMT_BTREE
touch S_IFREG.FMT_BTREE
for I in `seq 0 8 200`; do
	xfs_io -d -c "pwrite ${I}k 4k" S_IFREG.FMT_BTREE &>/dev/null
done

# ======= Directories =======
echo "Creating directory types ..."
# - FMT_LOCAL
mkdir S_IFDIR.FMT_LOCAL
touch S_IFDIR.FMT_LOCAL/localdirfile

# - FMT_EXTENTS
mkdir S_IFDIR.FMT_EXTENTS
for I in `seq 1 100`; do
	touch S_IFDIR.FMT_EXTENTS/extent_dir_file_$I
done
# With a few missing
for I in `seq 10 2 20` 100; do
	rm -f S_IFDIR.FMT_EXTENTS/extent_dir_file_$I
done

# - FMT_BTREE
mkdir S_IFDIR.FMT_BTREE
for I in `seq 1 1000`; do
	touch S_IFDIR.FMT_BTREE/btree_dir_file_$I
done
# With a few missing
for I in `seq 10 2 20` 1000; do
	rm -f S_IFDIR.FMT_BTREE/btree_dir_file_$I
done

# Dave's special hack - grow freespace tree
mkdir S_IFDIR.FMT_BTREE2
for I in `seq 1 5000`; do
	touch S_IFDIR.FMT_BTREE2/btree2_dir_file_$I
done
# Remove every other
for I in `seq 1 2 5000`; do
	rm -f S_IFDIR.FMT_BTREE2/btree2_dir_file_$I
done

# ======= Symlinks =======
echo "Creating symlink types ..."
# - FMT_LOCAL
ln -s target S_IFLNK.FMT_LOCAL
# - FMT_EXTENTS
# create "strangely_long_path_component/strangely_long_path_component/..."
COMP=strangely_long_path_component
TARGET=$COMP
for I in `seq 1 30`; do
	TARGET=$TARGET/$COMP
done
ln -s $TARGET S_IFLNK.FMT_EXTENTS

# ======= Char & block devices =======
echo "Creating char & block types ..."
mkdir S_IFDIR.DEVICES
mknod S_IFDIR.DEVICES/S_IFCHR c 1 1
mknod S_IFDIR.DEVICES/S_IFBLK c 1 1
# Create an inode with some local data & then remove
echo "Create local symlink"
touch S_IFDIR.DEVICES/longnamenamenamenamenamenamenamenamenamename
ln -s "longnamenamenamenamenamenamenamenamenamename" S_IFDIR.DEVICES/link
xfs_io -c fsync S_IFDIR.DEVICES/link
rm -f S_IFDIR.DEVICES/link
mknod S_IFDIR.DEVICES/S_IFBLK2 c 1 1

# ======= Attributes =======
echo "Creating attribute types ..."
# FMT_LOCAL
touch S_IFREG.ATTR.FMT_LOCAL
setfattr -n user.localattrname -v localattrvalue S_IFREG.ATTR.FMT_LOCAL
# FMT_EXTENTS
touch S_IFREG.ATTR.FMT_EXTENTS
for I in `seq 1 50`; do
	setfattr -n user.extentattrname$I -v extentattrvalue S_IFREG.ATTR.FMT_EXTENTS
done
# With a few missing
for I in 10 12 50; do
	setfattr -x user.extentattrname$I S_IFREG.ATTR.FMT_EXTENTS
done

# FMT_EXTENTS with a remote 3k value, fill with "C"
touch S_IFREG.ATTR.FMT_EXTENTS_REMOTE3K
xfs_io -f -c "pwrite -S 0x43 0 3k" S_IFREG.ATTRVALFILE &>/dev/null
attr -q -s user.remotebtreeattrname S_IFREG.ATTR.FMT_EXTENTS_REMOTE3K < S_IFREG.ATTRVALFILE

# FMT_EXTENTS with a remote 4k value, fill with "D"
touch S_IFREG.ATTR.FMT_EXTENTS_REMOTE4K
xfs_io -f -c "pwrite -S 0x44 0 4k" S_IFREG.ATTRVALFILE &>/dev/null
attr -q -s user.remotebtreeattrname S_IFREG.ATTR.FMT_EXTENTS_REMOTE4K < S_IFREG.ATTRVALFILE

# FMT_BTREE
touch S_IFREG.ATTR.FMT_BTREE
for I in `seq 1 1000`; do
	setfattr -n user.btreeattrname$I -v btreeattrlongervalue S_IFREG.ATTR.FMT_BTREE
done
# With a few missing
for I in 10 12 1000; do
	setfattr -x user.btreeattrname$I S_IFREG.ATTR.FMT_BTREE
done

# Make an unused inode
mkdir S_IFDIR.DELETED
touch S_IFDIR.DELETED/S_IFREG.DELETED
# Really push this to disk
xfs_freeze -f .
xfs_freeze -u .
rm -f S_IFDIR.DELETED/S_IFREG.DELETED

# =============================

# Now fsstress for some good randomness

mkdir stress
echo "fsstressing"
$FSSTRESS -d stress -p 4 -n 1000
echo "done"

sleep 5

cd -

echo "umount & remount"
umount mnt
mount -o loop fsfile.img mnt

# Get details of what's on disk in the original fs
echo "Get list of original files & attributes"
ls -lR mnt > orig_files
getfattr -m - -dR mnt > orig_attrs 2>/dev/null

echo "FS utilization:"
df mnt/

echo "umount"
umount mnt

# Test that we didn't lose anything with stale-data-zeroing
# turned on (i.e. zap too much)
# dump & restore it, repair it, and compare contents to orig

# ===== NON-OBFUSCATED =====
# do a NON-obfuscated metadump & look for stale pattern coming through

rm -f fsfile-clear.img
echo "Non-obfuscated metadump"
./xfs_metadump -o fsfile.img - | xfs_mdrestore - fsfile-clear.img
# Make sure it's not corrupt
echo "xfs_repair on unobfuscated & stale-zeroed metadump"
xfs_repair -n fsfile-clear.img 2>/dev/null || _fail "Repair failed on fsfile-clear.img"
# Get details of what's on disk in the image
mount -o loop fsfile-clear.img mnt
ls -lR mnt > clear_files
getfattr -m - -dR mnt > clear_attrs 2>/dev/null

echo "Checking for unchanged files & attrs via unobfuscated metadump"
diff -u orig_files clear_files
diff -u orig_attrs clear_attrs

echo "Looking for stale data in unobfuscated dump"
# Generic stale data test - look for original pattern
hexdump -C fsfile-clear.img | grep "cd cd cd"

# ===== OBFUSCATED =====
# Now do OBFUSCATED metadump & look for stale strings coming through,
# as well as looking for any other data we wrote
rm -f fsfile-obfuscated.img
xfs_metadump fsfile.img - | xfs_mdrestore - fsfile-obfuscated.img
# Make sure it's not corrupt
echo "xfs_repair on obfuscated & stale-zeroed metadump"
xfs_repair -n fsfile-obfuscated.img 2>/dev/null || _fail "Repair failed on fsfile-obfuscated.img"

# Generic stale data test - look for original pattern
echo "Looking for stale data in obfuscated dump"
hexdump -C fsfile-obfuscated.img | grep "cd cd cd"

# Look for stuff we explicitly wrote
echo "Looking for our data in obfuscated dump"
strings -t x fsfile-obfuscated.img | grep -i "S_IF\|attr\|name\|value\|btree\|long\|local\|extent\|label"
