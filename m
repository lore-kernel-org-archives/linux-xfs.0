Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 24 Jan 2007 08:45:07 -0800 (PST)
Received: from internal-mail-relay1.corp.sgi.com (internal-mail-relay1.corp.sgi.com [198.149.32.52])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l0OGj0qw024255
	for <xfs@oss.sgi.com>; Wed, 24 Jan 2007 08:45:01 -0800
Message-ID: <45B78CD4.1060400@sgi.com>
Date: Wed, 24 Jan 2007 16:44:04 +0000
From: Lachlan McIlroy <lachlan@sgi.com>
Reply-To: lachlan@sgi.com
MIME-Version: 1.0
Subject: Re: Review: Fix sub-page zeroing for buffered writes into unwritten
 extents
References: <20070123224704.GH33919298@melbourne.sgi.com>
In-Reply-To: <20070123224704.GH33919298@melbourne.sgi.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: xfs-dev@sgi.com, xfs@oss.sgi.com

Dave,

I'm trying to understand what the sequence of events is here.

If we write to an unwritten extent then will __xfs_get_blocks()
be called with create=1 and flags=BMAPI_WRITE?  And calling
bhv_vop_bmap() with flags set to BMAPI_WRITE will cause xfs_iomap()
to set iomap_flags to IOMAP_NEW?  The combination of create=1 and
iomap_flags=IOMAP_NEW in __xfs_get_blocks() should result in calling
set_buffer_new(), right?

I must be missing something...

Lachlan

David Chinner wrote:
> Simple test case:
> 
> prealloc large file
> write 3000 bytes to the middle of the file
> read back file
> 
> The data in the block where the 3000 bytes was written has
> non-zero garbage around it both in memory and on disk.
> 
> The problem is a buffer mapping problem. When we copy data
> into an unwritten buffer, we have the create flag set which
> means we map the buffer. We then mark the buffer as unwritten,
> and do some more checks. Because the buffer is mapped, we do
> not set the buffer_new() flag on the buffer, which means when
> we return to the generic code, it does not do sub-block zeroing
> of the unwritten areas of the block.
> 
> The following patch fixes the problem. Comments?
> 
> Cheers,
> 
> Dave.
