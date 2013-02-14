Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 05E78805C
	for <xfs@oss.sgi.com>; Thu, 14 Feb 2013 16:37:35 -0600 (CST)
Date: Thu, 14 Feb 2013 16:37:31 -0600
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 0/4] Refactor release scripts to conform to using git
	archive
Message-ID: <20130214223731.GJ22182@sgi.com>
References: <20130214162454.GH30652@sgi.com>
	<322172909.3042470.1360880747978.JavaMail.root@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <322172909.3042470.1360880747978.JavaMail.root@redhat.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Nathan Scott <nathans@debian.org>
Cc: Andrew Dahl <adahl@sgi.com>, xfs@oss.sgi.com

On Thu, Feb 14, 2013 at 05:25:47PM -0500, Nathan Scott wrote:
> ----- Original Message -----
> > ...
> > 'make deb' failed for me like this:
> > 
> > signfile xfsprogs_3.1.9.dsc
> > gpg: skipped "Nathan Scott <nathans@debian.org>": secret key not
> > available
> > gpg: [stdin]: clearsign failed: secret key not available
> > 
> > dpkg-genchanges  >../xfsprogs_3.1.9_amd64.changes
> > dpkg-genchanges: including full source code in upload
> > dpkg-buildpackage: full upload; Debian-native package (full source is
> > included)
> > dpkg-buildpackage: warning: Failed to sign .dsc and .changes file
> > make: *** [deb] Error 1
> > 
> > Secure-by-default is a great idea but it seems that in this case it
> > also
> > requires that anyone who wants to do a build for debian has to do it
> > on a
> > machine with a keyring containing your secret key. ;)
> > 
> 
> Awkward.  :)

Really I don't mind.  What was your passphrase again? 

> > I think it is also reasonable for devs to be able to build test debs
> 
> *nod* ... not sure what trickery Dave had used.

I tried setting DEB_BUILD_OPTIONS="-us -uc" but no luck.

> But, perhaps a better
> way to tackle this would be similar to the way the build allows extra
> configure options to be passed in.

> 
> include/builddefs: configure
>         ./configure $$LOCAL_CONFIGURE_OPTIONS
> 
> so, perhaps something like this...
> 
> # LOCAL_BUILDPACKAGE_OPTIONS="-us -uc" for unsigned debs
> deb: include/builddefs include/platform_defs.h
> ...
>         $(Q)cd $(SRCDIR) && dpkg-buildpackage $$LOCAL_BUILDPACKAGE_OPTIONS

Gotcha.  I'll take a look.  Thanks for the reviews!

-Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
