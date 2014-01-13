Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 7A5C329DF8
	for <xfs@oss.sgi.com>; Sun, 12 Jan 2014 21:47:35 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 4E4748F804B
	for <xfs@oss.sgi.com>; Sun, 12 Jan 2014 19:47:35 -0800 (PST)
Received: from mail.uberzach.com (rondo.uberzach.com [64.22.125.169]) by
	cuda.sgi.com with ESMTP id oQc0AkdYHvsR2Jj4 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sun, 12 Jan 2014 19:47:33 -0800 (PST)
Received: from [172.19.7.2] (unknown [74.93.97.69])
	(Authenticated sender: profplump)
	by mail.uberzach.com (Postfix) with ESMTPSA id 95E4A5802B
	for <xfs@oss.sgi.com>; Sun, 12 Jan 2014 19:47:30 -0800 (PST)
From: Zachary Kotlarek <zach@kotlarek.com>
Message-Id: <E2EE0AEA-ED22-4D3B-8550-88F2ED1F8314@kotlarek.com>
Mime-Version: 1.0 (Mac OS X Mail 7.1 \(1827\))
Subject: Re: Files with non-ASCII names inaccessible after xfs_repair
Date: Sun, 12 Jan 2014 19:47:29 -0800
References: <A40DF90D-5F6B-4595-AA30-B91D8F7972D0@kotlarek.com>
	<52D2E358.6070106@hardwarefreak.com>
	<CF41F386-E86A-4745-B28D-0DAA8D3CA1DD@kotlarek.com>
	<20140113015007.GC3469@dastard>
	<EDB09149-717F-4089-9C21-1D342CF77A7D@kotlarek.com>
	<20140113031947.GG3469@dastard>
In-Reply-To: <20140113031947.GG3469@dastard>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============6155846152242668301=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com


--===============6155846152242668301==
Content-Type: multipart/signed; boundary="Apple-Mail=_7F6F628A-FC7C-40C5-9BA6-0D1497A6BAC4"; protocol="application/pkcs7-signature"; micalg=sha1


--Apple-Mail=_7F6F628A-FC7C-40C5-9BA6-0D1497A6BAC4
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=windows-1252


On Jan 12, 2014, at 7:19 PM, Dave Chinner <david@fromorbit.com> wrote:

> IOWs, xfs-repair wrote new contents to those blocks, and now the =
kernel
> cannot read them from disk.


Sure, but I don=92t understand why it would have re-written them in the =
first place. I know corruption happens, but this seems awfully =
pattern-tastic to be random errors.


> Try using xfs_db to read and parse the blocks that the fielsystem is
> choking on. If it can't read them from xfs_db, then there's
> something gone wrong below XFS. If you can read them, use xfs_db to
> parse the block as a directory block and see what the raw directory
> entries are the block contains....
>=20
> e.g.
> # xfs_db <dev>
> xfs_db> convert daddr 0x3c8ff73e0 fsb
> <fsbno>
> xfs_db> fsb <fsbno>
> xfs_db> p
> <hex output>
> xfs_db> type dir2
> xfs_db> p
> <decoded output>


Works.

