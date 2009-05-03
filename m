Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n43NZdpS141673 for <xfs@oss.sgi.com>; Sun, 3 May 2009 18:35:39 -0500
Received: from wf-out-1314.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3264525C827
	for <xfs@oss.sgi.com>; Sun,  3 May 2009 16:35:40 -0700 (PDT)
Received: from wf-out-1314.google.com (wf-out-1314.google.com
	[209.85.200.170]) by cuda.sgi.com with ESMTP id
	UECnbCnS8uMboLwD for <xfs@oss.sgi.com>;
	Sun, 03 May 2009 16:35:40 -0700 (PDT)
Received: by wf-out-1314.google.com with SMTP id 29so2651170wff.32
	for <xfs@oss.sgi.com>; Sun, 03 May 2009 16:35:39 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20090429135050.GC30808@infradead.org>
References: <20090429135050.GC30808@infradead.org>
Date: Mon, 4 May 2009 09:35:39 +1000
Message-ID: <d38e348a0905031635s3b7a812cl3e46d13069572d97@mail.gmail.com>
Subject: Re: [PATCH] xfsdump: add .gitignore
From: Timothy Shimmin <timothy.shimmin@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============7184269248066861284=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

--===============7184269248066861284==
Content-Type: multipart/alternative; boundary=000e0cd17b9ae2d5f204690a80a9

--000e0cd17b9ae2d5f204690a80a9
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Get rid of the symlinked files by creating a local library for the
commonality? ;-)Probably easier said than done - I haven't looked at the
code in a while - but I
I think the traditional library model is better than a heap of symlinks :)
(I realise you just want a .gitignore file but .... ;-)

--Tim

On Wed, Apr 29, 2009 at 11:50 PM, Christoph Hellwig <hch@infradead.org>wrote:

