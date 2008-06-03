Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 03 Jun 2008 10:35:39 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m53HZYwY007445
	for <xfs@oss.sgi.com>; Tue, 3 Jun 2008 10:35:35 -0700
Received: from rv-out-0708.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id CFFC31E0E82
	for <xfs@oss.sgi.com>; Tue,  3 Jun 2008 10:36:27 -0700 (PDT)
Received: from rv-out-0708.google.com (rv-out-0708.google.com [209.85.198.241]) by cuda.sgi.com with ESMTP id gjwYZNpeknfED3Wz for <xfs@oss.sgi.com>; Tue, 03 Jun 2008 10:36:27 -0700 (PDT)
Received: by rv-out-0708.google.com with SMTP id f25so1341120rvb.32
        for <xfs@oss.sgi.com>; Tue, 03 Jun 2008 10:36:27 -0700 (PDT)
Message-ID: <3607657a0806031036r702ab6a5w7ca6517c19395b9b@mail.gmail.com>
Date: Tue, 3 Jun 2008 13:36:26 -0400
From: "Spam Magnet" <spam.wax@gmail.com>
Subject: Re: XFS: SB validate failed
In-Reply-To: <48427DEE.40400@stesmi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <3607657a0805291005k457791cej1c5f867da0f95965@mail.gmail.com>
	 <483F1AED.3010808@sandeen.net>
	 <3607657a0805291446t79808c63l664780c1cbc3d871@mail.gmail.com>
	 <483F907A.3020108@sgi.com>
	 <3607657a0805301019h4a49dc86ne8f1f019629a1c41@mail.gmail.com>
	 <4840406F.50402@stesmi.com> <48408D3E.3090401@gmail.com>
	 <48409981.1050405@stesmi.com> <48425148.1080105@gmail.com>
	 <48427DEE.40400@stesmi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Stefan Smietanowski <stesmi@stesmi.com>
Cc: Timothy Shimmin <tes@sgi.com>, Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com

On Sun, Jun 1, 2008 at 6:46 AM, Stefan Smietanowski <stesmi@stesmi.com> wrote:
> One way is : od -t c jaz7.img | grep X | head
>
> Look for X   F   S   B, may be split on two lines for you.
>
> This is what my disk looks like but of course, it's on a DOS
> partition:
>
> 0077000   X   F   S   B  \0  \0 020  \0  \0  \0  \0  \0  \0  \0   `  \0
>

I couldn't find any XFS by using the full dump of the disk:
$ od -t c jaz7.img | grep X | head
0040000 353   > 220   (   j   0   X   ]   I   H   C  \0 002     001  \0
0040240 003 303   H 367 363 001   F 374 021   N 376   Z   X 273  \0  \a
0040560 023   Y   Z   X   r  \t   @   u 001   B 003   ^  \v 342 314 303
1041040   5   0                           E   X   E   !  \0   K   -   H
1141360 031  \0   t  \b   P  \r 362  \t   .  \0 265   P   X  \f 026   z
1141400   # 001 353  \n   X 034 022 020   D 001   I 016   X 034   @ 023

(The healthy disk image also doesn't have any XFS but it has: 'S f x'
(capital s))
50.exe at offset 1041040 made me check the image file using a Windows
utility called : UFS Explorer.
(www.ufsexplorer.com) They claim that they can recover XFS partitions.
To my surprise that software
recognized the image as a FAT16 file system containing only one single
file called "50.exe"
I am more inclined to believe 'fdisk' rather than UFS Explorer:
Most likely the original format that Iomega had shipped the Jaz disk
with was a FAT16 and then
somebody in our lab had decided to format it to xfs.

I am beginning to feel that I will need to recover my data manually,
one file at a time :(
(It's really frustrating that I can see all my beautiful file names
through hexdump but can't access them).

So is there a preferred way of hard disk/partition recovery for XFS
file system ?
And if I end up doing that, where can I get more info about the
underwork of xfs ?

thank you all for your patience and help.
