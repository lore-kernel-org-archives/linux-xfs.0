Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 30 Aug 2007 11:57:34 -0700 (PDT)
Received: from brmea-mail-2.sun.com ([192.18.98.43])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l7UIvT4p012114
	for <xfs@oss.sgi.com>; Thu, 30 Aug 2007 11:57:31 -0700
Received: from fe-amer-09.sun.com ([192.18.108.183])
	by brmea-mail-2.sun.com (8.13.6+Sun/8.12.9) with ESMTP id l7UIXsnI008979
	for <xfs@oss.sgi.com>; Thu, 30 Aug 2007 18:33:55 GMT
Received: from conversion-daemon.mail-amer.sun.com by mail-amer.sun.com
 (Sun Java System Messaging Server 6.2-6.01 (built Apr  3 2006))
 id <0JNL00201NHEQZ00@mail-amer.sun.com>
 (original mail from James.Mauro@Sun.COM) for xfs@oss.sgi.com; Thu,
 30 Aug 2007 12:33:54 -0600 (MDT)
Date: Thu, 30 Aug 2007 14:33:48 -0400
From: Jim Mauro <James.Mauro@Sun.COM>
Subject: Re: [zfs-discuss] ZFS, XFS, and EXT4 compared
In-reply-to: <1188454611.23311.13.camel@toonses.gghcwest.com>
Message-id: <46D70D8C.8010203@sun.com>
MIME-version: 1.0
Content-type: text/plain; format=flowed; charset=ISO-8859-1
Content-transfer-encoding: 7BIT
References: <1188454611.23311.13.camel@toonses.gghcwest.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: "Jeffrey W. Baker" <jwbaker@acm.org>
Cc: zfs-discuss@opensolaris.org, xfs@oss.sgi.com, linux-ext4@vger.kernel.org


I'll take a look at this. ZFS provides outstanding sequential IO performance
(both read and write). In my testing, I can essentially sustain 
"hardware speeds"
with ZFS on sequential loads. That is, assuming 30-60MB/sec per disk 
sequential
IO capability (depending on hitting inner or out cylinders), I get 
linear scale-up
on sequential loads as I add disks to a zpool, e.g. I can sustain 
250-300MB/sec
on a 6 disk zpool, and it's pretty consistent for raidz and raidz2.

Your numbers are in the 50-90MB/second range, or roughly 1/2 to 1/4 what was
measured on the other 2 file systems for the same test. Very odd.

Still looking...

Thanks,
/jim

Jeffrey W. Baker wrote:
> I have a lot of people whispering "zfs" in my virtual ear these days,
> and at the same time I have an irrational attachment to xfs based
> entirely on its lack of the 32000 subdirectory limit.  I'm not afraid of
> ext4's newness, since really a lot of that stuff has been in Lustre for
> years.  So a-benchmarking I went.  Results at the bottom:
>
> http://tastic.brillig.org/~jwb/zfs-xfs-ext4.html
>
> Short version: ext4 is awesome.  zfs has absurdly fast metadata
> operations but falls apart on sequential transfer.  xfs has great
> sequential transfer but really bad metadata ops, like 3 minutes to tar
> up the kernel.
>
> It would be nice if mke2fs would copy xfs's code for optimal layout on a
> software raid.  The mkfs defaults and the mdadm defaults interact badly.
>
> Postmark is somewhat bogus benchmark with some obvious quantization
> problems.
>
> Regards,
> jwb
>
> _______________________________________________
> zfs-discuss mailing list
> zfs-discuss@opensolaris.org
> http://mail.opensolaris.org/mailman/listinfo/zfs-discuss
>   