> This one is pretty ugly due to all the symlinked files, any better
> suggestions?
>
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
>
> Index: xfsdump-dev/.gitignore
> ===================================================================
> --- /dev/null   1970-01-01 00:00:00.000000000 +0000
> +++ xfsdump-dev/.gitignore      2009-04-29 15:48:26.996484383 +0200
> @@ -0,0 +1,134 @@
> +# object files
> +*.o
> +
> +# build system
> +.census
> +Logs/
> +include/config.h
> +include/builddefs
> +install-sh
> +
> +# magic diretory symlinks
> +#include/disk
> +#include/xfs
> +
> +# Makepgs
> +build/src-manifest
> +build/xfsdump-*.tar.gz
> +doc/CHANGES.gz
> +xfsdump-*
> +
> +# autoconf generated files
> +aclocal.m4
> +autom4te.cache/
> +config.guess
> +config.log
> +config.status
> +config.sub
> +configure
> +
> +# libtool
> +libtool
> +ltmain.sh
> +*.lo
> +*.la
> +.libs
> +
> +# gettext
> +po/xfsdump.pot
> +po/*.mo
> +
> +# quilt stuff
> +.pc/
> +patches/
> +
> +# binaries
> +dump/xfsdump
> +invutil/xfsinvutil
> +restore/xfsrestore
> +
> +# @%#% symlinked sourced files
> +dump/arch_xlate.[ch]
> +dump/cldmgr.[ch]
> +dump/content.h
> +dump/content_common.[ch]
> +dump/content_inode.h
> +dump/dlog.[ch]
> +dump/drive.[ch]
> +dump/drive_minrmt.c
> +dump/drive_scsitape.c
> +dump/drive_simple.c
> +dump/exit.h
> +dump/fs.[ch]
> +dump/getdents.[ch]
> +dump/global.[ch]
> +dump/hsmapi.[ch]
> +dump/inv_api.c
> +dump/inv_core.c
> +dump/inv_files.c
> +dump/inv_fstab.c
> +dump/inv_idx.c
> +dump/inv_mgr.c
> +dump/inv_priv.h
> +dump/inv_stobj.c
> +dump/inventory.h
> +dump/lock.[ch]
> +dump/main.c
> +dump/media.h
> +dump/mlog.[ch]
> +dump/openutil.[ch]
> +dump/path.[ch]
> +dump/qlock.[ch]
> +dump/rec_hdr.h
> +dump/ring.[ch]
> +dump/sproc.[ch]
> +dump/stream.[ch]
> +dump/ts_mtio.h
> +dump/types.h
> +dump/util.[ch]
> +
> +invutil/global.h
> +invutil/inv_files.c
> +invutil/inv_priv.h
> +invutil/inventory.h
> +invutil/mlog.h
> +invutil/types.h
> +invutil/util.h
> +
> +restore/arch_xlate.[ch]
> +restore/cldmgr.[ch]
> +restore/content.h
> +restore/content_inode.h
> +restore/dlog.[ch]
> +restore/drive.[ch]
> +restore/drive_minrmt.c
> +restore/drive_scsitape.c
> +restore/drive_simple.c
> +restore/exit.h
> +restore/fs.[ch]
> +restore/getdents.[ch]
> +restore/global.[ch]
> +restore/hsmapi.[ch]
> +restore/inv_api.c
> +restore/inv_core.c
> +restore/inv_files.c
> +restore/inv_fstab.c
> +restore/inv_idx.c
> +restore/inv_mgr.c
> +restore/inv_priv.h
> +restore/inv_stobj.c
> +restore/inventory.h
> +restore/lock.[ch]
> +restore/main.c
> +restore/media.h
> +restore/mlog.[ch]
> +restore/openutil.[ch]
> +restore/path.[ch]
> +restore/qlock.[ch]
> +restore/rec_hdr.h
> +restore/ring.[ch]
> +restore/sproc.[ch]
> +restore/stream.[ch]
> +restore/ts_mtio.h
> +restore/types.h
> +restore/util.[ch]
>
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
>

--000e0cd17b9ae2d5f204690a80a9
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Get rid of the symlinked files by creating a local library for the commonal=
ity? ;-)<div>Probably easier said than done - I haven&#39;t looked at the c=
ode in a while - but I</div><div>I think the traditional library model is b=
etter than a heap of symlinks :)</div>
<div>(I realise you just want a .gitignore file but .... ;-)<br><div><br></=
div><div>--Tim<br><br><div class=3D"gmail_quote">On Wed, Apr 29, 2009 at 11=
:50 PM, Christoph Hellwig <span dir=3D"ltr">&lt;<a href=3D"mailto:hch@infra=
dead.org">hch@infradead.org</a>&gt;</span> wrote:<br>
<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex;">This one is pretty ugly due to all the syml=
inked files, any better<br>
suggestions?<br>
<br>
<br>
Signed-off-by: Christoph Hellwig &lt;<a href=3D"mailto:hch@lst.de">hch@lst.=
de</a>&gt;<br>
<br>
Index: xfsdump-dev/.gitignore<br>
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D<br>
--- /dev/null =A0 1970-01-01 00:00:00.000000000 +0000<br>
+++ xfsdump-dev/.gitignore =A0 =A0 =A02009-04-29 15:48:26.996484383 +0200<b=
r>
@@ -0,0 +1,134 @@<br>
+# object files<br>
+*.o<br>
+<br>
+# build system<br>
+.census<br>
+Logs/<br>
+include/config.h<br>
+include/builddefs<br>
+install-sh<br>
+<br>
+# magic diretory symlinks<br>
+#include/disk<br>
+#include/xfs<br>
+<br>
+# Makepgs<br>
+build/src-manifest<br>
+build/xfsdump-*.tar.gz<br>
+doc/CHANGES.gz<br>
+xfsdump-*<br>
+<br>
+# autoconf generated files<br>
+aclocal.m4<br>
+autom4te.cache/<br>
+config.guess<br>
+config.log<br>
+config.status<br>
+config.sub<br>
+configure<br>
+<br>
+# libtool<br>
+libtool<br>
+ltmain.sh<br>
+*.lo<br>
+*.la<br>
+.libs<br>
+<br>
+# gettext<br>
+po/xfsdump.pot<br>
+po/*.mo<br>
+<br>
+# quilt stuff<br>
+.pc/<br>
+patches/<br>
+<br>
+# binaries<br>
+dump/xfsdump<br>
+invutil/xfsinvutil<br>
+restore/xfsrestore<br>
+<br>
+# @%#% symlinked sourced files<br>
+dump/arch_xlate.[ch]<br>
+dump/cldmgr.[ch]<br>
+dump/content.h<br>
+dump/content_common.[ch]<br>
+dump/content_inode.h<br>
+dump/dlog.[ch]<br>
+dump/drive.[ch]<br>
+dump/drive_minrmt.c<br>
+dump/drive_scsitape.c<br>
+dump/drive_simple.c<br>
+dump/exit.h<br>
+dump/fs.[ch]<br>
+dump/getdents.[ch]<br>
+dump/global.[ch]<br>
+dump/hsmapi.[ch]<br>
+dump/inv_api.c<br>
+dump/inv_core.c<br>
+dump/inv_files.c<br>
+dump/inv_fstab.c<br>
+dump/inv_idx.c<br>
+dump/inv_mgr.c<br>
+dump/inv_priv.h<br>
+dump/inv_stobj.c<br>
+dump/inventory.h<br>
+dump/lock.[ch]<br>
+dump/main.c<br>
+dump/media.h<br>
+dump/mlog.[ch]<br>
+dump/openutil.[ch]<br>
+dump/path.[ch]<br>
+dump/qlock.[ch]<br>
+dump/rec_hdr.h<br>
+dump/ring.[ch]<br>
+dump/sproc.[ch]<br>
+dump/stream.[ch]<br>
+dump/ts_mtio.h<br>
+dump/types.h<br>
+dump/util.[ch]<br>
+<br>
+invutil/global.h<br>
+invutil/inv_files.c<br>
+invutil/inv_priv.h<br>
+invutil/inventory.h<br>
+invutil/mlog.h<br>
+invutil/types.h<br>
+invutil/util.h<br>
+<br>
+restore/arch_xlate.[ch]<br>
+restore/cldmgr.[ch]<br>
+restore/content.h<br>
+restore/content_inode.h<br>
+restore/dlog.[ch]<br>
+restore/drive.[ch]<br>
+restore/drive_minrmt.c<br>
+restore/drive_scsitape.c<br>
+restore/drive_simple.c<br>
+restore/exit.h<br>
+restore/fs.[ch]<br>
+restore/getdents.[ch]<br>
+restore/global.[ch]<br>
+restore/hsmapi.[ch]<br>
+restore/inv_api.c<br>
+restore/inv_core.c<br>
+restore/inv_files.c<br>
+restore/inv_fstab.c<br>
+restore/inv_idx.c<br>
+restore/inv_mgr.c<br>
+restore/inv_priv.h<br>
+restore/inv_stobj.c<br>
+restore/inventory.h<br>
+restore/lock.[ch]<br>
+restore/main.c<br>
+restore/media.h<br>
+restore/mlog.[ch]<br>
+restore/openutil.[ch]<br>
+restore/path.[ch]<br>
+restore/qlock.[ch]<br>
+restore/rec_hdr.h<br>
+restore/ring.[ch]<br>
+restore/sproc.[ch]<br>
+restore/stream.[ch]<br>
+restore/ts_mtio.h<br>
+restore/types.h<br>
+restore/util.[ch]<br>
<br>
_______________________________________________<br>
xfs mailing list<br>
<a href=3D"mailto:xfs@oss.sgi.com">xfs@oss.sgi.com</a><br>
<a href=3D"http://oss.sgi.com/mailman/listinfo/xfs" target=3D"_blank">http:=
//oss.sgi.com/mailman/listinfo/xfs</a><br>
</blockquote></div><br></div></div>

--000e0cd17b9ae2d5f204690a80a9--


--===============7184269248066861284==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============7184269248066861284==--
