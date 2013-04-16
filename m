Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id A96FC29DFA
	for <xfs@oss.sgi.com>; Tue, 16 Apr 2013 10:54:57 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 88516304053
	for <xfs@oss.sgi.com>; Tue, 16 Apr 2013 08:54:57 -0700 (PDT)
Received: from mail-ia0-f173.google.com (mail-ia0-f173.google.com
	[209.85.210.173]) by cuda.sgi.com with ESMTP id
	M6aQ5QmveufYyy9d (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 16 Apr 2013 08:54:53 -0700 (PDT)
Received: by mail-ia0-f173.google.com with SMTP id j5so562121iaf.32
	for <xfs@oss.sgi.com>; Tue, 16 Apr 2013 08:54:52 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20120828172928.999971219@sgi.com>
References: <20120828172605.607853317@sgi.com>
	<20120828172928.999971219@sgi.com>
Date: Tue, 16 Apr 2013 17:54:52 +0200
Message-ID: <CAFZPdfgFjRS2rFUekfSr4dT+-sfuji-0uUo1i7VE6=9GZOnzfg@mail.gmail.com>
Subject: Re: [PATCH 2/5] xfstests: Use libtool to install applications
From: Boris Ranto <ranto.boris@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0533523915848483662=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Rich Johnston <rjohnston@sgi.com>
Cc: Boris Ranto <branto@redhat.com>, xfs-oss <xfs@oss.sgi.com>

--===============0533523915848483662==
Content-Type: multipart/alternative; boundary=14dae9340be9d7a00a04da7c639e

--14dae9340be9d7a00a04da7c639e
Content-Type: text/plain; charset=ISO-8859-1

Hi,

this patch introduced a regression as it is no longer possible to install
xfstests to non-standard directory. The install-sh script that is packed
with xfstests supports DIST_ROOT variable for installation to non-standard
directory and hence, the command

make DIST_ROOT=/some/other/dir

worked well before the change. However now, even though libtootl actually
calls the install-sh script, the libtool itself also checks that the given
installation directory exists. Since the libtool does not respect
DIST_ROOT, then unless you already have xfstests installed in
/var/lib/xfstets, the installation with DIST_ROOT variable will fail with

libtool: install: `/var/lib/xfstests/ltp' is not a directory

Looking at the libtool script, there does not seem to be a nice way to fix
this since it checks that the destination directory exists directly by
command 'test -d "$dest".

Hence, possible workarounds include creating xfstests directory structure
in /var/lib/xfstest/ before installing to DEST_DIR or reverting this patch.
Looking at the libtool --mode=install --help, the command should also
support -inst-prefix $DEST_DIR but that did not work in my case (and
looking at the source code of libtool script, it does not treat the
-inst-prefix option specially in install mode).

Regrads,
Boris



On Tue, Aug 28, 2012 at 7:26 PM, Rich Johnston <rjohnston@sgi.com> wrote:

> This patch replaces the INSTALL macro with LTINSTALL so that libtool is
> used
> to install the applications.  Libtool will install the binary from the
> proper
> location and display a warning if any shared library dependancies are not
> properly installed.  This ensures that a libtool wrapper shell script is
> not
> installed in place of application when libtool wrappers are being used.
>
>
> Signed-off-by: Rich Johnston <rjohnston@sgi.com>
>
> ---
>  ltp/Makefile |    2 +-
>  src/Makefile |    6 +++---
>  2 files changed, 4 insertions(+), 4 deletions(-)
>
> Index: b/ltp/Makefile
> ===================================================================
> --- a/ltp/Makefile
> +++ b/ltp/Makefile
> @@ -44,7 +44,7 @@ $(TARGETS): $(LIBTEST)
>
>  install: default
>         $(INSTALL) -m 755 -d $(PKG_LIB_DIR)/ltp
> -       $(INSTALL) -m 755 $(TARGETS) $(PKG_LIB_DIR)/ltp
> +       $(LTINSTALL) -m 755 $(TARGETS) $(PKG_LIB_DIR)/ltp
>         $(INSTALL) -m 755 $(SCRIPTS) $(PKG_LIB_DIR)/ltp
>
>  -include .dep
> Index: b/src/Makefile
> ===================================================================
> --- a/src/Makefile
> +++ b/src/Makefile
> @@ -74,9 +74,9 @@ LINKTEST = $(LTLINK) $@.c -o $@ $(CFLAGS
>
>  install: default $(addsuffix -install,$(SUBDIRS))
>         $(INSTALL) -m 755 -d $(PKG_LIB_DIR)/src
> -       $(INSTALL) -m 755 $(TARGETS) $(PKG_LIB_DIR)/src
> -       $(INSTALL) -m 755 fill2attr fill2fs fill2fs_check scaleread.sh
> $(PKG_LIB_DIR)/src
> -       $(INSTALL) -m 644 dumpfile $(PKG_LIB_DIR)/src
> +       $(LTINSTALL) -m 755 $(TARGETS) $(PKG_LIB_DIR)/src
> +       $(LTINSTALL) -m 755 fill2attr fill2fs fill2fs_check scaleread.sh
> $(PKG_LIB_DIR)/src
> +       $(LTINSTALL) -m 644 dumpfile $(PKG_LIB_DIR)/src
>
>  %-install:
>         $(MAKE) -C $* install
>
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
>

--14dae9340be9d7a00a04da7c639e
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Hi,<br><br>this patch introduced a regression as it is no =
longer possible to install xfstests to non-standard directory. The install-=
sh script that is packed with xfstests supports DIST_ROOT variable for inst=
allation to non-standard directory and hence, the command<br>
<br>make DIST_ROOT=3D/some/other/dir<br><br>worked well before the change. =
However now, even though libtootl actually calls the install-sh script, the=
 libtool itself also checks that the given installation directory exists. S=
ince the libtool does not respect DIST_ROOT, then unless you already have x=
fstests installed in /var/lib/xfstets, the installation with DIST_ROOT vari=
able will fail with<br>
<br>libtool: install: `/var/lib/xfstests/ltp&#39; is not a directory<br><br=
>Looking at the libtool script, there does not seem to be a nice way to fix=
 this since it checks that the destination directory exists  directly by co=
mmand &#39;test -d &quot;$dest&quot;.<br>
<br>Hence, possible workarounds include creating xfstests directory structu=
re in /var/lib/xfstest/ before installing to DEST_DIR or reverting this pat=
ch. Looking at the libtool --mode=3Dinstall --help, the command should also=
 support -inst-prefix $DEST_DIR but that did not work in my case (and looki=
ng at the source code of libtool script, it does not treat the -inst-prefix=
 option specially in install mode).<br>
<br>Regrads,<br>Boris<br><br></div><div class=3D"gmail_extra"><br><br><div =
class=3D"gmail_quote">On Tue, Aug 28, 2012 at 7:26 PM, Rich Johnston <span =
dir=3D"ltr">&lt;<a href=3D"mailto:rjohnston@sgi.com" target=3D"_blank">rjoh=
nston@sgi.com</a>&gt;</span> wrote:<br>
<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex">This patch replaces the INSTALL macro with L=
TINSTALL so that libtool is used<br>
to install the applications. =A0Libtool will install the binary from the pr=
oper<br>
location and display a warning if any shared library dependancies are not<b=
r>
properly installed. =A0This ensures that a libtool wrapper shell script is =
not<br>
installed in place of application when libtool wrappers are being used.<br>
<br>
<br>
Signed-off-by: Rich Johnston &lt;<a href=3D"mailto:rjohnston@sgi.com">rjohn=
ston@sgi.com</a>&gt;<br>
<br>
---<br>
=A0ltp/Makefile | =A0 =A02 +-<br>
=A0src/Makefile | =A0 =A06 +++---<br>
=A02 files changed, 4 insertions(+), 4 deletions(-)<br>
<br>
Index: b/ltp/Makefile<br>
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D<br>
--- a/ltp/Makefile<br>
+++ b/ltp/Makefile<br>
@@ -44,7 +44,7 @@ $(TARGETS): $(LIBTEST)<br>
<br>
=A0install: default<br>
=A0 =A0 =A0 =A0 $(INSTALL) -m 755 -d $(PKG_LIB_DIR)/ltp<br>
- =A0 =A0 =A0 $(INSTALL) -m 755 $(TARGETS) $(PKG_LIB_DIR)/ltp<br>
+ =A0 =A0 =A0 $(LTINSTALL) -m 755 $(TARGETS) $(PKG_LIB_DIR)/ltp<br>
=A0 =A0 =A0 =A0 $(INSTALL) -m 755 $(SCRIPTS) $(PKG_LIB_DIR)/ltp<br>
<br>
=A0-include .dep<br>
Index: b/src/Makefile<br>
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D<br>
--- a/src/Makefile<br>
+++ b/src/Makefile<br>
@@ -74,9 +74,9 @@ LINKTEST =3D $(LTLINK) $@.c -o $@ $(CFLAGS<br>
<br>
=A0install: default $(addsuffix -install,$(SUBDIRS))<br>
=A0 =A0 =A0 =A0 $(INSTALL) -m 755 -d $(PKG_LIB_DIR)/src<br>
- =A0 =A0 =A0 $(INSTALL) -m 755 $(TARGETS) $(PKG_LIB_DIR)/src<br>
- =A0 =A0 =A0 $(INSTALL) -m 755 fill2attr fill2fs fill2fs_check scaleread.s=
h $(PKG_LIB_DIR)/src<br>
- =A0 =A0 =A0 $(INSTALL) -m 644 dumpfile $(PKG_LIB_DIR)/src<br>
+ =A0 =A0 =A0 $(LTINSTALL) -m 755 $(TARGETS) $(PKG_LIB_DIR)/src<br>
+ =A0 =A0 =A0 $(LTINSTALL) -m 755 fill2attr fill2fs fill2fs_check scaleread=
.sh $(PKG_LIB_DIR)/src<br>
+ =A0 =A0 =A0 $(LTINSTALL) -m 644 dumpfile $(PKG_LIB_DIR)/src<br>
<br>
=A0%-install:<br>
=A0 =A0 =A0 =A0 $(MAKE) -C $* install<br>
<br>
_______________________________________________<br>
xfs mailing list<br>
<a href=3D"mailto:xfs@oss.sgi.com">xfs@oss.sgi.com</a><br>
<a href=3D"http://oss.sgi.com/mailman/listinfo/xfs" target=3D"_blank">http:=
//oss.sgi.com/mailman/listinfo/xfs</a><br>
</blockquote></div><br></div>

--14dae9340be9d7a00a04da7c639e--


--===============0533523915848483662==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============0533523915848483662==--
