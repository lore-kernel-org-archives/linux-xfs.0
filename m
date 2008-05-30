Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 30 May 2008 10:18:44 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m4UHIdFG010410
	for <xfs@oss.sgi.com>; Fri, 30 May 2008 10:18:40 -0700
Received: from rv-out-0708.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9A14BC270FA
	for <xfs@oss.sgi.com>; Fri, 30 May 2008 10:19:30 -0700 (PDT)
Received: from rv-out-0708.google.com (rv-out-0708.google.com [209.85.198.241]) by cuda.sgi.com with ESMTP id aUolTcVfCdFiWmgx for <xfs@oss.sgi.com>; Fri, 30 May 2008 10:19:30 -0700 (PDT)
Received: by rv-out-0708.google.com with SMTP id f25so3729606rvb.32
        for <xfs@oss.sgi.com>; Fri, 30 May 2008 10:19:30 -0700 (PDT)
Message-ID: <3607657a0805301019h4a49dc86ne8f1f019629a1c41@mail.gmail.com>
Date: Fri, 30 May 2008 13:19:30 -0400
From: "Spam Magnet" <spam.wax@gmail.com>
Subject: Re: XFS: SB validate failed
In-Reply-To: <483F907A.3020108@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <3607657a0805291005k457791cej1c5f867da0f95965@mail.gmail.com>
	 <483EE5BD.8020407@sandeen.net>
	 <3607657a0805291255i59fd006fi9d6836cf528d19a6@mail.gmail.com>
	 <483F0BC3.2050901@sandeen.net>
	 <3607657a0805291400h3c50165lea6fbea919deed0f@mail.gmail.com>
	 <483F1AED.3010808@sandeen.net>
	 <3607657a0805291446t79808c63l664780c1cbc3d871@mail.gmail.com>
	 <483F907A.3020108@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Timothy Shimmin <tes@sgi.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com

> As Eric said.
> We chose the ondisk format to have the byte ordering of IRIX so
> it should not be a problem. However, parts of the log code in Linux
> does not do the necessary endian conversion (due to lack of info at
> the relevant points - it only knows as blobs of data) and so you
> need the log to be clean. i.e. byte ordering problem just for the log.
>

Thanks for this info, it's good to have 1 less problem to worry about :)

> OOI, as Eric asked, how were you able to mount it all of a sudden?
>

I am not sure, as I said, to narrow down the problem I am experiencing
with other disks, I decided to format an empty, healthy disk under Irix and
try to mount it under Linux. The first try was not successful but the
second was.

Right now I am making an image of the good/healthy disk using dd to
see if I can mount that
image under Linux. (It's not fun to copy 2GB disks through a
USB1.1-SCSI adapter :)
My ultimate goal is to make image of the disks that do have
partition table but refuse to mount under either OS (magic number and
SB validattion failure).
I am hoping I can edit the disk image in order to get the data back.

Again I'd like to thank Eric, you and Stephen, you guys have been very helpful.
