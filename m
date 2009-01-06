Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	n06I4EU9001400 for <xfs@oss.sgi.com>; Tue, 6 Jan 2009 12:04:15 -0600
Received: from rv-out-0708.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 066D917B1B07
	for <xfs@oss.sgi.com>; Tue,  6 Jan 2009 10:04:13 -0800 (PST)
Received: from rv-out-0708.google.com (rv-out-0708.google.com
	[209.85.198.242]) by cuda.sgi.com with ESMTP id
	yabv98ksfDpqTnc0 for <xfs@oss.sgi.com>;
	Tue, 06 Jan 2009 10:04:13 -0800 (PST)
Received: by rv-out-0708.google.com with SMTP id f25so7367735rvb.32
	for <xfs@oss.sgi.com>; Tue, 06 Jan 2009 10:04:13 -0800 (PST)
Message-ID: <b75ef8170901061004n75f52cffg7f810a51aca21ff@mail.gmail.com>
Date: Tue, 6 Jan 2009 20:04:12 +0200
From: "Gergely Soos" <sogerc1@gmail.com>
Subject: Re: need help to repair XFS partition
In-Reply-To: <49638190.3070803@sandeen.net>
MIME-Version: 1.0
References: <b75ef8170901060111l52b9a803uf31dc7baa80df721@mail.gmail.com>
	<49638190.3070803@sandeen.net>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============4109167692478637782=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============4109167692478637782==
Content-Type: text/plain
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Content-length: 6783

In my original email there was an attachment that contained the original
boot sector, but anyway, here comes the hexdump Eric asked for:

