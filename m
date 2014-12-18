Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 8A6477F9A
	for <xfs@oss.sgi.com>; Thu, 18 Dec 2014 10:43:10 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 79542304039
	for <xfs@oss.sgi.com>; Thu, 18 Dec 2014 08:43:06 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id ttdYeNCOSeThTxF2 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 18 Dec 2014 08:43:05 -0800 (PST)
Received: from int-mx14.intmail.prod.int.phx2.redhat.com
	(int-mx14.intmail.prod.int.phx2.redhat.com [10.5.11.27])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id sBIGh4Mk024684
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=FAIL) for <xfs@oss.sgi.com>; Thu, 18 Dec 2014 11:43:05 -0500
Message-ID: <54930417.7030601@redhat.com>
Date: Thu, 18 Dec 2014 10:43:03 -0600
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs_repair: fix max block offset test
References: <5489DA3B.5050908@redhat.com>
	<20141218151835.GC13471@laptop.bfoster>
In-Reply-To: <20141218151835.GC13471@laptop.bfoster>
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
Cc: Eryu Guan <eguan@redhat.com>, xfs-oss <xfs@oss.sgi.com>

On 12/18/14 9:18 AM, Brian Foster wrote:

> Thought this looked familiar:
> 
> http://oss.sgi.com/archives/xfs/2014-09/msg00524.html

oh, whoops.  let me go read that, sorry!

-Eric

> Either one is fine with me. If we use the fix below, I think we should
> update the error message since it technically refers to the extent
> offset and we slightly tweak the meaning of the failure.
> 
> Brian
> 
>>
>> diff --git a/repair/dinode.c b/repair/dinode.c
>> index 38a6562..ca57a61 100644
>> --- a/repair/dinode.c
>> +++ b/repair/dinode.c
>> @@ -667,7 +667,9 @@ _("inode %" PRIu64 " - bad extent overflows - start %" PRIu64 ", "
>>  					irec.br_startoff);
>>  				goto done;
>>  		}
>> -		if (irec.br_startoff >= fs_max_file_offset)  {
>> +		/* Ensure this extent does not extend beyond the max offset */
>> +		if (irec.br_startoff + irec.br_blockcount - 1 >
>> +							fs_max_file_offset) {
>>  			do_warn(
>>  _("inode %" PRIu64 " - extent offset too large - start %" PRIu64 ", "
>>    "count %" PRIu64 ", offset %" PRIu64 "\n"),
>>
>> _______________________________________________
>> xfs mailing list
>> xfs@oss.sgi.com
>> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
