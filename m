Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 03 Jun 2008 10:55:18 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m53HtEGW008764
	for <xfs@oss.sgi.com>; Tue, 3 Jun 2008 10:55:15 -0700
Received: from rv-out-0708.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id DDBF211AD100
	for <xfs@oss.sgi.com>; Tue,  3 Jun 2008 10:56:08 -0700 (PDT)
Received: from rv-out-0708.google.com (rv-out-0708.google.com [209.85.198.243]) by cuda.sgi.com with ESMTP id qjiQYInvLVS8vFyC for <xfs@oss.sgi.com>; Tue, 03 Jun 2008 10:56:08 -0700 (PDT)
Received: by rv-out-0708.google.com with SMTP id f25so1350769rvb.32
        for <xfs@oss.sgi.com>; Tue, 03 Jun 2008 10:56:08 -0700 (PDT)
Message-ID: <3607657a0806031056w24efa917q625f13bfe9eaa706@mail.gmail.com>
Date: Tue, 3 Jun 2008 13:56:08 -0400
From: "Spam Magnet" <spam.wax@gmail.com>
Subject: Re: XFS: SB validate failed
In-Reply-To: <3607657a0806031036r702ab6a5w7ca6517c19395b9b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <3607657a0805291005k457791cej1c5f867da0f95965@mail.gmail.com>
	 <3607657a0805291446t79808c63l664780c1cbc3d871@mail.gmail.com>
	 <483F907A.3020108@sgi.com>
	 <3607657a0805301019h4a49dc86ne8f1f019629a1c41@mail.gmail.com>
	 <4840406F.50402@stesmi.com> <48408D3E.3090401@gmail.com>
	 <48409981.1050405@stesmi.com> <48425148.1080105@gmail.com>
	 <48427DEE.40400@stesmi.com>
	 <3607657a0806031036r702ab6a5w7ca6517c19395b9b@mail.gmail.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Stefan Smietanowski <stesmi@stesmi.com>
Cc: Timothy Shimmin <tes@sgi.com>, Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com

> (The healthy disk image also doesn't have any XFS but it has: 'S f x'
> (capital s))

Correcting my mistake:

The healthy image file does have the X F S B at 10000000  (octal) as
fdisk had reported:
Pt#          Device  Info     Start       End   Sectors  Id  System
 8: 2gb-ubuntu.img1            4096   3915599   3911504   a  SGI xfs

4096*512=2097152 (10000000 octal):
$ od -t c 2gb-ubuntu.img | grep 10000000
10000000   X   F   S   B  \0  \0 020  \0  \0  \0  \0  \0  \0  \a   u 350

I tried to see if I can find do the same thing for jaz7.img:
Pt#    Device  Info     Start       End   Sectors  Id  System
 8: jaz7.img1            3072   2091007   2087936   a  SGI xfs

$ od -t c jaz7.img | grep 6000000
6000000  \0  \0  \0  \0  \0  \0  \0  \0  \0  \0  \0  \0  \0  \0  \0  \0

I guess all those zeros are not good signs.
