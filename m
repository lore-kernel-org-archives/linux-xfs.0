Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id C7FB87F3F
	for <xfs@oss.sgi.com>; Tue, 15 Apr 2014 07:23:15 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 436A5AC006
	for <xfs@oss.sgi.com>; Tue, 15 Apr 2014 05:23:12 -0700 (PDT)
Received: from morework.geizhals.at (morework.geizhals.at [78.142.138.3]) by
	cuda.sgi.com with ESMTP id jrH5ynVoUm6flHhf (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 15 Apr 2014 05:23:10 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
	by morework.geizhals.at (Postfix) with ESMTP id 41B021248385
	for <xfs@oss.sgi.com>; Tue, 15 Apr 2014 14:23:09 +0200 (CEST)
Message-ID: <534D24AB.1050605@geizhals.at>
Date: Tue, 15 Apr 2014 14:23:07 +0200
From: Johannes Truschnigg <johannes.truschnigg@geizhals.at>
MIME-Version: 1.0
Subject: Seeking XFS tuning advice for PostgreSQL on SATA SSDs/Linux-md
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
To: xfs@oss.sgi.com

Hi list,

we're building a postgres streaming replication slave that's supposed to 
pick up work if our primary pg cluster (with an all-flash FC SAN 
appliance as its backend store) goes down. We'll be using consumer-grade 
hardware for this setup, which I detail below:

o 2x Intel Xeon E5-2630L (24 threads total)
o 512GB DDR3 ECC RDIMM
o Intel C606-based Dual 4-Port SATA/SAS HBA (PCIID 8086:1d68)
o 6x Samsung 830 SSD with 512GB each, 25% reserved for HPA
o Debian GNU/Linux 7.x "Wheezy" + backports kernel (3.13+)
o PostgreSQL 9.0

If there's anything else that is of critical interest that I forgot to 
mention, hardware- or software-wise, please let me know.

When benchmarking the individual SSDs with fio (using the libaio 
backend), the IOPS we've seen were in the 30k-35k range overall for 4K 
block sizes. The host will be on the receiving end of a pg9.0 streaming 
replication cluster setup where the master handles ~50k IOPS peak, and 
I'm thinking what'd be a good approach to design the local storage stack 
(with availability in mind) in a way that has a chance to keep up with 
our flash-based FC SAN.

After digging through linux-raid archives, I think the most sensible 
approach are two-disk pairs in RAID1 that are concatenated via either 
LVM2 or md (leaning towards the latter, since I'd expect that to have a 
tad less overhead), and xfs on top of that resulting block device. That 
should yield roughly 1.2TB of usable space (we need a minimum of 900GB 
for the DB). With this setup, it should be possible to have up to 3 CPUs 
busy with handling I/O on the block side of things, which raises the 
question what'd be a sensible value to choose for xfs' Allocation Group 
Count/agcount.

I've been trying to find information on that myself, but what I managed 
to dig up is, at times, so old that it seems rather outlandish today - 
some sources on the web (from 2003), for example, say that one AG per 
4GB of underlying diskspace makes sense, which seems excessive for a 
1200GB volume.

I've experimented with mkfs.xfs (on top of LVM only; I don't know if it 
takes into account lower block layers and seen that it supposedly 
chooses to default to an agcount of 4, which seems insufficient given 
the max. bandwidth our setup should be able to provide.

Apart from that, is there any kind of advice you can share for tuning 
xfs to run postgres (9.0 initially, but we're planning to upgrade to 9.3 
or later eventually) on in 2014, especially performance-wise?

Thanks, regards:
- Johannes

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
