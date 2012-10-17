Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9H8WUdr043441 for <xfs@oss.sgi.com>; Wed, 17 Oct 2012 03:32:30 -0500
Message-ID: <507E6D6D.7060603@oracle.com>
Date: Wed, 17 Oct 2012 16:33:49 +0800
From: Jie Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: Re: xfstests: SEEK_HOLE/SEEK_DATA advanced tests
References: <20121016204240.142425319@sgi.com>
	<20121016204244.997819918@sgi.com>
	<20121017023439.GB26797@dastard> <507E284D.40800@oracle.com>
	<20121017072424.GC26797@dastard>
In-Reply-To: <20121017072424.GC26797@dastard>
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

On 10/17/12 15:24, Dave Chinner wrote:
> On Wed, Oct 17, 2012 at 11:38:53AM +0800, Jie Liu wrote:
>> On 10/17/12 10:34, Dave Chinner wrote:
>>> On Tue, Oct 16, 2012 at 03:42:41PM -0500, Mark Tinguely wrote:
>>>> This is the test of the advanced SEEK_HOLE and SEEK_DATA features
>>>> of the lseek() function call.
>>>>
>>>> Jie Liu <jeff.liu@oracle.com> wrote the C code, I converted it to
>>>> a test with his permission.
>>> Jie, can you sign-off on this patch as well as it has Oracle
>>> copyright statements in it?
>> Hi Dave,
>>
>> I can sign-off this patch, but it's better to keep the copyright
>> statements with SGI for this test script since
>> it wrote by Mark, and Mark is already made the C test file as Oracle.
> The .c file has this:
>
> + * Copyright (C) 2011-2012 Oracle. All rights reserved.
>
> Which is why the patch needs your signoff.
>
> But if the test is redone without the .c file (i.e. SEEK_HOLE/DATA
> added to xfs_io) then it won't be necessary (unless you do that
> work :).
Ah, I see, thanks for your clarification, I'll check Mark's patch of
next revised version according to your comments, and sign it.

Thanks,
-Jeff
>
> Cheers,
>
> Dave.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
