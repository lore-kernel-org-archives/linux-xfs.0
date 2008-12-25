Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mBPI4CAd022823 for <xfs@oss.sgi.com>; Thu, 25 Dec 2008 12:04:15 -0600
Received: from lucidpixels.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 91FB847F74
	for <xfs@oss.sgi.com>; Thu, 25 Dec 2008 10:04:08 -0800 (PST)
Received: from lucidpixels.com (lucidpixels.com [75.144.35.66]) by
	cuda.sgi.com with ESMTP id cp8rOKO67CDoORuE for
	<xfs@oss.sgi.com>; Thu, 25 Dec 2008 10:04:08 -0800 (PST)
Date: Thu, 25 Dec 2008 13:04:07 -0500 (EST)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: mismatch_cnt, random bitflips, silent corruption(?), mdadm/sw
	raid[156]
Message-ID: <alpine.DEB.1.10.0812250435260.12329@p34.internal.lan>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED;
	BOUNDARY="-1463747160-1756203312-1230208415=:24295"
Content-ID: <alpine.DEB.1.10.0812250741470.24295@p34.internal.lan>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
Cc: Alan Piszcz <ap@solarrain.com>, smartmontools-support@lists.sourceforge.net, xfs@oss.sgi.com

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463747160-1756203312-1230208415=:24295
Content-Type: TEXT/PLAIN; CHARSET=ISO-8859-1; FORMAT=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Content-ID: <alpine.DEB.1.10.0812250741471.24295@p34.internal.lan>

I have many backups of data from the late 1990s onward, each of which have=
=20
been combined into tar files and then encrypted with gpg, each is about 4=
=20
gigabytes so I can store them on DVD.  For quicker access, I also kept
them on software raid.  In the past, I have always kept them on either SW=
=20
RAID5 or SW RAID6 using XFS.  All of the machines in question that I=20
have/had the data on never exhibited any bad memory and all pass memtest=20
OK.  However, what is worrisome, is, on occasion, the mismatch_cnt=20
would be some crazy number on different machines, 2000 or 5000, I checked=
=20
all of the disks with smart, they appear to be OK and when I run a check=20
and repair against the raid then the count will usually go back down to=20
zero.

However, in reality, are these "mismatches" really an indication of silent=
=20
data corruption?  In my case, I have 199 of these backup files and when I=
=20
tried to unencrypt the data, I got these errors on several volumes:

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

