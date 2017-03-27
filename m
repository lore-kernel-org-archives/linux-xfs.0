Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:51372 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751287AbdC0Q0X (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 27 Mar 2017 12:26:23 -0400
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20170327154003.GA5716@birch.djwong.org>
References: <20170327154003.GA5716@birch.djwong.org> <20170307050140.GA12946@infradead.org> <20170307000609.GG5280@birch.djwong.org> <10435.1488907375@warthog.procyon.org.uk> <20170324205322.GA4986@gmail.com> <E6DB8461-22DE-496C-8A4A-B0A2F3702750@dilger.ca>
Subject: Re: statx manpage
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <23714.1490631926.1@warthog.procyon.org.uk>
Date: Mon, 27 Mar 2017 17:25:26 +0100
Message-ID: <23715.1490631926@warthog.procyon.org.uk>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: dhowells@redhat.com, Andreas Dilger <adilger@dilger.ca>, Eric Biggers <ebiggers3@gmail.com>, Christoph Hellwig <hch@infradead.org>, "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, xfs <linux-xfs@vger.kernel.org>

Darrick J. Wong <darrick.wong@oracle.com> wrote:

> During the statx session at LSF last week I asked if filesystems ought
> to fill in fields that weren't asked for (btime, specifically) and the
> impression I got was that it's ok to go ahead and fill out fields that
> weren't asked for if we already have the data.

Yes.  The filesystem may return data that it wasn't asked for.

> Since statx backends can do that, they'll have to check the structure
> size, and not rely on "you asked for this field so we assume that you
> allocated enough memory in userspace to hold it".

Kind of.  I'm assuming that the extension fields will be in struct kstat and
can be set directly by the filesystem unconditionally, and the core can choose
whether to copy them or not.  However, assuming that one of the mask bits is
reserved to indicate a buffer extension, this will be made available to the fs
to let the fs know whether it's pointless to return it.

However, at the moment I have no extensions to play with.

Would it help you if I marked one of the mask bits reserved for this purpose?

> Or we could just shift the precedent now -- programs only get the
> information they ask for, and in asking for it we assume that we can
> write to that part of the buffer.  Frankly I'd prefer that behavior (see
> the XFS statx patch), but I don't own the interface. :)

That means a filesystem can't simply return non-basic data unconditionally if
possible.  I prefer letting it do so if it doesn't incur any extra I/O
overheads.

David
