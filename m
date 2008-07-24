Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 23 Jul 2008 22:41:20 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m6O5fECO002579
	for <xfs@oss.sgi.com>; Wed, 23 Jul 2008 22:41:16 -0700
Message-ID: <48881788.7010709@sgi.com>
Date: Thu, 24 Jul 2008 15:47:52 +1000
From: Lachlan McIlroy <lachlan@sgi.com>
Reply-To: lachlan@sgi.com
MIME-Version: 1.0
Subject: Re: [PATCH] Prevent log tail pushing from blocking on buffer locks
References: <48857EFB.3030301@sgi.com> <20080723112154.GA17338@infradead.org>
In-Reply-To: <20080723112154.GA17338@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

Christoph Hellwig wrote:
> On Tue, Jul 22, 2008 at 04:32:27PM +1000, Lachlan McIlroy wrote:
>> This changes xfs_inode_item_push() to use XFS_IFLUSH_ASYNC_NOBLOCK when
>> flushing an inode so the flush wont block on inode cluster buffer lock.
>> Also change the prototype of the IOP_PUSH operation so that xfsaild_push()
>> can bump it's stuck count.
>>
>> This change was prompted by a deadlock that would only occur on a debug
>> XFS where a thread creating an inode had the buffer locked and was trying
>> to allocate space for the inode tracing facility.  That recursed back into
>> the filesystem to flush data which created a transaction and needed log
>> space which wasn't available.
> 
> The stuck propagation looks good, but I don't think this should be
> blindly done for all errors.  The only error where it makes sense is
> the EAGAIN from xfs_iflush.  All other returns inside the item_push
> handlers basically indicate filesystem corruption.

Good point.  Regardless of the error it's still an item that could not
be pushed and is effectively 'stuck'.  What do you recommend I do for
other errors?  Shutdown the filesystem?
