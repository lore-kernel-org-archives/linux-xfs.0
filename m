Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q282I00v194314 for <xfs@oss.sgi.com>; Wed, 7 Mar 2012 20:18:00 -0600
Received: from mail.sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com
	with ESMTP id cUtsEO73dW0alJNZ for <xfs@oss.sgi.com>;
	Wed, 07 Mar 2012 18:17:59 -0800 (PST)
Message-ID: <4F5816D6.80801@sandeen.net>
Date: Wed, 07 Mar 2012 20:17:58 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: df bigger than ls?
References: <20120307155439.GA23360@nsrc.org> <20120307171619.GA23557@nsrc.org>
	<4F57A32A.5010704@sandeen.net> <20120308021054.GM3592@dastard>
In-Reply-To: <20120308021054.GM3592@dastard>
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
Cc: xfs@oss.sgi.com, Brian Candler <B.Candler@pobox.com>

On 3/7/12 8:10 PM, Dave Chinner wrote:
> On Wed, Mar 07, 2012 at 12:04:26PM -0600, Eric Sandeen wrote:

...

>> # du -hc bigfile* 2.0G	bigfile1 1.1G	bigfile2 907M
>> bigfile3
>>
>> Dave, is this working as intended?
> 
> Yes. Your problem is that you have a very small filesystem, which is
> not the case that we optimise XFS for. :/

Well, sure ;)

>> I know the speculative
>> preallocation amount for new files is supposed to go down as the
>> fs fills, but is there no way to discard prealloc space to avoid
>> ENOSPC on other files?
> 
> We don't track what files have current active preallocations, we
> only reduce the preallocation size as the filesystem nears ENOSPC.
> This generally works just fine in situations where the filesystem
> size is significantly greater than the maximum extent size. i.e. the
> common case
> 
> The problem you are tripping over here is that the maximum extent
> size is greater than the filesystem size, so the preallocation size
> is also greater than the filesystem size and hence can contribute
> significantly to premature ENOSPC. I see two possible ways to
> minimise this problem:

FWIW I'm not overly worried about my 4G filesystem, that was just
an obviously extreme case to test the behavior.

I'd be more interested to know if the behavior was causing any
issues for Brian's case, or if it was just confusing.  :)

> 	1. reduce the maximum speculative preallocation size based
> 	on filesystem size at mount time.
> 
> 	2. track inodes with active speculative preallocation and
> 	have an enospc based trigger that can find them and truncate
> 	away excess idle speculative preallocation.
> 
> The first is relatively easy to do, but will only reduce the
> incidence of your problem - we still need to allow significant
> preallocation sizes (e.g. 64MB) to avoid the fragmentation problems.

Might be worth it; even though a 4G fs is obviously not a design point,
it's good not to have diabolical behavior.  Although I suppose if xfstests
doesn't hit it in everything it does, it's probably not a big deal.
ISTR you did have to fix one thing up, though.

> The second is needed to reclaim the space we've already preallocated
> but is not being used. That's more complex to do - probably a radix
> tree bit and a periodic background scan to reduce the time window
> the preallocation sits around from cache lifetime to "idle for some
> time" along with a on-demand, synchronous ENOSPC scan. This will
> need some more thought as to how to do it effectively, but isn't
> impossible to do....

It seems worth thinking about.  I guess I'm still a little concerned
about the ENOSPC case; it could lead to some confusion - I could imagine
several hundreds of gigs under preallocation, with a reasonable-sized
filesystem returning ENOSPC quite early.

-Eric

> Cheers,
> 
> Dave.
>>
>> -Eric
>>
>>> root@storage1:~# du -h /disk*/scratch2/work/PRSRA1/PRSRA1.1.0.bff
>>> 2.0G	/disk10/scratch2/work/PRSRA1/PRSRA1.1.0.bff
>>> 2.0G	/disk11/scratch2/work/PRSRA1/PRSRA1.1.0.bff
>>> 2.0G	/disk12/scratch2/work/PRSRA1/PRSRA1.1.0.bff
>>> 1.1G	/disk1/scratch2/work/PRSRA1/PRSRA1.1.0.bff
>>> 1.1G	/disk2/scratch2/work/PRSRA1/PRSRA1.1.0.bff
>>> 2.0G	/disk3/scratch2/work/PRSRA1/PRSRA1.1.0.bff
>>> 2.0G	/disk4/scratch2/work/PRSRA1/PRSRA1.1.0.bff
>>> 2.0G	/disk5/scratch2/work/PRSRA1/PRSRA1.1.0.bff
>>> 2.0G	/disk6/scratch2/work/PRSRA1/PRSRA1.1.0.bff
>>> 2.0G	/disk7/scratch2/work/PRSRA1/PRSRA1.1.0.bff
>>> 2.0G	/disk8/scratch2/work/PRSRA1/PRSRA1.1.0.bff
>>> 2.0G	/disk9/scratch2/work/PRSRA1/PRSRA1.1.0.bff
>>> root@storage1:~# echo 3 >/proc/sys/vm/drop_caches 
>>> root@storage1:~# du -h /disk*/scratch2/work/PRSRA1/PRSRA1.1.0.bff
>>> 1.1G	/disk10/scratch2/work/PRSRA1/PRSRA1.1.0.bff
>>> 1.1G	/disk11/scratch2/work/PRSRA1/PRSRA1.1.0.bff
>>> 1.1G	/disk12/scratch2/work/PRSRA1/PRSRA1.1.0.bff
>>> 1.1G	/disk1/scratch2/work/PRSRA1/PRSRA1.1.0.bff
>>> 1.1G	/disk2/scratch2/work/PRSRA1/PRSRA1.1.0.bff
>>> 1.1G	/disk3/scratch2/work/PRSRA1/PRSRA1.1.0.bff
>>> 1.1G	/disk4/scratch2/work/PRSRA1/PRSRA1.1.0.bff
>>> 1.1G	/disk5/scratch2/work/PRSRA1/PRSRA1.1.0.bff
>>> 1.1G	/disk6/scratch2/work/PRSRA1/PRSRA1.1.0.bff
>>> 1.1G	/disk7/scratch2/work/PRSRA1/PRSRA1.1.0.bff
>>> 1.1G	/disk8/scratch2/work/PRSRA1/PRSRA1.1.0.bff
>>> 1.1G	/disk9/scratch2/work/PRSRA1/PRSRA1.1.0.bff
>>> root@storage1:~# 
>>>
>>> Very odd, but not really a major problem other than the confusion it causes.
>>>
>>> Regards,
>>>
>>> Brian.
>>>
>>> _______________________________________________
>>> xfs mailing list
>>> xfs@oss.sgi.com
>>> http://oss.sgi.com/mailman/listinfo/xfs
>>>
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
