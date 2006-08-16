Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 16 Aug 2006 08:44:20 -0700 (PDT)
Received: from moutng.kundenserver.de (moutng.kundenserver.de [212.227.126.177])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k7GFi6DW022226
	for <xfs@oss.sgi.com>; Wed, 16 Aug 2006 08:44:06 -0700
Message-ID: <44E32DE6.9090602@gmx.net>
Date: Wed, 16 Aug 2006 16:38:30 +0200
From: Klaus Strebel <klaus.strebel@gmx.net>
MIME-Version: 1.0
Subject: Re: xfsdump -s unacceptable performances
References: <200608161515.00543.daniele@interline.it>
In-Reply-To: <200608161515.00543.daniele@interline.it>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Daniele P. schrieb:
> Hi all,
> I'm new to the list. I have a problem with xfsdump using the -s option.
> I'm aware that the latest version (2.2.38) skip the scan and prune of
> the entire filesystem (see the test below), but there are other places
> where xfsdump performs an entire scan of the filesystem, slowing down
> the backup process.
> 
> For example in:
>  * dump/inomap.c after "phase 3" there is a function call to
>    bigstat_iter that scan the entire filesystem
>  * dump/content.c the function dump_dirs again scan the entire
>    filesystem
> 
> Are all there scan really necessary?
> Could we expect a performance fix?
> Is there a workaround?
> 
> I have done some test, and with quite large filesystem the performances
> where unacceptable. Dumping one directory with 4 file using 4KB of space
> takes hours (or days, it hasn't finished yet) if the underlying filesystem
> contains around 10.000.000 inodes.
> 
> On request I could provide more information and the output of some test.
> 
> Let's start with a simple comparison between 2.2.27 and 2.2.38
> using a small filesystem (40.000 inodes).
> 
> time xfsdump -p 60 -v drive=debug,media=debug \
> -s etc/20060401-0030 - /media/xfs-test | dd of=/dev/null
> xfsdump: using file dump (drive_simple) strategy
> xfsdump: version 2.2.27 (dump format 3.0) - Running single-threaded
> [...]
> xfsdump: media file size 17780576 bytes
> xfsdump: dump size (non-dir files) : 16477472 bytes
> xfsdump: dump complete: 219459 seconds elapsed
> xfsdump: Dump Status: SUCCESS
> 34727+1 records in
> 34727+1 records out
> 17780576 bytes transferred in 219459.047053 seconds (81 bytes/sec)
> 
> real    3657m39.120s
> user    0m2.361s
> sys     0m9.238s
> 
> 
> time /usr/lib/bin/xfsdump -p 60 -v drive=debug,media=debug \
> -s etc/20060401-0030 - /media/xfs-test | dd of=/dev/null
> /usr/lib/bin/xfsdump: using file dump (drive_simple) strategy
> /usr/lib/bin/xfsdump: version 2.2.38 (dump format 3.0) - Running single-threaded
> [...]
> /usr/lib/bin/xfsdump: media file size 17780576 bytes
> /usr/lib/bin/xfsdump: dump size (non-dir files) : 16477472 bytes
> /usr/lib/bin/xfsdump: dump complete: 18 seconds elapsed
> /usr/lib/bin/xfsdump: Dump Status: SUCCESS
> 34727+1 records in
> 34727+1 records out
> 17780576 bytes transferred in 17.451939 seconds (1018831 bytes/sec)
> 
> real    0m17.575s
> user    0m0.132s
> sys     0m1.035s
> 
> Thanks in advance for your suggestions.
> 
> Daniele P.
Hi Daniele,

hum, so the 2.2.27 was running 3657m39.120s and the 2.2.38 is running
the same (?) in 0m17.575s. Where is your performance problem running now
10000 times faster than the old 2.2.27 version???
Or did i miss something?

Ciao
Klaus

-- 
Mit freundlichen Grüssen / best regards

Klaus Strebel, Dipl.-Inform. (FH), mailto:klaus.strebel@gmx.net

/"\
\ /     ASCII RIBBON CAMPAIGN
 X        AGAINST HTML MAIL
/ \
