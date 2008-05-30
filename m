Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 29 May 2008 18:02:40 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m4U12YWr032144
	for <xfs@oss.sgi.com>; Thu, 29 May 2008 18:02:35 -0700
Date: Fri, 30 May 2008 11:03:51 +1000
Subject: Re: REVIEW: Enhance xfs_repair -P option to disable libxfs xfs_buf_t locking
From: "Barry Naujok" <bnaujok@sgi.com>
Content-Type: multipart/mixed; boundary=----------gqTEqeKk4oEHa0PPtngyH3
MIME-Version: 1.0
References: <op.ubxy8gk63jf8g2@pc-bnaujok.melbourne.sgi.com> <483F4FC7.3060801@sandeen.net>
Message-ID: <op.ubxzwpsd3jf8g2@pc-bnaujok.melbourne.sgi.com>
In-Reply-To: <483F4FC7.3060801@sandeen.net>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

------------gqTEqeKk4oEHa0PPtngyH3
Content-Type: text/plain; format=flowed; delsp=yes; charset=utf-8
Content-Transfer-Encoding: Quoted-Printable

On Fri, 30 May 2008 10:52:23 +1000, Eric Sandeen <sandeen@sandeen.net>=20=
=20
wrote:

> Barry Naujok wrote:
>> I hope the subject is explanation enough :)
>
> not really ;)
>
> Hum, if I normally lock why do I not want to lock?  Locking good?
> Locking bad?  Locking too slow?  locking for what?  Incoherency ok?  Man
> page updates? :)

Ok, I've reversed the logic, makes it much clearer.

So, with prefetch mode in xfs_repair, you need to lock the xfs_buf_t's
so the prefetch and processing threads play sensibily with them (ie.
avoiding simultaneous reads/writes - much like the kernel xfs_buf_t's).

If you disable prefetch, or the process is single threaded, there is
no need to use the locks.

So, this patch only locks the buffers if it's xfs_repair running without
the -P mode.


=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
xfsprogs/include/libxfs.h
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

--- a/xfsprogs/include/libxfs.h	2008-05-30 11:00:44.000000000 +1000
+++ b/xfsprogs/include/libxfs.h	2008-05-30 10:55:15.561596557 +1000
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
+	int		usebuflock;	/* lock xfs_buf_t's - for MT usage */
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

--- a/xfsprogs/libxfs/init.c	2008-05-30 11:00:44.000000000 +1000
+++ b/xfsprogs/libxfs/init.c	2008-05-30 10:57:52.189289029 +1000
@@ -28,6 +28,8 @@ int libxfs_ihash_size;		/* #buckets in i
  struct cache *libxfs_bcache;	/* global buffer cache */
  int libxfs_bhash_size;		/* #buckets in bcache */

+int	use_xfs_buf_lock;	/* global flag: use xfs_buf_t locks for MT */
+
  static void manage_zones(int);	/* setup global zones */

  /*
@@ -335,6 +337,7 @@ libxfs_init(libxfs_init_t *a)
  	if (!libxfs_bhash_size)
  		libxfs_bhash_size =3D LIBXFS_BHASHSIZE(sbp);
  	libxfs_bcache =3D cache_init(libxfs_bhash_size, &libxfs_bcache_operation=
s);
+	use_xfs_buf_lock =3D a->usebuflock;
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

--- a/xfsprogs/libxfs/rdwr.c	2008-05-30 11:00:44.000000000 +1000
+++ b/xfsprogs/libxfs/rdwr.c	2008-05-30 10:58:47.018181515 +1000
@@ -375,6 +375,8 @@ struct list_head	lock_buf_list =3D {&lock_
  int			lock_buf_count =3D 0;
  #endif

+extern int     use_xfs_buf_lock;
+
  xfs_buf_t *
  libxfs_getbuf(dev_t device, xfs_daddr_t blkno, int len)
  {
@@ -388,7 +390,8 @@ libxfs_getbuf(dev_t device, xfs_daddr_t

  	miss =3D cache_node_get(libxfs_bcache, &key, (struct cache_node **)&bp);
  	if (bp) {
-		pthread_mutex_lock(&bp->b_lock);
+		if (use_xfs_buf_lock)
+			pthread_mutex_lock(&bp->b_lock);
  		cache_node_set_priority(libxfs_bcache, (struct cache_node *)bp,
  			cache_node_get_priority((struct cache_node *)bp) - 4);
  #ifdef XFS_BUF_TRACING
@@ -417,7 +420,8 @@ libxfs_putbuf(xfs_buf_t *bp)
  	list_del_init(&bp->b_lock_list);
  	pthread_mutex_unlock(&libxfs_bcache->c_mutex);
  #endif
-	pthread_mutex_unlock(&bp->b_lock);
+	if (use_xfs_buf_lock)
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

--- a/xfsprogs/repair/init.c	2008-05-30 11:00:44.000000000 +1000
+++ b/xfsprogs/repair/init.c	2008-05-30 10:59:50.217989698 +1000
@@ -135,6 +135,7 @@ xfs_init(libxfs_init_t *args)
  		/* XXX assume data file also means rt file */
  	}

