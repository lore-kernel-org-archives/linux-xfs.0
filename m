Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6F16qCd178233 for <xfs@oss.sgi.com>; Thu, 14 Jul 2011 20:06:52 -0500
Received: from e6.ny.us.ibm.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 426A511EEE0E
	for <xfs@oss.sgi.com>; Thu, 14 Jul 2011 18:06:51 -0700 (PDT)
Received: from e6.ny.us.ibm.com (e6.ny.us.ibm.com [32.97.182.146]) by
	cuda.sgi.com with ESMTP id 19TG7JuBgf9rRtSe for
	<xfs@oss.sgi.com>; Thu, 14 Jul 2011 18:06:51 -0700 (PDT)
Received: from d01relay05.pok.ibm.com (d01relay05.pok.ibm.com [9.56.227.237])
	by e6.ny.us.ibm.com (8.14.4/8.13.1) with ESMTP id p6F0ggWX001665
	for <xfs@oss.sgi.com>; Thu, 14 Jul 2011 20:42:42 -0400
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by d01relay05.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	p6F16nCi161950 for <xfs@oss.sgi.com>; Thu, 14 Jul 2011 21:06:49 -0400
Received: from d01av03.pok.ibm.com (loopback [127.0.0.1])
	by d01av03.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id
	p6EL6bXm020036 for <xfs@oss.sgi.com>; Thu, 14 Jul 2011 18:06:37 -0300
Message-ID: <4E1F92A7.3030209@linux.vnet.ibm.com>
Date: Thu, 14 Jul 2011 18:06:47 -0700
From: Allison Henderson <achender@linux.vnet.ibm.com>
MIME-Version: 1.0
Subject: Re: [PATCH 2/2 v7] XFS TESTS: Add ENOSPC Hole Punch Test
References: <1309272301-5742-1-git-send-email-achender@linux.vnet.ibm.com>
	<1309272301-5742-3-git-send-email-achender@linux.vnet.ibm.com>
	<1310667725.2067.43.camel@doink>
In-Reply-To: <1310667725.2067.43.camel@doink>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: aelder@sgi.com
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, xfs@oss.sgi.com

On 07/14/2011 11:22 AM, Alex Elder wrote:
> On Tue, 2011-06-28 at 07:45 -0700, Allison Henderson wrote:
>> This patch adds a new test 255 that tests that a hole can be punched even when the
>> disk is full.  Reserved blocks should be used to allow a punch hole to proceed even
>> when there is not enough blocks to further fragment the file. To test this, the
>> file system is fragmented by punching holes in regular intervals and filling
>> the file system between punches. This will eventually force the file system to use
>> reserved blocks to proceed with the punch hole operation.
>>
>> The work in this patch is a continuation from a previous patch set that has been
>> partially accepted.
>>
>> Signed-off-by: Allison Henderson<achender@linux.vnet.ibm.com>
> 
Hi Alex,

Thx for the review! :)  Comments below:  


> First of all, I renumbered the test 256 (and will do
> that for you if necessary before committing the change).
> 
> Second, I can confirm that this new test passes for
> XFS on my setup.  I don't know what the threshold for
> inclusion in the "quick" group is, but it's under a
> minute so that's fine with me.

As I recall it was pretty quick on xfs, but over a minute
for ext4, so I will pull off the quick tag.

> 
> Third, maybe we can create a new group "punch" or
> something like that to tag tests that exercise
> hole punching functionality (tests 252, 255, and
> now this one at least; maybe 175 and 176 too).
> 
I think that's a good idea, I will add that in the 
next version.

> Finally, I found a bug and a few other spots that
> really ought to be fixed but aren't really serious
> problems.  I also have a number of other things that
> I commented on, but tried to make it clear where
> they're just remarks to consider, not requests to
> make a change.

Ah, thank you for the careful eye, I will get those
fixed up.  

