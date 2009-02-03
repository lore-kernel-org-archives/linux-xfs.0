Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n13LJDSa093470 for <xfs@oss.sgi.com>; Tue, 3 Feb 2009 15:19:14 -0600
Received: from mx2.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8581218B7F16
	for <xfs@oss.sgi.com>; Tue,  3 Feb 2009 13:18:33 -0800 (PST)
Received: from mx2.redhat.com (mx2.redhat.com [66.187.237.31]) by cuda.sgi.com
	with ESMTP id gIV7Qo3SSvUcoUjP for <xfs@oss.sgi.com>;
	Tue, 03 Feb 2009 13:18:33 -0800 (PST)
Message-ID: <4988ADAA.8040400@sandeen.net>
Date: Tue, 03 Feb 2009 14:48:42 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] Re: Corrupted XFS log replay oops.
References: <20090113142147.GE16333@alice>
	<20090120173455.GC21339@alice>	<20090121035703.GH10158@disturbed>	<200901211503.07308.nickpiggin@yahoo.com.au>
	<20090122043747.GU10158@disturbed>
In-Reply-To: <20090122043747.GU10158@disturbed>
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
To: Dave Chinner <david@fromorbit.com>, xfs mailing list <xfs@oss.sgi.com>

Dave Chinner wrote:
> On Wed, Jan 21, 2009 at 03:03:06PM +1100, Nick Piggin wrote:
>> On Wednesday 21 January 2009 14:57:03 Dave Chinner wrote:
>>>> [  235.250167] ------------[ cut here ]------------
>>>> [  235.250354] kernel BUG at mm/vmalloc.c:164!
>>>> [  235.250478] invalid opcode: 0000 [#1] PREEMPT DEBUG_PAGEALLOC
>>>> [  235.250869] last sysfs file: /sys/block/ram9/range
>>>> [  235.250998] Modules linked in:
> ......
>>>> [  235.251037] Call Trace:
>>>> [  235.251037]  [<c01414cf>] ? trace_hardirqs_on+0xb/0xd
>>>> [  235.251037]  [<c018367c>] ? vm_map_ram+0x36e/0x38a
>>>> [  235.251037]  [<c03b2e1e>] ? _xfs_buf_map_pages+0x42/0x6d
>>>> [  235.251037]  [<c03b3773>] ? xfs_buf_get_noaddr+0xbc/0x11f
>>>> [  235.251037]  [<c03a2406>] ? xlog_get_bp+0x5a/0x5d
>>>> [  235.251037]  [<c03a28fa>] ? xlog_find_verify_log_record+0x26/0x208
>>>> [  235.251037]  [<c03a3521>] ? xlog_find_zeroed+0x1d6/0x214
>>>> [  235.251037]  [<c03a3584>] ? xlog_find_head+0x25/0x358
>>> .....
>>>
>>> Ok, that's crashing in the new vmap code. It might take a couple
>>> of days before I get a chance to look at this, but I've cc'd Nick Piggin
>>> in case he has a chance to look at it before that. It's probably
>>> an XFS bug, anyway.
>> Hmm, it is crashing in BUG_ON(addr >= end); where this could happen
>> if XFS asks to map a really huge (or -ve) number of pages and wraps
>> the range, or if vmap subsystem returns an address right near the
>> end of the address range and addr+size wraps (which would be a bug
>> in vmap of course, but I think maybe less likely).
> 
> It's a zero length range, not a negative value. A debug XFS would
> have assert failed on it, but it was completely unchecked on
> production builds. The following patch checks the length of blocks
> to build/read/write for being valid. Instead of an oops, we get:

Dave, this patch seems like a candidate for 2.6.27-stable too, yes?

-Eric

> [ 1572.665001] XFS mounting filesystem loop0
> [ 1572.666942] XFS: Invalid block length (0x0) given for buffer
> [ 1572.667141] XFS: Log inconsistent (didn't find previous header)
> [ 1572.667141] XFS: empty log check failed
> [ 1572.667141] XFS: log mount/recovery failed: error 5
> [ 1572.671487] XFS: log mount failed
> 
> Cheers,
> 
> Dave.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
