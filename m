Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 70D397CBE
	for <xfs@oss.sgi.com>; Sat, 24 Aug 2013 12:18:38 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 5973C8F8033
	for <xfs@oss.sgi.com>; Sat, 24 Aug 2013 10:18:38 -0700 (PDT)
Received: from Ishtar.tlinx.org (ishtar.tlinx.org [173.164.175.65]) by
	cuda.sgi.com with ESMTP id JxVWgiAaUDOYXSaA (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sat, 24 Aug 2013 10:18:33 -0700 (PDT)
Message-ID: <5218EADD.4000704@tlinx.org>
Date: Sat, 24 Aug 2013 10:18:21 -0700
From: Linda Walsh <xfs@tlinx.org>
MIME-Version: 1.0
Subject: Re: does having ~Ncore+1? kworkers flushing XFS to 1 disk improve
	throughput?
References: <52181B69.6060707@tlinx.org> <52183194.2060008@hardwarefreak.com>
In-Reply-To: <52183194.2060008@hardwarefreak.com>
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
To: stan@hardwarefreak.com
Cc: xfs-oss <xfs@oss.sgi.com>



Stan Hoeppner wrote:
> On 8/23/2013 9:33 PM, Linda Walsh wrote:
> 
>> So what are all the kworkers doing and does having 6 of them do
>> things at the same time really help disk-throughput?
>>
>> Seems like they would conflict w/each other, cause disk
>> contention, and extra fragmentation as they do things?  If they
>> were all writing to separate disks, that would make sense, but do
>> that many kworker threads need to be finishing out disk I/O on
>> 1 disk?
> 
> https://raw.github.com/torvalds/linux/master/Documentation/workqueue.txt
----

Thanks for the pointer.

I see ways to limit #workers/cpu if they were hogging too much cpu,
which isn't the problem..  My concern is that the work they are
doing is all writing info back to the same physical disk -- and that
while >1 writer can improve throughput, generally, it would be best
if the pending I/O was sorted in disk order and written out using
the elevator algorithm.  I.e. I can't imagine that it takes 6-8
processes (mostly limiting themselves to 1 NUMA node) to keep the
elevator filled?

Shouldn't there be an additional way to limit the concurrency of
kworkers assigned to a single device -- esp.  if the blocking factor
on each of them is the device?  Together, they aren't using more
than, maybe, 2 core's worth of cpu.  Rough estimates on my part show
that for this partition, being RAID based and how it is setup,
2 writers can definitely be beneficial, 3-4 often, 5-6, starts to
cause more thrashing (disk seeking trying to keep up), and 7-8...
well that just gets worse, usually.  The fact that it takes as long
or longer to write out the data than it does for the program to
execute makes me think that it isn't being done very efficiently.


Already, BTW, I changed this "test setup" script (it's a setup
script for another test) from untarring the the 8 copies in parallel
to 1 untar at a time.  It was considerably slower

I can try some of the knobs on the wq but the only knob I see is
limiting # workers / cpu -- and since I'm only seeing 1 worker/cpu,
I don't # see how that would help.  It's the /device workers that
need to be # limited.

Wasn't it the case that at some point in the past xfs had "per
device kernel-threads" to help with disk writing, before the advent
of kworkers?  In the case of writing to devices, it seems the
file-system driver controlling the number of concurrent workers
makes more sense -- and even that, either needs to have the smart to
know how many extra workers a "disk" can handle (i.e. if it is a 12
spindle RAID, it can handle alot more concurrency than a 3 - spindle
RAID-0 composed of 4 RAID-5's each.  (I haven't forgotten about your
recommendations, to go all RAID10, but have to wait on budget
allocations ;-)).


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
