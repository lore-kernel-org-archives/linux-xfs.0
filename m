Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 713127F3F
	for <xfs@oss.sgi.com>; Mon, 13 Jan 2014 17:07:44 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 28EC38F8054
	for <xfs@oss.sgi.com>; Mon, 13 Jan 2014 15:07:41 -0800 (PST)
Received: from mail.uberzach.com (rondo.uberzach.com [64.22.125.169]) by
	cuda.sgi.com with ESMTP id NCBQWL7kL83RI1qT (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 13 Jan 2014 15:07:38 -0800 (PST)
Received: from [172.19.7.2] (unknown [74.93.97.69])
	(Authenticated sender: profplump)
	by mail.uberzach.com (Postfix) with ESMTPSA id 3CFEE580B1
	for <xfs@oss.sgi.com>; Mon, 13 Jan 2014 15:07:34 -0800 (PST)
From: Zachary Kotlarek <zach@kotlarek.com>
Message-Id: <0E45339E-04C4-4775-B6B0-FC55245B0AED@kotlarek.com>
Mime-Version: 1.0 (Mac OS X Mail 7.1 \(1827\))
Subject: Re: Files with non-ASCII names inaccessible after xfs_repair
Date: Mon, 13 Jan 2014 15:07:30 -0800
References: <A40DF90D-5F6B-4595-AA30-B91D8F7972D0@kotlarek.com>
	<52D2E358.6070106@hardwarefreak.com>
	<CF41F386-E86A-4745-B28D-0DAA8D3CA1DD@kotlarek.com>
	<20140113015007.GC3469@dastard>
	<EDB09149-717F-4089-9C21-1D342CF77A7D@kotlarek.com>
	<20140113031947.GG3469@dastard>
	<E2EE0AEA-ED22-4D3B-8550-88F2ED1F8314@kotlarek.com>
	<20140113192732.GI3469@dastard>
In-Reply-To: <20140113192732.GI3469@dastard>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============2116881571951036072=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com


--===============2116881571951036072==
Content-Type: multipart/signed; boundary="Apple-Mail=_1C27DD97-FFE9-4267-B4A6-3F4124BF0FAF"; protocol="application/pkcs7-signature"; micalg=sha1


--Apple-Mail=_1C27DD97-FFE9-4267-B4A6-3F4124BF0FAF
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=windows-1252


On Jan 13, 2014, at 11:27 AM, Dave Chinner <david@fromorbit.com> wrote:

> So, you need to find the inode number of a directory with a corrupt
> entry, and dump the inode and any data fork blocks that it belongs
> to with xfs_db similar to what you have just done.=20


Got one. bu[9] is the file that doesn=92t work:

xfs_db /dev/lvmsas/tv
xfs_db> inode 68719478806
xfs_db> p
core.magic =3D 0x494e
...
u.bmx[0] =3D [startoff,startblock,blockcount,extentflag] =
0:[0,4294967423,1,0]
a.bmx[0] =3D [startoff,startblock,blockcount,extentflag] =
0:[0,4294967537,1,0]
xfs_db> fsb 4294967423
xfs_db> p
000: 58443242 03980b88 00000000 00000000 00000010 00000816 012ee69d =
215c0010
020: 00000002 00000800 022e2ea2 1dc60020 00000010 00000817 092e4453 =
5f53746f
040: 7265652e 726f0030 00000010 00000818 10303120 2d20446f 2d4f7665 =
722e6d34
060: 76657b54 75e80048 00000010 00000819 1d303220 2d204265 6c696576 =
6520696e
080: 20746865 20537461 72732e6d 34760068 00000010 0000081a 2d303320 =
2d205468
0a0: 65204f6e 65207769 74682074 68652043 61737420 6f66204e 69676874 =
20436f75
0c0: 72742e6d 34760090 00000010 0000081b 15303420 2d204761 76696e20 =
566f6c75
0e0: 72652e6d 347600c8 00000010 0000081c 10303520 2d205265 756e696f =
6e2e6d34
100: 76732e6d 347600e8 00000010 0000081d 1a303620 2d204368 72697374 =
6d617320
120: 53706563 69616c2e 6d347674 206f0108 00000010 0000081e 1a303720 =
2d205365
140: c3b16f72 204d6163 686f2053 6f6c6f2e 6d347620 2d200130 00000010 =
0000081f
160: 11303820 2d20466c 75205368 6f742e6d 34766874 20430158 00000010 =
00000820
180: 20303920 2d205265 74726561 7420746f 204d6f76 6520466f 72776172 =
642e6d34
1a0: 76414e79 46490178 00000010 00000821 16313020 2d204765 6e657261 =
6c697373
1c0: 696d6f2e 6d3476a8 ffff0028 000001a8 00000010 00000822 1c313120 =
2d205374
1e0: 2e205661 6c656e74 696e6527 73204461 792e6d34 760001d0 00000010 =
00000823
200: 13313220 2d204c61 72727920 4b696e67 2e6d3476 000001f8 00000010 =
00000824
220: 1b313320 2d20476f 6f646279 652c204d 79204672 69656e64 2e6d3476 =
0add0218
240: 00000010 00000825 16313420 2d205468 65204675 6e636f6f 6b65722e =
6d34762e
260: 6d34763a 84810240 00000010 00000826 13313520 2d205468 65204275 =
62626c65
280: 2e6d3476 536f0268 00000010 00000827 17313620 2d204170 6f6c6c6f =
2c204170
2a0: 6f6c6c6f 2e6d3476 c3b16f72 204d0288 00000010 00000828 11313720 =
2d204375
2c0: 74626163 6b732e6d 34763038 202d02b0 00000010 00000829 1a313820 =
2d204a61
2e0: 636b6965 204a6f72 6d702d4a 6f6d702e 6d347620 2d2002d0 00000010 =
0000082a
300: 11313920 2d205468 65204f6e 65732e6d 34763039 202d02f8 00000010 =
0000082b
320: 1a323020 2d205468 65204e61 74757261 6c204f72 6465722e 6d34767b =
44850318
340: 00000010 0000082c 12323120 2d204d61 6d6d6120 4d69612e 6d347676 =
65200340
360: 00000010 0000082d 14323220 2d204b69 646e6579 204e6f77 212e6d34 =
762d0360
380: 00000010 0000082e 0b736561 736f6e5f 646f6e65 48460380 ffff0b88 =
00000e4f
3a0: 1a303720 2d205365 c3b16f72 204d6163 686f2053 6f6c6f2e 6d34762e =
6d340398
3c0: ffff0b60 b9ea03a0 ffff0030 00000822 242e3131 202d2053 742e2056 =
616c656e
3e0: 74696e65 27732044 61792e6d 34762e75 384d554e 6c0a03c8 00000010 =
00000822
400: 1c313120 2d205374 2e205661 6c656e74 696e6527 73204461 792e6d34 =
766c03f8
420: ffff0028 00000823 1b2e3132 202d204c 61727279 204b696e 672e6d34 =
762e6a65
440: 6d346167 ae670420 00000010 00000823 13313220 2d204c61 72727920 =
4b696e67
460: 2e6d3476 c5cd0448 ffff0030 00000824 232e3133 202d2047 6f6f6462 =
79652c20
480: 4d792046 7269656e 642e6d34 762e697a 48574e66 6ebe0468 00000010 =
00000824
4a0: 1b313320 2d20476f 6f646279 652c204d 79204672 69656e64 2e6d3476 =
06550498
4c0: ffff0030 00000825 1e2e3134 202d2054 68652046 756e636f 6f6b6572 =
2e6d3476
4e0: 2e546c46 37754e82 53830dea f02904c0 00000010 00000825 16313420 =
2d205468
500: 65204675 6e636f6f 6b65722e 6d3476c9 49d6c27e 862404f0 ffff0028 =
00000826
520: 1b2e3135 202d2054 68652042 7562626c 652e6d34 762e324e 756d6a55 =
3e2e0518
540: 00000010 00000826 13313520 2d205468 65204275 62626c65 2e6d3476 =
b8190540
560: ffff0030 00000827 1f2e3136 202d2041 706f6c6c 6f2c2041 706f6c6c =
6f2e6d34
580: 762e7862 706b7578 6015c501 5df00560 00000010 00000827 17313620 =
2d204170
5a0: 6f6c6c6f 2c204170 6f6c6c6f 2e6d3476 207a805c 32f30590 ffff0028 =
00000828
5c0: 192e3137 202d2043 75746261 636b732e 6d34762e 38644241 4e4e95d2 =
df0c05b8
5e0: 00000010 00000828 11313720 2d204375 74626163 6b732e6d 3476bfa5 =
5c2d05e0
600: ffff0030 00000829 222e3138 202d204a 61636b69 65204a6f 726d702d =
4a6f6d70
620: 2e6d3476 2e463654 536e4750 ed990600 00000010 00000829 1a313820 =
2d204a61
640: 636b6965 204a6f72 6d702d4a 6f6d702e 6d3476b3 568f0630 ffff0028 =
0000082a
660: 192e3139 202d2054 6865204f 6e65732e 6d34762e 5359636f 536c1450 =
7d780658
680: 00000010 0000082a 11313920 2d205468 65204f6e 65732e6d 347633f1 =
b79c0680
6a0: ffff0030 0000082b 222e3230 202d2054 6865204e 61747572 616c204f =
72646572
6c0: 2e6d3476 2e4c7779 456e7607 1acd06a0 00000010 0000082b 1a323020 =
2d205468
6e0: 65204e61 74757261 6c204f72 6465722e 6d347620 6ac406d0 ffff0028 =
0000082c
700: 1a2e3231 202d204d 616d6d61 204d6961 2e6d3476 2e793774 444471f0 =
7afb06f8
720: 00000010 0000082c 12323120 2d204d61 6d6d6120 4d69612e 6d34764a =
c2a20720
740: ffff0028 0000082d 1c2e3232 202d204b 69646e65 79204e6f 77212e6d =
34762e31
760: 70556e4a 516d0740 00000010 0000082d 14323220 2d204b69 646e6579 =
204e6f77
780: 212e6d34 76ec0768 ffff0020 0000082e 132e7365 61736f6e 5f646f6e =
652e5942
7a0: 45707653 4b1b0788 00000010 0000082e 0b736561 736f6e5f 646f6e65 =
dc4e07a8
7c0: ffff0760 e25dfdec 236bc146 04c68637 7ab5e375 e452f5b4 aa68bbe2 =
e8f96e8c
7e0: 2873dc2b 8c11d44f 8102132b cd297ee7 96731e39 9ce20e24 8c720b52 =
9d268801
800: 6f35094c 840bffb0 ea57f284 4ed0ddce c5fe47bc b716c676 5dcf744d =
6e1e043c
820: 65168783 12942365 473c4dd6 87b983ff b27554b6 ced9b37b 73a45143 =
953cfd5d
840: 776b8ce5 02b22034 12e3976a bf8ac0cf 6040f314 29a94c5d 1f64d68b =
41522fae
860: 5d086649 b415c9bc 5033532f 67d82e68 aba29045 99d66c7d 7d27a726 =
2461fab8
880: 62ffcb2d 2aae50f0 8a14c75e fb120b7c 30a35fde a44fb8ef 50e8ba97 =
87cd173f
8a0: 665fa3fb 068b30b0 2eb54bda 500c30e3 0f32a030 3bc1e136 371908be =
03be9608
8c0: 08931d14 19edb458 611be149 e69eab30 80885c83 ce31770c ef30d08f =
047edd2b
8e0: 881cd519 7a01e6e4 6bda3ab0 007b9eeb c406b0bd bdaa3634 e6ad67e4 =
1a0cb40a
900: ee3f89b3 18361c80 bab39b25 765b2eeb dcdae533 632b1eaa 527169da =
0808768c
920: 059a6327 60bfb867 64e6dfd1 c4790448 521e8b10 599e93ca 7ac96307 =
152793d1
940: 35e8539e 31c0a2ac b21c7fef b9c4b292 e76ea63d 2f5f4789 e996ba68 =
fc1f648a
960: f50cb772 6daa9cf9 29f49bc0 99450bdc e675a924 cd5df975 bbef5aca =
6f7f6dda
980: e3cf4905 d362fabe ca2f55ac 416055f8 c4478efe 76af424f 1246495b =
0681f743
9a0: 8985d4a8 c3bd705f b7fdad96 11e865b8 9d47709c 949269b7 171ba67c =
c0ecc834
9c0: 8720b834 f2265a2a 89cbab9f e1585a1e 0ad602bb fd403330 d1996c2b =
1dbd6f02
9e0: 5a890263 74042c9e 793ad4f8 5cbf7e6c 93666ff9 6cbbf437 05e82d05 =
7f0a56d8
a00: 0bc2aacb 9072859c 732cad1a 16b6cf21 2ec91573 6026017c 4df2822a =
7a8933f0
a20: 551195c5 fd7e2f03 aa07d4f3 f753314c eca96a08 d5aa1da7 fbe936d9 =
91e6b576
a40: 97d0c67c 5b46eabf df2292da b8536aab a12c6901 1ec450d8 18abacd6 =
1406d306
a60: 554371d9 8200daf2 284ad914 6ac1be9c 989fefc7 80b1cfa8 e73aec8c =
221852ff
a80: 81fd770f cc436dcb c905bf19 c4f7a3e3 3cffa8d1 a6730bfb 23942b33 =
dfaeea27
aa0: 8b55cc38 09174831 7952c5c7 652fe34f ac4979c6 8e16a508 9ad307a5 =
8563bf20
ac0: a394d950 ea4d7801 6fd9ef09 c9755dcd 17109143 75a0fa3f ecf18c41 =
51b93a5e
ae0: 5e66abc4 d1dd1d42 8bf4f8dc 98fb592a 76491dcf 6387793d 0a7dfe57 =
358dc4a5
b00: 93fdbb04 e8586f2b 8edf9aa3 db46597d 6c9c1824 fa9f84f8 f192c630 =
dbf863d8
b20: a767867e 9e6155d0 f3a48ac9 47755639 1ea41778 032888b8 8d2bec2f =
78196ed6
b40: 7fc54879 a7c28fb7 2385262d cebf16da d7723330 0d3666fd b6bd56f1 =
dc1e00d3
b60: 17a947ec 5e9dca3c d2fc6067 baf215e0 eb9783d1 89601c5b 7d82b2c7 =
5e66cb96
b80: 5e141c62 e821a2cc 80d7084c a5b77c29 5ec2586d 4b69b332 9549b233 =
38fc7b4d
ba0: 91bc57f6 566726bc 6dc234e4 0652f289 f40b37dc 721544c3 81ee4ee0 =
ebed6891
bc0: 4ac9351e f3283873 966d3e49 ad24e115 ee1d804c 70eaa426 ba1c48e6 =
7eafc96b
be0: c504f521 385b29ab 3532993f 266af82d 59ec08f9 d85820f3 589cc633 =
ee41a655
c00: a99d074d 23d8823e e7508910 16cc9d9c cecb5cb9 81de6036 b4e8faba =
cfdbdaf6
c20: 36536522 d057ff4a b9e85de3 f7b2704c 9a4908ca e339ac32 d785c548 =
348daa6a
c40: f0afc265 a71c920b 50ae9757 0b51af96 34531279 4da1ee1f f9df3e83 =
0055f97e
c60: 65fe66b4 34399905 9784127e 4c255ddd b0334416 fa5ef3d0 c62ab6aa =
f529f684
c80: e9ef32cd f1d11c0b ae35c00a 10e517fa 003f657c 3f6cb6e5 601b85ad =
0d576c38
ca0: 794e5372 08c0bf34 1c895e11 b6fa2895 67437581 3400a236 f642fe70 =
a69faaf7
cc0: 819bdd30 a8219dbc 2d0e0523 a6fa62be 1aa2386b 1590a568 3e3da633 =
6f9808b0
ce0: 88b35ef6 14240b49 e6721f51 77cee9c3 1af382ab 01677e4d f090c4fa =
4da2c2c5
d00: 024c8629 2ad08aa7 422af8e0 f9712ed5 177bdeea c25eabe2 729067c4 =
96c38d4f
d20: 7d12c96b b0d47cb4 153d0de0 b61116b9 05db3add 580b09ec 4185a57a =
12d2f403
d40: a79875a9 869ed8e9 54496e3a 12409817 29d8a734 c250f847 0269266a =
b1d21578
d60: 929e6a00 84a2c798 8a7dbe54 c56d38f8 cd2c9928 e37d988e 86e3bbd3 =
d66a8fb5
d80: 95bbf81a 31ec0870 354a6694 e583a8df 4c75d417 079d9277 4739253a =
88c7a85c
da0: ead4d046 c16f24a1 aac656b1 b1231730 292ad144 09d48770 9e383b4a =
79ff74d9
dc0: b8453a71 687b98a3 d66e6948 782ff312 e6acc0ef 23bf3730 fa77b629 =
00e0c284
de0: 3e1394c0 dd947b2f 7acd855f d1b55dc6 dddcb637 4afcf856 b28caf57 =
b169fd76
e00: 02f996ac 93f1b65c fd365b9f 723f2848 ce77021d 0f3e1303 273bbf86 =
284e60ea
e20: aaf5b695 10fd5132 c91a16d0 11a41dc9 5a02186a bbbb94a0 7bbceef5 =
9e943106
e40: afb9aace 1933d188 6bf0727f 90aa9123 2241a0d0 01598503 cfabe4aa =
b00afb9b
e60: 3effbd69 68165260 f8a81102 d38b3878 cdd4e4cb 8618f097 42244acf =
b8b976cb
e80: 35125209 f7b5805e 40db397b 00abcfa9 8a50409a c0f51dcf abe9fb4d =
5b8c44bb
ea0: ab9cc478 591f0715 5c06faff 4ff7c649 25880591 9d0f5e5c 7d38d25c =
76648e19
ec0: 6f6bad24 2a754c82 3154a2e3 d43e803a 7ca54600 fd6a3f1a 90dfc856 =
4d3aba0d
ee0: ea944aec ca997066 341ad794 ed5b0d0d d1b95bbd f94ac17a 34df90af =
8d8078e0
f00: 59d8b643 78da3fa9 c79a7dd6 a964a724 7ac02075 4ca9318d c21b6890 =
a9640398
f20: 0000002e 00000002 0000172e 00000004 00624cc3 00000063 1052379a =
00000006
f40: 12d2816f 0000001d 16d07074 00000026 16d0707c 00000000 1d7c54e2 =
00000070
f60: 2caf2876 0000000d 3d25c6d2 00000056 3e07609a 0000005a 6b667b53 =
0000006c
f80: 78fc099c 00000035 8ad0f8ab 00000009 8c17559b 00000012 8f0052b2 =
0000002b
fa0: 8fc97221 00000043 931912cb 0000003a 96b3bb3b 00000051 9a3c8cd4 =
00000019
fc0: 9d95db76 00000048 aec5036b 00000021 dc3223ae 0000004d dd98adc4 =
0000002f
fe0: ea32fb33 0000003f eb7796fb 00000068 ff3b09ea 0000005f 0000001b =
00000001
xfs_db> type dir2
xfs_db> p
bhdr.magic =3D 0x58443242
bhdr.bestfree[0].offset =3D 0x398
bhdr.bestfree[0].length =3D 0xb88
bhdr.bestfree[1].offset =3D 0
bhdr.bestfree[1].length =3D 0
bhdr.bestfree[2].offset =3D 0
bhdr.bestfree[2].length =3D 0
bu[0].inumber =3D 68719478806
bu[0].namelen =3D 1
bu[0].name =3D "."
bu[0].tag =3D 0x10
bu[1].inumber =3D 8589936640
bu[1].namelen =3D 2
bu[1].name =3D ".."
bu[1].tag =3D 0x20
bu[2].inumber =3D 68719478807
bu[2].namelen =3D 9
bu[2].name =3D ".DS_Store"
bu[2].tag =3D 0x30
bu[3].inumber =3D 68719478808
bu[3].namelen =3D 16
bu[3].name =3D "01 - Do-Over.m4v"
bu[3].tag =3D 0x48
bu[4].inumber =3D 68719478809
bu[4].namelen =3D 29
bu[4].name =3D "02 - Believe in the Stars.m4v"
bu[4].tag =3D 0x68
bu[5].inumber =3D 68719478810
bu[5].namelen =3D 45
bu[5].name =3D "03 - The One with the Cast of Night Court.m4v"
bu[5].tag =3D 0x90
bu[6].inumber =3D 68719478811
bu[6].namelen =3D 21
bu[6].name =3D "04 - Gavin Volure.m4v"
bu[6].tag =3D 0xc8
bu[7].inumber =3D 68719478812
bu[7].namelen =3D 16
bu[7].name =3D "05 - Reunion.m4v"
bu[7].tag =3D 0xe8
bu[8].inumber =3D 68719478813
bu[8].namelen =3D 26
bu[8].name =3D "06 - Christmas Special.m4v"
bu[8].tag =3D 0x108
bu[9].inumber =3D 68719478814
bu[9].namelen =3D 26
bu[9].name =3D "07 - Se\303\261or Macho Solo.m4v"
bu[9].tag =3D 0x130
bu[10].inumber =3D 68719478815
bu[10].namelen =3D 17
bu[10].name =3D "08 - Flu Shot.m4v"
bu[10].tag =3D 0x158
bu[11].inumber =3D 68719478816
bu[11].namelen =3D 32
bu[11].name =3D "09 - Retreat to Move Forward.m4v"
bu[11].tag =3D 0x178
bu[12].inumber =3D 68719478817
bu[12].namelen =3D 22
bu[12].name =3D "10 - Generalissimo.m4v"
bu[12].tag =3D 0x1a8
bu[13].inumber =3D 68719478818
bu[13].namelen =3D 28
bu[13].name =3D "11 - St. Valentine\'s Day.m4v"
bu[13].tag =3D 0x1d0
bu[14].inumber =3D 68719478819
bu[14].namelen =3D 19
bu[14].name =3D "12 - Larry King.m4v"
bu[14].tag =3D 0x1f8
bu[15].inumber =3D 68719478820
bu[15].namelen =3D 27
bu[15].name =3D "13 - Goodbye, My Friend.m4v"
bu[15].tag =3D 0x218
bu[16].inumber =3D 68719478821
bu[16].namelen =3D 22
bu[16].name =3D "14 - The Funcooker.m4v"
bu[16].tag =3D 0x240
bu[17].inumber =3D 68719478822
bu[17].namelen =3D 19
bu[17].name =3D "15 - The Bubble.m4v"
bu[17].tag =3D 0x268
bu[18].inumber =3D 68719478823
bu[18].namelen =3D 23
bu[18].name =3D "16 - Apollo, Apollo.m4v"
bu[18].tag =3D 0x288
bu[19].inumber =3D 68719478824
bu[19].namelen =3D 17
bu[19].name =3D "17 - Cutbacks.m4v"
bu[19].tag =3D 0x2b0
bu[20].inumber =3D 68719478825
bu[20].namelen =3D 26
bu[20].name =3D "18 - Jackie Jormp-Jomp.m4v"
bu[20].tag =3D 0x2d0
bu[21].inumber =3D 68719478826
bu[21].namelen =3D 17
bu[21].name =3D "19 - The Ones.m4v"
bu[21].tag =3D 0x2f8
bu[22].inumber =3D 68719478827
bu[22].namelen =3D 26
bu[22].name =3D "20 - The Natural Order.m4v"
bu[22].tag =3D 0x318
bu[23].inumber =3D 68719478828
bu[23].namelen =3D 18
bu[23].name =3D "21 - Mamma Mia.m4v"
bu[23].tag =3D 0x340
bu[24].inumber =3D 68719478829
bu[24].namelen =3D 20
bu[24].name =3D "22 - Kidney Now!.m4v"
bu[24].tag =3D 0x360
bu[25].inumber =3D 68719478830
bu[25].namelen =3D 11
bu[25].name =3D "season_done"
bu[25].tag =3D 0x380
bu[26].freetag =3D 0xffff
bu[26].length =3D 0xb88
bu[26].tag =3D 0x398
bleaf[0].hashval =3D 0x2e
bleaf[0].address =3D 0x2
bleaf[1].hashval =3D 0x172e
bleaf[1].address =3D 0x4
bleaf[2].hashval =3D 0x624cc3
bleaf[2].address =3D 0x63
bleaf[3].hashval =3D 0x1052379a
bleaf[3].address =3D 0x6
bleaf[4].hashval =3D 0x12d2816f
bleaf[4].address =3D 0x1d
bleaf[5].hashval =3D 0x16d07074
bleaf[5].address =3D 0x26
bleaf[6].hashval =3D 0x16d0707c
bleaf[6].address =3D 0
bleaf[7].hashval =3D 0x1d7c54e2
bleaf[7].address =3D 0x70
bleaf[8].hashval =3D 0x2caf2876
bleaf[8].address =3D 0xd
bleaf[9].hashval =3D 0x3d25c6d2
bleaf[9].address =3D 0x56
bleaf[10].hashval =3D 0x3e07609a
bleaf[10].address =3D 0x5a
bleaf[11].hashval =3D 0x6b667b53
bleaf[11].address =3D 0x6c
bleaf[12].hashval =3D 0x78fc099c
bleaf[12].address =3D 0x35
bleaf[13].hashval =3D 0x8ad0f8ab
bleaf[13].address =3D 0x9
bleaf[14].hashval =3D 0x8c17559b
bleaf[14].address =3D 0x12
bleaf[15].hashval =3D 0x8f0052b2
bleaf[15].address =3D 0x2b
bleaf[16].hashval =3D 0x8fc97221
bleaf[16].address =3D 0x43
bleaf[17].hashval =3D 0x931912cb
bleaf[17].address =3D 0x3a
bleaf[18].hashval =3D 0x96b3bb3b
bleaf[18].address =3D 0x51
bleaf[19].hashval =3D 0x9a3c8cd4
bleaf[19].address =3D 0x19
bleaf[20].hashval =3D 0x9d95db76
bleaf[20].address =3D 0x48
bleaf[21].hashval =3D 0xaec5036b
bleaf[21].address =3D 0x21
bleaf[22].hashval =3D 0xdc3223ae
bleaf[22].address =3D 0x4d
bleaf[23].hashval =3D 0xdd98adc4
bleaf[23].address =3D 0x2f
bleaf[24].hashval =3D 0xea32fb33
bleaf[24].address =3D 0x3f
bleaf[25].hashval =3D 0xeb7796fb
bleaf[25].address =3D 0x68
bleaf[26].hashval =3D 0xff3b09ea
bleaf[26].address =3D 0x5f
btail.count =3D 27
btail.stale =3D 1

And the inode it lists, which has reasonable mtime and size based on =
similar files in the directory:

xfs_db> inode 68719478814
xfs_db> p
core.magic =3D 0x494e
core.mode =3D 0100660
core.version =3D 2
core.format =3D 2 (extents)
core.nlinkv2 =3D 1
core.onlink =3D 0
core.projid_lo =3D 0
core.projid_hi =3D 0
core.uid =3D 1000
core.gid =3D 100
core.flushiter =3D 368
core.atime.sec =3D Thu Jan  2 18:23:36 2014
core.atime.nsec =3D 082260304
core.mtime.sec =3D Sat Sep 11 20:13:07 2010
core.mtime.nsec =3D 000000000
core.ctime.sec =3D Sun Jan 12 01:30:25 2014
core.ctime.nsec =3D 866103023
core.size =3D 326451171
core.nblocks =3D 79700
core.extsize =3D 0
core.nextents =3D 1
core.naextents =3D 0
core.forkoff =3D 7
core.aformat =3D 1 (local)
core.dmevmask =3D 0
core.dmstate =3D 0
core.newrtbm =3D 0
core.prealloc =3D 0
core.realtime =3D 0
core.immutable =3D 1
core.append =3D 0
core.sync =3D 0
core.noatime =3D 0
core.nodump =3D 0
core.rtinherit =3D 0
core.projinherit =3D 0
core.nosymlinks =3D 0
core.extsz =3D 0
core.extszinherit =3D 0
core.nodefrag =3D 0
core.filestream =3D 0
core.gen =3D 2502109681
next_unlinked =3D null
u.bmx[0] =3D [startoff,startblock,blockcount,extentflag] =
0:[0,509696,79700,0]
a.sfattr.hdr.totsize =3D 95
a.sfattr.hdr.count =3D 1
a.sfattr.list[0].namelen =3D 12
a.sfattr.list[0].valuelen =3D 76
a.sfattr.list[0].root =3D 1
a.sfattr.list[0].secure =3D 0
a.sfattr.list[0].name =3D "SGI_ACL_FILE"
a.sfattr.list[0].value =3D =
"\000\000\000\006\000\000\000\001\377\377\377\377\000\006\000\000\000\000\=
000\004\377\377\377\377\000\006\000\000\000\000\000\b\000\000\000d\000\006=
\000\000\000\000\000\b\000\000\003\361\000\004\000\000\000\000\000\020\377=
\377\377\377\000\006\000\000\000\000\000 =
\377\377\377\377\000\000\000\000=94

I=92m not sure if this the right way to get the related first data =
block. If I did it wrong let me know:

xfs_db> daddr 509696
xfs_db> p
000: e85e996a 4e705067 b42c65f1 97d553b3 4af10990 1609bbd9 beeef165 =
f1cf1a2c
020: 483f0a2e 24ecce2e ff1aa9bc a8e3b359 0808858e f7db2c32 d163ef30 =
10782a0e
040: 82862ec9 22285fed 90177e6e f8d2b6d2 15ae9d85 35356190 bffc2604 =
3ec17ea8
060: bb69e2ba 6ffd82ed b5df455d 4f2ed5bf 042b87c8 2a457ad3 224eb183 =
4905d39f
080: 37d5acb5 28480b63 c32662c6 33bd3c51 3de5ca43 bf7639c9 fa1097c1 =
8a1aff22
0a0: 9af51d18 89455c57 c569eb0c 8790d635 54e7ea81 9a37fd0b 824d57d6 =
6fb28c79
0c0: 6ba742db cf65ffd7 f47ef4f2 7f7e0233 fa2f788f e09d5aef 7cb17105 =
eddf901e
0e0: 21a74f60 c7c19141 387289a9 514d8962 2fb8597c 0a806421 6920a244 =
8610318f
100: f1119976 46332bd6 aad56bc2 319e7e23 e6b559c5 8aabf1e9 26c50da8 =
806048fd
120: 7851b307 6a858007 21c1feb2 4281f277 5fc5dd9b e49b59db 7f209de1 =
66d9e02b
140: ac4ca898 1dfeff12 207ec7cd 83283cf0 6f9d24be 421f64bc ffd05e4d =
e3828501
160: 0809baac 56a9dfc4 2133bbee fcd0d1e9 1c00f07d ecfec298 ead947e9 =
06ba929c
180: 7a3206f2 7efe3450 28cbf76a cf99e170 a22bf86d 826dade6 d67f8e60 =
6d5c7c02
1a0: 94be0967 ab263252 9ff805b1 7b34db8f 9a099feb cdb274e2 a06cd03f =
cbf8aefe
1c0: 7128dacb fad4c84c 63c4d19f 27a836fe 2a5ad1cb e8e6afe1 5f7c8182 =
9f46dcfd
1e0: 3a475df5 f9a1dc40 9f51fedd d722ef07 6e2346e9 8d58b1dd 8c7e9d7c =
041826cf

Thanks for your help,
	Zach


--Apple-Mail=_1C27DD97-FFE9-4267-B4A6-3F4124BF0FAF
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
9GbUngEr8gAAAAAAAA==

--Apple-Mail=_1C27DD97-FFE9-4267-B4A6-3F4124BF0FAF--


--===============2116881571951036072==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============2116881571951036072==--
