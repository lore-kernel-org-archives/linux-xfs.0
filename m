Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 30 Dec 2007 15:04:33 -0800 (PST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id lBUN4OF4013831
	for <xfs@oss.sgi.com>; Sun, 30 Dec 2007 15:04:25 -0800
Received: from lucidpixels.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9F883BD24D0
	for <xfs@oss.sgi.com>; Sun, 30 Dec 2007 15:04:34 -0800 (PST)
Received: from lucidpixels.com (lucidpixels.com [75.144.35.66]) by cuda.sgi.com with ESMTP id 0TYnHHVlXxaSOzDu for <xfs@oss.sgi.com>; Sun, 30 Dec 2007 15:04:34 -0800 (PST)
Date: Sun, 30 Dec 2007 18:04:32 -0500 (EST)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: New XFS benchmarks using David Chinner's recommendations for XFS-based
 optimizations.
Message-ID: <Pine.LNX.4.64.0712301752550.29138@p34.internal.lan>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com
Cc: linux-raid@vger.kernel.org, Alan Piszcz <ap@solarrain.com>

Dave's original e-mail:

> # mkfs.xfs -f -l lazy-count=1,version=2,size=128m -i attr=2 -d agcount=4 <dev>
> # mount -o logbsize=256k <dev> <mtpt>

> And if you don't care about filsystem corruption on power loss:

> # mount -o logbsize=256k,nobarrier <dev> <mtpt>

> Those mkfs values (except for log size) will be hte defaults in the next
> release of xfsprogs.

> Cheers,

> Dave.
> --
> Dave Chinner
> Principal Engineer
> SGI Australian Software Group

---------

I used his mkfs.xfs options verbatim but I use my own mount options:
noatime,nodiratime,logbufs=8,logbsize=26214

Here are the results, the results of 3 bonnie++ averaged together for each 
test:
http://home.comcast.net/~jpiszcz/xfs1/result.html

Thanks Dave, this looks nice--the more optimizations the better!

-----------

I also find it rather pecuilar that in some of my (other) benchmarks my 
RAID 5 is just as fast as RAID 0 for extracting large files (uncompressed) 
files:

RAID 5 (1024k CHUNK)
26.95user 6.72system 0:37.89elapsed 88%CPU (0avgtext+0avgdata 
0maxresident)k0inputs+0outputs (6major+526minor)pagefaults 0swaps

Compare with RAID 0 for the same operation:

(as with RAID5, it appears 256k-1024k..2048k possibly) is the sweet spot.

Why does mdadm still use 64k for the default chunk size?

And another quick question, would there be any benefit to use (if it were 
possible) a block size of > 4096 bytes with XFS (I assume only 
IA64/similar arch can support it), e.g. x86_64 cannot because the 
page_size is 4096.

[ 8265.407137] XFS: only pagesize (4096) or less will currently work.

The speeds:

extract speed with 4 chunk:
27.30user 10.51system 0:55.87elapsed 67%CPU (0avgtext+0avgdata 0maxresident)k
0inputs+0outputs (6major+526minor)pagefaults 0swaps
27.39user 10.38system 0:56.98elapsed 66%CPU (0avgtext+0avgdata 0maxresident)k
0inputs+0outputs (6major+528minor)pagefaults 0swaps
27.31user 10.56system 0:57.70elapsed 65%CPU (0avgtext+0avgdata 0maxresident)k
0inputs+0outputs (6major+528minor)pagefaults 0swaps
extract speed with 8 chunk:
27.09user 9.27system 0:54.60elapsed 66%CPU (0avgtext+0avgdata 0maxresident)k
0inputs+0outputs (6major+525minor)pagefaults 0swaps
27.23user 8.91system 0:54.38elapsed 66%CPU (0avgtext+0avgdata 0maxresident)k
0inputs+0outputs (6major+527minor)pagefaults 0swaps
27.19user 8.98system 0:54.68elapsed 66%CPU (0avgtext+0avgdata 0maxresident)k
0inputs+0outputs (6major+526minor)pagefaults 0swaps
extract speed with 16 chunk:
27.12user 7.24system 0:51.12elapsed 67%CPU (0avgtext+0avgdata 0maxresident)k
0inputs+0outputs (6major+526minor)pagefaults 0swaps
27.13user 7.12system 0:50.58elapsed 67%CPU (0avgtext+0avgdata 0maxresident)k
0inputs+0outputs (6major+528minor)pagefaults 0swaps
27.11user 7.18system 0:50.56elapsed 67%CPU (0avgtext+0avgdata 0maxresident)k
0inputs+0outputs (6major+527minor)pagefaults 0swaps
extract speed with 32 chunk:
27.15user 6.52system 0:48.06elapsed 70%CPU (0avgtext+0avgdata 0maxresident)k
0inputs+0outputs (6major+527minor)pagefaults 0swaps
27.24user 6.38system 0:49.10elapsed 68%CPU (0avgtext+0avgdata 0maxresident)k
0inputs+0outputs (6major+528minor)pagefaults 0swaps
27.11user 6.46system 0:47.56elapsed 70%CPU (0avgtext+0avgdata 0maxresident)k
0inputs+0outputs (6major+528minor)pagefaults 0swaps
extract speed with 64 chunk:
27.15user 5.94system 0:45.13elapsed 73%CPU (0avgtext+0avgdata 0maxresident)k
0inputs+0outputs (6major+525minor)pagefaults 0swaps
27.17user 5.94system 0:44.82elapsed 73%CPU (0avgtext+0avgdata 0maxresident)k
0inputs+0outputs (6major+527minor)pagefaults 0swaps
27.02user 6.12system 0:44.61elapsed 74%CPU (0avgtext+0avgdata 0maxresident)k
0inputs+0outputs (6major+525minor)pagefaults 0swaps
extract speed with 128 chunk:
26.98user 5.78system 0:40.48elapsed 80%CPU (0avgtext+0avgdata 0maxresident)k
0inputs+0outputs (6major+525minor)pagefaults 0swaps
27.05user 5.73system 0:40.30elapsed 81%CPU (0avgtext+0avgdata 0maxresident)k
0inputs+0outputs (6major+528minor)pagefaults 0swaps
27.11user 5.68system 0:40.59elapsed 80%CPU (0avgtext+0avgdata 0maxresident)k
0inputs+0outputs (6major+526minor)pagefaults 0swaps
extract speed with 256 chunk:
27.10user 5.60system 0:36.47elapsed 89%CPU (0avgtext+0avgdata 0maxresident)k
0inputs+0outputs (6major+525minor)pagefaults 0swaps
27.03user 5.67system 0:36.18elapsed 90%CPU (0avgtext+0avgdata 0maxresident)k
0inputs+0outputs (6major+528minor)pagefaults 0swaps
27.17user 5.50system 0:37.38elapsed 87%CPU (0avgtext+0avgdata 0maxresident)k
0inputs+0outputs (6major+526minor)pagefaults 0swaps
extract speed with 512 chunk:
27.06user 5.54system 0:36.58elapsed 89%CPU (0avgtext+0avgdata 0maxresident)k
0inputs+0outputs (6major+524minor)pagefaults 0swaps
27.03user 5.59system 0:36.31elapsed 89%CPU (0avgtext+0avgdata 0maxresident)k
0inputs+0outputs (6major+525minor)pagefaults 0swaps
27.06user 5.58system 0:36.42elapsed 89%CPU (0avgtext+0avgdata 0maxresident)k
0inputs+0outputs (6major+528minor)pagefaults 0swaps
extract speed with 1024 chunk:
26.92user 5.69system 0:36.51elapsed 89%CPU (0avgtext+0avgdata 0maxresident)k
0inputs+0outputs (6major+525minor)pagefaults 0swaps
27.18user 5.43system 0:36.39elapsed 89%CPU (0avgtext+0avgdata 0maxresident)k
0inputs+0outputs (6major+528minor)pagefaults 0swaps
27.04user 5.60system 0:36.27elapsed 90%CPU (0avgtext+0avgdata 0maxresident)k
0inputs+0outputs (6major+526minor)pagefaults 0swaps
extract speed with 2048 chunk:
26.97user 5.63system 0:36.99elapsed 88%CPU (0avgtext+0avgdata 0maxresident)k
0inputs+0outputs (6major+525minor)pagefaults 0swaps
26.98user 5.62system 0:36.90elapsed 88%CPU (0avgtext+0avgdata 0maxresident)k
0inputs+0outputs (6major+527minor)pagefaults 0swaps
27.15user 5.44system 0:37.06elapsed 87%CPU (0avgtext+0avgdata 0maxresident)k
0inputs+0outputs (6major+526minor)pagefaults 0swaps
extract speed with 4096 chunk:
27.11user 5.54system 0:38.96elapsed 83%CPU (0avgtext+0avgdata 0maxresident)k
0inputs+0outputs (6major+526minor)pagefaults 0swaps
27.09user 5.55system 0:38.85elapsed 84%CPU (0avgtext+0avgdata 0maxresident)k
0inputs+0outputs (6major+527minor)pagefaults 0swaps
27.12user 5.52system 0:38.80elapsed 84%CPU (0avgtext+0avgdata 0maxresident)k
0inputs+0outputs (6major+528minor)pagefaults 0swaps
extract speed with 8192 chunk:
27.04user 5.57system 0:43.54elapsed 74%CPU (0avgtext+0avgdata 0maxresident)k
0inputs+0outputs (6major+526minor)pagefaults 0swaps
27.15user 5.49system 0:43.52elapsed 75%CPU (0avgtext+0avgdata 0maxresident)k
0inputs+0outputs (6major+526minor)pagefaults 0swaps
27.11user 5.52system 0:43.66elapsed 74%CPU (0avgtext+0avgdata 0maxresident)k
0inputs+0outputs (6major+528minor)pagefaults 0swaps
extract speed with 16384 chunk:
27.25user 5.45system 0:52.18elapsed 62%CPU (0avgtext+0avgdata 0maxresident)k
0inputs+0outputs (6major+526minor)pagefaults 0swaps
27.18user 5.52system 0:52.54elapsed 62%CPU (0avgtext+0avgdata 0maxresident)k
0inputs+0outputs (6major+527minor)pagefaults 0swaps
27.17user 5.50system 0:51.38elapsed 63%CPU (0avgtext+0avgdata 0maxresident)k
0inputs+0outputs (6major+525minor)pagefaults 0swaps

Justin.
