Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:43216 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752582AbdC0J4O (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 27 Mar 2017 05:56:14 -0400
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20170324205322.GA4986@gmail.com>
References: <20170324205322.GA4986@gmail.com> <20170307050140.GA12946@infradead.org> <20170307000609.GG5280@birch.djwong.org> <10435.1488907375@warthog.procyon.org.uk>
Subject: Re: statx manpage
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <5176.1490608516.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: 8BIT
Date: Mon, 27 Mar 2017 10:55:16 +0100
Message-ID: <5177.1490608516@warthog.procyon.org.uk>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Biggers <ebiggers3@gmail.com>
Cc: dhowells@redhat.com, Christoph Hellwig <hch@infradead.org>, mtk.manpages@gmail.com, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, xfs <linux-xfs@vger.kernel.org>

Eric Biggers <ebiggers3@gmail.com> wrote:

> On Tue, Mar 07, 2017 at 05:22:55PM +0000, David Howells wrote:
> > STATX_ALL	[All currently available stuff]
> > .TE
> > .in
> > .PP
> > .B "Do not"
> > simply set
> > .I mask
> > to UINT_MAX as one or more bits may, in future, be used to specify an extension
> > to the buffer.
> 
> To clarify, will an "extension to the buffer" be an increase in the size of
> struct statx?

Yes.  I can make that more explicit, say perhaps "... specify an extension to
the size of the buffer".

> I think it would have to be, otherwise programs filling a struct statx with
> STATX_ALL would start breaking as soon as they're rebuilt with the new value
> of STATX_ALL, no?  Or would these "extension to the buffer" bits not be
> added to STATX_ALL ...?

It would have to work that way.  I can put this in a comment for future
guidance in the kernel header file if you'd prefer.

> And I don't suppose there's anything we can do to stop programs from asking
> for mask bits that haven't been defined yet, then breaking later if they
> happen to be defined as "extensions"?

If someone decides not to read the documentation, one could argue they get
what they deserve.

> Maybe adding an extra "buffer size" argument to the syscall?

This idea has already been rejected.

> I'm concerned that the idea of "extensions" isn't well thought out, and in
> practice we'll just be stuck with the current struct size (256 bytes) forever.

One or more bits (probably just one) are tentatively reserved to indicate that
the buffer is now bigger.  How much bigger I cannot say at this point, not
knowing the circumstances yet that will require the extension.

David
