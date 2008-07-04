Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 03 Jul 2008 23:40:26 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m646eM2m025979
	for <xfs@oss.sgi.com>; Thu, 3 Jul 2008 23:40:23 -0700
Received: from mailgate01.web.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 10AB52B6700
	for <xfs@oss.sgi.com>; Thu,  3 Jul 2008 23:41:25 -0700 (PDT)
Received: from mailgate01.web.de (mailgate01.web.de [217.72.192.251]) by cuda.sgi.com with ESMTP id niGYqJEbPdcJabmX for <xfs@oss.sgi.com>; Thu, 03 Jul 2008 23:41:25 -0700 (PDT)
Date: Fri, 4 Jul 2008 08:41:26 +0200
From: Jens Beyer <jens.beyer@1und1.de>
Subject: XFS perfomance degradation on growing filesystem size
Message-ID: <20080704064126.GA14847@webde.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com


Hi,

I have encountered a strange performance problem during some 
hardware evaluation tests: 

I am running a benchmark to measure especially random read/write 
I/O on an raid device and found that (under some circumstances) 
the performance of Random Read I/O is inverse proportional to the 
size of the tested XFS filesystem. 

In numbers this means that on a 100GB partition I get a throughput 
of ~25 MB/s and on the same hardware at 1TB FS size only 18 MB/s 
(and at 2+ TB like 14 MB/s) (absolute values depend on options, 
kernel version and are for random read i/o at 8k test block size).

Surprisingly this degradation does not affect random write or 
seq read/write (at least not by this factor).
Even more surprising using an ext3 filesystem I always get ~25 MB/s.

My test setups included: 
- kernel vanilla 2.6.24, 2.6.25.8, 2.6.24-ubuntu_8.04, 2.6.20, 32/64bit
- xfsprogs v2.9.8/7
- benchmarks:
  - iozone:   iozone -i 0 -i 2 -r 8k -s 1g -t 32 -+p 100
  - tiobench: tiobench.pl --size 32000 --random 100000 --block 8192 \
                          --dir /mnt --threads 32 --numruns 1
    (Bench is for 8k blocksize, 32 Threads with enough data to 
    be beyond simple ram cache).
- The hardware itself where recent HP dual/quadcores with 4GB RAM 
  with external SAS Raids (MSA60, MSA70) and 15k SAS disks (different 
  types).

I tried most options like but not limited to: agcount, logbufs, 
nobarrier, blockdev --setra, (...), but none had an significant impact. 
All benchmarks where run using deadline i/o scheduler

Does anyone has a clue on what is going on - or even can reproduce 
this? Or, is this the default behavior? Could this be an hardware 
problem ?

Thanks for any comment,
Jens
