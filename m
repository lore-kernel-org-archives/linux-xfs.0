Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45224 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751522AbdC0TEL (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 27 Mar 2017 15:04:11 -0400
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20170327164628.GA15147@infradead.org>
References: <20170327164628.GA15147@infradead.org> <20170327154003.GA5716@birch.djwong.org> <20170307050140.GA12946@infradead.org> <20170307000609.GG5280@birch.djwong.org> <10435.1488907375@warthog.procyon.org.uk> <20170324205322.GA4986@gmail.com> <E6DB8461-22DE-496C-8A4A-B0A2F3702750@dilger.ca> <23715.1490631926@warthog.procyon.org.uk>
Subject: Re: statx manpage
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <24755.1490641071.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: 8BIT
Date: Mon, 27 Mar 2017 19:57:51 +0100
Message-ID: <24756.1490641071@warthog.procyon.org.uk>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: dhowells@redhat.com, "Darrick J. Wong" <darrick.wong@oracle.com>, Andreas Dilger <adilger@dilger.ca>, Eric Biggers <ebiggers3@gmail.com>, "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, xfs <linux-xfs@vger.kernel.org>

Christoph Hellwig <hch@infradead.org> wrote:

> On Mon, Mar 27, 2017 at 05:25:26PM +0100, David Howells wrote:
> > That means a filesystem can't simply return non-basic data unconditionally if
> > possible.  I prefer letting it do so if it doesn't incur any extra I/O
> > overheads.
> 
> This seems like it will lead to userspace expecting certain fields to
> just be there, and a lot harder to properly verify for tests.  Which btw
> we all need for these odd behaviors.  If we can't get them any time soon
> (e.g. before -rc6) I think we'll simply have to revert statx instead of
> leaving this untested mess in the tree.

Have you reviewed the manpage yet?

David
