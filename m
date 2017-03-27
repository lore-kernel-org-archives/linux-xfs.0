Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-qt0-f171.google.com ([209.85.216.171]:35027 "EHLO
        mail-qt0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751729AbdC0TE0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 27 Mar 2017 15:04:26 -0400
Received: by mail-qt0-f171.google.com with SMTP id x35so46093675qtc.2
        for <linux-xfs@vger.kernel.org>; Mon, 27 Mar 2017 12:04:25 -0700 (PDT)
Message-ID: <1490641451.9691.4.camel@poochiereds.net>
Subject: Re: statx manpage
From: Jeff Layton <jlayton@poochiereds.net>
Date: Mon, 27 Mar 2017 15:04:11 -0400
In-Reply-To: <20170327164628.GA15147@infradead.org>
References: <20170327154003.GA5716@birch.djwong.org>
         <20170307050140.GA12946@infradead.org>
         <20170307000609.GG5280@birch.djwong.org>
         <10435.1488907375@warthog.procyon.org.uk> <20170324205322.GA4986@gmail.com>
         <E6DB8461-22DE-496C-8A4A-B0A2F3702750@dilger.ca>
         <23715.1490631926@warthog.procyon.org.uk>
         <20170327164628.GA15147@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>, David Howells <dhowells@redhat.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, Andreas Dilger <adilger@dilger.ca>, Eric Biggers <ebiggers3@gmail.com>, "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, xfs <linux-xfs@vger.kernel.org>

On Mon, 2017-03-27 at 09:46 -0700, Christoph Hellwig wrote:
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

I don't think so.

I think we just have to clearly document that that will not be the
case. If they really expect the field to be there, then they need to
set the bit in the "want" mask -- it's really as simple as that.

-- 
Jeff Layton <jlayton@poochiereds.net>
