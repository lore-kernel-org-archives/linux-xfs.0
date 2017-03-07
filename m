Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:50730 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756403AbdCGWmn (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 7 Mar 2017 17:42:43 -0500
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20170307184435.GG5281@birch.djwong.org>
References: <20170307184435.GG5281@birch.djwong.org> <20170307180217.GF5281@birch.djwong.org> <20170307050140.GA12946@infradead.org> <20170307000609.GG5280@birch.djwong.org> <10435.1488907375@warthog.procyon.org.uk> <10985.1488911982@warthog.procyon.org.uk>
Subject: Re: statx manpage
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <11209.1488912933.1@warthog.procyon.org.uk>
Date: Tue, 07 Mar 2017 18:55:33 +0000
Message-ID: <11210.1488912933@warthog.procyon.org.uk>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: dhowells@redhat.com, Christoph Hellwig <hch@infradead.org>, mtk.manpages@gmail.com, linux-fsdevel <linux-fsdevel@vger.kernel.org>, xfs <linux-xfs@vger.kernel.org>

Darrick J. Wong <darrick.wong@oracle.com> wrote:

> > > Hm.  Judging from the ext4 patch you proposed, I gather this is
> > > expected, at least in the btime case.
> 
> Ugh, I put that in the wrong part -- this was supposed to be a comment
> about the part where the manpage states that filesystems can return more
> than userspace asked for.

In that case, sort of.  You could just ask for STATX_TYPE | STATX_MODE, for
example, but the kernel is perfectly at liberty to add STATX_MTIME,
STATX_SIZE, STATX_INO, etc. even if it doesn't add STATX_BTIME as well.

> My eyes are bad at reading manpage source. :/

I know what you mean.

David
