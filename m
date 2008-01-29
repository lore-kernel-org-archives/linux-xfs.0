Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 29 Jan 2008 09:16:55 -0800 (PST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m0THGpdw000761
	for <xfs@oss.sgi.com>; Tue, 29 Jan 2008 09:16:53 -0800
Received: from enyo.dsw2k3.info (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id BFBC8574D67
	for <xfs@oss.sgi.com>; Tue, 29 Jan 2008 09:17:09 -0800 (PST)
Received: from enyo.dsw2k3.info (enyo.dsw2k3.info [195.71.86.239]) by cuda.sgi.com with ESMTP id 7nRj8oDhlzQSwYx0 for <xfs@oss.sgi.com>; Tue, 29 Jan 2008 09:17:09 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
	by enyo.dsw2k3.info (Postfix) with ESMTP id B00662BC53
	for <xfs@oss.sgi.com>; Tue, 29 Jan 2008 18:17:07 +0100 (CET)
Received: from enyo.dsw2k3.info ([127.0.0.1])
	by localhost (enyo.dsw2k3.info [127.0.0.1]) (amavisd-new, port 10024)
	with LMTP id ICgYVF5UuXwX for <xfs@oss.sgi.com>;
	Tue, 29 Jan 2008 18:17:01 +0100 (CET)
Received: from citd.de (p4FC4BD9B.dip.t-dialin.net [79.196.189.155])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(Client did not present a certificate)
	by enyo.dsw2k3.info (Postfix) with ESMTP id 24A192BC51
	for <xfs@oss.sgi.com>; Tue, 29 Jan 2008 18:17:01 +0100 (CET)
Date: Tue, 29 Jan 2008 18:16:58 +0100
From: Matthias Schniedermeyer <ms@citd.de>
Subject: Re: mkfs.xfs doesn't detect size of storage correctly
Message-ID: <20080129171658.GB21228@citd.de>
References: <20080129093201.GA16203@citd.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080129093201.GA16203@citd.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

On 29.01.2008 10:32, Matthias Schniedermeyer wrote:
> Hi
> 
> 
> Yesterday i bought a 750GB HDD.
> I encrypt nearly everything with loop-aes, so i also did it with this 
> HDD.
> 
> I create a "fake" partition table and:
> losetup -e aes256 -p 0 -o 4096 /dev/loop6 /dev/sdb < key
> 
> This creates a loop with everything except the first 4KB, i.e. it leaves 
> out the MBR and another 3,5KB.
> 
> /proc/partions shows the correct(tm) size informations for the HDD and 
> the loop:
> - snip -
>    7     6  732574580 loop6
>    8    16  732574584 sdb
>    8    17  732572001 sdb1
> - snip -
> 
> But when i mkfs.xfs the loop
> #> mkfs.xfs /dev/loop6
> meta-data=/dev/loop6             isize=256    agcount=3, agsize=45785911 blks
>          =                       sectsz=512   attr=2
> data     =                       bsize=4096   blocks=137357733, imaxpct=25
>          =                       sunit=0      swidth=0 blks
> naming   =version 2              bsize=4096
> log      =internal log           bsize=4096   blocks=32768, version=2
>          =                       sectsz=512   sunit=0 blks, lazy-count=0
> realtime =none                   extsz=4096   blocks=0, rtextents=0

I just found a workaround. :-)
As can be seen above the agcount is 3.

For a reason that lays years in the past, when there were issues with 
the agcount (actually agsize), that to the best of my knowledge are 
fixed years ago (but still cause a weird feeling whenever i see that 
word) i just tried '-d agcount=4'

#> mkfs.xfs -l size=1024b -d agcount=4 /dev/loop6 -f
meta-data=/dev/loop6             isize=256    agcount=4, agsize=45785912 blks
         =                       sectsz=512   attr=2
data     =                       bsize=4096   blocks=183143645, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096
log      =internal log           bsize=4096   blocks=32768, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=0
realtime =none                   extsz=4096   blocks=0, rtextents=0

As can be seen the "blocks"-number is much higher.

#> df -k /mnt
Filesystem           1K-blocks      Used Available Use% Mounted on
/dev/loop6           732570484      4256 732566228   1% /mnt

matches(tm) with the loop-size.


So i'm "burned" by agcount/agsize AGAIN, seems my weird feeling about 
those two words are still with reason. ;-)






Bis denn

-- 
Real Programmers consider "what you see is what you get" to be just as 
bad a concept in Text Editors as it is in women. No, the Real Programmer
wants a "you asked for it, you got it" text editor -- complicated, 
cryptic, powerful, unforgiving, dangerous.
