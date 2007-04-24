Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 23 Apr 2007 18:58:31 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l3O1wPfB001884
	for <xfs@oss.sgi.com>; Mon, 23 Apr 2007 18:58:27 -0700
Date: Tue, 24 Apr 2007 12:00:38 +1000
From: Timothy Shimmin <tes@sgi.com>
Subject: Re: review: don't hold ilock when calling vn_iowait
Message-ID: <1A5D0CA3BA5C7CF8B7241F39@timothy-shimmins-power-mac-g5.local>
In-Reply-To: <20070423231706.GO32602149@melbourne.sgi.com>
References: <20070422230303.GX32602149@melbourne.sgi.com> <20070423214338.GA17561@infradead.org>
 <20070423231706.GO32602149@melbourne.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>, Christoph Hellwig <hch@infradead.org>
Cc: xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>



--On 24 April 2007 9:17:06 AM +1000 David Chinner <dgc@sgi.com> wrote:

> On Mon, Apr 23, 2007 at 10:43:38PM +0100, Christoph Hellwig wrote:
>> On Mon, Apr 23, 2007 at 09:03:03AM +1000, David Chinner wrote:
>> >
>> > Regression introduced by recent freezing fixes - we should
>> > not hold the ilock while waiting for I/O completion.
>>
>> Looks good, and actually simplies the twisted maze the xfs_sync_inodes is
>> a little bit.  And the missing IPOINTER_INSERT in the SYNC_CLOSE case
>> looks like an actual bugfix.
>
> I had to look closely at that IPOINTER_INSERT case with SYNC_CLOSE;
> it was actaully working properly because you'd always end up in
> the SYNC_CLOSE case having inserted a pointer earlier on in the flow
> of the function. It certainly wasn't obvious that it was doing the
> right thing, though.
>
I find this existing code and the use of marker pointer macros a bit hard to follow.
Can you explain where "earlier on in the flow of the function" we've inserted
the marker pointer (and unlocked the inode-list lock).

Obviously whenever we release the inode-list lock, we have to insert the marker
first (which is what IPOINTER_INSERT does).
But in what cases do we need to release the inode-list lock (m_ilock).

Having a stab in looking at the code:
* before xfs_finish_reclaim
* before VN_RELE which can call xfs_inactive
* in the vnode reference case, prior to locking inode ????
* prior to unlocking the inode and calling one of the flush or toss pages routines.
* prior to unlocking the inode and reading in its buffer
* Prior to flushing the inode (xfs_iflush)
* Every so often if we loop a lot in the code (preempt variable and mask)

We don't seem to remove the marker afterwards always although we do so on each
iteration if we make it to the end of the loop.

It would be nice if this could be clearer somehow.

--Tim
