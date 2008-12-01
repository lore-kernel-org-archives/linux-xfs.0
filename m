Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mB1NVB7Q029149 for <xfs@oss.sgi.com>; Mon, 1 Dec 2008 17:31:11 -0600
Date: Tue, 02 Dec 2008 10:31:16 +1100
Subject: Re: [REVIEW] Fix unaligned accesses in IA64 in xfsprogs
From: "Barry Naujok" <bnaujok@sgi.com>
MIME-Version: 1.0
References: <op.ulg0j1bf3jf8g2@pc-bnaujok.melbourne.sgi.com>
	<20081201134205.GA7528@infradead.org>
Message-ID: <op.ulibmezc3jf8g2@pc-bnaujok.melbourne.sgi.com>
In-Reply-To: <20081201134205.GA7528@infradead.org>
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
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Tue, 02 Dec 2008 00:42:05 +1100, Christoph Hellwig <hch@infradead.org>  
wrote:

> On Mon, Dec 01, 2008 at 05:34:39PM +1100, Barry Naujok wrote:
>> xfs_repair is the main culprit when getting disk extents which aren't
>> properly aligned in memory. This patch does not call
>> xfs_bmbt_disk_get_all directly anymore but does an unaligned get on
>> the disk extent record and calls xfs_bmbt_get_all which is host-based
>> like the rest of the kernel routines do.
>
> What about just doin the get_unaligned in xfs_bmbt_disk_get_all?  That
> way we could just use it everywhere.  The only users that don't need
> the get_unaligned are in the tracing code, and I don't think we should
> be worried about that little bit of overhead.
>
>> @@ -277,21 +277,17 @@ convert_extent(
>>   	xfs_dfilblks_t		*cp,
>>   	int			*fp)
>>   {
>
> And then we could replace this helper with a direct call to
> xfs_bmbt_disk_get_all as the caller would be much cleaner with a
> xfs_bmbt_irec_t on the stack anyway..

It's a libxfs/kernel function, so ideally, it should be also ported
into the kernel space and possible kernel cleanups along with it.

>> --- a/xfsprogs/repair/dino_chunks.c	2008-12-01 17:10:37.000000000 +1100
>> +++ b/xfsprogs/repair/dino_chunks.c	2008-12-01 16:11:11.549834281 +1100
>> @@ -609,7 +609,8 @@ process_inode_chunk(
>>   	if (blks_per_cluster == 0)
>>   		blks_per_cluster = 1;
>>   	cluster_count = XFS_INODES_PER_CHUNK / inodes_per_cluster;
>> -	ASSERT(cluster_count > 0);
>> +	if (cluster_count == 0)
>> +		cluster_count = 1;
>
> I can't see how this is related.

Another IA64 fix.


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
