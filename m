Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id DAAA97F84
	for <xfs@oss.sgi.com>; Fri, 31 Jan 2014 09:51:34 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 9BDE4304032
	for <xfs@oss.sgi.com>; Fri, 31 Jan 2014 07:51:31 -0800 (PST)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id jvlEiWlZgSSqAxQ6 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 31 Jan 2014 07:51:29 -0800 (PST)
Message-ID: <52EBC67B.7020806@oracle.com>
Date: Fri, 31 Jan 2014 23:51:23 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs: improve xfs_bitmap_empty()
References: <52EBAF91.10608@oracle.com>
	<52EBBC3D.5030507@sandeen.net>	<52EBC103.5050006@oracle.com>
	<52EBC1AF.6020000@sandeen.net>
In-Reply-To: <52EBC1AF.6020000@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>


On 01/31 2014 23:30 PM, Eric Sandeen wrote:
> On 1/31/14, 9:28 AM, Jeff Liu wrote:
>>
>> On 01/31 2014 23:07 PM, Eric Sandeen wrote:
>>> On 1/31/14, 8:13 AM, Jeff Liu wrote:
>>>> From: Jie Liu <jeff.liu@oracle.com>
>>>>
>>>> There is no need to travel through the whole bitmap items to verify
>>>> if the bitmap array is empty or not, instead, just return 0 directly
>>>> if an item is detected in bitmap array.
>>>>
>>>> Signed-off-by: Jie Liu <jeff.liu@oracle.com>
>>>
>>> Makes sense (and the long loop was my fault, I guess, but it's 
>>> better than it was, see commit 24ad33f!)
>>
>> Ah, you have killed a lots code there! :)
>>> Reviewed-by: Eric Sandeen <sandeen@redhat.com>
>>>
>>> I wonder if something like:
>>>
>>> return (find_first_set(map, size) == size);
>>>
>>> would be faster (or if it'd be worth it)...?
>>> Probably not.  :)
>>>
>>
>> Well, when I looking through our bitmap source, I once thought if
>> we can replace the current code with the generic bitmap library.
>> However, our map is uint rather than unsigned long...
> 
> Technically the unsigned long (pointer) is just the bitmap address,
> I think.

Yeah, so this might worth to try on long terms.

Thanks,
-Jeff

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
