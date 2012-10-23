Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9N03U9X170190 for <xfs@oss.sgi.com>; Mon, 22 Oct 2012 19:03:31 -0500
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 8HRK8ldDuKeexHnR for
	<xfs@oss.sgi.com>; Mon, 22 Oct 2012 17:05:13 -0700 (PDT)
Message-ID: <5085DF37.5020103@redhat.com>
Date: Mon, 22 Oct 2012 19:05:11 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfsdump: Revert dump version bump for 32bit projid fix
References: <5085AB70.2060904@redhat.com> <20121022223139.GC4291@dastard>
In-Reply-To: <20121022223139.GC4291@dastard>
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

On 10/22/12 5:31 PM, Dave Chinner wrote:
> On Mon, Oct 22, 2012 at 03:24:16PM -0500, Eric Sandeen wrote:
>> commit 1e309da7a4f7e2a2f456bf6b7cea4c5f1181cd36 fixed xfsdump to
>> properly save & restore the top 16 bits of a 32-bit projid, which
>> otherwise was being dropped (and restored as 0) in older xfsdump.
>>
>> The original thought was to bump the dump version, so that we know
>> whether the dump (may) have the top 16 bits filled in.  In practice
>> this would prevent older restores from restoring newer dumps, and
>> losing the top 16 bits contained in these newer dumps.
>>
>> However, in hindsight this appears to be of limited value.  I
>> propose that the dump version change is unuseful/unwanted for a
>> couple reasons:
>>
>> * There is no actual dump *format* change; the structure size
>>   is the same, and the top 16 bits were properly zeroed before; old
>>   restores will read these fixed dumps without problems and without
>>   restoring garbage.  IOW, they will behave exactly as buggily as
>>   they did before.  And worst case, if a dump containing the top 16
>>   bits is mangled by an old restore, this can be easily remedied by
>>   simply re-restoring with updated userspace.
>>
>> * We have no reliable method to know whether 32 bit project IDs are
>>   in use; the feature flag was not added to the GEOM call at the time
>>   of implementation.  Therefore we cannot reliably bump to V4 only
>>   for projid32bit filesystems, and we cannot restrict V4 restores
>>   only to projid32bit filesystems.  So the dump version is not
>>   useful for feature cross-checking purposes.
> 
> Seems reasonable. Definitely solves most of the nasty problems
> you've been juggling caused by a version bump and 32bit projid
> detection. Do we have an xfstest that verifies these assumptions are
> valid?

I'll whip up a test that tests what happens when restoring a dump
w/ all 32 bits to a filesystem w/o the feature.

I'm not sure testing a restoration of an "old" dump to a 32-bit
projid is too useful, it really just tests that the zeroed bits
in the old dump image stay zeroed.

-Eric

> Cheers,
> 
> Dave.
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
