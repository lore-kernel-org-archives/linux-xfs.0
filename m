Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with SMTP id
	p2SMn7dt189902 for <xfs@oss.sgi.com>; Mon, 28 Mar 2011 17:49:07 -0500
Received: from mail-iy0-f181.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id CC6A1384542
	for <xfs@oss.sgi.com>; Mon, 28 Mar 2011 15:52:16 -0700 (PDT)
Received: from mail-iy0-f181.google.com (mail-iy0-f181.google.com
	[209.85.210.181]) by cuda.sgi.com with ESMTP id
	SDEbQSGiSbcwyT94 for <xfs@oss.sgi.com>;
	Mon, 28 Mar 2011 15:52:16 -0700 (PDT)
Received: by iyb26 with SMTP id 26so4461927iyb.26
	for <xfs@oss.sgi.com>; Mon, 28 Mar 2011 15:52:16 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20110328215344.GC3008@dastard>
References: <AANLkTinFqqmE+fTMTLVU-_CwPE+LQv7CpXSQ5+CdAKLK@mail.gmail.com>
	<20110328215344.GC3008@dastard>
Date: Tue, 29 Mar 2011 07:52:14 +0900
Message-ID: <BANLkTimHPFMUOCFAruF5J4OMHSkZsMsAgA@mail.gmail.com>
Subject: Re: Very aggressive memory reclaim
From: Minchan Kim <minchan.kim@gmail.com>
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
Cc: linux-mm@kvack.org, John Lepikhin <johnlepikhin@gmail.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

On Tue, Mar 29, 2011 at 6:53 AM, Dave Chinner <david@fromorbit.com> wrote:
> [cc xfs and mm lists]
>
> On Mon, Mar 28, 2011 at 08:39:29PM +0400, John Lepikhin wrote:
>> Hello,
>>
>> I use high-loaded machine with 10M+ inodes inside XFS, 50+ GB of
>> memory, intensive HDD traffic and 20..50 forks per second. Vanilla
>> kernel 2.6.37.4. The problem is that kernel frees memory very
>> aggressively.
>>
>> For example:
>>
>> 25% of memory is used by processes
>> 50% for page caches
>> 7% for slabs, etc.
>> 18% free.
>>
>> That's bad but works. After few hours:
>>
>> 25% of memory is used by processes
>> 62% for page caches
>> 7% for slabs, etc.
>> 5% free.
>>
>> Most of files are cached, works perfectly. This is the moment when
>> kernel decides to free some memory. After memory reclaim:
>>
>> 25% of memory is used by processes
>> 25% for page caches(!)
>> 7% for slabs, etc.
>> 43% free(!)
>>
>> Page cache is dropped, server becomes too slow. This is the beginning
>> of new cycle.
>>
>> I didn't found any huge mallocs at that moment. Looks like because of
>> large number of small mallocs (forks) kernel have pessimistic forecast
>> about future memory usage and frees too much memory. Is there any
>> options of tuning this? Any other variants?
>
> First it would be useful to determine why the VM is reclaiming so
> much memory. If it is somewhat predictable when the excessive
> reclaim is going to happen, it might be worth capturing an event
> trace from the VM so we can see more precisely what it is doiing
> during this event. In that case, recording the kmem/* and vmscan/*
> events is probably sufficient to tell us what memory allocations
> triggered reclaim and how much reclaim was done on each event.
>
> Cheers,
>
> Dave.
> --
> Dave Chinner
> david@fromorbit.com
>

Recently, We had a similar issue.
http://www.spinics.net/lists/linux-mm/msg12243.html
But it seems to not merge. I don't know why since I didn't follow up the thread.
Maybe Cced guys can help you.

Is it a sudden big cache drop at the moment or accumulated small cache
drop for long time?
What's your zones' size?

Please attach the result of cat /proc/zoneinfo for others.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
