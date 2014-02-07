Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 690F87F51
	for <xfs@oss.sgi.com>; Thu,  6 Feb 2014 22:23:51 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 324348F8070
	for <xfs@oss.sgi.com>; Thu,  6 Feb 2014 20:23:50 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id Z1CUy6Sb3wmLzNM4 for <xfs@oss.sgi.com>;
	Thu, 06 Feb 2014 20:23:49 -0800 (PST)
Message-ID: <52F45FD4.1080009@sandeen.net>
Date: Thu, 06 Feb 2014 22:23:48 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs: limit superblock corruption errors to probable
	corruption
References: <52E88D8B.90208@redhat.com>
	<52EAB56D.2050203@redhat.com>	<52EAB66E.204@redhat.com>
	<52EABBF8.5070309@redhat.com> <20140206064314.GM13997@dastard>
In-Reply-To: <20140206064314.GM13997@dastard>
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
To: Dave Chinner <david@fromorbit.com>, Brian Foster <bfoster@redhat.com>
Cc: Eric Sandeen <sandeen@redhat.com>, xfs-oss <xfs@oss.sgi.com>

On 2/6/14, 12:43 AM, Dave Chinner wrote:
> On Thu, Jan 30, 2014 at 03:54:16PM -0500, Brian Foster wrote:
>> On 01/30/2014 03:30 PM, Eric Sandeen wrote:
>>> On 1/30/14, 2:26 PM, Brian Foster wrote:
>>>>> diff --git a/fs/xfs/xfs_sb.c b/fs/xfs/xfs_sb.c
>>>>>> index 511cce9..b575317 100644
>>>>>> --- a/fs/xfs/xfs_sb.c
>>>>>> +++ b/fs/xfs/xfs_sb.c
>>>>>> @@ -617,6 +617,8 @@ xfs_sb_read_verify(
>>>>>>  			/* Only fail bad secondaries on a known V5 filesystem */
>>>>>>  			if (bp->b_bn != XFS_SB_DADDR &&
>>>>>>  			    xfs_sb_version_hascrc(&mp->m_sb)) {
>>>>>> +				XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW,
>>>>>> +						     mp, bp->b_addr);
>>>>>>  				error = EFSCORRUPTED;
>>>>>>  				goto out_error;
>>>>>>  			}
>>>>>> @@ -625,12 +627,8 @@ xfs_sb_read_verify(
>>>>>>  	error = xfs_sb_verify(bp, true);
>>>>>>  
>>>>>>  out_error:
>>>>>> -	if (error) {
>>>>>> -		if (error != EWRONGFS)
>>>>>> -			XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW,
>>>>>> -					     mp, bp->b_addr);
>>>>>> +	if (error)
>>>>>>  		xfs_buf_ioerror(bp, error);
>>>>>> -	}
>>>>>>  }
>>>> ... but why not leave the corruption output here in out_error, change
>>>> the check to (error == EFSCORRUPTED) and remove the now duplicate
>>>> corruption message in xfs_mount_validate_sb() (or replace it with a
>>>> warn/notice message)? This would catch the other EFSCORRUPTED returns in
>>>> a consistent manner, including another potential duplicate in the write
>>>> verifier. I guess we'd lose a little specificity between the crc failure
>>>> and sb validation, but we could add a warn/notice for the former too.
>>>>
>>>> Brian
>>>>
>>>
>>> Well, I went back and forth on this.  It's probably philosophical. ;)
>>>
>>> Should we emit the corruption error at the point of corruption detection,
>>> or at a higher level?  I guess my concern was that while *this* caller
>>> might catch the return & yell, if another caller got added it might not.
>>>
>>> Putting it at the point of detection seemed foolproof in that regard.
>>>
>>
>> Yeah, that makes sense too. If we were consistent, that model would
>> suggest the write verifier corruption message could go and we'd embed
>> corruption errors along with the other associated EFSCORRUPTED returns
>> (at least where the resulting message is appropriate) in
>> xfs_mount_validate_sb().
>>
>> Either way seems reasonable to me. I guess if all the remaining
>> situations are in fact real corruption situations, the point of
>> detection approach is probably more resilient. It would still be nice to
>> make the verifiers consistent in that though. ;)
> 
> And the conclusion to this discussion is ...?

I think Brian has some valid points, I'll take another look at it.

Thanks,
-Eric

> Cheers,
> 
> Dave.
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