00000000  91 f0 1c 43 90 01 ba bf  f7 ee 29 9a 1e 6c d5 aa
|.=F0.C..=BA=BF=F7=EE)..l=D5=AA|
00000010  11 5a 12 cb 3b 29 cb ff  39 ce 4e d3 95 ec b9 39
|.Z.=CB;)=CB=FF9=CEN=D3.=EC=B99|
00000020  4a 5f 11 92 0a b5 c8 c0  fd ef 36 11 d7 d4 0a 55
|J_...=B5=C8=C0=FD=EF6.=D7=D4.U|
00000030  f7 f7 54 5e 52 4e 1a 7a  32 72 ad c1 a7 10 2e 28
|=F7=F7T^RN.z2r=AD=C1=A7..(|
00000040  cf 00 fb 5c 95 d3 ea 59  b6 72 51 4e cd 82 b7 7b
|=CF.=FB\.=D3=EAY=B6rQN=CD.=B7{|
00000050  3a 13 dd e0 af 01 bd fd  2c 9d b3 a4 ee 59 c3 ea
|:.=DD=E0=AF.=BD=FD,.=B3=A4=EEY=C3=EA|
00000060  a7 a1 e5 e9 b0 aa 74 19  14 e4 26 cf 60 3f 4c c9
|=A7=A1=E5=E9=B0=AAt..=E4&=CF`?L=C9|
00000070  51 1f fd 77 df 0e 26 76  43 6b 83 ba e4 f3 6f 56
|Q.=FDw=DF.&vCk.=BA=E4=F3oV|
00000080  7c b2 0a 70 1f 6b a0 a3  27 a6 c5 b2 f7 90 50 e1
||=B2.p.k =A3'=A6=C5=B2=F7.P=E1|
00000090  e7 7a 2b ab 8a 31 6b 5e  07 b0 48 df e4 cd b0 31
|=E7z+=AB.1k^.=B0H=DF=E4=CD=B01|
000000a0  73 39 7e dd b2 5e 20 15  48 b0 3a bb 40 f0 1b 8b  |s9~=DD=B2^
.H=B0:=BB@=F0..|
000000b0  c9 2d a2 bb cf dd bc 91  ee fe fe a8 88 88 92 cc
|=C9-=A2=BB=CF=DD=BC.=EE=FE=FE=A8...=CC|
000000c0  99 24 88 08 e5 9c 8b 89  b0 1b df d5 0b d9 d2 79
|.$..=E5...=B0.=DF=D5.=D9=D2y|
000000d0  cb d9 2f 39 d3 b6 c8 74  04 ce 4f 86 d8 50 ea b7
|=CB=D9/9=D3=B6=C8t.=CEO.=D8P=EA=B7|
000000e0  2a c4 d8 8c 11 85 ef 5b  31 2f f2 fa 4e d7 e9 92
|*=C4=D8...=EF[1/=F2=FAN=D7=E9.|
000000f0  ea 06 d5 25 71 d4 22 05  5e dd c8 64 43 02 18 a4
|=EA.=D5%q=D4".^=DD=C8dC..=A4|
00000100  76 01 01 0b fe fc ba d5  74 55 54 c8 bb cd 08 80
|v...=FE=FC=BA=D5tUT=C8=BB=CD..|
00000110  1a 0e 4f d7 17 51 da b5  5e 84 f4 5c 48 b8 63 66
|..O=D7.Q=DA=B5^.=F4\H=B8cf|
00000120  05 19 9c 7b c4 70 3b 37  a7 8c 45 43 ef a8 05 0b
|...{=C4p;7=A7.EC=EF=A8..|
00000130  52 d3 cc a4 a7 1e 07 c1  2e 9e 62 0e d1 43 83 4c
|R=D3=CC=A4=A7..=C1..b.=D1C.L|
00000140  ab bd e8 c0 e2 72 75 1f  21 b9 08 57 92 a2 e8 b8
|=AB=BD=E8=C0=E2ru.!=B9.W.=A2=E8=B8|
00000150  ee 34 5c 0d 01 55 5e fc  7a a9 07 67 c4 20 48 07  |=EE4\..U^=FCz(=
c).g=C4
H.|
00000160  aa 9f 96 d2 49 fd c0 39  35 e1 03 2a ae 93 d8 75
|=AA..=D2I=FD=C095=E1.*(R).=D8u|
00000170  28 0c 00 59 78 e1 28 10  dc c9 10 8c 03 00 24 4a
|(..Yx=E1(.=DC=C9....$J|
00000180  04 34 cf 1f 01 f4 cf 12  95 88 ee 39 f6 8c 05 30
|.4=CF..=F4=CF...=EE9=F6..0|
00000190  08 00 92 e0 3e e1 f0 21  83 12 70 93 90 9a 9c 3e
|...=E0>=E1=F0!..p....>|
000001a0  23 80 1c 7c 07 f4 c0 f8  10 e1 30 94 5f 8a 43 28
|#..|.=F4=C0=F8.=E10._.C(|
000001b0  78 33 4e 00 52 ef 2b 53  c3 db c3 ae 12 3e 07 6a
|x3N.R=EF+S=C3=DB=C3(R).>.j|
000001c0  87 2e c0 16 43 a2 52 ab  65 50 61 d5 f7 df 7d eb
|..=C0.C=A2R=ABePa=D5=F7=DF}=EB|
000001d0  7b 57 74 78 0f e9 d2 47  fb 17 b0 33 7b 1a e0 2c
|{Wtx.=E9=D2G=FB.=B03{.=E0,|
000001e0  a0 24 b6 09 b1 4b 03 42  56 0f c9 15 2a f6 11 bc
| $=B6.=B1K.BV.=C9.*=F6.=BC|
000001f0  06 c1 30 d4 0f 7f 05 2a  0e 34 08 85 2f 54 b4 dd
|.=C10=D4...*.4../T=B4=DD|
00000200

This looks like nothing to me...
xfs_repair rejects all superblock candidates and exits saying something
like: Sorry, cannot find valid secondary superblock.
I'm not sure what a GPT is, but this is an IDE harddisk, I'm using kernel
2.6.20 and my xfs partition is /dev/hdd1
Is there any way xfs_repair would accept the superblock as is and move on
with the repairs?

Gergely

On Tue, Jan 6, 2009 at 6:06 PM, Eric Sandeen <sandeen@sandeen.net> wrote:

> Gergely Soos wrote:
> > Greetings
> >
> > I heard that people compliment XFS for being the fastest FS these days
> > so I thought I give it a try.
> > What I did was that I converted my old 107GB FAT32 partition to XFS (I
> > created an XFS over it) and I wanted to use it as /home
> > Everything went as it should, I moved the files from my old /home then I
> > restarted (cleanly!) under windows.
> > When I got back from windows I was no longer able to mount the XFS
> > partition.
>
> Which partition was it?  I wonder if a gpt label got re-written over it
> or something.
>
> > xfs_repair only said that the superblock is invalid and attempts to find
> > secondary superblocks but all candidates fail.
> > So I created a file on another computer with the exact same size as the
> > partition on my computer and created an XFS on it.
>
> > Then I extracted the first 512 bytes and copied to my HDD using dd. But
> > it complained about the UUID so I corrected it using khexedit.
>
> Did you keep the original first 512 bytes?  It would be worth looking
> at; try hexdump -C on it (the original) and send that if you have it.
>
> > Then xfs_db complained that it cannot find the root inode so I wrote a
> > little perl script to search it.
> > You can find it in myxfs.tar.bz2. It seems that it found the root inode
> > because after I corrected the address using khexedit
> > xfs_db started complaining about the realtime bitmap inodes, so I
> > corrected those too (using inode numbers rootino+1 and rootino+2).
> > And this is where I'm stuck.
> > The mount still fails, dmesg says that it cannot find the root inode,
> > xfs_repair says the same old thing, xfs_check says a lot of things,
> > most of them are messages like this: can't seek in filesystem at bb
> > <some numbers> or: ag bad magick number.
> > That exceeds my knowledge.
> > Please help me restore the partition, It contains lots of programmes I
> > wrote over the years and some of them are not backed up,
> > some of them are, but only an older version. I also have personal stuff
> > on it like my bill records that I cannot recover from anywhere else.
> > myxfs.tar.bz2 contains the perl script I mentioned above and the inodes
> > it found. The one staring with ri is the root inode,
> > the files starting with sb are the suspected superblocks (I also took
> > one of those at random and corrected the three inode numbers
> > with khexedit but the result is the same) and the file backup_bootsect
> > contains the original superblock that was on the disk after I came back
> > from windows xp. It does not look like anything to me...
> > The numbers after ri and sb are the starting address in bytes of the
> > inode on the disk.
> > I would also attach the output of xfs_metadump which I created after I
> > corrected the three inode numbers in the superblock but even bzip-ed
> > it is more than 3MB and the administrator of this list does not accept
> it.
>
> As Chris suggested, I would find a spare 100G somewhere and make a dd
> image now, so you have something to experiment with + a backup if things
> go wrong.
>
> It sounds like something under windows clobbered your filesystem, I
> guess, unless it's the gpt thing I mentioned, it's very strange.
>
> -Eric
>


[[HTML alternate version deleted]]


--===============4109167692478637782==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============4109167692478637782==--
