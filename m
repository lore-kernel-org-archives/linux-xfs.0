Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pg0-f67.google.com ([74.125.83.67]:33929 "EHLO
        mail-pg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754459AbdCXUx0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 24 Mar 2017 16:53:26 -0400
Date: Fri, 24 Mar 2017 13:53:22 -0700
From: Eric Biggers <ebiggers3@gmail.com>
Subject: Re: statx manpage
Message-ID: <20170324205322.GA4986@gmail.com>
References: <20170307050140.GA12946@infradead.org>
 <20170307000609.GG5280@birch.djwong.org>
 <10435.1488907375@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <10435.1488907375@warthog.procyon.org.uk>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: David Howells <dhowells@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, mtk.manpages@gmail.com, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, xfs <linux-xfs@vger.kernel.org>

On Tue, Mar 07, 2017 at 05:22:55PM +0000, David Howells wrote:
> STATX_ALL	[All currently available stuff]
> .TE
> .in
> .PP
> .B "Do not"
> simply set
> .I mask
> to UINT_MAX as one or more bits may, in future, be used to specify an extension
> to the buffer.

To clarify, will an "extension to the buffer" be an increase in the size of
struct statx?  I think it would have to be, otherwise programs filling a struct
statx with STATX_ALL would start breaking as soon as they're rebuilt with the
new value of STATX_ALL, no?  Or would these "extension to the buffer" bits not
be added to STATX_ALL ...?

And I don't suppose there's anything we can do to stop programs from asking for
mask bits that haven't been defined yet, then breaking later if they happen to
be defined as "extensions"?  Maybe adding an extra "buffer size" argument to the
syscall?

I'm concerned that the idea of "extensions" isn't well thought out, and in
practice we'll just be stuck with the current struct size (256 bytes) forever.

- Eric
