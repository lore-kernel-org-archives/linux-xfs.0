Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id D59097F3F
	for <xfs@oss.sgi.com>; Wed, 19 Feb 2014 10:12:40 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id CBC99304097
	for <xfs@oss.sgi.com>; Wed, 19 Feb 2014 08:12:37 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id buae4hhGSJCt8dkM for <xfs@oss.sgi.com>;
	Wed, 19 Feb 2014 08:12:32 -0800 (PST)
Message-ID: <5304D7EE.8050406@sandeen.net>
Date: Wed, 19 Feb 2014 10:12:30 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH 9/9] xfs: modify verifiers to differentiate CRC from other
	errors
References: <1392767549-25574-1-git-send-email-sandeen@redhat.com>	<1392767549-25574-10-git-send-email-sandeen@redhat.com>
	<5304B941.5090800@redhat.com>
In-Reply-To: <5304B941.5090800@redhat.com>
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
To: Brian Foster <bfoster@redhat.com>, Eric Sandeen <sandeen@redhat.com>, xfs@oss.sgi.com

On 2/19/14, 8:01 AM, Brian Foster wrote:
> On 02/18/2014 06:52 PM, Eric Sandeen wrote:
>> Modify all read & write verifiers to differentiate
>> between CRC errors and other inconsistencies.
>>
>> This sets the appropriate error number on bp->b_error,
>> and then calls xfs_verifier_error() if something went
>> wrong.  That function will issue the appropriate message
>> to the user.
>>
>> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
>> ---

...

>> @@ -485,14 +484,13 @@ xfs_agfl_read_verify(
>>  	if (!xfs_sb_version_hascrc(&mp->m_sb))
>>  		return;
>>  
>> -	agfl_ok = xfs_buf_verify_cksum(bp, XFS_AGFL_CRC_OFF);
>> -
>> -	agfl_ok = agfl_ok && xfs_agfl_verify(bp);
>> -
>> -	if (!agfl_ok) {
>> -		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp, bp->b_addr);
>> +	if (!xfs_buf_verify_cksum(bp, offsetof(struct xfs_agfl, agfl_crc)))
>> +		xfs_buf_ioerror(bp, EFSBADCRC);
>> +	else if (!xfs_agfl_verify(bp))
> 
> Obviously you added the CRC_OFF directives earlier in the set. It looks
> like this patch squashed a couple of them (XFS_AGF_CRC_OFF as well).

Whoops, no idea how that happened :/ Thanks.

>>  		xfs_buf_ioerror(bp, EFSCORRUPTED);
>> -	}
>> +
>> +	if (bp->b_error)
>> +		xfs_verifier_error(bp);
>>  }
>>  
> ...
>> diff --git a/fs/xfs/xfs_ialloc.c b/fs/xfs/xfs_ialloc.c
>> index 4657586..8aa720d 100644
>> --- a/fs/xfs/xfs_ialloc.c
>> +++ b/fs/xfs/xfs_ialloc.c
>> @@ -1573,13 +1573,17 @@ xfs_agi_read_verify(
>>  	if (xfs_sb_version_hascrc(&mp->m_sb))
>>  		agi_ok = xfs_buf_verify_cksum(bp, XFS_AGI_CRC_OFF);
>>  
>> +	if (!agi_ok)
>> +		xfs_buf_ioerror(bp, EFSBADCRC);
>> +
>>  	agi_ok = agi_ok && xfs_agi_verify(bp);
>>  
>>  	if (unlikely(XFS_TEST_ERROR(!agi_ok, mp, XFS_ERRTAG_IALLOC_READ_AGI,
>> -			XFS_RANDOM_IALLOC_READ_AGI))) {
>> -		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp, bp->b_addr);
>> +			XFS_RANDOM_IALLOC_READ_AGI)))
>>  		xfs_buf_ioerror(bp, EFSCORRUPTED);
>> -	}
>> +
>> +	if (bp->b_error)
>> +		xfs_verifier_error(bp);
>>  }
> 
> Any reason not to use the same if/else pattern here that the others are
> now using (i.e., similar to xfs_agf_read_verify(), removing the need for
> agi_ok)?

Hm I was thinking it was the weird XFS_TEST_ERROR construction but
xfs_agf_read_verify has that too.  I'll take another look, thanks.

(TBH all these verifiers are so similar, I wish there were a way
to not do so much of what is essentially cut and paste with different
error tags & offsets...)

Thanks for the careful review,

-Eric

> Brian

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
