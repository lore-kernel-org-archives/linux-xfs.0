Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id A83C17F47
	for <xfs@oss.sgi.com>; Tue, 12 Jan 2016 03:15:14 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 7B64330405F
	for <xfs@oss.sgi.com>; Tue, 12 Jan 2016 01:15:14 -0800 (PST)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id Tz1P4xW6hy0jit5j (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 12 Jan 2016 01:15:10 -0800 (PST)
Date: Tue, 12 Jan 2016 01:14:32 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 8/9] vfs: hoist the btrfs deduplication ioctl to the vfs
Message-ID: <20160112091432.GB7832@birch.djwong.org>
References: <20151219085505.12478.71157.stgit@birch.djwong.org>
	<20151219085559.12478.33700.stgit@birch.djwong.org>
	<20160112060714.GA4980@zzz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160112060714.GA4980@zzz>
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

[adding btrfs to the cc since we're talking about a whole new dedupe interface]

On Tue, Jan 12, 2016 at 12:07:14AM -0600, Eric Biggers wrote:
> Some feedback on the VFS portion of the FIDEDUPERANGE ioctl and its man page...
> (note: I realize the patch is mostly just moving the code that already existed
> in btrfs, but in the VFS it deserves a more thorough review):

Wheee. :)

Yes, let's discuss the concerns about the btrfs extent same ioctl.

I believe Christoph dislikes about the odd return mechanism (i.e. status and
bytes_deduped) and doubts that the vectorization is really necessary.  There's
not a lot of documentation to go on aside from "Do whatever the BTRFS ioctl
does".  I suspect that will leave my explanations lackng, since I neither
designed the btrfs interface nor know all that much about the decisions made to
arrive at what we have now.

