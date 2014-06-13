Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id A9DA27F3F
	for <xfs@oss.sgi.com>; Thu, 12 Jun 2014 21:28:12 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 1F35DAC002
	for <xfs@oss.sgi.com>; Thu, 12 Jun 2014 19:28:12 -0700 (PDT)
Received: from mail-yk0-f173.google.com (mail-yk0-f173.google.com
	[209.85.160.173]) by cuda.sgi.com with ESMTP id
	vqxEnwsaEfSRXJeB (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Thu, 12 Jun 2014 19:28:09 -0700 (PDT)
Received: by mail-yk0-f173.google.com with SMTP id q200so1621720ykb.4
	for <xfs@oss.sgi.com>; Thu, 12 Jun 2014 19:28:09 -0700 (PDT)
Message-ID: <539A61B2.5040202@gmail.com>
Date: Thu, 12 Jun 2014 22:28:02 -0400
From: "Michael L. Semon" <mlsemon35@gmail.com>
MIME-Version: 1.0
Subject: Re: xfs_repair issue with ACLs on v5 XFS when beyond v4 limits
References: <5396799F.3050801@gmail.com> <20140610055254.GF9508@dastard>
In-Reply-To: <20140610055254.GF9508@dastard>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs-oss <xfs@oss.sgi.com>

On 06/10/2014 01:52 AM, Dave Chinner wrote:
> On Mon, Jun 09, 2014 at 11:21:03PM -0400, Michael L. Semon wrote:
>> Hi!  I've been running around in circles trying to work with too many 
>> ACLs, even losing my ability to count for a while.  Along the way, 
>> xfs_repair from git xfsprogs (last commit around May 27) is showing 
>> the following symptoms:
>>
>> On v5-superblock XFS...
>>
>> 1) When the ACL count is just above the limit from v4-superblock XFS--
>> 96 is a good test figure--`xfs_repair -n` and `xfs_repair` will both 
>> end in a segmentation fault.
> 
> I couldn't reproduce this - I suspect that this is a problem with
> the ACL struct having a hardcoded array size or userspace not
> having the correct padding in the on-disk structure definition and
> you are on a 32bit system. I think I've fixed that in the patch
> below.

Maybe.  Pentium III has a narrower cacheline than the Pentium 4, so 
I was not surprised to see holes in the XFS kernel code, even in the 
non-XFS kernel structs.  Do I need to upgrade something (ACL, system 
kernel headers, etc.) or would a pahole trip through libxfs be more 
revealing?

What I'm getting is that if xfs_repair is counting between 200 and 
256 ACLs, it will mention that there are too many ACLs, and it will 
segfault.  With your patch, the areas below and above this range are 
OK.

A sample session like the one I overwrote last time looks like this:

Phase 1 - find and verify superblock...
Phase 2 - using internal log
        - zero log...
        - scan filesystem freespace and inode maps...
        - found root inode chunk
Phase 3 - for each AG...
        - scan and clear agi unlinked lists...
        - process known inodes and perform inode discovery...
        - agno = 0
Too many ACL entries, count 250
entry contains illegal value in attribute named SGI_ACL_FILE or SGI_ACL_DEFAULT
(segfault, either Error 4 or Error 5, forgot to bring dmesg)

