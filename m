Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	n0EMH0Bu004343 for <xfs@oss.sgi.com>; Wed, 14 Jan 2009 16:17:01 -0600
Received: from ipmail05.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 103BD8BCE1
	for <xfs@oss.sgi.com>; Wed, 14 Jan 2009 14:16:59 -0800 (PST)
Received: from ipmail05.adl2.internode.on.net (ipmail05.adl2.internode.on.net
	[203.16.214.145]) by cuda.sgi.com with ESMTP id
	kseRMLGZBaxlCcsF for <xfs@oss.sgi.com>;
	Wed, 14 Jan 2009 14:16:59 -0800 (PST)
Date: Thu, 15 Jan 2009 09:16:55 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: spurious -ENOSPC on XFS
Message-ID: <20090114221655.GX8071@disturbed>
References: <Pine.LNX.4.64.0901120509550.11089@hs20-bc2-1.build.redhat.com>
	<20090112151133.GA24852@infradead.org> <496C2D69.2010301@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <496C2D69.2010301@sgi.com>
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
To: Lachlan McIlroy <lachlan@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>, Mikulas Patocka <mpatocka@redhat.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

On Tue, Jan 13, 2009 at 04:58:01PM +1100, Lachlan McIlroy wrote:
> Christoph Hellwig wrote:
>> On Mon, Jan 12, 2009 at 06:14:36AM -0500, Mikulas Patocka wrote:
>>> Hi
>>>
>>> I discovered a bug in XFS in delayed allocation.
>>>
>>> When you take a small partition (52MB in my case) and copy many small 
>>> files on it (source code) that barely fits there, you get -ENOSPC. 
>>> Then sync the partition, some free space pops up, click "retry" in MC 
>>> an the copy continues. They you get again -ENOSPC, you must sync, 
>>> click "retry" and go on. And so on few times until the source code 
>>> finally fits on the XFS partition.
>>>
>>> This misbehavior is apparently caused by delayed allocation, delayed  
>>> allocation does not exactly know how much space will be occupied by 
>>> data, so it makes some upper bound guess. Because free space count is 
>>> only a guess, not the actual data being consumed, XFS should not 
>>> return -ENOSPC on behalf of it. When the free space overflows, XFS 
>>> should sync itself, retry allocation and only return -ENOSPC if it 
>>> fails the second time, after the sync.
> This sounds like a problem with speculative allocation - delayed allocations
> beyond eof.  Even if we write a small file, say 4k, a 64k chunk of delayed
> allocation will be credited to the file. 

The second retry occurs without speculative EOF allocation. That's
what the BMAPI_SYNC flag does....

That being said, it can't truncate away pre-existing speculative
allocations on other files, which is why there is a global flush
and wait before the third retry.....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
