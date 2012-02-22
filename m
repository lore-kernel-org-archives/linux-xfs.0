Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q1MEQmXm026991 for <xfs@oss.sgi.com>; Wed, 22 Feb 2012 08:26:48 -0600
Message-ID: <4F44FB25.7080608@sgi.com>
Date: Wed, 22 Feb 2012 08:26:45 -0600
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] Introduce SEEK_DATA/SEEK_HOLE support V8
References: <4F3E532E.6000708@oracle.com> <4F43B081.3000300@sgi.com>
	<4F445B73.4000501@oracle.com>
In-Reply-To: <4F445B73.4000501@oracle.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: jeff.liu@oracle.com
Cc: Christoph Hellwig <hch@infradead.org>, Ben Myers <bpm@sgi.com>, Chris Mason <chris.mason@oracle.com>, xfs@oss.sgi.com

On 02/21/12 21:05, Jeff Liu wrote:
> On 02/21/2012 10:56 PM, Mark Tinguely wrote:
>
>> On 02/17/12 07:16, Jeff Liu wrote:
>>> Hello,
>>>
>>> This is the revised patch according to Dave's comments for V7.
>>>
>>> Changes to V8:
>>> --------------
>>> 1. If there is an internal error raised at extent reading routine, just
>>> return it rather than ENXIO.
>>> 2. Add the commit message.
>>> 3. Remove the for(;;) loop since there is no continuous holes shown even
>>> if create a Petabyte sparse file with hole extent length longer than
>>> 32-bit.  Thanks Dave for helping verify that!
>>> 4. In xfs_seek_data(), s/len/end/, looks 'end' is more meaningful here
>>> to indicate the range of extents mapped.
>>> 5. Remove BUG() from xfs_seek_data() since xfs_bmapi_read() have found
>>> any corruption during the lookup, it should not occurred at all.
>>>
>>> Any comments are appreciated!
>>>
>>> Thanks,
>>> -Jeff
>>>
>>>
>>> Signed-off-by: Jie Liu<jeff.liu@oracle.com>
>>
>> ...
>>
>>> +STATIC loff_t
>>> +xfs_seek_hole(
>> ...
>>> +
>>> +    fsbno = XFS_B_TO_FSBT(mp, start);
>>> +    error = xfs_bmap_first_unused(NULL, ip, 1,&fsbno, XFS_DATA_FORK);
>>> +    if (error)
>>> +        goto out_unlock;
>>> +
>>> +    holeoff = XFS_FSB_TO_B(mp, fsbno);
>>> +    if (holeoff<= start)
>>> +        offset = start;
>>> +    else
>>> +        offset = min_t(loff_t, holeoff, isize);
>>> +
>>
>> ...
>>
>> Very Nice. Much more concise.
>>
>> Can xfs_bmap_first_unused() return something larger than the end of file?
>
> I think it could be happen if the file has no holes past the given
> offset. In this case, it will return the first block past the end of
> file. That is why "min_t()" is used to determine the final value.
>
> Thanks,
> -Jeff
>
>>
>> Reviewed-by: Mark Tinguely<tinguely@sgi.com>
>
>

Okay. Looks good.

--Mark Tinguely.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
