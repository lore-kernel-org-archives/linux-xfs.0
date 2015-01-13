Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 966F77F3F
	for <xfs@oss.sgi.com>; Tue, 13 Jan 2015 08:23:26 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 849E230408C
	for <xfs@oss.sgi.com>; Tue, 13 Jan 2015 06:23:23 -0800 (PST)
Received: from mail-qg0-f49.google.com (mail-qg0-f49.google.com
	[209.85.192.49]) by cuda.sgi.com with ESMTP id fh8gwraAxuZtkAJ9
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 13 Jan 2015 06:23:19 -0800 (PST)
Received: by mail-qg0-f49.google.com with SMTP id f51so2280889qge.8
	for <xfs@oss.sgi.com>; Tue, 13 Jan 2015 06:23:19 -0800 (PST)
Message-ID: <54B52A4F.5070504@gmail.com>
Date: Tue, 13 Jan 2015 09:23:11 -0500
From: "Michael L. Semon" <mlsemon35@gmail.com>
MIME-Version: 1.0
Subject: Re: [RFC] xfs: remedy small writes during wrapped-log recovery
References: <54B033ED.9010805@gmail.com>
	<20150112153022.GB25944@bfoster.bfoster>
In-Reply-To: <20150112153022.GB25944@bfoster.bfoster>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Brian Foster <bfoster@redhat.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On 01/12/15 10:30, Brian Foster wrote:
> On Fri, Jan 09, 2015 at 03:02:53PM -0500, Michael L. Semon wrote:
>> Hi!  I like this patch and am confident with it on x86.  However,
>> a) it has no x86_64 coverage; and b) xfstests xfs/306 in particular
>> emits more of this output:
>>
>>     buffer_io_error: nnnn callbacks suppressed
>>
>> Might someone evaluate this patch or the intent of the patch?
>>
>> The intent:
>>
>> For XFS filesystems that don't change much, such as the /boot and
>> alternate / partitions here, mount times were about 17s instead of
>> 0.4s while the log is in a wrapped state, write caches off.  This 
>> patch fixes the issue on v4- and v5-superblock XFS filesystems.
>>
>> xfs_repair can solve this issue short-term and also cut wrapped-log 
>> mount time in half short-term for v5 file systems.  Don't know if 
>> that's a mkfs.xfs issue or just coincidence.
>>
>> A bisect still needs to be done to determine when the slow mount 
>> behavior started.  It could very well be that somebody fixed the 
>> buffer_io_error messages that I saw long ago, and the solution made 
>> some mounts here rather miserable.
>>
>> Thanks!
>>
>> Michael
>>
>> The patch:
>>
>> xlog_write_log_records() has an algorithm to "Greedily allocate a
>> buffer big enough...," starting with ffs(blocks), adding two sensible
>> checks, and then feeding it to a loop with checks of its own.
>>
>> However, when blocks is an odd number, the number that becomes nbblks
>> to the xlog_bwrite() function ends up being 2 (1 << 1).  The most
>> obvious effect is that when the log wraps, a write of two odd-sized
>> log regions on an 8-GB XFS filesystem will take around 2049 calls 
>> to xlog_bwrite() instead of the "two separate I/Os" suggested in
>> xlog_clear_stale_blocks().
>>
>> Fix this by changing the ffs(blocks) to fls(blocks).
>>
>> There is a similar ffs(blocks) check in xlog_find_verify_cycle().
>> This was not investigated.
>>
>> Signed-off-by: Michael L. Semon <mlsemon35@gmail.com>
>> ---
>>  fs/xfs/xfs_log_recover.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
>> index a5a945f..13381eb 100644
>> --- a/fs/xfs/xfs_log_recover.c
>> +++ b/fs/xfs/xfs_log_recover.c
>> @@ -1242,7 +1242,7 @@ xlog_write_log_records(
>>  	 * a smaller size.  We need to be able to write at least a
>>  	 * log sector, or we're out of luck.
>>  	 */
>> -	bufblks = 1 << ffs(blocks);
>> +	bufblks = 1 << fls(blocks);
> 
> Interesting, it does seem like there is a bug here. Thanks for the
> test code to help reproduce.
> 
> The fix seems reasonable to me, but I'm also wondering if there is at
> least one other bug in this code. In the middle of that loop, we have
> the following:
> 
> 	...
> 
> 	/* We may need to do a read at the end to fill in part of
>  	* the buffer in the final sector not covered by the write.
>  	* If this is the same sector as the above read, skip it.
>  	*/
> 	ealign = round_down(end_block, sectbb);
> 	if (j == 0 && (start_block + endcount > ealign)) {
> 		offset = bp->b_addr + BBTOB(ealign - start_block);
> 		error = xlog_bread_offset(log, ealign, sectbb,
> 						bp, offset);
> 		...
> 	}
> 	...
> 
> ... but how have we really confirmed whether the end sector is
> equivalent to the first sector? It looks to me that we operate at basic
> block granularity but log I/O is managed at log sector alignment. So if
> the start basic block is not sector aligned, we read in the first sector
> and add records at the associated buffer offset. Similar if the end
> block is not sector aligned. If the buffer size spans multiple sectors
> and the start and end are not aligned, it looks like we could skip the
> read of the final sector.

> Perhaps I'm missing some context as to why this wouldn't occur..? It
> also seems strange that the offset calculation above uses start_block as
> the baseline start block value of the buffer, but the pre-loop balign
> code suggests the buffer might not be aligned to start_block...
> 
> Brian

I'm currently stumped on getting this code to fire.  For that matter, all 
blk_no and nbblks numbers are coming in to xlog_bwrite() neatly pre-
rounded, so the rounding functions in there don't change anything.  In 
all, an unsuccessful testing effort on my part.

Maybe the "env MKFS_OPTIONS='-m crc=1,finobt=1 -s size=4096' ./check -g 
auto" xfstests run will cough something up.  It will be waiting at home, 
at the end of the day.

Should I use fdisk on a spare disk and deliberately misalign the 
partitions?  Otherwise, there's a struggle to find misalignments, and 
my idea bucket was not very full, anyway ;-)

Thanks!

Michael

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
