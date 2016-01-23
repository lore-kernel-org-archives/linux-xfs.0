Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id C6FE77F5D
	for <xfs@oss.sgi.com>; Fri, 22 Jan 2016 18:55:23 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 5618AAC005
	for <xfs@oss.sgi.com>; Fri, 22 Jan 2016 16:55:23 -0800 (PST)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id LLsOykhsWEj0MSso (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 22 Jan 2016 16:55:21 -0800 (PST)
Date: Fri, 22 Jan 2016 16:54:39 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 8/9] vfs: hoist the btrfs deduplication ioctl to the vfs
Message-ID: <20160123005439.GA5496@birch.djwong.org>
References: <20151219085505.12478.71157.stgit@birch.djwong.org>
	<20151219085559.12478.33700.stgit@birch.djwong.org>
	<20160112060714.GA4980@zzz>
	<20160112091432.GB7832@birch.djwong.org>
	<20160113023658.GA1551@zzz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160113023658.GA1551@zzz>
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
To: Eric Biggers <ebiggers3@gmail.com>
Cc: linux-api@vger.kernel.org, xfs@oss.sgi.com, hch@infradead.org, linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org

On Tue, Jan 12, 2016 at 08:36:58PM -0600, Eric Biggers wrote:
> On Tue, Jan 12, 2016 at 01:14:32AM -0800, Darrick J. Wong wrote:
> > 
> > Frankly, I also wouldn't mind changing the VFS dedupe ioctl that to something
> > that resembles the clone_range interface:
> > 
> > int ioctl(int dest_fd, FIDEDUPERANGE, struct file_dedupe_range * arg);
> 
> Getting rid of the vectorization certainly avoids a lot of API complexity.  I
> don't know precisely why it was made vectorized in the first place, but to me it
> seems it shouldn't be vectorized unless there's a strong reason for it to be.

I suppose the idea was that you could ask the kernel to dedupe a bunch of files
"atomically" and that locks would be held (at least on the source file) during
the entire operation...?

Ick.  Given that you can have 65536 vectors of 16MB apiece, you could be
reading up to 1TB of data into the pagecache.  That's a lot for a single
ioctl, though I guess we unlock all the inodes between each vector.

(Welll... we don't check for pending signals.  Urk.)

> > Not sure what you mean by 'symmetric', but in any case the convention seems
> > to be that src_fd's storage is shared with dest_fd if there's a match.
> > ...
> > I think the result of an earlier discussion was that src_fd must be readable,
> > and dest_fd must be writable or appendable.
> 
> Deduplication is a strange operation since you're not "reading" or "writing" in
> the traditional sense.  All file data stays exactly the same from a user
> perspective.
> 
> So rather than arbitrarily say that you're "reading" from one file and "writing"
> to the other, one possibility is to have an API where you submit two files and
> the implementation decides how to best deduplicate them.  That could involve
> sharing existing extents in file 1 with file 2; or sharing existing extents in
> file 2 with file 1; or creating a new extent and referencing it from each file.
> It would be up to the implementation to choose the most efficient approach.

That's a very good point!  We needn't limit the API to whatever the first
implementer does; all of the above are valid interpretations of what dedupe
could involve.  I might even argue that this is the use-case for the vectorized
dedupe call -- analyze all these proposed deduplications and figure out the
best plan to make it happen.

(Ofc the current implementation doesn't allow this, but we can change the
code when the singularity happens, etc.)

> But I take it that the existing btrfs ioctl doesn't work that way, and it always
> will share the existing extents in file 1 with file 2.
> 
> That's probably a perfectly fine way to do it, but I was wondering whether it
> really makes sense to hard-code that detail in the API, since an API could be
> defined more generally.
> 
> And from a practical perpective, people using the ioctl to deduplicate two files
> need to know which one to submit to the API as the "source" and which as the
> "destination", if it matters.
> 
> Related to this are the permissions you need on each file descriptor.  Since
> deduplication isn't "reading" or "writing" in the traditional sense it could,
> theoretically, be argued that no permissions at all should be required: neither
> FMODE_READ nor FMODE_WRITE.

I don't like the idea of being able to make major changes to a file that
I've opened with O_RDONLY. :)

I suppose if you're going to allow the FS to figure out its own strategy
and all that, then by the above reasoning one ought to have all the files
opened as writable.

> Most likely are concerns that would make that a bad idea, though.  Perhaps
> someone could create mischief by causing fragmentation in system files.
> 
> If this was previously discussed, can you point me to that discussion?

I don't know if there was a previous discussion, alas.

> The proposed man page is also very brief on permissions, only mentioning them
> indirectly in the error codes section.

There's a lot of unfortunate hand-waving in that manpage -- I wasn't involved
in designing the initial ioctl, so for the most part I'm simply sniffing my
way through based on observed behaviors (of duperemove) and guessing based on
the source code as I write the XFS version. :)

> > > The man page also says you get EPERM if "dest_fd is immutable" and ETXTBSY if
> > > "one of the files is a swap file", which I don't see actually happening in
> > > the implementation; it seems those error codes perhaps exist at all for this
> > > ioctl but rather be left to open(..., O_WRONLY).
> > 
> > Those could be hoisted to the VFS (from the XFS implementation), I think.
> 
> If the destination file has to already be open for writing then it can't be
> immutable.  So I don't think that error code is needed.  Checking for an active
> swapfile, on the other hand, may be valid, although I don't see such a check
> anywhere in the version of the code I'm looking at.

It's at the top of xfs_file_share_range() in the more recent RFCs of XFS reflink.

> > I'll later take a look at how many of these issues apply to clone/clone_range.
> 
> clone and clone_range seem to avoid the two biggest issues I saw: they aren't
> vectorized, and there's a natural distinction between the "source" and the
> "destination" of the operation.  They definitely need careful consideration as
> well, though.

Indeed.  I appreciate your review of the manpages/patches!

--D

> --
> To unsubscribe from this list: send the line "unsubscribe linux-api" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
