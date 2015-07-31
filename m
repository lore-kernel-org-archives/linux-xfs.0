Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 7448E7F6C
	for <xfs@oss.sgi.com>; Fri, 31 Jul 2015 10:21:31 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id E85E3AC005
	for <xfs@oss.sgi.com>; Fri, 31 Jul 2015 08:21:27 -0700 (PDT)
Received: from mout.gmx.net (mout.gmx.net [212.227.17.22]) by cuda.sgi.com
	with ESMTP id NyfLhvM6uGRdXFkm (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 31 Jul 2015 08:21:24 -0700 (PDT)
Message-ID: <55BB9271.6000300@gmx.net>
Date: Fri, 31 Jul 2015 17:21:21 +0200
From: Daniel Bast <daniel.bast@gmx.net>
MIME-Version: 1.0
Subject: xfsprogs fails to build on debian ppc64el
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============8153129465242327128=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: 793495@bugs.debian.org, xfs@oss.sgi.com, debian-powerpc@lists.debian.org

This is a multi-part message in MIME format.
--===============8153129465242327128==
Content-Type: multipart/alternative;
 boundary="------------050904090004000708050404"

This is a multi-part message in MIME format.
--------------050904090004000708050404
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit

Hi,

xfsprogs 3.2.4 fails to build on ppc64el, see log below or full build 
log 
https://buildd.debian.org/status/fetch.php?pkg=xfsprogs&arch=ppc64el&ver=3.2.4&stamp=1438318450
(xfsprogs 3.2.3 already failed with the same error)

What is the reason for this, libtool to old?


This potentially prevents the migration of the package to testing, which 
leaves CVE-2012-2150 open in testing on all arches.

Cheers,

Daniel


== dpkg-buildpackage: configure
test -f debian/rules
AUTOHEADER=/bin/true dh_autoreconf
	find ! -ipath "./debian/*" -a ! \( -path '*/.git/*' -o -path '*/.hg/*' -o -path '*/.bzr/*' -o -path '*/.svn/*' -o -path '*/CVS/*' \) -a  -type f -exec md5sum {} \; > debian/autoreconf.before
	autoreconf -f -i
libtoolize: putting auxiliary files in AC_CONFIG_AUX_DIR, `.'.
libtoolize: copying file `./ltmain.sh'
libtoolize: putting macros in AC_CONFIG_MACRO_DIR, `m4'.
libtoolize: copying file `m4/libtool.m4'
libtoolize: copying file `m4/ltoptions.m4'
libtoolize: copying file `m4/ltsugar.m4'
libtoolize: copying file `m4/ltversion.m4'
libtoolize: copying file `m4/lt~obsolete.m4'
libtoolize: Consider adding `-I m4' to ACLOCAL_AMFLAGS in Makefile.am.
	find ! -ipath "./debian/*" -a ! \( -path '*/.git/*' -o -path '*/.hg/*' -o -path '*/.bzr/*' -o -path '*/.svn/*' -o -path '*/CVS/*' \) -a  -type f -exec md5sum {} \; > debian/autoreconf.after
export DEBUG=-DNDEBUG DISTRIBUTION=debian INSTALL_USER=root INSTALL_GROUP=root LOCAL_CONFIGURE_OPTIONS="--enable-readline=yes --enable-blkid=yes" ; /usr/bin/make include/platform_defs.h
make[1]: Entering directory '/«PKGBUILDDIR»'
./configure $LOCAL_CONFIGURE_OPTIONS
./config.guess: unable to guess system type

This script, last modified 2012-02-10, has failed to recognize
the operating system you are using. It is advised that you
download the most up to date version of the config scripts from

   http://git.savannah.gnu.org/gitweb/?p=config.git;a=blob_plain;f=config.guess;hb=HEAD
and
   http://git.savannah.gnu.org/gitweb/?p=config.git;a=blob_plain;f=config.sub;hb=HEAD

If the version you run (./config.guess) is already up to date, please
send the following data and any information you think might be
pertinent to <config-patches@gnu.org> in order to provide the needed
information to handle your system.

config.guess timestamp = 2012-02-10

uname -m = ppc64le
uname -r = 3.16.0-4-powerpc64le
uname -s = Linux
uname -v = #1 SMP Debian 3.16.7-ckt11-1+deb8u2 (2015-07-17)

/usr/bin/uname -p =
/bin/uname -X     =

hostinfo               =
/bin/universe          =
/usr/bin/arch -k       =
/bin/arch              =
/usr/bin/oslevel       =
/usr/convex/getsysinfo =

UNAME_MACHINE = ppc64le
UNAME_RELEASE = 3.16.0-4-powerpc64le
UNAME_SYSTEM  = Linux
UNAME_VERSION = #1 SMP Debian 3.16.7-ckt11-1+deb8u2 (2015-07-17)
configure: error: cannot guess build type; you must specify one
make[1]: *** [include/builddefs] Error 1
checking build system type... Makefile:89: recipe for target 'include/builddefs' failed
make[1]: Leaving directory '/«PKGBUILDDIR»'
make: *** [.census] Error 2
dpkg-buildpackage: error: debian/rules build gave error exit status 2
debian/rules:36: recipe for target '.census' failed


--------------050904090004000708050404
Content-Type: text/html; charset=utf-8
Content-Transfer-Encoding: 8bit

<html>
  <head>

    <meta http-equiv="content-type" content="text/html; charset=utf-8">
  </head>
  <body bgcolor="#FFFFFF" text="#000000">
    Hi,<br>
    <br>
    xfsprogs 3.2.4 fails to build on ppc64el, see log below or full
    build log
<a class="moz-txt-link-freetext" href="https://buildd.debian.org/status/fetch.php?pkg=xfsprogs&amp;arch=ppc64el&amp;ver=3.2.4&amp;stamp=1438318450">https://buildd.debian.org/status/fetch.php?pkg=xfsprogs&amp;arch=ppc64el&amp;ver=3.2.4&amp;stamp=1438318450</a><br>
    (xfsprogs 3.2.3 already failed with the same error)<br>
    <br>
    What is the reason for this, libtool to old?<br>
    <br>
    <br>
    This potentially prevents the migration of the package to testing,
    which leaves CVE-2012-2150 open in testing on all arches.<br>
    <br>
    Cheers,<br>
    <br>
    Daniel<br>
    <br>
    <br>
    <meta http-equiv="content-type" content="text/html; charset=utf-8">
    <pre style="color: rgb(0, 0, 0); font-style: normal; font-variant: normal; font-weight: normal; letter-spacing: normal; line-height: normal; orphans: auto; text-align: start; text-indent: 0px; text-transform: none; widows: 1; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: rgb(255, 255, 255);">== dpkg-buildpackage: configure
test -f debian/rules
AUTOHEADER=/bin/true dh_autoreconf
	find ! -ipath "./debian/*" -a ! \( -path '*/.git/*' -o -path '*/.hg/*' -o -path '*/.bzr/*' -o -path '*/.svn/*' -o -path '*/CVS/*' \) -a  -type f -exec md5sum {} \; &gt; debian/autoreconf.before
	autoreconf -f -i
libtoolize: putting auxiliary files in AC_CONFIG_AUX_DIR, `.'.
libtoolize: copying file `./ltmain.sh'
libtoolize: putting macros in AC_CONFIG_MACRO_DIR, `m4'.
libtoolize: copying file `m4/libtool.m4'
libtoolize: copying file `m4/ltoptions.m4'
libtoolize: copying file `m4/ltsugar.m4'
libtoolize: copying file `m4/ltversion.m4'
libtoolize: copying file `m4/lt~obsolete.m4'
libtoolize: Consider adding `-I m4' to ACLOCAL_AMFLAGS in Makefile.am.
	find ! -ipath "./debian/*" -a ! \( -path '*/.git/*' -o -path '*/.hg/*' -o -path '*/.bzr/*' -o -path '*/.svn/*' -o -path '*/CVS/*' \) -a  -type f -exec md5sum {} \; &gt; debian/autoreconf.after
export DEBUG=-DNDEBUG DISTRIBUTION=debian INSTALL_USER=root INSTALL_GROUP=root LOCAL_CONFIGURE_OPTIONS="--enable-readline=yes --enable-blkid=yes" ; /usr/bin/make include/platform_defs.h
make[1]: Entering directory '/«PKGBUILDDIR»'
./configure $LOCAL_CONFIGURE_OPTIONS
./config.guess: unable to guess system type

This script, last modified 2012-02-10, has failed to recognize
the operating system you are using. It is advised that you
download the most up to date version of the config scripts from

  <a class="moz-txt-link-freetext" href="http://git.savannah.gnu.org/gitweb/?p=config.git;a=blob_plain;f=config.guess;hb=HEAD">http://git.savannah.gnu.org/gitweb/?p=config.git;a=blob_plain;f=config.guess;hb=HEAD</a>
and
  <a class="moz-txt-link-freetext" href="http://git.savannah.gnu.org/gitweb/?p=config.git;a=blob_plain;f=config.sub;hb=HEAD">http://git.savannah.gnu.org/gitweb/?p=config.git;a=blob_plain;f=config.sub;hb=HEAD</a>

If the version you run (./config.guess) is already up to date, please
send the following data and any information you think might be
pertinent to <a class="moz-txt-link-rfc2396E" href="mailto:config-patches@gnu.org">&lt;config-patches@gnu.org&gt;</a> in order to provide the needed
information to handle your system.

config.guess timestamp = 2012-02-10

uname -m = ppc64le
uname -r = 3.16.0-4-powerpc64le
uname -s = Linux
uname -v = #1 SMP Debian 3.16.7-ckt11-1+deb8u2 (2015-07-17)

/usr/bin/uname -p = 
/bin/uname -X     = 

hostinfo               = 
/bin/universe          = 
/usr/bin/arch -k       = 
/bin/arch              = 
/usr/bin/oslevel       = 
/usr/convex/getsysinfo = 

UNAME_MACHINE = ppc64le
UNAME_RELEASE = 3.16.0-4-powerpc64le
UNAME_SYSTEM  = Linux
UNAME_VERSION = #1 SMP Debian 3.16.7-ckt11-1+deb8u2 (2015-07-17)
configure: error: cannot guess build type; you must specify one
make[1]: *** [include/builddefs] Error 1
checking build system type... Makefile:89: recipe for target 'include/builddefs' failed
make[1]: Leaving directory '/«PKGBUILDDIR»'
make: *** [.census] Error 2
dpkg-buildpackage: error: debian/rules build gave error exit status 2
debian/rules:36: recipe for target '.census' failed</pre>
  </body>
</html>

--------------050904090004000708050404--


--===============8153129465242327128==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============8153129465242327128==--
