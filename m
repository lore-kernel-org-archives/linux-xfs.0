Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 578AE7F37
	for <xfs@oss.sgi.com>; Mon,  7 Oct 2013 15:54:40 -0500 (CDT)
Message-ID: <52531F8F.2030204@sgi.com>
Date: Mon, 7 Oct 2013 15:54:39 -0500
From: Rich Johnston <rjohnston@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstests XFS: verify extended attributes after
	multi-stream xfsdump/xfsrestore
References: <524AF8AE.5030300@sgi.com> <20131007193912.256265551@sgi.com>
	<52531A72.1060902@sandeen.net>
In-Reply-To: <52531A72.1060902@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com



On 10/07/2013 03:32 PM, Eric Sandeen wrote:
> On 10/7/13 2:38 PM, rjohnston@sgi.com wrote:
>> Verify extended attributes are not lost after multi-stream
>> xfsdump/xfsrestore of wholly-sparse files.  xfsrestore did not
>> recognize that if the LAST header was reached with no restoredsz set,
>> (i.e the LAST header is the only header), the following warning is
>> displayed:
>>
>>    "partial_reg: Out of records. Extend attrs applied early."
>>
>> and the extended attributes on the current and following restored
>> files are lost.
>
> and restore segfaults too, IIRC.  ;)

For test 2 yes you are correct, does not segfault for test 1.

>
> So I'm trying to understand - are attrs not applied because xfs_restore
> terminates, or is everything fine other than the attrs missing when
> it completes successfully?

Everything fine other than the attrs missing when it completes 
successfully, which is how this bug was originally reported to me.
In DMF land this meant OFFLINE files were restored as NON-MIGRATABLE 
(iow Extended attributes removed )

>
> iows, I get this when it fails:
>
>   QA output created by 350
>   Silence is golden.
> +ATTR for /mnt/scratch/restore/dumpsrc/sparse0  DOES NOT match

This is from the first test, and I purposely just echo the error so I 
hit the second case too.
>
> and never get to the point of seeing if attrs are missing.

Forgot I changed the echo "restore failed" to _fail "restore failed".
That's why you don't see the attrs are missing.

>
> Anyway, a few other things below for the record...
>
>> Signed-off-by: Rich Johnston <rjohnston@sgi.com>
>>
>> ---
>>   tests/xfs/350     |  134 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
>>   tests/xfs/350.out |    2
>>   tests/xfs/group   |    1
>>   3 files changed, 137 insertions(+)
>>
>> Index: b/tests/xfs/350
>> ===================================================================
>> --- /dev/null
>> +++ b/tests/xfs/350
>> @@ -0,0 +1,134 @@
>> +#! /bin/bash
>> +# FS QA Test No. 350
>
> Big jump!

Taken care of at commit time. ;) Big jump as to not interfere with other 
peoples development.

>
>> +#
>> +# Verify extended attributes are not lost after multi-stream
>> +# xfsdump/xfsrestore of wholly-sparse files.
>> +
>> +#-----------------------------------------------------------------------
>> +# Copyright (c) 2013 SGI.  All Rights Reserved.
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
>> +
>> +seq=`basename $0`
>> +seqres=$RESULT_DIR/$seq
>> +echo "QA output created by $seq"
>> +
>> +here=`pwd`
>> +tmp=/tmp/$$
>> +status=0	# success is the default!
>> +trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
>> +
>> +# get standard environment, filters and checks
>> +. ./common/rc
>> +. ./common/filter
>> +. ./common/dump
>> +
>> +# real QA test starts here
>> +_supported_fs xfs
>> +_supported_os Linux
>> +
>> +_require_multi_stream
>

Dooh good catch.

> _require_scratch
> _scratch_mkfs
> _scratch_mount
>
>> +
>> +# dir where we'll restore
>> +RESTOREDIR=$SCRATCH_MNT/restore
>
> so you need _require_scratch & _scratch_mkfs before this...

Gottcha

>
>> +
>> +# subdir used for dump/restore
>> +DUMPDIR=dumpsrc
>> +
>> +# test extended attributes
>> +attr_name=testattr
>> +attr_value=1234
>> +
>> +# setup for test
>> +rm -rf $seqres.full
>
> no need to recursively remove a file, but *shrug* :)

