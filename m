Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:59264 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933207AbeFKUgr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 11 Jun 2018 16:36:47 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w5BKZjdX011308
        for <linux-xfs@vger.kernel.org>; Mon, 11 Jun 2018 20:36:46 GMT
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by userp2120.oracle.com with ESMTP id 2jg7hwy2v3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 11 Jun 2018 20:36:46 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w5BKaj8N014767
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 11 Jun 2018 20:36:45 GMT
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w5BKaiT9028135
        for <linux-xfs@vger.kernel.org>; Mon, 11 Jun 2018 20:36:44 GMT
Date: Mon, 11 Jun 2018 13:36:42 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v1 1/1] xfstests: Add parent pointer test
Message-ID: <20180611203642.GJ22045@magnolia>
References: <1528607439-11186-1-git-send-email-allison.henderson@oracle.com>
 <1528607439-11186-2-git-send-email-allison.henderson@oracle.com>
 <20180611172509.GA22045@magnolia>
 <f63473da-d6c4-e988-7737-ccaa4401d668@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f63473da-d6c4-e988-7737-ccaa4401d668@oracle.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Allison Henderson <allison.henderson@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Mon, Jun 11, 2018 at 12:59:42PM -0700, Allison Henderson wrote:
> On 06/11/2018 10:25 AM, Darrick J. Wong wrote:
> > On Sat, Jun 09, 2018 at 10:10:39PM -0700, Allison Henderson wrote:
> > > This patch adds a test for basic parent pointer operations,
> > > including link, unlink, rename, overwrite, hardlinks and
> > > error inject.
> > > 
> > > Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
> > > ---
> > >   tests/xfs/448     |  423 +++++++++++++++++++++
> > >   tests/xfs/448.out | 1096 +++++++++++++++++++++++++++++++++++++++++++++++++++++
> > 
> > Whoah, this is a huge ^^^^^ test.  Could you break these up into smaller
> > tests?  One to test the simple case (a single pptr), one for harder case
> > (multiple hardlinks), and maybe each of the evil ones each get a separate
> > testcase?  Also, you might as well tag them all (in test/xfs/group) with
> > 'pptr' or something like that, so that we can all run:
> > 
> > # ./check -g pptr
> > 
> > to run all the parent pointer tests.
> > 
> 
> Sure, I'll try to break them up a little and make a group to put them in.
> 
> > >   tests/xfs/group   |    1 +
> > >   3 files changed, 1520 insertions(+)
> > > 
> > > diff --git a/tests/xfs/448 b/tests/xfs/448
> > > new file mode 100755
> > > index 0000000..8353bdb
> > > --- /dev/null
> > > +++ b/tests/xfs/448
> > > @@ -0,0 +1,423 @@
> > > +#! /bin/bash
> > 
> > The xfs* repos are moving to SPDX headers, so please replace the big
> > copyright statements (all the legalese between the long dashed lines)
> > with:
> > 
> > # SPDX-License-Identifier: GPL-2.0
> > # Copyright (c) 2018, Oracle and/or its affiliates.  All Rights Reserved.
> > 
> > (I thought we (Oracle) were supposed to be GPL-2.0+, fwiw...)
> > 
> > > +# Test 448
> > 
> > "FS QA Test No. 448"
> > 
> > This way tools/mvtest will update the tag if/when the test gets moved.
> > 
> > > +#
> > > +# parent pointer tests
> > > +#
> > > +#-----------------------------------------------------------------------
> > > +# Copyright (c) 2018 Oracle, Inc.  All Rights Reserved.
> > > +#
> > > +# This program is free software; you can redistribute it and/or
> > > +# modify it under the terms of the GNU General Public License as
> > > +# published by the Free Software Foundation.
> > > +#
> > > +# This program is distributed in the hope that it would be useful,
> > > +# but WITHOUT ANY WARRANTY; without even the implied warranty of
> > > +# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > > +# GNU General Public License for more details.
> > > +#
> > > +# You should have received a copy of the GNU General Public License
> > > +# along with this program; if not, write the Free Software Foundation,
> > > +# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
> > > +#-----------------------------------------------------------------------
> > 
> > example:
> > 
> > #! /bin/bash
> > # SPDX-License-Identifier: GPL-2.0
> > # Copyright (c) 2018, Oracle and/or its affiliates.  All Rights Reserved.
> > #
> > # FS QA Test No. 448
> > #
> > # parent pointer tests
> > 
> > seq=`basename $0`
> > <other stuff>
> > 
> Sure, will do.  Does this apply to new files added in xfsprogs too?

Not at this exact instant but I think we'll have finished the spdx
transition in kernel/xfsprogs by the time 4.18 get released.

(FWIW I have it queued up kernel-side in for-next, but as there wasn't a
tree for Monday 6/11 I haven't sent Linus a pull req yet.)

> > > +#
> > > +
> > > +seq=`basename $0`
> > > +seqres=$RESULT_DIR/$seq
> > > +echo "QA output created by $seq"
> > > +
> > > +here=`pwd`
> > > +tmp=/tmp/$$
> > > +seqfull="$seqres.full"
> > > +tatus=1	# failure is the default!
> > > +trap "_cleanup; exit \$status" 0 1 2 3 15
> > > +
> > > +_cleanup()
> > > +{
> > > +	cd /
> > > +	rm -f $tmp.*
> > > +}
> > > +
> > > +filter_dbval()
> > > +{
> > > +	awk '{ print $4 }'
> > > +}
> > > +
> > > +_full()
> > 
> > The only names that should start with an underscore are common/
> > functions.
> > 
> Alrighty, will fix
> 
> > > +{
> > > +    echo ""            >>$seqfull
> > > +    echo "*** $* ***"  >>$seqfull
> > > +    echo ""            >>$seqfull
> > > +}
> > > +
> > > +# get standard environment, filters and checks
> > > +. ./common/rc
> > > +. ./common/filter
> > > +. ./common/reflink
> > > +. ./common/inject
> > > +
> > > +# remove previous $seqres.full before test
> > > +rm -f $seqres.full
> > > +
> > > +# Modify as appropriate
> > > +_supported_os Linux
> > > +_supported_fs xfs
> > > +_require_scratch
> > > +_require_xfs_io_error_injection "delayed_attr"
> > > +
> > > +echo "Silence is golden."
> > > +
> > > +# real QA test starts here
> > > +protofile=$tmp.proto
> > > +tempfile=$tmp.file
> > > +
> > > +echo fish >$tempfile
> > > +$here/src/devzero -b 2048 -n 2 -c -v 44 $tempfile.2
> > > +
> > > +cat >$protofile <<EOF
> > > +DUMMY1
> > > +0 0
> > > +: root directory
> > > +d--777 3 1
> > > +: a directory
> > > +testfolder1 d--755 3 1
> > > +file1 ---755 3 1 /dev/null
> > > +$
> > > +: back in the root
> > > +testfolder2 d--755 3 1
> > > +file2 ---755 3 1 /dev/null
> > > +: done
> > > +$
> > > +EOF
> > > +
> > > +if [ $? -ne 0 ]
> > > +then
> > > +    _fail "failed to create test protofile"
> > > +fi
> > > +
> > > +#
> > > +# parse_parent_pointer PARENT_POINTER_LIST PARENT_INODE PARENT_POINTER_NAME
> > > +#
> > > +# Given a list of parent pointers, find the record that matches
> > > +# the given inode and filename
> > > +#
> > > +# outputs:
> > > +# PPINO		: Parent pointer inode
> > > +# PPGEN		: Parent pointer generation
> > > +# PPNAME	: Parent pointer name
> > > +# PPNAME_LEN	: Parent pointer name length
> > > +#
> > > +parse_parent_pointer()
> > 
> > These next two helpers, OTOH, might be good candidates for common/pptr
> > or something... as Amir points out separately, it might be faster to
> > implement some of this as a C helper, though a lot depends on what
> > exactly makes the test runtime high in the first place. :)
> > 
> > I also kinda wonder if xfs_io's parent command ought to have a "return
> > only the parent-links to this directory...
> 
> Sure, I'll move some stuff around and see what works best.  For the
> multilink section, all but a few of the entries are links.  I do notice they
> are coming through fifo though.  I'm thinking maybe if i set up something
> that starts scanning from the bottom, worst case may turn into best case.

<nod> AFAICT we just return entries in the order that they land in the
attribute fork, which usually is FIFO for a clean fs.  It might not be
for an xattr tree with a lot of set/remove activity.  Userspace is
responsible for collecting all the entries and applying whatever
transformations it wants.

