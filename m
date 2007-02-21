Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 20 Feb 2007 18:50:31 -0800 (PST)
Received: from talk.nabble.com (www.nabble.com [72.21.53.35])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l1L2oQm7022900
	for <linux-xfs@oss.sgi.com>; Tue, 20 Feb 2007 18:50:26 -0800
Received: from [72.21.53.38] (helo=jubjub.nabble.com)
	by talk.nabble.com with esmtp (Exim 4.50)
	id 1HJhYo-0007GA-3r
	for linux-xfs@oss.sgi.com; Tue, 20 Feb 2007 18:50:26 -0800
Message-ID: <9074554.post@talk.nabble.com>
Date: Tue, 20 Feb 2007 18:50:25 -0800 (PST)
From: pgf111000 <junkmail@petergfrazier.com>
Subject: Re: [PATCH] mkfs.xfs, lvm, multi-terrabyte hardware array and luks
In-Reply-To: <45DB60E9.5040809@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
References: <9068053.post@talk.nabble.com> <45DB4CE1.3040302@sandeen.net> <9069238.post@talk.nabble.com> <45DB60E9.5040809@sandeen.net>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-xfs@oss.sgi.com


XFS.. HERE I COME!!!!!!!  The LUKS partition was indeed the culprit.  The
LUKS partition was not accurately representing the size of the underlying
logical volume (when over 2gb) automatically; in order to handle partitions
over 2gb it is necessary to explicitly specify the desired size of the LUKS
partition (size<lv) to the LUKS partition itself (via the LUKS "resize"
command).  It seems that mkfs.xfs relies on an accurate LUKS size in order
to work on logical volumes greater than or equal to 2gb.  I updated this
info on the LUKS wiki and other forums...

So just to recap.... if you are getting the error:

"mkfs.xfs: libxfs_device_zero write failed: Input/output error"

make sure that you have resized the underlying LUKS partition to the desired
size.

Thanks for the help; much appreciated.





Eric Sandeen-3 wrote:
> 
> pgf111000 wrote:
>> Thank you for the quick response.  I have posted on a few luks forums to
>> try
>> to delve into this issue a little deeper; if they are aware of a
>> resolution
>> I'll make sure to post it.  The interesting thing is that when I
>> mkfs.ext3
>> on luks partitions above 2-3gb all is fine; I wish xfs and luks would
>> play
>> nice.....
> 
> mkfs.xfs actually does writes out at the end of the device and verifies
> them; I'm not sure ext3 is doing the same.  You may find yourself in
> trouble on ext3 post-mkfs (or you may not...)  I seem to recall that xfs
> has shaken out similar problems on other block devices for this reason.
> 
> I'd do some simple device-level read/write tests around 2GB just for
> fun, see how it goes.
> 
> -Eric
> 
> 
> 
> 

-- 
View this message in context: http://www.nabble.com/mkfs.xfs%2C-lvm%2C-multi-terrabyte-hardware-array-and-luks-tf3262532.html#a9074554
Sent from the linux-xfs mailing list archive at Nabble.com.