>> 2) When the ACL count is in a higher range--as low as 250, IIRC--
>> xfs_repair will complain about "Too many ACL entries" and proceed to 
>> remove them.  Below is a full session:
> 
> Yup, never been taught about the expanded ACL count. I didn't even
> realised that repair validated acls directly...
> 
>>
>> root@oldsvrhw:~# mkfs.xfs -f -m crc=1 $SCRATCH_DEV
>> meta-data=/dev/sdb5              isize=512    agcount=4, agsize=786432 blks
>>          =                       sectsz=512   attr=2, projid32bit=1
>>          =                       crc=1        finobt=0
>> data     =                       bsize=4096   blocks=3145728, imaxpct=25
>>          =                       sunit=0      swidth=0 blks
>> naming   =version 2              bsize=4096   ascii-ci=0 ftype=1
>> log      =internal log           bsize=4096   blocks=2560, version=2
>>          =                       sectsz=512   sunit=0 blks, lazy-count=1
>> realtime =none                   extsz=4096   blocks=0, rtextents=0
>>
>> root@oldsvrhw:~# mount $SCRATCH_DEV $SCRATCH_MNT
>>
>> root@oldsvrhw:~# mkdir $SCRATCH_MNT/acl-dir
>>
>> root@oldsvrhw:~# for a in `seq 1000 1325`; do setfacl -d -m u:$a:r-- $SCRATCH_MNT/acl-dir; done
> .....
> 
> Ok, I can reproduce that, and I've fixed it in the patch below.

Maybe not...your E-mail patch doesn't have the git version at the 
bottom, so I wondered whether I installed the entire patch.  What 
I did get went through `git am` just fine, with one whitespace error.

>> 3) When the ACL count is at the max for v5-superblock XFS--at least 
>> with both regular and default ACL slots filled--xfs_repair will 
>> complain of corrupt remote attributes.  AFAIK, xfs_repair doesn't 
>> bother with the "Too many ACL entries" line.  Those ACLs will be 
>> cleansed, too.
> 
> Ok, I see that, too:
> 
>         - agno = 0
> Metadata corruption detected at block 0x190/0x1000
> Corrupt remote block for attributes of inode 67
> 
> Ah, of course - there was an off-by-one in the remote attr max size
> validation that we fixed in the kernel. The kernel code hasn't been
> siynced to userspace yet. Ok, the patch below fixes that as well.

This is most definitely fixed.  Thanks!

> Can you turn this into a new fstest so we
> don't break this accidentally again?

I'm struggling, and it will take a long time, but I'll try.  If you
have a compiled ACL generator somewhere in xfstests, it will save
the time of reading ACL-related man pages.

In the meantime, I developed a fairly coherent script that goes through
a filesystem 4 ACL entries, checking and making filesystems in between.
I started it by making filesystems on a ramdisk and storing the
results on a tmpfs mount, but it uses a normal $SCRATCH_DEV now.
It won't show an error immediately, but all xfs_repair output will
be stored on a tmpfs amount for your perusal.

The script is enclosed, with a debug "step=1" line uncommented so
you can go after the 200-250 ACL-count issue.  Read it first because
you'll want to alter something for your setup.  It's not worthy of
the xfstests harness, but it should be comprehensive enough to let
you run fs_mark in the middle of it if need be.

The smaller the partition you use, the faster the script will go.

> Can you try the patch below? It should fix the problem you are
> seeing.
> 
>> Sorry I missed this one in all of my limits testing.  This was 
>> discovered when I saw a bug in my ACL population script and hit 
>> Ctrl-c so I could stop and edit the script.  Donations of brown paper 
>> bags are welcome...the plastic bags I'm using make it hard to breathe 
>> and don't hide my face very well...
> 
> We've all missed it, so pass the paper bags all around. To prevent
> this from happening again in future, can you wrap this all up in a
> new generic fstest that creates several different numbers of ACLs
> on a file and runs repair on the filesystem after each incremental
> increase in the number of ACLs?
> 
> Thanks for the testing and the bug report, Michael!

No problem.  I'll keep trying!

Michael

#!/bin/bash

# Suggested filename: pop_acl.sh

# ACL coverage script
# Michael L. Semon
# Thu Jun 12 20:38:22 UTC 2014

# This script builds ACL entries, four at a time, and applies them to a new
# directory on a fresh filesystem.  The filesystem is umounted and repaired
# after each creation to look for issues.  A new filesystem is made with
# each pass of the main loop.

