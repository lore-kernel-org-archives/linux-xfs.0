Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 0A29C29DFB
	for <xfs@oss.sgi.com>; Fri, 23 Aug 2013 21:33:26 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id CC8738F8033
	for <xfs@oss.sgi.com>; Fri, 23 Aug 2013 19:33:22 -0700 (PDT)
Received: from Ishtar.tlinx.org (ishtar.tlinx.org [173.164.175.65]) by
	cuda.sgi.com with ESMTP id xaelUiaM8NYo1kH1 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 23 Aug 2013 19:33:19 -0700 (PDT)
Received: from [192.168.4.12] (Athenae [192.168.4.12])
	by Ishtar.tlinx.org (8.14.7/8.14.4/SuSE Linux 0.8) with ESMTP id
	r7O2XDno077115 for <xfs@oss.sgi.com>; Fri, 23 Aug 2013 19:33:15 -0700
Message-ID: <52181B69.6060707@tlinx.org>
Date: Fri, 23 Aug 2013 19:33:13 -0700
From: Linda Walsh <xfs@tlinx.org>
MIME-Version: 1.0
Subject: does having ~Ncore+1? kworkers flushing XFS to 1 disk improve
	throughput?
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs-oss <xfs@oss.sgi.com>


I just untar'ed several(8) copies of of a 3.4GB test dir into separate
test directories,

The untarring is in background, but I wait for each "tar" to return,
so I can list out the times

I untar the same image 8 times in 8 different dirs.

The initial tars go very quickly, consuming 100% cpu
as the first tars basically extract to buffer memory,
but after the 4th, times begin increasing
almost geometrically:


1...5.03sec 0.12usr 4.90sys (99.84% cpu)
2...5.17sec 0.12usr 5.03sys (99.71% cpu)
3...5.36sec 0.13usr 5.21sys (99.68% cpu)
4...5.35sec 0.15usr 5.17sys (99.66% cpu)
5...7.36sec 0.12usr 5.69sys (79.14% cpu)
6...27.81sec 0.16usr 6.76sys (24.93% cpu)
7...85.54sec 0.21usr 7.33sys (8.83% cpu)
8...101.64sec 0.25usr 7.88sys (8.00% cpu)
2nd run:
1...5.23sec 0.12usr 5.10sys (99.73% cpu)
2...5.25sec 0.15usr 5.08sys (99.71% cpu)
3...6.08sec 0.13usr 5.09sys (85.86% cpu)
4...5.31sec 0.14usr 5.15sys (99.71% cpu)
5...14.02sec 0.18usr 6.28sys (46.11% cpu)
6...23.32sec 0.17usr 6.47sys (28.50% cpu)
7...31.14sec 0.21usr 6.74sys (22.32% cpu)
8...82.36sec 0.22usr 7.23sys (9.05% cpu)


Now -- and for 3-4 minutes after this point, I see
7 kworker processes -- 6 of them on the even cpu's (2-node numa)
and 1 on an odd cpu.  The 7 consume about 12-18% cpu each
and the odd one is "matched" by a "flush-254:odd" process that
has the same cpu as the odd kworker.

I added a "time sync" after the script finished (to show,
approximately, how long disk activity continues)
222.95sec 0.00usr 0.23sys (0.10% cpu)

So what are all the kworkers doing and does having 6 of them
do things at the same time really help disk-throughput?

Seems like they would conflict w/each other, cause
disk contention, and extra fragmentation as they
do things?  If they were all writing to separate
disks, that would make sense, but do that many kworker
threads need to be finishing out disk I/O on 1 disk?

FWIW, I remove and create a skeleton dir-struct before I
untar to the dirs.
The "rm -fr" on those dirs happens in parallel with a "wait" at
the end to wait for all of them.  That takes:
1.82sec 0.07usr 12.91sys (711.34% cpu)

Creating the dirnames + empty filenames) takes:
(for ~1-2 dirs, and 5000+ filenames)

6.85sec 0.38usr 11.68sys (176.03% cpu)

So is it efficient to use that many writers on 1 disk?

Note the disks' max-write speed in writing a large
contiguous multi gig file, is about 1GB/s and is mounted
(showing mount output):

 /dev/mapper/HnS-Home on /home type xfs \
  (rw,nodiratime,relatime,swalloc,attr2,largeio,inode64,allocsize=128k,\
  logbsize=256k,sunit=128,swidth=1536,noquota)
 




_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
