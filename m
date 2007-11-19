Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 19 Nov 2007 07:52:50 -0800 (PST)
Received: from sandeen.net (sandeen.net [209.173.210.139])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id lAJFqgbN018233
	for <xfs@oss.sgi.com>; Mon, 19 Nov 2007 07:52:43 -0800
Message-ID: <4741B14D.8020004@sandeen.net>
Date: Mon, 19 Nov 2007 09:52:45 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: REVIEW: xfs_reno #2
References: <op.tznnweh23jf8g2@pc-bnaujok.melbourne.sgi.com> <473D32D9.2020500@sgi.com> <473D36AC.7040507@sgi.com> <20071119123918.GA15942@infradead.org>
In-Reply-To: <20071119123918.GA15942@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: Timothy Shimmin <tes@sgi.com>, Vlad Apostolov <vapo@sgi.com>, Barry Naujok <bnaujok@sgi.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>, xfs-dev <xfs-dev@sgi.com>

Christoph Hellwig wrote:
> On Fri, Nov 16, 2007 at 05:20:28PM +1100, Timothy Shimmin wrote:
>> Vlad Apostolov wrote:
>>> When the XFS parent pointers feature is released we would need to find
>>> out to update the EA to point to the new inode parent directory. This may
>>> not be that easy though.
>>>
>> Really?
>> Apart from the swapping of extents, reno uses standard calls doesn't it,
>> in which case any movement of inodes will have the parent pointers
>> updated by the normal vnode ops (e.g. mkdir, rename) in the kernel.
> 
> What parent pointers?
> 
> 

The ones not yet released I guess :)

>> Vlad Apostolov wrote:
>>> When the XFS parent pointers feature is released...

-Eric
