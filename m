Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n0P04MAM074684 for <xfs@oss.sgi.com>; Sat, 24 Jan 2009 18:04:23 -0600
Message-ID: <497BAC47.2030101@sgi.com>
Date: Sun, 25 Jan 2009 11:03:19 +1100
From: Mark Goodwin <markgw@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH, needs new owner] xfs_repair memory optimization
References: <497926DC.1030509@sgi.com> <20090124142331.GA32688@infradead.org>
In-Reply-To: <20090124142331.GA32688@infradead.org>
Reply-To: markgw@sgi.com
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs-oss <xfs@oss.sgi.com>



Christoph Hellwig wrote:
> On Fri, Jan 23, 2009 at 01:09:32PM +1100, Mark Goodwin wrote:
>> A known limitation of xfs_repair is the large amount of memory it
>> requires, depending on filesystem size and number of inodes, etc.
>>
>> The attached patch series, originally by Barry Bnaujok, is close to
>> being finished but requires a new owner to do some final testing and
>> polishing. It applies cleanly against top-of-tree xfsprogs-3.0.0
>
> I did a quick look over it on the plane today and it looks quite nice
> to me.

that sounds promising, maybe we have a new owner for this code ;-)

> I guess there are no patch descriptions left anywhere?

The patch series as posted is straight out of Barry's workarea.
The only descriptions are the patch filenames themselves and what's
still in Barry head - you could email him and he may or may not
respond. I do know that he spent quite a lot of time benchmarking
and stressing this code - it should be fairly robust and close to
release quality.

> Otherwise some of the patch might need some minor polishing, e.g.
> the patch moving over from the radix tree to the btree leaves the
> radix-tree implementation in, which gets removed in the next patch
> which has otherwise unrelated changes.

well you could split the radix removal from the unrelated changes,
but the end result is the same, right?

> The btree implementation btw worries me a little, 

all XFS btree implementations continue to be bit of a worry :)

> I wonder if we need
> a test harness to make sure it's correct for all corner cases.

Would the test harness for the factored kernel btrees be adaptable to this
one in userspace? (or could the kernel btree code also be adapted/shared
for use in userspace too?)

BTW, I think Barry also had some changes underway to xfs_repair phase-1,
e.g. to detect missing volume manager pieces (and thus abort the repair
rather than make a dogs breakfast), better backup superblock searching,
etc. He also had plans for utilizing parent pointers, e.g. to practically
eliminate lost+found.

Cheers
-- Mark

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
