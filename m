Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 16 Jul 2008 00:34:17 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m6G7YFA2010769
	for <xfs@oss.sgi.com>; Wed, 16 Jul 2008 00:34:15 -0700
Received: from ipmail01.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8570018DB3E0
	for <xfs@oss.sgi.com>; Wed, 16 Jul 2008 00:35:21 -0700 (PDT)
Received: from ipmail01.adl6.internode.on.net (ipmail01.adl6.internode.on.net [203.16.214.146]) by cuda.sgi.com with ESMTP id VMuWqaN7ZMpuBaGo for <xfs@oss.sgi.com>; Wed, 16 Jul 2008 00:35:21 -0700 (PDT)
Date: Wed, 16 Jul 2008 17:35:03 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Power loss causes bad magic number??
Message-ID: <20080716073503.GE29319@disturbed>
References: <F46A887185FC6044A7FAC577E31118AE022316C0@rsbne01.RSBNE.LOCAL> <487D5F80.1050909@sandeen.net> <F46A887185FC6044A7FAC577E31118AE021E0623@rsbne01.RSBNE.LOCAL>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <F46A887185FC6044A7FAC577E31118AE021E0623@rsbne01.RSBNE.LOCAL>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Stephen Porter <stephenp@r-s.com.au>
Cc: Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com

On Wed, Jul 16, 2008 at 05:01:56PM +1000, Stephen Porter wrote:
> Hi Eric,
> 
> It's not an in-kernel driver, I need to rebuild it each time the kernel is updated.
> 
> The output of the dd command follows:
> 
> $ sudo dd if=/dev/sdc bs=512 count=128 iflag=direct | hexdump -C | grep XFSB
> 128+0 records in
> 128+0 records out
> 65536 bytes (66 kB) copied, 0.0241381 s, 2.7 MB/s
> 
> I thought the XFSB marked the start of the superblock... and it not being there would be a Bad Thing??
> 
> without the "| grep XFSB" the output looks like:
> 
> $ sudo dd if=/dev/sdc bs=512 count=128 iflag=direct | hexdump -C
> 00000000  33 c0 8e d0 bc 00 7c fb  50 07 50 1f fc be 1b 7c  |3.....|.P.P....||
> 00000010  bf 1b 06 50 57 b9 e5 01  f3 a4 cb bd be 07 b1 04  |...PW...........|
> 00000020  38 6e 00 7c 09 75 13 83  c5 10 e2 f4 cd 18 8b f5  |8n.|.u..........|
> 00000030  83 c6 10 49 74 19 38 2c  74 f6 a0 b5 07 b4 07 8b  |...It.8,t.......|
> 00000040  f0 ac 3c 00 74 fc bb 07  00 b4 0e cd 10 eb f2 88  |..<.t...........|
> 00000050  4e 10 e8 46 00 73 2a fe  46 10 80 7e 04 0b 74 0b  |N..F.s*.F..~..t.|
> 00000060  80 7e 04 0c 74 05 a0 b6  07 75 d2 80 46 02 06 83  |.~..t....u..F...|
> 00000070  46 08 06 83 56 0a 00 e8  21 00 73 05 a0 b6 07 eb  |F...V...!.s.....|
> 00000080  bc 81 3e fe 7d 55 aa 74  0b 80 7e 10 00 74 c8 a0  |..>.}U.t..~..t..|
> 00000090  b7 07 eb a9 8b fc 1e 57  8b f5 cb bf 05 00 8a 56  |.......W.......V|
> 000000a0  00 b4 08 cd 13 72 23 8a  c1 24 3f 98 8a de 8a fc  |.....r#..$?.....|
> 000000b0  43 f7 e3 8b d1 86 d6 b1  06 d2 ee 42 f7 e2 39 56  |C..........B..9V|
> 000000c0  0a 77 23 72 05 39 46 08  73 1c b8 01 02 bb 00 7c  |.w#r.9F.s......||
> 000000d0  8b 4e 02 8b 56 00 cd 13  73 51 4f 74 4e 32 e4 8a  |.N..V...sQOtN2..|
> 000000e0  56 00 cd 13 eb e4 8a 56  00 60 bb aa 55 b4 41 cd  |V......V.`..U.A.|
> 000000f0  13 72 36 81 fb 55 aa 75  30 f6 c1 01 74 2b 61 60  |.r6..U.u0...t+a`|
> 00000100  6a 00 6a 00 ff 76 0a ff  76 08 6a 00 68 00 7c 6a  |j.j..v..v.j.h.|j|
> 00000110  01 6a 10 b4 42 8b f4 cd  13 61 61 73 0e 4f 74 0b  |.j..B....aas.Ot.|
> 00000120  32 e4 8a 56 00 cd 13 eb  d6 61 f9 c3 49 6e 76 61  |2..V.....a..Inva|
> 00000130  6c 69 64 20 70 61 72 74  69 74 69 6f 6e 20 74 61  |lid partition ta|
> 00000140  62 6c 65 00 45 72 72 6f  72 20 6c 6f 61 64 69 6e  |ble.Error loadin|
> 00000150  67 20 6f 70 65 72 61 74  69 6e 67 20 73 79 73 74  |g operating syst|
> 00000160  65 6d 00 4d 69 73 73 69  6e 67 20 6f 70 65 72 61  |em.Missing opera|
> 00000170  74 69 6e 67 20 73 79 73  74 65 6d 00 00 00 00 00  |ting system.....|
> 00000180  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|

That looks like a boot loader.

> *
> 000001b0  00 00 00 00 00 2c 44 63  9d 08 9e 08 00 00 00 01  |.....,Dc........|
> 000001c0  01 00 fd fe 3f 3c 3f 00  00 00 be f3 0e 00 00 00  |....?<?.........|
> 000001d0  01 3d fd fe ff ff fd f3  0e 00 e5 cb 40 0e 00 00  |.=..........@...|
> 000001e0  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
> 000001f0  00 00 00 00 00 00 00 00  00 00 00 00 00 00 55 aa  |..............U.|
> 00000200  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|

And at 0x200 I'd expect to see an AGF header, not zeros. To
me, that says that either XFS is inside a partition on the drive
or someone ran a partitioning tool on /dev/sdc and overwrote the
XFS filesystem headers...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