> 
> > 
> > > +{
> > > +	PARENTS=$1
> > > +	PINO=$2
> > > +	PARENT_POINTER_NAME=$3
> > > +
> > > +	PLEN=${#PARENTS[@]}
> > > +	FOUND=0
> > > +
> > > +	# Find the entry that has the same inode as the parent
> > > +	# and parse out the entry info
> > > +	for (( i=0; i<${PLEN}; i++ )); do
> > > +
> > > +		#advance to the parent entry matching the parent inode
> > > +		if ! echo ${PARENTS[$i]} | grep -q "p_ino    = $PINO" ; then
> > > +			continue
> > > +		fi
> > > +
> > > +		PPINO="$(echo ${PARENTS[$i]} | awk '{print $NF}')"
> > > +
> > > +		((i++))
> > > +		PPGEN="$(echo ${PARENTS[$i]} | awk '{print $NF}')"
> > > +
> > > +		((i++))
> > > +		PPNAME_LEN="$(echo ${PARENTS[$i]} | awk '{print $NF}')"
> > > +
> > > +		((i++))
> > > +		PPNAME="$(echo ${PARENTS[$i]} | awk '{print $NF}' | cut -d '"' -f2 )"
> > > +
> > > +		if [ "$PPNAME" != "$PARENT_POINTER_NAME" ]; then
> > > +			continue
> > > +		fi
> > > +
> > > +		break
> > > +	done
> > > +
> > > +	# If exhausted the list, we didnt find anything
> > > +	if [ $i -eq $PLEN ]; then
> > > +		return 0
> > 
> > Shell commands (and bash functions) return 0 for success and nonzero for
> > error.
> > 
> > You could also just _fail directly if nothing is found.
> Alrighty then, will adjust the error code.  We cant fail just yet though,
> because we use this to validate that old pptrs go away when they should.
> Like for when things move or get renamed

Understood. (Maybe a comment?) :)

> 
> > 
> > > +	fi
> > > +
> > > +	# Verify the parent pointer name length is correct
> > > +	if [ $PPNAME_LEN -ne ${#PARENT_POINTER_NAME} ]
> > > +	then
> > > +		_fail "Bad parent pointer reclen for $CHILD_PATH"
> > > +	fi
> > > +
> > > +	#return sucess
> > > +	return 1
> > > +
> > > +}
> > > +
> > > +#
> > > +# verify_parent PARENT_PATH PARENT_POINTER_NAME CHILD_PATH
> > > +#
> > > +# Verify that the given child path lists the given parent as a parent pointer
> > > +# and that the parent pointer name matches the given name
> > > +#
> > > +# Examples:
> > > +#
> > > +# #simple example
> > > +# mkdir testfolder1
> > > +# touch testfolder1/file1
> > > +# verify_parent testfolder1 file1 testfolder1/file1
> > > +#
> > > +# #hardlink example
> > > +# mkdir testfolder1
> > > +# mkdir testfolder2
> > > +# touch testfolder1/file1
> > > +# ln testfolder1/file1 testfolder2/file1_ln
> > > +# verify_parent testfolder2 file1_ln testfolder1/file1
> > > +#
> > > +verify_parent()
> > > +{
> > > +
> > > +	PARENT_PATH=$1
> > > +	PARENT_POINTER_NAME=$2
> > > +	CHILD_PATH=$3
> > > +
> > > +	CHILD_NAME=$(basename "$CHILD_PATH")
> > > +	PPINO=0
> > > +	PPGEN=0
> > > +	PPNAME_LEN=0
> > > +	PPNAME=""
> > > +	IFS=$'\n'
> > > +
> > > +	# Verify parent exists
> > > +	if [ ! -d $SCRATCH_MNT/$PARENT_PATH ]; then
> > > +		_fail "$SCRATCH_MNT/$PARENT_PATH not found"
> > > +	else
> > > +		echo "*** $PARENT_PATH OK"
> > > +	fi
> > > +
> > > +	# Verify child exists
> > > +	if [ ! -f $SCRATCH_MNT/$CHILD_PATH ]; then
> > > +		_fail "$SCRATCH_MNT/$CHILD_PATH not found"
> > > +	else
> > > +		echo "*** $CHILD_PATH OK"
> > > +	fi
> > > +
> > > +	# Verify the parent pointer name exists as a child of the parent
> > > +	PARENT_PPATH="$PARENT_PATH/$PARENT_POINTER_NAME"
> > > +
> > > +	if [ ! -f $SCRATCH_MNT/$PARENT_PPATH ]; then
> > > +		_fail "$SCRATCH_MNT/$PARENT_PPATH not found"
> > > +	else
> > > +		echo "*** $PARENT_PPATH OK"
> > > +	fi
> > > +
> > > +	# Get the inodes of both parent and child
> > > +	PINO="$(stat -c '%i' $SCRATCH_MNT/$PARENT_PATH)"
> > > +	CINO="$(stat -c '%i' $SCRATCH_MNT/$CHILD_PATH)"
> > > +
> > > +	# Get all the parent pointers of the child
> > > +	PARENTS=($($XFS_IO_PROG -x -c parent $SCRATCH_MNT/$CHILD_PATH))
> > > +	if [[ $? != 0 ]]; then
> > > +		 _fail "No parent pointers found for $CHILD_PATH"
> > > +	fi
> > > +
> > > +	parse_parent_pointer $PARENTS $PINO $PARENT_POINTER_NAME
> > > +	FOUND=$?
> > > +
> > > +	# If we didnt find one, bail out
> > > +	if [ $FOUND -eq 0 ]; then
> > > +		_fail "No parent pointer record found for $PARENT_PATH in $CHILD_PATH"
> > > +	fi
> > > +
> > > +	# Verify the inode generated by the parent pointer name is
> > > +	# the same as the child inode
> > > +	PPPINO="$(stat -c '%i' $SCRATCH_MNT/$PARENT_PPATH)"
> > > +	if [ $CINO -ne $PPPINO ]
> > > +	then
> > > +		_fail "Bad parent pointer name value for $CHILD_PATH."\
> > > +				"$SCRATCH_MNT/$PARENT_PPATH belongs to inode $PPPINO, but should be $CINO"
> > > +	fi
> > > +
> > > +	echo "*** Verified parent pointer:"\
> > > +			"inode:$PPINO, name:$PPNAME, namelen:$PPNAME_LEN"
> > > +	echo "*** Parent pointer OK for child $CHILD_PATH inode:$CINO"
> > > +}
> > > +
> > > +#
> > > +# verify_parent PARENT_PATH PARENT_POINTER_NAME CHILD_PATH
> > > +#
> > > +# Verify that the given child path contains no parent pointer entry
> > > +# for the given parent path and parnet pointer name
> > > +#
> > > +verify_no_parent()
> > > +{
> > > +
> > > +	PARENT_PATH=$1
> > > +	PARENT_PNAME=$2
> > > +	CHILD_PATH=$3
> > > +	CHILD_NAME=$(basename "$CHILD_PATH")
> > > +	PPINO=0
> > > +	PPGEN=0
> > > +	PPNAME_LEN=0
> > > +	PPNAME=""
> > > +	IFS=$'\n'
> > 
> > Uppercase variable names are usually reserved for global variables, and
> > local function variables should be declared with the 'local' keyword to
> > prevent them from escaping scope. e.g.
> > 
> > 	local parent_path="$1"
> > 
> > Note that setting IFS here affects everything called after
> > verify_no_parent, which is a side effect you might not want.
> > 
> Alrighty then, will fix.  Some of these may go away depending on how the sub
> routines get redone.

I forgot to mention in my earlier reply that perhaps the IFS= should be
applied directly to the input parsing command, e.g.

cat /etc/passwd | while IFS=: read uname junk uid junk; do echo $uid $uname; done

Also, I would suggest adding a flag to the parent command to spit out
results in some sort of machine readable format.  Though given that the
only illegal character in a filename is the path separator I guess
you're stuck with:

/$ino/$gen/$offset/$name

(yes, slashes as the field separator...)

--D

> > > +
> > > +	# Check if parent even exists
> > > +	if [ ! -d $SCRATCH_MNT/$PARENT_PATH ]; then
> > > +		return 0
> > > +	fi
> > > +
> > > +
> > > +	# Verify child exists
> > > +	if [ ! -f $SCRATCH_MNT/$CHILD_PATH ]; then
> > > +		_fail "$SCRATCH_MNT/$CHILD_PATH not found"
> > > +	else
> > > +		echo "*** $CHILD_PATH OK"
> > > +	fi
> > > +
> > > +	# Get parent inode
> > > +	PINO="$(stat -c '%i' $SCRATCH_MNT/$PARENT_PATH)"
> > > +
> > > +	# Get all the parent pointers of the child
> > > +	PARENTS=($($XFS_IO_PROG -x -c parent $SCRATCH_MNT/$CHILD_PATH))
> > > +	if [[ $? != 0 ]]; then
> > > +		return 0
> > > +	fi
> > > +
> > > +	parse_parent_pointer $PARENTS $PINO $PARENT_PNAME
> > > +	FOUND=$?
> > > +
> > > +	# If we didnt find one, return sucess
> > > +	if [ $FOUND -eq 0 ]; then
> > > +		return 0
> > > +	fi
> > > +
> > > +	_fail "Parent pointer entry found where none should:"\
> > > +			"inode:$PPINO, gen:$PPGEN,"
> > > +			"name:$PPNAME, namelen:$PPNAME_LEN"
> > > +}
> > > +
> > > +verify_fs()
> > 
> > This whole thing could simply be a part of the main script body (i.e.
> > you don't need a helper function that's only called once)
> > 
> > --D
> 
> Ok, I will collapse this one down.  Thx!
> 
> Allison
> 
> > 
> > > +{
> > > +	echo "*** create FS"
> > > +
> > > +	rm -f $seqfull
> > > +	_scratch_unmount >/dev/null 2>&1
> > > +
> > > +	_scratch_mkfs_xfs -f -n parent=1 -p $protofile >>$seqfull 2>&1 \
> > > +		|| _fail "mkfs failed"
> > > +	echo "*** check FS"
> > > +	_check_scratch_fs
> > > +
> > > +	echo "*** mount FS"
> > > +	_full " mount"
> > > +	_scratch_mount >>$seqfull 2>&1 \
> > > +		|| _fail "mount failed"
> > > +
> > > +	TESTFOLDER1="testfolder1"
> > > +	TESTFOLDER2="testfolder2"
> > > +	FILE1="file1"
> > > +	FILE2="file2"
> > > +	FILE3="file3"
> > > +	FILE4="file4"
> > > +	FILE5="file5"
> > > +	FILE1_LN="file1_link"
> > > +
> > > +	echo ""
> > > +	echo "Create parent pointer test"
> > > +	verify_parent "$TESTFOLDER1" "$FILE1" "$TESTFOLDER1/$FILE1"
> > > +
> > > +	echo ""
> > > +	echo "Move parent pointer test"
> > > +	mv $SCRATCH_MNT/$TESTFOLDER1/$FILE1 $SCRATCH_MNT/$TESTFOLDER2/$FILE1
> > > +	verify_parent "$TESTFOLDER2" "$FILE1" "$TESTFOLDER2/$FILE1"
> > > +
> > > +	echo ""
> > > +	echo "Hard link parent pointer test"
> > > +	ln $SCRATCH_MNT/$TESTFOLDER2/$FILE1 $SCRATCH_MNT/$TESTFOLDER1/$FILE1_LN
> > > +	verify_parent "$TESTFOLDER1" "$FILE1_LN"  "$TESTFOLDER1/$FILE1_LN"
> > > +	verify_parent "$TESTFOLDER1" "$FILE1_LN"  "$TESTFOLDER2/$FILE1"
> > > +	verify_parent "$TESTFOLDER2" "$FILE1"     "$TESTFOLDER1/$FILE1_LN"
> > > +	verify_parent "$TESTFOLDER2" "$FILE1"     "$TESTFOLDER2/$FILE1"
> > > +
> > > +	echo ""
> > > +	echo "Remove hard link parent pointer test"
> > > +	rm $SCRATCH_MNT/$TESTFOLDER2/$FILE1
> > > +	verify_parent    "$TESTFOLDER1" "$FILE1_LN" "$TESTFOLDER1/$FILE1_LN"
> > > +	verify_no_parent "$TESTFOLDER2" "$FILE1"    "$TESTFOLDER1/$FILE1_LN"
> > > +
> > > +	echo ""
> > > +	echo "Rename parent pointer test"
> > > +	mv $SCRATCH_MNT/$TESTFOLDER1/$FILE1_LN $SCRATCH_MNT/$TESTFOLDER1/$FILE2
> > > +	verify_parent    "$TESTFOLDER1" "$FILE2"    "$TESTFOLDER1/$FILE2"
> > > +	verify_no_parent "$TESTFOLDER1" "$FILE1_LN" "$TESTFOLDER1/$FILE2"
> > > +
> > > +	echo ""
> > > +	echo "Over write parent pointer test"
> > > +	touch $SCRATCH_MNT/$TESTFOLDER2/$FILE3
> > > +	verify_parent    "$TESTFOLDER2" "$FILE3"    "$TESTFOLDER2/$FILE3"
> > > +	mv -f $SCRATCH_MNT/$TESTFOLDER2/$FILE3 $SCRATCH_MNT/$TESTFOLDER1/$FILE2
> > > +	verify_parent    "$TESTFOLDER1" "$FILE2"    "$TESTFOLDER1/$FILE2"
> > > +
> > > +
> > > +	echo ""
> > > +	echo "Multi link parent pointer test"
> > > +	NLINKS=100
> > > +	touch $SCRATCH_MNT/$TESTFOLDER1/$FILE1
> > > +	for (( j=0; j<$NLINKS; j++ )); do
> > > +		ln $SCRATCH_MNT/$TESTFOLDER1/$FILE1 $SCRATCH_MNT/$TESTFOLDER1/$FILE1_LN.$j
> > > +		verify_parent    "$TESTFOLDER1" "$FILE1_LN.$j"    "$TESTFOLDER1/$FILE1"
> > > +		verify_parent    "$TESTFOLDER1" "$FILE1"          "$TESTFOLDER1/$FILE1_LN.$j"
> > > +	done
> > > +	echo "Multi unlink parent pointer test"
> > > +	for (( j=$NLINKS-1; j<=0; j-- )); do
> > > +		rm $SCRATCH_MNT/$TESTFOLDER1/$FILE1_LN.$j
> > > +		verify_no_parent "$TESTFOLDER1" "$FILE1_LN.$j" "$TESTFOLDER1/$FILE1"
> > > +	done
> > > +
> > > +
> > > +	echo ""
> > > +	echo "Error inject test"
> > > +
> > > +	echo "Create files"
> > > +	touch $SCRATCH_MNT/$TESTFOLDER1/$FILE4
> > > +	verify_parent    "$TESTFOLDER1" "$FILE4" "$TESTFOLDER1/$FILE4"
> > > +
> > > +	echo "Inject error"
> > > +	_scratch_inject_error "delayed_attr"
> > > +
> > > +	echo "Move files"
> > > +	mv $SCRATCH_MNT/$TESTFOLDER1/$FILE4 $SCRATCH_MNT/$TESTFOLDER2/$FILE5
> > > +
> > > +	echo "FS should be shut down, touch will fail"
> > > +	touch $SCRATCH_MNT/$TESTFOLDER2/$FILE5 2>&1 | _filter_scratch
> > > +
> > > +	echo "Remount to replay log"
> > > +	_scratch_inject_logprint >> $seqres.full
> > > +
> > > +	echo "FS should be online, touch should succeed"
> > > +	touch $SCRATCH_MNT/$TESTFOLDER2/$FILE5
> > > +
> > > +	echo "Check files again"
> > > +	verify_parent    "$TESTFOLDER2" "$FILE5" "$TESTFOLDER2/$FILE5"
> > > +
> > > +	echo "*** unmount FS"
> > > +	_full "umount"
> > > +	_scratch_unmount >>$seqfull 2>&1 \
> > > +		|| _fail "umount failed"
> > > +
> > > +}
> > > +
> > > +verify_fs
> > > +
> > > +echo "*** done"
> > > +rm $seqfull
> > > +status=0
> > > +
> > > +# success, all done
> > > +status=0
> > > +exit
> > > diff --git a/tests/xfs/448.out b/tests/xfs/448.out
> > > new file mode 100644
> > > index 0000000..ccb2d4e
> > > --- /dev/null
> > > +++ b/tests/xfs/448.out
> > > @@ -0,0 +1,1096 @@
> > > +QA output created by 448
> > > +Silence is golden.
> > > +Wrote 2048.00Kb (value 0x2c)
> > > +*** create FS
> > > +*** check FS
> > > +*** mount FS
> > > +
> > > +Create parent pointer test
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1 OK
> > > +*** testfolder1/file1 OK
> > > +*** Verified parent pointer: inode:16777344, name:file1, namelen:5
> > > +*** Parent pointer OK for child testfolder1/file1 inode:16777345
> > > +
> > > +Move parent pointer test
> > > +*** testfolder2 OK
> > > +*** testfolder2/file1 OK
> > > +*** testfolder2/file1 OK
> > > +*** Verified parent pointer: inode:33613312, name:file1, namelen:5
> > > +*** Parent pointer OK for child testfolder2/file1 inode:16777345
> > > +
> > > +Hard link parent pointer test
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1_link OK
> > > +*** testfolder1/file1_link OK
> > > +*** Verified parent pointer: inode:16777344, name:file1_link, namelen:10
> > > +*** Parent pointer OK for child testfolder1/file1_link inode:16777345
> > > +*** testfolder1 OK
> > > +*** testfolder2/file1 OK
> > > +*** testfolder1/file1_link OK
> > > +*** Verified parent pointer: inode:16777344, name:file1_link, namelen:10
> > > +*** Parent pointer OK for child testfolder2/file1 inode:16777345
> > > +*** testfolder2 OK
> > > +*** testfolder1/file1_link OK
> > > +*** testfolder2/file1 OK
> > > +*** Verified parent pointer: inode:33613312, name:file1, namelen:5
> > > +*** Parent pointer OK for child testfolder1/file1_link inode:16777345
> > > +*** testfolder2 OK
> > > +*** testfolder2/file1 OK
> > > +*** testfolder2/file1 OK
> > > +*** Verified parent pointer: inode:33613312, name:file1, namelen:5
> > > +*** Parent pointer OK for child testfolder2/file1 inode:16777345
> > > +
> > > +Remove hard link parent pointer test
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1_link OK
> > > +*** testfolder1/file1_link OK
> > > +*** Verified parent pointer: inode:16777344, name:file1_link, namelen:10
> > > +*** Parent pointer OK for child testfolder1/file1_link inode:16777345
> > > +*** testfolder1/file1_link OK
> > > +
> > > +Rename parent pointer test
> > > +*** testfolder1 OK
> > > +*** testfolder1/file2 OK
> > > +*** testfolder1/file2 OK
> > > +*** Verified parent pointer: inode:16777344, name:file2, namelen:5
> > > +*** Parent pointer OK for child testfolder1/file2 inode:16777345
> > > +*** testfolder1/file2 OK
> > > +
> > > +Over write parent pointer test
> > > +*** testfolder2 OK
> > > +*** testfolder2/file3 OK
> > > +*** testfolder2/file3 OK
> > > +*** Verified parent pointer: inode:33613312, name:file3, namelen:5
> > > +*** Parent pointer OK for child testfolder2/file3 inode:33613314
> > > +*** testfolder1 OK
> > > +*** testfolder1/file2 OK
> > > +*** testfolder1/file2 OK
> > > +*** Verified parent pointer: inode:16777344, name:file2, namelen:5
> > > +*** Parent pointer OK for child testfolder1/file2 inode:33613314
> > > +
> > > +Multi link parent pointer test
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1 OK
> > > +*** testfolder1/file1_link.0 OK
> > > +*** Verified parent pointer: inode:16777344, name:file1_link.0, namelen:12
> > > +*** Parent pointer OK for child testfolder1/file1 inode:16777345
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1_link.0 OK
> > > +*** testfolder1/file1 OK
> > > +*** Verified parent pointer: inode:16777344, name:file1, namelen:5
> > > +*** Parent pointer OK for child testfolder1/file1_link.0 inode:16777345
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1 OK
> > > +*** testfolder1/file1_link.1 OK
> > > +*** Verified parent pointer: inode:16777344, name:file1_link.1, namelen:12
> > > +*** Parent pointer OK for child testfolder1/file1 inode:16777345
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1_link.1 OK
> > > +*** testfolder1/file1 OK
> > > +*** Verified parent pointer: inode:16777344, name:file1, namelen:5
> > > +*** Parent pointer OK for child testfolder1/file1_link.1 inode:16777345
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1 OK
> > > +*** testfolder1/file1_link.2 OK
> > > +*** Verified parent pointer: inode:16777344, name:file1_link.2, namelen:12
> > > +*** Parent pointer OK for child testfolder1/file1 inode:16777345
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1_link.2 OK
> > > +*** testfolder1/file1 OK
> > > +*** Verified parent pointer: inode:16777344, name:file1, namelen:5
> > > +*** Parent pointer OK for child testfolder1/file1_link.2 inode:16777345
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1 OK
> > > +*** testfolder1/file1_link.3 OK
> > > +*** Verified parent pointer: inode:16777344, name:file1_link.3, namelen:12
> > > +*** Parent pointer OK for child testfolder1/file1 inode:16777345
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1_link.3 OK
> > > +*** testfolder1/file1 OK
> > > +*** Verified parent pointer: inode:16777344, name:file1, namelen:5
> > > +*** Parent pointer OK for child testfolder1/file1_link.3 inode:16777345
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1 OK
> > > +*** testfolder1/file1_link.4 OK
> > > +*** Verified parent pointer: inode:16777344, name:file1_link.4, namelen:12
> > > +*** Parent pointer OK for child testfolder1/file1 inode:16777345
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1_link.4 OK
> > > +*** testfolder1/file1 OK
> > > +*** Verified parent pointer: inode:16777344, name:file1, namelen:5
> > > +*** Parent pointer OK for child testfolder1/file1_link.4 inode:16777345
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1 OK
> > > +*** testfolder1/file1_link.5 OK
> > > +*** Verified parent pointer: inode:16777344, name:file1_link.5, namelen:12
> > > +*** Parent pointer OK for child testfolder1/file1 inode:16777345
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1_link.5 OK
> > > +*** testfolder1/file1 OK
> > > +*** Verified parent pointer: inode:16777344, name:file1, namelen:5
> > > +*** Parent pointer OK for child testfolder1/file1_link.5 inode:16777345
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1 OK
> > > +*** testfolder1/file1_link.6 OK
> > > +*** Verified parent pointer: inode:16777344, name:file1_link.6, namelen:12
> > > +*** Parent pointer OK for child testfolder1/file1 inode:16777345
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1_link.6 OK
> > > +*** testfolder1/file1 OK
> > > +*** Verified parent pointer: inode:16777344, name:file1, namelen:5
> > > +*** Parent pointer OK for child testfolder1/file1_link.6 inode:16777345
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1 OK
> > > +*** testfolder1/file1_link.7 OK
> > > +*** Verified parent pointer: inode:16777344, name:file1_link.7, namelen:12
> > > +*** Parent pointer OK for child testfolder1/file1 inode:16777345
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1_link.7 OK
> > > +*** testfolder1/file1 OK
> > > +*** Verified parent pointer: inode:16777344, name:file1, namelen:5
> > > +*** Parent pointer OK for child testfolder1/file1_link.7 inode:16777345
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1 OK
> > > +*** testfolder1/file1_link.8 OK
> > > +*** Verified parent pointer: inode:16777344, name:file1_link.8, namelen:12
> > > +*** Parent pointer OK for child testfolder1/file1 inode:16777345
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1_link.8 OK
> > > +*** testfolder1/file1 OK
> > > +*** Verified parent pointer: inode:16777344, name:file1, namelen:5
> > > +*** Parent pointer OK for child testfolder1/file1_link.8 inode:16777345
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1 OK
> > > +*** testfolder1/file1_link.9 OK
> > > +*** Verified parent pointer: inode:16777344, name:file1_link.9, namelen:12
> > > +*** Parent pointer OK for child testfolder1/file1 inode:16777345
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1_link.9 OK
> > > +*** testfolder1/file1 OK
> > > +*** Verified parent pointer: inode:16777344, name:file1, namelen:5
> > > +*** Parent pointer OK for child testfolder1/file1_link.9 inode:16777345
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1 OK
> > > +*** testfolder1/file1_link.10 OK
> > > +*** Verified parent pointer: inode:16777344, name:file1_link.10, namelen:13
> > > +*** Parent pointer OK for child testfolder1/file1 inode:16777345
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1_link.10 OK
> > > +*** testfolder1/file1 OK
> > > +*** Verified parent pointer: inode:16777344, name:file1, namelen:5
> > > +*** Parent pointer OK for child testfolder1/file1_link.10 inode:16777345
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1 OK
> > > +*** testfolder1/file1_link.11 OK
> > > +*** Verified parent pointer: inode:16777344, name:file1_link.11, namelen:13
> > > +*** Parent pointer OK for child testfolder1/file1 inode:16777345
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1_link.11 OK
> > > +*** testfolder1/file1 OK
> > > +*** Verified parent pointer: inode:16777344, name:file1, namelen:5
> > > +*** Parent pointer OK for child testfolder1/file1_link.11 inode:16777345
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1 OK
> > > +*** testfolder1/file1_link.12 OK
> > > +*** Verified parent pointer: inode:16777344, name:file1_link.12, namelen:13
> > > +*** Parent pointer OK for child testfolder1/file1 inode:16777345
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1_link.12 OK
> > > +*** testfolder1/file1 OK
> > > +*** Verified parent pointer: inode:16777344, name:file1, namelen:5
> > > +*** Parent pointer OK for child testfolder1/file1_link.12 inode:16777345
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1 OK
> > > +*** testfolder1/file1_link.13 OK
> > > +*** Verified parent pointer: inode:16777344, name:file1_link.13, namelen:13
> > > +*** Parent pointer OK for child testfolder1/file1 inode:16777345
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1_link.13 OK
> > > +*** testfolder1/file1 OK
> > > +*** Verified parent pointer: inode:16777344, name:file1, namelen:5
> > > +*** Parent pointer OK for child testfolder1/file1_link.13 inode:16777345
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1 OK
> > > +*** testfolder1/file1_link.14 OK
> > > +*** Verified parent pointer: inode:16777344, name:file1_link.14, namelen:13
> > > +*** Parent pointer OK for child testfolder1/file1 inode:16777345
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1_link.14 OK
> > > +*** testfolder1/file1 OK
> > > +*** Verified parent pointer: inode:16777344, name:file1, namelen:5
> > > +*** Parent pointer OK for child testfolder1/file1_link.14 inode:16777345
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1 OK
> > > +*** testfolder1/file1_link.15 OK
> > > +*** Verified parent pointer: inode:16777344, name:file1_link.15, namelen:13
> > > +*** Parent pointer OK for child testfolder1/file1 inode:16777345
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1_link.15 OK
> > > +*** testfolder1/file1 OK
> > > +*** Verified parent pointer: inode:16777344, name:file1, namelen:5
> > > +*** Parent pointer OK for child testfolder1/file1_link.15 inode:16777345
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1 OK
> > > +*** testfolder1/file1_link.16 OK
> > > +*** Verified parent pointer: inode:16777344, name:file1_link.16, namelen:13
> > > +*** Parent pointer OK for child testfolder1/file1 inode:16777345
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1_link.16 OK
> > > +*** testfolder1/file1 OK
> > > +*** Verified parent pointer: inode:16777344, name:file1, namelen:5
> > > +*** Parent pointer OK for child testfolder1/file1_link.16 inode:16777345
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1 OK
> > > +*** testfolder1/file1_link.17 OK
> > > +*** Verified parent pointer: inode:16777344, name:file1_link.17, namelen:13
> > > +*** Parent pointer OK for child testfolder1/file1 inode:16777345
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1_link.17 OK
> > > +*** testfolder1/file1 OK
> > > +*** Verified parent pointer: inode:16777344, name:file1, namelen:5
> > > +*** Parent pointer OK for child testfolder1/file1_link.17 inode:16777345
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1 OK
> > > +*** testfolder1/file1_link.18 OK
> > > +*** Verified parent pointer: inode:16777344, name:file1_link.18, namelen:13
> > > +*** Parent pointer OK for child testfolder1/file1 inode:16777345
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1_link.18 OK
> > > +*** testfolder1/file1 OK
> > > +*** Verified parent pointer: inode:16777344, name:file1, namelen:5
> > > +*** Parent pointer OK for child testfolder1/file1_link.18 inode:16777345
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1 OK
> > > +*** testfolder1/file1_link.19 OK
> > > +*** Verified parent pointer: inode:16777344, name:file1_link.19, namelen:13
> > > +*** Parent pointer OK for child testfolder1/file1 inode:16777345
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1_link.19 OK
> > > +*** testfolder1/file1 OK
> > > +*** Verified parent pointer: inode:16777344, name:file1, namelen:5
> > > +*** Parent pointer OK for child testfolder1/file1_link.19 inode:16777345
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1 OK
> > > +*** testfolder1/file1_link.20 OK
> > > +*** Verified parent pointer: inode:16777344, name:file1_link.20, namelen:13
> > > +*** Parent pointer OK for child testfolder1/file1 inode:16777345
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1_link.20 OK
> > > +*** testfolder1/file1 OK
> > > +*** Verified parent pointer: inode:16777344, name:file1, namelen:5
> > > +*** Parent pointer OK for child testfolder1/file1_link.20 inode:16777345
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1 OK
> > > +*** testfolder1/file1_link.21 OK
> > > +*** Verified parent pointer: inode:16777344, name:file1_link.21, namelen:13
> > > +*** Parent pointer OK for child testfolder1/file1 inode:16777345
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1_link.21 OK
> > > +*** testfolder1/file1 OK
> > > +*** Verified parent pointer: inode:16777344, name:file1, namelen:5
> > > +*** Parent pointer OK for child testfolder1/file1_link.21 inode:16777345
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1 OK
> > > +*** testfolder1/file1_link.22 OK
> > > +*** Verified parent pointer: inode:16777344, name:file1_link.22, namelen:13
> > > +*** Parent pointer OK for child testfolder1/file1 inode:16777345
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1_link.22 OK
> > > +*** testfolder1/file1 OK
> > > +*** Verified parent pointer: inode:16777344, name:file1, namelen:5
> > > +*** Parent pointer OK for child testfolder1/file1_link.22 inode:16777345
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1 OK
> > > +*** testfolder1/file1_link.23 OK
> > > +*** Verified parent pointer: inode:16777344, name:file1_link.23, namelen:13
> > > +*** Parent pointer OK for child testfolder1/file1 inode:16777345
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1_link.23 OK
> > > +*** testfolder1/file1 OK
> > > +*** Verified parent pointer: inode:16777344, name:file1, namelen:5
> > > +*** Parent pointer OK for child testfolder1/file1_link.23 inode:16777345
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1 OK
> > > +*** testfolder1/file1_link.24 OK
> > > +*** Verified parent pointer: inode:16777344, name:file1_link.24, namelen:13
> > > +*** Parent pointer OK for child testfolder1/file1 inode:16777345
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1_link.24 OK
> > > +*** testfolder1/file1 OK
> > > +*** Verified parent pointer: inode:16777344, name:file1, namelen:5
> > > +*** Parent pointer OK for child testfolder1/file1_link.24 inode:16777345
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1 OK
> > > +*** testfolder1/file1_link.25 OK
> > > +*** Verified parent pointer: inode:16777344, name:file1_link.25, namelen:13
> > > +*** Parent pointer OK for child testfolder1/file1 inode:16777345
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1_link.25 OK
> > > +*** testfolder1/file1 OK
> > > +*** Verified parent pointer: inode:16777344, name:file1, namelen:5
> > > +*** Parent pointer OK for child testfolder1/file1_link.25 inode:16777345
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1 OK
> > > +*** testfolder1/file1_link.26 OK
> > > +*** Verified parent pointer: inode:16777344, name:file1_link.26, namelen:13
> > > +*** Parent pointer OK for child testfolder1/file1 inode:16777345
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1_link.26 OK
> > > +*** testfolder1/file1 OK
> > > +*** Verified parent pointer: inode:16777344, name:file1, namelen:5
> > > +*** Parent pointer OK for child testfolder1/file1_link.26 inode:16777345
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1 OK
> > > +*** testfolder1/file1_link.27 OK
> > > +*** Verified parent pointer: inode:16777344, name:file1_link.27, namelen:13
> > > +*** Parent pointer OK for child testfolder1/file1 inode:16777345
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1_link.27 OK
> > > +*** testfolder1/file1 OK
> > > +*** Verified parent pointer: inode:16777344, name:file1, namelen:5
> > > +*** Parent pointer OK for child testfolder1/file1_link.27 inode:16777345
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1 OK
> > > +*** testfolder1/file1_link.28 OK
> > > +*** Verified parent pointer: inode:16777344, name:file1_link.28, namelen:13
> > > +*** Parent pointer OK for child testfolder1/file1 inode:16777345
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1_link.28 OK
> > > +*** testfolder1/file1 OK
> > > +*** Verified parent pointer: inode:16777344, name:file1, namelen:5
> > > +*** Parent pointer OK for child testfolder1/file1_link.28 inode:16777345
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1 OK
> > > +*** testfolder1/file1_link.29 OK
> > > +*** Verified parent pointer: inode:16777344, name:file1_link.29, namelen:13
> > > +*** Parent pointer OK for child testfolder1/file1 inode:16777345
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1_link.29 OK
> > > +*** testfolder1/file1 OK
> > > +*** Verified parent pointer: inode:16777344, name:file1, namelen:5
> > > +*** Parent pointer OK for child testfolder1/file1_link.29 inode:16777345
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1 OK
> > > +*** testfolder1/file1_link.30 OK
> > > +*** Verified parent pointer: inode:16777344, name:file1_link.30, namelen:13
> > > +*** Parent pointer OK for child testfolder1/file1 inode:16777345
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1_link.30 OK
> > > +*** testfolder1/file1 OK
> > > +*** Verified parent pointer: inode:16777344, name:file1, namelen:5
> > > +*** Parent pointer OK for child testfolder1/file1_link.30 inode:16777345
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1 OK
> > > +*** testfolder1/file1_link.31 OK
> > > +*** Verified parent pointer: inode:16777344, name:file1_link.31, namelen:13
> > > +*** Parent pointer OK for child testfolder1/file1 inode:16777345
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1_link.31 OK
> > > +*** testfolder1/file1 OK
> > > +*** Verified parent pointer: inode:16777344, name:file1, namelen:5
> > > +*** Parent pointer OK for child testfolder1/file1_link.31 inode:16777345
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1 OK
> > > +*** testfolder1/file1_link.32 OK
> > > +*** Verified parent pointer: inode:16777344, name:file1_link.32, namelen:13
> > > +*** Parent pointer OK for child testfolder1/file1 inode:16777345
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1_link.32 OK
> > > +*** testfolder1/file1 OK
> > > +*** Verified parent pointer: inode:16777344, name:file1, namelen:5
> > > +*** Parent pointer OK for child testfolder1/file1_link.32 inode:16777345
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1 OK
> > > +*** testfolder1/file1_link.33 OK
> > > +*** Verified parent pointer: inode:16777344, name:file1_link.33, namelen:13
> > > +*** Parent pointer OK for child testfolder1/file1 inode:16777345
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1_link.33 OK
> > > +*** testfolder1/file1 OK
> > > +*** Verified parent pointer: inode:16777344, name:file1, namelen:5
> > > +*** Parent pointer OK for child testfolder1/file1_link.33 inode:16777345
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1 OK
> > > +*** testfolder1/file1_link.34 OK
> > > +*** Verified parent pointer: inode:16777344, name:file1_link.34, namelen:13
> > > +*** Parent pointer OK for child testfolder1/file1 inode:16777345
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1_link.34 OK
> > > +*** testfolder1/file1 OK
> > > +*** Verified parent pointer: inode:16777344, name:file1, namelen:5
> > > +*** Parent pointer OK for child testfolder1/file1_link.34 inode:16777345
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1 OK
> > > +*** testfolder1/file1_link.35 OK
> > > +*** Verified parent pointer: inode:16777344, name:file1_link.35, namelen:13
> > > +*** Parent pointer OK for child testfolder1/file1 inode:16777345
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1_link.35 OK
> > > +*** testfolder1/file1 OK
> > > +*** Verified parent pointer: inode:16777344, name:file1, namelen:5
> > > +*** Parent pointer OK for child testfolder1/file1_link.35 inode:16777345
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1 OK
> > > +*** testfolder1/file1_link.36 OK
> > > +*** Verified parent pointer: inode:16777344, name:file1_link.36, namelen:13
> > > +*** Parent pointer OK for child testfolder1/file1 inode:16777345
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1_link.36 OK
> > > +*** testfolder1/file1 OK
> > > +*** Verified parent pointer: inode:16777344, name:file1, namelen:5
> > > +*** Parent pointer OK for child testfolder1/file1_link.36 inode:16777345
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1 OK
> > > +*** testfolder1/file1_link.37 OK
> > > +*** Verified parent pointer: inode:16777344, name:file1_link.37, namelen:13
> > > +*** Parent pointer OK for child testfolder1/file1 inode:16777345
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1_link.37 OK
> > > +*** testfolder1/file1 OK
> > > +*** Verified parent pointer: inode:16777344, name:file1, namelen:5
> > > +*** Parent pointer OK for child testfolder1/file1_link.37 inode:16777345
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1 OK
> > > +*** testfolder1/file1_link.38 OK
> > > +*** Verified parent pointer: inode:16777344, name:file1_link.38, namelen:13
> > > +*** Parent pointer OK for child testfolder1/file1 inode:16777345
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1_link.38 OK
> > > +*** testfolder1/file1 OK
> > > +*** Verified parent pointer: inode:16777344, name:file1, namelen:5
> > > +*** Parent pointer OK for child testfolder1/file1_link.38 inode:16777345
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1 OK
> > > +*** testfolder1/file1_link.39 OK
> > > +*** Verified parent pointer: inode:16777344, name:file1_link.39, namelen:13
> > > +*** Parent pointer OK for child testfolder1/file1 inode:16777345
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1_link.39 OK
> > > +*** testfolder1/file1 OK
> > > +*** Verified parent pointer: inode:16777344, name:file1, namelen:5
> > > +*** Parent pointer OK for child testfolder1/file1_link.39 inode:16777345
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1 OK
> > > +*** testfolder1/file1_link.40 OK
> > > +*** Verified parent pointer: inode:16777344, name:file1_link.40, namelen:13
> > > +*** Parent pointer OK for child testfolder1/file1 inode:16777345
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1_link.40 OK
> > > +*** testfolder1/file1 OK
> > > +*** Verified parent pointer: inode:16777344, name:file1, namelen:5
> > > +*** Parent pointer OK for child testfolder1/file1_link.40 inode:16777345
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1 OK
> > > +*** testfolder1/file1_link.41 OK
> > > +*** Verified parent pointer: inode:16777344, name:file1_link.41, namelen:13
> > > +*** Parent pointer OK for child testfolder1/file1 inode:16777345
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1_link.41 OK
> > > +*** testfolder1/file1 OK
> > > +*** Verified parent pointer: inode:16777344, name:file1, namelen:5
> > > +*** Parent pointer OK for child testfolder1/file1_link.41 inode:16777345
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1 OK
> > > +*** testfolder1/file1_link.42 OK
> > > +*** Verified parent pointer: inode:16777344, name:file1_link.42, namelen:13
> > > +*** Parent pointer OK for child testfolder1/file1 inode:16777345
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1_link.42 OK
> > > +*** testfolder1/file1 OK
> > > +*** Verified parent pointer: inode:16777344, name:file1, namelen:5
> > > +*** Parent pointer OK for child testfolder1/file1_link.42 inode:16777345
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1 OK
> > > +*** testfolder1/file1_link.43 OK
> > > +*** Verified parent pointer: inode:16777344, name:file1_link.43, namelen:13
> > > +*** Parent pointer OK for child testfolder1/file1 inode:16777345
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1_link.43 OK
> > > +*** testfolder1/file1 OK
> > > +*** Verified parent pointer: inode:16777344, name:file1, namelen:5
> > > +*** Parent pointer OK for child testfolder1/file1_link.43 inode:16777345
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1 OK
> > > +*** testfolder1/file1_link.44 OK
> > > +*** Verified parent pointer: inode:16777344, name:file1_link.44, namelen:13
> > > +*** Parent pointer OK for child testfolder1/file1 inode:16777345
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1_link.44 OK
> > > +*** testfolder1/file1 OK
> > > +*** Verified parent pointer: inode:16777344, name:file1, namelen:5
> > > +*** Parent pointer OK for child testfolder1/file1_link.44 inode:16777345
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1 OK
> > > +*** testfolder1/file1_link.45 OK
> > > +*** Verified parent pointer: inode:16777344, name:file1_link.45, namelen:13
> > > +*** Parent pointer OK for child testfolder1/file1 inode:16777345
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1_link.45 OK
> > > +*** testfolder1/file1 OK
> > > +*** Verified parent pointer: inode:16777344, name:file1, namelen:5
> > > +*** Parent pointer OK for child testfolder1/file1_link.45 inode:16777345
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1 OK
> > > +*** testfolder1/file1_link.46 OK
> > > +*** Verified parent pointer: inode:16777344, name:file1_link.46, namelen:13
> > > +*** Parent pointer OK for child testfolder1/file1 inode:16777345
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1_link.46 OK
> > > +*** testfolder1/file1 OK
> > > +*** Verified parent pointer: inode:16777344, name:file1, namelen:5
> > > +*** Parent pointer OK for child testfolder1/file1_link.46 inode:16777345
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1 OK
> > > +*** testfolder1/file1_link.47 OK
> > > +*** Verified parent pointer: inode:16777344, name:file1_link.47, namelen:13
> > > +*** Parent pointer OK for child testfolder1/file1 inode:16777345
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1_link.47 OK
> > > +*** testfolder1/file1 OK
> > > +*** Verified parent pointer: inode:16777344, name:file1, namelen:5
> > > +*** Parent pointer OK for child testfolder1/file1_link.47 inode:16777345
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1 OK
> > > +*** testfolder1/file1_link.48 OK
> > > +*** Verified parent pointer: inode:16777344, name:file1_link.48, namelen:13
> > > +*** Parent pointer OK for child testfolder1/file1 inode:16777345
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1_link.48 OK
> > > +*** testfolder1/file1 OK
> > > +*** Verified parent pointer: inode:16777344, name:file1, namelen:5
> > > +*** Parent pointer OK for child testfolder1/file1_link.48 inode:16777345
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1 OK
> > > +*** testfolder1/file1_link.49 OK
> > > +*** Verified parent pointer: inode:16777344, name:file1_link.49, namelen:13
> > > +*** Parent pointer OK for child testfolder1/file1 inode:16777345
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1_link.49 OK
> > > +*** testfolder1/file1 OK
> > > +*** Verified parent pointer: inode:16777344, name:file1, namelen:5
> > > +*** Parent pointer OK for child testfolder1/file1_link.49 inode:16777345
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1 OK
> > > +*** testfolder1/file1_link.50 OK
> > > +*** Verified parent pointer: inode:16777344, name:file1_link.50, namelen:13
> > > +*** Parent pointer OK for child testfolder1/file1 inode:16777345
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1_link.50 OK
> > > +*** testfolder1/file1 OK
> > > +*** Verified parent pointer: inode:16777344, name:file1, namelen:5
> > > +*** Parent pointer OK for child testfolder1/file1_link.50 inode:16777345
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1 OK
> > > +*** testfolder1/file1_link.51 OK
> > > +*** Verified parent pointer: inode:16777344, name:file1_link.51, namelen:13
> > > +*** Parent pointer OK for child testfolder1/file1 inode:16777345
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1_link.51 OK
> > > +*** testfolder1/file1 OK
> > > +*** Verified parent pointer: inode:16777344, name:file1, namelen:5
> > > +*** Parent pointer OK for child testfolder1/file1_link.51 inode:16777345
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1 OK
> > > +*** testfolder1/file1_link.52 OK
> > > +*** Verified parent pointer: inode:16777344, name:file1_link.52, namelen:13
> > > +*** Parent pointer OK for child testfolder1/file1 inode:16777345
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1_link.52 OK
> > > +*** testfolder1/file1 OK
> > > +*** Verified parent pointer: inode:16777344, name:file1, namelen:5
> > > +*** Parent pointer OK for child testfolder1/file1_link.52 inode:16777345
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1 OK
> > > +*** testfolder1/file1_link.53 OK
> > > +*** Verified parent pointer: inode:16777344, name:file1_link.53, namelen:13
> > > +*** Parent pointer OK for child testfolder1/file1 inode:16777345
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1_link.53 OK
> > > +*** testfolder1/file1 OK
> > > +*** Verified parent pointer: inode:16777344, name:file1, namelen:5
> > > +*** Parent pointer OK for child testfolder1/file1_link.53 inode:16777345
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1 OK
> > > +*** testfolder1/file1_link.54 OK
> > > +*** Verified parent pointer: inode:16777344, name:file1_link.54, namelen:13
> > > +*** Parent pointer OK for child testfolder1/file1 inode:16777345
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1_link.54 OK
> > > +*** testfolder1/file1 OK
> > > +*** Verified parent pointer: inode:16777344, name:file1, namelen:5
> > > +*** Parent pointer OK for child testfolder1/file1_link.54 inode:16777345
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1 OK
> > > +*** testfolder1/file1_link.55 OK
> > > +*** Verified parent pointer: inode:16777344, name:file1_link.55, namelen:13
> > > +*** Parent pointer OK for child testfolder1/file1 inode:16777345
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1_link.55 OK
> > > +*** testfolder1/file1 OK
> > > +*** Verified parent pointer: inode:16777344, name:file1, namelen:5
> > > +*** Parent pointer OK for child testfolder1/file1_link.55 inode:16777345
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1 OK
> > > +*** testfolder1/file1_link.56 OK
> > > +*** Verified parent pointer: inode:16777344, name:file1_link.56, namelen:13
> > > +*** Parent pointer OK for child testfolder1/file1 inode:16777345
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1_link.56 OK
> > > +*** testfolder1/file1 OK
> > > +*** Verified parent pointer: inode:16777344, name:file1, namelen:5
> > > +*** Parent pointer OK for child testfolder1/file1_link.56 inode:16777345
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1 OK
> > > +*** testfolder1/file1_link.57 OK
> > > +*** Verified parent pointer: inode:16777344, name:file1_link.57, namelen:13
> > > +*** Parent pointer OK for child testfolder1/file1 inode:16777345
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1_link.57 OK
> > > +*** testfolder1/file1 OK
> > > +*** Verified parent pointer: inode:16777344, name:file1, namelen:5
> > > +*** Parent pointer OK for child testfolder1/file1_link.57 inode:16777345
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1 OK
> > > +*** testfolder1/file1_link.58 OK
> > > +*** Verified parent pointer: inode:16777344, name:file1_link.58, namelen:13
> > > +*** Parent pointer OK for child testfolder1/file1 inode:16777345
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1_link.58 OK
> > > +*** testfolder1/file1 OK
> > > +*** Verified parent pointer: inode:16777344, name:file1, namelen:5
> > > +*** Parent pointer OK for child testfolder1/file1_link.58 inode:16777345
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1 OK
> > > +*** testfolder1/file1_link.59 OK
> > > +*** Verified parent pointer: inode:16777344, name:file1_link.59, namelen:13
> > > +*** Parent pointer OK for child testfolder1/file1 inode:16777345
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1_link.59 OK
> > > +*** testfolder1/file1 OK
> > > +*** Verified parent pointer: inode:16777344, name:file1, namelen:5
> > > +*** Parent pointer OK for child testfolder1/file1_link.59 inode:16777345
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1 OK
> > > +*** testfolder1/file1_link.60 OK
> > > +*** Verified parent pointer: inode:16777344, name:file1_link.60, namelen:13
> > > +*** Parent pointer OK for child testfolder1/file1 inode:16777345
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1_link.60 OK
> > > +*** testfolder1/file1 OK
> > > +*** Verified parent pointer: inode:16777344, name:file1, namelen:5
> > > +*** Parent pointer OK for child testfolder1/file1_link.60 inode:16777345
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1 OK
> > > +*** testfolder1/file1_link.61 OK
> > > +*** Verified parent pointer: inode:16777344, name:file1_link.61, namelen:13
> > > +*** Parent pointer OK for child testfolder1/file1 inode:16777345
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1_link.61 OK
> > > +*** testfolder1/file1 OK
> > > +*** Verified parent pointer: inode:16777344, name:file1, namelen:5
> > > +*** Parent pointer OK for child testfolder1/file1_link.61 inode:16777345
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1 OK
> > > +*** testfolder1/file1_link.62 OK
> > > +*** Verified parent pointer: inode:16777344, name:file1_link.62, namelen:13
> > > +*** Parent pointer OK for child testfolder1/file1 inode:16777345
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1_link.62 OK
> > > +*** testfolder1/file1 OK
> > > +*** Verified parent pointer: inode:16777344, name:file1, namelen:5
> > > +*** Parent pointer OK for child testfolder1/file1_link.62 inode:16777345
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1 OK
> > > +*** testfolder1/file1_link.63 OK
> > > +*** Verified parent pointer: inode:16777344, name:file1_link.63, namelen:13
> > > +*** Parent pointer OK for child testfolder1/file1 inode:16777345
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1_link.63 OK
> > > +*** testfolder1/file1 OK
> > > +*** Verified parent pointer: inode:16777344, name:file1, namelen:5
> > > +*** Parent pointer OK for child testfolder1/file1_link.63 inode:16777345
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1 OK
> > > +*** testfolder1/file1_link.64 OK
> > > +*** Verified parent pointer: inode:16777344, name:file1_link.64, namelen:13
> > > +*** Parent pointer OK for child testfolder1/file1 inode:16777345
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1_link.64 OK
> > > +*** testfolder1/file1 OK
> > > +*** Verified parent pointer: inode:16777344, name:file1, namelen:5
> > > +*** Parent pointer OK for child testfolder1/file1_link.64 inode:16777345
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1 OK
> > > +*** testfolder1/file1_link.65 OK
> > > +*** Verified parent pointer: inode:16777344, name:file1_link.65, namelen:13
> > > +*** Parent pointer OK for child testfolder1/file1 inode:16777345
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1_link.65 OK
> > > +*** testfolder1/file1 OK
> > > +*** Verified parent pointer: inode:16777344, name:file1, namelen:5
> > > +*** Parent pointer OK for child testfolder1/file1_link.65 inode:16777345
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1 OK
> > > +*** testfolder1/file1_link.66 OK
> > > +*** Verified parent pointer: inode:16777344, name:file1_link.66, namelen:13
> > > +*** Parent pointer OK for child testfolder1/file1 inode:16777345
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1_link.66 OK
> > > +*** testfolder1/file1 OK
> > > +*** Verified parent pointer: inode:16777344, name:file1, namelen:5
> > > +*** Parent pointer OK for child testfolder1/file1_link.66 inode:16777345
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1 OK
> > > +*** testfolder1/file1_link.67 OK
> > > +*** Verified parent pointer: inode:16777344, name:file1_link.67, namelen:13
> > > +*** Parent pointer OK for child testfolder1/file1 inode:16777345
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1_link.67 OK
> > > +*** testfolder1/file1 OK
> > > +*** Verified parent pointer: inode:16777344, name:file1, namelen:5
> > > +*** Parent pointer OK for child testfolder1/file1_link.67 inode:16777345
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1 OK
> > > +*** testfolder1/file1_link.68 OK
> > > +*** Verified parent pointer: inode:16777344, name:file1_link.68, namelen:13
> > > +*** Parent pointer OK for child testfolder1/file1 inode:16777345
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1_link.68 OK
> > > +*** testfolder1/file1 OK
> > > +*** Verified parent pointer: inode:16777344, name:file1, namelen:5
> > > +*** Parent pointer OK for child testfolder1/file1_link.68 inode:16777345
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1 OK
> > > +*** testfolder1/file1_link.69 OK
> > > +*** Verified parent pointer: inode:16777344, name:file1_link.69, namelen:13
> > > +*** Parent pointer OK for child testfolder1/file1 inode:16777345
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1_link.69 OK
> > > +*** testfolder1/file1 OK
> > > +*** Verified parent pointer: inode:16777344, name:file1, namelen:5
> > > +*** Parent pointer OK for child testfolder1/file1_link.69 inode:16777345
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1 OK
> > > +*** testfolder1/file1_link.70 OK
> > > +*** Verified parent pointer: inode:16777344, name:file1_link.70, namelen:13
> > > +*** Parent pointer OK for child testfolder1/file1 inode:16777345
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1_link.70 OK
> > > +*** testfolder1/file1 OK
> > > +*** Verified parent pointer: inode:16777344, name:file1, namelen:5
> > > +*** Parent pointer OK for child testfolder1/file1_link.70 inode:16777345
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1 OK
> > > +*** testfolder1/file1_link.71 OK
> > > +*** Verified parent pointer: inode:16777344, name:file1_link.71, namelen:13
> > > +*** Parent pointer OK for child testfolder1/file1 inode:16777345
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1_link.71 OK
> > > +*** testfolder1/file1 OK
> > > +*** Verified parent pointer: inode:16777344, name:file1, namelen:5
> > > +*** Parent pointer OK for child testfolder1/file1_link.71 inode:16777345
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1 OK
> > > +*** testfolder1/file1_link.72 OK
> > > +*** Verified parent pointer: inode:16777344, name:file1_link.72, namelen:13
> > > +*** Parent pointer OK for child testfolder1/file1 inode:16777345
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1_link.72 OK
> > > +*** testfolder1/file1 OK
> > > +*** Verified parent pointer: inode:16777344, name:file1, namelen:5
> > > +*** Parent pointer OK for child testfolder1/file1_link.72 inode:16777345
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1 OK
> > > +*** testfolder1/file1_link.73 OK
> > > +*** Verified parent pointer: inode:16777344, name:file1_link.73, namelen:13
> > > +*** Parent pointer OK for child testfolder1/file1 inode:16777345
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1_link.73 OK
> > > +*** testfolder1/file1 OK
> > > +*** Verified parent pointer: inode:16777344, name:file1, namelen:5
> > > +*** Parent pointer OK for child testfolder1/file1_link.73 inode:16777345
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1 OK
> > > +*** testfolder1/file1_link.74 OK
> > > +*** Verified parent pointer: inode:16777344, name:file1_link.74, namelen:13
> > > +*** Parent pointer OK for child testfolder1/file1 inode:16777345
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1_link.74 OK
> > > +*** testfolder1/file1 OK
> > > +*** Verified parent pointer: inode:16777344, name:file1, namelen:5
> > > +*** Parent pointer OK for child testfolder1/file1_link.74 inode:16777345
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1 OK
> > > +*** testfolder1/file1_link.75 OK
> > > +*** Verified parent pointer: inode:16777344, name:file1_link.75, namelen:13
> > > +*** Parent pointer OK for child testfolder1/file1 inode:16777345
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1_link.75 OK
> > > +*** testfolder1/file1 OK
> > > +*** Verified parent pointer: inode:16777344, name:file1, namelen:5
> > > +*** Parent pointer OK for child testfolder1/file1_link.75 inode:16777345
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1 OK
> > > +*** testfolder1/file1_link.76 OK
> > > +*** Verified parent pointer: inode:16777344, name:file1_link.76, namelen:13
> > > +*** Parent pointer OK for child testfolder1/file1 inode:16777345
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1_link.76 OK
> > > +*** testfolder1/file1 OK
> > > +*** Verified parent pointer: inode:16777344, name:file1, namelen:5
> > > +*** Parent pointer OK for child testfolder1/file1_link.76 inode:16777345
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1 OK
> > > +*** testfolder1/file1_link.77 OK
> > > +*** Verified parent pointer: inode:16777344, name:file1_link.77, namelen:13
> > > +*** Parent pointer OK for child testfolder1/file1 inode:16777345
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1_link.77 OK
> > > +*** testfolder1/file1 OK
> > > +*** Verified parent pointer: inode:16777344, name:file1, namelen:5
> > > +*** Parent pointer OK for child testfolder1/file1_link.77 inode:16777345
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1 OK
> > > +*** testfolder1/file1_link.78 OK
> > > +*** Verified parent pointer: inode:16777344, name:file1_link.78, namelen:13
> > > +*** Parent pointer OK for child testfolder1/file1 inode:16777345
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1_link.78 OK
> > > +*** testfolder1/file1 OK
> > > +*** Verified parent pointer: inode:16777344, name:file1, namelen:5
> > > +*** Parent pointer OK for child testfolder1/file1_link.78 inode:16777345
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1 OK
> > > +*** testfolder1/file1_link.79 OK
> > > +*** Verified parent pointer: inode:16777344, name:file1_link.79, namelen:13
> > > +*** Parent pointer OK for child testfolder1/file1 inode:16777345
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1_link.79 OK
> > > +*** testfolder1/file1 OK
> > > +*** Verified parent pointer: inode:16777344, name:file1, namelen:5
> > > +*** Parent pointer OK for child testfolder1/file1_link.79 inode:16777345
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1 OK
> > > +*** testfolder1/file1_link.80 OK
> > > +*** Verified parent pointer: inode:16777344, name:file1_link.80, namelen:13
> > > +*** Parent pointer OK for child testfolder1/file1 inode:16777345
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1_link.80 OK
> > > +*** testfolder1/file1 OK
> > > +*** Verified parent pointer: inode:16777344, name:file1, namelen:5
> > > +*** Parent pointer OK for child testfolder1/file1_link.80 inode:16777345
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1 OK
> > > +*** testfolder1/file1_link.81 OK
> > > +*** Verified parent pointer: inode:16777344, name:file1_link.81, namelen:13
> > > +*** Parent pointer OK for child testfolder1/file1 inode:16777345
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1_link.81 OK
> > > +*** testfolder1/file1 OK
> > > +*** Verified parent pointer: inode:16777344, name:file1, namelen:5
> > > +*** Parent pointer OK for child testfolder1/file1_link.81 inode:16777345
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1 OK
> > > +*** testfolder1/file1_link.82 OK
> > > +*** Verified parent pointer: inode:16777344, name:file1_link.82, namelen:13
> > > +*** Parent pointer OK for child testfolder1/file1 inode:16777345
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1_link.82 OK
> > > +*** testfolder1/file1 OK
> > > +*** Verified parent pointer: inode:16777344, name:file1, namelen:5
> > > +*** Parent pointer OK for child testfolder1/file1_link.82 inode:16777345
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1 OK
> > > +*** testfolder1/file1_link.83 OK
> > > +*** Verified parent pointer: inode:16777344, name:file1_link.83, namelen:13
> > > +*** Parent pointer OK for child testfolder1/file1 inode:16777345
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1_link.83 OK
> > > +*** testfolder1/file1 OK
> > > +*** Verified parent pointer: inode:16777344, name:file1, namelen:5
> > > +*** Parent pointer OK for child testfolder1/file1_link.83 inode:16777345
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1 OK
> > > +*** testfolder1/file1_link.84 OK
> > > +*** Verified parent pointer: inode:16777344, name:file1_link.84, namelen:13
> > > +*** Parent pointer OK for child testfolder1/file1 inode:16777345
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1_link.84 OK
> > > +*** testfolder1/file1 OK
> > > +*** Verified parent pointer: inode:16777344, name:file1, namelen:5
> > > +*** Parent pointer OK for child testfolder1/file1_link.84 inode:16777345
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1 OK
> > > +*** testfolder1/file1_link.85 OK
> > > +*** Verified parent pointer: inode:16777344, name:file1_link.85, namelen:13
> > > +*** Parent pointer OK for child testfolder1/file1 inode:16777345
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1_link.85 OK
> > > +*** testfolder1/file1 OK
> > > +*** Verified parent pointer: inode:16777344, name:file1, namelen:5
> > > +*** Parent pointer OK for child testfolder1/file1_link.85 inode:16777345
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1 OK
> > > +*** testfolder1/file1_link.86 OK
> > > +*** Verified parent pointer: inode:16777344, name:file1_link.86, namelen:13
> > > +*** Parent pointer OK for child testfolder1/file1 inode:16777345
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1_link.86 OK
> > > +*** testfolder1/file1 OK
> > > +*** Verified parent pointer: inode:16777344, name:file1, namelen:5
> > > +*** Parent pointer OK for child testfolder1/file1_link.86 inode:16777345
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1 OK
> > > +*** testfolder1/file1_link.87 OK
> > > +*** Verified parent pointer: inode:16777344, name:file1_link.87, namelen:13
> > > +*** Parent pointer OK for child testfolder1/file1 inode:16777345
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1_link.87 OK
> > > +*** testfolder1/file1 OK
> > > +*** Verified parent pointer: inode:16777344, name:file1, namelen:5
> > > +*** Parent pointer OK for child testfolder1/file1_link.87 inode:16777345
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1 OK
> > > +*** testfolder1/file1_link.88 OK
> > > +*** Verified parent pointer: inode:16777344, name:file1_link.88, namelen:13
> > > +*** Parent pointer OK for child testfolder1/file1 inode:16777345
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1_link.88 OK
> > > +*** testfolder1/file1 OK
> > > +*** Verified parent pointer: inode:16777344, name:file1, namelen:5
> > > +*** Parent pointer OK for child testfolder1/file1_link.88 inode:16777345
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1 OK
> > > +*** testfolder1/file1_link.89 OK
> > > +*** Verified parent pointer: inode:16777344, name:file1_link.89, namelen:13
> > > +*** Parent pointer OK for child testfolder1/file1 inode:16777345
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1_link.89 OK
> > > +*** testfolder1/file1 OK
> > > +*** Verified parent pointer: inode:16777344, name:file1, namelen:5
> > > +*** Parent pointer OK for child testfolder1/file1_link.89 inode:16777345
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1 OK
> > > +*** testfolder1/file1_link.90 OK
> > > +*** Verified parent pointer: inode:16777344, name:file1_link.90, namelen:13
> > > +*** Parent pointer OK for child testfolder1/file1 inode:16777345
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1_link.90 OK
> > > +*** testfolder1/file1 OK
> > > +*** Verified parent pointer: inode:16777344, name:file1, namelen:5
> > > +*** Parent pointer OK for child testfolder1/file1_link.90 inode:16777345
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1 OK
> > > +*** testfolder1/file1_link.91 OK
> > > +*** Verified parent pointer: inode:16777344, name:file1_link.91, namelen:13
> > > +*** Parent pointer OK for child testfolder1/file1 inode:16777345
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1_link.91 OK
> > > +*** testfolder1/file1 OK
> > > +*** Verified parent pointer: inode:16777344, name:file1, namelen:5
> > > +*** Parent pointer OK for child testfolder1/file1_link.91 inode:16777345
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1 OK
> > > +*** testfolder1/file1_link.92 OK
> > > +*** Verified parent pointer: inode:16777344, name:file1_link.92, namelen:13
> > > +*** Parent pointer OK for child testfolder1/file1 inode:16777345
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1_link.92 OK
> > > +*** testfolder1/file1 OK
> > > +*** Verified parent pointer: inode:16777344, name:file1, namelen:5
> > > +*** Parent pointer OK for child testfolder1/file1_link.92 inode:16777345
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1 OK
> > > +*** testfolder1/file1_link.93 OK
> > > +*** Verified parent pointer: inode:16777344, name:file1_link.93, namelen:13
> > > +*** Parent pointer OK for child testfolder1/file1 inode:16777345
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1_link.93 OK
> > > +*** testfolder1/file1 OK
> > > +*** Verified parent pointer: inode:16777344, name:file1, namelen:5
> > > +*** Parent pointer OK for child testfolder1/file1_link.93 inode:16777345
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1 OK
> > > +*** testfolder1/file1_link.94 OK
> > > +*** Verified parent pointer: inode:16777344, name:file1_link.94, namelen:13
> > > +*** Parent pointer OK for child testfolder1/file1 inode:16777345
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1_link.94 OK
> > > +*** testfolder1/file1 OK
> > > +*** Verified parent pointer: inode:16777344, name:file1, namelen:5
> > > +*** Parent pointer OK for child testfolder1/file1_link.94 inode:16777345
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1 OK
> > > +*** testfolder1/file1_link.95 OK
> > > +*** Verified parent pointer: inode:16777344, name:file1_link.95, namelen:13
> > > +*** Parent pointer OK for child testfolder1/file1 inode:16777345
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1_link.95 OK
> > > +*** testfolder1/file1 OK
> > > +*** Verified parent pointer: inode:16777344, name:file1, namelen:5
> > > +*** Parent pointer OK for child testfolder1/file1_link.95 inode:16777345
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1 OK
> > > +*** testfolder1/file1_link.96 OK
> > > +*** Verified parent pointer: inode:16777344, name:file1_link.96, namelen:13
> > > +*** Parent pointer OK for child testfolder1/file1 inode:16777345
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1_link.96 OK
> > > +*** testfolder1/file1 OK
> > > +*** Verified parent pointer: inode:16777344, name:file1, namelen:5
> > > +*** Parent pointer OK for child testfolder1/file1_link.96 inode:16777345
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1 OK
> > > +*** testfolder1/file1_link.97 OK
> > > +*** Verified parent pointer: inode:16777344, name:file1_link.97, namelen:13
> > > +*** Parent pointer OK for child testfolder1/file1 inode:16777345
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1_link.97 OK
> > > +*** testfolder1/file1 OK
> > > +*** Verified parent pointer: inode:16777344, name:file1, namelen:5
> > > +*** Parent pointer OK for child testfolder1/file1_link.97 inode:16777345
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1 OK
> > > +*** testfolder1/file1_link.98 OK
> > > +*** Verified parent pointer: inode:16777344, name:file1_link.98, namelen:13
> > > +*** Parent pointer OK for child testfolder1/file1 inode:16777345
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1_link.98 OK
> > > +*** testfolder1/file1 OK
> > > +*** Verified parent pointer: inode:16777344, name:file1, namelen:5
> > > +*** Parent pointer OK for child testfolder1/file1_link.98 inode:16777345
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1 OK
> > > +*** testfolder1/file1_link.99 OK
> > > +*** Verified parent pointer: inode:16777344, name:file1_link.99, namelen:13
> > > +*** Parent pointer OK for child testfolder1/file1 inode:16777345
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1_link.99 OK
> > > +*** testfolder1/file1 OK
> > > +*** Verified parent pointer: inode:16777344, name:file1, namelen:5
> > > +*** Parent pointer OK for child testfolder1/file1_link.99 inode:16777345
> > > +Multi unlink parent pointer test
> > > +
> > > +Error inject test
> > > +Create files
> > > +*** testfolder1 OK
> > > +*** testfolder1/file4 OK
> > > +*** testfolder1/file4 OK
> > > +*** Verified parent pointer: inode:16777344, name:file4, namelen:5
> > > +*** Parent pointer OK for child testfolder1/file4 inode:16777346
> > > +Inject error
> > > +Move files
> > > +mv: cannot move '/mnt/scratch/testfolder1/file4' to '/mnt/scratch/testfolder2/file5': Input/output error
> > > +FS should be shut down, touch will fail
> > > +touch: cannot touch 'SCRATCH_MNT/testfolder2/file5': Input/output error
> > > +Remount to replay log
> > > +FS should be online, touch should succeed
> > > +Check files again
> > > +*** testfolder2 OK
> > > +*** testfolder2/file5 OK
> > > +*** testfolder2/file5 OK
> > > +*** Verified parent pointer: inode:33613312, name:file5, namelen:5
> > > +*** Parent pointer OK for child testfolder2/file5 inode:16777346
> > > +*** unmount FS
> > > +*** done
> > > diff --git a/tests/xfs/group b/tests/xfs/group
> > > index 2319f58..fb74e82 100644
> > > --- a/tests/xfs/group
> > > +++ b/tests/xfs/group
> > > @@ -445,3 +445,4 @@
> > >   445 auto quick filestreams
> > >   446 auto quick
> > >   447 auto mount
> > > +448 auto
> > > -- 
> > > 2.7.4
> > > 
> > > --
> > > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > > the body of a message to majordomo@vger.kernel.org
> > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
