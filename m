Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q860dgws172693 for <xfs@oss.sgi.com>; Wed, 5 Sep 2012 19:39:42 -0500
Received: from mail.sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com
	with ESMTP id fu9HOdpBMLSBgAek for <xfs@oss.sgi.com>;
	Wed, 05 Sep 2012 17:40:39 -0700 (PDT)
Message-ID: <5047F106.4050905@sandeen.net>
Date: Wed, 05 Sep 2012 19:40:38 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH v2] xfstests: Add test case to test xfs projid32bit
	functionality a bit more extensively.
References: <CAFZPdfg+5kRfUuVOtRk1pqKrRai6CZBxisvXnuPUr-_SNAmGTg@mail.gmail.com>
	<20120906003150.GM15292@dastard>
In-Reply-To: <20120906003150.GM15292@dastard>
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
Cc: Boris Ranto <ranto.boris@gmail.com>, xfs-oss <xfs@oss.sgi.com>

On 9/5/12 7:31 PM, Dave Chinner wrote:
> On Tue, Aug 28, 2012 at 02:59:42PM +0200, Boris Ranto wrote:
>>  The test covers several areas including enabling projid32bit
>> functionality dynamically by xfs_admin, dumping, restoring, quota
>> reporting and xfs_db projid values reporting.
>>  This test case hits two bugs: one for broken xfsdump/xfsrestore
>> functionality and one for enabling projid32bit functionality with
>> xfs_admin on a LVM device (SCRATCH_DEV must be an LVM device to hit
>> this).
> 
> The LVM problem is incidental - if there's a problem with LVM
> devices then xfs_db should show the same problem, as should all
> other xfs_admin commands that use xfs_db. Hence I don't think that
> there is any point in mentioning it here.

I agree.  And FWIW, though I tried to bisect my way to the root cause,
in the end I realized that upstream it's no longer a problem, so TBH
I stopped looking ...

...

>> +mkdir -p $dir
>> +touch $dir/{16,32}less
> 
> "less" is a weird filename suffix. What's it mean? Why not just
> something standard like "test"?

16 or less (fewer) bits, 32 or less bits.
...

>> +# Now, we can examine the file systems with xfs_db
>> +# These two should report the same values
>> +echo "These two values of 16bit project quota ids shall be the same"
> 
> No need to output this into the out file. The comment says it all,
> and we don't need the text in the output file to test for test
> failure.

Although the comments don't end up in the output file; if it fails with an out file diff like:

@blah,blah
 core.projid_lo = 24853
 core.projid_hi = 32401
 core.projid_lo = 24853
-core.projid_hi = 32401
+core.projid_hi = 0
 core.projid_lo = 24853
 core.projid_hi = 32401

it's sometimes tedious to work your way back to where the numbers came from and what was being tested at the time; IOW comment-style landmarks in the output file like this are sometimes helpful, in my experience.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