(I agree with both of hch's complaints.)

Really, the best argument for keeping this ioctl is to avoid breaking
duperemove.  Even then, given that current duperemove checks for btrfs before
trying to use BTRFS_IOC_EXTENT_SAME, we could very well design a new dedupe
ioctl for the VFS, hook the new dedupers (XFS) into the new VFS ioctl
leaving the old btrfs ioctl intact, and train duperemove to try the new
ioctl and fall back on the btrfs one if the VFS ioctl isn't supported.

Frankly, I also wouldn't mind changing the VFS dedupe ioctl that to something
that resembles the clone_range interface:

int ioctl(int dest_fd, FIDEDUPERANGE, struct file_dedupe_range * arg);

struct file_dedupe_range {
    __s64 src_fd;
    __u64 src_offset;
    __u64 length;
    __u64 dest_offset;
    __u64 flags;
};

"See if the byte range src_offset:length in src_fd matches all of
dest_offset:length in dest_fd; if so, share src_fd's physical storage with
dest_fd.  Both fds must be files; if they are the same file the ranges cannot
overlap; src_fd must be readable; dest_fd must be writable or append-only.
Offsets and lengths probably need to be block-aligned, but that is filesystem
dependent."

The error conditions would be superset of the ones we know about today.  I'd
return EOVERFLOW or something if length is longer than the FS wants to deal
with.

Now all the vectorization problems go away, and since it's a new VFS interface
we can define everything from the start.

Christoph, if this new interface solves your complaints I think I'd like to get
started on the code/docs soon.

> At high level, I am confused about what is meant by the "source" and
> "destination" files.  I understand that with more than two files, you
> effectively have to choose one file to treat specially and dedupe with all
> the other files (an NxN comparison isn't realistic).  But with just two
> files, a deduplication operation should be completely symmetric, should it
> not?  The end

Not sure what you mean by 'symmetric', but in any case the convention seems
to be that src_fd's storage is shared with dest_fd if there's a match.

> result should be that the data is deduplicated, regardless of the order in
> which I gave the file descriptors.  So why is there some non-symmetric
> behavior?  There are several examples but one is that the VFS is checking
> !S_ISREG() on the "source" file descriptor but not on the "destination" file
> descriptor.

The dedupe_range function pointer should only be supplied for regular files.

> Another is that different permissions are required on the source versus on
> the destination.  If there are good reasons for the nonsymmetry then this
> needs to be clearly explained in the man page; otherwise it may not be clear
> what to use as the "source" and what to use as the "destination".
> 
> It seems odd to be adding "copy" as a system call but then have "dedupe" and
> "clone" as ioctls rather than system calls... it seems that they should all
> be one or the other (at least, if we put aside the fact that the ioctls
> already exist in btrfs).

We can't put the clone ioctl aside; coreutils has already started using it.

I'm not sure if clone_range or extent_same are all that popular, though.
AFAIK duperemove is the only program using extent_same, and I don't know
of anything using clone_range.

(Well, xfs_io does...)

> The range checking in clone_verify_area() appears incomplete.  Someone could
> provide len=UINT64_MAX and all the checks would still pass even though
> 'pos+len' would overflow.

Yeah...

> Should the ioctl be interruptible?  Right now it always goes through *all*
> the 'struct file_dedupe_range_info's you passed in --- potentially up to
> 65535 of them.

There probably ought to be explicit signal checks, or we could just get rid
of the vectorization entirely. :)

> Why 'info->bytes_deduped += deduped' rather than 'info->bytes_deduped =
> deduped'?  'bytes_deduped' is per file descriptor, not for the operation as a
> whole.

Right, because bytes_deduped is a part of file_dedup_range_info, not
file_dedupe_range.

(Note the bytes_deduped = 0 earlier in the function.)

> What permissions do you need on the destination file descriptors?  The man
> page implies they must be open for writing and not appending.  The
> implementation differs: it requires FMODE_WRITE only for non-admin users, and
> it doesn't check for O_APPEND at all.

I think the result of an earlier discussion was that src_fd must be readable,
and dest_fd must be writable or appendable.

> The man page also says you get EPERM if "dest_fd is immutable" and ETXTBSY if
> "one of the files is a swap file", which I don't see actually happening in
> the implementation; it seems those error codes perhaps exist at all for this
> ioctl but rather be left to open(..., O_WRONLY).

Those could be hoisted to the VFS (from the XFS implementation), I think.

> If the filesystem doesn't support deduplication, or I pass in a strange file
> descriptor such as one for a named pipe, do I get EINVAL or EOPNOTSUPP?  The
> man page isn't clear.

Should be EOPNOTSUPP if dest_fd isn't a regular file; EISDIR if either are
directories; and EINVAL for any other kind of non-file fd.  I suspect the
clone* manpages don't make this too clear either.

> Under what circumstances will 'bytes_deduped' differ from the count that was
> passed in?

btrfs/xfs will only compare the first 16MB.  Not documented anywhere. :(

> If short counts are allowed, what will be the 'status' be in that case:
> FILE_DEDUP_RANGE_DIFFERS, FILE_DEDUPE_RANGE_SAME, or something else?

One of those two.

> Can data be deduped even if only a prefix of the data region matches?

No.

> The man page doesn't mention FILE_DEDUPE_RANGE_SAME at all, instead calling it
> 0; it only mentions FILE_DEDUPE_RANGE_DIFFERS.

Oops, good catch. :(

> The man page isn't clear about whether the ioctl stops early if an error
> occurs or always processes all the 'struct file_dedupe_range_info's you pass
> in.  And if it were, hypothetically, to stop early, how is the user meant to
> know on which file it stopped?

I don't know if this should be the official behavior, but it stopped at
whichever file_dedupe_range_info has both status and bytes_deduped set to zero.

> The man page says "logical_offset" but in the struct it is called
> "dest_offset".

Oops.

> There are some variables named "same" which don't really make sense now that
> the ioctl is called FIDEDUPERANGE instead of EXTENT_SAME.

Perhaps not.

I'll later take a look at how many of these issues apply to clone/clone_range.

--D

> 
> Eric
> --
> To unsubscribe from this list: send the line "unsubscribe linux-api" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
