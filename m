Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q2TMFJqG200632 for <xfs@oss.sgi.com>; Thu, 29 Mar 2012 17:15:19 -0500
Received: from mho-01-ewr.mailhop.org (mho-01-ewr.mailhop.org [204.13.248.71])
	by cuda.sgi.com with ESMTP id BVJrd5NkRZZmg9ap (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 29 Mar 2012 15:15:17 -0700 (PDT)
From: "Kirk Anderson" <kirkande@tx.rr.com>
References: <004b01cd0d3f$c6d4fbc0$547ef340$@tx.rr.com>
	<20120329064054.GP5091@dastard>
	<002501cd0dbe$24be21c0$6e3a6540$@tx.rr.com>
	<20120329213100.GA18323@dastard>
In-Reply-To: <20120329213100.GA18323@dastard>
Subject: RE: Buffalo LS-Q4.0 Raid 5 XFS errors
Date: Thu, 29 Mar 2012 17:15:08 -0500
Message-ID: <005101cd0df9$67f61250$37e236f0$@tx.rr.com>
MIME-Version: 1.0
Content-Language: en-us
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: 'Dave Chinner' <david@fromorbit.com>
Cc: xfs@oss.sgi.com

Thank you again for your help.  Please let me know what my next step should
be.

Here is the output from the dd command.  My understanding is that I use the
/dev/sd[a-d]6 for mine as the  cat /proc/mdstat indicated that 
md2 : active raid5 sda6[0] sdd6[3] sdc6[2] sdb6[1]
      2906278656 blocks level 5, 64k chunk, algorithm 2 [4/4] [UUUU]

root@LS-QLF55:~# dd if=/dev/sda6 bs=512 count=1 2> /dev/null | hexdump -C
00000000  58 46 53 42 00 00 10 00  00 00 00 00 2b 4e 92 c0
|XFSB........+N..|
00000010  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00
|................|
00000020  1b 5a c5 ad cc e3 40 11  87 4d f5 8e 9b f8 37 c0
|.Z....@..M....7.|
00000030  00 00 00 00 20 00 00 07  00 00 00 00 00 00 01 00  |....
...........|
00000040  00 00 00 00 00 00 01 01  00 00 00 00 00 00 01 02
|................|
00000050  00 00 00 30 01 5a 74 a0  00 00 00 20 00 00 00 00  |...0.Zt....
....|
00000060  00 00 80 00 3d 84 10 00  01 00 00 10 00 00 00 00
|....=...........|
00000070  00 00 00 00 00 00 00 00  0c 0c 08 04 19 00 00 19
|................|
00000080  00 00 00 00 00 04 50 c0  00 00 00 00 00 00 02 ce
|......P.........|
00000090  00 00 00 00 0b ba 45 ab  00 00 00 00 00 00 00 00
|......E.........|
000000a0  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00
|................|
000000b0  00 00 00 00 00 00 00 02  00 00 00 10 00 00 00 30
|...............0|
000000c0  00 0c 10 00 00 00 10 00  00 00 00 00 00 00 00 00
|................|
000000d0  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00
|................|

root@LS-QLF55:~# dd if=/dev/sdb6 bs=512 count=1 2> /dev/null | hexdump -C
00000000  00 00 00 00 00 00 59 91  8c 3c b8 15 8c 3c ee 97
|......Y..<...<..|
00000010  8b 3c 91 18 8b 3c a2 97  8a 3c 22 15 8a 3c 14 91
|.<...<...<"..<..|
00000020  89 3c 78 0b 89 3c 50 84  88 3c 9e fb 87 3c 64 71
|.<x..<P..<...<dq|
00000030  87 3c a3 e5 86 3c 5d 58  86 3c 94 c9 85 3c 4a 39
|.<...<]X.<...<J9|
00000040  85 3c 80 a7 84 3c 38 14  84 3c 73 7f 83 3c 35 e9
|.<...<8..<s..<5.|
00000050  82 3c 7e 51 82 3c 50 b8  81 3c ad 1d 81 3c 97 81
|.<~Q.<P..<...<..|
00000060  80 3c 22 c8 7f 3c 36 8a  7e 3c 70 49 7d 3c d4 05
|.<"..<6.~<pI}<..|
00000070  7c 3c 65 bf 7a 3c 27 76  79 3c 1f 2a 78 3c 50 db
||<e.z<'vy<.*x<P.|
00000080  76 3c be 89 75 3c 6e 35  74 3c 63 de 72 3c a2 84
|v<..u<n5t<c.r<..|
00000090  71 3c 2f 28 70 3c 0d c9  6e 3c 42 67 6d 3c d2 02
|q</(p<..n<Bgm<..|
000000a0  6c 3c c0 9b 6a 3c 11 32  69 3c ca c5 67 3c ee 56
|l<..j<.2i<..g<.V|
000000b0  66 3c 83 e5 64 3c 8c 71  63 3c 0e fb 61 3c 0e 82
|f<..d<.qc<..a<..|
000000c0  60 3c 90 06 5f 3c 98 88  5d 3c 2b 08 5c 3c 4f 85
|`<.._<..]<+.\<O.|
000000d0  5a 3c 06 00 59 3c 56 78  57 3c 44 ee 55 3c d5 61
|Z<..Y<VxW<D.U<.a|
000000e0  54 3c 0c d3 52 3c f0 41  51 3c 83 ae 4f 3c cd 18
|T<..R<.AQ<..O<..|
000000f0  4e 3c d0 80 4c 3c 92 e6  4a 3c 19 4a 49 3c 68 ab
|N<..L<..J<.JI<h.|
00000100  47 3c 85 0a 46 3c 75 67  44 3c 3c c2 42 3c e0 1a
|G<..F<ugD<<.B<..|
00000110  41 3c 65 71 3f 3c d2 c5  3d 3c 2a 18 3c 3c 73 68
|A<eq?<..=<*.<<sh|
00000120  3a 3c b1 b6 38 3c eb 02  37 3c 25 4d 35 3c 65 95
|:<..8<..7<%M5<e.|
00000130  33 3c af db 31 3c 09 20  30 3c 78 62 2e 3c 02 a3  |3<..1<.
0<xb.<..|
00000140  2c 3c ab e1 2a 3c 79 1e  29 3c 71 59 27 3c 98 92
|,<..*<y.)<qY'<..|
00000150  25 3c f5 c9 23 3c 8c ff  21 3c 62 33 20 3c 7e 65  |%<..#<..!<b3
<~e|
00000160  1e 3c e4 95 1c 3c 9a c4  1a 3c a6 f1 18 3c 0d 1d
|.<...<...<...<..|
00000170  17 3c d4 46 15 3c 01 6f  13 3c 99 95 11 3c a3 ba
|.<.F.<.o.<...<..|
00000180  0f 3c 23 de 0d 3c 1f 00  0c 3c 9e 20 0a 3c a3 3f  |.<#..<...<.
.<.?|
00000190  08 3c 36 5d 06 3c 5c 79  04 3c 1a 94 02 3c 76 ad
|.<6].<\y.<...<v.|
000001a0  00 3c eb 8a fd 3b 3e b8  f9 3b ef e2 f5 3b 0a 0b
|.<...;>..;...;..|
000001b0  f2 3b 9a 30 ee 3b ac 53  ea 3b 4a 74 e6 3b 80 92
|.;.0.;.S.;Jt.;..|
000001c0  e2 3b 59 ae de 3b e2 c7  da 3b 26 df d6 3b 31 f4
|.;Y..;...;&..;1.|
000001d0  d2 3b 0e 07 cf 3b c9 17  cb 3b 6e 26 c7 3b 08 33
|.;...;...;n&.;.3|
000001e0  c3 3b a4 3d bf 3b 4d 46  bb 3b 0f 4d b7 3b f6 51
|.;.=.;MF.;.M.;.Q|
000001f0  b3 3b 0d 55 af 3b 61 56  ab 3b fe 55 a7 3b ef 53
|.;.U.;aV.;.U.;.S|
00000200

root@LS-QLF55:~# dd if=/dev/sdc6 bs=512 count=1 2> /dev/null | hexdump -C
00000000  18 af 00 20 27 af 00 90  35 af 00 18 44 af 00 88  |...
'...5...D...|
00000010  52 af 00 f8 60 af 00 68  6f af 00 d8 7d af 00 20  |R...`..ho...}..
|
00000020  86 af 00 54 8d af 00 80  94 af 00 b0 9b af 00 d8
|...T............|
00000030  a2 af 00 04 aa af 00 2c  b1 af 00 50 b8 af 00 70
|.......,...P...p|
00000040  bf af 00 90 c6 af 00 a8  cd af 00 c8 d4 af 00 d8
|................|
00000050  db af 00 f0 e2 af 00 00  ea af 00 0c f1 af 00 14
|................|
00000060  f8 af 00 1c ff af 00 10  03 b0 00 90 06 b0 00 0e
|................|
00000070  0a b0 00 8a 0d b0 00 04  11 b0 00 7c 14 b0 00 f4
|...........|....|
00000080  17 b0 00 68 1b b0 00 da  1e b0 00 4c 22 b0 00 ba
|...h.......L"...|
00000090  25 b0 00 24 29 b0 00 90  2c b0 00 f8 2f b0 00 5e
|%..$)...,.../..^|
000000a0  33 b0 00 c0 36 b0 00 22  3a b0 00 80 3d b0 00 dc
|3...6..":...=...|
000000b0  40 b0 00 36 44 b0 00 8e  47 b0 00 e2 4a b0 00 36
|@..6D...G...J..6|
000000c0  4e b0 00 84 51 b0 00 d0  54 b0 00 1c 58 b0 00 64
|N...Q...T...X..d|
000000d0  5b b0 00 a8 5e b0 00 ea  61 b0 00 28 65 b0 00 66
|[...^...a..(e..f|
000000e0  68 b0 00 a0 6b b0 00 d6  6e b0 00 0a 72 b0 00 3a
|h...k...n...r..:|
000000f0  75 b0 00 68 78 b0 00 94  7b b0 00 ba 7e b0 00 ef
|u..hx...{...~...|
00000100  80 b0 00 80 82 b0 00 0e  84 b0 00 9c 85 b0 00 28
|...............(|
00000110  87 b0 00 b2 88 b0 00 3a  8a b0 00 c1 8b b0 00 46
|.......:.......F|
00000120  8d b0 00 c9 8e b0 00 4a  90 b0 00 ca 91 b0 00 48
|.......J.......H|
00000130  93 b0 00 c5 94 b0 00 3e  96 b0 00 b7 97 b0 00 2e
|.......>........|
00000140  99 b0 00 a3 9a b0 00 16  9c b0 00 86 9d b0 00 f6
|................|
00000150  9e b0 00 63 a0 b0 00 ce  a1 b0 80 37 a3 b0 00 9f
|...c.......7....|
00000160  a4 b0 00 04 a6 b0 80 67  a7 5c 08 00 b3 a8 b0 00
|.......g.\......|
00000170  28 aa b0 80 85 ab b0 80  e0 ac b0 80 39 ae b0 00
|(...........9...|
00000180  91 af b0 80 e5 b0 b0 00  38 b2 b0 00 89 b3 b0 80
|........8.......|
00000190  d7 b4 b0 80 23 b6 b0 00  6e b7 b0 80 b5 b8 b0 80
|....#...n.......|
000001a0  fb b9 b0 00 3f bb b0 00  80 bc b0 00 bf bd b0 00
|....?...........|
000001b0  fc be b0 80 36 c0 b0 00  6e c1 b0 80 a4 c2 b0 00
|....6...n.......|
000001c0  d8 c3 b0 00 09 c5 b0 80  37 c6 b0 80 64 c7 b0 00
|........7...d...|
000001d0  8e c8 b0 80 b6 c9 b0 00  db ca b0 80 fe cb b0 00
|................|
000001e0  1f cd b0 80 3c ce b0 80  58 cf b0 80 71 d0 b0 00
|....<...X...q...|
000001f0  88 d1 b0 80 9c d2 b0 00  ae d3 b0 80 bd d4 b0 80
|................|
00000200

root@LS-QLF55:~# dd if=/dev/sdd6 bs=512 count=1 2> /dev/null | hexdump -C
00000000  40 e9 53 62 27 af 49 01  b9 93 b8 0d e3 dd 7c df
|@.Sb'.I.......|.|
00000010  d9 93 91 e0 eb 93 a2 ff  e5 93 22 cd f7 93 14 b1
|..........".....|
00000020  14 c9 bd f2 c8 70 10 15  9b de 6b c5 87 6b 53 69
|.....p....k..kSi|
00000030  25 93 a3 e1 0c 93 5d 73  37 93 94 99 3d 93 4b 49
|%.....]s7...=.KI|
00000040  3a 93 80 37 42 93 39 bd  49 93 73 b7 57 93 34 33
|:..7B.9.I.s.W.43|
00000050  59 93 7e 91 61 c9 24 18  6b 93 ad 31 70 93 97 95
|Y.~.a.$.k..1p...|
00000060  78 93 a2 d4 bd 17 26 9a  7c 8c 70 c9 7b 8c d4 0b
|x.....&.|.p.{...|
00000070  76 8c 65 35 77 8c 27 72  64 80 17 52 75 8c 50 36
|v.e5w.'rd..Ru.P6|
00000080  61 8c be e1 6e 88 3e 2f  6a 8c 63 92 50 8c a0 f0
|a...n.>/j.c.P...|
00000090  54 8c 2f 0c 52 36 48 f2  42 8c 42 9f 42 8c d2 5c
|T./.R6H.B.B.B..\|
000000a0  5f 8c c0 5b 5c 8c 11 10  53 8c ca 45 5a 8c ee 8a
|_..[\...S..EZ...|
000000b0  26 8c 83 d3 20 8c 8c fd  24 8c 0e 09 2b 8c 0e 84  |&...
...$...+...|
000000c0  2e 80 80 82 0e 8c 88 58  09 8c 2b 14 04 8c 4f e1
|.......X..+...O.|
000000d0  01 8c 06 a8 07 8c 56 92  36 8c 44 c6 30 8c d5 07
|......V.6.D.0...|
000000e0  3c 8c 0c 73 39 8c f0 97  3f 8c 83 a4 3d 8c cd 22
|<..s9...?...=.."|
000000f0  3b 8c d0 e8 34 8c 92 72  31 8c 19 f0 37 8c 68 44
|;...4..r1...7.hD|
00000100  c7 8c 85 8a c4 8c 75 69  c0 8c 3c 5e c7 8c e0 32
|......ui..<^...2|
00000110  c6 8c 65 c3 b7 8c d2 ff  b7 8c 2a d9 b7 8c 73 2e
|..e.......*...s.|
00000120  b7 8c b1 7f b6 8c eb 48  a7 8c 25 87 a4 8c 65 dd
|.......H..%...e.|
00000130  a0 8c af 1e a5 8c 09 1e  a6 8c 78 d5 b9 8c 02 8d
|..........x.....|
00000140  b5 8c ab 42 b0 8c 79 08  b5 8c 71 df ba 8c 98 64
|...B..y...q....d|
00000150  bb 8c f5 aa 83 8c 8c 31  80 8c e2 04 83 8c 7e fa
|.......1......~.|
00000160  ba 8c e4 91 ba 8c 1a a3  bd 60 ae f1 ab 94 bd 1d
|.........`......|
00000170  3f 96 64 c6 90 97 b1 ef  f3 90 29 15 28 92 13 ba
|?.d.......).(...|
00000180  9e 93 93 5e e8 8c af 00  34 8e 2e 20 83 8f 13 bf  |...^....4..
....|
00000190  df 88 86 dd 25 8a ec 79  6a 8b aa 14 b7 84 c6 2d
|....%..yj......-|
000001a0  fb 85 5b 8a c2 80 8e b8  79 87 5f e2 4a 86 ba 0b
|..[.....y._.J...|
000001b0  0e 85 2a b0 d8 fb 1c 53  84 fa fa f4 42 f9 30 92
|..*....S....B.0.|
000001c0  3a f8 e9 ae d7 fe 52 47  ed fd 96 5f b2 fc 81 f4
|:.....RG..._....|
000001d0  5c f3 be 87 79 f2 79 17  10 f1 de a6 39 f0 b8 33
|\...y.y.....9..3|
000001e0  dc f6 14 bd 83 f5 fd c6  e3 f4 bf cd c6 eb 46 51
|..............FQ|
000001f0  3b ea bd d5 33 e9 d1 56  05 e8 4e d5 1a ef 5f d3
|;...3..V..N..._.|
00000200

-----Original Message-----
From: Dave Chinner [mailto:david@fromorbit.com] 
Sent: Thursday, March 29, 2012 4:31 PM
To: Kirk Anderson
Cc: xfs@oss.sgi.com
Subject: Re: Buffalo LS-Q4.0 Raid 5 XFS errors

On Thu, Mar 29, 2012 at 10:10:55AM -0500, Kirk Anderson wrote:
> Thank you for the reply.  I apologize as I do not know how to reply 
> back in the thread.  I ran the xfs_repair command below:

Just reply to all - the list sets up the reply-to headers automatically for
this. I've re-cc'd the list.

> xfs_repair -n /dev/md2
> 
> The output is 21,078 lines.  The first few are below.
> 
> I am just trying to make sure I do not dig this hole any deeper than 
> it has to be.  Is there anything of this that you would need to look 
> at or do I just run the xfs_repair without any flags?
> 
> I appreciate your help.   Thanks, Kirk
> 
> No modify flag set, skipping phase 5
> ..
> Phase 2 - using internal log
>         - scan filesystem freespace and inode maps...
> bad magic # 0xb5524a00 for agf 0
> bad version # -447948225 for agf 0
> bad sequence # -920712132 for agf 0

Oh, that's really bad. Something has gone disasterously wrong with your RAID
device. The first thing you ned to check is whether it got put back together
in the correct order - it may be that the disk that is supposed to be the
first in the array isn't anymore...

Have a look at the first sector of each device in the RAID array - the one
that should be first needs to have an XFS superblock in that sector. The
easy way to check that is to run:

$ sudo dd if=/dev/vda bs=512 count=1 2> /dev/null | hexdump -C
00000000  58 46 53 42 00 00 10 00  00 00 00 00 00 10 00 00
|XFSB............|
00000010  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00
|................|
00000020  27 04 1a bb 8d cc 47 ea  b4 18 be 11 84 43 e2 56
|'.....G......C.V|
00000030  00 00 00 00 00 08 00 04  00 00 00 00 00 00 00 80
|................|
00000040  00 00 00 00 00 00 00 81  00 00 00 00 00 00 00 82
|................|
00000050  00 00 00 01 00 04 00 00  00 00 00 04 00 00 00 00
|................|
00000060  00 00 0a 00 b4 b4 02 00  01 00 00 10 00 00 00 00
|................|
00000070  00 00 00 00 00 00 00 00  0c 09 08 04 12 00 00 19
|................|
00000080  00 00 00 00 00 00 2d 00  00 00 00 00 00 00 00 83
|......-.........|
00000090  00 00 00 00 00 0c 4e e8  00 00 00 00 00 00 00 00
|......N.........|
000000a0  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00
|................|
000000b0  00 00 00 00 00 00 00 02  00 00 00 00 00 00 00 00
|................|
000000c0  00 00 00 00 00 00 00 01  00 00 00 0a 00 00 00 0a
|................|
000000d0  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00
|................|
*
00000200

And the superblock has that "XFSB" magic number as the first 4 bytes of the
output.  Similarly, the second sector should contain an AGF (magic number
XAGF), the third sector an AGI (magic XAGI).

If the first device in the array does not have a XFSB at sector zero, then
the device definitely has been Sewn Back Together Wrong.

If that isn't the problem, then I think it is likely you are going to lose a
lot of data, and you should look disaster recovery tools like xfs_irecover
to extract the intact data rather than trying to repair it...

Cheers,

Dave.
--
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
