Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58110 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751217AbdCHJ7k (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 8 Mar 2017 04:59:40 -0500
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20170307225533.GA1403@zzz>
References: <20170307225533.GA1403@zzz> <20170307050140.GA12946@infradead.org> <20170307000609.GG5280@birch.djwong.org> <10435.1488907375@warthog.procyon.org.uk>
Subject: Re: statx manpage
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <17956.1488966060.1@warthog.procyon.org.uk>
Date: Wed, 08 Mar 2017 09:41:00 +0000
Message-ID: <17957.1488966060@warthog.procyon.org.uk>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Biggers <ebiggers3@gmail.com>
Cc: dhowells@redhat.com, Christoph Hellwig <hch@infradead.org>, mtk.manpages@gmail.com, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, xfs <linux-xfs@vger.kernel.org>

Eric Biggers <ebiggers3@gmail.com> wrote:

> > .I Note:
> > For performance and simplicity reasons, different fields in the
> > .I statx
> > structure may contain state information from different moments
> > during the execution of the system call.
> > For example, if
> > .IR stx_mode
> > or
> > .IR stx_uid
> > is changed by another process by calling
> > .BR chmod (2)
> > or
> > .BR chown (2),
> > .BR stat ()
> > might return the old
> > .I stx_mode
> > together with the new
> > .IR stx_uid ,
> > or the old
> > .I stx_uid
> > together with the new
> > .IR stx_mode .
> 
> This example is confusing because chmod() doesn't change st_uid, and chown()
> doesn't ordinarily change st_mode.

Doesn't chown() clear the S_ISUID and S_ISGID flags?

> A better example would be that if chown() is used to change both the owner
> and group, it's possible that statx() would return the new owner paired with
> the old group, or the new group paired with the old owner.  Or, the new
> owner and group could be observed before the new ctime.

This is copied more or less verbatim from stat(2), so what you said applies
there too.

> Also, it seems this note belongs in a BUGS section of the man page, since it
> is a bug.

No, it's not a bug, exactly.  It's a design decision.  It might be worth
adding an AT_STAT_LOCK flag to synchronise against attribute setting, but it
will cost you something in terms of performance - and even then, over a
network filesystem it might not achieve anything.

> > .SH ERRORS
> > .TP
> > .B EINVAL
> > Invalid flag specified in
> > .IR flags .
> 
> Actually, the behavior when specifying invalid flags differs depending on
> whether a path is specified.

Good point.  Should I reject AT_EMPTY_PATH, AT_NO_AUTOMOUNT and
AT_SYMLINK_NOFOLLOW if pathname is NULL, I wonder?

> > .B ENOENT
> > A component of
> > .I pathname
> > does not exist, or
> > .I pathname
> > is an empty string.
> 
> is an empty string and AT_EMPTY_PATH was not specified in flags.

That needs fixing in stat(2) also.

> > .SH SEE ALSO
> > .BR ls (1),
> > .BR stat (1),
> 
> Shouldn't this link to stat (2), not stat (1)?

Depends whether stat(1) ends up using statx() or not.  I can take it out for
now.

David
