Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q0HGXLAY165528 for <xfs@oss.sgi.com>; Tue, 17 Jan 2012 10:33:21 -0600
Received: from mail.sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com
	with ESMTP id zfNraUq0SbKKLsh9 for <xfs@oss.sgi.com>;
	Tue, 17 Jan 2012 08:33:19 -0800 (PST)
Message-ID: <4F15A2D0.2090900@sandeen.net>
Date: Tue, 17 Jan 2012 10:33:20 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH V2] xfstests: make 275 pass
References: <4F04A6E6.1090304@redhat.com> <4F04BC81.1000207@redhat.com>
	<20120104231725.GB24466@dastard> <4F04DEDC.6020807@redhat.com>
	<20120105003928.GC24466@dastard>
In-Reply-To: <20120105003928.GC24466@dastard>
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
Cc: Eric Sandeen <sandeen@redhat.com>, ext4 development <linux-ext4@vger.kernel.org>, Eryu Guan <eguan@redhat.com>, xfs-oss <xfs@oss.sgi.com>

On 1/4/12 6:39 PM, Dave Chinner wrote:
> On Wed, Jan 04, 2012 at 05:21:00PM -0600, Eric Sandeen wrote:
>> On 1/4/12 5:17 PM, Dave Chinner wrote:
>>> On Wed, Jan 04, 2012 at 02:54:25PM -0600, Eric Sandeen wrote:
>>>> Ok, this is a significant rework of 275, which made too many
>>>> assumptions about details of space usage and failed on several
>>>> filesystems (it passed on xfs, but only by accident).
>>>>
>>>> This new version tries to leave about 256k free, then tries
>>>> a single 1M IO, and fails only if 0 bytes are written.
>>>>
>>>> It also sends a lot more to $seq.full for debugging on failure
>>>> and fixes a few other stylistic things.
>>>>
>>>> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
>>>
>>> I just had another thought about this, Eric....
>>>
>>>> +# And at least some of it should succeed.
>>>> +_filesize=`du $SCRATCH_MNT/tmp1 | awk '{print $1}'`
>>>> +[ $_filesize -eq 0 ] && _fail "write file err: Partial write until enospc failed; wrote 0 bytes."
>>>
>>> The question that just came to mind was this assumes that allocation
>>> succeeded so therefore the partial write succeeded. But that's not
>>> necessary the case. The partial write might not succeed leaving the
>>> file size as zero, but the underlying FS might not remove all the
>>> blocks it allocated (nothing says that it has to). Hence to
>>> determine if a partial write succeeded, we also need to check that
>>> the file size itself is greater than zero....
>>
>> Probably need to read up on what posix says it should do.  I think
>> what you're saying is that it might leave blocks allocated past EOF?
>> That'd be surprising to me, but maybe I misunderstand?
> 
> There's no guarantee that du is even reporting blocks on disk. e.g
> for XFS du will also report reserved (in-memory) delalloc space on
> the inode and that includes speculative allocation beyond EOF. We
> don't have to remove specultive delalloc ranges when a partial write
> occurs, so effectively checking du output to see if a partial write
> succeeded is not a sufficient test to determine if the partial write
> succeeded or not.
> 
> However, if the partial write did succeed then the file size *must*
> change to reflect what was written. Hence I suspect all we actually
> need here is a file size check...

Ok; so would you be happy with just this?

# And at least some of it should succeed.
_filesize=`ls -l $SCRATCH_MNT/tmp1 | awk '{print $5}'`
[ $_filesize -eq 0 ] && _fail "write file err: Partial write until enospc failed; wrote 0 bytes."

If so I'll put your reviewed-by on it and get this pushed, ok?

-Eric

> Cheers,
> 
> Dave.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
