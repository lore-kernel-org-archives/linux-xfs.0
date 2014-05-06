Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 509358004
	for <xfs@oss.sgi.com>; Tue,  6 May 2014 08:14:49 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 322C3304043
	for <xfs@oss.sgi.com>; Tue,  6 May 2014 06:14:46 -0700 (PDT)
Received: from belhaven.mcs.st-and.ac.uk (belhaven.mcs.st-and.ac.uk
	[138.251.201.57]) by cuda.sgi.com with ESMTP id
	wE8xWaQCpGt19xYb for <xfs@oss.sgi.com>;
	Tue, 06 May 2014 06:14:41 -0700 (PDT)
Date: Tue, 6 May 2014 14:14:35 +0100 (BST)
From: Steve Brooks <steveb@mcs.st-and.ac.uk>
Subject: Re: XFS tune to adaptec ASR71605
In-Reply-To: <20140506130008.13a1a7ee@harpe.intellique.com>
Message-ID: <alpine.LRH.2.02.1405061408480.24742@becks.mcs.st-and.ac.uk>
References: <alpine.LRH.2.02.1405061104580.24742@becks.mcs.st-and.ac.uk>
	<20140506130008.13a1a7ee@harpe.intellique.com>
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


>> My question is are the "mkfs.xfs" and the mount options I used
>> sensible? The RAID is to be used to store data from "numerical
>> simulations" that were run on a high performance cluster and is not
>> mission critical in the sense that it can be regenerated if lost. Of
>> course that would take the user/cluster some time.
>>
>
> Looks fine to me. In my experience, using non default mkfs.xfs settings
> makes very little to no difference at all, anyway. In case you're
> interested, here are some benchmarks I've made on a similar setup with
> bonnie++ (Raid controller 71604, 16x 3 To HGST, RAID-6 + spare (13 data
> drives)).
>
> 1.96,1.96,storiq,1,1386247609,32160M,,,,886148,94,511728,76,,,1364991,99,699.9,36,50,,,,,32874,93,
> +++++,+++,37064,95,32901,96,+++++,+++,33100,93,,22110us,348ms,,62214us,141ms,11973us,111us,141us,131us,10us,134us
> 1.96,1.96,storiq,1,1386247609,32160M,,,,989408,95,568600,82,,,1623220,95,869.3,17,50,,,,,34624,96,
> +++++,+++,39390,94,34764,94,+++++,+++,37472,96,,22037us,213ms,,253ms,232ms,324us,109us,140us,319us,7us,108us
> 1.96,1.96,storiq,1,1386247609,32160M,,,,1023291,97,580413,81,,,1634417,98,725.4,35,50,,,,,34913,96,
> +++++,+++,41099,99,34578,97,+++++,+++,33708,94,,186us,216ms,,54367us,63127us,1016us,104us,5508us,1029us,7us,138us
> 1.96,1.96,storiq,1,1386247609,32160M,,,,942138,97,578247,81,,,1643345,96,909.4,19,50,,,,,33042,96,
> +++++,+++,36391,95,33893,95,+++++,+++,34003,93,,1813us,222ms,,83887us,69003us,1032us,108us,144us,133us,7us,133us
> 1.96,1.96,storiq,1,1386247609,32160M,,,,939598,97,580680,82,,,1611637,97,728.1,34,50,,,,,34819,96,
> +++++,+++,39870,96,34614,97,+++++,+++,37632,96,,2053us,210ms,,71363us,84645us,990us,108us,139us,1030us,6us,1042us
> 1.96,1.96,storiq,1,1386247609,32160M,,,,972033,98,576180,81,,,1656062,98,722.0,35,50,,,,,34923,97,
> +++++,+++,39788,96,33449,95,+++++,+++,32783,95,,3608us,279ms,,82386us,46777us,1026us,105us,137us,1059us,17us,142us
> 1.96,1.96,storiq,1,1386247609,32160M,,,,937764,98,578995,83,,,1496290,96,731.3,36,50,,,,,34852,97,
> +++++,+++,39990,96,34625,97,+++++,+++,35387,96,,185us,206ms,,52160us,41925us,344us,106us,136us,993us,5us,128us
> 1.96,1.96,storiq,1,1386247609,32160M,,,,1037074,97,580587,81,,,1681379,98,719.0,36,50,,,,,34673,96,
> +++++,+++,39961,96,34799,97,+++++,+++,37775,96,,175us,252ms,,29845us,78347us,1035us,113us,137us,1011us,7us,3389us


Thanks for the reply Emmanuel, I installed and rua bonnie++ although I 
will need to research the results


> bonnie++ -d ./ -s 8192 -r 4096 -u root


Version  1.96   ------Sequential Output------ --Sequential Input- --Random-
Concurrency     -Per Chr- --Block-- -Rewrite- -Per Chr- --Block-- --Seeks--
Machine    Size K/sec %CP K/sec %CP K/sec %CP K/sec %CP K/sec %CP  /sec %CP
sraid2v      8G  1845  94 76018   4 89110   4  4275 154 3908715  99  4952  93
Latency          8537us     164us     170us    2770us      45us    5867us
Version  1.96   ------Sequential Create------ --------Random Create--------
sraid2v         -Create-- --Read--- -Delete-- -Create-- --Read--- -Delete--
           files  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP
              16 13100  21 +++++ +++ 24231  37 13289  22 +++++ +++ 28532  44
Latency         23062us      60us     117ms   25013us      29us      61us

Steve

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
