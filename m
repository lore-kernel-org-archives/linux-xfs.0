Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 29 May 2008 15:25:13 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m4TMPBjp019207
	for <xfs@oss.sgi.com>; Thu, 29 May 2008 15:25:11 -0700
Received: from proxy2.bredband.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 93A8A1758FDE
	for <xfs@oss.sgi.com>; Thu, 29 May 2008 15:26:03 -0700 (PDT)
Received: from proxy2.bredband.net (proxy2.bredband.net [195.54.101.72]) by cuda.sgi.com with ESMTP id HZOjdE5EdqkWYGIo for <xfs@oss.sgi.com>; Thu, 29 May 2008 15:26:03 -0700 (PDT)
Received: from ironport.bredband.com (195.54.101.120) by proxy2.bredband.net (7.3.127)
        id 4811833300A93E0D for xfs@oss.sgi.com; Fri, 30 May 2008 00:26:02 +0200
Message-ID: <483F2D69.4080200@stesmi.com>
Date: Fri, 30 May 2008 00:25:45 +0200
From: Stefan Smietanowski <stesmi@stesmi.com>
MIME-Version: 1.0
Subject: Re: XFS: SB validate failed
References: <3607657a0805291005k457791cej1c5f867da0f95965@mail.gmail.com>	 <483EE5BD.8020407@sandeen.net>	 <3607657a0805291255i59fd006fi9d6836cf528d19a6@mail.gmail.com>	 <483F0BC3.2050901@sandeen.net>	 <3607657a0805291400h3c50165lea6fbea919deed0f@mail.gmail.com>	 <483F1AED.3010808@sandeen.net> <3607657a0805291446t79808c63l664780c1cbc3d871@mail.gmail.com>
In-Reply-To: <3607657a0805291446t79808c63l664780c1cbc3d871@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Spam Magnet <spam.wax@gmail.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com

Hi!

Spam Magnet wrote:

> So I guess it doesn't matter if I do the image either using dd or xfsdump.
> I'd prefer dd since I get a lot of issues trying to compile xfsprogs under Irix.
> 
> Assuming that I get an image using dd, would a simple mount command suffice
> to use the xfs utils ? :
> $ mount -t xfs -o loop disk.img /mnt
> 
> Or there are some intermediate steps that I need to take in order to
> mount an xfs disk
> image file on Linux ?

I would add ",ro" after loop like this :

$ mount -t xfs -o loop,ro disk.img /mnt

But that's just a precaution and not necessary. This way if you
manage to mess something up some way you can just try again since
you're then mounting readonly.

Unless you were planning on updating the image and then dd'ing it back
to the original device of course.

// Stefan
