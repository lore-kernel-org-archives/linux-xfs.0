Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q2T1rxpY013415 for <xfs@oss.sgi.com>; Wed, 28 Mar 2012 20:53:59 -0500
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id seGagKspHBI4p9CB for
	<xfs@oss.sgi.com>; Wed, 28 Mar 2012 18:53:58 -0700 (PDT)
Message-ID: <4F73C0B2.1080703@redhat.com>
Date: Wed, 28 Mar 2012 20:53:54 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: Re: [PATCH] mkfs.xfs: print std info if agcount makes agsize out
	of bounds
References: <4F7375F7.5090305@redhat.com> <20120329012404.GL5091@dastard>
In-Reply-To: <20120329012404.GL5091@dastard>
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
Cc: xfs-oss <xfs@oss.sgi.com>

On 3/28/12 8:24 PM, Dave Chinner wrote:
> On Wed, Mar 28, 2012 at 03:35:03PM -0500, Eric Sandeen wrote:
>> When specifying a too-small agcount with stripe geometry,
>> mkfs.xfs can fail with a somewhat unexpected message:
>>
>> $ mkfs.xfs -f -d file,name=fsfile,size=9764864000b,agcount=31,su=512k,sw=20
>> Allocation group size (314995613) is not a multiple of the stripe unit (128)
>>
>> This strikes me as especially odd because normally, mkfs.xfs
>> tries to fix up the agsize to be a stripe multiple.  The only way
>> we get to the above error message is if ag _size_ is out of bounds;
>> exiting with an error about alignment rather than about size
>> seems odd.
>>
>> Maybe below is too clever, but if by the time we've decided that
>> agsize is out of bounds after rounding it both up and down,
>> as necessary, to get to a stripe-width multiple, calling
>> validate_ag_geometry() will give us the same standard message as
>> if we had specified no stripe geometry:
>>
>> $ mkfs/mkfs.xfs -f -d file,name=fsfile,size=9764864000b,agcount=31,su=512k,sw=20
>> agsize (314995613b) too big, maximum is 268435455 blocks
>> Usage: mkfs.xfs
>> ...
>>
>> $ mkfs/mkfs.xfs -f -d file,name=fsfile,size=9764864000b,agcount=31
>> agsize (314995613b) too big, maximum is 268435455 blocks
>> Usage: mkfs.xfs
>> ...
>>
>> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> 
> Makes sense. Consider it:
> 
> Reviewed-by: Dave Chinner <dchinner@redhat.com>
> 
> As an aside, do you want to touch that error message:
> 
> agsize (314995613b) too big, maximum is 268435455 blocks
> 
> so that it uses the same notation for blocks for both numbers. i.e.
> something like:
> 
> agsize (314995613 blocks) too big, maximum is 268435455 blocks

Good idea, will do.

-Eric

> Cheers,
> 
> Dave.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
