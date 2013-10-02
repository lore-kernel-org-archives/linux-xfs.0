Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id AF67E29DFC
	for <xfs@oss.sgi.com>; Tue,  1 Oct 2013 22:57:39 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 912668F804C
	for <xfs@oss.sgi.com>; Tue,  1 Oct 2013 20:57:36 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id kzlekHEqx3JV52sc for <xfs@oss.sgi.com>;
	Tue, 01 Oct 2013 20:57:35 -0700 (PDT)
Message-ID: <524B99AD.5000408@sandeen.net>
Date: Tue, 01 Oct 2013 22:57:33 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfsrestore: fix multi stream support
References: <524AF8AE.5030300@sgi.com> <524B34D4.10807@sandeen.net>
	<524B4119.8020005@sgi.com> <524B4677.40200@sgi.com>
In-Reply-To: <524B4677.40200@sgi.com>
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
To: Rich Johnston <rjohnston@sgi.com>
Cc: xfs-oss <xfs@oss.sgi.com>

On 10/1/13 5:02 PM, Rich Johnston wrote:
> OOPS hit send too soon.

I'll fix it up as I go . . . 

> On 10/01/2013 04:39 PM, Rich Johnston wrote:
>>
>>
>> On 10/01/2013 03:47 PM, Eric Sandeen wrote:
>>> Hi Rich -
>>>
>>> On 10/1/13 11:30 AM, Rich Johnston wrote:
>>>> If no extents exist, there is no need to call partial_reg() becausee
>>>> entire file
>>>> there is no data to split up.
>>> thought based on the code alone it was self explainitory
>>> Does that break something, or is this an optimization?
>>
>> The original code is broken, would not detect if the
>> entire file was a hole (no extents) regardless of the value of partialmax.
> 
>> If partialmax != 0
>> (multi-stream) and no extents exist (entire file is a hole), is there
>> anything to restore? Nope so why call parial_reg().  If you do call it
>> you will not find anything to restore:
>>
>>
>> 8977         /* If not found, find a free one, fill it in and return */
>> 8978         if ( ! isptr ) {
>> 8979                 mlog(MLOG_NITTY | MLOG_NOLOCK,
>> 8980                         "partial_reg: no entry found for %llu\n",
>> ino);
>> 8981                 /* find a free one */
>> 8982                 for (i=0; i < partialmax; i++ ) {
>> 8983                         if (persp->a.parrest[i].is_ino == 0) {
>> 8984                                 int j;
>> 8985
>> 8986                                 isptr = &persp->a.parrest[i];
>> 8987                                 isptr->is_ino = ino;
>> 8988                                 persp->a.parrestcnt++;
>> 8989
>> 8990                                 /* Clear all endoffsets (this value is
>> 8991                                  * used to decide if an entry is
>> used or
>> 8992                                  * not
>> 8993                                  */
>> 8994                                 for (j=0, bsptr=isptr->is_bs;
>> 8995                                      j < drivecnt; j++, bsptr++) {
>> 8996                                      bsptr->endoffset = 0;
>> 8997                                 }
>> 8998
>> 8999                                 goto found;
>> 9000                         }
>> 9001                 }
>> 9002
>> 9003                 /* Should never get here. */
>>
>> And we reach the dreaded comment above :)

After that comment above, there's a warning:

                mlog( MLOG_NORMAL | MLOG_WARNING, _(
                  "partial_reg: Out of records. Extend attrs applied early.\n"));

So you saw that?  Is that the bug you're fixing?

But in my tests I don't hit that, even though I can hit this function
with a purely sparse file w/ no extents.

>>>> Also remove the uneeded check in partial_reg() to detect if this is a
>>>> multistream restore.
>>>
>>> Why is it unneeded?
> 
>> The check is unneeded because with my fix,  partial_reg will never be
>> called if partialmax==0 which also means that . Do we really need the extra check?
> Scratch the above :)
> I meant to say the check was needed in the original code because of the bug explained above.
> 
> example:
> create a directory with several files with at least 1 extent
> create a file with no extents (i.e. touch empty_file)

well, no; for an empty file, bs_size == restoredsz so we won't go to partial_reg.
But if you truncate --size=20m you'll see it.  But it works fine today AFAICT.

> Current code will fail for multistream dump/restore and will also
> fail for single stream if the partialmax == 0 check is removed from
> partial_reg().

In my testing it's fine for a large, sparse file w/ multistream.

w/ some printf debugs, I see:

bs_size 20971520 restoredsz 0 /* so we go to partial_reg */
partial_reg: d_index = 3, ino = 137, fsize = 20971520, offset = 0, sz = 0

and it carries along just fine.

Silly to call partial_reg only to return, perhaps, but - no out right bug?

> In my opinion that check was just a workaround for single stream and
> no one tested an empty file with no extents, just file with one
> extent and the entire file is a hole.

well, it's a workaround for the fact that the test to call partial_reg
doesn't account for sparse files at all, I think.  :(

But I'm still not totally clear on what bug you're fixing.

I suppose if you can provide the testcase or the description
of the erroneous end-result, it might be clearer.

p.s. your patches are whitespace-mangled.  ;)

Thanks,
-Eric

here's the hacky sort of test I was doing to trigger the
go-to-partial-reg-with-no-extents code:

#!/bin/bash

# paths to binaries under test
DUMP=/mnt/test2/git/xfsdump/dump/xfsdump
RESTORE=/mnt/test2/git/xfsdump/restore/xfsrestore

# what we'll create files in & dump
DUMPDIR=/mnt/test
# where we'll restore
RESTOREDIR=/mnt/test2/restore

mkdir -p $DUMPDIR/dir
mkdir -p $RESTOREDIR

clean () {
	rm -rf $DUMPDIR/dir/*
	rm -rf $RESTOREDIR/*x
}

clean

xfs_io -f -c "pwrite 4k 4km" $DUMPDIR/dir/8ksparsefront

xfs_io -f -c "pwrite 0 4k" $DUMPDIR/dir/8ksparseend
truncate --size=8k $DUMPDIR/dir/8ksparseend

xfs_io -f -c "pwrite 0 20m" $DUMPDIR/dir/20mfile

xfs_io -f -c "pwrite 20m 20m" $DUMPDIR/dir/40msparsefront

xfs_io -f -c "pwrite 0 20m" $DUMPDIR/dir/40msparseend
truncate --size=40m $DUMPDIR/dir/40msparseend

truncate --size=20m $DUMPDIR/dir/sparsefile

touch $DUMPDIR/dir/emptyfile

rm -f stream1 stream2 stream3 stream4
$DUMP -L session -M label1 -M label2 -M label3 -M label4 -f stream1 -f stream2 -f stream3 -f stream4 $DUMPDIR
$RESTORE -F -f stream1 -f stream2 -f stream3 -f stream4 $RESTOREDIR

ls -1i $DUMPDIR/dir

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
