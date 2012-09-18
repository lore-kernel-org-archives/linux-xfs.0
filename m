Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q8IEgUPe055322 for <xfs@oss.sgi.com>; Tue, 18 Sep 2012 09:42:30 -0500
Message-ID: <50588898.6050802@sgi.com>
Date: Tue, 18 Sep 2012 09:43:36 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: Anyone have test cases for SEEK_HOLE/SEEK_DATA?
References: <nsxa9wojdcd.fsf@closure.thunk.org>
	<20120918064039.GS11511@dastard>
In-Reply-To: <20120918064039.GS11511@dastard>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>, xfs@oss.sgi.com

On 09/18/12 01:40, Dave Chinner wrote:
> On Mon, Sep 17, 2012 at 10:04:34PM -0400, Theodore Ts'o wrote:
>>
>> Does anyone have test cases for SEEK_HOLE/SEEK_DATA handy?  As near as I
>> can tell xfstests doesn't have any tests for SEEK_HOLE/SEEK_DATA
>> functionality, and I was hoping someone had some test programs and test
>> sets already written.
>
> Perhaps a cc to xfs@oss.sgi.com so the xfstests maintainers see the
> question would be a sensible idea?
>
> As it is, there are tests pending check-in that test
> seek-data/seek-hole functionality - they were used to verify the
> unwritten extent aware XFS implementation that recently went into
> the kernel....
>
> Cheers,
>
> Dave.

xfstest 285 and 286 (I believe these tests were only in the OSS version 
and not in the kernel.org developers version of xfstests).

There is rough version of another test that I got directly from Jeff 
Lui, the person who wrote the SEEK_HOLE/SEEK_DATA feature in XFS. This 
version tests the advance features of SEEK_HOLE/SEEK_DATA.

Ben asked me about this advanced test when he committed the advance 
features of SEEK_HOLE/SEEK_DATA to the XFS OSS tree. To the best of my 
knowledge, this test has not been submitted as an xfstest so we could 
not add it then.

--Mark Tinguely.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
