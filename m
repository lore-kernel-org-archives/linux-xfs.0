Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p5MFW4Z8100624 for <xfs@oss.sgi.com>; Wed, 22 Jun 2011 10:32:05 -0500
Received: from ns2.tower-research.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 801931EDFD53
	for <xfs@oss.sgi.com>; Wed, 22 Jun 2011 08:32:02 -0700 (PDT)
Received: from ns2.tower-research.com (ns2.tower-research.com [64.245.141.6])
	by cuda.sgi.com with ESMTP id byxv85nwKGDHpxVb for
	<xfs@oss.sgi.com>; Wed, 22 Jun 2011 08:32:02 -0700 (PDT)
Received: from lithium-b.tower-research.com (lithium-b.tower-research.com
	[10.1.1.13])
	by ns2.tower-research.com (8.13.8/8.13.8) with ESMTP id p5MFW2kv007221
	for <xfs@oss.sgi.com>; Wed, 22 Jun 2011 11:32:02 -0400
Received: from ionlinux.tower-research.com (ionlinux.tower-research.com
	[10.0.20.21])
	by lithium-b.tower-research.com (8.13.8/8.13.8) with ESMTP id
	p5MFW1vE024019
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Wed, 22 Jun 2011 11:32:01 -0400
Received: from ionlinux.tower-research.com (localhost.localdomain [127.0.0.1])
	by ionlinux.tower-research.com (8.13.1/8.13.1) with ESMTP id
	p5MFW1Dw027251 for <xfs@oss.sgi.com>; Wed, 22 Jun 2011 11:32:01 -0400
Received: from localhost (ion@localhost)
	by ionlinux.tower-research.com (8.13.1/8.13.1/Submit) with ESMTP id
	p5MFW1C2027245 for <xfs@oss.sgi.com>; Wed, 22 Jun 2011 11:32:01 -0400
Date: Wed, 22 Jun 2011 11:32:01 -0400 (EDT)
From: Ion Badulescu <ib-xfs@badula.org>
Subject: Re: xfs_repair never finishes on lvm partition
Message-ID: <alpine.LRH.2.00.1106221115510.16108@ionlinux.tower-research.com>
MIME-Version: 1.0
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Hello,

Sorry for highjacking this old thread from last year. I actually ran into 
the same situation as the original poster, using xfsprogs-3.1.5 on kernel 
2.6.38.7. Using xfs_repair -P fixed the issue, and I also managed to get a 
metadump before repairing it so you guys can take a look and maybe fix the 
prefetch mode.

The strace of the xfs_repair, for what it's worth, seems to show a 
complete deadlock with all threads waiting on futexes:

# strace -f -F -p 8315
Process 8374 attached with 6 threads - interrupt to quit
[pid  8374] futex(0x7f2336d20a84, FUTEX_WAIT, 4, NULL <unfinished ...>
[pid  8373] futex(0x7f2336d20a84, FUTEX_WAIT, 3, NULL) = -1 EAGAIN (Resource temporarily unavailable)
[pid  8372] futex(0x7f2336d20a84, FUTEX_WAIT, 2, NULL <unfinished ...>
[pid  8373] futex(0x7f2336d20a84, FUTEX_WAIT, 4, NULL <unfinished ...>
[pid  8372] <... futex resumed> )       = -1 EAGAIN (Resource temporarily unavailable)
[pid  8372] futex(0x7f2336d20a84, FUTEX_WAIT, 4, NULL <unfinished ...>
[pid  8371] futex(0x7f2336d20a84, FUTEX_WAIT, 1, NULL) = -1 EAGAIN (Resource temporarily unavailable)
[pid  8370] futex(0x7f2336d20b08, FUTEX_WAIT, 0, NULL <unfinished ...>
[pid  8371] futex(0x7f2336d20a84, FUTEX_WAIT, 4, NULL <unfinished ...>
[pid  8315] futex(0x7f2336d1f958, FUTEX_WAIT, 2, NULL^C <unfinished ...>
Process 8315 detached
Process 8370 detached
Process 8371 detached
Process 8372 detached
Process 8373 detached
Process 8374 detached

The metadump is 4.2GB, off of a 2.2TB filesystem. If there are interested 
parties, I can arrange to put online somewhere for an http download.

Thanks,
-Ion

-- 
   It is better to keep your mouth shut and be thought a fool,
             than to open it and remove all doubt.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