xfs_db> convert daddr 0x3c8ff73e0 fsb
0x8007f67c (2148005500)
xfs_db> fsb 0x8007f67c
xfs_db> p
000: 58443242 075007d0 04600038 00b00030 00000008 007f681a 012ed556 =
11060010
020: 0000000c 80000800 022e2efe 68440020 ffff0020 007f6839 112e2e44 =
535f5374
040: 6f72652e 6b594c6b 4b32537a 78410030 00000008 007f6839 092e4453 =
5f53746f
060: 726597db 77f50050 ffff0028 007f683a 182e3031 202d2043 69747920 =
6f662e6d
080: 34762e42 3269704c 3888dfd6 05e80068 00000008 007f683a 10303120 =
2d204369
0a0: 7479206f 662e6d34 769f1dff 1b260090 ffff0030 007f683b 1e2e3032 =
202d204c
0c0: 6f6e656c 79204865 61727473 2e6d3476 2e61454e 59786913 1d7bf8ce =
8c6200b0
0e0: 00000008 007f683b 16303220 2d204c6f 6e656c79 20486561 7274732e =
6d34764a
100: 5eadac34 2b5d00e0 ffff0028 007f683c 1c2e3033 202d2049 6e207468 =
65204461
120: 726b2e6d 34762e7a 4b726254 72b50108 00000008 007f683c 14303320 =
2d20496e
140: 20746865 20446172 6b2e6d34 767b0130 ffff0030 007f683d 212e3034 =
202d2049
160: 2046616c 6c20746f 20506965 6365732e 6d34762e 6f735975 497aeb65 =
c2bb0150
180: 00000008 007f683d 19303420 2d204920 46616c6c 20746f20 50696563 =
65732e6d
1a0: 3476990e 3e560180 ffff0030 007f683e 1f2e3035 202d2052 6f6f6d20 =
77697468
1c0: 20612056 752e6d34 762e5478 72794b72 60a2e009 eef101a8 00000008 =
007f683e
1e0: 17303520 2d20526f 6f6d2077 69746820 61205675 2e6d3476 b883247d =
552901d8
200: ffff0030 007f683f 242e3036 202d2053 656e7365 20262053 656e7369 =
74697669
220: 74792e6d 34762e65 6776556e 77550200 00000008 007f683f 1c303620 =
2d205365
240: 6e736520 26205365 6e736974 69766974 792e6d34 762b0230 ffff0030 =
0129b800
260: 1f2e3037 202d2042 61636865 6c6f7220 50617274 792e6d34 762e6632 =
4e477851
280: 7d4c7797 3f600258 00000008 0129b800 17303720 2d204261 6368656c =
6f722050
2a0: 61727479 2e6d3476 4a911d34 eca00288 ffff0030 0129b801 242e3038 =
202d2049
2c0: 2057696c 6c205265 6d656d62 65722059 6f752e6d 34762e49 43687344 =
6ad002b0
2e0: 00000008 0129b801 1c303820 2d204920 57696c6c 2052656d 656d6265 =
7220596f
300: 752e6d34 76e902e0 ffff0020 0129b802 152e3039 202d2048 65726f2e =
6d34762e
320: 58467063 36790308 00000008 0129b802 0d303920 2d204865 726f2e6d =
34760328
340: ffff0030 0129b803 1e2e3130 202d2050 61727469 6e672047 69667473 =
2e6d3476
360: 2e794156 30534584 1783a6af dd270340 00000008 0129b803 16313020 =
2d205061
380: 7274696e 67204769 6674732e 6d347687 27f22157 cbc00370 ffff0028 =
0129b804
3a0: 1d2e3131 202d2053 6f6d6e61 6d62756c 6973742e 6d34762e 444d365a =
6b760398
3c0: 00000008 0129b804 15313120 2d20536f 6d6e616d 62756c69 73742e6d =
347603c0
3e0: ffff0028 0129b805 1a2e3132 202d2045 78706563 74696e67 2e6d3476 =
2e494b66
400: 6b3067c1 901903e0 00000008 0129b805 12313220 2d204578 70656374 =
696e672e
420: 6d3476db 2c390408 ffff0020 0129b806 142e3133 202d2053 68652e6d =
34762e6a
440: 4c553742 50d30428 00000008 0129b806 0c313320 2d205368 652e6d34 =
76e10448
460: ffff0038 0129b807 2b2e3134 202d2049 27766520 476f7420 596f7520 =
556e6465
480: 72204d79 20536b69 6e2e6d34 762e4d74 4a536e70 86e50460 00000008 =
0129b807
4a0: 23313420 2d204927 76652047 6f742059 6f752055 6e646572 204d7920 =
536b696e
4c0: 2e6d3476 9d510498 ffff0028 0129b808 1d2e3135 202d2054 68652050 =
726f6469
4e0: 67616c2e 6d34762e 4879314f 704c04c8 00000008 0129b808 15313520 =
2d205468
500: 65205072 6f646967 616c2e6d 347604f0 ffff0028 0129b809 192e3136 =
202d2054
520: 68652052 696e672e 6d34762e 43764467 375aa0d3 c99e0510 00000008 =
0129b809
540: 11313620 2d205468 65205269 6e672e6d 3476181c c7aa0538 ffff0028 =
0129b80a
560: 192e3137 202d2045 7465726e 6974792e 6d34762e 48707449 625a34be =
fb360558
580: 00000008 0129b80a 11313720 2d204574 65726e69 74792e6d 3476cafa =
1f2a0580
5a0: ffff0028 0129b80b 1d2e3138 202d2046 69766520 62792046 6976652e =
6d34762e
5c0: 4d376f4b 703005a0 00000008 0129b80b 15313820 2d204669 76652062 =
79204669
5e0: 76652e6d 347605c8 ffff0028 0129b80c 1a2e3139 202d2053 616e6374 =
75617279
600: 2e6d3476 2e6a4b4c 514d4f4f 197a05e8 00000008 0129b80c 12313920 =
2d205361
620: 6e637475 6172792e 6d347638 4cbd0610 ffff0028 0129b80d 192e3230 =
202d2057
640: 6172205a 6f6e652e 6d34762e 45654333 39468f41 69da0630 00000008 =
0129b80d
660: 11323020 2d205761 72205a6f 6e652e6d 347627e8 12e20658 ffff0028 =
0129b80e
680: 1b2e3231 202d2042 6c696e64 20446174 652e6d34 762e3176 42307637 =
94160678
6a0: 00000008 0129b80e 13323120 2d20426c 696e6420 44617465 2e6d3476 =
0ec306a0
6c0: ffff0030 0129b80f 232e3232 202d2054 6f205368 616e7368 7520696e =
204c2e41
6e0: 2e2e6d34 762e796b 35673178 b54306c0 00000008 0129b80f 1b323220 =
2d20546f
700: 20536861 6e736875 20696e20 4c2e412e 2e6d3476 288c06f0 ffff0020 =
0129b810
720: 132e7365 61736f6e 5f646f6e 652e6e43 616a3843 95690718 00000008 =
0129b810
740: 0b736561 736f6e5f 646f6e65 e16d0738 ffff07d0 f9ea06ea d5e36984 =
08dfaf37
760: 839b1911 0eb746af fcddf06e 0f80efea 2026141f 2745eb43 576864b0 =
9ed2d367
780: 6416bfd5 fd3fbe54 e92297c6 c270efcc 92bcd97f a65c797c 183f55ef =
34a9a3c0
7a0: c8baae28 6ec2437e a1893396 953d1142 caa8f097 7bf24092 41761bd6 =
b0c9476f
7c0: 49feafe8 27befa39 337839fe 6cb36a71 02271bae efc1dd71 feb52c4b =
86812ed3
7e0: 8796047e 0c56fca7 41e50a83 08caab90 44e09c44 128a8deb 53f0eeab =
53b77cfb
800: 81ed5efa a63df170 1f7f1141 a5d3c9cf 396814b6 4e9e25fe 02bb6dec =
a53ad8d4
820: d0821508 4e9db912 93763d78 a8168589 03038a08 e0ca0726 7cd14047 =
5955481a
840: c4790009 219669b5 245a03a7 4432c8d7 75d11951 cf50c217 92c7ba29 =
6c0550e0
860: e62af66c be6f982d 10f973c9 eff4247a af474e28 596e66cf c4784950 =
4b8b2920
880: d1a86479 3bb122ce e7725d4f edcfd24e 873697d6 a32aa37a 50efecd4 =
5865ea8d
8a0: 2ab983d6 f7b5f8e9 1dd7da5c 25163ec5 f739efbb 1802ebee 130eedd2 =
acbe5057
8c0: 657a9441 e45944ec 81fccc2e fb195d01 08e27602 8c05d317 192d287e =
1f6b6b44
8e0: 0ea3dac4 47a2220c 9bd0c05e d19f0084 9d29c842 2329ef6d ee5f1243 =
c888b2d7
900: 72684d4d 2480de9e 17d89b6e 94d1ae56 a6801086 2606f081 16fa1c53 =
33d31265
920: e981b683 334e4852 7333fb71 b6a61d88 214c8e96 9951983f e274c5cf =
0df673b9
940: 2504e588 92166468 c6c797a1 8f5f19a1 3c361256 8d82a685 cc9ef823 =
ce5c1bf8
960: 1079cc0c 17a734c1 20827061 c411c62c 061cefd0 9c859dee 4a9f4054 =
871d4aaa
980: ba6f826f b04c7af4 04bad6d3 a496781a ebfe246f 8ebc0b06 159d8229 =
aebae34a
9a0: c6b2ade4 33464523 11f48dce 57012621 d78c8057 1d1f46f4 2a18a7f5 =
154ee854
9c0: e26663de ce93d67e 1ebb438a 3a5e7676 a3a23975 3e230af3 675493ca =
0c037437
9e0: 4b616411 0957bc98 d6a4e884 3e6cbc40 8d73ff32 70511f83 63412623 =
97c86e08
a00: aa4a81ec f63eb667 cc9d08d9 ad5587d3 bd633843 8bdc0dd5 082278c6 =
51a0bfcb
a20: 516674cf 1a21edcf d637719e c0c2611a 3b704840 187e86bd 1588453c =
e0dce6c2
a40: 72a96f83 80d9c4eb eb8cf0dc aa446e69 d52ebf6a 05f72c6f a699c103 =
0c9815d1
a60: 970a51cc d6624f7a d15b82bc 8d3e9dad 3faa9538 27def54a 028922fc =
38286c39
a80: 71c7a014 e0eded3a 0a690907 7388c60b c6b67887 6b902d4e 21ca8aeb =
7a4c5f65
aa0: 765eadca e2659fce 83f3c782 d52eb4b3 80d14192 96370abe 877069d8 =
fb3556ca
ac0: f3e9c2ad 8b8feaf2 40d369f7 7e47554e 66702687 b3111b33 e5ad2674 =
5688172c
ae0: 3a3a0fd1 8423c871 edf5ffab fd8a4b5c 2f01203f 450a34d1 fdb3f703 =
812a7acd
b00: f46e1c28 de90fa2a ec07adfc 9609447f 958c5b2a b0ed662f 0d8deba4 =
c2435873
b20: 16a9b9f6 6fa8663c 44027b36 985464c4 efac6073 28dbc000 79e617e9 =
a10f883a
b40: 4b44c78f 55ab9384 187180c5 2db10f43 b0d9a0fe c1bc615f 052b89a7 =
89f8739a
b60: e51b96c9 8a76ea67 6fbf1ba5 077d2a08 3dad2b88 e17d6c4e 6a553913 =
2c6fa5d1
b80: 2b6bf4bc 01c82612 1ebd3150 290dab97 b2fa8a81 1d29d75f a13a2c5e =
74944ff6
ba0: a1530f5f 79426a7d d491c2f0 f93639aa 1f67ae3c 8274b8a8 b4b79706 =
3539bde3
bc0: 7be2d58c 49875f20 cc314f03 33aaef61 cda9405d ff044415 fd150822 =
faa4f257
be0: d4ed221a 5d5a8ce4 200e2e9c 96fccaad 4bba9f8b 253448a1 2de101f9 =
4916a536
c00: 725f39cc b7aaab5a 5c76965b e4009b17 0e0d53e4 d40d169b d4028a52 =
116ce300
c20: f2b43ec9 ef7bf8fe dc9a0b18 18b33c79 5d7d17ff d4db5b05 5e78ddbe =
15b21957
c40: 0cc1085b 2bb4784f 7ed53bb0 75b0f0b0 556d9dc1 59a25bca 39360281 =
496b7e29
c60: 057cdf54 d6bd1f0c 53d799a7 5546023d c4705471 ae45c65b 6293ef94 =
6d691cc3
c80: a639d85c e30a2c1b 55f8c1ea 2039f040 e7cee649 610e07cc d54727ce =
69e1106d
ca0: 009d124c c4549462 bce84f03 cffd7cb2 15f84246 9f07d1cf 0868c871 =
911061d9
cc0: 6e46283e 3a27cab5 f9cb1ca9 54699f02 998fd95e 264df0ef 569c1493 =
fe01fd0a
ce0: eff15169 34bd36cc b5dc5191 ef90312d 65ae1a21 349ce3f1 cbe326ae =
cc0bb2a7
d00: 1bfa7b64 a220c6a6 4082321c f9941053 ea9dc196 cff261d0 5874801f =
6b2924b6
d20: 86dce448 532071af f4d7f789 c7eb7853 27a6e68c e1bfd039 0c7edc86 =
58cf2529
d40: 1b018742 3634a552 9349bf37 4052e265 a39e4c76 9f82e539 7e04a1d0 =
25b2c962
d60: af93a551 99ebcd67 36371b9f 653dc4d5 64082e7b 5418806e 0a1f520b =
c3760072
d80: eafc4c5a acebbcef 0001e2c5 0e60368a 58291704 cb6f1135 57e8bd7f =
aac906db
da0: df3d7989 f1036a7f 654b967e 633953db a05e60b4 fd5f48e2 867275a4 =
040f0928
dc0: ed385b29 bf0b2d96 eef904bc 9b695030 3cadcc76 ad48c64a f44c7350 =
b5087bda
de0: 23162a13 9326ada9 40982285 90862b55 ce7e1b1e 032a1b80 fc6a38b1 =
e3366816
e00: 2f64457a 250baa07 073a83f5 cde75e52 2b6a288e bc579c34 c3be59f9 =
c692e1cb
e20: 12c6452f a869827c b2eeeaf9 f61ca991 45625e17 f1eb5b64 cc56633b =
aad11127
e40: 7efa415e 4e63c788 1e53815a 9a3deed8 164c95f4 0e8c08e6 1f491f9a =
674d8896
e60: 2a658a0c 3869bb6d 7ce3df75 141daf64 d0118632 5e770c85 43a05783 =
b8dca76e
e80: 7f400acf 65cb07a4 f79b2e57 76c9132c eb0c2466 4f2c3785 37359252 =
86fc1e04
ea0: cbce2311 b62986ad 632365c3 38f2d301 979cbb61 cd10b57a bce9f49e =
d475721a
ec0: 4b66eaae 6b0d7314 7076c4d1 424dd11e ba955554 db9fbd69 a28407e0 =
2b86a30d
ee0: 3680f9fc e58c9607 4077e015 a58184a3 56eace9e 9f124bb5 944a1b3c =
897ad88d
f00: c2545a63 74d9659d d5af8264 4399a397 68d0a8c7 f7f59cb5 faf8f9db =
133b0750
f20: 0000002e 00000002 0000172e 00000004 0d3b2e62 000000b0 1052379a =
0000000a
f40: 15fe1de6 00000000 1d7c54e2 000000e7 1da526c4 0000009e 1f127df8 =
000000cb
f60: 2f384255 0000001c 3b0eaf4a 00000051 4040055a 00000046 484d370f =
00000078
f80: 54f0b050 0000005c 55e13fd3 000000b9 560de5f6 00000065 68b5d9ab =
00000093
fa0: 789cb9e0 00000089 7eb5a6e5 000000c2 88dfa187 00000081 8aa13ee8 =
0000003b
fc0: 93fda139 00000012 a56edfc1 0000006e b7310079 00000026 bf010bb3 =
000000a7
fe0: e956d990 00000030 f909f282 000000de fb7fbced 000000d4 0000001b =
00000001
xfs_db> type dir2
xfs_db> p
bhdr.magic =3D 0x58443242
bhdr.bestfree[0].offset =3D 0x750
bhdr.bestfree[0].length =3D 0x7d0
bhdr.bestfree[1].offset =3D 0x460
bhdr.bestfree[1].length =3D 0x38
bhdr.bestfree[2].offset =3D 0xb0
bhdr.bestfree[2].length =3D 0x30
bu[0].inumber =3D 34368088090
bu[0].namelen =3D 1
bu[0].name =3D "."
bu[0].tag =3D 0x10
bu[1].inumber =3D 53687093248
bu[1].namelen =3D 2
bu[1].name =3D ".."
bu[1].tag =3D 0x20
bu[2].freetag =3D 0xffff
bu[2].length =3D 0x20
bu[2].tag =3D 0x30
bu[3].inumber =3D 34368088121
bu[3].namelen =3D 9
bu[3].name =3D ".DS_Store"
bu[3].tag =3D 0x50
bu[4].freetag =3D 0xffff
bu[4].length =3D 0x28
bu[4].tag =3D 0x68
bu[5].inumber =3D 34368088122
bu[5].namelen =3D 16
bu[5].name =3D "01 - City of.m4v"
bu[5].tag =3D 0x90
bu[6].freetag =3D 0xffff
bu[6].length =3D 0x30
bu[6].tag =3D 0xb0
bu[7].inumber =3D 34368088123
bu[7].namelen =3D 22
bu[7].name =3D "02 - Lonely Hearts.m4v"
bu[7].tag =3D 0xe0
bu[8].freetag =3D 0xffff
bu[8].length =3D 0x28
bu[8].tag =3D 0x108
bu[9].inumber =3D 34368088124
bu[9].namelen =3D 20
bu[9].name =3D "03 - In the Dark.m4v"
bu[9].tag =3D 0x130
bu[10].freetag =3D 0xffff
bu[10].length =3D 0x30
bu[10].tag =3D 0x150
bu[11].inumber =3D 34368088125
bu[11].namelen =3D 25
bu[11].name =3D "04 - I Fall to Pieces.m4v"
bu[11].tag =3D 0x180
bu[12].freetag =3D 0xffff
bu[12].length =3D 0x30
bu[12].tag =3D 0x1a8
bu[13].inumber =3D 34368088126
bu[13].namelen =3D 23
bu[13].name =3D "05 - Room with a Vu.m4v"
bu[13].tag =3D 0x1d8
bu[14].freetag =3D 0xffff
bu[14].length =3D 0x30
bu[14].tag =3D 0x200
bu[15].inumber =3D 34368088127
bu[15].namelen =3D 28
bu[15].name =3D "06 - Sense & Sensitivity.m4v"
bu[15].tag =3D 0x230
bu[16].freetag =3D 0xffff
bu[16].length =3D 0x30
bu[16].tag =3D 0x258
bu[17].inumber =3D 34379249664
bu[17].namelen =3D 23
bu[17].name =3D "07 - Bachelor Party.m4v"
bu[17].tag =3D 0x288
bu[18].freetag =3D 0xffff
bu[18].length =3D 0x30
bu[18].tag =3D 0x2b0
bu[19].inumber =3D 34379249665
bu[19].namelen =3D 28
bu[19].name =3D "08 - I Will Remember You.m4v"
bu[19].tag =3D 0x2e0
bu[20].freetag =3D 0xffff
bu[20].length =3D 0x20
bu[20].tag =3D 0x308
bu[21].inumber =3D 34379249666
bu[21].namelen =3D 13
bu[21].name =3D "09 - Hero.m4v"
bu[21].tag =3D 0x328
bu[22].freetag =3D 0xffff
bu[22].length =3D 0x30
bu[22].tag =3D 0x340
bu[23].inumber =3D 34379249667
bu[23].namelen =3D 22
bu[23].name =3D "10 - Parting Gifts.m4v"
bu[23].tag =3D 0x370
bu[24].freetag =3D 0xffff
bu[24].length =3D 0x28
bu[24].tag =3D 0x398
bu[25].inumber =3D 34379249668
bu[25].namelen =3D 21
bu[25].name =3D "11 - Somnambulist.m4v"
bu[25].tag =3D 0x3c0
bu[26].freetag =3D 0xffff
bu[26].length =3D 0x28
bu[26].tag =3D 0x3e0
bu[27].inumber =3D 34379249669
bu[27].namelen =3D 18
bu[27].name =3D "12 - Expecting.m4v"
bu[27].tag =3D 0x408
bu[28].freetag =3D 0xffff
bu[28].length =3D 0x20
bu[28].tag =3D 0x428
bu[29].inumber =3D 34379249670
bu[29].namelen =3D 12
bu[29].name =3D "13 - She.m4v"
bu[29].tag =3D 0x448
bu[30].freetag =3D 0xffff
bu[30].length =3D 0x38
bu[30].tag =3D 0x460
bu[31].inumber =3D 34379249671
bu[31].namelen =3D 35
bu[31].name =3D "14 - I\'ve Got You Under My Skin.m4v"
bu[31].tag =3D 0x498
bu[32].freetag =3D 0xffff
bu[32].length =3D 0x28
bu[32].tag =3D 0x4c8
bu[33].inumber =3D 34379249672
bu[33].namelen =3D 21
bu[33].name =3D "15 - The Prodigal.m4v"
bu[33].tag =3D 0x4f0
bu[34].freetag =3D 0xffff
bu[34].length =3D 0x28
bu[34].tag =3D 0x510
bu[35].inumber =3D 34379249673
bu[35].namelen =3D 17
bu[35].name =3D "16 - The Ring.m4v"
bu[35].tag =3D 0x538
bu[36].freetag =3D 0xffff
bu[36].length =3D 0x28
bu[36].tag =3D 0x558
bu[37].inumber =3D 34379249674
bu[37].namelen =3D 17
bu[37].name =3D "17 - Eternity.m4v"
bu[37].tag =3D 0x580
bu[38].freetag =3D 0xffff
bu[38].length =3D 0x28
bu[38].tag =3D 0x5a0
bu[39].inumber =3D 34379249675
bu[39].namelen =3D 21
bu[39].name =3D "18 - Five by Five.m4v"
bu[39].tag =3D 0x5c8
bu[40].freetag =3D 0xffff
bu[40].length =3D 0x28
bu[40].tag =3D 0x5e8
bu[41].inumber =3D 34379249676
bu[41].namelen =3D 18
bu[41].name =3D "19 - Sanctuary.m4v"
bu[41].tag =3D 0x610
bu[42].freetag =3D 0xffff
bu[42].length =3D 0x28
bu[42].tag =3D 0x630
bu[43].inumber =3D 34379249677
bu[43].namelen =3D 17
bu[43].name =3D "20 - War Zone.m4v"
bu[43].tag =3D 0x658
bu[44].freetag =3D 0xffff
bu[44].length =3D 0x28
bu[44].tag =3D 0x678
bu[45].inumber =3D 34379249678
bu[45].namelen =3D 19
bu[45].name =3D "21 - Blind Date.m4v"
bu[45].tag =3D 0x6a0
bu[46].freetag =3D 0xffff
bu[46].length =3D 0x30
bu[46].tag =3D 0x6c0
bu[47].inumber =3D 34379249679
bu[47].namelen =3D 27
bu[47].name =3D "22 - To Shanshu in L.A..m4v"
bu[47].tag =3D 0x6f0
bu[48].freetag =3D 0xffff
bu[48].length =3D 0x20
bu[48].tag =3D 0x718
bu[49].inumber =3D 34379249680
bu[49].namelen =3D 11
bu[49].name =3D "season_done"
bu[49].tag =3D 0x738
bu[50].freetag =3D 0xffff
bu[50].length =3D 0x7d0
bu[50].tag =3D 0x750
bleaf[0].hashval =3D 0x2e
bleaf[0].address =3D 0x2
bleaf[1].hashval =3D 0x172e
bleaf[1].address =3D 0x4
bleaf[2].hashval =3D 0xd3b2e62
bleaf[2].address =3D 0xb0
bleaf[3].hashval =3D 0x1052379a
bleaf[3].address =3D 0xa
bleaf[4].hashval =3D 0x15fe1de6
bleaf[4].address =3D 0
bleaf[5].hashval =3D 0x1d7c54e2
bleaf[5].address =3D 0xe7
bleaf[6].hashval =3D 0x1da526c4
bleaf[6].address =3D 0x9e
bleaf[7].hashval =3D 0x1f127df8
bleaf[7].address =3D 0xcb
bleaf[8].hashval =3D 0x2f384255
bleaf[8].address =3D 0x1c
bleaf[9].hashval =3D 0x3b0eaf4a
bleaf[9].address =3D 0x51
bleaf[10].hashval =3D 0x4040055a
bleaf[10].address =3D 0x46
bleaf[11].hashval =3D 0x484d370f
bleaf[11].address =3D 0x78
bleaf[12].hashval =3D 0x54f0b050
bleaf[12].address =3D 0x5c
bleaf[13].hashval =3D 0x55e13fd3
bleaf[13].address =3D 0xb9
bleaf[14].hashval =3D 0x560de5f6
bleaf[14].address =3D 0x65
bleaf[15].hashval =3D 0x68b5d9ab
bleaf[15].address =3D 0x93
bleaf[16].hashval =3D 0x789cb9e0
bleaf[16].address =3D 0x89
bleaf[17].hashval =3D 0x7eb5a6e5
bleaf[17].address =3D 0xc2
bleaf[18].hashval =3D 0x88dfa187
bleaf[18].address =3D 0x81
bleaf[19].hashval =3D 0x8aa13ee8
bleaf[19].address =3D 0x3b
bleaf[20].hashval =3D 0x93fda139
bleaf[20].address =3D 0x12
bleaf[21].hashval =3D 0xa56edfc1
bleaf[21].address =3D 0x6e
bleaf[22].hashval =3D 0xb7310079
bleaf[22].address =3D 0x26
bleaf[23].hashval =3D 0xbf010bb3
bleaf[23].address =3D 0xa7
bleaf[24].hashval =3D 0xe956d990
bleaf[24].address =3D 0x30
bleaf[25].hashval =3D 0xf909f282
bleaf[25].address =3D 0xde
bleaf[26].hashval =3D 0xfb7fbced
bleaf[26].address =3D 0xd4
btail.count =3D 27
btail.stale =3D 1


