Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 31 Aug 2008 19:04:28 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m8124NkL010560
	for <xfs@oss.sgi.com>; Sun, 31 Aug 2008 19:04:24 -0700
Subject: Re: [REVIEW #2]  Update kernel code to compile in userspace (libxfs)
From: "Barry Naujok" <bnaujok@sgi.com>
Content-Type: text/plain; format=flowed; delsp=yes; charset=utf-8
MIME-Version: 1.0
References: <op.ugmy3u2o3jf8g2@pc-bnaujok.melbourne.sgi.com>
 <op.ugm1ttzb3jf8g2@pc-bnaujok.melbourne.sgi.com>
 <20080829181120.GA9455@infradead.org>
 <op.ugr4zpyv3jf8g2@pc-bnaujok.melbourne.sgi.com>
 <20080901015950.GA16825@infradead.org>
Content-Transfer-Encoding: 7bit
Date: Mon, 01 Sep 2008 12:06:54 +1000
Message-ID: <op.ugr5hsao3jf8g2@pc-bnaujok.melbourne.sgi.com>
In-Reply-To: <20080901015950.GA16825@infradead.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Mon, 01 Sep 2008 11:59:50 +1000, Christoph Hellwig <hch@infradead.org>  
wrote:

> On Mon, Sep 01, 2008 at 11:56:03AM +1000, Barry Naujok wrote:
>> On Sat, 30 Aug 2008 04:11:20 +1000, Christoph Hellwig  
>> <hch@infradead.org>
>> wrote:
>>
>>> On Fri, Aug 29, 2008 at 05:59:43PM +1000, Barry Naujok wrote:
>>>> On Fri, 29 Aug 2008 17:00:56 +1000, Barry Naujok <bnaujok@sgi.com>
>>>> wrote:
>>>>
>>>>> Mostly header changes associated with #ifdef __KERNEL__ stuff.
>>>>>
>>>>> Some function prototypes had to be reordered to separate
>>>>> shared and kernel only functions.
>>>>
>>>> fs/xfs/xfs_inode.h patch looked pretty horrid (and there was a missing
>>>> declaration), here's a better version:
>>>
>>> I still don't like it very much :)  What about just moving the
>>> xfs_ictimestamp and xfs_icdinode defintions next to the ifork
>>> so that we can save one ifdef __KERNEL__?  Also might be worth
>>> to move the xfs_iflock & co inlines before the end of that __KERNEL__
>>> block to save another ifdef.
>>
>> Ok, this now only has one blob of #ifdef __KERNEL__ in it now:
>
> Looks good.
>

What about the rest ;)
