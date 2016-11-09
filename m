Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:30641 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752282AbcKIA3z (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 8 Nov 2016 19:29:55 -0500
Date: Tue, 8 Nov 2016 16:29:46 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 1/9] populate: create all types of XFS metadata
Message-ID: <20161109002946.GE20710@birch.djwong.org>
References: <147830503054.1919.4998804611100937975.stgit@birch.djwong.org>
 <147830503682.1919.1673201723512253812.stgit@birch.djwong.org>
 <20161107153413.GL27776@eguan.usersys.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161107153413.GL27776@eguan.usersys.redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eryu Guan <eguan@redhat.com>
Cc: david@fromorbit.com, linux-xfs@vger.kernel.org, fstests@vger.kernel.org

On Mon, Nov 07, 2016 at 11:34:13PM +0800, Eryu Guan wrote:
> On Fri, Nov 04, 2016 at 05:17:16PM -0700, Darrick J. Wong wrote:
> > We have three new metadata types -- rmapbt, rtrmapbt, and refcountbt.
> > Ensure that we populate the scratch fs with all three.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  common/populate |   87 ++++++++++++++++++++++++++++++++++++++++++++++++++-----
> >  1 file changed, 79 insertions(+), 8 deletions(-)
> > 
> > 
> > diff --git a/common/populate b/common/populate
> > index d0003c5..6ada902 100644
> > --- a/common/populate
> > +++ b/common/populate
> > @@ -24,6 +24,7 @@
> >  
> >  _require_xfs_io_command "falloc"
> >  _require_xfs_io_command "fpunch"
> > +_require_test_program "punch-alternating"
> >  
> >  _require_xfs_db_blocktrash_z_command() {
> >  	test "${FSTYP}" = "xfs" || _notrun "cannot run xfs_db on ${FSTYP}"
> > @@ -106,9 +107,7 @@ _scratch_xfs_populate() {
> >  	echo "+ btree extents file"
> >  	nr="$((blksz * 2 / 16))"
> >  	$XFS_IO_PROG -f -c "pwrite -S 0x62 0 $((blksz * nr))" "${SCRATCH_MNT}/S_IFREG.FMT_BTREE"
> > -	for i in $(seq 1 2 ${nr}); do
> > -		$XFS_IO_PROG -f -c "fpunch $((i * blksz)) ${blksz}" "${SCRATCH_MNT}/S_IFREG.FMT_BTREE"
> > -	done
> > +	./src/punch-alternating "${SCRATCH_MNT}/S_IFREG.FMT_BTREE"
> >  
> >  	# Directories
> >  	# - INLINE
> > @@ -128,6 +127,7 @@ _scratch_xfs_populate() {
> >  	__populate_create_dir "${SCRATCH_MNT}/S_IFDIR.FMT_NODE" "$((16 * dblksz / 40))" true
> >  
> >  	# - BTREE
> > +	echo "+ btree dir"
> >  	__populate_create_dir "${SCRATCH_MNT}/S_IFDIR.FMT_BTREE" "$((128 * dblksz / 40))" true
> >  
> >  	# Symlinks
> > @@ -180,10 +180,43 @@ _scratch_xfs_populate() {
> >  	$XFS_IO_PROG -f -c 'fsync' "${SCRATCH_MNT}/unused"
> >  	rm -rf "${SCRATCH_MNT}/unused"
> >  
> > +	# Free space btree
> > +	echo "+ freesp btree"
> > +	nr="$((blksz * 2 / 8))"
> > +	$XFS_IO_PROG -f -c "pwrite -S 0x62 0 $((blksz * nr))" "${SCRATCH_MNT}/BNOBT"
> > +	./src/punch-alternating "${SCRATCH_MNT}/BNOBT"
> > +
> > +	# Reverse-mapping btree
> > +	is_rmapbt="$(xfs_info "${SCRATCH_MNT}" | grep -c 'rmapbt=1')"
> > +	if [ $is_rmapbt -gt 0 ]; then
> > +		echo "+ rmapbt btree"
> > +		nr="$((blksz * 2 / 24))"
> > +		$XFS_IO_PROG -f -c "pwrite -S 0x62 0 $((blksz * nr))" "${SCRATCH_MNT}/RMAPBT"
> > +		./src/punch-alternating "${SCRATCH_MNT}/RMAPBT"
> > +	fi
> > +
> > +	# Realtime Reverse-mapping btree
> > +	is_rt="$(xfs_info "${SCRATCH_MNT}" | grep -c 'rtextents=[1-9]')"
> > +	if [ $is_rmapbt -gt 0 ] && [ $is_rt -gt 0 ]; then
> > +		echo "+ rtrmapbt btree"
> > +		nr="$((blksz * 2 / 32))"
> > +		$XFS_IO_PROG -f -R -c "pwrite -S 0x62 0 $((blksz * nr))" "${SCRATCH_MNT}/RTRMAPBT"
> > +		./src/punch-alternating "${SCRATCH_MNT}/RTRMAPBT"
> > +	fi
> > +
> > +	# Reference-count btree
> > +	is_reflink="$(xfs_info "${SCRATCH_MNT}" | grep -c 'reflink=1')"
> > +	if [ $is_reflink -gt 0 ]; then
> > +		echo "+ reflink btree"
> > +		nr="$((blksz * 2 / 12))"
> > +		$XFS_IO_PROG -f -c "pwrite -S 0x62 0 $((blksz * nr))" "${SCRATCH_MNT}/REFCOUNTBT"
> > +		cp --reflink=always "${SCRATCH_MNT}/REFCOUNTBT" "${SCRATCH_MNT}/REFCOUNTBT2"
> > +		./src/punch-alternating "${SCRATCH_MNT}/REFCOUNTBT"
> > +	fi
> > +
> >  	# Copy some real files (xfs tests, I guess...)
> >  	echo "+ real files"
> > -	#__populate_fill_fs "${SCRATCH_MNT}" 40
> > -	cp -pRdu --reflink=always "${SCRATCH_MNT}/S_IFREG.FMT_BTREE" "${SCRATCH_MNT}/S_IFREG.FMT_BTREE.REFLINK" 2> /dev/null
> > +	test $fill -ne 0 && __populate_fill_fs "${SCRATCH_MNT}" 5
> 
> Seems this hunk belongs to patch 3/9? There's no "fill" in this context.

Yep.  I'll fix this.

> >  	umount "${SCRATCH_MNT}"
> >  }
> > @@ -212,9 +245,7 @@ _scratch_ext4_populate() {
> >  	echo "+ extent tree file"
> >  	nr="$((blksz * 2 / 12))"
> >  	$XFS_IO_PROG -f -c "pwrite -S 0x62 0 $((blksz * nr))" "${SCRATCH_MNT}/S_IFREG.FMT_ETREE"
> > -	for i in $(seq 1 2 ${nr}); do
> > -		$XFS_IO_PROG -f -c "fpunch $((i * blksz)) ${blksz}" "${SCRATCH_MNT}/S_IFREG.FMT_ETREE"
> > -	done
> > +	./src/punch-alternating "${SCRATCH_MNT}/S_IFREG.FMT_ETREE"
> >  
> >  	# Directories
> >  	# - INLINE
> > @@ -349,6 +380,39 @@ __populate_check_xfs_attr() {
> >  	esac
> >  }
> >  
> > +# Check that there's at least one per-AG btree with multiple levels
> > +__populate_check_xfs_agbtree_height() {
> > +	bt_type="$1"
> > +	nr_ags=$(_scratch_xfs_db -c 'sb 0' -c 'p agcount' | awk '{print $3}')
> > +
> > +	case "${bt_type}" in
> > +	"bno"|"cnt"|"rmap"|"refcnt")
> > +		hdr="agf"
> > +		bt_prefix="${bt_type}"
> > +		;;
> > +	"ino")
> > +		hdr="agi"
> > +		bt_prefix=""
> > +		;;
> > +	"fino")
> > +		hdr="agi"
> > +		bt_prefix="free_"
> > +		;;
> > +	*)
> > +		_fail "Don't know about AG btree ${bt_type}"
> > +		;;
> > +	esac
> > +
> > +	seq 0 $((nr_ags - 1)) | while read ag; do
> > +		bt_level=$(_scratch_xfs_db -c "${hdr} ${ag}" -c "p ${bt_prefix}level" | awk '{print $3}')
> > +		if [ "${bt_level}" -gt 1 ]; then
> > +			return 100
> > +		fi
> > +	done
> > +	test $? -eq 100 || _fail "Failed to create ${bt_type} of sufficient height!"
> 
> I'm a bit confused here, why test against 100? Because of the
> "return 100" above? That should exit the function and return to caller
> already.

The while loop+body executes in a subshell because of the "seq ... |
while" behavior, so the 'return 100' exits the subshell with a return
code of 100, depositing us at the first statement after the "done"
clause.  That's the "test $? -eq 100" statement, which is how
__populate_check_xfs_agbtree_height catches the early loop termination
so that we can _fail the test.  We can't call _fail from inside the
subshell because that will only abort the loop, not the whole test.

FWIW all that is unnecessary if we do:

for ag in $(seq 0 $((nr_ags - 1)) ); do
	...
done 

But I prefer to code that a little more defensively when possible since
that could result in a very long command line.

--D

> 
> Thanks,
> Eryu
> 
> > +	return 1
> > +}
> > +
> >  # Check that populate created all the types of files we wanted
> >  _scratch_xfs_populate_check() {
> >  	_scratch_mount
> > @@ -367,6 +431,9 @@ _scratch_xfs_populate_check() {
> >  	leaf_attr="$(__populate_find_inode "${SCRATCH_MNT}/ATTR.FMT_LEAF")"
> >  	node_attr="$(__populate_find_inode "${SCRATCH_MNT}/ATTR.FMT_NODE")"
> >  	btree_attr="$(__populate_find_inode "${SCRATCH_MNT}/ATTR.FMT_BTREE")"
> > +	is_finobt=$(xfs_info "${SCRATCH_MNT}" | grep -c 'finobt=1')
> > +	is_rmapbt=$(xfs_info "${SCRATCH_MNT}" | grep -c 'rmapbt=1')
> > +	is_reflink=$(xfs_info "${SCRATCH_MNT}" | grep -c 'reflink=1')
> >  
> >  	blksz="$(stat -f -c '%s' "${SCRATCH_MNT}")"
> >  	dblksz="$(xfs_info "${SCRATCH_MNT}" | grep naming.*bsize | sed -e 's/^.*bsize=//g' -e 's/\([0-9]*\).*$/\1/g')"
> > @@ -389,6 +456,10 @@ _scratch_xfs_populate_check() {
> >  	__populate_check_xfs_attr "${node_attr}" "node"
> >  	__populate_check_xfs_attr "${btree_attr}" "btree"
> >  	__populate_check_xfs_aformat "${btree_attr}" "btree"
> > +	__populate_check_xfs_agbtree_height "bno"
> > +	__populate_check_xfs_agbtree_height "cnt"
> > +	test -n $is_rmapbt && __populate_check_xfs_agbtree_height "rmap"
> > +	test -n $is_reflink && __populate_check_xfs_agbtree_height "refcnt"
> >  }
> >  
> >  # Check data fork format of ext4 file
> > 
