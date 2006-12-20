Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 20 Dec 2006 15:46:14 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id kBKNk4qw008827
	for <xfs@oss.sgi.com>; Wed, 20 Dec 2006 15:46:07 -0800
Message-Id: <200612202344.KAA13553@larry.melbourne.sgi.com>
From: "Barry Naujok" <bnaujok@melbourne.sgi.com>
Subject: RE: [PATCH] rethink removal of xattr syscall stubs (for now)
Date: Thu, 21 Dec 2006 10:50:29 +1100
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
In-Reply-To: <1166650831.5572.164.camel@edge>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: nscott@aconex.com, lachlan@sgi.com
Cc: 'Christoph Hellwig' <hch@infradead.org>, bnaujok@sgi.com, xfs@oss.sgi.com, agruen@suse.de


> -----Original Message-----
> From: xfs-bounce@oss.sgi.com [mailto:xfs-bounce@oss.sgi.com] 
> On Behalf Of Nathan Scott
> Sent: Thursday, 21 December 2006 8:41 AM
> To: lachlan@sgi.com
> Cc: Christoph Hellwig; bnaujok@sgi.com; xfs@oss.sgi.com; 
> agruen@suse.de
> Subject: Re: [PATCH] rethink removal of xattr syscall stubs (for now)
> 
> On Wed, 2006-12-20 at 16:03 +0000, Lachlan McIlroy wrote:
> > Nathan Scott wrote:
> > > On Tue, 2006-12-19 at 10:05 +0000, Christoph Hellwig wrote:
> > > | > Please apply as an interim fix to the original problem and to
> > > | > the accidental new problems its caused, and I'll push 
> through a
> > > | > new patch in the new year.
> > > | 
> > > | There is a way to re-export symbols you imported from another
> > > | library with symbol versioning.  That how for example libpthread
> > > | works on recent Solaris versions.  I'll find out how 
> exactly that
> > > | should be implemented.
> > > 
> > > Ah, that sounds ideal - thanks!
> > > 
> > 
> > Nathan, do you still need your patch applied or will you look into
> > this new approach instead?
> > 
> 
> The patch needs to be applied, thanks.  At a later date we'll fix it
> differently, but that will take some time.

I applied Nathan's patch yesterday. 
