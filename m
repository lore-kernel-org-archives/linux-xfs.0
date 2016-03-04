Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 18C797CA1
	for <xfs@oss.sgi.com>; Fri,  4 Mar 2016 05:24:04 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 66B0DAC002
	for <xfs@oss.sgi.com>; Fri,  4 Mar 2016 03:24:03 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id cGfJg23B46C1qkNz (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 04 Mar 2016 03:23:58 -0800 (PST)
Received: from int-mx09.intmail.prod.int.phx2.redhat.com
	(int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (Postfix) with ESMTPS id 02D5D2655
	for <xfs@oss.sgi.com>; Fri,  4 Mar 2016 11:23:57 +0000 (UTC)
Received: from localhost (dhcp-13-211.nay.redhat.com [10.66.13.211])
	by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id u24BNsJR009353
	for <xfs@oss.sgi.com>; Fri, 4 Mar 2016 06:23:56 -0500
Date: Fri, 4 Mar 2016 19:23:54 +0800
From: Eryu Guan <eguan@redhat.com>
Subject: Some xfstests failures on non-crc xfs with latest xfsprogs
	(v4.5.0-rc1)
Message-ID: <20160304112354.GX11419@eguan.usersys.redhat.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="MSd2ShuMixI0uVaZ"
Content-Disposition: inline
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com


--MSd2ShuMixI0uVaZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,

I noticed some xfstests failures while testing v4 XFS with latest
v4.5.0-rc1 xfsprogs on v4.5-rc6 kernel, and all these failures are gone
if I use v3.2.4 xfsprogs, or if test on v5 XFS.

So either xfstests needs update or xfsprogs breaks something for non-crc
XFS. But I'm not sure which is which, so I post them out for broader
review.

(All tests are checked with 'MKFS_OPTIONS="-m crc=0" ./check <sometest>')

== 1. xfs/032 fsck failure (xfs_db check) on ppc64 host ==

xfs/032 fails in the same way as the following steps on ppc64 host:

 mkfs -t xfs  -m crc=0 -s size=32768 -b size=65536 -d size=1g -f /dev/sda5
 xfs_db -c check /dev/sda5

This prints

 bad magic number 0 for inode 1792
 ...
 bad magic number 0 for inode 2047
 root inode 1792 is not a directory
 block 0/7 type unknown not expected
 allocated inode 1792 has 0 link count
 allocated inode 1793 has 0 link count
 allocated inode 1794 has 0 link count


== 2. xfs/033 fsck failure ==

xfs_repair detects more nlinks error. And this happens after commit
"c2c5096 libxfs: update to 3.16 kernel code"

# diff -u tests/xfs/033.out /root/xfstests/results//xfs_4k/xfs/033.out.bad
--- tests/xfs/033.out   2015-07-16 17:28:15.996000000 +0800
+++ /root/xfstests/results//xfs_4k/xfs/033.out.bad      2016-03-04 18:54:39.461000000 +0800
@@ -66,6 +66,7 @@
         - traversal finished ...
         - moving disconnected inodes to lost+found ...
 Phase 7 - verify and correct link counts...
+resetting inode INO nlinks from 0 to 1
 done
 Corrupting rt summary inode - setting bits to 0
 Wrote X.XXKb (value 0x0)
@@ -96,6 +97,7 @@
         - traversal finished ...
         - moving disconnected inodes to lost+found ...
 Phase 7 - verify and correct link counts...
+resetting inode INO nlinks from 0 to 1
 done
 Corrupting root inode - setting bits to -1
 Wrote X.XXKb (value 0xffffffff)
@@ -160,6 +162,7 @@
         - traversal finished ...
         - moving disconnected inodes to lost+found ...
 Phase 7 - verify and correct link counts...
+resetting inode INO nlinks from 0 to 1
 done
 Corrupting rt summary inode - setting bits to -1
 Wrote X.XXKb (value 0xffffffff)
@@ -191,4 +194,5 @@
         - traversal finished ...
         - moving disconnected inodes to lost+found ...
 Phase 7 - verify and correct link counts...
+resetting inode INO nlinks from 0 to 1
 done


== 3. xfs/108 xfs/196 xfs/261 xfs/244 fsck failure. ==

These tests fail in a similiar way, and they are all quota related.
Note that xfs/244 only fails on ppc64, others fail on all arches.

*** xfs_repair -n output ***
Phase 1 - find and verify superblock...
Phase 2 - using internal log
        - zero log...
        - scan filesystem freespace and inode maps...
        - found root inode chunk
Phase 3 - for each AG...
        - scan (but don't clear) agi unlinked lists...
        - process known inodes and perform inode discovery...
        - agno = 0
        - agno = 1
        - agno = 2
        - agno = 3
        - process newly discovered inodes...
Phase 4 - check for duplicate blocks...
        - setting up duplicate extent list...
        - check for inodes claiming duplicate blocks...
        - agno = 0
        - agno = 3
        - agno = 1
        - agno = 2
No modify flag set, skipping phase 5
Phase 6 - check inode connectivity...
        - traversing filesystem ...
        - traversal finished ...
        - moving disconnected inodes to lost+found ...
disconnected inode 131, would move to lost+found
Phase 7 - verify link counts...
No modify flag set, skipping filesystem flush and exiting.
*** end xfs_repair outpu

== 4. xfs/186 xfs/187 attr test failure ==

xfs/186 is missing almost all the attr values.
xfs/187 reports test needs update.


Please see attachments for details.

Thanks,
Eryu

--MSd2ShuMixI0uVaZ
Content-Type: application/x-bzip2
Content-Disposition: attachment; filename="xfs-032-ppc64.full.bz2"
Content-Transfer-Encoding: base64

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

--MSd2ShuMixI0uVaZ
Content-Type: application/x-bzip2
Content-Disposition: attachment; filename="xfs-033.out.bad.bz2"
Content-Transfer-Encoding: base64

QlpoOTFBWSZTWZQ5u4gABP9fgHYQQG9/hy+t9eA/79/wYAZ/fIEqRAUqqBQKI5gE0wCZDAAE
wTAAADmATTAJkMAATBMAAAOYBNMAmQwABMEwAAA5gE0wCZDAAEwTAAABEoplPAoPUaNTIYga
GhoBoPKAClRCBMFGmim1NPTSPUD1Gho9CHih6T+y3sRiqOh8mEe5YX3n0ZF818F/PbugaDaP
eMAa8zscXc2NGMGjGMsITGznI2OHRC4XhUFflwbFUJX6j9B6R6xyHEvtXddl+tfK0XJfFYWl
k+rxLawWLUwtWWSOyx23r/S0ovK8uK93yXzui3retFhcVoPYw5rlksXw/z/Lf70blxXK1jRc
VldL2rnaroty7LRcFlaLnquy5r5rksrCwvZeS7L/C4XbS69WNbOe2c5yyy5o62yyWi5rksu6
3rZd1oX23m5reWq9w7BzIOY6gajoO8N44u0YMGMGDUe1871MfU0aNGrR9+I4A+scypCFRDmB
0NBgzoL+K7POw3L6/StV7O66HdlchuHcOWY6NgNg1GA0HrBvdHgHMeqjv8osN63LCMCwsCws
IwWFiPs95RcDutVgvauqytF9iyWFlegtDaYDqf6DAjFXhYJBgnZB4oK+3u4O7AsOXLkkD/WV
PT3jtuB2/Eerbu/Fg9tHpHsBvRTnG+6bUU8iKbRr+x31EpXduGjXUN5SCclhH7VoXxXq2sPg
vWviqwta/BGPxj61/RbVfRe34FvlOAtqsF7Un9WyNfuX5Fu/6vJVkjjRqWEbljmjoWEfvX5F
hai2RpSzVwWLcsScsLJY2XnxDesLsvMsLOJMI0LKysCyXD7uRJosKuBNV4ZR3N6xH8F9F0Sd
9ZT0rxWiZLRGF1sjQaxtbkwHWPIrorFoIQcxjBhQcVyvvWJNVhaJeojyLwWFguS6LJGBdVhb
1WV2LmXVdsEc12XTH5K8gwV+CtRExH+DRE1g2rcqhBzXqS6rw96TgtEdFhetbLCO6Pz6h8A8
QN7zsuVyQo6h48hsB1jUajVvYL0rCNy7rojiit6PSzYR4rOpUXYIYZDgDcpaNoOgrBuGtBqr
vjI8lirBfoRuWxYLZeBWV5sK0k8V2XpWF2WyOV1WLCyvEtPQRirlyytC2WbQuKrksI0uW/et
FupZWEbLmX0XFbpJuwsLCMLK2LRFetcVtqsrKxsRnmXRYWC81LkitlmWiyq4o9C86NVeQsx7
lxcAZC2jaDat8B0HEeEHMYOseioO8MIwWqyufcjRc0aFoXjuV4YXSPM2XBdbgsLgt5YWC2Rt
ejktF6S3rcW9+a3VbiNZ4LRxLUvLz2VssLRdLzF1LVdFlZWywsLNYty5FvRxSd7etVhGFhar
RbC1Xq19eW5HQar8SwtyWpeHRxcuCvFeS1b1uLTXj02m8MUNQ2g36xuGX7MB5lbQbmA6DAeS
0WxdUZdco8FquazXPTqRheC7rYjcXYsexcVpWK0LsjutI77eteCytS7lhGS0XDotF4fgq36j
k6fUuAag0GDxjgjipkMH/i7kinChIShzdxA=

--MSd2ShuMixI0uVaZ
Content-Type: application/x-bzip2
Content-Disposition: attachment; filename="xfs-108.full.bz2"
Content-Transfer-Encoding: base64

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
krjH/xdyRThQkInDx3c=

--MSd2ShuMixI0uVaZ
Content-Type: application/x-bzip2
Content-Disposition: attachment; filename="xfs-186.out.bad.bz2"
Content-Transfer-Encoding: base64

QlpoOTFBWSZTWdTHWpQAAMB/gAAQAAJQEXfCIgA0Dj/v3zAwAULW0EkJNMjRT0QDJoeoAeUE
iplGjCANGI9IAAEkVD1AP1TQwhpoyAGSSc4wWbwk6qUcGaAmzynmOY2TlCB3h3iFTQSiPuAX
P8c2YIjzgYXoMQMx9Jx3UEGs8OtX175W8ZZHEuGu7hVBMuxfoC9QWokOOKRkYuQJoi7BqAmF
iZB8xWqYqllipERQuAkITAEAWsK0xj3AqRPwEELQuhpYZhmNtp4hI+iwFOSDASKpM6DCKxjm
OwT+lsua3JDhqnuVy/hUJzyBhI2DQMswx6sBBlM4bBSEFwJxOJj9A94SUBC1F5M8DCQw1VIM
JhirHK/kSWDCRBeIILFFwMdARiFKknSRdM0mkjgKDNbvUW5bM/xdyRThQkNTHWpQ

--MSd2ShuMixI0uVaZ
Content-Type: application/x-bzip2
Content-Disposition: attachment; filename="xfs-187.out.bad.bz2"
Content-Transfer-Encoding: base64

QlpoOTFBWSZTWTv+LQoAACjfgAAQQAx0wjev/Wo/Z99gIACEIqflT1PKeowjT1D1DTI9Q/JT
Qepo0Iqf6k8hTeqaPUGjJo0AAA2UoYQNwvhR5RV/cpOze8imCt0Kax6cuK1P2xeFRhh4IbAs
BaWhaKOKImcSAzekCyhvaSNjdjnnYVwlnmpm1VMKuUuXMt9sXkZXM3dI3Mbqkhk4EHSisPTU
g57TRxyZRMGKkxB5qoI+oUI1ApziF+2kl/i7kinChIHf8WhQ

--MSd2ShuMixI0uVaZ
Content-Type: application/x-bzip2
Content-Disposition: attachment; filename="xfs-196.full.bz2"
Content-Transfer-Encoding: base64

QlpoOTFBWSZTWfaAAXcAAfvfgAQQQP//0iCBYIC/7//wUAV69OzjsNUSGtCqENNTSNGp4hTe
pHlP0UNBpoMnqAEUemqaepvUamAJhBkYCaMRgkQo1MqfhU2JhCAaNqAB6jGA0BoAANNBoBoA
0CSEEaAp6ABT0UMQZAep6QkGJlq9NSgpo8fRH6ICL846Pf4xawlDAvaEEARJIgDcvbXgeaAc
WMISBQKQICmeG2emr+ZkgB7BkMMwyP6A+/Dj7ARPa92YFJNGznVg7frGrd0mgfXUL8oa7Bti
0mxTJ8q6lfFnIxytg+qM0iQt5ubYZ44tDTgezO2gaB1BA5gFU79xsm64HBrFBBAPkICBYyA0
8gI8koIzBGq5kyKOP8edT7rSbR0U8CjN1wdJTt0QB3KZtfxy27Ocp9Od1Go7tnPCCWESv0BZ
HzCwdbBY9xi9iG7hD4v5nDXTzEHhCZj4h/hLtaML8caXsbQ2Jtiex7b5aCYxnI1joBtbTQMd
3Bz0SPCYBtJc7tzvf4tE3bZJNY90wkaSOQ5JtyUC7GdkwrEXVHfdFKKiGQhYrFcQAKrnUuz4
uUjfinLT1XhZTtrtTvk5wlVsD2I/cH1yUlW6jRMHnE/VSVpqc5eQh88NMJJmbv9Kgbr+PSOU
vyHdKn8+AHaGoe5dxjuQeYRWweUlP5mZOR495ZoJOV9TEmG1/tl7t90pVWAJfb+AtuMJn2N0
/KSkfR2uumRgv77G/e8gBiCDFWBiRcI6iMEjjfS4vFWbGkoJL4tgRxcFaJvcbEr7og1Z2ZM8
ObO4+YIYnD9ZTRkkrYYwKGEDCMqpuiZlpbedt7Fru4jEU215RNqllpgR3RFZBqCVEfDIZ7Uw
3lF0AOoUSVOCdRmS73OsTVJXKEJXKojExHNT5EmoaFbferpi7JUhar0s7sdHKmqMA0Kg+5XA
l1GFPkAbGB6HG5UFmiGq/hC537vrnAac8s55UF0NXuaLWwEs3coXeGMC9RO2SnRLYU24zYHa
AGTz6hDEBBgU18T14o5mIIjkcT5AdEJa4Ryv8a7M1xvrmXo9AZHW95LuXjGRpNqMFq4tz10Y
0mUNy+v1cjkrFDKZfmdhBCS3jOCWIciI49UYnBYZ0TlEMFS3mayb1anR0YglplKBukcYRUqM
GAQGlcWv0QAAy3zab4XKC4RKljNqVpB0rUtasmQgo1zDUXgCsklcIS8O9KYDjLw04ZYgW1Op
NFUNLuVINgmAmMAqTJAHr5JW5uwcVcuL2LEwRosxXFSoVLSADTIJSGvuACnYqnXqAGpPhuws
Id+52KKpLncnO2dOsqUt5H9BcQzVeAZMm2MKO+6AzYlRmJ0jeskJehCNVUcKt+e5LLVzugDO
UqDFEkriMRZskOaaklNBRymJ4Ro7tPB2iosCsgGEtYcnoMIWaMANySefJ3fcnVh7p3xtcVMM
puvQvewh9U6BGWzIQOLInymDDJrq9krlsjfUVTogmHJpyOckTbZVISOt1iYJbcNbsA1Dqaht
Bma6JgsiRNSzvyRiFAAoEl8Lx7IYvBGJzGCV0oVEfDiJMhEvVPst+J3rEBjTRg1WgJUhxqkx
4G1cNUkpvKkG3CYA8A3lyOdnz8BhwY0gNwktC8w8xdyRThQkPaAAXcA=

--MSd2ShuMixI0uVaZ
Content-Type: application/x-bzip2
Content-Disposition: attachment; filename="xfs-244-ppc64.full.bz2"
Content-Transfer-Encoding: base64

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
87PhX5lWSHJEc0jRvsf/i7kinChIPJfF6oA=

--MSd2ShuMixI0uVaZ
Content-Type: application/x-bzip2
Content-Disposition: attachment; filename="xfs-261.full.bz2"
Content-Transfer-Encoding: base64

QlpoOTFBWSZTWdPyhkwAAfNfgAQQQP//0iCBQAC/7//wUAVeut24Z3XVFarQVWkJJAp6YJKf
pR7RqaRoeoDanpBoNIyCZR6Rk0aA0aGQAAJCRBKeaU8gn6RlNNAaADIYAaaNBpiAAABkAJIQ
SehojQAhRk9IZBjUOkFjLRr6EgkyPli/+Dg9M3+jcflWolJgKMiyBLCQfjv1bsg+rnMKrIew
VNvDfpw6d6dmwgDxDcMbGj8gffr9wEtwyiFZOuEOTXd5y1adj5lJRM+tu9TS8GZ08UxKL6Xc
W1nXKNtFZh+bYhNuPGCG0b074diQchFXCfDTZsNq3GhnGIH+ZtIVpCFEwSPZ5pGIP2qKQWbv
q57aceB96/UqBKlwFZpNvIAPQlds+N9PBxrHnynJpOc2I1eQq+GWYK51CgbUDYf4ZmynzCpt
nhenlfQQdEJs+QeYl2NGeGzZZeDaGxNsTyfHCmgqbK2m+eQHFtNAx37XXkkc2kHK/U7v9YSr
zi6N88aiRpQ6DVNuiwLgzhUWJL2nfeWUtIyIyqViwC+/Hv38+TjUN1Zd9fQ7n6bGzFbJzhJk
RBZQqAvwkhOe1RsAWw2bSQoMJjEsANcozxQlKVc0AUPqrPKloWsib41ACGofkw5R4IPWArYP
VJe5clB5/MtEEnLexkTDTLyv2SfJUBLz/IZaFInmaeKSedSe6Y+q9NjhwdAAYggyWIMSMBHY
RuSOdJLm1lVmGSTkGExzJ2uFtE31GSWF5E20/XUOMhNAQ1ylkZpK2OUIhhAwjKUmaRDwlw61
4sLTboMIk205Iy+EEa1WFg3glgj0aHM8NnEwWoByCiSpxTqLku7LI+iSqoQlVUEZGQ5qfwSa
hoVtRkxXFThXWu5nOrlTeiwXKg/BYAl2GFPmAbzE1Oc1IKsh2UvwOdabfzm4X65Zx0kE41g6
sY45iW53UXcGyC5lcaLWKbCzbm5gcgAybP4CGICDEpr5nrzR1MgRHQ5noB2Qlvq/XLpv0Zpk
rk0bwYNpuguhMYsYjJwa7rNy10Y0mUNl7+7kdFYoZzN1zwIISXEZwSyDpD9kVPaqXinGqGDc
U7xV28mlzciwJZ3g8bm/i9FSowbxDeKZyt6IAa/68ZNrlpA1TNoZ9lRZV0zWdq0lINjHddAK
EsRCXSS9/UQa6O9NbQMtT4JEQMl3U0GAmSQwwBKDRAHr1Sr2aoc1gub2LEwRorhgVqqlpABp
mEpDbsAAp4Kp1+gAak+W2NhDv5PBRVJdcE54vTvKlLew+8XMLrkGbJuBjN32gLsSop0jiskJ
byEaqo6Pnslw1c8oAvKVBiiSVSMRXZIcz0KLNBY1qV2y27m8I7YAsEAwjWue4YUtyNgNkk8+
ju+ydWHwnujhgVMc5ut5uewh9E0gRty2iBzFFfOoZ7WvN5Utcp12lrOxCo7O9jWQT4Ko6R3w
sTBLhy1wxDUO5qHCC5romCyIEVDGV0WCQASCC9V4/FDGQItyGUJwepAwiGQiPZPvW2J4rEBj
S7BorglSHGqTHgbRw0SSaKU38ZgDwDerkdLPfyGPJhkgNhJYJGX/F3JFOFCQ0/KGTA==

--MSd2ShuMixI0uVaZ
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--MSd2ShuMixI0uVaZ--
