Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 343597F5A
	for <xfs@oss.sgi.com>; Mon, 12 Oct 2015 16:31:39 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 265058F8035
	for <xfs@oss.sgi.com>; Mon, 12 Oct 2015 14:31:35 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id XbEVAFH0nVz0B19s for <xfs@oss.sgi.com>;
	Mon, 12 Oct 2015 14:31:33 -0700 (PDT)
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.4])
	(using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id 6238663C3A31
	for <xfs@oss.sgi.com>; Mon, 12 Oct 2015 16:31:33 -0500 (CDT)
Subject: Re: [PATCH 2/4] xfs_repair: fix unaligned accesses
References: <56170906.5090301@redhat.com> <56170974.5020604@sandeen.net>
	<20151011222618.GX27164@dastard>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <561C26B4.3080008@sandeen.net>
Date: Mon, 12 Oct 2015 16:31:32 -0500
MIME-Version: 1.0
In-Reply-To: <20151011222618.GX27164@dastard>
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



On 10/11/15 5:26 PM, Dave Chinner wrote:
> On Thu, Oct 08, 2015 at 07:25:24PM -0500, Eric Sandeen wrote:
>> This fixes some unaligned accesses spotted by libubsan in repair.
>>
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
> 
> I don't understand - when are pointers in the BMBT not 64 bit
> aligned? The buffers are allocated by memalign to be 64 bit aligned,
> and all the internal BMBT structures are 64 bit aligned, too. i.e
> the BMBT block header is 24/72 bytes in length (depending on CRCs),
> the pointers are 64 bit, and the records are 128 bit.
> 
> So where's the unaligned access coming from?

Ok, so on a recheck, I'm not crazy w.r.t. what gcc said, anyway:

dinode.c:964:26: runtime error: load of misaligned address 0x7fc4f800ef54 for type 'xfs_bmbt_ptr_t', which requires 8 byte alignment
0x7fc4f800ef54: note: pointer points here
  00 00 00 00 00 00 00 00  00 20 38 5e 00 00 00 00  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00
              ^ 

with some added printfs, it came from:

        pp = XFS_BMDR_PTR_ADDR(dib, 1,
                xfs_bmdr_maxrecs(XFS_DFORK_SIZE(dip, mp, whichfork), 0));
        printf("dib at %p pp at %p\n", dib, pp);

dib at 0x7fc4f800eeb0 pp at 0x7fc4f800ef54

so pp is at not an 8-multiple away from dib ...now how'd that happen?

#define XFS_BMDR_PTR_ADDR(block, index, maxrecs) \
        ((xfs_bmdr_ptr_t *) \
                ((char *)(block) + \
                 sizeof(struct xfs_bmdr_block) + \
                 (maxrecs) * sizeof(xfs_bmdr_key_t) + \
                 ((index) - 1) * sizeof(xfs_bmdr_ptr_t)))

xfs_bmdr_block is 32 bits, not 64.

But everything in my patch is BMDR not BMBT, right?  I don't think I
ran into any problems in BMBT land, and

#define XFS_BMBT_PTR_ADDR(mp, block, index, maxrecs) \
        ((xfs_bmbt_ptr_t *) \
                ((char *)(block) + \
                 XFS_BMBT_BLOCK_LEN(mp) + \
                 (maxrecs) * sizeof(xfs_bmbt_key_t) + \
                 ((index) - 1) * sizeof(xfs_bmbt_ptr_t)))

all those offsets seem fine.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
