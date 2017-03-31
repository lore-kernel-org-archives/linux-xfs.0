Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:55982 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933128AbdCaPth (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 31 Mar 2017 11:49:37 -0400
Date: Fri, 31 Mar 2017 08:49:31 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: statx manpage
Message-ID: <20170331154931.GA7235@infradead.org>
References: <20170327154003.GA5716@birch.djwong.org>
 <20170307050140.GA12946@infradead.org>
 <20170307000609.GG5280@birch.djwong.org>
 <10435.1488907375@warthog.procyon.org.uk>
 <20170324205322.GA4986@gmail.com>
 <E6DB8461-22DE-496C-8A4A-B0A2F3702750@dilger.ca>
 <23715.1490631926@warthog.procyon.org.uk>
 <20170327164628.GA15147@infradead.org>
 <1490641451.9691.4.camel@poochiereds.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1490641451.9691.4.camel@poochiereds.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jeff Layton <jlayton@poochiereds.net>
Cc: Christoph Hellwig <hch@infradead.org>, David Howells <dhowells@redhat.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, Andreas Dilger <adilger@dilger.ca>, Eric Biggers <ebiggers3@gmail.com>, "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, xfs <linux-xfs@vger.kernel.org>

On Mon, Mar 27, 2017 at 03:04:11PM -0400, Jeff Layton wrote:
> I think we just have to clearly document that that will not be the
> case. If they really expect the field to be there, then they need to
> set the bit in the "want" mask -- it's really as simple as that.

If the usual local file systems set it but say NFS doesn't I will
very much expect that people don't set the flag and create buggy
programs a lot.  An API that doesn't give you more than you ask
for is a lot more obvious.
