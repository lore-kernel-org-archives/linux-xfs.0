Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 400BD7F4E
	for <xfs@oss.sgi.com>; Wed,  4 Mar 2015 02:51:07 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id B1151AC006
	for <xfs@oss.sgi.com>; Wed,  4 Mar 2015 00:51:06 -0800 (PST)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id uZ6SoJCe7ZFfw3BZ (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 04 Mar 2015 00:51:01 -0800 (PST)
Message-ID: <54F6C772.3050806@suse.cz>
Date: Wed, 04 Mar 2015 09:50:58 +0100
From: Vlastimil Babka <vbabka@suse.cz>
MIME-Version: 1.0
Subject: Re: How to handle TIF_MEMDIE stalls?
References: <20150217225430.GJ4251@dastard>
	<20150219102431.GA15569@phnom.home.cmpxchg.org>
	<20150219225217.GY12722@dastard>
	<20150221235227.GA25079@phnom.home.cmpxchg.org>
	<20150223004521.GK12722@dastard>
	<20150222172930.6586516d.akpm@linux-foundation.org>
	<20150223073235.GT4251@dastard> <54F42FEA.1020404@suse.cz>
	<20150302223154.GJ18360@dastard> <54F57B20.3090803@suse.cz>
	<20150304013346.GP18360@dastard>
In-Reply-To: <20150304013346.GP18360@dastard>
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
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, Johannes Weiner <hannes@cmpxchg.org>, oleg@redhat.com, xfs@oss.sgi.com, mhocko@suse.cz, linux-mm@kvack.org, mgorman@suse.de, dchinner@redhat.com, rientjes@google.com, Andrew Morton <akpm@linux-foundation.org>, torvalds@linux-foundation.org

On 03/04/2015 02:33 AM, Dave Chinner wrote:
> On Tue, Mar 03, 2015 at 10:13:04AM +0100, Vlastimil Babka wrote:
>>>
>>> Preallocated reserves do not allow for unbound demand paging of
>>> reclaimable objects within reserved allocation contexts.
>>
>> OK I think I get the point now.
>>
>> So, lots of the concerns by me and others were about the wasted memory due to
>> reservations, and increased pressure on the rest of the system. I was thinking,
>> are you able, at the beginning of the transaction (for this purposes, I think of
>> transaction as the work that starts with the memory reservation, then it cannot
>> rollback and relies on the reserves, until it commits and frees the memory),
>> determine whether the transaction cannot be blocked in its progress by any other
>> transaction, and the only thing that would block it would be inability to
>> allocate memory during its course?
>
> No. e.g. any transaction that requires allocation or freeing of an
> inode or extent can get stuck behind any other transaction that is
> allocating/freeing and inode/extent. And this will happen when
> holding inode locks, which means other transactions on that inode
> will then get stuck on the inode lock, and so on. Blocking
> dependencies within transactions are everywhere and cannot be
> avoided.

Hm, I see. I thought that perhaps to avoid deadlocks between 
transactions (which you already have to do somehow), either the 
dependencies have to be structured in a way that there's always some 
transaction that can't block on others. Or you have a way to detect 
potential deadlocks before they happen, and stall somebody who tries to 
lock. Both should (at least theoretically) mean that you would be able 
to point to such transaction, although I can imagine the cost of being 
able to do that could be prohibitive.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
