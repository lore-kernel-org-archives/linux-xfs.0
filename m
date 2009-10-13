Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n9DNbJY7160549 for <xfs@oss.sgi.com>; Tue, 13 Oct 2009 18:37:19 -0500
Content-class: urn:content-classes:message
MIME-Version: 1.0
Subject: RE: [PATCH 02/14] repair: reduce byte swap operations
	inscanfunc_allocbt
Date: Tue, 13 Oct 2009 18:37:21 -0500
Message-ID: <1AB9A794DBDDF54A8A81BE2296F7BDFE83ADA5@cf--amer001e--3.americas.sgi.com>
In-Reply-To: <4AD364D9.9090306@sandeen.net>
From: "Alex Elder" <aelder@sgi.com>
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
To: Eric Sandeen <sandeen@sandeen.net>, Christoph Hellwig <hch@infradead.org>
Cc: Barry Naujok <bnaujok@sgi.com>, xfs@oss.sgi.com

On , Eric Sandeen wrote:
> Christoph Hellwig wrote:
> 
>> Store native endian version of the extent startblock and length in
>> local variables instead of converting them over and over again.
>> 
>> 
>> Signed-off-by: Barry Naujok <bnaujok@sgi.com>
>> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> I bet there's a lot more places where this could be done too :)

Lots more...

> Reviewed-by: Eric Sandeen <sandeen@sandeen.net>
Reviewed-by: Alex Elder <aelder@sgi.com>

>> Index: xfsprogs-dev/repair/scan.c
>> ===================================================================
>> --- xfsprogs-dev.orig/repair/scan.c	2009-08-21 18:48:01.000000000 +0000
>> +++ xfsprogs-dev/repair/scan.c	2009-08-21 18:54:29.000000000 +0000
>> @@ -449,7 +449,6 @@ scanfunc_allocbt(
>>  	__uint32_t		magic)
>>  {
>>  	const char 		*name;
>> -	xfs_agblock_t		b, e;
>>  	int			i;
>>  	xfs_alloc_ptr_t		*pp;
>>  	xfs_alloc_rec_t		*rp;
>> @@ -509,20 +508,21 @@ _("%s freespace btree block claimed (sta
>> 
>>  		rp = XFS_ALLOC_REC_ADDR(mp, block, 1);
>>  		for (i = 0; i < numrecs; i++) {
>> -			if (be32_to_cpu(rp[i].ar_blockcount) == 0 ||
>> -			    be32_to_cpu(rp[i].ar_startblock) == 0 ||
>> -			    !verify_agbno(mp, agno,
>> -				be32_to_cpu(rp[i].ar_startblock)) ||
>> -			    be32_to_cpu(rp[i].ar_blockcount) >
>> -					MAXEXTLEN)
>> -				continue;
>> +			xfs_agblock_t		b, end;
>> +			xfs_extlen_t		len;
>> +
>> +			b = be32_to_cpu(rp[i].ar_startblock);
>> +			len = be32_to_cpu(rp[i].ar_blockcount);
>> +			end = b + len;
>> 
>> -			e = be32_to_cpu(rp[i].ar_startblock) +
>> -				be32_to_cpu(rp[i].ar_blockcount);
>> -			if (!verify_agbno(mp, agno, e - 1))
>> +			if (b == 0 || !verify_agbno(mp, agno, b))
>> +				continue;
>> +			if (len == 0 || len > MAXEXTLEN)
>>  				continue;
>> -			for (b = be32_to_cpu(rp[i].ar_startblock);
>> -			     b < e; b++)  {
>> +			if (!verify_agbno(mp, agno, end - 1))
>> +				continue;
>> +
>> +			for ( ; b < end; b++)  {
>>  				state = get_agbno_state(mp, agno, b);
>>  				switch (state) {
>>  				case XR_E_UNKNOWN:
>> @@ -579,6 +579,8 @@ _("%s freespace btree block claimed (sta  	}
>> 
>>  	for (i = 0; i < numrecs; i++)  {
>> +		xfs_agblock_t		bno = be32_to_cpu(pp[i]);
>> +
>>  		/*
>>  		 * XXX - put sibling detection right here.
>>  		 * we know our sibling chain is good.  So as we go,
>> @@ -588,11 +590,11 @@ _("%s freespace btree block claimed (sta
>>  		 * pointer mismatch, try and extract as much data
>>  		 * as possible.
>>  		 */
>> -		if (be32_to_cpu(pp[i]) != 0 && verify_agbno(mp, agno,
>> -							be32_to_cpu(pp[i])))
>> -			scan_sbtree(be32_to_cpu(pp[i]), level, agno, suspect,
>> +		if (bno != 0 && verify_agbno(mp, agno, bno)) {
>> +			scan_sbtree(bno, level, agno, suspect,
>>  				    (magic == XFS_ABTB_MAGIC) ?
>>  				    	scanfunc_bno : scanfunc_cnt, 0);
>> +		}
>>  	}
>>  }
>> 
>> 
>> _______________________________________________
>> xfs mailing list
>> xfs@oss.sgi.com
>> http://oss.sgi.com/mailman/listinfo/xfs
>> 
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
