Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:57026 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726240AbeJFFYE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 6 Oct 2018 01:24:04 -0400
Date: Fri, 5 Oct 2018 15:23:12 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 9/8] xfs_io: dedupe command should only complain if we
 don't dedupe anything
Message-ID: <20181005222312.GE19324@magnolia>
References: <153841345236.27952.5050172703525712660.stgit@magnolia>
 <20181004222733.GM19324@magnolia>
 <bda0d21d-d81e-7a16-2440-67037c307c84@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bda0d21d-d81e-7a16-2440-67037c307c84@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: sandeen@redhat.com, linux-xfs@vger.kernel.org

On Fri, Oct 05, 2018 at 04:37:14PM -0500, Eric Sandeen wrote:
> On 10/4/18 5:27 PM, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > The dedupe command should only complain about non-matching extents if
> > the kernel hasn't managed to dedupe /any/ of the input range.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Should it be "no extents matched" then perhaps?
> 
> I mean xfs_io is not exactly-quite a purpose-built dedupe tool, but should
> we be a bit more specific if we're issuing a message at all?
> 
> if (info->status == XFS_EXTENT_DATA_DIFFERS) {
> 	if (deduped == 0)
> 		fprintf(stderr, "XFS_IOC_FILE_EXTENT_SAME: %s\n",
>   			_("No extents matched."));
> 	else
> 		fprintf(stderr, "XFS_IOC_FILE_EXTENT_SAME: %s\n",
>   			_("Some extents did not match."));

We don't need to tell the user that /some/ extents did not match.

If we have two files containing "moo cow" and "moo bow", you'd agree
that the first four bytes match, right?  So the output should be:

$ xfs_io -c 'dedupe /a 0 0 7' /b
linked 4/7 bytes at offset 0
4 bytes, 1 ops; 0.0000 sec

The "4/7" tells us that some extents didn't match, because we didn't
fulfill the entire range requested.  Pretend that this fs can dedupe at
byte alignment.

Now if the files contained "boo cow" and "aaaaaaa", you'd expect:

$ xfs_io -c 'dedupe /a 0 0 7' /b
XFS_IOC_EXTENT_SAME: No extents matched.

And if the files contained "moo cow" and "moo cow":

$ xfs_io -c 'dedupe /a 0 0 7' /b
linked 7/7 bytes at offset 0
7 bytes, 1 ops; 0.0000 sec

> }
> 
> And the manpage implies that any difference will make it fail:
> 
> > map length bytes at offset dst_offset in the open file to the same physical
> > blocks that are mapped at offset src_offset in the file src_file, but only
> > if the contents of both ranges are identical.

It also says:

"Upon  successful  completion  of  this ioctl, the number of bytes
successfully deduplicated is returned in bytes_deduped...."

Which contradicts:

"If even a single byte in the range does not match, the deduplication
request will be ignored and status set to FILE_DEDUPE_RANGE_DIFFERS.

But that makes no sense because if our only choices were really "all the
bytes" or "none of the bytes" then there wouldn't be a bytes_deduped.

> now you're telling me it'll make a best effort?  ;)  I think the manpage
> needs clarification too ...

Yep.

--D

> 
> > ---
> 
> 
> >  io/reflink.c |    3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> > 
> > diff --git a/io/reflink.c b/io/reflink.c
> > index 26eb2e32..72dfe32d 100644
> > --- a/io/reflink.c
> > +++ b/io/reflink.c
> > @@ -70,7 +70,8 @@ dedupe_ioctl(
> >  					_(strerror(-info->status)));
> >  			goto done;
> >  		}
> > -		if (info->status == XFS_EXTENT_DATA_DIFFERS) {
> > +		if (deduped == 0 &&
> > +		    info->status == XFS_EXTENT_DATA_DIFFERS) {
> >  			fprintf(stderr, "XFS_IOC_FILE_EXTENT_SAME: %s\n",
> >  					_("Extents did not match."));
> >  			goto done;
> > 
