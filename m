Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 06 May 2008 11:55:38 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m46IsvDU009169
	for <linux-xfs@oss.sgi.com>; Tue, 6 May 2008 11:54:59 -0700
Received: from mail.lichtvoll.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 12E98B1C9E9
	for <linux-xfs@oss.sgi.com>; Tue,  6 May 2008 11:55:40 -0700 (PDT)
Received: from mail.lichtvoll.de (mondschein.lichtvoll.de [194.150.191.11]) by cuda.sgi.com with ESMTP id ajozqk36i7hrfzEb for <linux-xfs@oss.sgi.com>; Tue, 06 May 2008 11:55:40 -0700 (PDT)
Received: from [10.0.0.21] (e179178177.adsl.alicedsl.de [85.179.178.177])
	by mail.lichtvoll.de (Postfix) with ESMTP id 88F735AE2C
	for <linux-xfs@oss.sgi.com>; Tue,  6 May 2008 20:54:21 +0200 (CEST)
From: Martin Steigerwald <Martin@lichtvoll.de>
Subject: Re: XFS for lots of small files
Date: Tue, 6 May 2008 20:55:36 +0200
References: <4820832B.3070903@dubielvitrum.pl> (sfid-20080506_185726_779300_46423265)
In-Reply-To: <4820832B.3070903@dubielvitrum.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805062055.36755.Martin@lichtvoll.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-xfs@oss.sgi.com

Am Dienstag 06 Mai 2008 schrieb Leszek Dubiel:
> Hello!

Hi Leszek,

> I consider moving server from reiserfs to xfs. In all benchmarks I have
> read both file systems have had comparable results.
>
> But I've made a test:
>
> 1. formated /dev/hda2 with reiserfs with default options and made
> 10.000 files
> 2. formated /dev/hda2 with xfs with default options and made 10.000
>
> Reiserfs created those files in 2 (two) seconds, and xfs created them
> in 35 (thirty five) seconds.
>
> Is that normal? What I am doing wrong?
>
> My system is Debian, current stable version. Below is a log of
> operation.
>
>
> Thanks in advance.

[...]

> debian:/mnt/hdc2# time for f in `seq 9999`; do echo $f > $f; done
>
> real	0m35.558s
> user	0m0.256s
> sys	0m1.080s
>
> debian:/mnt/hdc2# time cat * | wc -l
> 9999
>
> real	0m0.239s
> user	0m0.020s
> sys	0m0.172s

I get

martin@shambala:~/Zeit/filetest -> rm *; sync ; time for ((I=1; I<=10000; 
I=I+1)); do echo $I > $I; done

real    0m10.642s
user    0m0.907s
sys     0m1.713s
martin@shambala:~/Zeit/filetest -> sync ; time cat * >/dev/null

real    0m0.238s
user    0m0.087s
sys     0m0.153s
martin@shambala:~/Zeit/filetest -> sync ; time cat * | wc -l
10000

real    0m0.375s
user    0m0.120s
sys     0m0.247s
martin@shambala:~/Zeit/filetest -> sync ; time rm *

real    0m7.600s
user    0m0.113s
sys     0m1.377s


for XFS with optimized settings...

shambala> xfs_info /home
meta-data=/dev/sda5              isize=256    agcount=6, agsize=4883256 
blks
         =                       sectsz=512   attr=2
data     =                       bsize=4096   blocks=29299536, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096
log      =internal               bsize=4096   blocks=32768, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0

agcount is two more than would be optimal cause I growed the partition 
once.

shambala> mount | grep home
/dev/sda5 on /home type xfs (rw,relatime,logbsize=256k,logbufs=8)

This is on a ThinkPad T42 internal laptop 160 GB harddisk drive with I 
think 5400rpm.

Partition I tested on was not empty at that time and is heavily used.

shambala> LANG=EN df -h /home
Filesystem            Size  Used Avail Use% Mounted on
/dev/sda5             112G   84G   29G  75% /home

And there is quite some fragmentation on it:

xfs_db> frag
actual 653519, ideal 587066, fragmentation factor 10.17%

I do not have free space in my playground LVM to test against ext3 and 
reiserfs at the moment.

Ciao,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
