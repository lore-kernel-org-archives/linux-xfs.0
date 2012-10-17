Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9H3bXln013857 for <xfs@oss.sgi.com>; Tue, 16 Oct 2012 22:37:33 -0500
Message-ID: <507E284D.40800@oracle.com>
Date: Wed, 17 Oct 2012 11:38:53 +0800
From: Jie Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: Re: xfstests: SEEK_HOLE/SEEK_DATA advanced tests
References: <20121016204240.142425319@sgi.com>
	<20121016204244.997819918@sgi.com> <20121017023439.GB26797@dastard>
In-Reply-To: <20121017023439.GB26797@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Mark Tinguely <tinguely@sgi.com>, xfs@oss.sgi.com

On 10/17/12 10:34, Dave Chinner wrote:
> On Tue, Oct 16, 2012 at 03:42:41PM -0500, Mark Tinguely wrote:
>> This is the test of the advanced SEEK_HOLE and SEEK_DATA features
>> of the lseek() function call.
>>
>> Jie Liu <jeff.liu@oracle.com> wrote the C code, I converted it to
>> a test with his permission.
> Jie, can you sign-off on this patch as well as it has Oracle
> copyright statements in it?
Hi Dave,

I can sign-off this patch, but it's better to keep the copyright
statements with SGI for this test script since
it wrote by Mark, and Mark is already made the C test file as Oracle.

Thanks,
-Jeff
>> Signed-off-by: Mark Tinguely <tinguely@sgi.com
> Typo - missing closing ">"
>
>> +
>> +[ -x $here/src/seek_advance_test ] || _notrun "seek_advance_test not built"
>> +
>> +_cleanup()
>> +{
>> +	rm -f $src1 $src2
>> +}
>> +
>> +	echo "Silence is golden..."
>> +	rm -f $src1 $src2
> Rather strange indenting here and for the rest of the test...
>
>> +        write_cmd1="-c \"falloc 512k 256k\" -c \"pwrite 516k 4k\" -c \
>> +		    \"pwrite 800k 4k\""
>> +        write_cmd2="-c \"falloc 512k 256k\" -c \"pwrite 600k 16k\""
> That reminds me of line noise :/
>
>> +
>> +        eval ${XFS_IO_PROG} -F -f "${write_cmd1}" $src1 > $seq.full 2>&1 ||
>> +                _fail "create test1 file failed!"
>> +        echo "*** create test1 file done ***" >>$seq.full
>> +        eval ${XFS_IO_PROG} -F -f "${write_cmd2}" $src2 >>$seq.full 2>&1 ||
>> +                _fail "create test2 file failed!"
>> +        echo "*** create test2 file done ***" >>$seq.full
>
> The way that you're executing xfs_io to create the files is,
> well, convoluted. It doesn't need -F anymore, either. Just run:
>
> $XFS_IO_PROG -f -c "falloc 512k 256k" \
> 		-c "pwrite 516k 4k" \
> 		-c "pwrite 800k 4k" \
> 		$src1 | _filter_xfs_io
>
> And allow the golden output match to detect failures to create the
> file correctly. The filter/golden output test is designed to avoid
> all this "did it work" detection around simple operations.  Indeed,
> seek_advance_test checks the file exists (via the open parameters)
> and errors out with an error message so there is no need to check it
> ahead of time and specifically fail the test.
>
> Further, with the xfs_io output in the golden output, you don't need
> the intermediate "echo <redundant information>" lines to determine
> what failed, either....
>
>> +        echo >>$seq.full
>> +        $here/src/seek_advance_test $dir >> $seq.full || _fail "test failed"
> Pass in the file names, not the directory. That way you only encode
> the filename in one place, not have ot keep the test and .c code in
> step.
>
>> +
>> +status=0
>> +exit
>> +
>> Index: b/288.out
>> ===================================================================
>> --- /dev/null
>> +++ b/288.out
>> @@ -0,0 +1,2 @@
>> +QA output created by 288
>> +Silence is golden...
> Not when you should be using the golden output to detect failures
> instead of convouted code....
>
>> Index: b/group
>> ===================================================================
>> --- a/group
>> +++ b/group
>> @@ -406,3 +406,4 @@ deprecated
>>  285 auto rw
>>  286 other
>>  287 auto dump quota quick
>> +288 other
> Why? it's a test that is quick and should always be run. If you are
> worried about it failing on systems that don't support
> SEEK_HOLE/DATA, then add a _requires_seek_hole function....
>
>> +#include <assert.h>
>> +
>> +#ifndef SEEK_DATA
>> +#define SEEK_DATA	3
>> +#define SEEK_HOLE	4
>> +#endif
>> +
>> +char *base_file_path;
>> +
>> +int
>> +verify(
>> +	off_t offset,
>> +	off_t exp_hoff,
>> +	off_t exp_doff,
>> +	off_t hoff,
>> +	off_t doff)
> I don't really understand what the variables are supposed to mean
> or what is being verified here.
>
>> +{
>> +	fprintf(stdout, "SEEK start %lu expect %ld/%ld got %ld/%ld [%s]\n",
>> +	offset, exp_hoff, exp_doff, hoff, doff,
>> +	(hoff == exp_hoff && doff == exp_doff) ? "PASS" : "FAIL");
>> +
>> +	return(hoff != exp_hoff || doff != exp_doff);
>
> Why are you even determining pass/fail here?
>
> This is what golden output matching is for. Dump some numbers out,
> and if they match the golden output the test passed. If they don't,
> the test fails. We can't filter this output if necessary, nor
> support different block size filesystems, etc. because the
> verification is done within the C code rather than by the filters
> and test harness.
>
> Indeed, if you add SEEK_HOLE/SEEK_DATA to xfs_io to dump the next
> offset of that type given a start offset, then this can all be
> implemented in a single script using filtering golden output
> matching, and can easily be made to support different block sizes.
> This code is just going to be fragile and hard to maintain....
>
> Cheers,
>
> Dave.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
