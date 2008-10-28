Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 28 Oct 2008 02:52:49 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9S9qXqZ012122
	for <xfs@oss.sgi.com>; Tue, 28 Oct 2008 02:52:35 -0700
Received: from lucidpixels.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3F367ECCF69
	for <xfs@oss.sgi.com>; Tue, 28 Oct 2008 02:52:30 -0700 (PDT)
Received: from lucidpixels.com (lucidpixels.com [75.144.35.66]) by cuda.sgi.com with ESMTP id qtLNs07fFdyRE4UW for <xfs@oss.sgi.com>; Tue, 28 Oct 2008 02:52:30 -0700 (PDT)
Date: Tue, 28 Oct 2008 05:52:29 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: Map a disk LBA to filename?
In-Reply-To: <20081028093827.GA12133@kyra>
Message-ID: <alpine.DEB.1.10.0810280552200.14523@p34.internal.lan>
References: <4905A3FB.6080709@aei.mpg.de> <20081027114945.GE4985@disturbed> <4905B48A.8010108@aei.mpg.de> <4905BC13.3030402@drutsystem.com> <20081027233516.GG4985@disturbed> <4906BB32.8080403@aei.mpg.de> <20081028072105.GW4985@disturbed> <4906C164.6090704@aei.mpg.de>
 <4906D80F.9050500@aei.mpg.de> <20081028093827.GA12133@kyra>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463747160-1319962850-1225187549=:14523"
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: KELEMEN Peter <Peter.Kelemen@cern.ch>
Cc: xfs@oss.sgi.com

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463747160-1319962850-1225187549=:14523
Content-Type: TEXT/PLAIN; charset=utf-8; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE



On Tue, 28 Oct 2008, KELEMEN Peter wrote:

> * Carsten Aulbert (carsten.aulbert@aei.mpg.de) [20081028 10:14]:
>
>> Is it possible that blocks !=3D bsized_blocks?
>
> xfs_bmap(8) talks in basic blocks (512 bytes).
> 660 div 8 =3D 82, so try:
>
> 	blockget -b 82 -n
>
>> Sorry for these questions, but I'm quite lost and I have not
>> been able to find the answer in the man pages.
>
> The second paragraph of man xfs_bmap says:
>
> ?[...] All the file offsets and disk blocks are in units of
> 512-byte blocks, no matter what the filesystem?s block size
> is.?
>
> HTH,
> Peter
>
> --
>    .+'''+.         .+'''+.         .+'''+.         .+'''+.         .+''
> Kelemen P=C3=A9ter     /       \       /       \     Peter.Kelemen@cern.ch
> .+'         `+...+'         `+...+'         `+...+'         `+...+'
>
>

If you figure it out a little how-to would be nice :)

Justin.
---1463747160-1319962850-1225187549=:14523--
