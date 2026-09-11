Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61CB243CEF3;
	Fri, 11 Sep 2026 11:17:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789125448; cv=none; b=D2rxGz6brMs59bOCxbHSB9XgKmiVheBTLg5NM/JXIiMaeUwP+hsxuIcZH+ZpmkiJUzU3j6K7g/l3OyhqI3d3AEm39xnhmkR5BoeuEvsHUwFR8oXB3XUFKcTYwKhzluJFB9VTZ1PZvD94abbw10fNyGFt/fHf92WF4m2e67eAQMI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789125448; c=relaxed/simple;
	bh=5rpnsxtir7gI3WZ0JL6ctgMtAPwo2XBZSyL/Whzi3sI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MdZ6a2d8TMU8LPu1A49mcaNevRg/uikG85MMYhmAzP/HbnIri+n1L7CuervkesGo65nxFBFai/Htr4saos7wK8JyztiBNh6FF9L35xijFkwomQKRbMvke3yF4n0qiXgKq20xX9uP12xGrHVjaCukue4IUdIRzJaaAIEmOrrx5iM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=c+7czgRI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="c+7czgRI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B3861F000FF;
	Fri, 11 Sep 2026 11:17:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789125436;
	bh=GJknxmTRlHM6hii7B9W1p75sUvxbw7pA2UQYmJy++BY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=c+7czgRIgwMg8WqJbLxrsmUmgk+Un+D9FBzijuX65SjEvc8YO4qphiFBiUVNZ6Frb
	 MU9RgIFmB0gnSPkrKmTvBoAwR64wMolS2ZHufZWqRhiT/H7SZkeKKSEIAEE7sUV+HR
	 qbucisYKAaZa0jwkXW042SWEYR8B8PxvX1ni+CXFi2z8lpsM8NQmJJtAsFvGuGusLh
	 Ura1fflQyBwuQsFovEWw58qYrTrUBYouVZ6117k7be1EJyp5//yizapEXDE4BM5WMk
	 u80ntt2UENLRqUveBbsZ9r1q7/kOVycNcWQwnQqEouUdROm/MQuthHi2bZoVvd+ux5
	 ABS44KN/6d7kg==
Date: Fri, 11 Sep 2026 13:17:12 +0200
From: Andrey Albershteyn <aalbersh@kernel.org>
To: Alejandro Colomar <alx@kernel.org>
Cc: linux-man@vger.kernel.org, linux-xfs@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@lst.de>, djwong@kernel.org, 
	linux-api@vger.kernel.org
Subject: Re: [PATCH v2] man/man2: introduce man page for
 file_getattr/file_setattr syscalls
Message-ID: <aqPg20OSbTsxRd6-@aalbersh-thinkpadx1carbongen13.rmtcz.csb>
References: <20260910104120.3964799-1-aalbersh@kernel.org>
 <aqKgTGHh3nDnM3eh@devuan>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aqKgTGHh3nDnM3eh@devuan>

Hi Alejandro,

Thanks for the review, I will apply your suggestions, responses to
some of the questions below:

On 2026-09-10 15:20:25, Alejandro Colomar wrote:
> Hi Andrey,
> 
> > Date: 2026-09-10 12:41:18+0200
> > From: Andrey Albershteyn <aalbersh@kernel.org>
> >
> > Add manual pages for file_getattr() and file_setattr() syscalls and
> > struct file_attr used as input/output argument.
> > 
> > Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
> > Link: https://lore.kernel.org/all/20250630-xattrat-syscall-v6-0-c4e3bc35227b@kernel.org/
> > 
> > ---
> > v2: a few grammar fixes, sashiko.dev fixes (wrong AT_FDCWD combined with
> > AT_EMPTY_PATH description, unused "dfd") and dropped requirement to zero
> > fattr before using file_setattr().
> > ---
> >  man/man2/file_getattr.2      | 279 +++++++++++++++++++++++++++++
> >  man/man2/file_setattr.2      | 333 +++++++++++++++++++++++++++++++++++
> >  man/man2type/file_attr.2type | 187 ++++++++++++++++++++
> >  3 files changed, 799 insertions(+)
> >  create mode 100644 man/man2/file_getattr.2
> >  create mode 100644 man/man2/file_setattr.2
> >  create mode 100644 man/man2type/file_attr.2type
> > 
> > diff --git a/man/man2/file_getattr.2 b/man/man2/file_getattr.2
> > new file mode 100644
> > index 000000000000..2d9a6d338a5e
> > --- /dev/null
> > +++ b/man/man2/file_getattr.2
> > @@ -0,0 +1,279 @@
> > +.\" Copyright, the authors of the Linux man-pages project
> > +.\"
> > +.\" SPDX-License-Identifier: Linux-man-pages-copyleft
> > +.\"
> > +.TH file_getattr 2 (date) "Linux man-pages (unreleased)"
> > +.SH NAME
> > +file_getattr \- get filesystem inode attributes
> > +.SH SYNOPSIS
> > +.nf
> > +.BR "#include <linux/fcntl.h>" "      /* " AT_* " constants */"
> > +.BR "#include <linux/fs.h>" "         /* struct " file_attr " and " FS_XFLAG_* " constants */"
> 
> Most of the time, we don't document in these comments where types come
> from.  They are already documented in the man2type manual page for the
> type, so this is a bit redundant.  We limit these comments to constants.

