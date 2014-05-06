Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id B2C907FB2
	for <xfs@oss.sgi.com>; Tue,  6 May 2014 09:40:42 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 8E578304043
	for <xfs@oss.sgi.com>; Tue,  6 May 2014 07:40:42 -0700 (PDT)
Received: from belhaven.mcs.st-and.ac.uk (belhaven.mcs.st-and.ac.uk
	[138.251.201.57]) by cuda.sgi.com with ESMTP id
	Ae3dsqjYV1RMGNdK for <xfs@oss.sgi.com>;
	Tue, 06 May 2014 07:40:40 -0700 (PDT)
Date: Tue, 6 May 2014 15:40:37 +0100 (BST)
From: Steve Brooks <steveb@mcs.st-and.ac.uk>
Subject: Re: XFS tune to adaptec ASR71605
In-Reply-To: <20140506155149.5cf056b5@harpe.intellique.com>
Message-ID: <alpine.LRH.2.02.1405061520020.24742@becks.mcs.st-and.ac.uk>
References: <alpine.LRH.2.02.1405061104580.24742@becks.mcs.st-and.ac.uk>
	<20140506130008.13a1a7ee@harpe.intellique.com>
	<alpine.LRH.2.02.1405061408480.24742@becks.mcs.st-and.ac.uk>
	<20140506155149.5cf056b5@harpe.intellique.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Emmanuel Florac <eflorac@intellique.com>
Cc: xfs@oss.sgi.com



> Yup, they're... weird :) Write speed is abysmal, but random seeks very
> high. Please try my settings so that we can compare the numbers more
> directly:
>
> bonnie++ -f -d ./ -n 50
>
> If you translate the output from my test file with bon_csv2
>
> Did you turn off write cache? did you tune the IO scheduler, read
> ahead, and queue length? Here are the settings I'm generally using
> with this type of controllers (for better sequential IO):
>
> echo none > /sys/block/sda/queue/scheduler
> echo 1024 > /sys/block/sda/queue/nr_requests
> echo 65536 > /sys/block/sda/queue/read_ahead_kb
>
> You can check the cache status in the output from
>
> arcconf getconfig 1
>
> If you didn't install arcconf, you definitely should :) If you turned
> off the write cache, be aware that this is not the expected mode of
> operation for modern RAID controllers... Go buy a ZMM if necessary.


Hi,

Yes the write speed is very poor.. I am running "bonnie++" again with your 
params but no sure how long it will take.

>  bonnie++ -f -d ./ -n 50

Will thisno be different for our two machines as it seems to generate 
other params depending on the size of the RAM. All ours have 64G RAM.


I disabled write cache on the controller as there is no ZMM flash backup 
module and it seems to be advised that way. I could enable it and try 
another test to see if that is a contribution to the poor write 
performance. I do have "arcconf" on all our adaptec raid machines.

I have not tuned the IO scheduler, read ahead, and queue length?  I guess 
I can try this.

> echo none > /sys/block/sda/queue/scheduler
> echo 1024 > /sys/block/sda/queue/nr_requests
> echo 65536 > /sys/block/sda/queue/read_ahead_kb

Will this need to be done after every reboot? I guess it could go in 
"/etc/rc.local" ?


Thanks, Steve

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
