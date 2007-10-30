Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 29 Oct 2007 17:11:42 -0700 (PDT)
Received: from agminet01.oracle.com (agminet01.oracle.com [141.146.126.228])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id l9U0Baeo004973
	for <xfs@oss.sgi.com>; Mon, 29 Oct 2007 17:11:38 -0700
Date: Mon, 29 Oct 2007 17:11:26 -0700
From: Mark Fasheh <mark.fasheh@oracle.com>
Subject: Re: [RFC] add FIEMAP ioctl to efficiently map file allocation
Message-ID: <20071030001126.GD28607@ca-server1.us.oracle.com>
Reply-To: Mark Fasheh <mark.fasheh@oracle.com>
References: <20070419002139.GK5967@schatzie.adilger.int> <20070419015426.GM48531920@melbourne.sgi.com> <20070430224401.GX5967@schatzie.adilger.int> <20070501042254.GD77450368@melbourne.sgi.com> <1FA8E92B-954D-4624-A089-80D4AA7399FD@cam.ac.uk> <20070502000654.GK77450368@melbourne.sgi.com> <8464EA47-03AC-4162-A2D0-683517568640@cam.ac.uk> <20071029194507.GA8578@webber.adilger.int> <20071029205744.GB28607@ca-server1.us.oracle.com> <20071029221302.GD3042@webber.adilger.int>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071029221302.GD3042@webber.adilger.int>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-fsdevel@vger.kernel.org, David Chinner <dgc@sgi.com>, linux-ext4@vger.kernel.org, xfs@oss.sgi.com, hch@infradead.org, Anton Altaparmakov <aia21@cam.ac.uk>, Mike Waychison <mikew@google.com>, ocfs2-devel@oss.oracle.com

On Mon, Oct 29, 2007 at 04:13:02PM -0600, Andreas Dilger wrote:
> On Oct 29, 2007  13:57 -0700, Mark Fasheh wrote:
> > 	Thanks for posting this. I believe that an interface such as FIEMAP
> > would be very useful to Ocfs2 as well. (I added ocfs2-devel to the e-mail)
> 
> I tried to make it as Lustre-agnostic as possible...

IMHO, your description succeeded at that. I'm hoping that the final patch
can have mostly generic code, like FIBMAP does today.


> > > #define FIEMAP_EXTENT_LAST      0x00000020 /* last extent in the file */
> > > #define FIEMAP_EXTENT_EOF       0x00000100 /* fm_start + fm_len beyond EOF*/
> > 
> > Is "EOF" here considering "beyond i_size" or "beyond allocation"?
> 
> _EOF == beyond i_size.
> _LAST == last extent in the file.
> 
> In most cases FIEMAP_EXTENT_EOF will be set at the same time as
> FIEMAP_EXTENT_LAST, but in case of e.g. prealloc beyond i_size the 
> EOF flag may be set on one or more earlier extents.

Oh, ok great - I was primarily looking for a way to say "there's allocation
past i_size" and it looks like we have it.


> > > FIEMAP_EXTENT_NO_DIRECT means data cannot be directly accessed (maybe
> > > encrypted, compressed, etc.)
> > 
> > Would it be valid to use FIEMAP_EXTENT_NO_DIRECT for marking in-inode data?
> > Btrfs, Ocfs2, and Gfs2 pack small amounts of user data directly in inode
> > blocks.
> 
> Hmm, but part of the issue would be how to request the extra data, and
> what offset it would be given?  One could, for example, use negative
> offsets to represent metadata or something, or add a FIEMAP_EXTENT_META
> or similar, I hadn't given that much thought.

Well, fe_offset and fe_length are already expressed in bytes, so we could
just put the byte offset to where the inline data starts in there. fe_length
is just used as the length allocated for inline-data.

If fe_offset is required to be block aligned, then we could add a field to
express an offset within the block where data would be found - say
'fe_data_start_offset'. In the non-inline case, we could guarantee that
fe_data_start_offset is zero. That way software which doesn't want to care
whether something is inline-data (for example, a backup program) or not
could just blidly add it to fe_offset before looking at the data.

Regardless, I think we also want to explicitely flag this:

#define FIEMAP_EXTENT_DATA_IN_INODE 0x00000400 /* extent data is stored in inode block */


I'm going to pretend that I completely understand reiserfs tail-packing and
say that my approaches above looks like they could work for that case too.
We'd want to add a seperate flag for tail packed data though.


> The other issue is that I'd like to get the basics of the API in place
> before it gets too complex. We can always add functionality with more
> FIEMAP_FLAG_* (whether in the INCOMPAT range or not, depending on what is
> being done).

Sure, but I think whatever goes upstream should be able to handle this case
- there's file systems in use _today_ which put data in inode blocks and
pack file tails.

Thanks,
	--Mark

--
Mark Fasheh
Senior Software Developer, Oracle
mark.fasheh@oracle.com
