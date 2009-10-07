Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n971VZe4149490 for <xfs@oss.sgi.com>; Tue, 6 Oct 2009 20:31:36 -0500
Received: from hera.kernel.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B0E3E1B9835D
	for <xfs@oss.sgi.com>; Tue,  6 Oct 2009 18:33:01 -0700 (PDT)
Received: from hera.kernel.org (hera.kernel.org [140.211.167.34]) by
	cuda.sgi.com with ESMTP id IHtf0iyMGrKUugvC for
	<xfs@oss.sgi.com>; Tue, 06 Oct 2009 18:33:01 -0700 (PDT)
Message-ID: <4ACBEFC9.3020707@kernel.org>
Date: Wed, 07 Oct 2009 10:32:57 +0900
From: Tejun Heo <tj@kernel.org>
MIME-Version: 1.0
Subject: Re: stack bloat after stackprotector changes
References: <4ACA5EB0.4010707@sandeen.net> <4ACADB74.5090508@kernel.org>
	<4ACB50C1.80702@sandeen.net>
In-Reply-To: <4ACB50C1.80702@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs mailing list <xfs@oss.sgi.com>

Hello,

Eric Sandeen wrote:
> Tejun Heo wrote:
>> Eric Sandeen wrote:
>>> It seems that after:
>>>
>>> commit 5d707e9c8ef2a3596ed5c975c6ff05cec890c2b4
>>> Author: Tejun Heo <tj@kernel.org>
>>> Date:   Mon Feb 9 22:17:39 2009 +0900
>>>
>>>     stackprotector: update make rules
>>>
>>> xfs stack usage jumped up a fair bit;
>>>
>>> Not a lot in each case but could be significant as it accumulates.
>>>
>>> I'm not familiar w/ the gcc stack protector feature; would this be an
>>> expected result?
>>
>> Yeah, it adds a bit of stack usage per each function call and around
>> arrays which seem like they could overflow, so the behavior is
>> expected and I can see it can be a problem with function call depth
>> that deep.  Has it caused actual stack overflow?
>>
>> Thanks.
>>
> 
> It's hard to point at one thing and say "that caused it" but I did
> overflow (or come very close to it - this one was within 8 bytes).
> 
> Add 20 byte or so to each of 65 calls and it starts to matter I guess.
> 
> Granted, xfs is being piggy too (as are some of the more common
> functions in the callchain - do_sync_write and write_cache_pages at 320
> bytes each...)
> 
> -Eric
> 
>          Depth    Size   Location    (65 entries)
>          -----    ----   --------
>    0)     7280      80   check_object+0x6c/0x1d3

Yeap, that's pretty darn close.

But the thing is that stackprotector is a feature which consumes
certain amount of stack space, so there I'm afraid really isn't a way
around that other than trying to diet the piggies or enlarging the
stack.  :-(

Thanks.

-- 
tejun

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