# Later, a new filesystem is made, and the new directory is populated to 
# its limit (hopefully).  The filesystem is umounted and repaired again.

# There is a WORK_DIR that holds temporary data, repair results, and the 
# cumulative ACL count.  It is set to mount a tmpfs area for this purpose.
# This behavior can be overridden early in the script.

# There are two sections marked OPTIONAL ACTIVITIES.  In these sections, you 
# can add your own commands.  Should they be executed in a directory with 
# default ACLs, file creation stress in particular should exercise ACL 
# inheritance at the same time.

# This script can be set to use v5-superblock XFS (xfs or v5xfs), regular 
# v4-superblock XFS (x4xfs), JFS (jfs), or F2FS (f2fs).  btrfs 
# can also be used in single mode.  An FSTYP variable is coded with a 
# default of "xfs".  The script can also be executed like this:
#
# env FSTYP=jfs ./pop_acl.sh

# -------- basic globals --------

# This line should be commented out so that xfstests SCRATCH_DEV can be used.
# SCRATCH_DEV=/dev/ram0

if [ -z $SCRATCH_DEV ]; then
	echo 'SCRATCH_DEV is empty.  Exiting.'
	exit
fi

if [ -z $SCRATCH_MNT ]; then
	echo 'SCRATCH_MNT is empty.  Exiting.'
	exit
fi

# Choices are xfs (which means v5), v5xfs, v4xfs, jfs, f2fs, and btrfs.
FSTYP=${FSTYP:=xfs}

# How many entries (times 4) does this script make for each filesystem?
# Default is (measured max - 8 - 4) / 8, integer division in bc.
case $FSTYP in
xfs|v5xfs)
	# Calculated from 10922 (5461+5461)
	step=1363
	;;
v4xfs)
	# Calculated from 50 (25+25)
	step=4
	;;
jfs)
	# Calculated from 16382 (8191+8191)
	step=2046
	;;
f2fs)
	# Calculated from 507 (250+257)
	step=123
	;;
btrfs)
	# Calculated from 978 (489+489) for mixed data/metadata mode on a 
	# small partition.
	# A value of 4050 (2025+2025) was calculated after btrfs auto-set 
	# the big metadata feature on a larger partition.
	step=241
	;;
*)
	step=1
	;;
esac

# Uncomment this to go after corner cases:
step=1

# Base number for calculating uids and gids.
id=1000

# -------- Work Area (section that pertains to tmpfs) ---------

# If you want to store results on a hard disk, override WORK_DIR 
# and comment out the tmpfs mount below.

# work area (tmpfs by default)
WORK_DIR=/tmp/tmpfs
# WORK_DIR=/usr/src

# results dir
RES_DIR=$WORK_DIR/results_dir

# reference acl list
acl_list=$WORK_DIR/acl_list

if [ -e $WORK_DIR ]; then
	umount $WORK_DIR
else
	mkdir $WORK_DIR
fi
mount -t tmpfs tmpfs $WORK_DIR

[ -e $RES_DIR ] || mkdir $RES_DIR

# -------- end of section that pertains to tmpfs ---------

# -------- basic setup --------

# Set up the base entries:
cat << here > $acl_list
user::rwx
group::rwx
other::r-x
mask::rwx
default:user::r-x
default:group::r-x
default:other::--x
default:mask::r-x
here

# Done here in case SCRATCH_DEV is already open.
umount $SCRATCH_DEV

