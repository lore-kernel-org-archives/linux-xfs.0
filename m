Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id B3A5129DFB
	for <xfs@oss.sgi.com>; Fri, 23 Aug 2013 11:53:10 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 5009AAC007
	for <xfs@oss.sgi.com>; Fri, 23 Aug 2013 09:53:07 -0700 (PDT)
Message-ID: <5217929F.5050008@redhat.com>
Date: Fri, 23 Aug 2013 12:49:35 -0400
From: Brian Foster <bfoster@redhat.com>
MIME-Version: 1.0
Subject: Re: XFS: Assertion failed: first <= last && last <
	BBTOB(bp->b_length), file: fs/xfs/xfs_trans_buf.c, line: 568
References: <52165830.8050006@redhat.com> <52176134.6090905@sgi.com>
	<5217640F.7050900@redhat.com> <52176A2C.9060708@sgi.com>
In-Reply-To: <52176A2C.9060708@sgi.com>
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
To: Mark Tinguely <tinguely@sgi.com>
Cc: xfs@oss.sgi.com

On 08/23/2013 09:57 AM, Mark Tinguely wrote:
> On 08/23/13 08:30, Brian Foster wrote:
>> On 08/23/2013 09:18 AM, Mark Tinguely wrote:
>>> On 08/22/13 13:28, Brian Foster wrote:
>>>> Hi all,
>>>>
>>>> I hit an assert on a debug kernel while beating on some finobt work and
>>>> eventually reproduced it on unmodified/TOT xfs/xfsprogs as of today. I
>>>> hit it through a couple different paths, first while running
>>>> fsstress on
>>>> a CRC enabled filesystem (with otherwise default mkfs options):
>>>>
>>>> (These tests are running on a 4p, 4GB VM against a 100GB virtio disk,
>>>> hosted on a single spindle desktop box).
>>>
>>> Eeek.
>>>
>>> So both crashes are directory related. What is the top XFS kernel commit
>>> for these tests?
>>>
>>
>> Hi Mark,
>>
>> It was the latest from at some point yesterday. I don't think I've
>> pulled since, so I'm at:
>>
>> 3e3c51ce xfs: add xfs sb v4 support for dirent filetype field
>>
>>> Have you seen this on earlier versions of the kernel?
>>>
>>
>> Well I hit an issue first on my dev. branch for finobt hacking, which is
>> currently based on a slightly older commit:
>>
>> 2c2bcc07 xfs: call roundup_64() to calculate the min_logblks
>>
>> Unfortunately I don't have the precise error/stack from that failure on
>> hand to double check whether it's the exact same failure. I can try to
>> regenerate it a bit later today.
>>
>> Brian
>>
>>> Thanks,
>>>
>>> --Mark.
>>
> Good, I just want to make sure the common directory mods for the file
> type patch was not the cause. I will try to recreate it too.
> 

And just to confirm, I can hit the assert from both tests on a 2c2bcc07
kernel (pre-dirent ftype change).

Brian

> Thanks.
> 
> --Mark.
> 
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
