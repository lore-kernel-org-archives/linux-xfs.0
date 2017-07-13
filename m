Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49980 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750877AbdGMH2v (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 13 Jul 2017 03:28:51 -0400
Date: Thu, 13 Jul 2017 15:28:48 +0800
From: Eryu Guan <eguan@redhat.com>
Subject: Re: [PATCH] xfsdump: fix race condition between lseek() and
 read()/write()
Message-ID: <20170713072848.GD2478@eguan.usersys.redhat.com>
References: <1461244016-7373-1-git-send-email-eguan@redhat.com>
 <a63c9311-8b97-ad31-63cb-35bdea02b6a3@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a63c9311-8b97-ad31-63cb-35bdea02b6a3@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: linux-xfs <linux-xfs@vger.kernel.org>

On Wed, Jul 12, 2017 at 03:56:00PM -0500, Eric Sandeen wrote:
> Hm, but isn't this a problem?

/me rewinds my mind by 15 months and confirms it is a problem :)

> 
> On 04/21/2016 08:06 AM, Eryu Guan wrote:
> > diff --git a/inventory/inv_core.c b/inventory/inv_core.c
> > index a17c2c9..42d0ac4 100644
> > --- a/inventory/inv_core.c
> > +++ b/inventory/inv_core.c
> > @@ -121,19 +121,10 @@ get_invtrecord( int fd, void *buf, size_t bufsz, off64_t off,
> >  	if ( dolock ) 
> >  		INVLOCK( fd, LOCK_SH );
> >  
> > -	if ( lseek( fd, (off_t)off, whence ) < 0 ) {
> 
> whence can be _SET or _CUR depending on the caller, but with this
> patch whence is no longer used, and -
> 
> > -		INV_PERROR( _("Error in reading inventory record "
> > -			      "(lseek failed): ") );
> > -		if ( dolock ) 
> > -			INVLOCK( fd, LOCK_UN );
> > -		return -1;
> > -	}
> > -	
> > -	nread = read( fd, buf, bufsz );
> > -
> > +	nread = pread(fd, buf, bufsz, (off_t)off);
> 
> This is only equivalent to SET, no?  With the other changes, perhaps we're

Yes, it's only equivalent to SET.

> no longer called via GET_REC_SEEKCUR - but in that case, the whence arg should
> be removed?  Except for that pesky test code which explicitly passes SEEK_CUR ...

Agreed, the whence arg can be removed, the test code requires some
updates though.

I'm now testing a new version, I'll post it once it passes '-g dump'
tests.

Thanks for the review!

Eryu

> 
> 
> -Eric
> 
> >  	if (  nread != (int) bufsz ) {
> >  		INV_PERROR( _("Error in reading inventory record :") );
> > -		if ( dolock ) 
> > +		if ( dolock )
> >  			INVLOCK( fd, LOCK_UN );
> >  		return -1;
> >  	}
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
