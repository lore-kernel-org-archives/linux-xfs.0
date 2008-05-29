Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 29 May 2008 15:19:12 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m4TMJ6dp018814
	for <xfs@oss.sgi.com>; Thu, 29 May 2008 15:19:06 -0700
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1B8811CEA72
	for <xfs@oss.sgi.com>; Thu, 29 May 2008 15:19:58 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id rPTPu33ePT7mO6GN for <xfs@oss.sgi.com>; Thu, 29 May 2008 15:19:58 -0700 (PDT)
Message-ID: <483F2C0D.1020401@sandeen.net>
Date: Thu, 29 May 2008 17:19:57 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: XFS: SB validate failed
References: <3607657a0805291005k457791cej1c5f867da0f95965@mail.gmail.com>	 <483EE5BD.8020407@sandeen.net>	 <3607657a0805291255i59fd006fi9d6836cf528d19a6@mail.gmail.com>	 <483F0BC3.2050901@sandeen.net>	 <3607657a0805291400h3c50165lea6fbea919deed0f@mail.gmail.com>	 <483F1AED.3010808@sandeen.net> <3607657a0805291446t79808c63l664780c1cbc3d871@mail.gmail.com>
In-Reply-To: <3607657a0805291446t79808c63l664780c1cbc3d871@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Spam Magnet <spam.wax@gmail.com>
Cc: xfs@oss.sgi.com

Spam Magnet wrote:
>> try xfs_repair -n then maybe.  Or update xfsprogs.  check shouldn't
>> segfault, regardless of the fs state.
>>
> 
> I updated xfsprogs to the latest version (cvs checkout) and it solved
> the segfault.
> 
>> nah that's fine, images or disks, whichever.
>>
> 
> So I guess it doesn't matter if I do the image either using dd or xfsdump.
> I'd prefer dd since I get a lot of issues trying to compile xfsprogs under Irix.
> 
> Assuming that I get an image using dd, would a simple mount command suffice
> to use the xfs utils ? :
> $ mount -t xfs -o loop disk.img /mnt

that's fine, assuming your dd was of the partition that actually held
the xfs fs.

-Eric
