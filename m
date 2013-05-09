Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 0AD3029DF8
	for <xfs@oss.sgi.com>; Thu,  9 May 2013 11:21:33 -0500 (CDT)
Message-ID: <518BCD0F.6000501@sgi.com>
Date: Thu, 09 May 2013 11:21:35 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 10/8] xfsdb: re-instate DA btree node headers
References: <20130430121300.GB10481@dastard> <20130501063006.GK10481@dastard>
	<518BBF6C.2000101@sgi.com>
In-Reply-To: <518BBF6C.2000101@sgi.com>
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

On 05/09/13 10:23, Mark Tinguely wrote:
> On 05/01/13 01:30, Dave Chinner wrote:
>> From: Dave Chinner<dchinner@redhat.com>
>>
>> When removing the dirv1 code, it wasn't immediately obvious that the
>> dir v2 code used a small chunk of the dirv1 field definitions. i.e.
>> those for the DA btree node headers. Hence bits of xfs_db didn't
>> work as expected, and some tests failed in non-obvious ways. e.g
>> test 073 failed with this additional line of output:
>>
>> Use of uninitialized value $logstart in numeric gt (>) at
>> /home/dave/src/xfstests-dev/src/fill2fs line 84
>>
>> which was the result of the command:
>>
>> xfs_db -r -c sb -c $TEST_DEV
>>
>> giving an unexpectedly incorrect output.
>>
>> Re-instate the needed field definitions and rename them from "DIR"
>> to "DA" so it is obvious they are for decoding DA Btree format
>> blocks.
>>
>> Signed-off-by: Dave Chinner<dchinner@redhat.com>
>> ---
>
> This no longer cleanly applies.
>
> --Mark.

Oops, I forgot that patch 9/8 and 10/8 was folded back into the version 
2 of the tarball. 11/8 (xfs_logprint: fix continuation transactions) is 
not in the tarball.

Sorry for the noise.

--Mark.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
