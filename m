Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-it0-f67.google.com ([209.85.214.67]:32869 "EHLO
        mail-it0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934128AbdC3Sph (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 30 Mar 2017 14:45:37 -0400
MIME-Version: 1.0
In-Reply-To: <CAOQ4uxiEzYvbAOdsJLOMKESUEVJuC57PPbYHvo-HtDZEiihb3A@mail.gmail.com>
References: <15267.1490891560@warthog.procyon.org.uk> <CAOQ4uxiEzYvbAOdsJLOMKESUEVJuC57PPbYHvo-HtDZEiihb3A@mail.gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Thu, 30 Mar 2017 21:45:35 +0300
Message-ID: <CAOQ4uxj6eOQ+XukToULq3-y3gv18qMW+dphXBqqZYyiVgeqxwA@mail.gmail.com>
Subject: Re: [PATCH] xfstests: Add first statx test
Content-Type: text/plain; charset=UTF-8
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: David Howells <dhowells@redhat.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>, Andreas Dilger <adilger@dilger.ca>, Christoph Hellwig <hch@infradead.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Eric Sandeen <sandeen@sandeen.net>, fstests <fstests@vger.kernel.org>

On Thu, Mar 30, 2017 at 9:36 PM, Amir Goldstein <amir73il@gmail.com> wrote:
> [ + cc: fstests ]
>
> On Thu, Mar 30, 2017 at 7:32 PM, David Howells <dhowells@redhat.com> wrote:
>> Add a statx test that does the following:
>>
>>  (1) Creates one each of the various types of file object and creates a
>>      hard link to the regular file.
>>
>>      Note that the creation of an AF_UNIX socket is done with netcat in a
>>      bash coprocessing thread.  This might be best done with another
>>      in-house helper to avoid a dependency on nc.
>>
>>  (2) Notes the clock time before creating the file.
>>
>>  (3) Invokes the C test program included in this patch after the creation,
>>      handing it the clock time from (2) and providing a selection of
>>      invariants to check.
>>
>> The patch also creates a C[*] test program to do the actual stat checking.
>> The test program then does the following:
>>
>>  (1) Compares the output of statx() to that of fstatat().
>>
>>  (2) Optionally compares the timestamps to see that they're sensibly
>>      ordered with respect to the saved clock time[**] and each other.
>>
>
> I suggest that instead of comparing to absolute timestamp value
> compare to a timestamp of the cmp file.
> This will also solve you the problem of gettimeofday() vs. kernel_time
> and will also open up the possibility of adding more interesting tests
> later on (e.g. make sure that mtime of file A >= atime of file B).
>
>>  (3) Optionally compares selected stats to values specified on the command
>>      line.
>>
>>  (4) Optionally compares the stats to those of another file, requiring them
>>      to be the same (hard link checking).
>>
>> For example:
>>
>>         ./src/stat_test /dev/null \
>>                0.0 \
>>                stx_type=char \
>>                stx_rdev_major=3 \
>>                stx_rdev_minor=8 \
>>                stx_nlink=1
>>
>>
>> [*] Note that it proved much easier to do this in C than trying to do it in
>>     shell script and trying parsing the output of xfs_io.  Using xfs_io has
>>     other pitfalls also: it wants to *open* the file, even if the file is
>>     not an appropriate type for this or does not grant permission to do so.
>>     I can get around this by opening O_PATH, but then xfs_io fails to
>>     handle XFS files because it wants to issue ioctls on every fd it opens.
>>
>
> IMO, you reached the correct solution :)
> Minor nits below.
>
>> [**] It turns out they may be *before* the clock time.  This would seem to
>>      indicate a bug in the kernel's time-tracking system.
>>
>> Signed-off-by: David Howells <dhowells@redhat.com>
>> ---
>
> [...]
>
>> +
>> +static __attribute__((noreturn))
>> +void format(void)
>> +{
>> +       fprintf(stderr, "usage: %s [-v] [-m<mask>] <testfile> <origintime> [checks]\n",
>> +               prog);
>> +       fprintf(stderr, "\t<mask> can be basic, all or a number; all is the default\n");
>> +       fprintf(stderr, "checks is a list of zero or more of:\n");
>> +       fprintf(stderr, "\tts-order -- check the timestamp order after init\n");
>> +       fprintf(stderr, "\tts=<a>,<b> -- timestamp a <= b, where a and b are one of 'Oabcm'\n");
>
> How about ABCMabcm,
> where ABCM are timestamps of cmp file
>
>> +       fprintf(stderr, "\tcmp=<file> -- check that the specified file has identical stats\n");
>> +       fprintf(stderr, "\tstx_<field>=<val> -- statx field value check\n");

And maybe use the flag "stx_<field>" (without =<val>) to indicate
'compare statx field
with that of the cmp file'.
So instead of having an all on nothing 'check that the specified file
has identical stats'
tests could be more specific than that.
And maybe a '-a' flag for 'compare all stats'.

>> +       fprintf(stderr, "\t\t(for stx_type, fifo char dir, block, file, sym, sock can be used)\n");
>> +       exit(2);
>> +}
>> +
>
> [...]
>
>> +
>> +if [ $failed = 1 ]
>> +then
>> +    echo "Test script failed"
>
> That's not really needed
>
>> +    exit
>> +fi
>> +
>> +echo "Success"
>
> And neither is this.
>
>> +
>> +# optional stuff if your test has verbose output to help resolve problems
>> +#echo
>> +#echo "If failure, check $seqres.full (this) and $seqres.full.ok (reference)"
>> +
>> +# success, all done
>> +status=0
>
> status=fail will do the trick.
>
>> +exit
>> diff --git a/tests/generic/420.out b/tests/generic/420.out
>> new file mode 100644
>> index 0000000..e2956a6
>> --- /dev/null
>> +++ b/tests/generic/420.out
>> @@ -0,0 +1,12 @@
>> +QA output created by 420
>> +Test statx on a fifo
>> +Test statx on a chardev
>> +Test statx on a directory
>> +Test statx on a blockdev
>> +Test statx on a file
>> +20+0 records in
>> +20+0 records out
>> +Test statx on a symlink
>> +Test statx on an AF_UNIX socket
>> +Test a hard link to a file
>> +Success
>> diff --git a/tests/generic/group b/tests/generic/group
>> index 0781f35..c420998 100644
>> --- a/tests/generic/group
>> +++ b/tests/generic/group
>> @@ -422,3 +422,4 @@
>>  417 auto quick shutdown log
>>  418 auto rw
>>  419 auto quick encrypt
>> +420 other
>
> Since your test takes a few seconds, you should add it to auto, quick groups
> I don't know what this 'other' group is about.
>
> Amir.