Yup typo.

>
>> +mkdir -p $RESTOREDIR
>> +mkdir -p $SCRATCH_MNT/$DUMPDIR
>> +
>> +# cleanup for next dump/restore.
>> +_clean_dirs()
>> +{
>> +	rm -rf $SCRATCH_MNT/$DUMPDIR/*
>> +	rm -rf $RESTOREDIR/*
>> +	rm -f $tmp.stream?
>> +}
>> +
>> +# set the extended attributes on the test files.
>> +_set_attrs()
>> +{
>> +	for fname in $(ls -dD $SCRATCH_MNT/$DUMPDIR/*); do
>> +		attr -Rs $attr_name -V $attr_value $fname \
>> +		2>&1 >> $seqres.full || _fail "could not set ATTR for $fname"
>> +	done
>
> Just out of curiosity, is the root (-R) namespace relevant to the problem?

Don't think so I can remove th -R.>

>> +}
>> +
>> +# perform a dump and restore.
>> +_do_dump_restore()
>> +{
>> +	$XFSDUMP_PROG -L session -M label1 -M label2 -f $tmp.stream1 \
>> +		-f $tmp.stream2 $SCRATCH_MNT -s $DUMPDIR \
>> +		2>&1 >> $seqres.full || _fail "dump failed"
>> +	$XFSRESTORE_PROG -F -f $tmp.stream1 -f $tmp.stream2 $RESTOREDIR \
>> +		2>&1 >> $seqres.full || _fail "restore failed"
>> +}
>> +
>> +# verify the restored files extended attributes and
>> +# echo the error (if any) so the test will continue
>> +_verify_attrs()
>> +{
>> +	for fname in $(ls -dD $RESTOREDIR/$DUMPDIR/*); do
>> +		attr -Rg $attr_name $fname 2>&1 | tee -a $seqres.full | \
>> +			grep $attr_value 2>&1 >> $seqres.full || \
>> +			echo "ATTR for $fname  DOES NOT match"
>> +	done
>> +}
>> +
>> +# create files for test 1, a large file so the sparse file
>> +# is in the next stream.
>> +_create_test1_files()
>> +{
>> +
>> +	dd if=/dev/zero of=$SCRATCH_MNT/$DUMPDIR/10MB bs=1MB \
>> +		count=10 2>&1 >> $seqres.full | _filter_dd
>> +	truncate --size=1t $SCRATCH_MNT/$DUMPDIR/sparse0 2>&1 \
>> +		>> $seqres.full
>> +}
>> +
>> +# create 4 sparse files for test 2
>> +_create_test2_files()
>> +{
>> +	for i in `seq 1 4`; do
>> +		truncate --size=1t $SCRATCH_MNT/$DUMPDIR/sparse$i 2>&1 >> \
>> +		$seqres.full || _fail "failed to create sparse \"$i\""
>> +	done
>> +}
>> +echo "Silence is golden."
>> +echo "Starting Test 1" >> $seqres.full
>> +_clean_dirs
>> +_create_test1_files
>> +_set_attrs
>> +_do_dump_restore
>> +_verify_attrs
>> +
>> +echo "Starting Test 2" >> $seqres.full
>> +_clean_dirs
>> +_create_test2_files
>> +_set_attrs
>> +_do_dump_restore
>> +_verify_attrs
>> +
>> +# success, all done
>> +exit
>> Index: b/tests/xfs/350.out
>> ===================================================================
>> --- /dev/null
>> +++ b/tests/xfs/350.out
>> @@ -0,0 +1,2 @@
>> +QA output created by 350
>> +Silence is golden.
>> Index: b/tests/xfs/group
>> ===================================================================
>> --- a/tests/xfs/group
>> +++ b/tests/xfs/group
>> @@ -179,3 +179,4 @@
>>   297 auto freeze
>>   298 auto attr symlink quick
>>   299 auto quota
>> +350 dump auto
>>
>>
>> _______________________________________________
>> xfs mailing list
>> xfs@oss.sgi.com
>> http://oss.sgi.com/mailman/listinfo/xfs
>>
>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
