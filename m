Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:43030 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932866AbdCGSuZ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 7 Mar 2017 13:50:25 -0500
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20170307180217.GF5281@birch.djwong.org>
References: <20170307180217.GF5281@birch.djwong.org> <20170307050140.GA12946@infradead.org> <20170307000609.GG5280@birch.djwong.org> <10435.1488907375@warthog.procyon.org.uk>
Subject: Re: statx manpage
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <10984.1488911982.1@warthog.procyon.org.uk>
Date: Tue, 07 Mar 2017 18:39:42 +0000
Message-ID: <10985.1488911982@warthog.procyon.org.uk>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: dhowells@redhat.com, Christoph Hellwig <hch@infradead.org>, mtk.manpages@gmail.com, linux-fsdevel <linux-fsdevel@vger.kernel.org>, xfs <linux-xfs@vger.kernel.org>

Darrick J. Wong <darrick.wong@oracle.com> wrote:

> Is (flags & AT_EMPTY_PATH) is the same as (pathname == NULL)?

I'm not sure.  I was wondering about that whilst writing this.  The text
describing the option is copied from the stat(2) manpage.  It specified an
empty path (presumably "") rather than NULL.  I'm also not sure whether it has
other ramifications.

> > .I Note:
> > For performance and simplicity reasons, different fields in the
> > .I statx
> > structure may contain state information from different moments
> > during the execution of the system call.
> 
> Hm.  Judging from the ext4 patch you proposed, I gather this is
> expected, at least in the btime case.

This is copied from the stat(2) manpage.  The comment in the source there says
it's because there's no locking in the getattr path against the setattr path.

David
