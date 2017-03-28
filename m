Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:51386 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754563AbdC1Ir0 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 28 Mar 2017 04:47:26 -0400
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20170328062825.GA11567@infradead.org>
References: <20170328062825.GA11567@infradead.org> <20170327164628.GA15147@infradead.org> <20170327154003.GA5716@birch.djwong.org> <20170307050140.GA12946@infradead.org> <20170307000609.GG5280@birch.djwong.org> <10435.1488907375@warthog.procyon.org.uk> <20170324205322.GA4986@gmail.com> <E6DB8461-22DE-496C-8A4A-B0A2F3702750@dilger.ca> <23715.1490631926@warthog.procyon.org.uk> <23003.1490660007@warthog.procyon.org.uk>
Subject: Re: [PATCH] Add initial batch of statx() LTP tests
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <26587.1490689414.1@warthog.procyon.org.uk>
Date: Tue, 28 Mar 2017 09:23:34 +0100
Message-ID: <26588.1490689414@warthog.procyon.org.uk>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: dhowells@redhat.com, "Darrick J. Wong" <darrick.wong@oracle.com>, Andreas Dilger <adilger@dilger.ca>, Eric Biggers <ebiggers3@gmail.com>, "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, xfs <linux-xfs@vger.kernel.org>

Christoph Hellwig <hch@infradead.org> wrote:

> ltp is a trainwreck.  Please send xfstests test like for all other file
> system functionality.  You're really trying to make it as hard as
> possible for fs developers, don't you?

Sorry, Christoph, but, in my opinion, xfstests is in worse shape than LTP.
It's not self-contained (the code to make statx available seems to have to be
added to xfsprogs) and it's practically undocumented.  LTP, on the other hand,
is pretty easy to modify.

David
