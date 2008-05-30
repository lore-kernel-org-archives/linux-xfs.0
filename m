Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 29 May 2008 17:48:19 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m4U0m0KN030399
	for <xfs@oss.sgi.com>; Thu, 29 May 2008 17:48:10 -0700
Received: from pc-bnaujok.melbourne.sgi.com (pc-bnaujok.melbourne.sgi.com [134.14.55.58]) by larry.melbourne.sgi.com (950413.SGI.8.6.12/950213.SGI.AUTOCF) via ESMTP id KAA15258 for <xfs@oss.sgi.com>; Fri, 30 May 2008 10:48:50 +1000
Date: Fri, 30 May 2008 10:49:18 +1000
Subject: REVIEW: Enhance xfs_repair -P option to disable libxfs xfs_buf_t locking
From: "Barry Naujok" <bnaujok@sgi.com>
Content-Type: multipart/mixed; boundary=----------ISQHamI6crqZS8JCtnUcjs
MIME-Version: 1.0
Message-ID: <op.ubxy8gk63jf8g2@pc-bnaujok.melbourne.sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

------------ISQHamI6crqZS8JCtnUcjs
Content-Type: text/plain; format=flowed; delsp=yes; charset=utf-8
Content-Transfer-Encoding: Quoted-Printable

I hope the subject is explanation enough :)

Tested successfully by Sebastian on his filesystem reported in
http://oss.sgi.com/archives/xfs/2008-05/msg00410.html

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
xfsprogs/include/libxfs.h
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

--- a/xfsprogs/include/libxfs.h	2008-05-28 18:10:03.000000000 +1000
+++ b/xfsprogs/include/libxfs.h	2008-05-28 17:47:13.956576883 +1000
@@ -69,11 +69,14 @@ typedef struct {
  	char            *rtname;        /* pathname of realtime "subvolume" */
  	int             isreadonly;     /* filesystem is only read in applic */
  	int             isdirect;       /* we can attempt to use direct I/O */
-	int             disfile;        /* data "subvolume" is a regular file=20=
=20
*/        int             dcreat;         /* try to create data subvolume=
=20=20
*/
+	int             disfile;        /* data "subvolume" is a regular file */
+	int             dcreat;         /* try to create data subvolume */
  	int             lisfile;        /* log "subvolume" is a regular file */
  	int             lcreat;         /* try to create log subvolume */
-	int             risfile;        /* realtime "subvolume" is a reg file=20=
=20
*/        int             rcreat;         /* try to create realtime=20=20
subvolume */
+	int             risfile;        /* realtime "subvolume" is a reg file */
+	int             rcreat;         /* try to create realtime subvolume */
  	int		setblksize;	/* attempt to set device blksize */
+	int		nobuflock;	/* don't lock xfs_buf_t's */
  				/* output results */
  	dev_t           ddev;           /* device for data subvolume */
  	dev_t           logdev;         /* device for log subvolume */

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
xfsprogs/libxfs/init.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

--- a/xfsprogs/libxfs/init.c	2008-05-28 18:10:03.000000000 +1000
+++ b/xfsprogs/libxfs/init.c	2008-05-28 17:50:48.105195527 +1000
@@ -28,6 +28,8 @@ int libxfs_ihash_size;		/* #buckets in i
  struct cache *libxfs_bcache;	/* global buffer cache */
  int libxfs_bhash_size;		/* #buckets in bcache */

+int	no_xfs_buf_lock;	/* global don't use xfs_buf_t lock flag */
+
  static void manage_zones(int);	/* setup global zones */

  /*
@@ -335,6 +337,7 @@ libxfs_init(libxfs_init_t *a)
  	if (!libxfs_bhash_size)
  		libxfs_bhash_size =3D LIBXFS_BHASHSIZE(sbp);
  	libxfs_bcache =3D cache_init(libxfs_bhash_size, &libxfs_bcache_operation=
s);
+	no_xfs_buf_lock =3D a->nobuflock;
  	manage_zones(0);
  	rval =3D 1;
  done:

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
xfsprogs/libxfs/rdwr.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

--- a/xfsprogs/libxfs/rdwr.c	2008-05-28 18:10:03.000000000 +1000
+++ b/xfsprogs/libxfs/rdwr.c	2008-05-28 18:01:29.735224868 +1000
@@ -375,6 +375,8 @@ struct list_head	lock_buf_list =3D {&lock_
  int			lock_buf_count =3D 0;
  #endif

+extern int     no_xfs_buf_lock;
+
  xfs_buf_t *
  libxfs_getbuf(dev_t device, xfs_daddr_t blkno, int len)
  {
@@ -388,7 +390,8 @@ libxfs_getbuf(dev_t device, xfs_daddr_t

  	miss =3D cache_node_get(libxfs_bcache, &key, (struct cache_node **)&bp);
  	if (bp) {
-		pthread_mutex_lock(&bp->b_lock);
+		if (!no_xfs_buf_lock)
+			pthread_mutex_lock(&bp->b_lock);
  		cache_node_set_priority(libxfs_bcache, (struct cache_node *)bp,
  			cache_node_get_priority((struct cache_node *)bp) - 4);
  #ifdef XFS_BUF_TRACING
@@ -417,7 +420,8 @@ libxfs_putbuf(xfs_buf_t *bp)
  	list_del_init(&bp->b_lock_list);
  	pthread_mutex_unlock(&libxfs_bcache->c_mutex);
  #endif
-	pthread_mutex_unlock(&bp->b_lock);
+	if (!no_xfs_buf_lock)
+		pthread_mutex_unlock(&bp->b_lock);
  	cache_node_put((struct cache_node *)bp);
  }


=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
xfsprogs/repair/init.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

--- a/xfsprogs/repair/init.c	2008-05-28 18:10:03.000000000 +1000
+++ b/xfsprogs/repair/init.c	2008-05-28 17:52:26.024674072 +1000
@@ -135,6 +135,7 @@ xfs_init(libxfs_init_t *args)
  		/* XXX assume data file also means rt file */
  	}

