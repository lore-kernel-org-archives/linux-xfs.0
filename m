Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id EAAC67CA3
	for <xfs@oss.sgi.com>; Wed, 30 Mar 2016 19:29:34 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id BD0268F8037
	for <xfs@oss.sgi.com>; Wed, 30 Mar 2016 17:29:31 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id oOjmGUYc18Ad7QYY (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 30 Mar 2016 17:29:29 -0700 (PDT)
Date: Wed, 30 Mar 2016 17:32:42 -0700
From: Liu Bo <bo.li.liu@oracle.com>
Subject: Re: fallocate mode flag for "unshare blocks"?
Message-ID: <20160331003242.GA5813@localhost.localdomain>
References: <20160302155007.GB7125@infradead.org>
	<20160330182755.GC2236@birch.djwong.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160330182755.GC2236@birch.djwong.org>
Reply-To: bo.li.liu@oracle.com
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
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-api@vger.kernel.org, linux-btrfs <linux-btrfs@vger.kernel.org>, xfs@oss.sgi.com

On Wed, Mar 30, 2016 at 11:27:55AM -0700, Darrick J. Wong wrote:
> Hi all,
> 
> Christoph and I have been working on adding reflink and CoW support to
> XFS recently.  Since the purpose of (mode 0) fallocate is to make sure
> that future file writes cannot ENOSPC, I extended the XFS fallocate
> handler to unshare any shared blocks via the copy on write mechanism I
> built for it.  However, Christoph shared the following concerns with
> me about that interpretation:
> 
> > I know that I suggested unsharing blocks on fallocate, but it turns out
> > this is causing problems.  Applications expect falloc to be a fast
> > metadata operation, and copying a potentially large number of blocks
> > is against that expextation.  This is especially bad for the NFS
> > server, which should not be blocked for a long time in a synchronous
> > operation.
> > 
> > I think we'll have to remove the unshare and just fail the fallocate
> > for a reflinked region for now.  I still think it makes sense to expose
> > an unshare operation, and we probably should make that another
> > fallocate mode.

I'm expecting fallocate to be fast, too.

Well, btrfs fallocate doesn't allocate space if it's a shared one
because it thinks the space is already allocated.  So a later overwrite
over this shared extent may hit enospc errors.

> 
> With that in mind, how do you all think we ought to resolve this?
> Should we add a new fallocate mode flag that means "unshare the shared
> blocks"?  Obviously, this unshare flag cannot be used in conjunction
> with hole punching, zero range, insert range, or collapse range.  This
> breaks the expectation that writing to a file after fallocate won't
> ENOSPC.
> 
> Or is it ok that fallocate could block, potentially for a long time as
> we stream cows through the page cache (or however unshare works
> internally)?  Those same programs might not be expecting fallocate to
> take a long time.
> 
> Can we do better than either solution?  It occurs to me that XFS does
> unshare by reading the file data into the pagecache, marking the pages
> dirty, and flushing the dirty pages; performance could be improved by
> skipping the flush at the end.  We won't ENOSPC, because the XFS
> delalloc system is careful enough to check that there are enough free
> blocks to handle both the allocation and the metadata updates.  The
> only gap in this scheme that I can see is if we fallocate, crash, and
> upon restart the program then tries to write without retrying the
> fallocate.  Can we trade some performance for the added requirement
> that we must fallocate -> write -> fsync, and retry the trio if we
> crash before the fsync returns?  I think that's already an implicit
> requirement, so we might be ok here.
> 
> Opinions?  I rather like the last option, though I've only just
> thought of it and have not had time to examine it thoroughly, and it's
> specific to XFS. :)

I'd vote for another mode for 'unshare the shared blocks'.

Thanks,

-liubo

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
