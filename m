Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 20 Feb 2007 12:00:58 -0800 (PST)
Received: from talk.nabble.com (www.nabble.com [72.21.53.35])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l1KK0pm7012688
	for <linux-xfs@oss.sgi.com>; Tue, 20 Feb 2007 12:00:52 -0800
Received: from [72.21.53.38] (helo=jubjub.nabble.com)
	by talk.nabble.com with esmtp (Exim 4.50)
	id 1HJbAR-0000Ek-Jk
	for linux-xfs@oss.sgi.com; Tue, 20 Feb 2007 12:00:51 -0800
Message-ID: <9069238.post@talk.nabble.com>
Date: Tue, 20 Feb 2007 12:00:51 -0800 (PST)
From: pgf111000 <junkmail@petergfrazier.com>
Subject: Re: [PATCH] mkfs.xfs, lvm, multi-terrabyte hardware array and luks
In-Reply-To: <45DB4CE1.3040302@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
References: <9068053.post@talk.nabble.com> <45DB4CE1.3040302@sandeen.net>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-xfs@oss.sgi.com


Thank you for the quick response.  I have posted on a few luks forums to try
to delve into this issue a little deeper; if they are aware of a resolution
I'll make sure to post it.  The interesting thing is that when I mkfs.ext3
on luks partitions above 2-3gb all is fine; I wish xfs and luks would play
nice.....


Eric Sandeen-3 wrote:
> 
> pgf111000 wrote:
>> When I try to format partitions above 2-3gb my opteron experiences heavy
>> io
>> wait; the mkfs.xfs fails, and I receive the following....
>> 
>>  "mkfs.xfs: libxfs_device_zero write failed: Input/output error"
>> 
>> When I format partions below 2-3gb, there is no problem whatsoever.  I
>> can
>> mkfs.xfs on a +2-3GB non-luks formated partition without a problem... any
>> thoughts?
> 
> Sounds like a LUKS problem, maybe it can't do those large offsets?  xfs
> certainly can...
> 
> I bet you'll find that the 2GB size is the threshold... xfs is just
> trying a write():
> 
>         if ((bytes = write(fd, z, bytes)) < 0) {
>                 fprintf(stderr, _("%s: %s write failed: %s\n"),
>                         progname, __FUNCTION__, strerror(errno));
> 
> maybe try a simple dd write at the end of your large luks device, see
> how that goes.
> 
> -Eric
> 
> 
> 
> 

-- 
View this message in context: http://www.nabble.com/mkfs.xfs%2C-lvm%2C-multi-terrabyte-hardware-array-and-luks-tf3262532.html#a9069238
Sent from the linux-xfs mailing list archive at Nabble.com.