gpg: block_filter 0x1c8e200: read error (size=3D10266,a->size=3D10266)
gpg: mdc_packet with invalid encoding
gpg: decryption failed: invalid packet
gpg: block_filter: pending bytes!
gpg: fatal: zlib inflate problem: invalid stored block lengths
secmem usage: 2368/2496 bytes in 6/7 blocks of pool 3104/32768
gpg: fatal: zlib inflate problem: invalid block type
secmem usage: 2368/2496 bytes in 6/7 blocks of pool 3104/32768
gpg: fatal: zlib inflate problem: invalid code lengths set
secmem usage: 2368/2496 bytes in 6/7 blocks of pool 3104/32768
gpg: fatal: zlib inflate problem: invalid block type
secmem usage: 2368/2496 bytes in 6/7 blocks of pool 3104/32768
gpg: fatal: zlib inflate problem: invalid block type
secmem usage: 2368/2496 bytes in 6/7 blocks of pool 3104/32768
gpg: [don't know]: invalid packet (ctb=3D1f)
gpg: [don't know]: invalid packet (ctb=3D2d)
gpg: mdc_packet with invalid encoding
gpg: decryption failed: invalid packet
gpg: [don't know]: invalid packet (ctb=3D30)
gpg: fatal: zlib inflate problem: invalid stored block lengths
secmem usage: 2368/2496 bytes in 6/7 blocks of pool 3104/32768
gpg: fatal: zlib inflate problem: invalid stored block lengths
secmem usage: 2368/2496 bytes in 6/7 blocks of pool 3104/32768
gpg: fatal: zlib inflate problem: invalid code lengths set
secmem usage: 2368/2496 bytes in 6/7 blocks of pool 3104/32768
gpg: fatal: zlib inflate problem: invalid stored block lengths
secmem usage: 2368/2496 bytes in 6/7 blocks of pool 3104/32768
gpg: fatal: zlib inflate problem: invalid distance code
secmem usage: 2368/2496 bytes in 6/7 blocks of pool 3104/32768
gpg: fatal: zlib inflate problem: invalid distance code
secmem usage: 2368/2496 bytes in 6/7 blocks of pool 3104/32768
gpg: fatal: zlib inflate problem: invalid code lengths set
secmem usage: 2368/2496 bytes in 6/7 blocks of pool 3104/32768
gpg: fatal: zlib inflate problem: invalid block type
secmem usage: 2368/2496 bytes in 6/7 blocks of pool 3104/32768

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

This resulted in partial-sized corrupted tarballs, I am decompressing each
of the 199 backups now to isolate which are affected so I can come up with
a better count on how many files were affected.

The total amount of data is:=20
832G in 199 files (4.18gig/file average)

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

Bad files (out of the 199):

Thu Dec 25 05:44:16 EST 2008: Decompressing backup038.tar
tar: Unexpected EOF in archive
tar: Unexpected EOF in archive
tar: Error is not recoverable: exiting now
Thu Dec 25 08:18:00 EST 2008: Decompressing backup103.tar
tar: Unexpected EOF in archive
tar: Unexpected EOF in archive
tar: Error is not recoverable: exiting now
Thu Dec 25 08:34:39 EST 2008: Decompressing backup111.tar
tar: Unexpected EOF in archive
tar: Unexpected EOF in archive
tar: Error is not recoverable: exiting now
Thu Dec 25 08:43:26 EST 2008: Decompressing backup115.tar
tar: Unexpected EOF in archive
tar: Unexpected EOF in archive
tar: Error is not recoverable: exiting now
Thu Dec 25 08:54:39 EST 2008: Decompressing backup120.tar
tar: Unexpected EOF in archive
tar: Unexpected EOF in archive
tar: Error is not recoverable: exiting now
Thu Dec 25 09:36:02 EST 2008: Decompressing backup137.tar
tar: Unexpected EOF in archive
tar: Unexpected EOF in archive
tar: Error is not recoverable: exiting now
Thu Dec 25 09:36:39 EST 2008: Decompressing backup138.tar
tar: Unexpected EOF in archive
tar: Unexpected EOF in archive
tar: Error is not recoverable: exiting now
Thu Dec 25 09:52:06 EST 2008: Decompressing backup145.tar
tar: Unexpected EOF in archive
tar: Unexpected EOF in archive
tar: Error is not recoverable: exiting now
Thu Dec 25 10:10:14 EST 2008: Decompressing backup153.tar
tar: Unexpected EOF in archive
tar: Unexpected EOF in archive
tar: Error is not recoverable: exiting now
Thu Dec 25 10:10:32 EST 2008: Decompressing backup154.tar
tar: Unexpected EOF in archive
tar: Unexpected EOF in archive
tar: Error is not recoverable: exiting now
Thu Dec 25 10:36:50 EST 2008: Decompressing backup166.tar
tar: Unexpected EOF in archive
tar: Unexpected EOF in archive
tar: Error is not recoverable: exiting now
Thu Dec 25 10:40:19 EST 2008: Decompressing backup168.tar
tar: Unexpected EOF in archive
tar: Unexpected EOF in archive
tar: Error is not recoverable: exiting now
Thu Dec 25 11:20:00 EST 2008: Decompressing backup181.tar
tar: Unexpected EOF in archive
tar: Unexpected EOF in archive
tar: Error is not recoverable: exiting now
Thu Dec 25 11:39:11 EST 2008: Decompressing backup187.tar
tar: Unexpected EOF in archive
tar: Unexpected EOF in archive
tar: Error is not recoverable: exiting now
Thu Dec 25 12:05:27 EST 2008: Decompressing backup194.tar
tar: Unexpected EOF in archive
tar: Unexpected EOF in archive
tar: Error is not recoverable: exiting now



=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

Example of one file:
-rw-r--r--  1 root root   40M 2008-12-24 20:08 backup038.tar
-rw-r--r--  1 root root  4.3G 2008-12-23 17:45 backup038.tar.gpg

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

I have restored the data off of DVD and confirmed the data that had=20
resided on disk must have suffered from a bit-flip/corruption:

$ md5sum backup038.tar.gpg=20
9958813aa22e4307f2101f87b8820bff  backup038.tar.gpg (from dvd)

$ md5sum backup038.tar.gpg
9437138a01fc2429ca2131f6a10295b5  backup038.tar.gpg (from disk)

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

Splitting these files up we can isolate how many corruptions occured in the
file:

dvd$ split -b 100M backup038.tar.gpg
hdd$ split -b 100M backup038.tar.gpg

$ diff dvd.md5 ../hdd/hdd.md5=20
1c1
< 9dfcab90fd6590705ba4293994f10a85  xaa
---
> cce57047ac869ef3e603d4d6bd3579e9  xaa

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

Dig further:
$ mv xaa dvd.xaa
$ mv xaa hdd.xaa

$ split -b 1M dvd.xaa=20
$ split -b 1M hdd.xaa

$ diff dvd.md5  ../../hdd/xaa_split/hdd.md5=20
40c40
< 439e4291ea67240c0b083abe5f041319  xbn
---
> 95e548284fa78f750b50f3e6a8e1b847  xbn

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

Further..
$ split -a 100 -b 1k dvd.xbn=20
$ split -a 100 -b 1k hdd.xbn

$ diff dvd.md5  ../../../hdd/xaa_split/xbn_split/hdd.md5 |wc
     132     392   17960

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

Quite a big 'chunk' of the file suffered corruption.

$ diff dvd.md5  ../../../hdd/xaa_split/xbn_split/hdd.md5 | awk '{print $3}'=
 | xargs -n1 ls  | xargs du -ach
520K    total

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

dvd$ md5sum one_part_with_corruption
c131c2f7dea3c316cbcd2c26360e4b03  one_part_with_corruption
hdd$ md5sum one_part_with_corruption
35968f907c5e6f986d9c5a171dd0a7ac  one_part_with_corruption

Taking an octal dump and checking the ASCII characters:

dvd:
< 0000000 034   =E5   =E2 201   f   =AE   =E7   =B9   e   D 221   =CA   =C1=
  \b   =F7   $
< 0000020   >   p   M   | 212 236 034   =D8  \b   =FF   z   =E5   =ED  \a  =
 =C8   i
< 0000040 212  \f   =E7   ] 200   l   =AA 234   Y 224   =B3   =E9   =FB   =
=F3   =CC=20
< 0000060 233   }   G   =E4   W   : 236   b   =B0   } 215   ) 224   R   R  =
 =B8
