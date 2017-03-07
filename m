Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pg0-f67.google.com ([74.125.83.67]:34213 "EHLO
        mail-pg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755985AbdCGW4O (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 7 Mar 2017 17:56:14 -0500
Date: Tue, 7 Mar 2017 14:55:33 -0800
From: Eric Biggers <ebiggers3@gmail.com>
Subject: Re: statx manpage
Message-ID: <20170307225533.GA1403@zzz>
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
> .fi
> .in
> .PP
> (Note that reserved space and padding is ommitted)

ommitted => omitted

> .TP
> .BR AT_EMPTY_PATH " (since Linux 2.6.39)"
...
> .TP
> .BR AT_NO_AUTOMOUNT " (since Linux 2.6.38)"

Given that statx is just being added now in 4.11, saying "since Linux 2.6.39"
and "since Linux 2.6.38" for these flags seems unneeded.

> The
> .I mask
> argument to
> .BR statx ()
> is used to tell the kernel which fields the caller is interested in
> .I mask
> is an OR'ed combination of the following constants:

Missing a period between "interested in" and "mask".

> .B "Do not"
> simply set
> .I mask
> to UINT_MAX as one or more bits may, in future, be used to specify an extension
> to the buffer.

"in future" => "in the future".

> .I Note:
> For performance and simplicity reasons, different fields in the
> .I statx
> structure may contain state information from different moments
> during the execution of the system call.
> For example, if
> .IR stx_mode
> or
> .IR stx_uid
> is changed by another process by calling
> .BR chmod (2)
> or
> .BR chown (2),
> .BR stat ()
> might return the old
> .I stx_mode
> together with the new
> .IR stx_uid ,
> or the old
> .I stx_uid
> together with the new
> .IR stx_mode .

This example is confusing because chmod() doesn't change st_uid, and chown()
doesn't ordinarily change st_mode.  A better example would be that if chown() is
used to change both the owner and group, it's possible that statx() would return
the new owner paired with the old group, or the new group paired with the old
owner.  Or, the new owner and group could be observed before the new ctime.
Also, it seems this note belongs in a BUGS section of the man page, since it is
a bug.

> .SH ERRORS
> .TP
> .B EINVAL
> Invalid flag specified in
> .IR flags .

Actually, the behavior when specifying invalid flags differs depending on
whether a path is specified.

If a path is specified, then statx() fails with EINVAL if unrecognized flags are
specified.

However, the behavior differs when no path is specified.  For example, the the
following call with invalid flags succeeds:

	statx(fd, NULL, 0xFFFF0000, 0, &stbuf);

I think this is a bug, and it should be fixed by applying the same 'flags'
validation regardless of whether a path is specified.

> .B ENOENT
> A component of
> .I pathname
> does not exist, or
> .I pathname
> is an empty string.

is an empty string and AT_EMPTY_PATH was not specified in flags.

> .SH SEE ALSO
> .BR ls (1),
> .BR stat (1),

Shouldn't this link to stat (2), not stat (1)?

- Eric
