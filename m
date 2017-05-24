Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45506 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S966711AbdEXHiR (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 24 May 2017 03:38:17 -0400
Date: Wed, 24 May 2017 09:38:12 +0200
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: Shutdown filesystem when a thin pool become full
Message-ID: <20170524073812.h7fzmdyhdtzf7sew@eorzea.usersys.redhat.com>
References: <c25a8ccc-f143-989d-3d49-3fe8753aa6f7@assyoma.it>
 <8eb6b192-50fa-d283-3aa6-59bf75dde8b8@sandeen.net>
 <d8ac124743a86de83e57a89f3f95b400@assyoma.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d8ac124743a86de83e57a89f3f95b400@assyoma.it>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Gionatan Danti <g.danti@assyoma.it>
Cc: Eric Sandeen <sandeen@sandeen.net>, linux-xfs@vger.kernel.org

On Tue, May 23, 2017 at 10:23:55PM +0200, Gionatan Danti wrote:
> Il 23-05-2017 15:24 Eric Sandeen ha scritto:
> > It is pretty much by design - keeping in mind that XFS predates the
> > general notion of thin storage by a decade or two.  ;)
> > 
> > In the big picture, xfs's shutdown behavior is there to preserve the
> > consistency of the filesystem - if metadata writes are failing,
> > continuing would likely lead to corruption.
> > 
> > If /data/ writes are failing, that's for the application to deal with.
> > 
> > Shutting down the filesystem for an unwritable data block is probably
> > not
> > what people want to see, in general.
> 
> True.
> 
> But preparing for the worse (ie: a thin pool which inadvertently filled), I
> think that a read-only/shutdown mode would be valuable for the (large) class
> of application which don't really know how to deal with I/O errors.
> Moreover, applications not issuing fsyncs will *never* know that an I/O
> error happened on data writeout. On the other hand, sure, applications which
> do non use fsyncs probably do not really care about their data...
> 

If the application don't deal with the I/O errors, and ensure its data is
already written, what difference a RO fs will do? :) the application will send a
write request, the filesystem will deny it (because it is in RO), and the
application will not care :)

> Eric: in general terms, how do you feel about XFS on thinly-provisioned
> volumes? Is it a production-level setup or they have too many rough edges?
> 

Any application that don't ensure its data is stored, with fsync, and
applications that don't check for IO errors, well, it's applications fault, the
filesystem can't do much other than reporting the error to userspace.

Thin provisioning is not a new thing, and XFS has been designed to work on such
volumes from the beginning, so, yes, it is reliable to be used with thin
provisioned volumes. But of course, it requires the thin provisioning system to
be well administered, as any other filesystem will require.

>From a historical point of view, XFS ever retried forever to submit any failed
IO, once, most EIOs are considered temporary.

Well, things change, and we implemented a way to configure for how long XFS
should retry such IOs, and that's where the configuration system comes in.

Regarding you don't seeing XFS to shutdown during your tests, XFS will shutdown
if is there problems writing metadata to the disk, ensuring data is properly
written is the application responsibility, the filesystem should guarantee
consistency.


Cheers

> > As for your question about ENOSPC vs EIO, even though the storage may
> > return ENOSPC, I believe that gets turned into an EIO when it passes
> > through XFS to userspace.
> > 
> > Historically, ENOSPC meant that the filesystem itself has run out of
> > blocks, and EIO meant that the underlying device could not complete the
> > IO - so it's a matter of semantics, and I'm not sure anyone has
> > really settled on a consistent story with thin devices.
> > 
> 
> Yeah, I agree ;)
> 
> Thanks.
> 
> -- 
> Danti Gionatan
> Supporto Tecnico
> Assyoma S.r.l. - www.assyoma.it
> email: g.danti@assyoma.it - info@assyoma.it
> GPG public key ID: FF5F32A8
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Carlos