Based on the file names that=92s this, unaffected directory:

vera /mnt/media/TV/Angel 0$ ls Season\ 1
01 - City of.m4v              07 - Bachelor Party.m4v       13 - She.m4v =
                        19 - Sanctuary.m4v
02 - Lonely Hearts.m4v        08 - I Will Remember You.m4v  14 - I've =
Got You Under My Skin.m4v  20 - War Zone.m4v
03 - In the Dark.m4v          09 - Hero.m4v                 15 - The =
Prodigal.m4v                21 - Blind Date.m4v
04 - I Fall to Pieces.m4v     10 - Parting Gifts.m4v        16 - The =
Ring.m4v                    22 - To Shanshu in L.A..m4v
05 - Room with a Vu.m4v       11 - Somnambulist.m4v         17 - =
Eternity.m4v                    season_done
06 - Sense & Sensitivity.m4v  12 - Expecting.m4v            18 - Five by =
Five.m4v

I md5sum=92d all those files against the last backup =97 they all seem =
fine, and listing and opening those files does not produce any kernel =
messages.

I tried a couple other addresses from the logs and got similar results =97=
 they all worked fine and were not related to the inaccessible paths.


> Hmmmm - you're not using LVM snapshots or anything like that are
> you?


No. Just a vanilla: `lvcreate -L 16T -n tv /dev/lvmsas`

