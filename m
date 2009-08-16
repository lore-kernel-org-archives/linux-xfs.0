Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n7G1ZH0J216957 for <xfs@oss.sgi.com>; Sat, 15 Aug 2009 20:35:27 -0500
Received: from mail.rtr.ca (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8E3F31D59121
	for <xfs@oss.sgi.com>; Sat, 15 Aug 2009 18:35:54 -0700 (PDT)
Received: from mail.rtr.ca (rtr.ca [76.10.145.34]) by cuda.sgi.com with ESMTP
	id 9uGFulHCv3ZGFSPu for <xfs@oss.sgi.com>;
	Sat, 15 Aug 2009 18:35:54 -0700 (PDT)
Message-ID: <4A876255.10606@rtr.ca>
Date: Sat, 15 Aug 2009 21:35:17 -0400
From: Mark Lord <liml@rtr.ca>
MIME-Version: 1.0
Subject: Re: [PATCH, RFC] xfs: batched discard support
References: <20090816004705.GA7347@infradead.org>
In-Reply-To: <20090816004705.GA7347@infradead.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-fsdevel@vger.kernel.org, jens.axboe@oracle.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, xfs@oss.sgi.com

Christoph Hellwig wrote:
> Given that everyone is so big in the discard discussion I'd like to
> present what I had started to prepare for XFS.  I didn't plan to send it
> out until I get my hands onto a TRIM capable device (or at least get
> time to add support to qemu), and so far it's only been tested in
> dry-run mode.
> 
> The basic idea is to add an ioctl which walks the free space btrees in
> each allocation group and simply discard everythin that is free.  Given
> that XFS doesn't gragment freespace very much that's a very efficient
> way to do it.  In addition we also already support setting a threshold
> under which we don't bother to discard an extent, it's currently
> hardcoded in the helper tool.  In the future we could also add things
> like a sequence number in the AG headers if anything has changed at all,
> but let's leave those optimizations until we need them.
> 
> XFS locks the allocation btree using the btree buffers, so we do not
> block allocations from any extent which we're not currenly discarding.
> 
> Now the caveat for that is that we really do want to do the discard
> synchronously, that is wait for the request to finish.  That's what
> I've implemented in this patch, but it's the part I haven't been
> able to test so far.  (and yes, this should be separate patch, but it's
> really just an RFC for now)
> 
> Mark, any chance to try it?  Just create an XFS filesystem, age it a
> bit and then call the attached little trim.c program on the mountmoint
> (or any file inside the filesystem for that matter)
..

Looking at it now.  Thanks, Christoph!

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
