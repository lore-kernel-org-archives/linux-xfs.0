Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id AB7AE7F5F
	for <xfs@oss.sgi.com>; Fri,  9 Oct 2015 09:03:31 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 2C16EAC00D
	for <xfs@oss.sgi.com>; Fri,  9 Oct 2015 07:03:27 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id 4AFr3T8GIziHY9ai for <xfs@oss.sgi.com>;
	Fri, 09 Oct 2015 07:03:09 -0700 (PDT)
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.4])
	(using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id D764D6567AA2
	for <xfs@oss.sgi.com>; Fri,  9 Oct 2015 09:03:08 -0500 (CDT)
Subject: Re: [PATCH 2/4] xfs_repair: fix unaligned accesses
References: <56170906.5090301@redhat.com> <56170974.5020604@sandeen.net>
	<20151009132433.GC27982@bfoster.bfoster>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <5617C91C.10203@sandeen.net>
Date: Fri, 9 Oct 2015 09:03:08 -0500
MIME-Version: 1.0
In-Reply-To: <20151009132433.GC27982@bfoster.bfoster>
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
To: xfs@oss.sgi.com



On 10/9/15 8:24 AM, Brian Foster wrote:
> On Thu, Oct 08, 2015 at 07:25:24PM -0500, Eric Sandeen wrote:
>> This fixes some unaligned accesses spotted by libubsan in repair.
>>
> 
> Could we add a couple sentences about why this is a problem? I take it
> unaligned accesses are "bad" on certain arches..?

To the commit perhaps?  Probably not in the code, we have lots of
places that do this trick, or use [get|put]_unaligned_be[32|64]
with no explanation of the problem.

Documentation/unaligned-memory-access.txt in the kernel covers
it:

Why unaligned access is bad
===========================

The effects of performing an unaligned memory access vary from architecture
to architecture. It would be easy to write a whole document on the differences
here; a summary of the common scenarios is presented below:

 - Some architectures are able to perform unaligned memory accesses
   transparently, but there is usually a significant performance cost.
 - Some architectures raise processor exceptions when unaligned accesses
   happen. The exception handler is able to correct the unaligned access,
   at significant cost to performance.
 - Some architectures raise processor exceptions when unaligned accesses
   happen, but the exceptions do not contain enough information for the
   unaligned access to be corrected.
 - Some architectures are not capable of unaligned memory access, but will
   silently perform a different memory access to the one that was requested,
   resulting in a subtle code bug that is hard to detect!

It should be obvious from the above that if your code causes unaligned
memory accesses to happen, your code will not work correctly on certain
platforms and will cause performance problems on others.

Maybe I can refer to that in the commit?

>> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
>> ---
>>  repair/dinode.c   |   19 +++++++++----------
>>  repair/prefetch.c |    4 ++--
>>  2 files changed, 11 insertions(+), 12 deletions(-)
>>
>> diff --git a/repair/dinode.c b/repair/dinode.c
>> index f78f907..44bbb8f 100644
>> --- a/repair/dinode.c
>> +++ b/repair/dinode.c
>> @@ -960,13 +960,13 @@ _("bad numrecs 0 in inode %" PRIu64 " bmap btree root block\n"),
>>  		 * btree, we'd do it right here.  For now, if there's a
>>  		 * problem, we'll bail out and presumably clear the inode.
>>  		 */
>> -		if (!verify_dfsbno(mp, be64_to_cpu(pp[i])))  {
>> +		if (!verify_dfsbno(mp, get_unaligned_be64(&pp[i])))  {
>>  			do_warn(_("bad bmap btree ptr 0x%llx in ino %" PRIu64 "\n"),
>> -			       (unsigned long long) be64_to_cpu(pp[i]), lino);
>> +			       get_unaligned_be64(&pp[i]), lino);
>>  			return(1);
>>  		}
>>  
>> -		if (scan_lbtree(be64_to_cpu(pp[i]), level, scan_bmapbt, type,
>> +		if (scan_lbtree(get_unaligned_be64(&pp[i]), level, scan_bmapbt, type,
>>  				whichfork, lino, tot, nex, blkmapp, &cursor,
>>  				1, check_dups, magic, &xfs_bmbt_buf_ops))
>>  			return(1);
>> @@ -977,25 +977,24 @@ _("bad numrecs 0 in inode %" PRIu64 " bmap btree root block\n"),
>>  		 * blocks but the parent hasn't been updated
>>  		 */
>>  		if (!check_dups && cursor.level[level-1].first_key !=
>> -					be64_to_cpu(pkey[i].br_startoff))  {
>> +				   get_unaligned_be64(&pkey[i].br_startoff)) {
>>  			if (!no_modify)  {
>>  				do_warn(
>>  	_("correcting key in bmbt root (was %llu, now %" PRIu64") in inode "
>>  	  "%" PRIu64" %s fork\n"),
>> -				       (unsigned long long)
>> -					       be64_to_cpu(pkey[i].br_startoff),
>> +					get_unaligned_be64(&pkey[i].br_startoff),
>>  					cursor.level[level-1].first_key,
>>  					XFS_AGINO_TO_INO(mp, agno, ino),
>>  					forkname);
>>  				*dirty = 1;
>> -				pkey[i].br_startoff = cpu_to_be64(
>> -					cursor.level[level-1].first_key);
>> +				put_unaligned_be64(
>> +					cpu_to_be64(cursor.level[level-1].first_key),
>> +					&pkey[i].br_startoff);
> 
> I could be confused here... but if get_unaligned_be64() takes a be64 and
> transforms to cpu order, shouldn't put_unaligned_be64() take a cpu order
> parameter? Is this a double byte order swap?
> 
> Brian
> 
>>  			} else  {
>>  				do_warn(
>>  	_("bad key in bmbt root (is %llu, would reset to %" PRIu64 ") in inode "
>>  	  "%" PRIu64 " %s fork\n"),
>> -				       (unsigned long long)
>> -					       be64_to_cpu(pkey[i].br_startoff),
>> +					get_unaligned_be64(&pkey[i].br_startoff),
>>  					cursor.level[level-1].first_key,
>>  					XFS_AGINO_TO_INO(mp, agno, ino),
>>  					forkname);
>> diff --git a/repair/prefetch.c b/repair/prefetch.c
>> index 32ec55e..52238ca 100644
>> --- a/repair/prefetch.c
>> +++ b/repair/prefetch.c
>> @@ -330,7 +330,7 @@ pf_scanfunc_bmap(
>>  	pp = XFS_BMBT_PTR_ADDR(mp, block, 1, mp->m_bmap_dmxr[1]);
>>  
>>  	for (i = 0; i < numrecs; i++) {
>> -		dbno = be64_to_cpu(pp[i]);
>> +		dbno = get_unaligned_be64(&pp[i]);
>>  		if (!verify_dfsbno(mp, dbno))
>>  			return 0;
>>  		if (!pf_scan_lbtree(dbno, level, isadir, args, pf_scanfunc_bmap))
>> @@ -372,7 +372,7 @@ pf_read_btinode(
>>  	pp = XFS_BMDR_PTR_ADDR(dib, 1, xfs_bmdr_maxrecs(dsize, 0));
>>  
>>  	for (i = 0; i < numrecs; i++) {
>> -		dbno = be64_to_cpu(pp[i]);
>> +		dbno = get_unaligned_be64(&pp[i]);
>>  		if (!verify_dfsbno(mp, dbno))
>>  			break;
>>  		if (!pf_scan_lbtree(dbno, level, isadir, args, pf_scanfunc_bmap))
>> -- 
>> 1.7.1
>>
>> _______________________________________________
>> xfs mailing list
>> xfs@oss.sgi.com
>> http://oss.sgi.com/mailman/listinfo/xfs
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
