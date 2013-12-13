Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 437817F4E
	for <xfs@oss.sgi.com>; Thu, 12 Dec 2013 19:23:40 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 3C8A6304053
	for <xfs@oss.sgi.com>; Thu, 12 Dec 2013 17:23:24 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	Xh5it5yU0WF5g1qj for <xfs@oss.sgi.com>;
	Thu, 12 Dec 2013 17:22:56 -0800 (PST)
Date: Fri, 13 Dec 2013 12:22:51 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/4 v3] fiemap: add EXTENT_DATA_COMPRESSED flag
Message-ID: <20131213012251.GO10988@dastard>
References: <cover.1386778302.git.dsterba@suse.cz>
	<4f8d5dc5b51a43efaf16c39398c23a6276e40a30.1386778303.git.dsterba@suse.cz>
	<20131212232443.GL31386@dastard>
	<9520AB36-B728-423A-8EA1-FDD22B79AE90@dilger.ca>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <9520AB36-B728-423A-8EA1-FDD22B79AE90@dilger.ca>
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
To: Andreas Dilger <adilger@dilger.ca>
Cc: linux-nilfs@vger.kernel.org, Mark Fasheh <mfasheh@suse.com>, David Sterba <dsterba@suse.cz>, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, ocfs2-devel@oss.oracle.com, Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Ext4 Developers List <linux-ext4@vger.kernel.org>, "linux-btrfs@vger.kernel.org Btrfs" <linux-btrfs@vger.kernel.org>

On Thu, Dec 12, 2013 at 05:02:57PM -0700, Andreas Dilger wrote:
> On Dec 12, 2013, at 4:24 PM, Dave Chinner <david@fromorbit.com> wrote:
> > On Thu, Dec 12, 2013 at 04:25:59PM +0100, David Sterba wrote:
> >> This flag was not accepted when fiemap was proposed [2] due to lack of
> >> in-kernel users. Btrfs has compression for a long time and we'd like to
> >> see that an extent is compressed in the output of 'filefrag' utility
> >> once it's taught about it.
> >> 
> >> For that purpose, a reserved field from fiemap_extent is used to let the
> >> filesystem store along the physcial extent length when the flag is set.
> >> This keeps compatibility with applications that use FIEMAP.
> > 
> > I'd prefer to just see the new physical length field always filled
> > out, regardless of whether it is a compressed extent or not. In
> > terms of backwards compatibility to userspace, it makes no
> > difference because the value of reserved/unused fields is undefined
> > by the API. Yes, the implementation zeros them, but there's nothing
> > in the documentation that says "reserved fields must be zero".
> > Hence I think we should just set it for every extent.
> 
> I'd actually thought the same thing while reading the patch, but I figured
> people would object because it implies that old kernels will return a
> physical length of 0 bytes (which might be valid) and badly-written tools
> will not work correctly on older kernels. 

Well, that's a problem regardless of whether new kernels return a
physical length by default or not. I think I'd prefer a flag that
says specifically whether the fe_phys_len field is valid or not. Old
kernels will never set the flag, new kernels can always set the
flag...

> That said, applications _should_
> be checking the FIEMAP_EXTENT_DATA_COMPRESSED flag, and I suspect in the
> future fewer developers will be confused if fe_phys_length == fe_length
> going forward.

I think an explicit flag is better than relying on a flag that
defines the encoding to imply the physical length field is valid.

> If the initial tools get it right (in particular filefrag),

I'd think xfs_io is the first target - because we'll need xfstests
coverage of this before there's a filefrag release that supports
it...

> then hopefully others will get it correct also.

Agreed.

> > From the point of view of the kernel API (fiemap_fill_next_extent),
> > passing the physical extent size in the "len" parameter for normal
> > extents, then passing 0 for the "physical length" makes absolutely
> > no sense.
> > 
> > IOWs, what you have created is a distinction between the extent's
> > "logical length" and it's "physical length". For uncompressed
> > extents, they are both equal and they should both be passed to
> > fiemap_fill_next_extent as the same value. Extents where they are
> > different (i.e.  encoded extents) is when they can be different.
> > Perhaps fiemap_fill_next_extent() should check and warn about
> > mismatches when they differ and the relevant flags are not set...
> 
> Seems reasonable to have a WARN_ONCE() in that case.  That would catch bugs
> in the filesystem, code as well:
> 
> 	WARN_ONCE(phys_len != lgcl_len &&
> 		  !(flags & FIEMAP_EXTENT_DATA_COMPRESSED),
> 		  "physical len %llu != logical length %llu without DATA_COMPRESSED\n",
> 		  phys_len, logical_len, phys_len, logical_len);

Yup, pretty much what I was thinking.

> >> --- a/include/uapi/linux/fiemap.h
> >> +++ b/include/uapi/linux/fiemap.h
> >> @@ -19,7 +19,9 @@ struct fiemap_extent {
> >> 	__u64 fe_physical; /* physical offset in bytes for the start
> >> 			    * of the extent from the beginning of the disk */
> >> 	__u64 fe_length;   /* length in bytes for this extent */
> >> -	__u64 fe_reserved64[2];
> >> +	__u64 fe_phys_length; /* physical length in bytes, undefined if
> >> +			       * DATA_COMPRESSED not set */
> >> +	__u64 fe_reserved64;
> >> 	__u32 fe_flags;    /* FIEMAP_EXTENT_* flags for this extent */
> >> 	__u32 fe_reserved[3];
> >> };
> > 
> > The comment for fe_length needs to change, too, because it needs to
> > indicate that it is the logical extent length and that it may be
> > different to the fe_phys_length depending on the flags that are set
> > on the extent.
> 
> Would it make sense to rename fe_length to fe_logi_length (or something,
> I'm open to suggestions), and have a compat macro:
> 
> #define fe_length fe_logi_length
> 
> around for older applications?  That way, new developers would start to
> use the new name, old applications would still compile for both newer and
> older interfaces, and it doesn't affect the ABI at all.

Sounds like a good idea.

> > And, FWIW, I wouldn't mention specific flags in the comment here,
> > but do it at the definition of the flags that indicate there is
> > a difference between physical and logical extent lengths....
> 
> Actually, I was thinking just the opposite for this field.  It seems useful
> that the requirement for DATA_COMPRESSED being set is beside fe_phys_length
> so that anyone using this field sees the correlation clearly.  I don't expect
> everyone would read and understand the meaning of all the flags when looking
> at the data structure.

Well, it's moot if we decide a specific flag for the fe_phys_len
field being valid is decided on ;)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