+	args->nobuflock =3D !do_prefetch;
  	args->setblksize =3D !dangerously;
  	args->isdirect =3D LIBXFS_DIRECT;
  	if (no_modify)
------------ISQHamI6crqZS8JCtnUcjs
Content-Disposition: attachment; filename=no_xfs_buf_t_lock_repair.patch
Content-Type: text/x-patch; name=no_xfs_buf_t_lock_repair.patch
Content-Transfer-Encoding: Base64

Cj09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PQp4ZnNwcm9ncy9pbmNs
dWRlL2xpYnhmcy5oCj09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PQoK
LS0tIGEveGZzcHJvZ3MvaW5jbHVkZS9saWJ4ZnMuaAkyMDA4LTA1LTI4IDE4
OjEwOjAzLjAwMDAwMDAwMCArMTAwMAorKysgYi94ZnNwcm9ncy9pbmNsdWRl
L2xpYnhmcy5oCTIwMDgtMDUtMjggMTc6NDc6MTMuOTU2NTc2ODgzICsxMDAw
CkBAIC02OSwxMSArNjksMTQgQEAgdHlwZWRlZiBzdHJ1Y3QgewogCWNoYXIg
ICAgICAgICAgICAqcnRuYW1lOyAgICAgICAgLyogcGF0aG5hbWUgb2YgcmVh
bHRpbWUgInN1YnZvbHVtZSIgKi8KIAlpbnQgICAgICAgICAgICAgaXNyZWFk
b25seTsgICAgIC8qIGZpbGVzeXN0ZW0gaXMgb25seSByZWFkIGluIGFwcGxp
YyAqLwogCWludCAgICAgICAgICAgICBpc2RpcmVjdDsgICAgICAgLyogd2Ug
Y2FuIGF0dGVtcHQgdG8gdXNlIGRpcmVjdCBJL08gKi8KLQlpbnQgICAgICAg
ICAgICAgZGlzZmlsZTsgICAgICAgIC8qIGRhdGEgInN1YnZvbHVtZSIgaXMg
YSByZWd1bGFyIGZpbGUgKi8gICAgICAgIGludCAgICAgICAgICAgICBkY3Jl
YXQ7ICAgICAgICAgLyogdHJ5IHRvIGNyZWF0ZSBkYXRhIHN1YnZvbHVtZSAq
LworCWludCAgICAgICAgICAgICBkaXNmaWxlOyAgICAgICAgLyogZGF0YSAi
c3Vidm9sdW1lIiBpcyBhIHJlZ3VsYXIgZmlsZSAqLworCWludCAgICAgICAg
ICAgICBkY3JlYXQ7ICAgICAgICAgLyogdHJ5IHRvIGNyZWF0ZSBkYXRhIHN1
YnZvbHVtZSAqLwogCWludCAgICAgICAgICAgICBsaXNmaWxlOyAgICAgICAg
LyogbG9nICJzdWJ2b2x1bWUiIGlzIGEgcmVndWxhciBmaWxlICovCiAJaW50
ICAgICAgICAgICAgIGxjcmVhdDsgICAgICAgICAvKiB0cnkgdG8gY3JlYXRl
IGxvZyBzdWJ2b2x1bWUgKi8KLQlpbnQgICAgICAgICAgICAgcmlzZmlsZTsg
ICAgICAgIC8qIHJlYWx0aW1lICJzdWJ2b2x1bWUiIGlzIGEgcmVnIGZpbGUg
Ki8gICAgICAgIGludCAgICAgICAgICAgICByY3JlYXQ7ICAgICAgICAgLyog
dHJ5IHRvIGNyZWF0ZSByZWFsdGltZSBzdWJ2b2x1bWUgKi8KKwlpbnQgICAg
ICAgICAgICAgcmlzZmlsZTsgICAgICAgIC8qIHJlYWx0aW1lICJzdWJ2b2x1
bWUiIGlzIGEgcmVnIGZpbGUgKi8KKwlpbnQgICAgICAgICAgICAgcmNyZWF0
OyAgICAgICAgIC8qIHRyeSB0byBjcmVhdGUgcmVhbHRpbWUgc3Vidm9sdW1l
ICovCiAJaW50CQlzZXRibGtzaXplOwkvKiBhdHRlbXB0IHRvIHNldCBkZXZp
Y2UgYmxrc2l6ZSAqLworCWludAkJbm9idWZsb2NrOwkvKiBkb24ndCBsb2Nr
IHhmc19idWZfdCdzICovCiAJCQkJLyogb3V0cHV0IHJlc3VsdHMgKi8KIAlk
ZXZfdCAgICAgICAgICAgZGRldjsgICAgICAgICAgIC8qIGRldmljZSBmb3Ig
ZGF0YSBzdWJ2b2x1bWUgKi8KIAlkZXZfdCAgICAgICAgICAgbG9nZGV2OyAg
ICAgICAgIC8qIGRldmljZSBmb3IgbG9nIHN1YnZvbHVtZSAqLwoKPT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09Cnhmc3Byb2dzL2xpYnhmcy9pbml0
LmMKPT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09CgotLS0gYS94ZnNw
cm9ncy9saWJ4ZnMvaW5pdC5jCTIwMDgtMDUtMjggMTg6MTA6MDMuMDAwMDAw
MDAwICsxMDAwCisrKyBiL3hmc3Byb2dzL2xpYnhmcy9pbml0LmMJMjAwOC0w
NS0yOCAxNzo1MDo0OC4xMDUxOTU1MjcgKzEwMDAKQEAgLTI4LDYgKzI4LDgg
QEAgaW50IGxpYnhmc19paGFzaF9zaXplOwkJLyogI2J1Y2tldHMgaW4gaQog
c3RydWN0IGNhY2hlICpsaWJ4ZnNfYmNhY2hlOwkvKiBnbG9iYWwgYnVmZmVy
IGNhY2hlICovCiBpbnQgbGlieGZzX2JoYXNoX3NpemU7CQkvKiAjYnVja2V0
cyBpbiBiY2FjaGUgKi8KIAoraW50CW5vX3hmc19idWZfbG9jazsJLyogZ2xv
YmFsIGRvbid0IHVzZSB4ZnNfYnVmX3QgbG9jayBmbGFnICovCisKIHN0YXRp
YyB2b2lkIG1hbmFnZV96b25lcyhpbnQpOwkvKiBzZXR1cCBnbG9iYWwgem9u
ZXMgKi8KIAogLyoKQEAgLTMzNSw2ICszMzcsNyBAQCBsaWJ4ZnNfaW5pdChs
aWJ4ZnNfaW5pdF90ICphKQogCWlmICghbGlieGZzX2JoYXNoX3NpemUpCiAJ
CWxpYnhmc19iaGFzaF9zaXplID0gTElCWEZTX0JIQVNIU0laRShzYnApOwog
CWxpYnhmc19iY2FjaGUgPSBjYWNoZV9pbml0KGxpYnhmc19iaGFzaF9zaXpl
LCAmbGlieGZzX2JjYWNoZV9vcGVyYXRpb25zKTsKKwlub194ZnNfYnVmX2xv
Y2sgPSBhLT5ub2J1ZmxvY2s7CiAJbWFuYWdlX3pvbmVzKDApOwogCXJ2YWwg
PSAxOwogZG9uZToKCj09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PQp4
ZnNwcm9ncy9saWJ4ZnMvcmR3ci5jCj09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PQoKLS0tIGEveGZzcHJvZ3MvbGlieGZzL3Jkd3IuYwkyMDA4LTA1
LTI4IDE4OjEwOjAzLjAwMDAwMDAwMCArMTAwMAorKysgYi94ZnNwcm9ncy9s
aWJ4ZnMvcmR3ci5jCTIwMDgtMDUtMjggMTg6MDE6MjkuNzM1MjI0ODY4ICsx
MDAwCkBAIC0zNzUsNiArMzc1LDggQEAgc3RydWN0IGxpc3RfaGVhZAlsb2Nr
X2J1Zl9saXN0ID0geyZsb2NrXwogaW50CQkJbG9ja19idWZfY291bnQgPSAw
OwogI2VuZGlmCiAKK2V4dGVybiBpbnQgICAgIG5vX3hmc19idWZfbG9jazsK
KwogeGZzX2J1Zl90ICoKIGxpYnhmc19nZXRidWYoZGV2X3QgZGV2aWNlLCB4
ZnNfZGFkZHJfdCBibGtubywgaW50IGxlbikKIHsKQEAgLTM4OCw3ICszOTAs
OCBAQCBsaWJ4ZnNfZ2V0YnVmKGRldl90IGRldmljZSwgeGZzX2RhZGRyX3Qg
CiAKIAltaXNzID0gY2FjaGVfbm9kZV9nZXQobGlieGZzX2JjYWNoZSwgJmtl
eSwgKHN0cnVjdCBjYWNoZV9ub2RlICoqKSZicCk7CiAJaWYgKGJwKSB7Ci0J
CXB0aHJlYWRfbXV0ZXhfbG9jaygmYnAtPmJfbG9jayk7CisJCWlmICghbm9f
eGZzX2J1Zl9sb2NrKQorCQkJcHRocmVhZF9tdXRleF9sb2NrKCZicC0+Yl9s
b2NrKTsKIAkJY2FjaGVfbm9kZV9zZXRfcHJpb3JpdHkobGlieGZzX2JjYWNo
ZSwgKHN0cnVjdCBjYWNoZV9ub2RlICopYnAsCiAJCQljYWNoZV9ub2RlX2dl
dF9wcmlvcml0eSgoc3RydWN0IGNhY2hlX25vZGUgKilicCkgLSA0KTsKICNp
ZmRlZiBYRlNfQlVGX1RSQUNJTkcKQEAgLTQxNyw3ICs0MjAsOCBAQCBsaWJ4
ZnNfcHV0YnVmKHhmc19idWZfdCAqYnApCiAJbGlzdF9kZWxfaW5pdCgmYnAt
PmJfbG9ja19saXN0KTsKIAlwdGhyZWFkX211dGV4X3VubG9jaygmbGlieGZz
X2JjYWNoZS0+Y19tdXRleCk7CiAjZW5kaWYKLQlwdGhyZWFkX211dGV4X3Vu
bG9jaygmYnAtPmJfbG9jayk7CisJaWYgKCFub194ZnNfYnVmX2xvY2spCisJ
CXB0aHJlYWRfbXV0ZXhfdW5sb2NrKCZicC0+Yl9sb2NrKTsKIAljYWNoZV9u
b2RlX3B1dCgoc3RydWN0IGNhY2hlX25vZGUgKilicCk7CiB9CiAKCj09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PQp4ZnNwcm9ncy9yZXBhaXIvaW5p
dC5jCj09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PQoKLS0tIGEveGZz
cHJvZ3MvcmVwYWlyL2luaXQuYwkyMDA4LTA1LTI4IDE4OjEwOjAzLjAwMDAw
MDAwMCArMTAwMAorKysgYi94ZnNwcm9ncy9yZXBhaXIvaW5pdC5jCTIwMDgt
MDUtMjggMTc6NTI6MjYuMDI0Njc0MDcyICsxMDAwCkBAIC0xMzUsNiArMTM1
LDcgQEAgeGZzX2luaXQobGlieGZzX2luaXRfdCAqYXJncykKIAkJLyogWFhY
IGFzc3VtZSBkYXRhIGZpbGUgYWxzbyBtZWFucyBydCBmaWxlICovCiAJfQog
CisJYXJncy0+bm9idWZsb2NrID0gIWRvX3ByZWZldGNoOwogCWFyZ3MtPnNl
dGJsa3NpemUgPSAhZGFuZ2Vyb3VzbHk7CiAJYXJncy0+aXNkaXJlY3QgPSBM
SUJYRlNfRElSRUNUOwogCWlmIChub19tb2RpZnkpCg==

------------ISQHamI6crqZS8JCtnUcjs--
