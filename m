Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id E58F77F8C
	for <xfs@oss.sgi.com>; Thu, 10 Oct 2013 05:20:44 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id A49218F8064
	for <xfs@oss.sgi.com>; Thu, 10 Oct 2013 03:20:44 -0700 (PDT)
Received: from mail-pb0-f52.google.com (mail-pb0-f52.google.com
	[209.85.160.52]) by cuda.sgi.com with ESMTP id rGJaXzOviisTNP8V
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 10 Oct 2013 03:20:43 -0700 (PDT)
Received: by mail-pb0-f52.google.com with SMTP id wz12so2338566pbc.11
	for <xfs@oss.sgi.com>; Thu, 10 Oct 2013 03:20:43 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20131009235828.GR4446@dastard>
References: <1381090446-2897-1-git-send-email-linkinjeon@gmail.com>
	<20131009235828.GR4446@dastard>
Date: Thu, 10 Oct 2013 19:20:43 +0900
Message-ID: <CAKYAXd8DZ1Obk6P+iX8fS7LPCUK7aD4gnDSvz4jCLan-76E4oQ@mail.gmail.com>
Subject: Re: [PATCH RESEND 6/7] xfstest: Add test case to test multiple
	collapse range call
From: Namjae Jeon <linkinjeon@gmail.com>
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
Cc: elder@kernel.org, tytso@mit.edu, Namjae Jeon <namjae.jeon@samsung.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, hch@infradead.org, bpm@sgi.com, adilger.kernel@dilger.ca, viro@zeniv.linux.org.uk, a.sangwan@samsung.com, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, mtk.manpages@gmail.com

>> +. ./common/rc
>> +. ./common/filter
>> +
>> +# real QA test starts here
>> +_supported_fs xfs ext4
>> +_supported_os Linux
>> +
>> +_require_scratch
>> +_require_xfs_io_fiemap
>> +_require_xfs_io_falloc_collapse
>> +_do_die_on_error=y
>> +test=$SCRATCH_MNT/test
>
> Not used.
Okay.

>
>> +testfile=$SCRATCH_MNT/317.$$
>> +BSIZE=4096
>> +BLOCKS=10240
>> +
>> +# Filters fiemap output
>> +_filter_fiemap()
>> +{
>> +     awk --posix '
>> +             $3 ~ /hole/ {
>> +                     print $1, $2, $3;
>> +                     next;
>> +             }
>> +             $5 ~ /0x[[:xdigit:]]+/ {
>> +                     print $1, $2, "extent";
>> +             }'
>> +}
>
> There's already a function in common/punch of this name, and it does
> pretty much the same thing. Why not use that?
Ah, Okay, I will check.

>
>> +
>> +case $FSTYP in
>> +     ext4)
>> +             export MKFS_OPTIONS="-F -b $BSIZE"
>> +             ;;
>> +     xfs)
>> +             export MKFS_OPTIONS="-f -b size=$BSIZE"
>> +             ;;
>> +esac
>
> _scratch_mkfs takes options on the command line - there is no need
> to do this.
Okay.

>
> In fact, this test needs to run on all block sizes that filesystems
> are capable of using, not just 4k and different architectures
> exercise different code paths and so we must be able to test the
> case where block size is smaller than page size on x86-64 so when
> the code is run on an ia64 or ppc64 box with a 64k page size we know
> that it's not completely broken...
Okay, I will update to test block size is smaller than page size.

>
> Anyway, if you really need to make a 4k block size filesystem, then
> _scratch_mkfs_sized() is the generic way of doing this.
>
>> +# make filesystem on scratch with 4KB blocksize
>> +_do 'make filesystem on $SCRATCH_DEV' '_scratch_mkfs'
>> +_do 'mount filesytem' '_scratch_mount'
>
> I really dislike this "_do" wrapper. The text does not add anything
> to the test, and it makes it hard to see the command being run and
> harder to modify it when necessary. It is used only by a couple of
> old tests, and we'd do better to remove it than to propagate it
> further.  This:
>
> _scratch_mkfs >> $seqres.full 2>&1 || _fail "scratch_mkfs failed."
> _scratch_mount >> $seqres.full 2>&1 || _fail "scratch_mount failed."
>
> does everything that the _do wrapper does.
Okay.

>
>> +
>> +# Write file
>> +length=$(($BLOCKS*$BSIZE))
>> +$XFS_IO_PROG -f -c "pwrite 0 $length" -c fsync $testfile > /dev/null
>> +
>> +# Collapse alternate blocks
>> +for (( i = 1; i <= 7; i++ )); do
>> +     for(( j=0 ; j < $(($BLOCKS/(2**$i))) ; j++ )); do
>> +             offset=$(($j*$BSIZE))
>> +             $XFS_IO_PROG -c "fcollapse $offset $BSIZE" $testfile > /dev/null
>> +     done
>> +done
>> +
>> +# Check if 80 extents are present
>> +$XFS_IO_PROG -c "fiemap -v" $testfile | _filter_fiemap
>
> If all you care about is that there are 80 extents, then why not
> just something like:
>
> $XFS_IO_PROG -c "fiemap -v" $testfile |grep "^ *[0-9]*:" |wc -l
Okay, I will check.

>
>> +
>> +_do 'unmount $SCRATCH_DEV' 'umount $SCRATCH_DEV'
>> +_do 'repair filesystem' '_check_scratch_fs'
>
> _check_scratch_fs is all you need to call here.
Yes, right. I will update.

>
>> index 3a69294..80ff7ec 100644
>> --- a/tests/shared/group
>> +++ b/tests/shared/group
>> @@ -12,3 +12,4 @@
>>  298 auto trim
>>  305 aio dangerous enospc rw stress
>>  316 auto quick collapse
>> +317 auto collapse
>
> Again, I think the prealloc group is better for this.
Okay, I will add collpase range cases to prealloc group.

Thanks for review.
I will post patches included your all review points soon.
>
> Cheers,
>
> Dave.
> --
> Dave Chinner
> david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
