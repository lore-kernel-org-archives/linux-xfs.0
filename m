Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 0D1337F3F
	for <xfs@oss.sgi.com>; Tue, 24 Feb 2015 07:28:30 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id EF1AF304032
	for <xfs@oss.sgi.com>; Tue, 24 Feb 2015 05:28:26 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id jm7Wld9dggJe1z7F (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 24 Feb 2015 05:28:25 -0800 (PST)
Date: Tue, 24 Feb 2015 08:28:23 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH] xfs: avoid firstused overflow in attr3 leaf header with
	64k blocks
Message-ID: <20150224132822.GA45528@bfoster.bfoster>
References: <1424722050-24149-1-git-send-email-bfoster@redhat.com>
	<54EB8E5D.8080905@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <54EB8E5D.8080905@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com

On Mon, Feb 23, 2015 at 02:32:29PM -0600, Eric Sandeen wrote:
> On 2/23/15 2:07 PM, Brian Foster wrote:
> > The attr3 leaf header has a 16-bit firstused field that tracks the first
> > used entry offset. This field is initialized to the block size in
> > xfs_attr3_leaf_create() and updated accordingly in
> > xfs_attr3_leaf_add_work() when new attributes are added.
> > 
> > The initialization of firstused overflows if the block size exceeds
> > 16-bits. E.g., xfstests test generic/117 causes assert failures on a
> > -bsize=64k fs on ppc64 because ichdr.firstused evaluates to 0.
> 
> cool :)
> 
> > Update the firstused initialization to not exceed the maximum value of
> > an unsigned short. This avoids the overflow to 0 and allows firstused to
> > be updated appropriately on subsequent xattr addition. Also update the
> > freemap size calculation to use the actual block size rather than the
> > potentially minimized version stored in firstused.
> 
> I'm a little scared by this; does this truncated value risk going to disk?
> (Yes, I think so.)  Is that ok?	 Does that ... mean we lose a byte of space
> we'd otherwise have?  Maybe that's ok ...
> 

I don't think it goes to disk in this situation, but even if it does I'm
not sure it matters. Either it's a sane value for the field or it isn't.
:)

We've lost a byte according to the technical meaning of the field but I
don't think that is the practical result. If you follow
xfs_attr_shortform_to_leaf() down to xfs_attr3_leaf_add(), we use the
freemap size and compare firstused against the base, so this is
insignificant there. Continue further to xfs_attr3_leaf_add_work() where
we do this:

        ichdr->freemap[mapindex].size -= xfs_attr_leaf_newentsize(args, &tmp);

        entry->nameidx = cpu_to_be16(ichdr->freemap[mapindex].base +
                                     ichdr->freemap[mapindex].size);

	...

        if (be16_to_cpu(entry->nameidx) < ichdr->firstused)
                ichdr->firstused = be16_to_cpu(entry->nameidx);
	...

... and it looks to me that firstused will be updated appropriately on
first insertion just the same since the data structure to track the
entry itself is larger than a single byte (I think there's also 4-byte
alignment rules in play here).

All that said, that's just the insert after sf->leaf conversion case and
I'm still working on grokking this code. I haven't considered the other
compaction cases and whatnot yet. TBH, even if we do lose a byte in some
circumstances, I think that's just a limitation of the on-disk format.
We just have to make sure it's documented and handled correctly. Another
question is what happens if one one of these blocks is emptied some time
later (e.g., is conversion/removal guaranteed? maybe it's more
appropriate to reduce the size as well, pretend the blocks are a few
bytes shorter and avoid a landmine altogether).

> FWIW, I think the same problem exists in xfs_attr3_leaf_compact():
> 
>         /* Initialise the incore headers */
>         ichdr_src = *ichdr_dst; /* struct copy */
>         ichdr_dst->firstused = args->geo->blksize;
> 
> and xfs_attr3_leaf_unbalance():
> 
>                 tmphdr.firstused = state->args->geo->blksize;
> 

Indeed, thanks for catching these. I'll look through them and the one
Dave pointed out.

> > Signed-off-by: Brian Foster <bfoster@redhat.com>
> > ---
> >  fs/xfs/libxfs/xfs_attr_leaf.c | 5 +++--
> >  1 file changed, 3 insertions(+), 2 deletions(-)
> > 
> > diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
> > index 15105db..dc7bda3 100644
> > --- a/fs/xfs/libxfs/xfs_attr_leaf.c
> > +++ b/fs/xfs/libxfs/xfs_attr_leaf.c
> > @@ -970,7 +970,8 @@ xfs_attr3_leaf_create(
> >  	memset(leaf, 0, args->geo->blksize);
> >  
> >  	memset(&ichdr, 0, sizeof(ichdr));
> > -	ichdr.firstused = args->geo->blksize;
> > +	/* firstused is 16-bit */
> > +	ichdr.firstused = min_t(int, USHRT_MAX, args->geo->blksize);
> >  
> >  	if (xfs_sb_version_hascrc(&mp->m_sb)) {
> >  		struct xfs_da3_blkinfo *hdr3 = bp->b_addr;
> > @@ -986,7 +987,7 @@ xfs_attr3_leaf_create(
> >  		ichdr.magic = XFS_ATTR_LEAF_MAGIC;
> >  		ichdr.freemap[0].base = sizeof(struct xfs_attr_leaf_hdr);
> >  	}
> > -	ichdr.freemap[0].size = ichdr.firstused - ichdr.freemap[0].base;
> > +	ichdr.freemap[0].size = args->geo->blksize - ichdr.freemap[0].base;
> 
> But now freemap.size is out of sync with firstused; is that ok?
> 

I think so, according to the above logic. I'll have to see about those
other cases...

Brian

> -Eric
>  
> >  	xfs_attr3_leaf_hdr_to_disk(leaf, &ichdr);
> >  	xfs_trans_log_buf(args->trans, bp, 0, args->geo->blksize - 1);
> > 
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
