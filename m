Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-qt0-f170.google.com ([209.85.216.170]:36120 "EHLO
        mail-qt0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753330AbdC1UWj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 28 Mar 2017 16:22:39 -0400
Received: by mail-qt0-f170.google.com with SMTP id r45so74484575qte.3
        for <linux-xfs@vger.kernel.org>; Tue, 28 Mar 2017 13:22:38 -0700 (PDT)
Message-ID: <1490732554.24656.7.camel@poochiereds.net>
Subject: Re: statx manpage
From: Jeff Layton <jlayton@poochiereds.net>
Date: Tue, 28 Mar 2017 16:22:34 -0400
In-Reply-To: <5E78AA22-2C44-4A94-9CEA-A954D836FC6C@dilger.ca>
References: <20170327154003.GA5716@birch.djwong.org>
         <20170307050140.GA12946@infradead.org>
         <20170307000609.GG5280@birch.djwong.org>
         <10435.1488907375@warthog.procyon.org.uk> <20170324205322.GA4986@gmail.com>
         <E6DB8461-22DE-496C-8A4A-B0A2F3702750@dilger.ca>
         <23715.1490631926@warthog.procyon.org.uk>
         <20170327164628.GA15147@infradead.org>
         <1490641451.9691.4.camel@poochiereds.net>
         <5E78AA22-2C44-4A94-9CEA-A954D836FC6C@dilger.ca>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Andreas Dilger <adilger@dilger.ca>
Cc: Christoph Hellwig <hch@infradead.org>, David Howells <dhowells@redhat.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, Eric Biggers <ebiggers3@gmail.com>, "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, xfs <linux-xfs@vger.kernel.org>

On Tue, 2017-03-28 at 13:39 -0600, Andreas Dilger wrote:
> On Mar 27, 2017, at 1:04 PM, Jeff Layton <jlayton@poochiereds.net> wrote:
> > 
> > On Mon, 2017-03-27 at 09:46 -0700, Christoph Hellwig wrote:
> > > On Mon, Mar 27, 2017 at 05:25:26PM +0100, David Howells wrote:
> > > > That means a filesystem can't simply return non-basic data unconditionally if
> > > > possible.  I prefer letting it do so if it doesn't incur any extra I/O
> > > > overheads.
> > > 
> > > This seems like it will lead to userspace expecting certain fields to
> > > just be there, and a lot harder to properly verify for tests.  Which btw
> > > we all need for these odd behaviors.  If we can't get them any time soon
> > > (e.g. before -rc6) I think we'll simply have to revert statx instead of
> > > leaving this untested mess in the tree.
> > 
> > I don't think so.
> > 
> > I think we just have to clearly document that that will not be the
> > case. If they really expect the field to be there, then they need to
> > set the bit in the "want" mask -- it's really as simple as that.
> 
> It would be my preference to only return attributes which are explicitly
> requested (Lustre won't return fields for which the bit is not set), but
> there was a request for this behaviour in NFS I recall.
> 
> That said, there are also flags for "lazy" attributes for NFS. I wonder if
> it is enough to pass AT_STATX_DONT_SYNC and request STATX_SIZE | STATX_CTIME,
> or whatever NFS is worried about, and return the client-local version of the
> attributes?
> 
> I guess the real question is what an application is going to do with fields
> that it didn't actually request, and has no way to know if they are valid or
> contain garbage?
> 

You certainly do have a way to know if they're valid. You can check the
stx_mask.

Basically, if you request something, you're guaranteed to get it, or an
error. If you don't request it, you might get it but you had better
check the stx_mask before assuming that you did.

TBQH though, I don't _really_ expect userland to use this that often.

The main reason I'm arguing for this is for simplicity of the in-kernel 
implementations. Having to check each bit in the mask before filling
out its field is cumbersome. It's much simpler to fill out the kstat
struct with what you have and set the stx_mask unconditionally.

It's also not 100% clear to me how the unrequested fields would be set
if we don't allow this. zeroing them out seems like the obvious thing
to do, but that doesn't really provide any guarantee that someone won't
try to interpret it as valid.
-- 
Jeff Layton <jlayton@poochiereds.net>
