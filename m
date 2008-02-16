Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 15 Feb 2008 21:40:42 -0800 (PST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m1G5eZJI001085
	for <xfs@oss.sgi.com>; Fri, 15 Feb 2008 21:40:36 -0800
Received: from bob.dscon.sk (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 56F6E5E24BC
	for <xfs@oss.sgi.com>; Fri, 15 Feb 2008 21:41:00 -0800 (PST)
Received: from bob.dscon.sk (bob.dscon.sk [88.86.113.10]) by cuda.sgi.com with ESMTP id Qf8KdOWpaBq1LUrY for <xfs@oss.sgi.com>; Fri, 15 Feb 2008 21:41:00 -0800 (PST)
Date: Sat, 16 Feb 2008 06:41:42 +0100
Subject: Re: rewrite very slow
Message-ID: <20080216054142.GD4859@bob.dscon.sk>
References: <20080215191636.GC4859@bob.dscon.sk> <47B62FF6.2000903@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47B62FF6.2000903@sandeen.net>
From: xfs@bob.dscon.sk (DS)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Test configuration:
Linux kernel 2.6.23.1 #1 SMP
2x Intel(R) Xeon(TM) CPU 2.40GHz with HT

iSCSI storage (1TB - 7 sata disks in RAID6, 2GB cache controler)


Yes, your "test" works fine:
file1:/mnt/hosting/test# time ./test

real    0m0.334s
user    0m0.000s
sys     0m0.000s


Is there any way to get it work for perl/php/other scripts/programs?

DS


On Fri, Feb 15, 2008 at 06:36:06PM -0600, Eric Sandeen wrote:
> DS wrote:
> > Hello,
> > 
> > I need some help to tunning my storage.
> 
> ...
> > TIME 43 sekund
> 
> 
> What kernel?  when I test on my 2.6.23.9-85.fc8 and 2.6.22.5 boxes, I
> see 2 and 7 seconds for rewrite, respectively.
> 
> but granted, on ext3 I get 0 seconds for every run.
> 
> Also the difference appears to be O_TRUNC (which the perl script does);
> if I code it in c:
> 
> #include <sys/types.h>
> #include <sys/stat.h>
> #include <fcntl.h>
> 
> void main(void)
> {
>         int i;
>         int fd;
>         char file[4];
> 
>         for (i = 0; i < 100; i++) {
>                 sprintf(file, "%d.txt", i);
>                 fd = open(file, O_CREAT|O_RDWR|O_TRUNC, 0644);
>                 write(fd, "aaaaaaaaaaaaaaaaaaa\n");
>                 close(fd);
>         }
> }
> 
> rewrite is a bit slower w/ O_TRUNC in place, plenty fast w/o it.  Not
> sure about the xfs/ext3 difference... this is probably a side-effect of
> flushes xfs put into place on truncate (IIRC?)
> 
> -Eric
> 
> 
