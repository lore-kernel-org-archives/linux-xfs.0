Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id CFB667F59
	for <xfs@oss.sgi.com>; Sun, 11 Oct 2015 20:33:47 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id B0FB58F804B
	for <xfs@oss.sgi.com>; Sun, 11 Oct 2015 18:33:47 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id 53xAI0DMGEubmgzN for <xfs@oss.sgi.com>;
	Sun, 11 Oct 2015 18:33:42 -0700 (PDT)
Mime-Version: 1.0 (1.0)
Subject: Re: [PATCH 2/4] xfs_repair: fix unaligned accesses
From: Eric Sandeen <sandeen@sandeen.net>
In-Reply-To: <20151011222618.GX27164@dastard>
Date: Sun, 11 Oct 2015 20:33:41 -0500
Message-Id: <52FCE688-8D54-4304-A8F4-0621B47E9320@sandeen.net>
References: <56170906.5090301@redhat.com> <56170974.5020604@sandeen.net>
	<20151011222618.GX27164@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Oct 11, 2015, at 5:26 PM, Dave Chinner <david@fromorbit.com> wrote:
> 
>> On Thu, Oct 08, 2015 at 07:25:24PM -0500, Eric Sandeen wrote:
>> This fixes some unaligned accesses spotted by libubsan in repair.
>> 
>> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
>> ---
>> repair/dinode.c   |   19 +++++++++----------
>> repair/prefetch.c |    4 ++--
>> 2 files changed, 11 insertions(+), 12 deletions(-)
>> 
>> diff --git a/repair/dinode.c b/repair/dinode.c
>> index f78f907..44bbb8f 100644
>> --- a/repair/dinode.c
>> +++ b/repair/dinode.c
>> @@ -960,13 +960,13 @@ _("bad numrecs 0 in inode %" PRIu64 " bmap btree root block\n"),
>>         * btree, we'd do it right here.  For now, if there's a
>>         * problem, we'll bail out and presumably clear the inode.
>>         */
>> -        if (!verify_dfsbno(mp, be64_to_cpu(pp[i])))  {
>> +        if (!verify_dfsbno(mp, get_unaligned_be64(&pp[i])))  {
> 
> I don't understand - when are pointers in the BMBT not 64 bit
> aligned? The buffers are allocated by memalign to be 64 bit aligned,
> and all the internal BMBT structures are 64 bit aligned, too. i.e
> the BMBT block header is 24/72 bytes in length (depending on CRCs),
> the pointers are 64 bit, and the records are 128 bit.
> 
> So where's the unaligned access coming from?
> 
Hrm, I'm sure I hit it and just took it at face value, sorry - I'll run through it again and look more closely...

Thanks,
Eric

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
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
