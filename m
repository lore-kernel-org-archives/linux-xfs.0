Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54380 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932305AbcKOSLI (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 15 Nov 2016 13:11:08 -0500
Date: Tue, 15 Nov 2016 13:11:01 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH RFC 1/4] xfs: clean up cow fork reservation and tag
 inodes correctly
Message-ID: <20161115181101.GC65218@bfoster.bfoster>
References: <1478636856-7590-1-git-send-email-bfoster@redhat.com>
 <1478636856-7590-2-git-send-email-bfoster@redhat.com>
 <20161115141621.GA18630@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161115141621.GA18630@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org

On Tue, Nov 15, 2016 at 06:16:21AM -0800, Christoph Hellwig wrote:
> > +	if (imap->br_startoff != got.br_startoff ||
> > +	    imap->br_blockcount != got.br_blockcount)
> >  		xfs_inode_set_cowblocks_tag(ip);
> 
> Can't got.br_blockcount be smaller than imap->br_blockcount if we have
> an existing COW fork reservation lying around behind the whole we're
> filling?  Also they way xfs_bmapi_reserve_delalloc works the startoff
> will be the same.  E.g. this check should probably be:
> 

Good point, though I think it can be smaller or larger without
necessarily having preallocation due to being merged with surrounding
extents. I'm not quite sure what the right answer for that is with
regard to tagging, but I do think it's better to have false positive
tagging than false negatives.

startoff can actually change due to merges as well, but merging aside,
I'm not following how you expect startoff to always be the same in the
event of the extent size hint. E.g., I see the following on a quick test
(file is a 1m reflinked file):

# xfs_io -c fiemap -c "fiemap -c" /mnt/file 
/mnt/file:
        0: [0..2047]: 160..2207
/mnt/file:
# xfs_io -c "pwrite 32k 4k" /mnt/file 
wrote 4096/4096 bytes at offset 32768
4 KiB, 1 ops; 0.0000 sec (16.910 MiB/sec and 4329.0043 ops/sec)
# xfs_io -c fiemap -c "fiemap -c" /mnt/file 
/mnt/file:
        0: [0..63]: 160..223
        1: [64..71]: 2272..2279
        2: [72..2047]: 232..2207
/mnt/file:
        0: [0..63]: 2208..2271
        1: [64..71]: hole
        2: [72..255]: 2280..2463
        3: [256..2047]: hole

So the cow extent size hint rounds out the allocation in the cow fork to
the aligned start/end offsets. In fact, I think it would do so
regardless of whether those covered blocks are even shared, but that's a
separate issue.

Given all of that, I could tweak the check to:

	if (got.br_startoff < imap->br_startoff ||
	    got.br_blockcount > imap->br_blockcount)
		...

Thoughts?

Brian

> 	if (got.br_blockcount > imap->br_blockcount)
> 
> Except for that the patch looks good and is a nice cleanup.
