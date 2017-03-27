Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:43677 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751572AbdC0Qq6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 27 Mar 2017 12:46:58 -0400
Date: Mon, 27 Mar 2017 09:46:28 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: statx manpage
Message-ID: <20170327164628.GA15147@infradead.org>
References: <20170327154003.GA5716@birch.djwong.org>
 <20170307050140.GA12946@infradead.org>
 <20170307000609.GG5280@birch.djwong.org>
 <10435.1488907375@warthog.procyon.org.uk>
 <20170324205322.GA4986@gmail.com>
 <E6DB8461-22DE-496C-8A4A-B0A2F3702750@dilger.ca>
 <23715.1490631926@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <23715.1490631926@warthog.procyon.org.uk>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: David Howells <dhowells@redhat.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, Andreas Dilger <adilger@dilger.ca>, Eric Biggers <ebiggers3@gmail.com>, Christoph Hellwig <hch@infradead.org>, "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, xfs <linux-xfs@vger.kernel.org>

On Mon, Mar 27, 2017 at 05:25:26PM +0100, David Howells wrote:
> That means a filesystem can't simply return non-basic data unconditionally if
> possible.  I prefer letting it do so if it doesn't incur any extra I/O
> overheads.

This seems like it will lead to userspace expecting certain fields to
just be there, and a lot harder to properly verify for tests.  Which btw
we all need for these odd behaviors.  If we can't get them any time soon
(e.g. before -rc6) I think we'll simply have to revert statx instead of
leaving this untested mess in the tree.