I will drop the 'struct "file_attr " and ' then

> 
> (In a few cases, we document the types too, but those are mistakes that
>  we should fix.)
> 
> > +.BR "#include <sys/syscall.h>" "      /* " SYS_* " constants */"
> > +.B #include <unistd.h>
> > +.P
> > +.B long syscall(SYS_file_getattr,
> > +.BI "               int " dirfd ", const char *" pathname ,
> 
> We now use 'path' quite consistently for these parameter names.
> See this commit:
> 
> 	commit a239bc4520d6cb8b4d217510c22eddd7c3fd5d10
> 	Author: Alejandro Colomar <alx@kernel.org>
> 	Date:   2025-01-15 20:41:01 +0100
> 
> 	    man/: Consistently use 'path' for parameters referring to pathnames
> 	    
> 	    And use 'pathname' in the descriptions.
> 	    
> 	    'pathname' is the POSIXly correct term, and 'path' is a reasonable
> 	    abbreviation for it in parameter names.
> 	    
> 	    Cc: "G. Branden Robinson" <branden@debian.org>
> 	    Signed-off-by: Alejandro Colomar <alx@kernel.org>
> 
> 	diff --git a/man/man2/acct.2 b/man/man2/acct.2
> 	index d2d1be1c4fc6..fe3606c17752 100644
> 	--- a/man/man2/acct.2
> 	+++ b/man/man2/acct.2
> 	@@ -12,7 +12,7 @@ .SH SYNOPSIS
> 	 .nf
> 	 .B #include <unistd.h>
> 	 .P
> 	-.BI "int acct(const char *_Nullable " filename );
> 	+.BI "int acct(const char *_Nullable " path );
> 	 .fi
> 	 .P
> 	 .RS -4
> 	@@ -34,10 +34,10 @@ .SH DESCRIPTION
> 	 The
> 	 .BR acct ()
> 	 system call enables or disables process accounting.
> 	-If called with the name of an existing file as its argument,
> 	+If called with the pathname of an existing file as its argument,
> 	 accounting is turned on,
> 	-and records for each terminating process are appended to
> 	-.I filename
> 	+and records for each terminating process
> 	+are appended to the file
> 	 as it terminates.
> 	 An argument of NULL causes accounting to be turned off.
> 	 .SH RETURN VALUE
> 	...
> 
> > +.BI "               struct file_attr *" fattr ", size_t " size ,
> > +.BI "               unsigned int " flags );
> > +.fi
> > +.P
> > +.IR Note :
> > +glibc provides no wrapper for
> > +.BR file_getattr (),
> > +use
> > +.BR syscall (2)
> > +instead.
> 
> I've been trying to remove this sentence from manual pages.  This note
> was originally introduced when manual pages used syntax as if the
> wrapper existed, but some years ago we started using syscall()
> explicitly, which already clrearly notices this, so this is superfluous.
> Let's not add more.  (I'll remove the existing ones eventually.)
> 
> > +.SH DESCRIPTION
> > +The
> > +.BR file_getattr ()
> > +system call retrieves filesystem file attributes
> > +from the file specified by
> > +.IR pathname .
> > +.P
> > +This system call provides functionality similar to the
> > +.B FS_IOC_FSGETXATTR
> > +.BR ioctl (2)
> > +operation,
> 
> Should we document FS_IOC_FSGETXATTR in a new FS_IOC_FSGETXATTR(2const)
> manual page?
> 
> > +but with the advantage that the file does not need to be opened.
> > +By using a pathname,
> > +.BR file_getattr ()
> > +can retrieve filesystem file attributes
> > +from all file types,
> > +including special files such as FIFOs, sockets, block devices, character
> > +devices, and symlinks, where opening the targeted inode may not be possible.
> 
> This seems to be a limitation of FS_IOC_FSGETXATTR(2const), and would be
> more appropriately documented in that page (if we add it).  There, I'd
> document it in CAVEATS.  Then, file_getattr(2) wouldn't need to mention
> this at all, because it's not an issue here.
> 
> > +.P
> > +As with
> > +.BR openat (2),
> > +if
> > +.I pathname
> > +is relative,
> > +then it is interpreted relative to the directory
> > +referred to by the file descriptor
> > +.IR dirfd .
> > +The special value
> > +.B AT_FDCWD
> > +could be used to refer to the current working directory of the calling process.
> > +If
> > +.I pathname
> > +is absolute,
> > +then
> > +.I dirfd
> > +is ignored.
> > +.P
> > +The
> > +.I fattr
> > +argument is a pointer to a
> > +.I file_attr
> > +structure.
> > +This structure will be filled with file attributes.
> > +This structure is described in
> > +.BR file_attr(2type) .
> 
> The '(2const)' part shouldn't be in bold.  Thus:
> 
> 	.BR file_attr (2type).
> 
> > +.P
> > +The
> > +.I size
> > +argument specifies the size of the buffer pointed to by
> > +.IR fattr .
> 
> I'd do: s/buffer/structure/
> 
> We say 'size of the buffer' to refer to arrays (and say length,
> to not confuse it with the size in bytes).
> 
> > +The size indicates version of the structure in use, refer to
> > +.B file_attr(2type)
> > +for more information on versioning.
> > +.P
> > +Userspace applications should zero-initialize
> 
> s/Userspace/User-space/
> 
> > +.I struct file_attr
> > +before calling
> > +.BR file_getattr ()
> > +to ensure that fields not filled in by older kernels
> > +will have predictable values.
> > +.P
> > +The
> > +.I flags
> > +argument is a bit mask, available flags are:
> 
> The usual language we use for this is:
> 
> 	The
> 	.I flags
> 	argument contains
> 	a bitwise OR of zero or more of the following constants:
> 
> See for example readv(2).

