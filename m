Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from smtp1.onthe.net.au ([203.22.196.249]:42795 "EHLO
        smtp1.onthe.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751719AbeCVPMF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 22 Mar 2018 11:12:05 -0400
Received: from localhost (localhost [127.0.0.1])
        by smtp1.onthe.net.au (Postfix) with ESMTP id F2EE66139F
        for <linux-xfs@vger.kernel.org>; Fri, 23 Mar 2018 02:02:29 +1100 (EST)
Received: from smtp1.onthe.net.au ([127.0.0.1])
        by localhost (smtp1.onthe.net.au [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 83cX93XqQ8xh for <linux-xfs@vger.kernel.org>;
        Fri, 23 Mar 2018 02:02:28 +1100 (EST)
Received: from hestia.private.onthe.net.au (hestia-gw1-vpn.private.onthe.net.au [10.9.1.6])
        by smtp1.onthe.net.au (Postfix) with ESMTP id 9F69560E43
        for <linux-xfs@vger.kernel.org>; Fri, 23 Mar 2018 02:02:26 +1100 (EST)
Date: Fri, 23 Mar 2018 02:02:26 +1100
From: Chris Dunlop <chris@onthe.net.au>
Subject: file corruptions, 2nd half of 512b block
Message-ID: <20180322150226.GA31029@onthe.net.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Hi,

I'm experiencing 256-byte corruptions in files on XFS on 4.9.76.

System configuration details below.

For those cases where the corrupt file can be regenerated from other
data and the new file compared to the corrupt file (15 files in all),
the corruptions are invariably in the 2nd 256b half of a 512b sector,
part way through the file. That's pretty odd! Perhaps some kind of
buffer tail problem?

Are there any known issues that might cause this?

------
Late addendum... this is the same system, but different FS, where I
experienced this:

https://www.spinics.net/lists/linux-xfs/msg14876.html

To my vast surprise I see the box is still on the same kernel without
the patch per that message. (I must have been sleep deprived, I would
have sworn that it was upgraded.) Is this possibly the same underlying 
problem?
------

Further details...

The corruptions are being flagged by a mismatched md5. The file
generator calculates the md5 of the data as it's being generated (i.e.
before it hits storage), and saves the md5 in a separate file alongside
the data file. The corruptions are being found by comparing the
previously calculated md5 with the current file contents. The xfs sits
on raid6 which checks clean, so it seems like it's not a hdd problem.

The box was upgraded from 3.18.25 to 4.9.76 on 2018-01-15. There's a
good chance this was when the corruptions started as the earliest
confirmed corruption is in a file generated 2018-02-04, and there may
have been another on 2018-01-23. However it's also possible there were
earlier (and maybe even much earlier) corruptions which weren't being
picked up.

A scan through the commit log between 4.9.76 and current stable (.88)
for xfs bits doesn't show anything that stands out as relevant, at least
to my eyes. I've also looked between 4.9 and current HEAD, but there
are of course a /lot/ of xfs updates there and I'm afraid it's way too
easy for me to miss any relevant changes.

The file generator either runs remotely, and the data (and md5) arrives
via FTP, or runs locally, and the data (and md5) is written via NFS. The
corruptions have occurred in both cases.

These files are generally in the 10s of GB range, with a few at 1-3GB,
and a few in the low 100s of GB. All but one of the corrupt files have a
single 256b corruption, with the other having two separate corruptions
(each in the 2nd half of a 512b sector).

Overall we've received ~33k files since the o/s change, and have
identified about 34 corrupt files amongst those. Unfortunately some
parts of the generator aren't deterministic so we can't compare corrupt
files with regenerated files in all cases - per above, we've been able
to compare 15 of these files, with no discernible pattern other than the
corruption always occurring in the 2nd 256b of a 512b block.

Using xfs_bmap to investigate the corrupt files and where the corrupt
data sits, and digging down further into the LV, PV, md and hdd levels,
there's no consistency or discernible pattern of placement of the
corruptions at any level: ag, md, hdd.

Eyeballing the corrupted blocks and matching good blocks doesn't show
any obvious pattern. The files themselves contain compressed data so
it's all highly random at the block level, and the corruptions
themselves similarly look like random bytes.

The corrupt blocks are not a copy of other data in the file within the
surrounding 256k of the corrupt block.

----------------------------------------------------------------------
System configuration
----------------------------------------------------------------------

linux-4.9.76
xfsprogs 4.10
CPU: 2 x E5620 (16 cores total)
192G RAM

# grep bigfs /etc/mtab
/dev/mapper/vg00-bigfs /bigfs xfs rw,noatime,attr2,inode64,logbsize=256k,sunit=1024,swidth=9216,noquota 0 0
# xfs_info /bigfs
meta-data=/dev/mapper/vg00-bigfs isize=512    agcount=246, agsize=268435328 blks
         =                       sectsz=4096  attr=2, projid32bit=1
         =                       crc=1        finobt=1 spinodes=0 rmapbt=0
         =                       reflink=0
data     =                       bsize=4096   blocks=65929101312, imaxpct=5
         =                       sunit=128    swidth=1152 blks
naming   =version 2              bsize=4096   ascii-ci=0 ftype=1
log      =internal               bsize=4096   blocks=521728, version=2
         =                       sectsz=4096  sunit=1 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0

XFS on LVM on 6 x PVs, each PV is md raid-6, each with 11 x hdd.

The raids all check clean.

The XFS has been expanded a number of times.

----------------------------------------------------------------------
Explicit example...
----------------------------------------------------------------------

2018-03-04 21:40:44 data + md5 files written
2018-03-04 22:43:33 checksum mismatch detected

file size: 31232491008 bytes

The file is moved to "badfile", and the file regenerated from source
data as "goodfile".

"cmp -l badfile goodfile" shows there are 256 bytes differing, in the
2nd half of (512b) block 53906431.

$ dd if=badfile bs=512 skip=53906431 count=1 | od -t x2
0000000 4579 df86 376e a4dd 22d6 0a6a 845d c6c3
0000020 78c2 56b1 6344 e371 8ed3 f16e 691b b329
0000040 cee2 ab84 bfb5 f9f3 1a3c 23b8 33d1 e70c
0000060 8135 9dbb aaf8 be26 fea7 8446 bd39 6b28
0000100 7895 3f84 c07d 95a3 c79b 11e3 28cb dcdd
0000120 5e75 b945 cd8e 46c6 53b8 a0f2 dad3 a68b
0000140 5361 b5b4 09c9 8264 bf18 ede5 4177 0a5c
0000160 ddc7 4927 6b24 80c9 8f4c 76ac 1ae3 1df9
0000200 b477 3be0 c60a 9355 53e0 925f 4b8d 162c
0000220 2431 788f 4024 16ae 226e 51c4 6b85 392d
0000240 5283 a918 b97a c85c 7b34 e341 7689 0468
0000260 a4f1 a94a 0798 e5e3 435a 5ee4 3ab4 af1c
0000300 426a e484 7d2e 4e37 f2ef 95b3 fcf5 8fc8
0000320 a9d2 e50d 61ae 76bd 5ad9 6d00 67c3 3fcc
0000340 a610 7edd fe05 46bf 78c1 c70b 1829 11b7
0000360 9a34 c496 5161 c546 43cd 7eb8 ff70 473a
x
0000400 11d2 8c94 00ed c9cc d299 5fcf 38ee 5358
0000420 6da3 f8fd 8495 906e cf6f 3c12 94d7 a236
0000440 4150 98ce 22a6 68b0 f6f3 b2e0 f857 0719
0000460 58c9 abbf 059f 1092 c122 7592 a95e c736
0000500 aca4 4bd6 2ce0 1d4e 6097 9054 6f25 519c
0000520 187b 2598 8c1d 33ba 49fa 9cb6 e55c 779d
0000540 347f e1f2 8c6d fc06 5398 d675 ae49 4206
0000560 e343 7e08 b24a ed18 504b 4f28 5479 d492
0000600 1a88 fe80 6d19 0982 629a e06b e24a c78e
0000620 c2a9 370d f249 41ab 103b 0256 d0b2 b545
0000640 736d 430f c8a4 cf19 e5fb 5378 5889 7f3a
0000660 0dee e401 abcf 1d0d 5af2 5abe 0cbb 07a5
0000700 79ee 75d0 1bb7 68ee 5566 c057 45f9 a8ca
0000720 ee5d 3d86 b557 8d11 92cc 9b21 d421 fe81
0000740 8657 ffd6 e20d 01be 4e02 6049 540e b7f7
0000760 dfd4 4a0b 2a60 978c a6b1 2a8a 3e98 bcc5
0001000

$ dd if=goodfile bs=512 skip=53906431 count=1 | od -t x2
0000000 4579 df86 376e a4dd 22d6 0a6a 845d c6c3
0000020 78c2 56b1 6344 e371 8ed3 f16e 691b b329
0000040 cee2 ab84 bfb5 f9f3 1a3c 23b8 33d1 e70c
0000060 8135 9dbb aaf8 be26 fea7 8446 bd39 6b28
0000100 7895 3f84 c07d 95a3 c79b 11e3 28cb dcdd
0000120 5e75 b945 cd8e 46c6 53b8 a0f2 dad3 a68b
0000140 5361 b5b4 09c9 8264 bf18 ede5 4177 0a5c
0000160 ddc7 4927 6b24 80c9 8f4c 76ac 1ae3 1df9
0000200 b477 3be0 c60a 9355 53e0 925f 4b8d 162c
0000220 2431 788f 4024 16ae 226e 51c4 6b85 392d
0000240 5283 a918 b97a c85c 7b34 e341 7689 0468
0000260 a4f1 a94a 0798 e5e3 435a 5ee4 3ab4 af1c
0000300 426a e484 7d2e 4e37 f2ef 95b3 fcf5 8fc8
0000320 a9d2 e50d 61ae 76bd 5ad9 6d00 67c3 3fcc
0000340 a610 7edd fe05 46bf 78c1 c70b 1829 11b7
0000360 9a34 c496 5161 c546 43cd 7eb8 ff70 473a
x
0000400 3bf1 6176 7e4b f1ce 1e3c b747 4b16 8406
0000420 1e48 d38f ad9d edf0 11c6 fa63 6a7f b973
0000440 c90b 6745 be94 8090 d547 3c78 a8c9 ea94
0000460 498d 3115 cc88 8fb7 4f1d 8c1e f947 64d2
0000500 278f 2899 d2f1 d22f fcf0 7523 e3c7 a66e
0000520 a269 cac4 ae3d e551 1339 4d14 c0aa 52bc
0000540 b320 e0ed 46a7 bb93 1397 574c 1ed5 278f
0000560 8487 48d8 e24b 8882 9eef f64c 4c9a d916
0000600 d391 ddf8 4e13 4572 58e4 abcc 6f48 9c7e
0000620 4dda 2aa6 c8f2 4ac8 7002 a33b db8d fd00
0000640 3f4c 1cd1 89cf fa98 5692 b426 5b53 5e7e
0000660 7129 cf5f e3c8 fcf1 b378 1e31 de4f a0d7
0000700 9276 532d 3885 3bb1 93ca 87b8 2804 7d0b
0000720 68ec bc9b 624a 7249 3788 4d20 d5ac ecf6
0000740 2122 bbb8 dc49 2759 27b9 03a8 7ffa 5b6a
0000760 7ad1 a846 d795 6cfe bc1e c014 442a a93d
0001000

$ xfs_bmap -v badfile
badfile:
 EXT: FILE-OFFSET           BLOCK-RANGE                 AG AG-OFFSET                   TOTAL FLAGS
   0: [0..31743]:           281349379072..281349410815 131 (29155328..29187071)        31744 000011
   1: [31744..64511]:       281351100416..281351133183 131 (30876672..30909439)        32768 000011
   2: [64512..130047]:      281383613440..281383678975 131 (63389696..63455231)        65536 000011
   3: [130048..523263]:     281479251968..281479645183 131 (159028224..159421439)     393216 000011
   4: [523264..1047551]:    281513342976..281513867263 131 (193119232..193643519)     524288 000011
   5: [1047552..2096127]:   281627355136..281628403711 131 (307131392..308179967)    1048576 000011
   6: [2096128..5421055]:   281882829824..281886154751 131 (562606080..565931007)    3324928 000011
   7: [5421056..8386943]:   281904449536..281907415423 131 (584225792..587191679)    2965888 000111
   8: [8386944..8388543]:   281970693120..281970694719 131 (650469376..650470975)       1600 000111
   9: [8388544..8585215]:   281974888448..281975085119 131 (654664704..654861375)     196672 000111
  10: [8585216..9371647]:   281977619456..281978405887 131 (657395712..658182143)     786432 000011
  11: [9371648..12517375]:  281970695168..281973840895 131 (650471424..653617151)    3145728 000011
  12: [12517376..16465919]: 282179899392..282183847935 131 (859675648..863624191)    3948544 000011
  13: [16465920..20660223]: 282295112704..282299307007 131 (974888960..979083263)    4194304 000011
  14: [20660224..29048831]: 282533269504..282541658111 131 (1213045760..1221434367)  8388608 000010
  15: [29048832..45826039]: 286146131968..286162909175 133 (530942976..547720183)   16777208 000111
  16: [45826040..58243047]: 289315926016..289328343023 134 (1553254400..1565671407) 12417008 000111
  17: [58243048..61000959]: 294169719808..294172477719 136 (2112082944..2114840855)  2757912 000111

I.e. the corruption (in 512b sector 53906431) occurs part way through
extent 16, and not on an ag boundary.

Just to make sure we're not hitting some other boundary on the
underlying infrastructure, which might hint the problem could be there,
let's see where the file sector lies...

>From extent 16, the actual corrupt sector offset within the lv device
underneath xfs is:

289315926016 + (53906431 - 45826040) == 289324006407

Then we can look at the devices underneath the lv:

# lvs --units s -o lv_name,seg_start,seg_size,devices
  LV    Start         SSize         Devices
  bigfs            0S 105486999552S /dev/md0(0)
  bigfs 105486999552S 105487007744S /dev/md4(0)
  bigfs 210974007296S 105487007744S /dev/md9(0)
  bigfs 316461015040S  35160866816S /dev/md1(0)
  bigfs 351621881856S 105487007744S /dev/md5(0)
  bigfs 457108889600S  70323920896S /dev/md3(0)

Comparing our corrupt sector lv offset with the start sector of each md
device, we can see the corrupt sector is within /dev/md9 and not at a
boundary. The corrupt sector offset within the lv data on md9 is given
by:

289324006407 - 210974007296 == 78349999111

The lv data itself is offset within /dev/md9 and the offset can be seen
by:

# pvs --unit s -o pv_name,pe_start
  PV         1st PE
  /dev/md0     9216S
  /dev/md1     9216S
  /dev/md3     9216S
  /dev/md4     9216S
  /dev/md5     9216S
  /dev/md9     9216S

...so the lv data starts at sector 9216 of the md, which means the
corrupt sector is at this offset within /dev/md9:

9216 + 78349999111 == 78350008327

Confirm the calculations are correct by comparing the corrupt sector
from the file with the calculated sector on the md device:

# {
  dd if=badfile of=/tmp/foo.1 bs=512 skip=53906431 count=1
  dd if=/dev/md9 of=/tmp/foo.2 bs=512 skip=78350008327 count=1
  cmp /tmp/foo.{1,2} && echo "got it" || echo "try again"
}
got it

----------------------------------------------------------------------


I'd appreciate some pointers towards tracking down what's going on - or
even better, which version of linux I should upgrade to to make the
problem disappear!

Cheers,

Chris.
