Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 26 Oct 2008 22:30:30 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9R5UJ2A012875
	for <xfs@oss.sgi.com>; Sun, 26 Oct 2008 22:30:20 -0700
Received: from ipmail01.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id BFFB5549E90
	for <xfs@oss.sgi.com>; Sun, 26 Oct 2008 22:30:17 -0700 (PDT)
Received: from ipmail01.adl6.internode.on.net (ipmail01.adl6.internode.on.net [203.16.214.146]) by cuda.sgi.com with ESMTP id vv3QUgXV92TtD7IK for <xfs@oss.sgi.com>; Sun, 26 Oct 2008 22:30:17 -0700 (PDT)
Date: Mon, 27 Oct 2008 16:30:04 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: deadlock with latest xfs
Message-ID: <20081027053004.GF11948@disturbed>
References: <4900412A.2050802@sgi.com> <20081023205727.GA28490@infradead.org> <49013C47.4090601@sgi.com> <20081024052418.GO25906@disturbed> <20081024064804.GQ25906@disturbed> <20081026005351.GK18495@disturbed> <20081026025013.GL18495@disturbed> <49051C71.9040404@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49051C71.9040404@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Lachlan McIlroy <lachlan@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs-oss <xfs@oss.sgi.com>, linux-mm@kvack.org

On Mon, Oct 27, 2008 at 12:42:09PM +1100, Lachlan McIlroy wrote:
> Dave Chinner wrote:
>> On Sun, Oct 26, 2008 at 11:53:51AM +1100, Dave Chinner wrote:
>>> On Fri, Oct 24, 2008 at 05:48:04PM +1100, Dave Chinner wrote:
>>>> OK, I just hung a single-threaded rm -rf after this completed:
>>>>
>>>> # fsstress -p 1024 -n 100 -d /mnt/xfs2/fsstress
>>>>
>>>> It has hung with this trace:
....
>> Got it now. I can reproduce this in a couple of minutes now that both
>> the test fs and the fs hosting the UML fs images are using lazy-count=1
>> (and the frequent 10s long host system freezes have gone away, too).
>>
>> Looks like *another* new memory allocation problem [1]:
.....
>> We've entered memory reclaim inside the xfsdatad while trying to do
>> unwritten extent completion during I/O completion, and that memory
>> reclaim is now blocked waiting for I/o completion that cannot make
>> progress.
>>
>> Nasty.
>>
>> My initial though is to make _xfs_trans_alloc() able to take a KM_NOFS argument
>> so we don't re-enter the FS here. If we get an ENOMEM in this case, we should
>> then re-queue the I/O completion at the back of the workqueue and let other
>> I/o completions progress before retrying this one. That way the I/O that
>> is simply cleaning memory will make progress, hence allowing memory
>> allocation to occur successfully when we retry this I/O completion...
> It could work - unless it's a synchronous I/O in which case the I/O is not
> complete until the extent conversion takes place.

Right. Pushing unwritten extent conversion onto a different
workqueue is probably the only way to handle this easily.
That's the same solution Irix has been using for a long time
(the xfsc thread)....

> Could we allocate the memory up front before the I/O is issued?

Possibly, but that will create more memory pressure than
allocation in I/O completion because now we could need to hold
thousands of allocations across an I/O - think of the case where
we are running low on memory and have a disk subsystem capable of
a few hundred thousand I/Os per second. the allocation failing would
prevent the I/os from being issued, and if this is buffered writes
into unwritten extents we'd be preventing dirty pages from being
cleaned....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
