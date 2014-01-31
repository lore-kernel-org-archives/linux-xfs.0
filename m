Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id DBEEF7F54
	for <xfs@oss.sgi.com>; Fri, 31 Jan 2014 10:47:25 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id CC020304051
	for <xfs@oss.sgi.com>; Fri, 31 Jan 2014 08:47:25 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id lIfQfzQ9eIh9yq80 for <xfs@oss.sgi.com>;
	Fri, 31 Jan 2014 08:47:14 -0800 (PST)
Message-ID: <52EBD38F.5070608@sandeen.net>
Date: Fri, 31 Jan 2014 10:47:11 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs: improve xfs_bitmap_empty()
References: <52EBAF91.10608@oracle.com>	<52EBBC3D.5030507@sandeen.net>	<52EBC103.5050006@oracle.com>	<52EBC1AF.6020000@sandeen.net>
	<52EBC67B.7020806@oracle.com> <52EBCF12.1020403@sgi.com>
In-Reply-To: <52EBCF12.1020403@sgi.com>
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
To: Mark Tinguely <tinguely@sgi.com>, Jeff Liu <jeff.liu@oracle.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On 1/31/14, 10:28 AM, Mark Tinguely wrote:
> On 01/31/14 09:51, Jeff Liu wrote:
>>
>> On 01/31 2014 23:30 PM, Eric Sandeen wrote:
>>> On 1/31/14, 9:28 AM, Jeff Liu wrote:
>>>>
>>>> On 01/31 2014 23:07 PM, Eric Sandeen wrote:
>>>>> On 1/31/14, 8:13 AM, Jeff Liu wrote:
>>>>>> From: Jie Liu<jeff.liu@oracle.com>
>>>>>>
>>>>>> There is no need to travel through the whole bitmap items to verify
>>>>>> if the bitmap array is empty or not, instead, just return 0 directly
>>>>>> if an item is detected in bitmap array.
>>>>>>
>>>>>> Signed-off-by: Jie Liu<jeff.liu@oracle.com>
>>>>>
>>>>> Makes sense (and the long loop was my fault, I guess, but it's
>>>>> better than it was, see commit 24ad33f!)
>>>>
>>>> Ah, you have killed a lots code there! :)
>>>>> Reviewed-by: Eric Sandeen<sandeen@redhat.com>
>>>>>
>>>>> I wonder if something like:
>>>>>
>>>>> return (find_first_set(map, size) == size);
>>>>>
>>>>> would be faster (or if it'd be worth it)...?
>>>>> Probably not.  :)
>>>>>
>>>>
>>>> Well, when I looking through our bitmap source, I once thought if
>>>> we can replace the current code with the generic bitmap library.
>>>> However, our map is uint rather than unsigned long...
>>>
>>> Technically the unsigned long (pointer) is just the bitmap address,
>>> I think.
>>
>> Yeah, so this might worth to try on long terms.
>>
> 
> The blf_data_map[] is int aligned, not long aligned.
> You could reflect the alignment difference in the offset or
> change the alignment in the structure.

Oh, I guess it does matter.  Sometimes C escapes me...

probably not worth messing with.  I'll stop thinking
out loud in front of everybody, now.  ;)

Thanks,
-Eric
 
> --Mark.
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
