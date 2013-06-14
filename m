Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 906537F37
	for <xfs@oss.sgi.com>; Fri, 14 Jun 2013 08:23:31 -0500 (CDT)
Message-ID: <51BB1954.5060801@sgi.com>
Date: Fri, 14 Jun 2013 08:23:32 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstest: ensure small symlink is removed
References: <20130613151007.449190598@sgi.com>
	<20130613151037.271434256@sgi.com> <20130614021107.GQ29338@dastard>
In-Reply-To: <20130614021107.GQ29338@dastard>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On 06/13/13 21:11, Dave Chinner wrote:
> On Thu, Jun 13, 2013 at 10:10:08AM -0500, Mark Tinguely wrote:
>> Tests that XFS symlinks that are small enough to be in the
>> inode, but were move to a remote symlink due to an extended
>> attribute were correctly removed.
>>
>> Signed-off-by: Mark Tinguely<tinguely@sgi.com>
>> ---
>>   new/xfstests/tests/xfs/298     |   92 +++++++++++++++++++++++++++++++++++++++++
>>   new/xfstests/tests/xfs/298.out |   33 ++++++++++++++
>>   new/xfstests/tests/xfs/group   |    1
>
> I don't see anything that really needs to be XFS specific about this
> test - can you make it generic?
>
>> +SYMLINK=""
>> +SYMLINK_ADD="0123456789ABCDEF01234567890ABCDEF"
>> +
>> +# test 32 to 512 byte symlink. This should make sure that 256 and
>> +# 512 byte inodes version 2 and 3 are covered.
>
> Better to test all the way to MAXPATHLEN, rather than just an
> arbitrary sub-range of the possible symlink ranges.

Nod. I was not covering the 1K inode.
>
>> +LOOP=16
>> +SIZE=32
>> +while [ $LOOP -gt 0 ];do
>
> while [ $SIZE -le 512 ]; do

and eliminate one variable!

>
>> +	_scratch_mount>/dev/null 2>&1
>> +	cd $SCRATCH_MNT
>> +	echo "Testing symlink size $SIZE"
>> +	SYMLINK="${SYMLINK}${SYMLINK_ADD}"
>> +	ln -s $SYMLINK $SYMLINK_FILE>  /dev/null 2>&1
>> +
>> +	inode=`ls -li $SYMLINK_FILE | awk '{print $1}'`
>> +# add the extended attributes
>> +	attr  -Rs 1234567890ab $SYMLINK_FILE<  /dev/null>  /dev/null 2>&1
>> +	attr  -Rs 1234567890ac $SYMLINK_FILE<  /dev/null>  /dev/null 2>&1
>> +	attr  -Rs 1234567890ad $SYMLINK_FILE<  /dev/null>  /dev/null 2>&1
>> +# remove the extended attributes
>> +	attr  -Rr 1234567890ab $SYMLINK_FILE>  /dev/null 2>&1
>> +	attr  -Rr 1234567890ac $SYMLINK_FILE>  /dev/null 2>&1
>> +	attr  -Rr 1234567890ad $SYMLINK_FILE>  /dev/null 2>&1
>> +# remove the symlink - make sure ifree removes the remote symlink.
>> +	rm $SYMLINK_FILE
>> +# umount and check the number of extents on the inode. Should be 0.
>> +	cd
>> +	_scratch_unmount>/dev/null 2>&1
>> +	$XFS_DB_PROG  -c "inode $inode" -c "p core.nextents" $SCRATCH_DEV
>
> I'm not sure that's actually a valid thing to do - the inode has
> been removed, so the underlying inode chunk may have been removed
> and hence marked stale rather than been written back. Hence you
> cannot rely on xfs_db being able to print the extent count after the
> inode has been unlinked and the filesystem unmounted.
>
> As it is, it's not really necessary for the test to detect the
> problem that you found, right? i.e. that the kernel would assert
> fail? If you drop the xfs_db stuff here, then the test is generic...

It will ASSERT on a debug kernel, but put this test so it would still 
fail in the debug case.

>
>> --- a/new/xfstests/tests/xfs/group
>> +++ b/new/xfstests/tests/xfs/group
>> @@ -177,3 +177,4 @@
>>   295 auto logprint quick
>>   296 dump auto quick
>>   297 auto freeze
>> +298 auto attr symlink
>
> + quick.

Okay, I had it in but removed it at the last minute.

>
> Cheers,
>
> Dave.

Thanks.

--Mark.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
