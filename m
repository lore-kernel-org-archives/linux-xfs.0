Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mr003msb.fastweb.it ([85.18.95.87]:45285 "EHLO
        mr003msb.fastweb.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1031913AbdEWUYK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 23 May 2017 16:24:10 -0400
Subject: Re: Shutdown filesystem when a thin pool become full
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Tue, 23 May 2017 22:23:55 +0200
From: Gionatan Danti <g.danti@assyoma.it>
In-Reply-To: <8eb6b192-50fa-d283-3aa6-59bf75dde8b8@sandeen.net>
References: <c25a8ccc-f143-989d-3d49-3fe8753aa6f7@assyoma.it>
 <8eb6b192-50fa-d283-3aa6-59bf75dde8b8@sandeen.net>
Message-ID: <d8ac124743a86de83e57a89f3f95b400@assyoma.it>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: linux-xfs@vger.kernel.org, g.danti@assyoma.it

Il 23-05-2017 15:24 Eric Sandeen ha scritto:
> It is pretty much by design - keeping in mind that XFS predates the
> general notion of thin storage by a decade or two.  ;)
> 
> In the big picture, xfs's shutdown behavior is there to preserve the
> consistency of the filesystem - if metadata writes are failing,
> continuing would likely lead to corruption.
> 
> If /data/ writes are failing, that's for the application to deal with.
> 
> Shutting down the filesystem for an unwritable data block is probably 
> not
> what people want to see, in general.

True.

But preparing for the worse (ie: a thin pool which inadvertently 
filled), I think that a read-only/shutdown mode would be valuable for 
the (large) class of application which don't really know how to deal 
with I/O errors. Moreover, applications not issuing fsyncs will *never* 
know that an I/O error happened on data writeout. On the other hand, 
sure, applications which do non use fsyncs probably do not really care 
about their data...

Eric: in general terms, how do you feel about XFS on thinly-provisioned 
volumes? Is it a production-level setup or they have too many rough 
edges?

> As for your question about ENOSPC vs EIO, even though the storage may
> return ENOSPC, I believe that gets turned into an EIO when it passes
> through XFS to userspace.
> 
> Historically, ENOSPC meant that the filesystem itself has run out of
> blocks, and EIO meant that the underlying device could not complete the
> IO - so it's a matter of semantics, and I'm not sure anyone has
> really settled on a consistent story with thin devices.
> 

Yeah, I agree ;)

Thanks.

-- 
Danti Gionatan
Supporto Tecnico
Assyoma S.r.l. - www.assyoma.it
email: g.danti@assyoma.it - info@assyoma.it
GPG public key ID: FF5F32A8
