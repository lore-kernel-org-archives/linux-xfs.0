Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:33826 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726119AbeHTSuD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 20 Aug 2018 14:50:03 -0400
Date: Mon, 20 Aug 2018 08:33:49 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [patch] file dedupe (and maybe clone) data corruption (was Re:
 [PATCH] generic: test for deduplication between different files)
Message-ID: <20180820153349.GA4334@magnolia>
References: <20180817083924.16916-1-fdmanana@kernel.org>
 <20180819231126.GU2234@dastard>
 <20180820010932.GV2234@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180820010932.GV2234@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: fdmanana@kernel.org, fstests@vger.kernel.org, linux-btrfs@vger.kernel.org, Filipe Manana <fdmanana@suse.com>, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

On Mon, Aug 20, 2018 at 11:09:32AM +1000, Dave Chinner wrote:
> [cc linux-fsdevel now, too]
> 
> On Mon, Aug 20, 2018 at 09:11:26AM +1000, Dave Chinner wrote:
> > [cc linux-xfs@vger.kernel.org]
> > 
> > On Fri, Aug 17, 2018 at 09:39:24AM +0100, fdmanana@kernel.org wrote:
> > > From: Filipe Manana <fdmanana@suse.com>
> > > 
> > > Test that deduplication of an entire file that has a size that is not
> > > aligned to the filesystem's block size into a different file does not
> > > corrupt the destination's file data.
> 
> Ok, I've looked at this now. My first question is where did all the
> magic offsets in this test come from? i.e. how was this bug
> found and who is it affecting?
> 
> > > This test is motivated by a bug found in Btrfs which is fixed by the
> > > following patch for the linux kernel:
> > > 
> > >   "Btrfs: fix data corruption when deduplicating between different files"
> > > 
> > > XFS also fails this test, at least as of linux kernel 4.18-rc7, exactly
> > > with the same corruption as in Btrfs - some bytes of a block get replaced
> > > with zeroes after the deduplication.
> > 
> > Filipe, in future can please report XFS bugs you find to the XFS
> > list the moment you find them. We shouldn't ever find out about a
> > data corruption bug we need to fix via a "oh, by the way" comment in
> > a commit message for a regression test....
> 
> This becomes much more relevant because of what I've just found....
> 
> .....
> 
> > > +# The first byte with a value of 0xae starts at an offset (2518890) which is not
> > > +# a multiple of the block size.
> > > +$XFS_IO_PROG -f \
> > > +	-c "pwrite -S 0x6b 0 2518890" \
> > > +	-c "pwrite -S 0xae 2518890 102398" \
> > > +	$SCRATCH_MNT/foo | _filter_xfs_io
> > > +
> > > +# Create a second file with a length not aligned to the block size, whose bytes
> > > +# all have the value 0x6b, so that its extent(s) can be deduplicated with the
> > > +# first file.
> > > +$XFS_IO_PROG -f -c "pwrite -S 0x6b 0 557771" $SCRATCH_MNT/bar | _filter_xfs_io
> > > +
> > > +# The file is filled with bytes having the value 0x6b from offset 0 to offset
> > > +# 2518889 and with the value 0xae from offset 2518890 to offset 2621287.
> > > +echo "File content before deduplication:"
> > > +od -t x1 $SCRATCH_MNT/foo
> 
> Please use "od -Ad -t x1 <file>" so the file offsets reported by od
> match the offsets used in the test (i.e. in decimal, not octal).
> 
> > > +
> > > +# Now deduplicate the entire second file into a range of the first file that
> > > +# also has all bytes with the value 0x6b. The destination range's end offset
> > > +# must not be aligned to the block size and must be less then the offset of
> > > +# the first byte with the value 0xae (byte at offset 2518890).
> > > +$XFS_IO_PROG -c "dedupe $SCRATCH_MNT/bar 0 1957888 557771" $SCRATCH_MNT/foo \
> > > +	| _filter_xfs_io
> 
> Ok, now it gets fun. dedupe to non-block aligned rtanges is supposed
> to be rejected by the kernel in vfs_clone_file_prep_inodes(). i.e
> this check:
> 
>         /* Only reflink if we're aligned to block boundaries */
>         if (!IS_ALIGNED(pos_in, bs) || !IS_ALIGNED(pos_in + blen, bs) ||
>             !IS_ALIGNED(pos_out, bs) || !IS_ALIGNED(pos_out + blen, bs))
>                 return -EINVAL;
> 
> And it's pretty clear that a length of 557771 is not block aligned
> (being an odd number).
> 
> So why was this dedupe request even accepted by the kernel? Well,
> I think there's a bug in the check just above this:
> 
>         /* If we're linking to EOF, continue to the block boundary. */
>         if (pos_in + *len == isize)
>                 blen = ALIGN(isize, bs) - pos_in;
>         else
>                 blen = *len;
> 
> basically, when the "in" file dedupe/reflink range is to EOF, it
> expands the range to include /all/ of the block that contains the
> EOF byte. IOWs, it now requests us to dedupe /undefined data beyond
> EOF/. But when we go to compare the data in these ranges, it
> truncates the comparison to the length that the user asked for
> (i.e. *len) and not the extended block length.
> 
> IOWs, it doesn't compare the bytes beyond EOF in the source block to
> the data in the destination block it would replace, and so doesn't
> fail the compare like it should.
> 
> And, well, btrfs has the same bug. extent_same_check_offsets()
> extends the range for alignment so it passes alignment checks, but
> then /explicitly/ uses the original length for the data compare
> and dedupe. i.e:
> 
>        /* pass original length for comparison so we stay within i_size */
>         ret = btrfs_cmp_data(olen, cmp);
>         if (ret == 0)
>                 ret = btrfs_clone(src, dst, loff, olen, len, dst_loff, 1);
> 
> This is what we should see if someone tried to dedupe the EOF block
> of a file:
> 
> generic/505     - output mismatch (see /home/dave/src/xfstests-dev/results//xfs/generic/505.out.bad)
>     --- tests/generic/505.out   2018-08-20 09:36:58.449015709 +1000
>     +++ /home/dave/src/xfstests-dev/results//xfs/generic/505.out.bad    2018-08-20 10:45:47.245482160 +1000
>     @@ -13,8 +13,7 @@
>      *
>      2621280 ae ae ae ae ae ae ae ae
>      2621288
>     -deduped 557771/557771 bytes at offset 1957888
>     -XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
>     +XFS_IOC_FILE_EXTENT_SAME: Invalid argument
>      File content after deduplication and before unmounting:
>     ...
>     (Run 'diff -u tests/generic/505.out /home/dave/src/xfstests-dev/results//xfs/generic/505.out.bad'  to see the entire diff)
> 
> i.e. the dedupe request should fail as we cannot dedupe the EOF
> block.
> 
> The patch below does this for the VFS dedupe code. it's not a final
> patch, it's just a demonstration of how this should never have got
> past the range checks. Open questions:

(Here's my five minutes of XFS that I'm allowed per day... :/)

> 	- is documenting rejection on request alignment grounds
> 	  (i.e. EINVAL) in the man page sufficient for app
> 	  developers to understand what is going on here?

I think so.  The manpage says: "The filesystem does not support
reflinking the ranges of the given files", which (to my mind) covers
this case of not supporting dedupe of EOF blocks.

> 	- should we just round down the EOF dedupe request to the
> 	  block before EOF so dedupe still succeeds?

I've often wondered if the interface should (have) be(en) that we start
at src_off/dst_off and share as many common blocks as possible until we
find a mismatch, then tell userspace where we stopped... instead of like
now where we compare the entire extent and fail if any part of it
doesn't match.

> 	- should file cloning (i.e. reflink) be allow allowing the
> 	  EOF block to be shared somewhere inside EOF in the
> 	  destination file?

I don't think we should.

> That's stale data exposure, yes?

Haven't tested that, but seems likely.

> 	- should clone only allow sharing of the EOF block if it's a
> 	  either a full file clone or a matching range clone and
> 	  isize is the same for both src and dest files?

The above sound reasonable for clone, though I would also allow clone to
share the EOF block if we extend isize of the dest file.

The above also nearly sound reasonable for dedupe too.  If we encounter
EOF at the same places in the src range and the dest range, should we
allow sharing there?  The post-eof bytes are undefined by definition;
does undefined == undefined?

> 
> Discuss.
> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 
> 
> [RFC] vfs: fix data corruption w/ unaligned dedupe ranges
> 
> From: Dave Chinner <dchinner@redhat.com>
> 
> Exposed by fstests generic/505 on XFS, caused by extending the
> bblock match range to include the partial EOF block, but then
> allowing unknown data beyond EOF to be considered a "match" to data
> in the destination file because the comparison is only made to the
> end of the source file. This corrupts the destination file when the
> source extent is shared with it.
> 
> Open questions:
> 
> 	- is documenting rejection on request alignment grounds
> 	  (i.e. EINVAL) in the man page sufficient for app
> 	  developers to understand what is going on here?
> 	- should we just silently round down the EOF dedupe request
> 	  to the block before EOF so dedupe still succeeds?
> 	- should file cloning (i.e. reflink) be allow allowing the
> 	  EOF block to be shared somewhere inside EOF in the
> 	  destination file? That's stale data exposure, yes?
> 	- should clone only allow sharing of the EOF block if it's a
> 	  either a full file clone or a matching range clone and
> 	  isize is the same for both src and dest files?
> 
> Btrfs also has the same bug in extent_same_check_offsets() and
> btrfs_extent_same_range() that is not addressed by this patch.

<nod> (xfs/ocfs2) clone ioctls tend to be bug-for-bug compatible with
btrfs more often than we probably ought to... :/

(I also sorta wonder if btrfs should be ported to the common vfs
routines for clone prep and dedupe comparison...?)

--D

> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/read_write.c | 13 +++++++++++--
>  1 file changed, 11 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/read_write.c b/fs/read_write.c
> index 153f8f690490..3844359a4597 100644
> --- a/fs/read_write.c
> +++ b/fs/read_write.c
> @@ -1768,8 +1768,17 @@ int vfs_clone_file_prep_inodes(struct inode *inode_in, loff_t pos_in,
>  			return -EINVAL;
>  	}
>  
> -	/* If we're linking to EOF, continue to the block boundary. */
> -	if (pos_in + *len == isize)
> +	/* Reflink allows linking to EOF, so round the length up to allow us to
> +	 * shared the last block in the file. We don't care what is beyond the
> +	 * EOF point in the block that gets shared, as we can't access it and
> +	 * attempts to extent the file will break the sharing.
> +	 *
> +	 * For dedupe, sharing the EOF block is illegal because the bytes beyond
> +	 * EOF are undefined (i.e. not readable) and so can't be deduped. Hence
> +	 * we do not extend/align the length and instead let the alignment
> +	 * checks below reject it.
> +	 */
> +	if (!is_dedupe && pos_in + *len == isize)
>  		blen = ALIGN(isize, bs) - pos_in;
>  	else
>  		blen = *len;
