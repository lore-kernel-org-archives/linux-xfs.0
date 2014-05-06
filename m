Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 3307D7F58
	for <xfs@oss.sgi.com>; Tue,  6 May 2014 11:03:14 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 2107D8F8035
	for <xfs@oss.sgi.com>; Tue,  6 May 2014 09:03:11 -0700 (PDT)
Received: from belhaven.mcs.st-and.ac.uk (belhaven.mcs.st-and.ac.uk
	[138.251.201.57]) by cuda.sgi.com with ESMTP id
	sYk4hxM99PO9Bgvw for <xfs@oss.sgi.com>;
	Tue, 06 May 2014 09:03:09 -0700 (PDT)
Date: Tue, 6 May 2014 17:03:06 +0100 (BST)
From: Steve Brooks <steveb@mcs.st-and.ac.uk>
Subject: Re: XFS tune to adaptec ASR71605 [SOLVED]
In-Reply-To: <20140506165933.65fc95e9@harpe.intellique.com>
Message-ID: <alpine.LRH.2.02.1405061652320.24742@becks.mcs.st-and.ac.uk>
References: <alpine.LRH.2.02.1405061104580.24742@becks.mcs.st-and.ac.uk>
	<20140506130008.13a1a7ee@harpe.intellique.com>
	<alpine.LRH.2.02.1405061408480.24742@becks.mcs.st-and.ac.uk>
	<20140506155149.5cf056b5@harpe.intellique.com>
	<alpine.LRH.2.02.1405061520020.24742@becks.mcs.st-and.ac.uk>
	<20140506165933.65fc95e9@harpe.intellique.com>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED;
	BOUNDARY="-74825271-1999177172-1399392186=:24742"
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Emmanuel Florac <eflorac@intellique.com>
Cc: xfs@oss.sgi.com

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---74825271-1999177172-1399392186=:24742
Content-Type: TEXT/PLAIN; charset=iso-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT

> Le Tue, 6 May 2014 15:40:37 +0100 (BST)
> Steve Brooks <steveb@mcs.st-and.ac.uk> écrivait:
>
>> Yes the write speed is very poor.. I am running "bonnie++" again with
>> your params but no sure how long it will take.
>>
>>>  bonnie++ -f -d ./ -n 50
>>
>> Will thisno be different for our two machines as it seems to generate
>> other params depending on the size of the RAM. All ours have 64G RAM.
>>
>
> You MUST test with a dataset bigger than RAM, else you're mostly testing
> your RAM speed :) If you've got 64 GB, by default bonnie will test with
> 128 GB of data. The small size probably explains the very fast seek
> speed... You're seeking in the RAM cache :)
>
>>
>> I disabled write cache on the controller as there is no ZMM flash
>> backup module and it seems to be advised that way. I could enable it
>> and try another test to see if that is a contribution to the poor
>> write performance. I do have "arcconf" on all our adaptec raid
>> machines.
>
> Modern RAIDs need write cache or perform abysmally. Do yourself a
> service and buy a ZMM. Without write cache it'll be so slow it will be
> nearly unusable, really. Did you see the numbers? your RAID is more
> than 12x slower than mine... actually slower than a single disk! You'll
> simply fail at filling it up at these speeds.
>
>> I have not tuned the IO scheduler, read ahead, and queue length?  I
>> guess I can try this.
>>
>>> echo none > /sys/block/sda/queue/scheduler
>>> echo 1024 > /sys/block/sda/queue/nr_requests
>>> echo 65536 > /sys/block/sda/queue/read_ahead_kb
>>
>> Will this need to be done after every reboot? I guess it could go in
>> "/etc/rc.local" ?
>>
>
> Yep. You can tweak the settings and try various configurations.
> However these work fine for me in most cases (particularly the noop
> scheduler). Of course replace sda with the RAID array device or you may
> end up tuning your boot drive instead :)


Thanks loads! As you stated it seems to have all been down to having write 
cache disabled. The new results from "bonnie++" show that sequential 
writes when the "write cach" is enabled have massively improved to
1642324 K/s ...


[root@sraid2v tmp]# bonnie++ -f -d ./ -n 50 -u root
Using uid:0, gid:0.
Writing intelligently...done
Rewriting...done
Reading intelligently...done
start 'em...done...done...done...done...done...
Create files in sequential order...done.
Stat files in sequential order...done.
Delete files in sequential order...done.
Create files in random order...done.
Stat files in random order...done.
Delete files in random order...done.
Version  1.96 ------Sequential Output------ --Sequential Input- --Random-
Concurrency 1 -Per Chr- --Block-- -Rewrite- -Per Chr- --Block-- --Seeks--
Machine  Size K/sec %CP K/sec %CP K/sec %CP K/sec %CP K/sec %CP  /sec %CP
sraid2v  126G           1642324  96 704219  51           2005711  81 529.8  36
Latency                 29978us     131ms             93836us   47600us
Version  1.96 ------Sequential Create------ --------Random Create--------
sraid2v       -Create-- --Read--- -Delete-- -Create-- --Read--- -Delete--
         files  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP
            50 45494  75 +++++ +++ 58252  84 51635  80 +++++ +++ 53103  81
Latency       15964us     191us      98us      80us      14us      60us
1.96,1.96,sraid2v,1,1399398521,126G,,,,1642324,96,704219,51,,,2005711,81,529.8,36,50,,,,,45494,75,+++++,+++,58252,84,51635,80,+++++,+++,53103,81,,29978us,131ms,,93836us,47600us,15964us,191us,98us,80us,14us,60us


Thanks again Emmanuel for your help!


Steve
---74825271-1999177172-1399392186=:24742
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

---74825271-1999177172-1399392186=:24742--
