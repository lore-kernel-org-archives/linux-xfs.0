Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:18306 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752633AbdLMC7c (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 12 Dec 2017 21:59:32 -0500
Date: Wed, 13 Dec 2017 13:59:28 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: include the XFS magic number in magic.h
Message-ID: <20171213025928.GZ5858@dastard>
References: <1513088469.3476.48.camel@linux.vnet.ibm.com>
 <20171212142615.GA25327@infradead.org>
 <1513089296.3476.52.camel@linux.vnet.ibm.com>
 <20171212143647.GA10887@infradead.org>
 <1513091096.3476.66.camel@linux.vnet.ibm.com>
 <20171212233031.GX5858@dastard>
 <1513122931.3476.97.camel@linux.vnet.ibm.com>
 <20171213001342.GY5858@dastard>
 <1513128072.3476.121.camel@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1513128072.3476.121.camel@linux.vnet.ibm.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-xfs <linux-xfs@vger.kernel.org>

On Tue, Dec 12, 2017 at 08:21:12PM -0500, Mimi Zohar wrote:
> On Wed, 2017-12-13 at 11:13 +1100, Dave Chinner wrote:
> > On Tue, Dec 12, 2017 at 06:55:31PM -0500, Mimi Zohar wrote:
> > > Based on file system, I could differentiate which files need to be
> > > signed.  For example, the root file system might require files
> > > signatures only on executables, while for other file systems all files
> > > could require signatures.
> > 
> > What's the filesystem magic number got to do with where the
> > filesystem is mounted or what it contains?

<silence>

[....]

> > > Unfortunately, not all filesystems support xattrs (eg.
> > > cpio/initramfs).
> > 
> > So add support to them....
> 
> Definitely, that would be the best solution!  Anyone have time and is
> interested in adding xattr support to CPIO?

One who needs the functionality finds the resources....

> > > scripts/sign-file is used to append a file signature to kernel
> > > modules.  This same script could be used for signing other files, like
> > > the kexec kernel image and initramfs.
> > 
> > This doesn't require knowing about what type of filesystem the file
> > is read from. It's just data appended to the file, and you can
> > already read filesystem without knowing what the underlying
> > filesystem implementation is....
> 
> Agreed, this is in response to your question "What's an appended
> signature".

Sure, but ...

>  The context was defining policy rules for testing, which
> either require different types of files signatures or require
> signatures for different file types, on a per file system basis.

... you still haven't explained why you need the filesystem magic
number for this or even why you need to have different
methods/policies for different filesystem types.

> Sigh, this patch was not suppose to be controversial.

It's not controversial, it's just wrong. :)

There are around 40 defined magic numbers in the XFS on-disk format.
They all get defined in the XFS on-disk format headers and should
not be used outside the XFS code.

>  Most, if not
> all, of the other file systems are included in magic.h.

And your point is?  Seriously, using filesystem magic numbers in the
kernel for detecting filesystems is misguided because:

	a) they don't uniquely identify a filesystem, and

	b) superblocks already have a struct file_system_type
	(sb->s_type) attached to them that is used explicity for
	identifying the filesystem type *by name*.

IOWs, if you need to identify a filesystem *type*, using internal
magic numbers is not the way to do it. selinux, for example, checks
sb->s_type->name quite a lot....

Cheers,

Dave.

-- 
Dave Chinner
david@fromorbit.com