And the filesystem has had very little activity since creation =97 I =
filed it from using rsync (converting from JFS after hitting the 32 TB =
limit on that filesystem) and 99% of the files are marked immutable.

	Zach


--Apple-Mail=_7F6F628A-FC7C-40C5-9BA6-0D1497A6BAC4
Content-Disposition: attachment;
	filename=smime.p7s
Content-Type: application/pkcs7-signature;
	name=smime.p7s
Content-Transfer-Encoding: base64

MIAGCSqGSIb3DQEHAqCAMIACAQExCzAJBgUrDgMCGgUAMIAGCSqGSIb3DQEHAQAAoIIGGTCCBhUw
ggP9oAMCAQICAQEwDQYJKoZIhvcNAQEFBQAwgYsxCzAJBgNVBAYTAlVTMRMwEQYDVQQIDApXYXNo
aW5ndG9uMRAwDgYDVQQHDAdTZWF0dGxlMRwwGgYDVQQKDBNaYWNoYXJ5IFAuIEtvdGxhcmVrMRUw
EwYDVQQDDAx1YmVyemFjaC5jb20xIDAeBgkqhkiG9w0BCQEWEXphY2hAa290bGFyZWsuY29tMB4X
DTEzMDgxMzAwMjMzM1oXDTE4MDgxMjAwMjMzM1owgZIxCzAJBgNVBAYTAlVTMRMwEQYDVQQIDApX
YXNoaW5ndG9uMRAwDgYDVQQHDAdTZWF0dGxlMRwwGgYDVQQKDBNaYWNoYXJ5IFAuIEtvdGxhcmVr
MRwwGgYDVQQDDBNaYWNoYXJ5IFAuIEtvdGxhcmVrMSAwHgYJKoZIhvcNAQkBFhF6YWNoQGtvdGxh
cmVrLmNvbTCCAiIwDQYJKoZIhvcNAQEBBQADggIPADCCAgoCggIBANL424NB+EzPp7/CqB/kxV+u
7MSpl9A8NlMqLldoPPJjpEwH9+4wfYrx+yUOBddih4WIgCD9NiF41+9tHu9gUqm+PZT8kdGXUIRP
fuQuwKyzAv0rSyydXBQD/Q/gRrFaEJvJ5wVUxgE51K/ugGATmyWTSeMwATOJR4qTs1u2dfxBliyR
xc2LCJCAgvuonwhfP1JprFYz+ycmlb/od3cAC5+8ggof5YJiitsUM6FPQtDykGPNWxhFnBwrVlQ+
vAxA1aT2v33C4MMK3hY3Ik8BUCZrAr4r/eWDSCBmcQydoawrUllAzEsVuozYqOW+EwbFp9RFDAZZ
UZH/pMSEK5v2yQcf2m3zx4+9S5fLbvX660DFY90C1GSt9MyDjfpgx+Mtx7RtJI2abcei2PEXt38p
U2aLypsHWsdloWhouzM4JpTkDXqCyUOm5hkUPgMdOXKHY5jCj0e7ok/Rknty7fJjolo4uyOKfJHQ
cjoU1xuzA8ob0i8zufIL03FUK72dWL7xyAGjRs4Hsa6xd/SbPYGvYHJ2afxLeTDPZwzrLErxn9no
E0wkAPnV0MfYbB+0Y/+Xaa2KIUflawzh3iQVkohrzmE9PU3gjiQJ9UqYtvx8HrUK2eEjCRinnSd5
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
tLf+HrOmvQAAAAAAAA==

--Apple-Mail=_7F6F628A-FC7C-40C5-9BA6-0D1497A6BAC4--


--===============6155846152242668301==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============6155846152242668301==--
