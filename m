Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 506B329E19
	for <xfs@oss.sgi.com>; Tue,  6 May 2014 10:22:40 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 3DE44304051
	for <xfs@oss.sgi.com>; Tue,  6 May 2014 08:22:37 -0700 (PDT)
Received: from belhaven.mcs.st-and.ac.uk (belhaven.mcs.st-and.ac.uk
	[138.251.201.57]) by cuda.sgi.com with ESMTP id
	ABiUfPBKFwYdwJho for <xfs@oss.sgi.com>;
	Tue, 06 May 2014 08:22:32 -0700 (PDT)
Date: Tue, 6 May 2014 16:22:29 +0100 (BST)
From: Steve Brooks <steveb@mcs.st-and.ac.uk>
Subject: Re: XFS tune to adaptec ASR71605
In-Reply-To: <20140506165933.65fc95e9@harpe.intellique.com>
Message-ID: <alpine.LRH.2.02.1405061603370.24742@becks.mcs.st-and.ac.uk>
References: <alpine.LRH.2.02.1405061104580.24742@becks.mcs.st-and.ac.uk>
	<20140506130008.13a1a7ee@harpe.intellique.com>
	<alpine.LRH.2.02.1405061408480.24742@becks.mcs.st-and.ac.uk>
	<20140506155149.5cf056b5@harpe.intellique.com>
	<alpine.LRH.2.02.1405061520020.24742@becks.mcs.st-and.ac.uk>
	<20140506165933.65fc95e9@harpe.intellique.com>
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

On Tue, 6 May 2014, Emmanuel Florac wrote:

Hi,

> You MUST test with a dataset bigger than RAM, else you're mostly testing
> your RAM speed :) If you've got 64 GB, by default bonnie will test with
> 128 GB of data. The small size probably explains the very fast seek
> speed... You're seeking in the RAM cache :)

Yes that makes sense, reading the man page is should auto pick up the 
amount of RAM and adjust appropriately. Still running at the moment.

I did pipe your results into "bon_csv2html" and used firefox to inspect 
the results, a neat tool :-)..

> Modern RAIDs need write cache or perform abysmally. Do yourself a
> service and buy a ZMM. Without write cache it'll be so slow it will be
> nearly unusable, really. Did you see the numbers? your RAID is more
> than 12x slower than mine... actually slower than a single disk! You'll
> simply fail at filling it up at these speeds.

Ok so maybe the abysmal write speeds are a symptom of the disabled cache, 
I hope so, once the current " bonnie++ -f -d ./ -n 50" finishes I will 
enable the write cache on the controller and repeat the benchmark, 
fingers crossed.

> Yep. You can tweak the settings and try various configurations.
> However these work fine for me in most cases (particularly the noop
> scheduler). Of course replace sda with the RAID array device or you may
> end up tuning your boot drive instead :)

Yes I noticed that too :-) .. the controllers here also  post on 
"/dev/sda" so would have been luck anyways..

Write just checked and the bonnie++ benchmark finished, and the results 
below.. So without cache yours are eight times faster at writes :-/  ..
My reads seem ok though :-) .. Ok will try with write cache on..




-sh-4.1$ bonnie++ -f -d ./ -n 50
Writing intelligently...done
Rewriting...
Message from syslogd@sraid2v at May  6 15:50:30 ...
  kernel:do_IRQ: 0.135 No irq handler for vector (irq -1)
done
Reading intelligently...done
start 'em...done...done...done...done...done...
Create files in sequential order...done.
Stat files in sequential order...done.
Delete files in sequential order...done.
Create files in random order...done.
Stat files in random order...done.
Delete files in random order...done.
Version  1.96  ------Sequential Output------ --Sequential Input- --Random-
Concurrency  1 -Per Chr- --Block-- -Rewrite- -Per Chr- --Block-- --Seeks--
Machine   Size K/sec %CP K/sec %CP K/sec %CP K/sec %CP K/sec %CP  /sec %CP
sraid2v   126G           112961   7 56056   4           1843032  80 491.8  33
Latency                    460ms     566ms             50148us   42171us
Version  1.96  ------Sequential Create------ --------Random Create--------
sraid2v        -Create-- --Read--- -Delete-- -Create-- --Read--- -Delete--
          files  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP
             50 14833  25 +++++ +++ 30047  47 27391  49 +++++ +++ 44988  76
Latency        11256us      70us     519ms   21504us      56us      72us
1.96,1.96,sraid2v,1,1399384651,126G,,,,112961,7,56056,4,,,1843032,80,491.8,33,50,,,,,14833,25,+++++,+++,30047,47,27391,49,+++++,+++,44988,76,,460ms,566ms,,50148us,42171us,11256us,70us,519ms,21504us,56us,72us



Many Thanks!

Steve

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
