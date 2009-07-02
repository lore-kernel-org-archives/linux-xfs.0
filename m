Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n62JuCwC109019 for <xfs@oss.sgi.com>; Thu, 2 Jul 2009 14:56:12 -0500
Received: from mx2.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 099D89CB404
	for <xfs@oss.sgi.com>; Thu,  2 Jul 2009 13:03:08 -0700 (PDT)
Received: from mx2.redhat.com (mx2.redhat.com [66.187.237.31]) by cuda.sgi.com
	with ESMTP id ZgW98gxKm9WN49cs for <xfs@oss.sgi.com>;
	Thu, 02 Jul 2009 13:03:08 -0700 (PDT)
Message-ID: <4A4D10ED.70506@sandeen.net>
Date: Thu, 02 Jul 2009 14:56:29 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs_metadump: agcount*agblocks overflow
References: <4A4CE85B.1030102@sandeen.net>
	<20090702192903.GA13919@infradead.org>
In-Reply-To: <20090702192903.GA13919@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs mailing list <xfs@oss.sgi.com>

Christoph Hellwig wrote:
> On Thu, Jul 02, 2009 at 12:03:23PM -0500, Eric Sandeen wrote:
>> Found another potential overflow in xfs_metadump,
>> similar to those just fixed in repair.
>>
>> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
>> --
>>
>> diff --git a/db/metadump.c b/db/metadump.c
>> index 19aed4f..ef6e571 100644
>> --- a/db/metadump.c
>> +++ b/db/metadump.c
>> @@ -222,7 +222,8 @@ valid_bno(
>>  		return 1;
>>  	if (agno == (mp->m_sb.sb_agcount - 1) && agbno > 0 &&
>>  			agbno <= (mp->m_sb.sb_dblocks -
>> -			 (mp->m_sb.sb_agcount - 1) * mp->m_sb.sb_agblocks))
>> +			 (xfs_drfsbno_t)(mp->m_sb.sb_agcount - 1) *
>> +			 mp->m_sb.sb_agblocks))
>>  		return 1;
>>  
>>  	return 0;
> 
> I have a really hard time reading the function (both before and after
> your patch).  It's a real mess and no wonder we have these overflow
> problems here.  What about the following instead:

well, I think the original goal was to make it efficient for the common
case.  How muchthis matters, not really sure.  (at least that's the
comment in the xfs_repair counterpart)

> static int
> valid_bno(
> 	xfs_agnumber_t		agno,
> 	xfs_agblock_t		agbno)
> {
> 	xfs_agnumber_t		last_agno = mp->m_sb.sb_agcount - 1;
> 	xfs_drfsbno_t		nblocks;
> 
> 	/*
> 	 * The first block in every AG contains a backups superblock,
> 	 * and is copied separately, and we can skip it early as an
> 	 * optimization.
> 	 */
> 	if (agbno == 0)
> 		return 0;
> 
> 	/*
> 	 * An invalid AG number is never okay.
> 	 */
> 	if (agno > last_agno)
> 		return 0;
> 
> 	if (agno == last_agno) {
> 		nblocks = mp->m_sb.sb_dblocks -
> 			((xfs_drfsbno_t)mp->m_sb.sb_agblocks *
> 			 (mp->m_sb.sb_agcount - 1));
> 	} else {
> 		nblocks = mp->m_sb.sb_agblocks);
> 	}
> 	
> 	if (agbno > nblocks)
> 		return 0;
> 	return 1;
> }
> 
> and with that form I wonder if we don't still have an off-by-one
> in the last if clause - shouldn't the agblocks be the count of blocks
> while agbno is an indes and thus 0-based?
> 
> Btw, do you have a testcase for this?

no testcase here, though could craft one.  I discovered it on Jesse's
corruptd fs (very big metadump image)

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
