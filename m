Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id A70387F4C
	for <xfs@oss.sgi.com>; Wed, 13 Mar 2013 19:03:19 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 7CD07304075
	for <xfs@oss.sgi.com>; Wed, 13 Mar 2013 17:03:16 -0700 (PDT)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id zGxxicMIEMWI8K7b
	for <xfs@oss.sgi.com>; Wed, 13 Mar 2013 17:03:15 -0700 (PDT)
Message-ID: <514113C6.9090602@hardwarefreak.com>
Date: Wed, 13 Mar 2013 19:03:18 -0500
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: xfs_fsr, sunit, and swidth
References: <5140C147.7070205@binghamton.edu>
In-Reply-To: <5140C147.7070205@binghamton.edu>
Reply-To: stan@hardwarefreak.com
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Hall <kdhall@binghamton.edu>
Cc: xfs@oss.sgi.com

On 3/13/2013 1:11 PM, Dave Hall wrote:

> Does xfs_fsr react in any way to the sunit and swidth attributes of the
> file system?  

No, manually remounting with new stripe alignment and then running
xfs_fsr is not going to magically reorganize your filesystem.

> In other words, with an XFS filesytem set up directly on a
> hardware RAID, it is recommended that the mount command be changed to
> specify sunit and swidth values that reflect the new geometry of the
> RAID.  

This recommendation (as well as most things storage related) is workload
dependent.  A common misconception many people have is that XFS simply
needs to be aligned to the RAID stripe.  In reality, it's more critical
that XFS write out be aligned to the application's write pattern, and
thus, the hardware RAID stripe needs to be as well.  Another common
misconception is that simply aligning XFS to the RAID stripe will
automagically yield fully filled hardware stripes.  This is entirely
dependent on matching the hardware RAID stripe to the applications write
pattern.

> In my case, these values were not specified on the mkfs.xfs of a
> rather large file system running on a RAID 6 array.  I am wondering
> adding sunit and swidth parameters to the fstab will cause xfs_fsr to do
> anything different than it is already doing.  

No, see above.  And read this carefully:  Aligning XFS affects write out
only during allocation.  It does not affect xfs_fsr.  Nor does it affect
non allocation workloads, i.e. database inserts, writing new mail to
mbox files, etc.

> Most importantly, will it
> improve performace in any way?

You provided insufficient information for us to help you optimize
performance.  For us to even take a stab at answering this we need to
know at least:

1.  application/workload write pattern(s)  Is it allocation heavy?
        a.  small random IO
        b.  large streaming
        c.  If mixed, what is the ratio

2.  current hardware RAID parameters
        a.  strip/chunk size
        b.  # of effective spindles (RAID6 minus 2)

3.  Current percentage of filesystem bytes and inodes used
        a.  ~$ df /dev/[mount_point]
        b.  ~$ df -i /dev/[mount_point]

FWIW, parity RAID is abysmal with random writes, and especially so if
the hardware stripe width is larger than the workload's write IOs.
Thus, optimizing performance with hardware RAID and filesystems must be
done during the design phase of the storage.  For instance if you have a
RAID6 chunk/strip size of 512K and 8 spindles that's a 4MB stripe width.
 If your application is doing random allocation write out in 256K
chunks, you simply can't optimize performance without blowing away the
array and recreating.  For this example you'd need a chunk/strip of 32K
with 8 effective spindles which equals 256K.

Now, there is a possible silver lining here.  If your workload is doing
mostly large streaming writes, allocation or not, that are many
multiples of your current hardware RAID stripe, it doesn't matter if
your XFS is doing default 4K writes or if it has been aligned to the
RAID stripe.  In this case the controller's BBWC is typically going to
take the successive XFS 4K IOs and fill hardware stripes automatically.

So again, as always, the answer depends on your workload.

-- 
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