# ======== MAIN LOOP (does most of the work) ========
while true; 
do
	uid=$id
	gid=$((id+6144))
	duid=$((gid+6144))
	dgid=$((duid+6144))

	# Make and mount a new filesystem, and do so early so it's 
	# obviously mounted while the ACL build loop does its work.
	case $FSTYP in
	xfs|v5xfs)
		mkfs.xfs -f -m crc=1 $SCRATCH_DEV > /dev/null 2>&1
		mount -t xfs $SCRATCH_DEV $SCRATCH_MNT
		;;
	v4xfs)
		mkfs.xfs -f $SCRATCH_DEV > /dev/null 2>&1
		mount -t xfs $SCRATCH_DEV $SCRATCH_MNT
		;;
	jfs)
		jfs_mkfs -q $SCRATCH_DEV > /dev/null 2>&1
		mount -t jfs $SCRATCH_DEV $SCRATCH_MNT
		;;
	f2fs)
		mkfs.f2fs $SCRATCH_DEV > /dev/null 2>&1
		mount -t f2fs $SCRATCH_DEV $SCRATCH_MNT
		;;
	btrfs)
		# Only on single for now:
		mkfs.btrfs -f $SCRATCH_DEV > /dev/null 2>&1
		mount -t btrfs $SCRATCH_DEV $SCRATCH_MNT
		;;
	*)
		echo "Filesystem $FSTYP is not supported.  Exiting."
		exit
		;;
	esac
	mkdir $SCRATCH_MNT/acl-dir

	# echo uid, gid, uid for default entries, gid for default entries
	echo "ids: $uid, $gid, $duid, $dgid; iterating by $step"

	cat /dev/null > $RES_DIR/added.acl

	# Make our entries onto the reference directory.
	for inn in `seq 1 $step`; do
cat << here >> $RES_DIR/added.acl
user:$((uid+inn)):r--
group:$((gid+inn)):r--
default:user:$((duid+inn)):r--
default:group:$((dgid+inn)):r--
here
	done

	cp -a $acl_list $WORK_DIR/last_acl_list_accepted
	cat $RES_DIR/added.acl >> $acl_list

	# Copy the ACL from the reference dir into the target filesystem.
	setfacl --set-file=$acl_list $SCRATCH_MNT/acl-dir || break
	getfacl -c $SCRATCH_MNT/acl-dir 2>/dev/null | grep -v "^$" | \
		wc -l | sed -e "s/^/$id: /" \
		>> $RES_DIR/acl.count 2>/dev/null

	# ==================== OPTIONAL ACTIVTIES #1 ===================
	# There is a separate list for later, once a maximum ACL count 
	# has been found.  It might be a good idea to keep this part 
	# light.  Commented out for being optional.
	#
	# fs_mark -L 3 -D 4 -n 100 -s 4096 -d $SCRATCH_MNT/acl-dir
	# touch $SCRATCH_MNT/acl-dir/child
	# mkdir $SCRATCH_MNT/acl-dir/child-dir
	# touch $SCRATCH_MNT/acl-dir/child-dir/grandchild
	# mkdir $SCRATCH_MNT/acl-dir/child-dir/grandchild-dir
	# touch $SCRATCH_MNT/acl-dir/child-dir/great-grandchild
	# ==============================================================

	# umount.  Uncomment the sync line if needed.
	# sync
	umount $SCRATCH_DEV

	# Repair the filesystem.  Make a no-modify pass first, in case 
	# the results are different, beneficial to JFS in particular.
	case $FSTYP in
	xfs|v5xfs|v4xfs)
		xfs_repair -n $SCRATCH_DEV >$RES_DIR/$id.nrepair 2>&1
		xfs_repair $SCRATCH_DEV >$RES_DIR/$id.repair  2>&1
		;;
	jfs)
		jfs_fsck -fnv $SCRATCH_DEV >$RES_DIR/$id.nrepair 2>&1
		jfs_fsck -fyv $SCRATCH_DEV >$RES_DIR/$id.repair  2>&1
		;;
	f2fs)
		# Don't know if/when fsck.f2fs will fix issues, so...
		fsck.f2fs $SCRATCH_DEV >$RES_DIR/$id.repair  2>&1
		ln $RES_DIR/$id.repair $RES_DIR/$id.nrepair  2>&1
		;;
	btrfs)
		btrfsck          $SCRATCH_DEV >$RES_DIR/$id.nrepair 2>&1
		btrfsck --repair $SCRATCH_DEV >$RES_DIR/$id.repair  2>&1
		;;
	*)
		echo "Filesystem $FSTYP is not supported.  Exiting."
		exit
		;;
	esac
	ln -sf $RES_DIR/$id.nrepair $RES_DIR/current.nrepair
	ln -sf $RES_DIR/$id.repair $RES_DIR/current.repair

	id=$((id+$step))
