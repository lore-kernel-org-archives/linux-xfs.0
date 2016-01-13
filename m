Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id A16E129DF5
	for <xfs@oss.sgi.com>; Tue, 12 Jan 2016 20:37:05 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 908FD304062
	for <xfs@oss.sgi.com>; Tue, 12 Jan 2016 18:37:02 -0800 (PST)
Received: from mail-io0-f194.google.com (mail-io0-f194.google.com
	[209.85.223.194]) by cuda.sgi.com with ESMTP id
	X6Hg7HUg0PCBMoRp (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 12 Jan 2016 18:37:01 -0800 (PST)
Received: by mail-io0-f194.google.com with SMTP id k127so46384723iok.1
	for <xfs@oss.sgi.com>; Tue, 12 Jan 2016 18:37:01 -0800 (PST)
Date: Tue, 12 Jan 2016 20:36:58 -0600
From: Eric Biggers <ebiggers3@gmail.com>
Subject: Re: [PATCH 8/9] vfs: hoist the btrfs deduplication ioctl to the vfs
Message-ID: <20160113023658.GA1551@zzz>
References: <20151219085505.12478.71157.stgit@birch.djwong.org>
	<20151219085559.12478.33700.stgit@birch.djwong.org>
	<20160112060714.GA4980@zzz>
	<20160112091432.GB7832@birch.djwong.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160112091432.GB7832@birch.djwong.org>
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
Cc: linux-api@vger.kernel.org, xfs@oss.sgi.com, hch@infradead.org, linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org

On Tue, Jan 12, 2016 at 01:14:32AM -0800, Darrick J. Wong wrote:
> 
> Frankly, I also wouldn't mind changing the VFS dedupe ioctl that to something
> that resembles the clone_range interface:
> 
> int ioctl(int dest_fd, FIDEDUPERANGE, struct file_dedupe_range * arg);

Getting rid of the vectorization certainly avoids a lot of API complexity.  I
don't know precisely why it was made vectorized in the first place, but to me it
seems it shouldn't be vectorized unless there's a strong reason for it to be.

> Not sure what you mean by 'symmetric', but in any case the convention seems
> to be that src_fd's storage is shared with dest_fd if there's a match.
> ...
> I think the result of an earlier discussion was that src_fd must be readable,
> and dest_fd must be writable or appendable.

Deduplication is a strange operation since you're not "reading" or "writing" in
the traditional sense.  All file data stays exactly the same from a user
perspective.

So rather than arbitrarily say that you're "reading" from one file and "writing"
to the other, one possibility is to have an API where you submit two files and
the implementation decides how to best deduplicate them.  That could involve
sharing existing extents in file 1 with file 2; or sharing existing extents in
file 2 with file 1; or creating a new extent and referencing it from each file.
It would be up to the implementation to choose the most efficient approach.

But I take it that the existing btrfs ioctl doesn't work that way, and it always
will share the existing extents in file 1 with file 2.

That's probably a perfectly fine way to do it, but I was wondering whether it
really makes sense to hard-code that detail in the API, since an API could be
defined more generally.

And from a practical perpective, people using the ioctl to deduplicate two files
need to know which one to submit to the API as the "source" and which as the
"destination", if it matters.

Related to this are the permissions you need on each file descriptor.  Since
deduplication isn't "reading" or "writing" in the traditional sense it could,
theoretically, be argued that no permissions at all should be required: neither
FMODE_READ nor FMODE_WRITE.

Most likely are concerns that would make that a bad idea, though.  Perhaps
someone could create mischief by causing fragmentation in system files.

If this was previously discussed, can you point me to that discussion?

The proposed man page is also very brief on permissions, only mentioning them
indirectly in the error codes section.

> > The man page also says you get EPERM if "dest_fd is immutable" and ETXTBSY if
> > "one of the files is a swap file", which I don't see actually happening in
> > the implementation; it seems those error codes perhaps exist at all for this
> > ioctl but rather be left to open(..., O_WRONLY).
> 
> Those could be hoisted to the VFS (from the XFS implementation), I think.

If the destination file has to already be open for writing then it can't be
immutable.  So I don't think that error code is needed.  Checking for an active
swapfile, on the other hand, may be valid, although I don't see such a check
anywhere in the version of the code I'm looking at.

> I'll later take a look at how many of these issues apply to clone/clone_range.

clone and clone_range seem to avoid the two biggest issues I saw: they aren't
vectorized, and there's a natural distinction between the "source" and the
"destination" of the operation.  They definitely need careful consideration as
well, though.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
