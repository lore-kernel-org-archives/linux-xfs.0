Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	n0D5tXTe027430 for <xfs@oss.sgi.com>; Mon, 12 Jan 2009 23:55:34 -0600
Message-ID: <496C2D69.2010301@sgi.com>
Date: Tue, 13 Jan 2009 16:58:01 +1100
From: Lachlan McIlroy <lachlan@sgi.com>
MIME-Version: 1.0
Subject: Re: spurious -ENOSPC on XFS
References: <Pine.LNX.4.64.0901120509550.11089@hs20-bc2-1.build.redhat.com>
	<20090112151133.GA24852@infradead.org>
In-Reply-To: <20090112151133.GA24852@infradead.org>
Reply-To: lachlan@sgi.com
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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
To: Christoph Hellwig <hch@infradead.org>
Cc: Mikulas Patocka <mpatocka@redhat.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

Christoph Hellwig wrote:
> On Mon, Jan 12, 2009 at 06:14:36AM -0500, Mikulas Patocka wrote:
>> Hi
>>
>> I discovered a bug in XFS in delayed allocation.
>>
>> When you take a small partition (52MB in my case) and copy many small 
>> files on it (source code) that barely fits there, you get -ENOSPC. Then 
>> sync the partition, some free space pops up, click "retry" in MC an the 
>> copy continues. They you get again -ENOSPC, you must sync, click "retry" 
>> and go on. And so on few times until the source code finally fits on the 
>> XFS partition.
>>
>> This misbehavior is apparently caused by delayed allocation, delayed 
>> allocation does not exactly know how much space will be occupied by data, 
>> so it makes some upper bound guess. Because free space count is only a 
>> guess, not the actual data being consumed, XFS should not return -ENOSPC 
>> on behalf of it. When the free space overflows, XFS should sync itself, 
>> retry allocation and only return -ENOSPC if it fails the second time, 
>> after the sync.
This sounds like a problem with speculative allocation - delayed allocations
beyond eof.  Even if we write a small file, say 4k, a 64k chunk of delayed
allocation will be credited to the file.  If we extend the file we use more
of that chunk instead of allocating more.  When the file is closed and the
last inode reference is dropped the excess delayed allocations are released
back to freespace - this must be happening during the sync.

> 
> This looks a lot like: http://oss.sgi.com/bugzilla/show_bug.cgi?id=724
> It's on my short-term todo list to turn the testcase in that entry
> into a proper xfsqa testcase and followup on the investigation by
> Dave and Eric.
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
