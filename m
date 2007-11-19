Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 19 Nov 2007 14:08:15 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with SMTP id lAJM89cO016131
	for <xfs@oss.sgi.com>; Mon, 19 Nov 2007 14:08:11 -0800
Message-ID: <4742094C.2020705@sgi.com>
Date: Tue, 20 Nov 2007 09:08:12 +1100
From: Vlad Apostolov <vapo@sgi.com>
MIME-Version: 1.0
Subject: Re: REVIEW: xfs_reno #2
References: <op.tznnweh23jf8g2@pc-bnaujok.melbourne.sgi.com> <473D32D9.2020500@sgi.com> <473D36AC.7040507@sgi.com> <20071119123918.GA15942@infradead.org> <4741B14D.8020004@sandeen.net>
In-Reply-To: <4741B14D.8020004@sandeen.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Christoph Hellwig <hch@infradead.org>, Timothy Shimmin <tes@sgi.com>, Barry Naujok <bnaujok@sgi.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>, xfs-dev <xfs-dev@sgi.com>

Eric Sandeen wrote:
> Christoph Hellwig wrote:
>   
>> On Fri, Nov 16, 2007 at 05:20:28PM +1100, Timothy Shimmin wrote:
>>     
>>> Vlad Apostolov wrote:
>>>       
>>>> When the XFS parent pointers feature is released we would need to find
>>>> out to update the EA to point to the new inode parent directory. This may
>>>> not be that easy though.
>>>>
>>>>         
>>> Really?
>>> Apart from the swapping of extents, reno uses standard calls doesn't it,
>>> in which case any movement of inodes will have the parent pointers
>>> updated by the normal vnode ops (e.g. mkdir, rename) in the kernel.
>>>       
>> What parent pointers?
>>
>>
>>     
>
> The ones not yet released I guess :)
>   
It is a released and existing feature on XFS for Irix, that we are back 
porting to
Linux. You will see some patches soon.

Regards,
Vlad
>   
>>> Vlad Apostolov wrote:
>>>       
>>>> When the XFS parent pointers feature is released...
>>>>         
>
> -Eric
>   
