Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o1PNiZkK138837 for <xfs@oss.sgi.com>; Thu, 25 Feb 2010 17:44:36 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8568B13DC7D6
	for <xfs@oss.sgi.com>; Thu, 25 Feb 2010 15:45:56 -0800 (PST)
Received: from mail.internode.on.net (bld-mail14.adl6.internode.on.net
	[150.101.137.99]) by cuda.sgi.com with ESMTP id
	yfvlIAu2j9G0GXQn for <xfs@oss.sgi.com>;
	Thu, 25 Feb 2010 15:45:56 -0800 (PST)
Date: Fri, 26 Feb 2010 10:45:53 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] Inode reclaim fixes (was Re: 2.6.31
	xfs_fs_destroy_inode: cannot reclaim)
Message-ID: <20100225234553.GC18369@discord.disaster>
References: <20100108113114.GA8654@discord.disaster>
	<4B504B03.7050604@news-service.com>
	<4B6706CE.1020207@news-service.com>
	<20100208194226.GD9527@infradead.org>
	<4B712166.9010701@news-service.com>
	<20100209103157.GA5197@infradead.org>
	<4B72A9D1.8030101@news-service.com>
	<20100210145508.GA29047@infradead.org>
	<4B72D3F3.2040308@news-service.com>
	<4B85703A.60104@news-service.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4B85703A.60104@news-service.com>
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
To: Patrick Schreurs <patrick@news-service.com>
Cc: Christoph Hellwig <hch@infradead.org>, Tommy van Leeuwen <tommy@news-service.com>, xfs@oss.sgi.com

On Wed, Feb 24, 2010 at 07:30:18PM +0100, Patrick Schreurs wrote:
> On 10-2-2010 16:42, Patrick Schreurs wrote:
>> On 10-2-2010 15:55, Christoph Hellwig wrote:
>>> On Wed, Feb 10, 2010 at 01:42:57PM +0100, Patrick Schreurs wrote:
>>>> Thanks for the patch. After having this patch applied we saw *a lot*
>>>> warnings. They all look like this:
>>>
>>> Ok, looks like that is not an issue, so you can discard that patch.
>>>
>>> I went down to the radix tree code to look for races in it's tag
>>> handling, but then noticed that we might have an issue with our
>>> usage of the radix-tree API. Can you try the patch below ontop
>>> of Dave's rollup, and instead of my previous one?
>>
>> Okay. This patch is currently active. Thanks. I don't have a way to
>> trigger it, so we'll have to wait and see what happens.
>
> Servers running with this patch applied are still running stable. The  
> first server we've patched is running stable for 2 weeks now. Should we  
> try to have this patches included for 2.6.33?

Good to hear. The fixes are already in 2.6.33 (just released), so
the question is whether we backport to 2.6.32 or not. Christoph,
Alex, Eric - should we push these fixes back to .32-stable?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