> 
> 					-Alex
> 
>> ---
>> v5->v6
>>
>> Test moved out of 252 and put in its own test 255
>>
>> _fill_fs and _test_full_fs_punch have been moved from common.punch
>> to test 255 and modified to use the _user_do routines in common.rc
>>
>> _fill_fs has been optimized to stop once files smaller than a block
>> cannot be created.
>>
>> v6->v7
>> Fixed bad file add
>>
>>
>> :000000 100644 0000000... 3d39fdb... A	255
>> :000000 100644 0000000... 3525403... A	255.out
>> :100644 100644 1f86075... c045e70... M	group
>>   255     |  178 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>>   255.out |    1 +
>>   group   |    1 +
>>   3 files changed, 180 insertions(+), 0 deletions(-)
>>
>> diff --git a/255 b/255
>> new file mode 100644
>> index 0000000..3d39fdb
>> --- /dev/null
>> +++ b/255
>> @@ -0,0 +1,178 @@
>> +#! /bin/bash
>> +# FS QA Test No. 255
>> +#
>> +# Test Full File System Hole Punching
>> +#
>> +#-----------------------------------------------------------------------
>> +# Copyright (c) 2011 IBM Corporation.  All Rights Reserved.
>> +#
>> +# This program is free software; you can redistribute it and/or
>> +# modify it under the terms of the GNU General Public License as
>> +# published by the Free Software Foundation.
>> +#
>> +# This program is distributed in the hope that it would be useful,
>> +# but WITHOUT ANY WARRANTY; without even the implied warranty of
>> +# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>> +# GNU General Public License for more details.
>> +#
>> +# You should have received a copy of the GNU General Public License
>> +# along with this program; if not, write the Free Software Foundation,
>> +# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
>> +#
>> +#-----------------------------------------------------------------------
>> +#
>> +# creator
>> +owner=achender@linux.vnet.ibm.com
>> +
>> +seq=`basename $0`
>> +echo "QA output created by $seq"
>> +
>> +here=`pwd`
>> +tmp=/tmp/$$
>> +status=1	# failure is the default!
>> +
>> +_cleanup()
>> +{
>> +    rm -f $tmp.*
>> +}
>> +
>> +trap "_cleanup ; exit \$status" 0 1 2 3 15
>> +
>> +# get standard environment, filters and checks
>> +. ./common.rc
>> +. ./common.filter
>> +. ./common.punch
>> +
>> +# real QA test starts here
>> +_supported_fs generic
>> +_supported_os Linux
>> +
>> +_require_xfs_io_falloc_punch
>> +_require_scratch
>> +_require_user
>> +
>> +testfile=$TEST_DIR/255.$$
>     testfile=$TEST_DIR/$seq.$$
> 
>> +
>> +
> 
> The _fill_fs function seems like it may be useful elsewhere,
> so it may end up in common.rc eventually.  (Easy enough to
> move it there later though.)
> 
In an earlier version of the patch, this function and _test_full_fs_punch() 
were in common.punch, but we moved it here since non of the other punch hole
tests were using it. If you think other tests could make use of it though,
I think it's a good idea to put it in common.rc. That way people wont have
to worry about moving it, or wonder if something went wrong in the move.

>> +# _fill_fs()
>> +#
>> +# Fills a file system by repeatedly creating files in the given folder
>> +# starting with the given file size.  Files are reduced in size when
>> +# they can no longer fit untill no more files can be created.
>> +#
>> +# This routine is used by _test_full_fs_punch to test that a hole may
>> +# still be punched when the disk is full by borrowing reserved blocks.
>> +# All files are created as a non root user to prevent reserved blocks
>> +# from being consumed.
>> +#
>> +_fill_fs() {
>> +	local file_size=$1
>> +	local dir=$2
>> +	local block_size=$3
>> +	local file_count=1
>> +	local bytes_written=0
>> +
>> +	if [ $# -ne 3 ]
>> +	then
>> +		echo "USAGE: _fill_fs filesize dir block size"
>> +		exit 1
>> +	fi
>> +
>> +	# Creation of files or folders
>> +	# must not be done as root or
>> +	# reserved blocks will be consumed
>> +	_user_do "mkdir -p $dir&>  /dev/null"
> 
> I personally prefer seeing ">  /dev/null 2>&1" rather
> than "&>  /dev/null", to make it that much more
> explicit that both are being redirected.  This is
> purely a style thing, and I say this mainly to see
> if anyone else has a preference one way or another.
> (This appears several times in the file, so if you
> do choose to change it, do so throughout.)
> 
Alrighty, I personally am not partial to one way over the
other, but if it helps make the code easier for people to 
look at, I am happy to put it in :)

>> +	if [ $? -ne 0 ] ; then
>> +		return 0
>> +	fi
>> +
>> +	if [ $file_size -lt $block_size ]
>> +	then
>> +		$file_size = $block_size
>                    file_size=$block_size
> 
> (This one is a bug.)

Got it :) I think the rest of what you have below are good modifications
to put in.  I will start working on an update.  Thx again for the review!

Allison Henderson

