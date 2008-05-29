Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 29 May 2008 14:45:51 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m4TLjnNR017176
	for <xfs@oss.sgi.com>; Thu, 29 May 2008 14:45:50 -0700
Received: from rv-out-0708.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4AB241758B4A
	for <xfs@oss.sgi.com>; Thu, 29 May 2008 14:46:40 -0700 (PDT)
Received: from rv-out-0708.google.com (rv-out-0708.google.com [209.85.198.251]) by cuda.sgi.com with ESMTP id y1ViwJxzFeOMIo35 for <xfs@oss.sgi.com>; Thu, 29 May 2008 14:46:40 -0700 (PDT)
Received: by rv-out-0708.google.com with SMTP id f25so3383854rvb.32
        for <xfs@oss.sgi.com>; Thu, 29 May 2008 14:46:40 -0700 (PDT)
Message-ID: <3607657a0805291446t79808c63l664780c1cbc3d871@mail.gmail.com>
Date: Thu, 29 May 2008 17:46:40 -0400
From: "Spam Magnet" <spam.wax@gmail.com>
Subject: Re: XFS: SB validate failed
In-Reply-To: <483F1AED.3010808@sandeen.net>
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
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com

> try xfs_repair -n then maybe.  Or update xfsprogs.  check shouldn't
> segfault, regardless of the fs state.
>

I updated xfsprogs to the latest version (cvs checkout) and it solved
the segfault.

>
> nah that's fine, images or disks, whichever.
>

So I guess it doesn't matter if I do the image either using dd or xfsdump.
I'd prefer dd since I get a lot of issues trying to compile xfsprogs under Irix.

Assuming that I get an image using dd, would a simple mount command suffice
to use the xfs utils ? :
$ mount -t xfs -o loop disk.img /mnt

Or there are some intermediate steps that I need to take in order to
mount an xfs disk
image file on Linux ?