done
umount $SCRATCH_DEV

# ======== SECONDARY SECTION (hopefully fills ACLs out to maximum) ========
# echo uid, gid, uid for default entries, gid for default entries
# echo "ids: $uid, $gid, $duid, $dgid, iterating $step (x4) ids"

# Make and mount a new filesystem.
case $FSTYP in
xfs|v5xfs)
	mkfs.xfs -f -m crc=1 $SCRATCH_DEV > /dev/null 2>&1
	mount -t xfs $SCRATCH_DEV $SCRATCH_MNT
	;;
v4xfs)
	mkfs.xfs -f $SCRATCH_DEV > /dev/null 2>&1
	mount -t xfs $SCRATCH_DEV $SCRATCH_MNT
	;;
jfs)
	jfs_mkfs -q $SCRATCH_DEV > /dev/null 2>&1
	mount -t jfs $SCRATCH_DEV $SCRATCH_MNT
	;;
f2fs)
	mkfs.f2fs $SCRATCH_DEV > /dev/null 2>&1
	mount -t f2fs $SCRATCH_DEV $SCRATCH_MNT
	;;
btrfs)
	# Only on single for now:
	mkfs.btrfs -f $SCRATCH_DEV > /dev/null 2>&1
	mount -t btrfs $SCRATCH_DEV $SCRATCH_MNT
	;;
*)
	echo "Filesystem $FSTYP is not supported.  Exiting."
	exit
	;;
esac
mkdir $SCRATCH_MNT/acl-dir

# Copy the ACL from the reference dir into the target filesystem.
setfacl --set-file=$WORK_DIR/last_acl_list_accepted \
	$SCRATCH_MNT/acl-dir || break

# ---------------------- FILL UP THE ACLs ----------------------
# This section tries to fill the ACL space in a balanced way.

echo "Attempt to find the maximum ACL count..." 

echo "...filling default user and group together..."
while true;
do
	# Increment first here, let the later loops retry it.
	duid=$((duid + 1))
	setfacl -d -m u:$duid:rwx $SCRATCH_MNT/acl-dir || break
	dgid=$((dgid + 1))
	setfacl -d -m g:$dgid:rwx $SCRATCH_MNT/acl-dir || break
done

echo "...filling default user..."
while true;
do
	setfacl -d -m u:$duid:rwx $SCRATCH_MNT/acl-dir || break
	duid=$((duid + 1))
done

echo "...filling default group..."
while true;
do
	setfacl -d -m g:$dgid:rwx $SCRATCH_MNT/acl-dir || break
	dgid=$((dgid + 1))
done

echo "...filling user and group together..."
while true;
do
	# Increment first here, let the later loops retry it.
	uid=$((uid + 1))
	setfacl -m u:$uid:rwx $SCRATCH_MNT/acl-dir || break
	gid=$((gid + 1))
	setfacl -m g:$gid:rwx $SCRATCH_MNT/acl-dir || break
done

echo "...filling user..."
while true;
do
	setfacl -m u:$uid:rwx $SCRATCH_MNT/acl-dir || break
	uid=$((uid + 1))
done

echo "...filling group..."
while true;
do
	setfacl -m g:$gid:rwx $SCRATCH_MNT/acl-dir || break
	gid=$((gid + 1))
done

# It seems that the mask has to be set to eke out that last entry, 
# but try the others, anyway:

echo "...setting the original base entries again..."