+	args->usebuflock =3D do_prefetch;
  	args->setblksize =3D !dangerously;
  	args->isdirect =3D LIBXFS_DIRECT;
  	if (no_modify)

------------gqTEqeKk4oEHa0PPtngyH3
Content-Disposition: attachment; filename=no_xfs_buf_t_lock_repair.patch
Content-Type: text/x-patch; name=no_xfs_buf_t_lock_repair.patch
Content-Transfer-Encoding: Base64

Cj09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PQp4ZnNwcm9ncy9pbmNs
dWRlL2xpYnhmcy5oCj09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PQoK
LS0tIGEveGZzcHJvZ3MvaW5jbHVkZS9saWJ4ZnMuaAkyMDA4LTA1LTMwIDEx
OjAwOjQ0LjAwMDAwMDAwMCArMTAwMAorKysgYi94ZnNwcm9ncy9pbmNsdWRl
L2xpYnhmcy5oCTIwMDgtMDUtMzAgMTA6NTU6MTUuNTYxNTk2NTU3ICsxMDAw
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
Y2UgYmxrc2l6ZSAqLworCWludAkJdXNlYnVmbG9jazsJLyogbG9jayB4ZnNf
YnVmX3QncyAtIGZvciBNVCB1c2FnZSAqLwogCQkJCS8qIG91dHB1dCByZXN1
bHRzICovCiAJZGV2X3QgICAgICAgICAgIGRkZXY7ICAgICAgICAgICAvKiBk
ZXZpY2UgZm9yIGRhdGEgc3Vidm9sdW1lICovCiAJZGV2X3QgICAgICAgICAg
IGxvZ2RldjsgICAgICAgICAvKiBkZXZpY2UgZm9yIGxvZyBzdWJ2b2x1bWUg
Ki8KCj09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PQp4ZnNwcm9ncy9s
aWJ4ZnMvaW5pdC5jCj09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PQoK
LS0tIGEveGZzcHJvZ3MvbGlieGZzL2luaXQuYwkyMDA4LTA1LTMwIDExOjAw
OjQ0LjAwMDAwMDAwMCArMTAwMAorKysgYi94ZnNwcm9ncy9saWJ4ZnMvaW5p
dC5jCTIwMDgtMDUtMzAgMTA6NTc6NTIuMTg5Mjg5MDI5ICsxMDAwCkBAIC0y
OCw2ICsyOCw4IEBAIGludCBsaWJ4ZnNfaWhhc2hfc2l6ZTsJCS8qICNidWNr
ZXRzIGluIGkKIHN0cnVjdCBjYWNoZSAqbGlieGZzX2JjYWNoZTsJLyogZ2xv
YmFsIGJ1ZmZlciBjYWNoZSAqLwogaW50IGxpYnhmc19iaGFzaF9zaXplOwkJ
LyogI2J1Y2tldHMgaW4gYmNhY2hlICovCiAKK2ludAl1c2VfeGZzX2J1Zl9s
b2NrOwkvKiBnbG9iYWwgZmxhZzogdXNlIHhmc19idWZfdCBsb2NrcyBmb3Ig
TVQgKi8KKwogc3RhdGljIHZvaWQgbWFuYWdlX3pvbmVzKGludCk7CS8qIHNl
dHVwIGdsb2JhbCB6b25lcyAqLwogCiAvKgpAQCAtMzM1LDYgKzMzNyw3IEBA
IGxpYnhmc19pbml0KGxpYnhmc19pbml0X3QgKmEpCiAJaWYgKCFsaWJ4ZnNf
Ymhhc2hfc2l6ZSkKIAkJbGlieGZzX2JoYXNoX3NpemUgPSBMSUJYRlNfQkhB
U0hTSVpFKHNicCk7CiAJbGlieGZzX2JjYWNoZSA9IGNhY2hlX2luaXQobGli
eGZzX2JoYXNoX3NpemUsICZsaWJ4ZnNfYmNhY2hlX29wZXJhdGlvbnMpOwor
CXVzZV94ZnNfYnVmX2xvY2sgPSBhLT51c2VidWZsb2NrOwogCW1hbmFnZV96
b25lcygwKTsKIAlydmFsID0gMTsKIGRvbmU6Cgo9PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT0KeGZzcHJvZ3MvbGlieGZzL3Jkd3IuYwo9PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT0KCi0tLSBhL3hmc3Byb2dzL2xpYnhm
cy9yZHdyLmMJMjAwOC0wNS0zMCAxMTowMDo0NC4wMDAwMDAwMDAgKzEwMDAK
KysrIGIveGZzcHJvZ3MvbGlieGZzL3Jkd3IuYwkyMDA4LTA1LTMwIDEwOjU4
OjQ3LjAxODE4MTUxNSArMTAwMApAQCAtMzc1LDYgKzM3NSw4IEBAIHN0cnVj
dCBsaXN0X2hlYWQJbG9ja19idWZfbGlzdCA9IHsmbG9ja18KIGludAkJCWxv
Y2tfYnVmX2NvdW50ID0gMDsKICNlbmRpZgogCitleHRlcm4gaW50ICAgICB1
c2VfeGZzX2J1Zl9sb2NrOworCiB4ZnNfYnVmX3QgKgogbGlieGZzX2dldGJ1
ZihkZXZfdCBkZXZpY2UsIHhmc19kYWRkcl90IGJsa25vLCBpbnQgbGVuKQog
ewpAQCAtMzg4LDcgKzM5MCw4IEBAIGxpYnhmc19nZXRidWYoZGV2X3QgZGV2
aWNlLCB4ZnNfZGFkZHJfdCAKIAogCW1pc3MgPSBjYWNoZV9ub2RlX2dldChs
aWJ4ZnNfYmNhY2hlLCAma2V5LCAoc3RydWN0IGNhY2hlX25vZGUgKiopJmJw
KTsKIAlpZiAoYnApIHsKLQkJcHRocmVhZF9tdXRleF9sb2NrKCZicC0+Yl9s
b2NrKTsKKwkJaWYgKHVzZV94ZnNfYnVmX2xvY2spCisJCQlwdGhyZWFkX211
dGV4X2xvY2soJmJwLT5iX2xvY2spOwogCQljYWNoZV9ub2RlX3NldF9wcmlv
cml0eShsaWJ4ZnNfYmNhY2hlLCAoc3RydWN0IGNhY2hlX25vZGUgKilicCwK
IAkJCWNhY2hlX25vZGVfZ2V0X3ByaW9yaXR5KChzdHJ1Y3QgY2FjaGVfbm9k
ZSAqKWJwKSAtIDQpOwogI2lmZGVmIFhGU19CVUZfVFJBQ0lORwpAQCAtNDE3
LDcgKzQyMCw4IEBAIGxpYnhmc19wdXRidWYoeGZzX2J1Zl90ICpicCkKIAls
aXN0X2RlbF9pbml0KCZicC0+Yl9sb2NrX2xpc3QpOwogCXB0aHJlYWRfbXV0
ZXhfdW5sb2NrKCZsaWJ4ZnNfYmNhY2hlLT5jX211dGV4KTsKICNlbmRpZgot
CXB0aHJlYWRfbXV0ZXhfdW5sb2NrKCZicC0+Yl9sb2NrKTsKKwlpZiAodXNl
X3hmc19idWZfbG9jaykKKwkJcHRocmVhZF9tdXRleF91bmxvY2soJmJwLT5i
X2xvY2spOwogCWNhY2hlX25vZGVfcHV0KChzdHJ1Y3QgY2FjaGVfbm9kZSAq
KWJwKTsKIH0KIAoKPT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09Cnhm
c3Byb2dzL3JlcGFpci9pbml0LmMKPT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09CgotLS0gYS94ZnNwcm9ncy9yZXBhaXIvaW5pdC5jCTIwMDgtMDUt
MzAgMTE6MDA6NDQuMDAwMDAwMDAwICsxMDAwCisrKyBiL3hmc3Byb2dzL3Jl
cGFpci9pbml0LmMJMjAwOC0wNS0zMCAxMDo1OTo1MC4yMTc5ODk2OTggKzEw
MDAKQEAgLTEzNSw2ICsxMzUsNyBAQCB4ZnNfaW5pdChsaWJ4ZnNfaW5pdF90
ICphcmdzKQogCQkvKiBYWFggYXNzdW1lIGRhdGEgZmlsZSBhbHNvIG1lYW5z
IHJ0IGZpbGUgKi8KIAl9CiAKKwlhcmdzLT51c2VidWZsb2NrID0gZG9fcHJl
ZmV0Y2g7CiAJYXJncy0+c2V0Ymxrc2l6ZSA9ICFkYW5nZXJvdXNseTsKIAlh
cmdzLT5pc2RpcmVjdCA9IExJQlhGU19ESVJFQ1Q7CiAJaWYgKG5vX21vZGlm
eSkK

------------gqTEqeKk4oEHa0PPtngyH3--