I will use "constants" then (the readv uses "following flags")

> 
> There are some minor variations of this in other pages, and I should
> make them more uniform.
> 
> > +.TP
> > +.B AT_EMPTY_PATH
> > +If
> > +.I pathname
> > +is an empty string,
> > +operate on the file referred to by
> > +.IR dirfd .
> > +In this case,
> > +.I dirfd
> > +can refer to any type of file,
> > +not just a directory.
> > +.TP
> > +.B AT_SYMLINK_NOFOLLOW
> > +If
> > +.I pathname
> > +is a symbolic link,
> > +do not dereference it;
> > +instead get attributes of the symbolic link inode itself.
> > +By default, symbolic links are dereferenced.
> > +.SH RETURN VALUE
> > +On success,
> > +zero is returned.
> > +On error,
> > +\-1 is returned,
> > +and
> > +.I errno
> > +is set to indicate the error.
> > +.SH ERRORS
> > +.TP
> > +.B E2BIG
> > +.I size
> > +is too big (larger than
> > +.BR PAGE_SIZE ).
> > +.TP
> > +.B EACCES
> > +Search permission is denied for one of the directories
> > +in the path prefix of
> > +.IR pathname .
> > +.TP
> > +.B EBADF
> > +.I pathname
> > +is relative but
> > +.I dirfd
> > +is neither
> > +.B AT_FDCWD
> > +nor a valid file descriptor.
> > +.TP
> > +.B EBADF
> > +.I pathname
> > +is an empty string,
> > +.B AT_EMPTY_PATH
> > +was specified,
> > +but
> > +.I dirfd
> > +is an invalid file descriptor.
> 
> I was wondering: is it valid to specify AT_EMPTY_PATH, use an empty
> string, and use AT_FDCWD as the dirfd?  That should act on the current
> working directory itself, right?  Or is that not supported?

Yes, this is valid combination. I can describe this case.

> 
> > +.TP
> > +.B EFAULT
> > +.I pathname
> > +or
> > +.I fattr
> > +is an invalid pointer.
> > +.TP
> > +.B EINVAL
> > +Invalid flag specified in
> 
> s/Invalid/Unknown/
> 
> You may have specified a valid flag, but the kernel is old and doesn't
> yet know it.
> 
> > +.IR flags .
> > +.TP
> > +.B EINVAL
> > +.I size
> > +is smaller than
> > +.BR FILE_ATTR_SIZE_VER0 .
> 
> perf_event_open(2) reports E2BIG for a size smaller than
> PERF_ATTR_SIZE_VER0.  This seems unnecessarily inconsistent.  I'm not
> sure which I'd say is more appropriate, but I'd expect them to be
> consistent.  I mentioned perf_event_open(2) because that's the only page
> that has a *_VER0 constant and documents an error if a size is smaller
> than it.  There's also mount_setattr(2) which documents
> MOUNT_ATTR_SIZE_VER0, but it's not documented in ERRORS.
> 
> I think kernel maintainers should have a look at the different APIs that
> have such a value, and discuss whether the error codes should be made
> uniform retroactively, or whether we should accept the existing
> divergence but decide on an error code for new APIs.
> 
> I've CCed linux-api@.

The MOUNT_ATTR_SIZE_VER0 also returns an EINVAL

I'm in favor of EINVAL as E2BIG is probably a more confusing naming
for the too small argument.

-- 
- Andrey