setfacl -d -m u::r-x $SCRATCH_MNT/acl-dir
setfacl -m u::rwx $SCRATCH_MNT/acl-dir

setfacl -d -m g::r-x $SCRATCH_MNT/acl-dir
setfacl -m g::rwx $SCRATCH_MNT/acl-dir

setfacl -d -m o::--x $SCRATCH_MNT/acl-dir
setfacl -m o::r-x $SCRATCH_MNT/acl-dir

setfacl -d -m m::rwx $SCRATCH_MNT/acl-dir
setfacl -m m::rwx $SCRATCH_MNT/acl-dir
echo "...done filling the inode with entries."
# --------------------------------------------------------------

getfacl -c $SCRATCH_MNT/acl-dir 2>/dev/null | grep -v "^$" | \
	wc -l | sed -e "s/^/final: /" \
	>> $RES_DIR/acl.count 2>/dev/null

echo "Making max ACL reference file at $WORK_DIR/max_acl_file."
getfacl $SCRATCH_MNT/acl-dir 2>/dev/null > $WORK_DIR/max_acl_file

# ==================== OPTIONAL ACTIVTIES #2 ===================
# This might be were all of the heavy fsstress, fsx, fio, and 
# fs_mark activities could go.  Commented out for being 
# optional.
#
# This section is placed here so the ACL breakdown will be the 
# last output from the script.

# fs_mark -F -D 4 -n 100 -s 4096 -d $SCRATCH_MNT/acl-dir

# touch $SCRATCH_MNT/acl-dir/child
# mkdir $SCRATCH_MNT/acl-dir/child-dir
# touch $SCRATCH_MNT/acl-dir/child-dir/grandchild
# mkdir $SCRATCH_MNT/acl-dir/child-dir/grandchild-dir
# touch $SCRATCH_MNT/acl-dir/child-dir/great-grandchild
# ==============================================================

echo "ACL count (last 3 loop iterations and final pass):"
tail -n 4 $RES_DIR/acl.count | sed -e 's/^/    /'
echo "ACL breakdown (default entries only, should total to maximum default):"
grep "^default" $WORK_DIR/max_acl_file | cut -d ':' -f 1-2 | \
	sort | uniq -c | sort -rg
echo "ACL breakdown (all, should total to maximum):"
grep -v "^#" $WORK_DIR/max_acl_file | grep -v "^$" | cut -d ':' -f 1 | \
	sort | uniq -c | sort -rg

# umount.  Uncomment the sync line if needed.
# sync
umount $SCRATCH_DEV

# Repair the filesystem.  Make a no-modify pass first, in case 
# the results are different, beneficial to JFS in particular.
case $FSTYP in
xfs|v5xfs|v4xfs)
	xfs_repair -n $SCRATCH_DEV >$RES_DIR/$id.nrepair 2>&1
	xfs_repair $SCRATCH_DEV >$RES_DIR/$id.repair  2>&1
	;;
jfs)
	jfs_fsck -fnv $SCRATCH_DEV >$RES_DIR/final.nrepair 2>&1
	jfs_fsck -fyv $SCRATCH_DEV >$RES_DIR/final.repair  2>&1
	;;
f2fs)
	# Don't know if/when fsck.f2fs will fix issues, so...
	fsck.f2fs $SCRATCH_DEV >$RES_DIR/final.repair  2>&1
	ln $RES_DIR/final.repair $RES_DIR/final.nrepair  2>&1
	;;
btrfs)
	btrfsck          $SCRATCH_DEV >$RES_DIR/final.nrepair 2>&1
	btrfsck --repair $SCRATCH_DEV >$RES_DIR/final.repair  2>&1
	;;
*)
	echo "Filesystem $FSTYP is not supported.  Exiting."
	exit
	;;
esac
ln -sf $RES_DIR/final.nrepair $RES_DIR/current.nrepair
ln -sf $RES_DIR/final.repair $RES_DIR/current.repair

# end of script

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