< 0000100 237   =A8   =BE 227   =DA   1   =A4   O   =E7   =FD 003 177   $  =
 e 032   =C1
< 0000120   !   ^   j   =DE 235   8   5   a   J   =A1   =F6   <   =C6   H 2=
23   =D5

hdd:
> 0000000  \r   =C6   =A6 033 034   =E5   =E2 201   f   =AE   =E7   =B9   e=
   D 221   =CA
> 0000020   =C1  \b   =F7   $   >   p   M   | 212 236 034   =D8  \b   =FF  =
 z   =E5
> 0000040   =ED  \a   =C8   i 212  \f   =E7   ] 200   l   =AA 234   Y 224  =
 =B3   =E9
> 0000060   =FB   =F3   =CC     233   }   G   =E4   W   : 236   b   =B0   }=
 215   )
> 0000100 224   R   R   =B8 237   =A8   =BE 227   =DA   1   =A4   O   =E7  =
 =FD 003 177
> 0000120   $   e 032   =C1   !   ^   j   =DE 235   8   5   a   J   =A1   =
=F6   <

The hdd image seems 'shifted' see the following sequence: (201..f..R..c) on
the first line.

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

So the question then becomes where did the shift begin?  Way above we see
the initial error began on xaa (100M) -> xbn (1M)

dvd$ md5sum xbm
2524788769acf2b0f98346f488a58441  xbm
hdd$ md5sum xbm
2524788769acf2b0f98346f488a58441  xbm

So then we want to take an od of xbn and then diff that:

It starts at the following segment:

dvd:
< 2006000   =FB   r 222 235   =A9   z   8   d 035   =B4 230   # 207   =CD  =
 =F5   u

hdd:
> 2006000   =FB   r 222 235   =FB   r 222 235   =A9   z   8   d 035   =B4 2=
30   #

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

So let's look at it a few lines before as well:

dvd:
2005720   '   0   =C3 001   =F2   =BB   [   ( 037 024   . 211   M 023 001  =
 =C3
2005740   V 021   \   =D0   Y   =C7   =D6 207 206   =AC   n   =AC 234   z  =
 =AF 034
2005760   =BF 206 002   +   w   =CE 200   =CE   3   =E8   =C0   K   $   =EA=
   e   n
2006000   =FB   r 222 235   =A9   z   8   d 035   =B4 230   # 207   =CD   =
=F5   u
2006020   R   =AF   =CD 025   =C1   =BC 022   =F6 024   =AF 200   Q 217   =
=C3   =AF   =A3
2006040 203   =AD   =F4   c   3   =ED 207   #   ]   =C4   =F4   H   (   =FD=
   5 207
2006060   =EB   C   C   a   @  \r 200   =DC   =E2   =A1  \r 204 230   U   =
=E6   O

hdd:
2005720   '   0   =C3 001   =F2   =BB   [   ( 037 024   . 211   M 023 001  =
 =C3
2005740   V 021   \   =D0   Y   =C7   =D6 207 206   =AC   n   =AC 234   z  =
 =AF 034
2005760   =BF 206 002   +   w   =CE 200   =CE   3   =E8   =C0   K   $   =EA=
   e   n
2006000   =FB   r 222 235   =FB   r 222 235   =A9   z   8   d 035   =B4 230=
   #
2006020 207   =CD   =F5   u   R   =AF   =CD 025   =C1   =BC 022   =F6 024  =
 =AF 200   Q