> 
>> +	fi
>> +
>> +	while [ $file_size -ge $block_size ]
>> +	do
>> +		bytes_written=0
>> +		_user_do "$XFS_IO_PROG -F -f -c \"pwrite 0 $file_size\" $dir/$file_count.bin&>  /dev/null"
>> +
> 
> Try to split these long lines, e.g.:
> 		_user_do "$XFS_IO_PROG -F -f -c \
> 				\"pwrite 0 $file_size\" \
> 				$dir/$file_count.bin&>  /dev/null"
> 
>> +		if [ -f $dir/$file_count.bin ]
>> +		then
>> +			bytes_written=`$XFS_IO_PROG -F -c "stat"  $dir/$file_count.bin | grep size | cut -d ' ' -f3`
> 
> Personal preference again, but as long as we're using bash
> and not sh, Use $(...) rather than `...` for sub-commands.
> 
>> +		fi
>> +
>> +		# If there was no room to make the file,
>> +		# then divide it in half, and keep going
>> +		if [ $bytes_written -lt $file_size ]
>> +		then
>> +			file_size=$(( $file_size / 2 ))
>> +		fi	
>> +		file_count=$(( $file_count + 1 ))
>> +
>> +	done
>> +}
>> +
>> +# _test_full_fs_punch()
>> +#
>> +# This function will test that a hole may be punched
>> +# even when the file system is full.  Reserved blocks
>> +# should be used to allow a punch hole to proceed even
>> +# when there is not enough blocks to further fragment the
>> +# file. To test this, this function will fragment the file
>> +# system by punching holes in regular intervals and filling
>> +# the file system between punches.
>> +#
>> +_test_full_fs_punch()
>> +{
>> +	local hole_len=$1      # The length of the holes to punch
>> +	local hole_interval=$2 # The interval between the holes
>> +	local iterations=$3    # The number of holes to punch
>> +	local file_name=$4     # File to punch holes in
>> +	local block_size=$5    # File system block size
>> +	local file_len=$(( $(( $hole_len + $hole_interval )) * $iterations ))
>> +	local path=`dirname $file_name`
>> +	local hole_offset=0
>> +
>> +	if [ $# -ne 5 ]
>> +	then
>> +		echo "USAGE: _test_full_fs_punch hole_len hole_interval iterations file_name block_size"
>> +		exit 1
>> +	fi
>> +
>> +	rm -f $file_name&>  /dev/null
>> +
>> +	$XFS_IO_PROG -F -f -c "pwrite 0 $file_len" \
>> +		-c "fsync" $file_name&>  /dev/null
>> +	chmod 666 $file_name
>> +
>> +	_fill_fs $(( 1024 * 1024 * 1024 )) $path/fill $block_size
> 
> You are specifying a file size that's equal to the filesystem
> size, which I think is guaranteed to fail its first pass.  Maybe
> start with half of the filesystem (or even 90% of it).  (I
> don't know whether this is a a real issue or not though.)
> 
> Also, you could maybe use a shell variable to represent the
> filesystem size, since you use it twice in this script.
> 
>> +
>> +	for (( i=0; i<$iterations; i++ ))
>> +	do
>> +		# This part must not be done as root in order to
>> +		# test that reserved blocks are used when needed
>> +		_user_do "$XFS_IO_PROG -F -f -c \"fpunch $hole_offset $hole_len\" $file_name"
>> +		rc=$?
>> +		if [ $? -ne 0 ] ; then
>> +			echo Punch hole failed
>> +			break
>> +		fi
>> +
>> +		hole_offset=$(( $hole_offset + $hole_len + $hole_interval ))
>> +
>> +		_fill_fs $hole_len $path/fill.$i $block_size
>> +
>> +	done
>> +}
>> +
>> +# Make a small file system to fillkk
>> +umount $SCRATCH_DEV&>  /dev/null
>> +_scratch_mkfs_sized $(( 1024 * 1024 * 1024 ))&>  /dev/null
>> +_scratch_mount
>> +# Test must be able to write files with non-root permissions
>> +chmod 777 $SCRATCH_MNT
>> +
>> +block_size=`stat -f $SCRATCH_DEV | grep "Block size" | cut -d " " -f3`
>> +_test_full_fs_punch $(( $block_size * 2 )) $block_size 500 $SCRATCH_MNT/252.$$ $block_size
>                                             Use     $SCRATCH_MNT/$seq.$$
> 
> ...and possibly define this path in a variable
> at the top of the file.
> 
>> +
>> +status=0 ; exit
>> diff --git a/255.out b/255.out
>> new file mode 100644
>> index 0000000..3525403
>> --- /dev/null
>> +++ b/255.out
>> @@ -0,0 +1 @@
>> +QA output created by 255
>> diff --git a/group b/group
>> index 1f86075..c045e70 100644
>> --- a/group
>> +++ b/group
>> @@ -368,3 +368,4 @@ deprecated
>>   252 auto quick prealloc
>>   253 auto quick
>>   254 auto quick
>> +255 auto quick
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
