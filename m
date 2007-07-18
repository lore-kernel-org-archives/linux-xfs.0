Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 18 Jul 2007 10:53:20 -0700 (PDT)
Received: from ext.agami.com (64.221.212.177.ptr.us.xo.net [64.221.212.177])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l6IHrEbm015587
	for <xfs@oss.sgi.com>; Wed, 18 Jul 2007 10:53:15 -0700
Received: from agami.com (mail [192.168.168.5])
	by ext.agami.com (8.12.5/8.12.5) with ESMTP id l6IHqq8q020197
	for <xfs@oss.sgi.com>; Wed, 18 Jul 2007 10:52:52 -0700
Received: from mx1.agami.com (mx1.agami.com [10.123.10.30])
	by agami.com (8.12.11/8.12.11) with ESMTP id l6IHrFF6009139
	for <xfs@oss.sgi.com>; Wed, 18 Jul 2007 10:53:15 -0700
Message-ID: <469E5389.3000002@agami.com>
Date: Wed, 18 Jul 2007 10:53:13 -0700
From: Michael Nishimoto <miken@agami.com>
MIME-Version: 1.0
Subject: Re: Allocating inodes from a single block
References: <469D0666.6040908@agami.com> <20070717201921.GA26309@tuatara.stupidest.org> <469D7035.2020507@sandeen.net> <1184724090.15488.553.camel@edge.yarra.acx> <20070718035012.GA12413810@sgi.com>
In-Reply-To: <20070718035012.GA12413810@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: Nathan Scott <nscott@aconex.com>, Eric Sandeen <sandeen@sandeen.net>, Chris Wedgwood <cw@f00f.org>, xfs@oss.sgi.com

David Chinner wrote:

>On Wed, Jul 18, 2007 at 12:01:30PM +1000, Nathan Scott wrote:
>  
>
>>On Tue, 2007-07-17 at 20:43 -0500, Eric Sandeen wrote:
>>    
>>
>>>Chris Wedgwood wrote:
>>>      
>>>
>>>>On Tue, Jul 17, 2007 at 11:11:50AM -0700, Michael Nishimoto wrote:
>>>>
>>>>        
>>>>
>>>>>Filesystem free space becomes fragmented over time.  It's possible
>>>>>for total free space to be a decent size and still not have a chunk
>>>>>large enough to allocate new inodes.
>>>>>          
>>>>>
>>>>by default there is a restriction that indoes shouldn't consume more
>>>>that 25% of the total space
>>>>
>>>>see the mkfs.xfs man-page for details, search for 'maxpct'
>>>>
>>>>for existing filesystems you can use xfs_db to rewrite this value
>>>>        
>>>>
>>FWIW, xfs_growfs can be used to change this online.
>>
>>    
>>
>>>The problem is that inodes are allocated in "clusters" of blocks.
>>>
>>>If your free blocks aren't such that they can form a cluster, I think
>>>you're out of luck when trying to allocate new inodes if your existing
>>>clusters are full.
>>>      
>>>
>>Have you looked into this much Mike?  I've not recently, but from a
>>quick peek it looks like the cluster size is set in xfs_mount.c as
>>mp->m_inode_cluster_size and a different value is used depending on
>>the machines memory size ... so, perhaps this can be made a mount
>>option?  (XFS_INODE_SMALL_CLUSTER_SIZE is 1FSB AFAICT).  But, maybe
>>I'm missing something or not remembering some details here that'd
>>make that infeasible.
>>    
>>
>
>The issue here is not the cluster size - that is purely an in-memory
>arrangement for reading/writing muliple inodes at once. The issue
>here is inode *chunks* (as Eric pointed out).
>
>Basically, each record in the AGI btree has a 64 bit but-field for
>indicating whether the inodes in the chunk are used or free and a
>64bit address of the first block of the inode chunk.
>
>It is assumed that all the inodes in the chunk are contiguous as
>they are addressed in a compressed form - AG #, block # of first inode,
>inode number in chunk.
>
>That means that:
>
>	a) the inode size across the entire AG must be fixed
>	b) the inodes must be allocated in contiguous chunks of
>	   64 inodes regardless of their size
>
>To change this, you need to completely change the AGI format, the
>inode allocation code and the inode freeing code and all the code that
>assumes that inodes appear in 64 inode chunks e.g. bulkstat. Then
>repair, xfs_db, mkfs, check, etc....
>
>The best you can do to try to avoid these sorts of problems is
>use the "ikeep" option to keep empty inode chunks around. That way
>if you remove a bunch of files then fragement free space you'll
>still be able to create new files until you run out of pre-allocated
>inodes....
>
>  
>
>>Even better than a mount option would be to degrade to smaller size
>>dynamically... not sure how hard that'd be either ... probably lots
>>of corner cases lurking there.
>>    
>>
>
>And a major on-disk format change.
>
>Cheers,
>
>Dave.
>  
>
Dave,

There certainly are alot of places where code will need to change, but
the changes might not be as dramatic if we assume that the ondisk
format stays mostly the same.

One of the ideas that we've been tossing around is to steal a single byte
from xfs_inobt_rec and use it as a bitmap to indicate which of the blocks
within an 8 block chunk have inodes allocated in them.  We certainly haven't
gone through all the places in the code that need to change; and hence, 
don't
understand the entire magnitude of this change, but it looks
like this might allow ondisk formats to remain backwards compatible.

We were thinking that it's possible to steal a byte from ir_freecount
because that field doesn't need 32 bits.

thanks for the input,

   Michael
