Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:50338 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751385AbdC0Pkn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 27 Mar 2017 11:40:43 -0400
Date: Mon, 27 Mar 2017 08:40:03 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: statx manpage
Message-ID: <20170327154003.GA5716@birch.djwong.org>
References: <20170307050140.GA12946@infradead.org>
 <20170307000609.GG5280@birch.djwong.org>
 <10435.1488907375@warthog.procyon.org.uk>
 <20170324205322.GA4986@gmail.com>
 <E6DB8461-22DE-496C-8A4A-B0A2F3702750@dilger.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E6DB8461-22DE-496C-8A4A-B0A2F3702750@dilger.ca>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Andreas Dilger <adilger@dilger.ca>
Cc: Eric Biggers <ebiggers3@gmail.com>, David Howells <dhowells@redhat.com>, Christoph Hellwig <hch@infradead.org>, "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, xfs <linux-xfs@vger.kernel.org>

On Sun, Mar 26, 2017 at 06:46:43PM -0600, Andreas Dilger wrote:
> 
> > On Mar 24, 2017, at 2:53 PM, Eric Biggers <ebiggers3@gmail.com> wrote:
> > 
> > On Tue, Mar 07, 2017 at 05:22:55PM +0000, David Howells wrote:
> >> STATX_ALL	[All currently available stuff]
> >> .TE
> >> .in
> >> .PP
> >> .B "Do not"
> >> simply set
> >> .I mask
> >> to UINT_MAX as one or more bits may, in future, be used to specify an extension
> >> to the buffer.
> > 
> > To clarify, will an "extension to the buffer" be an increase in the size of
> > struct statx?  I think it would have to be, otherwise programs filling a struct
> > statx with STATX_ALL would start breaking as soon as they're rebuilt with the
> > new value of STATX_ALL, no?  Or would these "extension to the buffer" bits not
> > be added to STATX_ALL ...?
> 
> The value of STATX_ALL would match the size of struct statx in the header at
> compilation time, so this would always be consistent.
> > 
> > And I don't suppose there's anything we can do to stop programs from asking
> > for mask bits that haven't been defined yet, then breaking later if they
> > happen to be defined as "extensions"?  Maybe adding an extra "buffer size"
> > argument to the syscall?
> 
> You can't stop applications from doing dumb things, like asking to read 1MB
> of data into a buffer that is only 512KB in size.  That will also work fine
> as long as the application only reads a files smaller than 512KB.
> 
> Similarly, if the statx() API says that the STATX_ALL mask is the list of
> currently-supported bits, but the app asks for more bits than it allocates
> a buffer for, there isn't much that the kernel can do.
> 
> > I'm concerned that the idea of "extensions" isn't well thought out, and in
> > practice we'll just be stuck with the current struct size (256 bytes) forever.
> 
> The extensions work exactly as they should - the client sets bits for fields
> that it needs (and by definition it shouldn't ask for anything that it doesn't
> understand), and the kernel masks this down to the bits that it understands.
> 
> If the client asks for more bits than the kernel understands, it is likely a
> newer application on an older kernel, and it will only get back the fields
> that the kernel understands.  The reverse (client asking for fewer bits than
> the kernel understands) is normal behaviour for this interface.  The kernel
> should only fill in fields that the client requested and for which there is
> space in the struct.

During the statx session at LSF last week I asked if filesystems ought
to fill in fields that weren't asked for (btime, specifically) and the
impression I got was that it's ok to go ahead and fill out fields that
weren't asked for if we already have the data.

Since statx backends can do that, they'll have to check the structure
size, and not rely on "you asked for this field so we assume that you
allocated enough memory in userspace to hold it".

Or we could just shift the precedent now -- programs only get the
information they ask for, and in asking for it we assume that we can
write to that part of the buffer.  Frankly I'd prefer that behavior (see
the XFS statx patch), but I don't own the interface. :)

--D

> 
> Cheers, Andreas
> 
> 
> 
> 
> 


