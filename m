Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 31 Aug 2008 18:58:29 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m811wQ5r009916
	for <xfs@oss.sgi.com>; Sun, 31 Aug 2008 18:58:27 -0700
Date: Sun, 31 Aug 2008 21:59:50 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [REVIEW #2]  Update kernel code to compile in userspace
	(libxfs)
Message-ID: <20080901015950.GA16825@infradead.org>
References: <op.ugmy3u2o3jf8g2@pc-bnaujok.melbourne.sgi.com> <op.ugm1ttzb3jf8g2@pc-bnaujok.melbourne.sgi.com> <20080829181120.GA9455@infradead.org> <op.ugr4zpyv3jf8g2@pc-bnaujok.melbourne.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <op.ugr4zpyv3jf8g2@pc-bnaujok.melbourne.sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Barry Naujok <bnaujok@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Mon, Sep 01, 2008 at 11:56:03AM +1000, Barry Naujok wrote:
> On Sat, 30 Aug 2008 04:11:20 +1000, Christoph Hellwig <hch@infradead.org> 
> wrote:
>
>> On Fri, Aug 29, 2008 at 05:59:43PM +1000, Barry Naujok wrote:
>>> On Fri, 29 Aug 2008 17:00:56 +1000, Barry Naujok <bnaujok@sgi.com>  
>>> wrote:
>>>
>>>> Mostly header changes associated with #ifdef __KERNEL__ stuff.
>>>>
>>>> Some function prototypes had to be reordered to separate
>>>> shared and kernel only functions.
>>>
>>> fs/xfs/xfs_inode.h patch looked pretty horrid (and there was a missing
>>> declaration), here's a better version:
>>
>> I still don't like it very much :)  What about just moving the
>> xfs_ictimestamp and xfs_icdinode defintions next to the ifork
>> so that we can save one ifdef __KERNEL__?  Also might be worth
>> to move the xfs_iflock & co inlines before the end of that __KERNEL__
>> block to save another ifdef.
>
> Ok, this now only has one blob of #ifdef __KERNEL__ in it now:

Looks good.
