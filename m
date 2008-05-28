Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 28 May 2008 01:10:40 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m4S8AWR1008660
	for <xfs@oss.sgi.com>; Wed, 28 May 2008 01:10:33 -0700
Date: Wed, 28 May 2008 18:13:33 +1000
Subject: Re: xfs_repair getting stuck
From: "Barry Naujok" <bnaujok@sgi.com>
Content-Type: multipart/mixed; boundary=----------NL5luSBEEB9F8pOELPD1Rz
MIME-Version: 1.0
References: <ebe74d2a0805271335x5844239eje2eeed606d7cc8b8@mail.gmail.com>
Message-ID: <op.ubuugvc83jf8g2@pc-bnaujok.melbourne.sgi.com>
In-Reply-To: <ebe74d2a0805271335x5844239eje2eeed606d7cc8b8@mail.gmail.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Sebastian M <sebcio@gmail.com>, xfs@oss.sgi.com

------------NL5luSBEEB9F8pOELPD1Rz
Content-Type: text/plain; format=flowed; delsp=yes; charset=utf-8
Content-Transfer-Encoding: Quoted-Printable

On Wed, 28 May 2008 06:35:53 +1000, Sebastian M <sebcio@gmail.com> wrote:

> Hello
>
> I was a happy user of the XFS untill yesterday. I had to move data off
> the XFS partition
> to other storage. I exported it via NFS.
> After half a day of moving files a kernel panic appeared on nfs server.
> (sorry, but currently I don't have any logs). After reboot I wasn't able=
=20=20
> to
> mount XFS partition anymore (got random kernel panics). I've tried to
> xfs_repair, however it didn't work out. I had to use -L option.
> As for now I can mount the partition, but most of my folders are not=20=
=20
> accessible:
> ls -la /
> drwxrwxrwx 221 99   98 4096 V 23 14:37 .
> drwxrwxrwx   3 99 root   21 II  5 01:11 ..
> ??????????   ? ?  ?       ?          ? 05
> ??????????   ? ?  ?       ?          ? 26
> ??????????   ? ?  ?       ?          ? 29
> ??????????   ? ?  ?       ?          ? 2A
> ??????????   ? ?  ?       ?          ? 2B
> ??????????   ? ?  ?       ?          ? 2C
> and so on.
> (few files went to the lost+found)
>
> When I try to run xfs_repair now it gets stuck every time on the same=20=
=20
> moment:
>
> kaszanka:~ # xfs_repair -P /dev/md0
> Phase 1 - find and verify superblock...
> Phase 2 - using internal log
>        - zero log...
>        - scan filesystem freespace and inode maps...
> block (3,1055347) already used, state 2
> block (3,1055348) already used, state 2
> bad on-disk superblock 4 - bad magic number
> primary/secondary superblock 4 conflict - AG superblock geometry info
> conflicts with filesystem geometry
> bad magic # 0x8cb4f for agi 4
> bad sequence # 576384 for agi 4
> bad length # 66 for agi 4, should be 4883888
> reset bad sb for ag 4
> reset bad agi for ag 4
> bad magic # 0x58443242 in inobt block 4/3
> expected level 576591 got 2568 in inobt block 4/3
> bad magic # 0x9c1ac711 in inobt block 4/2112
> bad magic # 0x9cd4974b in inobt block 4/329816
> bad magic # 0x8f1662e7 in inobt block 4/2160
> bad magic # 0x75edc52e in inobt block 4/2184
> bad magic # 0x58443242 in inobt block 4/2208
> bad magic # 0x8632ebfd in inobt block 4/2232
> expected level 576590 got 1 in inobt block 4/98
> bad magic # 0x58443242 in inobt block 4/1
> bad magic # 0x58443242 in inobt block 4/1
> bad magic # 0x553c5125 in inobt block 4/58339
> bad magic # 0x77db49b2 in inobt block 4/15
> bad magic # 0x58443242 in inobt block 4/1
> bad magic # 0x58443242 in inobt block 4/2
> bad magic # 0xc9c0c923 in inobt block 4/344821
> bad magic # 0x58443242 in inobt block 4/99
> expected level 576590 got 1 in inobt block 4/98
> bad magic # 0x58443242 in inobt block 4/1
> bad magic # 0x58443242 in inobt block 4/1
> bad magic # 0x85a7f11f in inobt block 4/51210
> bad magic # 0x28d25805 in inobt block 4/13
> bad magic # 0x58443242 in inobt block 4/1
> bad magic # 0x58443242 in inobt block 4/2
> bad magic # 0xb69f6a9c in inobt block 4/447057
> bad magic # 0x58443242 in inobt block 4/99
> expected level 576590 got 1 in inobt block 4/98
> bad magic # 0x58443242 in inobt block 4/1
>
> Strace shows following:
>
> strace -p
>
> write(2, "bad magic # 0x58443242 in inobt "..., 42) =3D 42
> write(2, "bad magic # 0x58443242 in inobt "..., 42) =3D 42
> pread(4,=20=20
> "\205\247\361\37\306\235:\307U\327\265\0\3260\304\253ej\220\2050\216\2401=
\37|\373\221]p|\310"...,
> 4096, 80227377152) =3D 4096
> write(2, "bad magic # 0x85a7f11f in inobt "..., 46) =3D 46
> pread(4, "(\322X\5\265\301
> s\33\\^\370\351\226}n+\375$8k\200\263f\256n*\254\246\313\375\2"...,
> 4096, 80017674240) =3D 4096
> write(2, "bad magic # 0x28d25805 in inobt "..., 43) =3D 43
> write(2, "bad magic # 0x58443242 in inobt "..., 42) =3D 42
> write(2, "bad magic # 0x58443242 in inobt "..., 42) =3D 42
> pread(4,=20=20
> "\266\237j\234\2\222d\214\364\3540\5\0008\\\310\2272\177\246!F`\311o*\26\=
362\370\302\214\237"...,
> 4096, 81848766464) =3D 4096
> write(2, "bad magic # 0xb69f6a9c in inobt "..., 47) =3D 47
> write(2, "bad magic # 0x58443242 in inobt "..., 43) =3D 43
> write(2, "expected level 576590 got 1 in i"..., 48) =3D 48
> write(2, "bad magic # 0x58443242 in inobt "..., 42) =3D 42
> futex(0xb80c88, FUTEX_WAIT, 2, NULL
>
> I've tried xfs_repair -P but the problem remains - it stuck on the same=
=20=20
> moment.

Can you try the attached patch to an xfsprogs 2.9.8 tarball
(or 2.10.0 CVS version) and try it with the -P option?

It should fix this problem.

> My xfs partition (2.6TB) is created on the top of software raid 5 (10x=20=
=20
> 320gb)
> Right now Im using OpenSuse with 2.6.22.17-0.1-default x86_64 kernel.
> My box got 2 Gigs of ram.
> SATA disks are connected with SIL 3114 raid controllers.
>
> Im using XFSProgs version 2.9.7
>
> Xfs_info:
>
> kaszanka:~ # xfs_info /dev/md0
> meta-data=3D/dev/md0               isize=3D256    agcount=3D144,=20=20
> agsize=3D4883888 blks
>         =3D                       sectsz=3D512   attr=3D0
> data     =3D                       bsize=3D4096   blocks=3D703279296,=20=
=20
> imaxpct=3D25
>         =3D                       sunit=3D16     swidth=3D48 blks
> naming   =3Dversion 2              bsize=3D4096
> log      =3Dinternal               bsize=3D4096   blocks=3D32768, version=
=3D2
>         =3D                       sectsz=3D512   sunit=3D0 blks, lazy-cou=
nt=3D0
> realtime =3Dnone                   extsz=3D196608 blocks=3D0, rtextents=
=3D0
>
> Mounting and unmounting looks normal:
>
> May 27 17:25:23 kaszanka kernel: SGI XFS with ACLs, security
> attributes, realtime, large block/inode numbers, no debug enabled
> May 27 17:25:23 kaszanka kernel: SGI XFS Quota Management subsystem
> May 27 17:25:23 kaszanka kernel: Filesystem "md0": Disabling barriers,
> not supported by the underlying device
> May 27 17:25:23 kaszanka kernel: XFS mounting filesystem md0
> May 27 17:25:25 kaszanka kernel: Ending clean XFS mount for filesystem:=
=20=20
> md0
>
> Is there any chance of repearing that partition ?
> I've made metadump of that partition - its quite big - more than 3GB. I=
=20=20
> can
> put it somewhere if any of developers is interested.
>
> Thanks,
> Sebastian
>
>


------------NL5luSBEEB9F8pOELPD1Rz
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

------------NL5luSBEEB9F8pOELPD1Rz--
