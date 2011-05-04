Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p446EhmL061122 for <xfs@oss.sgi.com>; Wed, 4 May 2011 01:14:43 -0500
Received: from greer.hardwarefreak.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D7FAC42C646
	for <xfs@oss.sgi.com>; Tue,  3 May 2011 23:18:20 -0700 (PDT)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id 7052bzEBVMyzhk6L
	for <xfs@oss.sgi.com>; Tue, 03 May 2011 23:18:20 -0700 (PDT)
Received: from [192.168.100.53] (gffx.hardwarefreak.com [192.168.100.53])
	by greer.hardwarefreak.com (Postfix) with ESMTP id EAD466C073
	for <xfs@oss.sgi.com>; Wed,  4 May 2011 01:18:19 -0500 (CDT)
Message-ID: <4DC0EFA8.1000702@hardwarefreak.com>
Date: Wed, 04 May 2011 01:18:16 -0500
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: XFS/Linux Sanity check
References: <BANLkTik4YjSr7-VA+f9Sh+UxvKfFKMy=+w@mail.gmail.com>
	<20110503031856.GA9114@dastard>
In-Reply-To: <20110503031856.GA9114@dastard>
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

On 5/2/2011 10:18 PM, Dave Chinner wrote:

> Also, knowing how you spread out the disks in each RAID-6 group
> between controllers, trays, etc as that has important performance
> and failure implications.
>
> e.g. I'm guessing that you are taking 6 drives from each enclosure
> for each 18-drive raid-6 group, which would split the RAID-6 group
> across all three SAS controllers and enclosures. That means if you
> lose a SAS controller or enclosure you lose all RAID-6 groups at
> once which is effectively catastrophic from a recovery point of view.
> It also means that one slow controller slows down everything so load
> balancing is difficult.

Assuming Paul's SC847 SAS chassis have the standard EL1 backplanes, his 
bandwidth profile per chassis is:

24 x 6Gb/s drives on 4 x 6Gb/s host ports via 36 port LSI expander
21 x 6Gb/s drives on 4 x 6Gb/s host ports via 36 port LSI expander

Not balanced but not horribly bad.  I recommend using one LSI 9285-8E 
RAID card per SC847 chassis, one SFF8088 cable connected to the front 
backplane the other connected to the rear.  Create two 21 drive RAID6 
arrays, taking care than one array consists only of drives on the front 
backplane, the other array consisting only of drives on the rear 
backplane.  Configure the remaining 3 drives on the front backplane as 
cold spares.  Not perfect, but I think the best solution given the 
unbalanced nature of the chassis backplanes.

> Large stripes might look like a good idea, but when you get to this
> scale concatenation of high throughput LUNs provides better
> throughput because of less contention through the storage
> controllers and enclosures.

Now create an LVM or mdraid concatenated device of the 6 hardware RAID6 
LUNs.  Format the resulting device with mkfs.xfs defaults allowing XFS 
allocation groups to drive your parallelism and throughput instead of a 
big stripe, just as Dave recommends.  Each 9285-8E should be able to 
pump streaming reads at about 3.2 to 3.5GB/s, a little less than the 38 
RAID6 spindle streaming aggregate capability.  At this throughput level 
you're bumping against the PCIe 2.0 x8 one way bandwidth limit after 
encoding and error correction overhead.  So overall I think you're 
fairly well balanced now, overcoming the slight imbalance of the disk 
chassis configuration.

Assuming you're able to load balance interrupts and tune things 
optimally, and assuming the Intel chipset in the R810 is up to the task, 
the above recommended setup should be capable of 8-10GB/s throughput 
with a parallel workload.  Newegg carries both the 9285-8E and the cache 
battery unit, ~$1200 total.  So it'll run you about $18,000 for 15 units 
for 5 servers, about 3x what you spent on the 9200-8E cards, and worth 
every sweet penny.

-- 
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
