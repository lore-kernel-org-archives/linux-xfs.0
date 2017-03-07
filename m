Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:38966 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756082AbdCGSpM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 7 Mar 2017 13:45:12 -0500
Date: Tue, 7 Mar 2017 10:44:35 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: statx manpage
Message-ID: <20170307184435.GG5281@birch.djwong.org>
References: <20170307180217.GF5281@birch.djwong.org>
 <20170307050140.GA12946@infradead.org>
 <20170307000609.GG5280@birch.djwong.org>
 <10435.1488907375@warthog.procyon.org.uk>
 <10985.1488911982@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <10985.1488911982@warthog.procyon.org.uk>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: David Howells <dhowells@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, mtk.manpages@gmail.com, linux-fsdevel <linux-fsdevel@vger.kernel.org>, xfs <linux-xfs@vger.kernel.org>

On Tue, Mar 07, 2017 at 06:39:42PM +0000, David Howells wrote:
> Darrick J. Wong <darrick.wong@oracle.com> wrote:
> 
> > Is (flags & AT_EMPTY_PATH) is the same as (pathname == NULL)?
> 
> I'm not sure.  I was wondering about that whilst writing this.  The text
> describing the option is copied from the stat(2) manpage.  It specified an
> empty path (presumably "") rather than NULL.  I'm also not sure whether it has
> other ramifications.

<nod>

> > > .I Note:
> > > For performance and simplicity reasons, different fields in the
> > > .I statx
> > > structure may contain state information from different moments
> > > during the execution of the system call.
> > 
> > Hm.  Judging from the ext4 patch you proposed, I gather this is
> > expected, at least in the btime case.

Ugh, I put that in the wrong part -- this was supposed to be a comment
about the part where the manpage states that filesystems can return more
than userspace asked for.  My eyes are bad at reading manpage source. :/

(Sorry for the noise.)

--D

> This is copied from the stat(2) manpage.  The comment in the source there says
> it's because there's no locking in the getattr path against the setattr path.
> 
> David
