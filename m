Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 14B127F51
	for <xfs@oss.sgi.com>; Tue,  4 Feb 2014 09:10:28 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 000EE8F8052
	for <xfs@oss.sgi.com>; Tue,  4 Feb 2014 07:10:24 -0800 (PST)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id FklukXKBRD94116G (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 04 Feb 2014 07:10:23 -0800 (PST)
Message-ID: <52F102D3.9020507@oracle.com>
Date: Tue, 04 Feb 2014 23:10:11 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs: improve xfs_bitmap_empty()
References: <52EBAF91.10608@oracle.com> <52EBBC3D.5030507@sandeen.net>
	<52EBC103.5050006@oracle.com> <52EBC1AF.6020000@sandeen.net>
	<52EBC67B.7020806@oracle.com> <52EBCF12.1020403@sgi.com>
	<52EC6EA0.9000501@oracle.com> <20140202215231.GS2212@dastard>
In-Reply-To: <20140202215231.GS2212@dastard>
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
Cc: Eric Sandeen <sandeen@sandeen.net>, Mark Tinguely <tinguely@sgi.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>


On 02/03 2014 05:52 AM, Dave Chinner wrote:
> On Sat, Feb 01, 2014 at 11:48:48AM +0800, Jeff Liu wrote:
>> On 02/01 2014 00:28 AM, Mark Tinguely wrote:
>>> On 01/31/14 09:51, Jeff Liu wrote:
>>>> On 01/31 2014 23:30 PM, Eric Sandeen wrote:
>>>>> On 1/31/14, 9:28 AM, Jeff Liu wrote:
>>>>>> Well, when I looking through our bitmap source, I once thought if
>>>>>> we can replace the current code with the generic bitmap library.
>>>>>> However, our map is uint rather than unsigned long...
>>>>>
>>>>> Technically the unsigned long (pointer) is just the bitmap address,
>>>>> I think.
>>>>
>>>> Yeah, so this might worth to try on long terms.
>>>
>>> The blf_data_map[] is int aligned, not long aligned.
>>> You could reflect the alignment difference in the offset or
>>> change the alignment in the structure.
>>
>> For now, I think we can not simply turn to generic bitmap just because
>> of the alignment difference on 64-bits OS.
> 
> The bitmaps end up on disk (in the log), so replacing the
> implementation with a generic implementation is something we need to
> be very careful about.
> 
> IMO, we should be getting rid of the bitmaps from the
> xfs_buf_log_item first (by moving to a low byte/high byte offset
> range), then we only have to worry about bitmaps when doing log
> recovery after a kernel upgrade on a filesystem with a dirty log.
> 
> Getting rid of the bitmaps also solves a scalability problem with
> large block sizes tracking all the changes in buffer - we burn a
> huge amount of CPU walking bits when logging 64k directory buffers:
> 
> +  21.19%  [kernel]  [k] xfs_dir3_leaf_check_int
> +  12.20%  [kernel]  [k] memcpy
> +   9.29%  [kernel]  [k] xfs_next_bit
> +   5.04%  [kernel]  [k] xfs_buf_offset
> +   3.63%  [kernel]  [k] xfs_buf_item_format
> +   3.59%  [kernel]  [k] xfs_buf_item_size_segment
> 
> The logging of xfs_buf_log_items there is consuming >30% of the CPU
> being used under this workload (xfs_dir3_leaf_check_int() is high
> because this is from a debug kernel.)
> 
> IOWs, we should work to remove the bitmap code from general
> operations first, then replace the remaining legacy log recovery
> code with the generic bitmap implemention....

Sorry for my too late response as I was on vacations.

I only moved a little progress after a quick hacking, but I can see the point
in getting rid of the bitmap, just give me yet a week once I was totally return
to work.


Thanks,
-Jeff

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
