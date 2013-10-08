Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id EBEEF7F69
	for <xfs@oss.sgi.com>; Tue,  8 Oct 2013 09:22:37 -0500 (CDT)
Message-ID: <5254153F.7060308@sgi.com>
Date: Tue, 8 Oct 2013 09:22:55 -0500
From: Rich Johnston <rjohnston@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstests XFS: verify extended attributes after
	multi-stream xfsdump/xfsrestore
References: <524AF8AE.5030300@sgi.com> <20131007193912.256265551@sgi.com>
	<20131008010822.GW4446@dastard>
In-Reply-To: <20131008010822.GW4446@dastard>
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

On 10/07/2013 08:08 PM, Dave Chinner wrote:
> On Mon, Oct 07, 2013 at 02:38:35PM -0500, rjohnston@sgi.com wrote:
>> +# create files for test 1, a large file so the sparse file
>> +# is in the next stream.
>> +_create_test1_files()
>> +{
>> +
>> +	dd if=/dev/zero of=$SCRATCH_MNT/$DUMPDIR/10MB bs=1MB \
>> +		count=10 2>&1 >> $seqres.full | _filter_dd
>> +	truncate --size=1t $SCRATCH_MNT/$DUMPDIR/sparse0 2>&1 \
>> +		>> $seqres.full
>
> I just noticed that 'truncate' is used here - we don't use that
> anywhere else in xfstests, so either you need test for it in
> common/config and use $TRUNCATE_PROG, or do like every other test
> does and use:
>
> 	$XFS_IO_PROG -c "truncate 1t" $SCRATCH_MNT/$DUMPDIR/sparse0
Good point I will make the changes.
>
> Cheers,
>
> Dave.
>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
