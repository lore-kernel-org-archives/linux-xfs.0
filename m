Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from fieldses.org ([173.255.197.46]:60800 "EHLO fieldses.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753151AbdEJRXX (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 10 May 2017 13:23:23 -0400
Date: Wed, 10 May 2017 13:23:22 -0400
From: "J. Bruce Fields" <bfields@fieldses.org>
Subject: Re: Locking problems with Linux 4.9 with NFSD and `fs/iomap.c`
Message-ID: <20170510172322.GA8470@fieldses.org>
References: <de171adc29600902515d1424fd800678@molgen.mpg.de>
 <20170508131843.GB29840@bfoster.bfoster>
 <90423117-4c49-5f61-2dcf-abf6d77c7ba3@molgen.mpg.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <90423117-4c49-5f61-2dcf-abf6d77c7ba3@molgen.mpg.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Paul Menzel <pmenzel@molgen.mpg.de>
Cc: Brian Foster <bfoster@redhat.com>, linux-nfs@vger.kernel.org, linux-xfs@vger.kernel.org, it+linux-nfs@molgen.mpg.de, Christoph Hellwig <hch@lst.de>, Jeff Layton <jlayton@poochiereds.net>

On Wed, May 10, 2017 at 11:08:52AM +0200, Paul Menzel wrote:
> On 05/08/17 15:18, Brian Foster wrote:
> >>NFS doesn’t respond to a null call.
> >
> >What exactly is a NULL call?
> 
> Sorry for not making that clear for non-NFS people. From *NFS
> Version 3 Protocol Specification* [1]:
> 
> >Procedure NULL does not do any work. It is made available to
> >allow server response testing and timing.

NFSD has a fixed number of threads for processing requests, so if one of
them hangs in the filesystem while holding a lock, all of them are
likely to eventually end up waiting for that lock, and there will be
none left even to answer NULL requests.  So this is a pretty normal
symptom of a deadlock or similar problem.

--b.
