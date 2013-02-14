Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 247747F93
	for <xfs@oss.sgi.com>; Thu, 14 Feb 2013 16:25:57 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id ADE26AC007
	for <xfs@oss.sgi.com>; Thu, 14 Feb 2013 14:25:56 -0800 (PST)
Date: Thu, 14 Feb 2013 17:25:47 -0500 (EST)
From: Nathan Scott <nathans@debian.org>
Message-ID: <322172909.3042470.1360880747978.JavaMail.root@redhat.com>
In-Reply-To: <20130214162454.GH30652@sgi.com>
Subject: Re: [PATCH 0/4] Refactor release scripts to conform to using git
	archive
MIME-Version: 1.0
Reply-To: Nathan Scott <nathans@debian.org>
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
To: Ben Myers <bpm@sgi.com>
Cc: xfs@oss.sgi.com, Andrew Dahl <adahl@sgi.com>



----- Original Message -----
> ...
> 'make deb' failed for me like this:
> 
> signfile xfsprogs_3.1.9.dsc
> gpg: skipped "Nathan Scott <nathans@debian.org>": secret key not
> available
> gpg: [stdin]: clearsign failed: secret key not available
> 
> dpkg-genchanges  >../xfsprogs_3.1.9_amd64.changes
> dpkg-genchanges: including full source code in upload
> dpkg-buildpackage: full upload; Debian-native package (full source is
> included)
> dpkg-buildpackage: warning: Failed to sign .dsc and .changes file
> make: *** [deb] Error 1
> 
> Secure-by-default is a great idea but it seems that in this case it
> also
> requires that anyone who wants to do a build for debian has to do it
> on a
> machine with a keyring containing your secret key. ;)
> 

Awkward.  :)

> I think it is also reasonable for devs to be able to build test debs

*nod* ... not sure what trickery Dave had used.  But, perhaps a better
way to tackle this would be similar to the way the build allows extra
configure options to be passed in.

include/builddefs: configure
        ./configure $$LOCAL_CONFIGURE_OPTIONS

so, perhaps something like this...

# LOCAL_BUILDPACKAGE_OPTIONS="-us -uc" for unsigned debs
deb: include/builddefs include/platform_defs.h
...
        $(Q)cd $(SRCDIR) && dpkg-buildpackage $$LOCAL_BUILDPACKAGE_OPTIONS


cheers.

--
Nathan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