2006040 217   =C3   =AF   =A3 203   =AD   =F4   c   3   =ED 207   #   ]   =
=C4   =F4   H
2006060   (   =FD   5 207   =EB   C   C   a   @  \r 200   =DC   =E2   =A1  =
\r 204

The same sequence still seems to exist after the flip for the 5th character
on line 2006000.

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

On the linux-raid mailing list, this issue is often discussed:
http://www.mail-archive.com/linux-raid@vger.kernel.org/msg07541.html

The solution seems to be repair and keep on trucking along, which is=20
probably fine for a filesystem with hundreds/thousands of files, most=20
likely, you would never notice the corruption.  However, with gpg, the files
obviously cannot suffer any corruption. It is only when I tried to extract =
the=20
data did I notice this problem.

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

=3D=3D server 1 (965 chipset) =3D=3D
Root filesystem (Raid-1):
Sat Nov 15 11:39:03 EST 2008: cat /sys/block/md2/md/mismatch_cnt
Sat Nov 15 11:39:03 EST 2008: 128

Storage array (Raid-6):
Wed Nov 26 10:14:21 EST 2008: cat /sys/block/md3/md/mismatch_cnt
Wed Nov 26 10:14:21 EST 2008: 1208

=3D=3D server 2 (p35-chipset) =3D=3D
Swap (Raid-1): I understand this is 'normal' for swap:
Fri Jan 18 22:51:47 EST 2008: cat /sys/block/md0/md/mismatch_cnt
Fri Jan 18 22:51:47 EST 2008: 4096
Fri May 30 21:00:07 EDT 2008: cat /sys/block/md0/md/mismatch_cnt
Fri May 30 21:00:07 EDT 2008: 896
Fri Nov 14 23:30:10 EST 2008: cat /sys/block/md0/md/mismatch_cnt
Fri Nov 14 23:30:10 EST 2008: 384

=3D=3D server 3 (also 965 chipset) =3D=3D
Root filesystem (Raid-1):
Fri May 18 20:50:05 EDT 2007: cat /sys/block/md2/md/mismatch_cnt
Fri May 18 20:50:05 EDT 2007: 128
Sat May 26 04:40:09 EDT 2007: cat /sys/block/md2/md/mismatch_cnt
Sat May 26 04:40:09 EDT 2007: 128

Swap (Raid-1): Again, normal but a very high mismatch_cnt:
Fri Oct  5 20:50:05 EDT 2007: cat /sys/block/md0/md/mismatch_cnt
Fri Oct  5 20:50:05 EDT 2007: 27904

Storage array (RAID-5)
Fri Apr  4 22:00:09 EDT 2008: cat /sys/block/md3/md/mismatch_cnt
Fri Apr  4 22:00:09 EDT 2008: 512
Fri May 23 22:00:10 EDT 2008: cat /sys/block/md3/md/mismatch_cnt
Fri May 23 22:00:10 EDT 2008: 256

=3D=3D server 4 (intel 875 chipset, raid-5)
# grep mismatches\ found *
daemon.log:Jan  3 11:27:27 p26 mdadm: RebuildFinished event detected on md =
device /dev/md0, component device  mismatches found: 11896
daemon.log:Nov 14 12:25:59 p26 mdadm[1956]: RebuildFinished event detected =
on md device /dev/md0, component device  mismatches found: 11664
daemon.log:Nov 14 18:19:01 p26 mdadm[1956]: RebuildFinished event detected =
on md device /dev/md0, component device  mismatches found: 11664
syslog:Jan  3 11:27:27 p26 mdadm: RebuildFinished event detected on md devi=
ce /dev/md0, component device  mismatches found: 11896
syslog:Nov 14 12:25:59 p26 mdadm[1956]: RebuildFinished event detected on m=
d device /dev/md0, component device  mismatches found: 11664
syslog:Nov 14 18:19:01 p26 mdadm[1956]: RebuildFinished event detected on m=
d device /dev/md0, component device  mismatches found: 11664

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

Options/alternatives for maintaining data integrity?

1. Obviously DVD and/or LTO-tape (multiple copies of data at rest)
http://epoka.dk/media/Linear_Tape_Open_(LTO)_Ultrium_Data_Cartridges.pdf
-> For LTO-2/LTO-3
-> Uncorrected bit error rate 1x10-17 1x10-17
-> Undetected bit error rate 1x10-27 1x10-27

2. ZFS, but only runs in user-space in Linux.

3. Keep an md5sum for each file on the filesystem and run daily checks?

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

Other options?

How do others maintain data integrity?  Just not worry about it until you h=
ave
to, rely on backups.. or?

Justin.
---1463747160-1756203312-1230208415=:24295
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

---1463747160-1756203312-1230208415=:24295--
