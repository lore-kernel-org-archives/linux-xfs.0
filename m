Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 406BE7F4E
	for <xfs@oss.sgi.com>; Tue, 11 Nov 2014 10:02:02 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 2E80A8F8049
	for <xfs@oss.sgi.com>; Tue, 11 Nov 2014 08:01:58 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id T3RFSiArcedcp1we for <xfs@oss.sgi.com>;
	Tue, 11 Nov 2014 08:01:57 -0800 (PST)
Message-ID: <546232F3.6030609@sandeen.net>
Date: Tue, 11 Nov 2014 10:01:55 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs_copy: simplify first_agbno calculation
References: <54613907.2000007@redhat.com>
	<20141111133705.GA38867@bfoster.bfoster>
In-Reply-To: <20141111133705.GA38867@bfoster.bfoster>
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
To: Brian Foster <bfoster@redhat.com>, Eric Sandeen <sandeen@redhat.com>
Cc: Zorro Lang <zlang@redhat.com>, xfs-oss <xfs@oss.sgi.com>

On 11/11/14 7:37 AM, Brian Foster wrote:
> On Mon, Nov 10, 2014 at 04:15:35PM -0600, Eric Sandeen wrote:
>> After ffe9a9a xfsprogs: xfs_copy: fix data corruption of target,
>> xfs_copy started hitting an ASSERT for a 4k sector / 4k blocksize
>> filesystem:
>>
>> # dd if=/dev/zero of=test.img bs=1M count=1024
>> # mkfs.xfs -s size=4096 test.img
>> # xfs_copy test.img xfs.img
>> xfs_copy: xfs_copy.c:720: main: Assertion `((((((xfs_daddr_t)(3 << (mp)->m_sectbb_log)) + 1) * (1<<9)) + first_residue) % source_blocksize) == 0' failed.
>> Aborted
>>
>> I started digging through all the calculations below, and realized
>> that in the end, all it wants is the first filesystem block after
>> the AG header.  XFS_AGFL_BLOCK(mp) + 1 suffices for this purpose;
>> rip out the rest which seems overly complex and apparently bug-prone.
>>
>> I tested this by creating a 4g filesystem with combinations of
>> sector & block size between 512 and 4k, copying in /lib/modules,
>> running an xfs_copy of that, and running repair against the copy;
>> it all looks good.  It took a long time, but I will create a
>> simpler/shorter xfstest based on this.
>>
>> Reported-by: Zorro Lang <zlang@redhat.com>
>> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
>> ---
> 
> Looks Ok to me:
> 
> Reviewed-by: Brian Foster <bfoster@redhat.com>
> 
> I just noticed the bug... so the problem was basically the assumption
> that sector size == BBSIZE?

To be honest, I never quite figured out what the root cause bug
was; bad me.  The previous commit was supposed to *fix* the assumption
that sector size == BBSIZE.  But I got lost in all the gyrations.

I guess maybe I should work that out, but I'm not sure it's worth
it.  ;)

-Eric

> Brian
> 
>>
>> diff --git a/copy/xfs_copy.c b/copy/xfs_copy.c
>> index 7ce5ec9..279527c 100644
>> --- a/copy/xfs_copy.c
>> +++ b/copy/xfs_copy.c
>> @@ -475,7 +475,7 @@ main(int argc, char **argv)
>>  	int		open_flags;
>>  	xfs_off_t	pos, end_pos;
>>  	size_t		length;
>> -	int		c, first_residue, tmp_residue;
>> +	int		c;
>>  	__uint64_t	size, sizeb;
>>  	__uint64_t	numblocks = 0;
>>  	int		wblocks = 0;
>> @@ -697,27 +697,13 @@ main(int argc, char **argv)
>>  	ASSERT(source_blocksize % source_sectorsize == 0);
>>  	ASSERT(source_sectorsize % BBSIZE == 0);
>>  
>> -	if (source_blocksize > source_sectorsize)  {
>> -		/* get number of leftover sectors in last block of ag header */
>> -
>> -		tmp_residue = ((XFS_AGFL_DADDR(mp) + 1) * BBSIZE)
>> -					% source_blocksize;
>> -		first_residue = (tmp_residue == 0) ? 0 :
>> -			source_blocksize - tmp_residue;
>> -		ASSERT(first_residue % source_sectorsize == 0);
>> -	} else if (source_blocksize == source_sectorsize)  {
>> -		first_residue = 0;
>> -	} else  {
>> +	if (source_blocksize < source_sectorsize)  {
>>  		do_log(_("Error:  filesystem block size is smaller than the"
>>  			" disk sectorsize.\nAborting XFS copy now.\n"));
>>  		exit(1);
>>  	}
>>  
>> -	first_agbno = (((XFS_AGFL_DADDR(mp) + 1) * BBSIZE)
>> -				+ first_residue) / source_blocksize;
>> -	ASSERT(first_agbno != 0);
>> -	ASSERT(((((XFS_AGFL_DADDR(mp) + 1) * BBSIZE)
>> -				+ first_residue) % source_blocksize) == 0);
>> +	first_agbno = XFS_AGFL_BLOCK(mp) + 1;
>>  
>>  	/* now open targets */
>>  
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
